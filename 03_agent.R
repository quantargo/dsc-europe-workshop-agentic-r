# 03 – Tool calling: an "ask your data" agent ---------------------------------
library(ellmer)
library(DBI)
library(ggplot2)

# Data: nycflights13 in an in-memory DuckDB ------------------------------------
con <- dbConnect(duckdb::duckdb())
for (tbl in c("flights", "airlines", "airports", "planes", "weather")) {
  dbWriteTable(con, tbl, getExportedValue("nycflights13", tbl))
}

# Step 1: plain R functions -----------------------------------------------------
list_tables <- function() {
  paste(dbListTables(con), collapse = ", ")
}

describe_table <- function(table) {
  cols <- dbGetQuery(con, paste0("DESCRIBE ", table))
  n <- dbGetQuery(con, paste0("SELECT count(*) AS n FROM ", table))$n
  paste0(table, " (", n, " rows)\n",
         paste(cols$column_name, cols$column_type, sep = ": ", collapse = "\n"))
}

run_query <- function(sql) {
  # Guardrail: read-only, limited output
  if (!grepl("^\\s*(SELECT|WITH)", sql, ignore.case = TRUE)) {
    stop("Only SELECT queries are allowed.")
  }
  res <- dbGetQuery(con, sql)
  paste(capture.output(print(head(res, 50))), collapse = "\n")
}

plot_query <- function(sql, x, y, title) {
  res <- dbGetQuery(con, sql)
  p <- ggplot(res, aes(.data[[x]], .data[[y]])) +
    geom_col(fill = "steelblue") +
    labs(title = title) +
    theme_minimal()
  print(p)
  "Plot shown to the user."
}

# Step 2: wrap them as tools ----------------------------------------------------
tools <- list(
  tool(list_tables, "List all tables in the database."),
  tool(describe_table, "Show columns, types and row count of a table.",
       arguments = list(table = type_string("Table name"))),
  tool(run_query, "Run a read-only DuckDB SQL query and return the first 50 rows.",
       arguments = list(sql = type_string("A SELECT statement"))),
  tool(plot_query, "Run a SQL query and show a bar chart of the result.",
       arguments = list(
         sql   = type_string("A SELECT statement returning the columns to plot"),
         x     = type_string("Column for the x axis"),
         y     = type_string("Numeric column for the y axis"),
         title = type_string("Chart title")
       ))
)

# Step 3: the agent -------------------------------------------------------------
agent <- chat_google_gemini(system_prompt = "
You are a data analyst with access to a DuckDB database of NYC flights (2013).
Always inspect tables before querying them. Use SQL for all numbers – never guess.
State which query your answer is based on. Keep answers short.
")
agent$register_tools(tools)

# Step 4: ask -------------------------------------------------------------------
agent$chat("Which airline had the highest average departure delay?")
agent$chat("Show that as a chart for the top 5 airlines, with full airline names.")
agent$chat("Is there a relationship between weather and delays at JFK?")

# Look at what happened under the hood: every tool request + result
agent

# Exercises ----------------------------------------------------------------------
# 1. Ask something ambiguous ("What's the worst airport?") – how does it decide?
# 2. Try run_query with "DELETE FROM flights" – does the guardrail hold?
# 3. Add a tool `save_csv(sql, file)` and ask the agent to export a result.

dbDisconnect(con)
