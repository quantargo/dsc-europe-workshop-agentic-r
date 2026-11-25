# Agentic R with ellmer – DSC Europe 2026

Workshop (90 min) by Mario Annau, Quantargo.

From a single LLM call to a data-analysis agent in R – and how to work with agents in Positron.

## Agenda

| Time  | Part | File |
|-------|------|------|
| 0–10  | What is an agent? (LLM + tools + loop) | – |
| 10–25 | ellmer basics & structured output | `01_basics.R`, `02_structured.R` |
| 25–55 | Tool calling: build an "ask your data" agent | `03_agent.R` |
| 55–75 | Agents in Positron (Posit Assistant, AGENTS.md, MCP) | `positron/` |
| 75–85 | Towards production: parallel calls, costs, evals | `04_production.R` |
| 85–90 | Q&A | – |

## Setup

1. R ≥ 4.1 and (ideally) Positron
2. Run `00_setup.R` to install packages
3. Set an API key in `~/.Renviron`, e.g.

   ```
   ANTHROPIC_API_KEY=sk-ant-...
   # or OPENAI_API_KEY=sk-...
   ```

   Restart R afterwards. No key? Use a local model via Ollama:
   `chat_ollama(model = "llama3.2")` (tool calling quality varies).

## Dataset

`nycflights13` (flights, airlines, airports, planes, weather) loaded into an
in-memory DuckDB database – the agent queries it with SQL.

## Further reading

- ellmer: https://ellmer.tidyverse.org
- Posit Assistant: https://positron.posit.co/assistant
- mcptools (R ↔ MCP): https://posit-dev.github.io/mcptools/
- vitals (LLM evals): https://vitals.tidyverse.org
- ragnar (RAG in R): https://ragnar.tidyverse.org
- shinychat (chat UIs in Shiny): https://posit-dev.github.io/shinychat/
