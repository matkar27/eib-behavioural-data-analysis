# ==========================================
# EIB: DATA PROCESSING
# ==========================================

library(tidyverse)


# ==========================================
# 1. IMPORT SYNTHETIC DATA
# ==========================================

eib_trials <- read_csv(
  "data/synthetic/eib_trials_synthetic.csv",
  show_col_types = FALSE
)

# ==========================================
# 2. CONVERT VARIABLE TYPES
# ==========================================

eib_trials <- eib_trials %>%

  mutate(

    participant_id = factor(participant_id),

    instruction_condition = factor(
      instruction_condition,
      levels = c(
        "WithoutInstruction",
        "WithInstruction"
      )
    ),

    phase = factor(
      phase,
      levels = c("Pre", "Post")
    ),

    distractor_valence = factor(
      distractor_valence,
      levels = c("Neutral", "Negative")
    ),

    lag = factor(
      lag,
      levels = c("Lag2", "Lag4")
    )

  )

# ==========================================
# 3. PARTICIPANT-LEVEL SUMMARY
# ==========================================

eib_participant_summary <- eib_trials %>%

  group_by(

    participant_id,

    instruction_condition,

    phase,

    cognitive_load,

    distractor_valence,

    lag,

    lag_ms

  ) %>%

  summarise(

    # Number of trials

    total_trials = n(),


    # Memory accuracy

    memory_correct = sum(memory_accuracy),

    memory_accuracy =
      mean(memory_accuracy) * 100,


    # Target detection accuracy

    target_detection_correct =
      sum(target_detection_accuracy),

    target_detection_accuracy =
      mean(target_detection_accuracy) * 100,


    # Target image accuracy

    target_image_correct =
      sum(target_image_accuracy),

    target_image_accuracy =
      mean(target_image_accuracy) * 100,


    .groups = "drop"

  )

# ==========================================
# 5. SAVE PARTICIPANT-LEVEL DATA
# ==========================================

write_csv(

  eib_participant_summary,

  "data/synthetic/eib_participant_summary_synthetic.csv"

)
