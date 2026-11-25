# 00 – Setup ------------------------------------------------------------------

install.packages(c(
  "ellmer",       # LLM interface
  "nycflights13", # example data
  "duckdb", "DBI",
  "ggplot2",
  "vitals",       # evals (part 4, optional)
  "mcptools"      # MCP server/client (Positron part, optional)
))

# Check that a key is available
nzchar(Sys.getenv("ANTHROPIC_API_KEY")) || nzchar(Sys.getenv("OPENAI_API_KEY"))

# Quick smoke test
library(ellmer)
chat <- chat_anthropic()   # or chat_openai()
chat$chat("Say hello to DSC Europe in one sentence.")
