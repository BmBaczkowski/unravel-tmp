require(glue)

readme <- glue("

# Info

This model implements a hierarchical Bayesian latent mixture framework to identify latent subgroups of participants in memory recognition based on old-new judgment data. The model assumes that each participant belongs probabilistically to one of two latent classes via a Bernoulli distribution with a mixing proportion $\\phi$. Each of the two latent classes  was defined by distinct group-level mean vectors for the $\\beta$ weights. 

## Bayesian Hierarchical Mixture Model

Reference graphical model representation for two-high-threshold model.
<a href='../docs-mdl/mdl_2HT_mixture.pdf' target='_blank'>View graphical model (pdf file).</a>


## Directory structure

```plaintext
.
├── CHANGES
├── README.md
├── dataset_description.json
├── task-recognition_desc-1HT_posterior_large_stanfit.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit.rds
├── task-recognition_desc-1HT_posterior_large_stanfit.txt
├── task-recognition_desc-1HT_posterior_large_stanfit_pred1.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_pred2.pdf
├── task-recognition_desc-1HT_posterior_stanfit.pdf
├── task-recognition_desc-1HT_posterior_stanfit.rds
├── task-recognition_desc-1HT_posterior_stanfit.txt
├── task-recognition_desc-1HT_posterior_stanfit_pred1.pdf
├── task-recognition_desc-1HT_posterior_stanfit_pred2.pdf
├── task-recognition_desc-1HT_stanmodel.rds
├── task-recognition_desc-2HT_posterior_large_stanfit.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit.rds
├── task-recognition_desc-2HT_posterior_large_stanfit.txt
├── task-recognition_desc-2HT_posterior_large_stanfit_pred1.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_pred2.pdf
├── task-recognition_desc-2HT_posterior_stanfit.pdf
├── task-recognition_desc-2HT_posterior_stanfit.rds
├── task-recognition_desc-2HT_posterior_stanfit.txt
├── task-recognition_desc-2HT_posterior_stanfit_pred1.pdf
├── task-recognition_desc-2HT_posterior_stanfit_pred2.pdf
├── task-recognition_desc-2HT_stanmodel.rds
├── task-recognition_desc-SDT_posterior_large_stanfit.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit.rds
├── task-recognition_desc-SDT_posterior_large_stanfit.txt
├── task-recognition_desc-SDT_posterior_large_stanfit_pred1.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_pred2.pdf
├── task-recognition_desc-SDT_posterior_stanfit.pdf
├── task-recognition_desc-SDT_posterior_stanfit.txt
├── task-recognition_desc-SDT_posterior_stanfit_pred1.pdf
├── task-recognition_desc-SDT_posterior_stanfit_pred2.pdf
└── task-recognition_desc-SDT_stanmodel.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| 1HT | files relevant for one-high-threshold model |
| 2HT | files relevant for two-high-threshold model |
| SDT | files relevant for signal detection theory model |
| stanmodel | compiled STAN model |
| stanfit | MCMC samples after fiting STAN model |
| posterior | model / samples after seeing the data |
| pred | posterior predictive data |
| large | increased number of MCMC samples |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |


")