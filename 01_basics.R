# 01 – ellmer basics -----------------------------------------------------------
library(ellmer)

# A chat object holds provider, model, system prompt and the conversation
chat <- chat_anthropic(
  system_prompt = "You are a concise R expert. Answer with tidyverse code."
)

chat$chat("How do I count rows per group in a data frame?")

# The object is stateful: follow-up questions keep the context
chat$chat("And now sort the result descending.")

# Inspect the conversation and token usage
chat
token_usage()

# Switching providers is one line – the rest of the code stays the same
# chat <- chat_openai()
# chat <- chat_google_gemini()
# chat <- chat_ollama(model = "llama3.2")

# Interactive console chat (great for live demos)
# live_console(chat)
