# ==========================================
# EIB: GROUP-LEVEL DESCRIPTIVE ANALYSIS
# ==========================================

library(tidyverse)


# ==========================================
# 1. IMPORT PARTICIPANT-LEVEL DATA
# ==========================================

eib_participant_summary <- read_csv(
  "data/synthetic/eib_participant_summary_synthetic.csv",
  show_col_types = FALSE
)

# ==========================================
# 2. GROUP-LEVEL SUMMARY
# ==========================================

eib_group_summary <- eib_participant_summary %>%

  group_by(

    instruction_condition,

    phase,

    cognitive_load,

    distractor_valence,

    lag,

    lag_ms

  ) %>%

  summarise(

    # Number of participants

    n_participants = n_distinct(participant_id),


    # ----------------------------------------
    # MEMORY ACCURACY
    # ----------------------------------------

    group_mean_memory_accuracy =
      mean(memory_accuracy, na.rm = TRUE),

    group_sd_memory_accuracy =
      sd(memory_accuracy, na.rm = TRUE),

    group_se_memory_accuracy =
      group_sd_memory_accuracy /
      sqrt(n_participants),


    # ----------------------------------------
    # TARGET DETECTION ACCURACY
    # ----------------------------------------

    group_mean_target_accuracy =
      mean(target_detection_accuracy, na.rm = TRUE),

    group_sd_target_accuracy =
      sd(target_detection_accuracy, na.rm = TRUE),

    group_se_target_accuracy =
      group_sd_target_accuracy /
      sqrt(n_participants),


    # ----------------------------------------
    # TARGET IMAGE ACCURACY
    # ----------------------------------------

    group_mean_image_accuracy =
      mean(target_image_accuracy, na.rm = TRUE),

    group_sd_image_accuracy =
      sd(target_image_accuracy, na.rm = TRUE),

    group_se_image_accuracy =
      group_sd_image_accuracy /
      sqrt(n_participants),


    .groups = "drop"

  )

# ==========================================
# 3. VALIDATE GROUP SUMMARY
# ==========================================

# Dimensions

dim(eib_group_summary)


# Number of unique participants per group

table(eib_group_summary$n_participants)


# Check missing values

colSums(is.na(eib_group_summary))


# Inspect first rows

head(eib_group_summary)

# ==========================================
# 4. SAVE GROUP-LEVEL SUMMARY
# ==========================================

write_csv(

  eib_group_summary,

  "data/synthetic/eib_group_summary_synthetic.csv"

)
