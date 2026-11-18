# Data Dictionary

## Project
Influence of Variable Cognitive Load on Emotional Interference in Emotion-Induced Blindness

## Data Description

This project uses artificially generated trial-level behavioural data to demonstrate data processing and analysis workflows for an Emotion-Induced Blindness (EIB) experiment.

Each row represents one simulated experimental trial.

No original participant-level observations are included.

## 1. Participant-Level Variables

| Variable | Description | Type |
|---|---|---|
| participant_id | Artificial participant identifier | Character |
| instruction_condition | Instruction group (WithInstruction / WithoutInstruction) | Factor |

## 2. Experimental Condition Variables

| Variable | Description | Type |
|---|---|---|
| phase | Data collection phase (Pre / Post) | Factor |
| cognitive_load | Number of digits maintained in short-term memory (1–6) | Integer |
| distractor_valence | Emotional category of distractor (Negative / Neutral) | Factor |
| lag | Temporal position of target (Lag2 / Lag4) | Factor |
| lag_ms | Target lag duration in milliseconds (200 / 400) | Integer |

## 3. Behavioural Outcome Variables

| Variable | Description | Type |
|---|---|---|
| memory_accuracy | Accuracy of the simulated digit-memory response (0 = Incorrect, 1 = Correct) | Binary |
| target_detection_accuracy | Accuracy of simulated target detection (0 = Incorrect, 1 = Correct) | Binary |
| target_image_accuracy | Accuracy of simulated target-image identification (0 = Incorrect, 1 = Correct) | Binary |

## 4. Trial Identification Variables

| Variable | Description | Type |
|---|---|---|
| trial_id | Unique identifier for each simulated trial | Character |
| trial_number | Sequential trial number within participant and phase | Integer |

## 5. Derived Analytical Measure

### Emotional Interference

Emotional interference will be calculated at the participant and condition levels as:

Neutral target accuracy minus Negative target accuracy.

Positive values indicate lower target accuracy following negative distractors compared with neutral distractors.

This is a descriptive measure for the synthetic demonstration and should not be interpreted as an empirical result.

## 6. Data Scope

All datasets are artificially generated for programming practice and portfolio demonstration.

They do not contain original NIMHANS participant data and do not reproduce the original study's empirical results.

## 7. Synthetic Dataset Design

The synthetic dataset is designed as a balanced trial-level behavioural dataset.

### Participant Structure

- Total synthetic participants: 24
- WithInstruction: 12 participants
- WithoutInstruction: 12 participants
- Instruction condition is assigned between participants.

### Experimental Factors

- Phase: Pre and Post
- Cognitive load: 1–6 digits
- Distractor valence: Negative and Neutral
- Target lag: Lag2 and Lag4

### Trial Structure

Five trials are generated for each combination of phase, cognitive load, distractor valence, and lag for every participant.

### Dataset Size

- Trials per participant: 240
- Total participants: 24
- Expected total observations: 5,760

### Simulation Assumptions

The synthetic data-generating process is designed to illustrate:

1. A general decline in memory accuracy as cognitive load increases.
2. Lower target accuracy following negative distractors compared with neutral distractors.
3. Greater emotional interference at Lag 2 compared with Lag 4.
4. Reduced emotional interference as cognitive load increases, particularly at Lag 2.

These assumptions are informed by the research hypothesis and description provided for this portfolio project. They are not empirical observations or a reconstruction of the original study results.

The Pre and Post labels are retained as synthetic data-organisation variables. Their original experimental interpretation has not been established in this project.
