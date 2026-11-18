# ==========================================
# EIB: DATA VISUALISATION
# ==========================================

library(tidyverse)


# ==========================================
# 1. IMPORT DATASETS
# ==========================================

eib_interference_participant <- read_csv(
  "data/synthetic/eib_interference_participant_synthetic.csv",
  show_col_types = FALSE
)

eib_interference_group <- read_csv(
  "data/synthetic/eib_interference_group_synthetic.csv",
  show_col_types = FALSE
)

eib_participant_summary <- read_csv(
  "data/synthetic/eib_participant_summary_synthetic.csv",
  show_col_types = FALSE
)

# ==========================================
# 2. PREPARE VARIABLES FOR PLOTTING
# ==========================================

eib_interference_group <- eib_interference_group %>%

  mutate(

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

    lag = factor(
      lag,
      levels = c("Lag2", "Lag4")
    )

  )

# ==========================================
# 3. TARGET-IMAGE ACCURACY GROUP SUMMARY
# ==========================================

eib_accuracy_group <- eib_participant_summary %>%

  group_by(

    instruction_condition,

    phase,

    cognitive_load,

    distractor_valence,

    lag

  ) %>%

  summarise(

    n_participants = n_distinct(participant_id),

    group_mean_accuracy =
      mean(target_image_accuracy, na.rm = TRUE),

    group_sd_accuracy =
      sd(target_image_accuracy, na.rm = TRUE),

    group_se_accuracy =
      group_sd_accuracy / sqrt(n_participants),

    .groups = "drop"

  )

# ==========================================
# 4. GROUP-LEVEL EMOTIONAL INTERFERENCE
# ==========================================

plot_interference_group <- ggplot(

  eib_interference_group,

  aes(

    x = cognitive_load,

    y = mean_emotional_interference,

    colour = lag,

    group = lag

  )

) +

  geom_hline(

    yintercept = 0,

    linetype = "dashed",

    colour = "grey50"

  ) +

  geom_line(

    linewidth = 1

  ) +

  geom_point(

    size = 2.5

  ) +

  geom_errorbar(

    aes(

      ymin = mean_emotional_interference -
        se_emotional_interference,

      ymax = mean_emotional_interference +
        se_emotional_interference

    ),

    width = 0.15,

    linewidth = 0.6

  ) +

  facet_grid(

    phase ~ instruction_condition

  ) +

  scale_x_continuous(

    breaks = 1:6

  ) +

  labs(

    title = "Emotional Interference Across Cognitive Load",

    x = "Cognitive Load (Number of Digits)",

    y = "Emotional Interference (Percentage Points)",

    colour = "Target Lag"

  ) +

  theme_minimal(base_size = 12) +

  theme(

    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),

    strip.text = element_text(
      face = "bold"
    ),

    legend.position = "bottom"

  )


plot_interference_group

# ==========================================
# 5. INDIVIDUAL PARTICIPANT TRAJECTORIES
# ==========================================

plot_interference_individual <- ggplot(

  eib_interference_participant,

  aes(

    x = cognitive_load,

    y = emotional_interference,

    colour = lag,

    group = interaction(
      participant_id,
      lag
    )

  )

) +

  geom_line(

    alpha = 0.20,

    linewidth = 0.4

  ) +

  geom_line(

    data = eib_interference_group,

    aes(

      x = cognitive_load,

      y = mean_emotional_interference,

      colour = lag,

      group = lag

    ),

    inherit.aes = FALSE,

    linewidth = 1.2

  ) +

  geom_point(

    data = eib_interference_group,

    aes(

      x = cognitive_load,

      y = mean_emotional_interference,

      colour = lag

    ),

    inherit.aes = FALSE,

    size = 2

  ) +

  facet_grid(

    phase ~ instruction_condition

  ) +

  scale_x_continuous(

    breaks = 1:6

  ) +

  labs(

    title = "Individual Emotional Interference Trajectories",

    x = "Cognitive Load (Number of Digits)",

    y = "Emotional Interference (Percentage Points)",

    colour = "Target Lag"

  ) +

  theme_minimal(base_size = 12) +

  theme(

    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),

    strip.text = element_text(
      face = "bold"
    ),

    legend.position = "bottom"

  )


plot_interference_individual

# ==========================================
# 6. TARGET-IMAGE ACCURACY BY DISTRACTOR
# ==========================================

plot_target_accuracy <- ggplot(

  eib_accuracy_group,

  aes(

    x = cognitive_load,

    y = group_mean_accuracy,

    colour = distractor_valence,

    group = interaction(
      distractor_valence,
      lag
    )

  )

) +

  geom_line(

    linewidth = 0.9

  ) +

  geom_point(

    size = 2

  ) +

  geom_errorbar(

    aes(

      ymin = group_mean_accuracy -
        group_se_accuracy,

      ymax = group_mean_accuracy +
        group_se_accuracy

    ),

    width = 0.15

  ) +

  facet_grid(

    phase + lag ~ instruction_condition

  ) +

  scale_x_continuous(

    breaks = 1:6

  ) +

  scale_y_continuous(

    limits = c(0, 100),

    breaks = seq(0, 100, 20)

  ) +

  labs(

    title = "Target-Image Accuracy Across Experimental Conditions",

    x = "Cognitive Load (Number of Digits)",

    y = "Target-Image Accuracy (%)",

    colour = "Distractor Valence"

  ) +

  theme_minimal(base_size = 12) +

  theme(

    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),

    strip.text = element_text(
      face = "bold"
    ),

    legend.position = "bottom"

  )


plot_target_accuracy

# ==========================================
# 7. SAVE FIGURES
# ==========================================

ggsave(

  "figures/eib_emotional_interference_group.png",

  plot_interference_group,

  width = 10,

  height = 7,

  dpi = 300

)


ggsave(

  "figures/eib_emotional_interference_individual.png",

  plot_interference_individual,

  width = 10,

  height = 7,

  dpi = 300

)


ggsave(

  "figures/eib_target_image_accuracy.png",

  plot_target_accuracy,

  width = 12,

  height = 9,

  dpi = 300

)
