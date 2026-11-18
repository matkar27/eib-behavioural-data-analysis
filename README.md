# EIB Behavioural Data Analysis

## Project Overview

This project demonstrates reproducible behavioural data processing, descriptive statistical analysis, and visualisation using R.

The project is conceptually based on an Emotion-Induced Blindness (EIB) task examining the relationship between cognitive load, emotional distractors, and temporal attention.

An independently generated synthetic dataset is used to demonstrate the organisation and analysis of trial-level behavioural data.

The project explores three behavioural outcomes:

1. **Memory Accuracy:** Accuracy of simulated short-term memory responses across different cognitive-load levels.
2. **Target Detection Accuracy:** Accuracy of simulated target detection responses.
3. **Target-Image Accuracy:** Accuracy of simulated target-image identification, used as the primary outcome for the illustrative emotional interference analysis.

All data and analytical code in this repository are independently constructed for demonstration purposes.

## Research Context

Emotion-Induced Blindness describes impaired detection of a target following an emotionally salient distractor.

The synthetic demonstration includes the following experimental dimensions:

| Experimental Factor | Levels |
|---|---|
| Cognitive Load | 1, 2, 3, 4, 5, 6 digits |
| Distractor Valence | Negative, Neutral |
| Target Lag | Lag 2 (200 ms), Lag 4 (400 ms) |
| Instruction Condition | With Instruction, Without Instruction |
| Phase | Pre, Post |

The simulation is designed to illustrate how cognitive load, distractor valence, and target lag can be represented and examined in a behavioural dataset.

## Dataset Description

The synthetic dataset contains:

- 24 artificially generated participants.
- 12 participants in each instruction condition.
- 5,760 trial-level observations.
- 240 trials per participant.
- 5 repetitions for each experimental condition combination within each phase.

### Behavioural Variables

| Variable | Description |
|---|---|
| `memory_accuracy` | Accuracy of simulated memory responses |
| `target_detection_accuracy` | Accuracy of simulated target detection responses |
| `target_image_accuracy` | Accuracy of simulated target-image identification responses |

All three outcomes are coded as binary responses:

- 0 = Incorrect
- 1 = Correct

## Analysis Workflow

The project is organised into five R scripts.

### 1. Synthetic Data Generation

`R/00_generate_synthetic_data.R`

- Generates artificial participant information.
- Defines experimental condition combinations.
- Constructs trial-level observations.
- Randomises trial order within participant and phase.
- Simulates binary behavioural responses.
- Performs data validation.
- Exports the synthetic trial-level dataset.

### 2. Data Processing

`R/01_data_processing.R`

- Imports trial-level observations.
- Converts categorical variables into appropriate data types.
- Calculates participant-level memory accuracy.
- Calculates participant-level target detection accuracy.
- Calculates participant-level target-image accuracy.
- Exports participant-level summaries.

### 3. Descriptive Analysis

`R/02_descriptive_analysis.R`

- Calculates group-level mean accuracy.
- Calculates standard deviations.
- Calculates standard errors.
- Summarises outcomes across instruction, phase, cognitive-load, distractor, and lag conditions.

### 4. Emotional Interference Analysis

`R/03_eib_interference_analysis.R`

- Restructures negative and neutral distractor conditions.
- Calculates participant-level emotional interference.
- Calculates group-level mean interference, standard deviation, and standard error.
- Examines descriptive interference patterns across cognitive load and target lag.

Emotional interference is operationalised as:

**Neutral Target-Image Accuracy − Negative Target-Image Accuracy**

Positive values indicate lower target-image accuracy following negative distractors.

### 5. Data Visualisation

`R/04_eib_visualisation.R`

Generates visualisations of:

- Group-level emotional interference.
- Individual participant emotional interference trajectories.
- Target-image accuracy across experimental conditions.

## Project Structure

```text
eib-behavioural-data-analysis/
│
├── R/
│   ├── 00_generate_synthetic_data.R
│   ├── 01_data_processing.R
│   ├── 02_descriptive_analysis.R
│   ├── 03_eib_interference_analysis.R
│   └── 04_eib_visualisation.R
│
├── data/
│   └── synthetic/
│       ├── eib_trials_synthetic.csv
│       ├── eib_participant_summary_synthetic.csv
│       ├── eib_group_summary_synthetic.csv
│       ├── eib_interference_participant_synthetic.csv
│       └── eib_interference_group_synthetic.csv
│
├── figures/
│   ├── eib_emotional_interference_group.png
│   ├── eib_emotional_interference_individual.png
│   └── eib_target_image_accuracy.png
│
├── docs/
│   └── data_dictionary.md
│
├── README.md
├── .gitignore
└── eib-behavioural-data-analysis.Rproj
```

## Selected Visualisations

The repository includes three figures demonstrating the synthetic analysis workflow:

1. Group-level emotional interference across cognitive load and target lag.
2. Individual participant emotional interference trajectories, with group means.
3. Target-image accuracy across distractor valence and experimental conditions.

The figures are available in the `figures/` directory.

## Requirements

- R
- RStudio (recommended)
- `tidyverse`

Install the required package using:

```r
install.packages("tidyverse")
```

## How to Run the Project

1. Clone or download the repository.
2. Open the `.Rproj` file in RStudio.
3. Run `00_generate_synthetic_data.R`.
4. Run `01_data_processing.R`.
5. Run `02_descriptive_analysis.R`.
6. Run `03_eib_interference_analysis.R`.
7. Run `04_eib_visualisation.R`.

Run the scripts in numerical order because subsequent scripts depend on the datasets generated by preceding scripts.

Generated datasets are saved in `data/synthetic/`, and figures are saved in `figures/`.

## Scope and Limitations

This repository is an independent demonstration of behavioural data processing and descriptive analysis using artificially generated data.

The simulation is informed by general concepts relating to cognitive load, emotional distractors, selective attention, and Emotion-Induced Blindness.

The following limitations apply:

- No original participant-level observations are included.
- The synthetic dataset does not reproduce the original experimental data or empirical findings.
- Pre/Post and instruction conditions are represented as balanced organisational factors without deliberately simulated phase-specific or instruction-specific effects.
- The emotional interference pattern is deliberately incorporated into the synthetic target-image accuracy simulation.
- The project focuses on data processing, descriptive statistics, and visualisation rather than inferential statistical testing.
- Simulated patterns should not be interpreted as empirical findings.

All datasets are artificially generated for programming practice and portfolio demonstration.

## Reproducibility

A fixed random seed is used during synthetic data generation to support reproducibility.

All analysis scripts use project-relative file paths, and generated datasets and figures are organised into dedicated folders.

The accompanying data dictionary documents the variables and dataset structure.
