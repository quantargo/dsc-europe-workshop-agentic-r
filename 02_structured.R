# 02 – Structured output: free text -> data frame -----------------------------
library(ellmer)

# Reviews of flights around Belgrade Nikola Tesla Airport (BEG) –
# in English, Serbian Latin and Serbian Cyrillic
reviews <- c(
  "Air Serbia JU 311 from Vienna to Belgrade landed 40 minutes late, but the crew was lovely.",
  "Wizz Air from BEG to Dortmund: on time, but €45 extra for my cabin bag. 2/5.",
  "Let Air Serbije iz Beograda za Podgoricu – sve savršeno, opet ću leteti s njima!",
  "Swiss је изгубио мој пртљаг на лету из Београда за Цирих. Никад више!"
)

# Describe the shape you want back – the model fills it in English and maps
# city names ("Beograd", "Београд") to airport codes
type_review <- type_object(
  airline   = type_string("Airline name"),
  origin    = type_string("Origin airport IATA code (e.g. BEG), if mentioned", required = FALSE),
  delayed   = type_boolean("Was the flight delayed?"),
  sentiment = type_enum(c("positive", "neutral", "negative"), "Overall sentiment"),
  issue     = type_string("Main complaint in 3 English words, if any", required = FALSE),
  rating    = type_number(required = FALSE)
)

chat <- chat_google_gemini()

# One text
chat$chat_structured(reviews[1], type = type_review)

# Many texts in parallel -> directly a data frame
# rpm keeps us under the Gemini free-tier rate limit
parallel_chat_structured(chat, as.list(reviews), type = type_review, rpm = 10)

# Exercises:
# 1. Add a field `rating` (type_number, optional) and re-run.
# 2. Add `destination` and `language` fields – does it get "Цирих" -> ZRH right?
# 3. Write your own review of your trip to DSC Europe and add it to `reviews`.
