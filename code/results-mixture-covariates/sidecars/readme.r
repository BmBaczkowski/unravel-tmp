require(glue)

readme <- glue("

# Info

After fitting a Bayesian latent mixture model with two latent classes, we extract posterior class membership estimates for each individual and assess their association with external covariates not included in the model (learning rate from RW model, skin conductance responses during conditioning, proportion of high confidence responses). This is done by computing spearman correlations between posterior class assignments and the covariates, providing info about how external variables relate to latent class structure.

## Directory structure

```plaintext
.
├── CHANGES
├── README.md
├── covariates.rds
├── dataset_description.json
├── hist_1HT_posterior_large_plot.pdf
├── hist_2HT_posterior_large_plot.pdf
├── hist_SDT_posterior_large_plot.pdf
├── p_z_covariates_1HT_posterior_large_stanfit.rds
├── p_z_covariates_2HT_posterior_large_stanfit.rds
└── p_z_covariates_SDT_posterior_large_stanfit.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| covariates | external covariates |
| p_z_covariates | matched posterior MCMC samples with external covariates |
| posterior_large | posterior MCMC samples extracted from the model with increased number of samples |
| hist | distribution of posterior class membership (mean) across studies |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |

")