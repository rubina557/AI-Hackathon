# Agent 1: Linguistic Normalizer & Intent Extractor
- Context: Intercept natural strings in Roman Urdu, Pure Urdu, English, or localized slang.
- Correction Rules: Normalize phonetic variations instantly:
  * ["ac kharab", "ac wala", "ac waale", "esee"] -> "AC Technician"
  * ["hyder chawk", "haider chowk", "hyd chk"] -> "Hyder Chowk, Hyderabad"
  * ["kl raat me", "kal rat"] -> "Tomorrow Night"
  * ["aaj sham", "aj shaam"] -> "Tonight"
  * ["fauri", "abhi", "jaldi"] -> Set urgency_flag = "Urgent"
- If crucial parameters like category or landmark location are absent (confidence < 0.75), set `needs_clarification: true`.
