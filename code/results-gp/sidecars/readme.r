require(glue)

readme <- glue("

# Info

We extended the baseline Bayesian model with gaussian process (GP) to explore the relationships between the individual differences in memory recognition (output) and indicies of aversive learning during conditioning (input features) such as learning rate (1D; extracted from RW learning model) and skin conductance response (2D; two estimation methods). In this approach, the outputs are modeled using latent functions ($f$s) defined over a feature space ($x$). We used a Matérn 3/2 covariance function to model similarities across participants in each feature space, which ensured flexibility while maintaining computational tractability. We placed standard priors on hyperparameters, including the length scale of the kernel (which controls the smoothness of the functions), kernel amplitude (which determines variation in the latent functions), and observation noise (which accounts for residual variability).
Exemplary <a href='../docs-mdl/mdl_1HT_gp.pdf' target='_blank'>graphical model (pdf file).</a>


## Directory structure

```plaintext
.
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_rw.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_rw.rds
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_rw.txt
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_avg.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_avg.rds
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_avg.txt
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_avg_pred.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_delta.pdf
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_delta.rds
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_delta.txt
├── task-recognition_desc-1HT_posterior_large_stanfit_gp_scr_delta_pred.pdf
├── task-recognition_desc-1HT_posterior_stanfit_gp_rw.pdf
├── task-recognition_desc-1HT_posterior_stanfit_gp_rw.rds
├── task-recognition_desc-1HT_posterior_stanfit_gp_rw.txt
├── task-recognition_desc-1HT_posterior_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-1HT_posterior_stanfit_gp_scr_delta.pdf
├── task-recognition_desc-1HT_posterior_stanfit_gp_scr_delta.rds
├── task-recognition_desc-1HT_posterior_stanfit_gp_scr_delta.txt
├── task-recognition_desc-1HT_posterior_stanmodel_gp.rds
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_rw.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_rw.rds
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_rw.txt
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_avg.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_avg.rds
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_avg.txt
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_avg_pred.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_delta.pdf
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_delta.rds
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_delta.txt
├── task-recognition_desc-2HT_posterior_large_stanfit_gp_scr_delta_pred.pdf
├── task-recognition_desc-2HT_posterior_stanfit_gp_rw.pdf
├── task-recognition_desc-2HT_posterior_stanfit_gp_rw.rds
├── task-recognition_desc-2HT_posterior_stanfit_gp_rw.txt
├── task-recognition_desc-2HT_posterior_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-2HT_posterior_stanfit_gp_scr_delta.pdf
├── task-recognition_desc-2HT_posterior_stanfit_gp_scr_delta.rds
├── task-recognition_desc-2HT_posterior_stanfit_gp_scr_delta.txt
├── task-recognition_desc-2HT_posterior_stanmodel_gp.rds
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_rw.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_rw.rds
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_rw.txt
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_avg.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_avg.rds
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_avg.txt
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_avg_pred.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_delta.pdf
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_delta.rds
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_delta.txt
├── task-recognition_desc-SDT_posterior_large_stanfit_gp_scr_delta_pred.pdf
├── task-recognition_desc-SDT_posterior_stanfit_gp_rw.pdf
├── task-recognition_desc-SDT_posterior_stanfit_gp_rw.rds
├── task-recognition_desc-SDT_posterior_stanfit_gp_rw.txt
├── task-recognition_desc-SDT_posterior_stanfit_gp_rw_pred.pdf
├── task-recognition_desc-SDT_posterior_stanfit_gp_scr_delta.rds
├── task-recognition_desc-SDT_posterior_stanfit_gp_scr_delta.txt
├── task-recognition_desc-SDT_posterior_stanmodel_gp.rds
├── task-recognition_standata_gp_rw.rds
├── task-recognition_standata_gp_scr_avg.rds
└── task-recognition_standata_gp_scr_delta.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| gp_rw | GP with alpha learning rate |
| gp_scr_avg | GP with average skin conductance response during conditioning |
| gp_scr_delta | GP with the difference of skin conductance response during conditioning (CS+ - CS-) |
| standata | data structure needed for STAN model |
| stanmodel | compiled STAN model |
| stanfit | MCMC samples after fiting STAN model |
| posterior | model / samples after seeing the data |
| large | increased number of MCMC samples |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |


")