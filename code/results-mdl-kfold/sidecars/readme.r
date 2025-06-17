require(glue)

readme <- glue("

# Info

Measurement models of recognition data were compared using 5-fold cross validation. 
We conducted 5-fold cross-validation, stratifying the folds by subject and study to ensure balanced representation across splits. For each fold, models were fit to 80% of the data and evaluated on the remaining 20%. We computed the estimated expected log predictive density (ELPD) using the `loo` package in R, which aggregates the log predictive densities from held-out observations across all folds. This approach provides an out-of-sample estimate of each model's predictive accuracy. Model comparisons were based on differences in cross-validated ELPD, with higher values indicating better predictive performance.

## Directory structure

```plaintext
.
├── CHANGES
├── README.md
├── dataset_description.json
├── task-recognition_desc-1HT_1_holdout_stanfit.rds
├── task-recognition_desc-1HT_1_posterior_stanfit.rds
├── task-recognition_desc-1HT_2_holdout_stanfit.rds
├── task-recognition_desc-1HT_2_posterior_stanfit.rds
├── task-recognition_desc-1HT_3_holdout_stanfit.rds
├── task-recognition_desc-1HT_3_posterior_stanfit.rds
├── task-recognition_desc-1HT_4_holdout_stanfit.rds
├── task-recognition_desc-1HT_4_posterior_stanfit.rds
├── task-recognition_desc-1HT_5_holdout_stanfit.rds
├── task-recognition_desc-1HT_5_posterior_stanfit.rds
├── task-recognition_desc-1HT_holdout_stanmodel.rds
├── task-recognition_desc-1HT_posterior_stanmodel.rds
├── task-recognition_desc-1HTvsSDT_elpd.rds
├── task-recognition_desc-2HT_1_holdout_stanfit.rds
├── task-recognition_desc-2HT_1_posterior_stanfit.rds
├── task-recognition_desc-2HT_2_holdout_stanfit.rds
├── task-recognition_desc-2HT_2_posterior_stanfit.rds
├── task-recognition_desc-2HT_3_holdout_stanfit.rds
├── task-recognition_desc-2HT_3_posterior_stanfit.rds
├── task-recognition_desc-2HT_4_holdout_stanfit.rds
├── task-recognition_desc-2HT_4_posterior_stanfit.rds
├── task-recognition_desc-2HT_5_holdout_stanfit.rds
├── task-recognition_desc-2HT_5_posterior_stanfit.rds
├── task-recognition_desc-2HT_holdout_stanmodel.rds
├── task-recognition_desc-2HT_posterior_stanmodel.rds
├── task-recognition_desc-2HTvs1HT_elpd.rds
├── task-recognition_desc-2HTvsSDT_elpd.rds
├── task-recognition_desc-SDT_1_holdout_stanfit.rds
├── task-recognition_desc-SDT_1_posterior_stanfit.rds
├── task-recognition_desc-SDT_2_holdout_stanfit.rds
├── task-recognition_desc-SDT_2_posterior_stanfit.rds
├── task-recognition_desc-SDT_3_holdout_stanfit.rds
├── task-recognition_desc-SDT_3_posterior_stanfit.rds
├── task-recognition_desc-SDT_4_holdout_stanfit.rds
├── task-recognition_desc-SDT_4_posterior_stanfit.rds
├── task-recognition_desc-SDT_5_holdout_stanfit.rds
├── task-recognition_desc-SDT_5_posterior_stanfit.rds
├── task-recognition_desc-SDT_holdout_stanmodel.rds
├── task-recognition_desc-SDT_posterior_stanmodel.rds
└── task-recognition_standata_kfold.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| 1HT | files relevant for one-high-threshold model |
| 2HT | files relevant for two-high-threshold model |
| SDT | files relevant for signal detection theory model |
| standata | data structure needed for STAN model after k-fold split|
| holdout_stanfit | MCMC samples after fiting STAN model to test data of each fold |
| posterior_stanfit | MCMC samples after fiting STAN model to training data of each fold |
| stanmodel | compiled STAN model |
| elpd | model comparison based on predictive performance |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |

")