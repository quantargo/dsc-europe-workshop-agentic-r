# 02 – Structured output: free text -> data frame -----------------------------
library(ellmer)

reviews <- c(
  "Flight UA 1545 from Newark was delayed 2 hours, staff were friendly though.",
  "JFK to Miami with American: on time, but the seat was broken. 2/5.",
  "Delta LGA-ATL, perfect flight, would fly again!",
  "Lost my luggage on JetBlue from JFK. Never again."
)

# Describe the shape you want back
type_review <- type_object(
  airline   = type_string("Airline name"),
  origin    = type_string("Origin airport code, if mentioned", required = FALSE),
  delayed   = type_boolean("Was the flight delayed?"),
  sentiment = type_enum(c("positive", "neutral", "negative"), "Overall sentiment"),
  issue     = type_string("Main complaint in 3 words, if any", required = FALSE)
)

chat <- chat_anthropic()

# One text
chat$chat_structured(reviews[1], type = type_review)

# Many texts in parallel -> directly a data frame
parallel_chat_structured(chat, as.list(reviews), type = type_review)

# Exercise: add a field `rating` (type_number, optional) and re-run.
