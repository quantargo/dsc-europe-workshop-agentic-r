# Positron demo (20 min) – speaker script

## 1. Posit Assistant in Positron (8 min)
- Open the chat pane, choose provider/model.
- Show that it sees the session: loaded objects, data frames, plots.
- Prompt (same question as in 03_agent.R, for the comparison):
  > Load nycflights13 and find out which airline had the highest average
  > departure delay. Make a bar chart of the top 5 with full names.
- Point out: it writes and runs code in the console – vs. our agent that
  only had the four tools we gave it.

## 2. Control & safety (5 min)
- Permission modes: Normal / Restricted / YOLO – what each allows.
- Plan Mode:
  > Plan how to turn 03_agent.R into a small Shiny app. Don't write code yet.
- Show AGENTS.md (this folder) and the workspace-trust prompt.

## 3. Bring your R session to any agent with MCP (5 min)
- In R:
  ```r
  mcptools::mcp_session()
  ```
- Agent config (e.g. Claude Desktop / Claude Code):
  ```json
  { "mcpServers": { "r-mcptools": {
      "command": "Rscript", "args": ["-e", "mcptools::mcp_server()"] } } }
  ```
- Ask the external agent about objects in the live R session.
- Bonus: `mcptools::mcp_tools()` makes MCP servers usable as ellmer tools.

## 4. Take-away (2 min)
- Build your own agent (ellmer) when you need control, guardrails, deployment.
- Use an IDE agent (Posit Assistant) for your own day-to-day analysis work.

## Backup
- Record this demo beforehand – conference Wi-Fi is not your friend.
