# 01 – ellmer basics -----------------------------------------------------------
# Read: https://cran.r-project.org/web/packages/ellmer/vignettes/ellmer.html
#
# Terminology
# - Provider: the company/API serving the model (Google, Anthropic, OpenAI, Ollama, ...)
# - Model:    the concrete LLM (e.g. a Gemini, Claude or GPT model)
# - Turn:     one message in the conversation (user or assistant)
# - Token:    unit of text the model reads/writes – what you pay for
# - Prompt:   platform prompt (set by the provider's app, not visible via API)
#             > system prompt (set by you, defines behaviour)
#             > user prompt (the actual question)
#   Example platform prompts: https://platform.claude.com/docs/en/release-notes/system-prompts/overview
#
# Setup: put your key into ~/.Renviron (usethis::edit_r_environ()), restart R
#   GEMINI_API_KEY=...        (free tier available: https://aistudio.google.com/apikey)
#   ANTHROPIC_API_KEY=...     / OPENAI_API_KEY=...

library(ellmer)

# 1. First steps ---------------------------------------------------------------
bare <- chat_google_gemini()
bare$chat("Who are the creators of the R programming language?", echo = "output")
bare$get_turns()

# 2. LLM APIs are stateless ----------------------------------------------------
# The chat object *looks* stateful, but every call resends the whole history.
bare$chat("And where is the name of the language coming from?")
bare$get_turns()

token_usage()                  # input tokens grow with every turn
ellmer:::last_request_json()   # internal helper: see the full payload sent
# -> long conversations get slower and more expensive; start fresh chats often.

# 3. Chat UI in one line -------------------------------------------------------
shinychat::chat_app(bare)
# or in the console: live_console(bare)

# 4. System prompts shape behaviour: code generation ---------------------------
# Same task, three system prompts -> three very different solutions.
task <- "Using the nycflights13 data: for summer flights (June to August) that
were not cancelled, compute the average arrival delay per airline. Keep only
airlines with at least 1000 such flights, add the full airline name from the
airlines table and return the top 5, worst first."

style_general <- "Return only valid concise R code without markdown fences."

style_base <- "Use base R only (no packages except nycflights13)."
codr <- chat_google_gemini( paste(style_general, style_base) )
codr$chat(task)

### Output
library(nycflights13)

summer <- flights[flights$month %in% 6:8 & !is.na(flights$arr_delay), ]
counts <- table(summer$carrier)
summer <- summer[summer$carrier %in% names(counts[counts >= 1000]), ]

avg_delay <- aggregate(arr_delay ~ carrier, data = summer, mean)
res <- merge(avg_delay, airlines, by = "carrier")
res <- res[order(-res$arr_delay), ]
head(res, 5)
###

style_dpylr <- "Use dplyr verbs and the native pipe |>."
codr <- chat_google_gemini( paste(style_general, style_dpylr) )
codr$chat(task)

### Output
library(nycflights13)
library(dplyr)

flights |>
  filter(month %in% 6:8, !is.na(arr_delay)) |>
  group_by(carrier) |>
  summarise(avg_arr_delay = mean(arr_delay), n = n()) |>
  filter(n >= 1000) |>
  left_join(airlines, by = "carrier") |>
  arrange(desc(avg_arr_delay)) |>
  slice_head(n = 5)
###

style_data_table <- "Use data.table syntax DT[i, j, by]."
codr <- chat_google_gemini( paste(style_general, style_data_table) )
codr$chat(task)

### Output
library(data.table)
library(nycflights13)

as.data.table(airlines)[
  as.data.table(flights)[month %in% 6:8 & !is.na(arr_delay), 
    .(mean_arr_delay = mean(arr_delay), n = .N), by = carrier][n >= 1000], 
  on = "carrier"
][order(-mean_arr_delay), .(carrier, name, mean_arr_delay)][1:5]
###



# Do all three give the same top 5? (Watch how each handles NA delays.)
# Discussion: which would you put into a package? Into a Shiny app?

# 5. Switching providers is one line -------------------------------------------
# chat <- chat_anthropic()
# chat <- chat_openai()
# chat <- chat_ollama(model = "llama3.2")   # local, no key needed


