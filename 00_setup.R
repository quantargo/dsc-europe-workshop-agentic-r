# 00 – Setup ------------------------------------------------------------------

install.packages(c(
  "ellmer",       # LLM interface
  "shinychat",    # chat UI (part 1)
  "clipr",        # copy generated code to clipboard (part 1)
  "nycflights13", # example data
  "dplyr", "data.table", # code-style comparison (part 1)
  "duckdb", "DBI",
  "ggplot2",
  "vitals",       # evals (part 4, optional)
  "mcptools"      # MCP server/client (Positron part, optional)
))

# Check that a key is available
keys <- c("GEMINI_API_KEY", "ANTHROPIC_API_KEY", "OPENAI_API_KEY")
nzchar(Sys.getenv(keys)) |> setNames(keys)

# Quick smoke test
library(ellmer)
chat <- chat_google_gemini()   # or chat_anthropic() / chat_openai()
chat$chat("Say hello to DSC Europe in one sentence.")
