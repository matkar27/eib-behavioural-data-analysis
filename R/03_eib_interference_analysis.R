# ==========================================
# EIB: EMOTIONAL INTERFERENCE ANALYSIS
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
# 2. RESHAPE DATA FOR INTERFERENCE ANALYSIS
# ==========================================

eib_interference_participant <- eib_participant_summary %>%

  select(
    participant_id,
    instruction_condition,
    phase,
    cognitive_load,
    lag,
    lag_ms,
    distractor_valence,
    target_image_accuracy
  ) %>%

  pivot_wider(

    names_from = distractor_valence,

    values_from = target_image_accuracy,

    names_prefix = "accuracy_"

  )

# ==========================================
# 3. CALCULATE EMOTIONAL INTERFERENCE
# ==========================================

eib_interference_participant <- eib_interference_participant %>%

  mutate(

    emotional_interference =
      accuracy_Neutral - accuracy_Negative

  )

# ==========================================
# 4. VALIDATE PARTICIPANT-LEVEL INTERFERENCE
# ==========================================

# Dimensions

dim(eib_interference_participant)


# Check missing values

colSums(
  is.na(eib_interference_participant)
)


# Check number of participants

n_distinct(
  eib_interference_participant$participant_id
)


# Inspect first observations

head(eib_interference_participant)

# ==========================================
# 5. GROUP-LEVEL EMOTIONAL INTERFERENCE
# ==========================================

eib_interference_group <- eib_interference_participant %>%

  group_by(

    instruction_condition,

    phase,

    cognitive_load,

    lag,

    lag_ms

  ) %>%

  summarise(

    n_participants = n_distinct(participant_id),


    # Negative distractor accuracy

    mean_negative_accuracy =
      mean(accuracy_Negative, na.rm = TRUE),


    # Neutral distractor accuracy

    mean_neutral_accuracy =
      mean(accuracy_Neutral, na.rm = TRUE),


    # Mean emotional interference

    mean_emotional_interference =
      mean(emotional_interference, na.rm = TRUE),


    # Standard deviation

    sd_emotional_interference =
      sd(emotional_interference, na.rm = TRUE),


    # Standard error

    se_emotional_interference =
      sd_emotional_interference / sqrt(n_participants),


    .groups = "drop"

  )

# ==========================================
# 6. VALIDATE GROUP-LEVEL INTERFERENCE
# ==========================================

# Dimensions

dim(eib_interference_group)


# Participants per condition

table(
  eib_interference_group$n_participants
)


# Missing values

colSums(
  is.na(eib_interference_group)
)


# Inspect results

print(
  eib_interference_group,
  n = 20,
  width = Inf
)

# ==========================================
# 7. EXPLORE INTERFERENCE ACROSS LOAD AND LAG
# ==========================================

eib_interference_overview <- eib_interference_group %>%

  group_by(

    cognitive_load,

    lag,

    lag_ms

  ) %>%

  summarise(

    mean_emotional_interference =
      mean(mean_emotional_interference),

    .groups = "drop"

  ) %>%

  arrange(
    lag_ms,
    cognitive_load
  )


print(
  eib_interference_overview,
  n = 12,
  width = Inf
)

# ==========================================
# 8. SAVE INTERFERENCE DATASETS
# ==========================================

write_csv(

  eib_interference_participant,

  "data/synthetic/eib_interference_participant_synthetic.csv"

)


write_csv(

  eib_interference_group,

  "data/synthetic/eib_interference_group_synthetic.csv"

)
