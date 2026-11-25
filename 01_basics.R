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
codr <- chat_google_gemini("Return only valid concise R code without markdown fences.")
code <- codr$chat("Write a function to compute the rolling mean of a numeric vector.")
clipr::write_clip(code)

# Same task, different styles – compare readability, dependencies, speed
codr$chat("Now the same in tidyverse style (slider/dplyr).")
codr$chat("Now the same using data.table::frollmean().")
codr$chat("Back to base R, but dependency-free and vectorised.")
# Discussion: which one would you put into a package? Into a Shiny app?

# 5. Switching providers is one line -------------------------------------------
# chat <- chat_anthropic()
# chat <- chat_openai()
# chat <- chat_ollama(model = "llama3.2")   # local, no key needed
