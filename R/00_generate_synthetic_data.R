# ==========================================
# EIB: SYNTHETIC DATA GENERATION
# ==========================================

library(tidyverse)

# ==========================================
# 1. SET SEED
# ==========================================

set.seed(20261118)

# ==========================================
# 2. GENERATE PARTICIPANT INFORMATION
# ==========================================

n_participants <- 24

participants <- tibble(

  participant_id = sprintf(
    "P%03d",
    1:n_participants
  ),

  instruction_condition = rep(
    c("WithoutInstruction", "WithInstruction"),
    each = n_participants / 2
  ),

  memory_person_effect = rnorm(
    n_participants,
    mean = 0,
    sd = 0.35
  ),

  target_person_effect = rnorm(
    n_participants,
    mean = 0,
    sd = 0.30
  ),

  image_person_effect = rnorm(
    n_participants,
    mean = 0,
    sd = 0.30
  )

)

head(participants)

# ==========================================
# 3. DEFINE EXPERIMENTAL CONDITIONS
# ==========================================

phases <- c("Pre", "Post")

cognitive_loads <- 1:6

distractor_conditions <- c(
  "Negative",
  "Neutral"
)

lags <- c(
  "Lag2",
  "Lag4"
)

trials_per_condition <- 5

# ==========================================
# 4. CREATE TRIAL-LEVEL DATA STRUCTURE
# ==========================================

eib_trials <- expand_grid(

  participant_id = participants$participant_id,

  phase = phases,

  cognitive_load = cognitive_loads,

  distractor_valence = distractor_conditions,

  lag = lags,

  trial_repetition = 1:trials_per_condition

) %>%

  left_join(
    participants,
    by = "participant_id"
  )

dim(eib_trials)

# ==========================================
# 5. RANDOMISE TRIAL ORDER
# ==========================================

eib_trials <- eib_trials %>%

  group_by(
    participant_id,
    phase
  ) %>%

  slice_sample(
    prop = 1
  ) %>%

  mutate(
    trial_number = row_number()
  ) %>%

  ungroup() %>%

  mutate(
    trial_id = sprintf(
      "TR%05d",
      row_number()
    )
  )

# ==========================================
# 5A. CREATE LAG DURATION VARIABLE
# ==========================================

eib_trials <- eib_trials %>%

  mutate(

    lag_ms = case_when(

      lag == "Lag2" ~ 200L,

      lag == "Lag4" ~ 400L

    )

  )

# ==========================================
# 6. SIMULATE MEMORY ACCURACY
# ==========================================

eib_trials <- eib_trials %>%

  mutate(

    load_index = cognitive_load - 1,

    memory_probability = plogis(
      2.8 -
        0.45 * load_index +
        memory_person_effect
    ),

    memory_accuracy = rbinom(
      n(),
      size = 1,
      prob = memory_probability
    )

  )

# ==========================================
# 7. SIMULATE TARGET DETECTION ACCURACY
# ==========================================

eib_trials <- eib_trials %>%

  mutate(

    target_detection_probability = plogis(

      2.1 -

        0.08 * load_index +

        target_person_effect

    ),

    target_detection_accuracy = rbinom(
      n(),
      size = 1,
      prob = target_detection_probability
    )

  )

# ==========================================
# 8. SIMULATE TARGET-IMAGE ACCURACY
# ==========================================

eib_trials <- eib_trials %>%

  mutate(

    # Emotional interference penalty

    target_image_emotional_penalty = case_when(

      lag == "Lag2" ~
        0.95 - 0.12 * load_index,

      lag == "Lag4" ~
        0.45 - 0.06 * load_index

    ),

    # Target-image identification probability

    target_image_probability = plogis(

      2.1 -

        0.08 * load_index -

        if_else(
          distractor_valence == "Negative",
          target_image_emotional_penalty,
          0
        ) +

        image_person_effect

    ),

    # Generate binary responses

    target_image_accuracy = rbinom(
      n(),
      size = 1,
      prob = target_image_probability
    )

  )

# ==========================================
# 9. FINALISE DATASET
# ==========================================

eib_trials <- eib_trials %>%

  select(

    trial_id,

    participant_id,

    instruction_condition,

    phase,

    trial_number,

    trial_repetition,

    cognitive_load,

    distractor_valence,

    lag,

    lag_ms,

    memory_accuracy,

    target_detection_accuracy,

    target_image_accuracy

  )

# ==========================================
# 10. DATA VALIDATION
# ==========================================

# Check dimensions

dim(eib_trials)


# Check unique participants

n_distinct(eib_trials$participant_id)


# Check instruction group allocation

table(
  participants$instruction_condition
)


# Check phase distribution

table(
  eib_trials$phase
)


# Check cognitive load distribution

table(
  eib_trials$cognitive_load
)


# Check distractor distribution

table(
  eib_trials$distractor_valence
)


# Check lag distribution

table(
  eib_trials$lag
)


# Check missing values

colSums(
  is.na(eib_trials)
)


# Check binary outcome coding

table(eib_trials$memory_accuracy)

table(eib_trials$target_detection_accuracy)

table(eib_trials$target_image_accuracy)

stopifnot(

  nrow(eib_trials) == 5760,

  ncol(eib_trials) == 13,

  n_distinct(eib_trials$participant_id) == 24,

  !anyNA(eib_trials),

  all(eib_trials$memory_accuracy %in% c(0, 1)),

  all(eib_trials$target_detection_accuracy %in% c(0, 1)),

  all(eib_trials$target_image_accuracy %in% c(0, 1))

)

# ==========================================
# 11. SAVE SYNTHETIC DATASET
# ==========================================

write.csv(

  eib_trials,

  "data/synthetic/eib_trials_synthetic.csv",

  row.names = FALSE

)
