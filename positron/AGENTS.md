# AGENTS.md – instructions for coding agents in this project

## Project
Workshop material for "Agentic R with ellmer". R only, tidyverse style.

## Rules
- Use the native pipe `|>` and tidyverse functions; no base-R loops for data wrangling.
- Data lives in `nycflights13`; never download other data.
- Before changing a script, run it and check it still works.
- Plots: ggplot2 with `theme_minimal()`.
- Never write API keys into files. Keys come from `~/.Renviron`.
- Keep scripts runnable top-to-bottom for live demos.
