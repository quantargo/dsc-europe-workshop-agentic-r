# 04 – Towards production -------------------------------------------------------
library(ellmer)

# 1. Scale: many prompts in parallel (or batch_chat() for cheaper async batches)
chat <- chat_anthropic()
prompts <- list(
  "Summarise in one sentence: what is an LLM agent?",
  "Summarise in one sentence: what is tool calling?",
  "Summarise in one sentence: what is MCP?"
)
answers <- parallel_chat(chat, prompts)
sapply(answers, function(x) x$last_turn()@text)

# 2. Costs: always know what you spend
token_usage()

# 3. Evals with vitals: does the agent answer correctly – reproducibly?
library(vitals)
library(tibble)

eval_data <- tibble(
  input  = c("Which airline (carrier code) had most flights in nycflights13?",
             "How many flights departed from JFK in 2013?"),
  target = c("UA", "111279")
)

# solver: plain chat here – swap in the agent from 03_agent.R
tsk <- Task$new(
  dataset = eval_data,
  solver  = generate(chat_anthropic()),
  scorer  = model_graded_qa()
)
tsk$eval()
tsk$get_samples()

# 4. Checklist before going live
# - Tools read-only by default, explicit allow-lists for writes
# - Log every tool call (audit trail), e.g. via ellmer's OpenTelemetry support
# - Limit data the model sees (PII!) and choose provider/region accordingly
# - Evals as part of CI – models change, your answers shouldn't
