require(glue)

readme <- glue("

# Info

One high threshold model of recognition judgment was fitted to behavioral data from 24-hour memory recognition test, utilizing bayesian sampling with MCMC implemented in STAN. 

## Bayesian graphical model

Bayesian cognitive model is depicted using graphical models (Lee & Wagenmakers, 2013). 
<a href='../docs-mdl/mdl_1HT.pdf' target='_blank'>View graphical model (pdf file).</a>

The graphical model represents the dependencies between observed data and latent parameters. It consists of nodes and directed edges, where nodes represent random variables (both observed and unobserved), and edges represent probabilistic / deterministic dependencies between these variables.

| variable | comment |
| --- | --- |
| $i$ | index for a participant |
| $j$ | index for an experimental condition (old items) |
| $k$ | index for an experimental condition (new items) |
| $n_{{ij}}^{{old}}$ | total number of old items |
| $n_{{ik}}^{{new}}$ | total number of new items |
| $y_{{ij}}$ | total number of responses indicating 'old' to old items |
| $y_{{ik}}$ | total number of responses indicating 'old' to new items |
| $\\theta_{{ij}}$ | probability of responding 'old' to old items |
| $\\theta_{{ik}}$ | probability of responding 'old' to new items |
| $\\rho_{{ij}}$ | strength of memory trace / probability of recognition state |
| $\\gamma_{{ik}}$ | guessing / bias towards 'old'  |
| $\\beta_{{ij}}$ | individual $\\beta$ weights (see design matrix $X_{{ij}}$)|
| $\\alpha_{{ik}}$ | individual $\\alpha$ weights (see design matrix $X_{{ik}}$)|
| $X_{{ij}}^{{\\beta}}$ | design matrix that transforms $\\beta$ weights to $\\rho$ |
| $X_{{ik}}^{{\\beta}}$ | design matrix that transforms $\\alpha$ weights to $\\gamma$ |
| $\\eta^{{\\rho}}$ | adjustment for the effect of a semantic category on $\\rho$ |
| $\\eta^{{\\gamma}}$ | adjustment for the effect of a semantic category on $\\gamma$ |
| $u_{{j}}^{{\\beta}}$ | adjustment for the effect of a study on $\\beta$ weights |
| $u_{{k}}^{{\\alpha}}$ | adjustment for the effect of a study on $\\alpha$ weights |
| $\\mu_{{j}}^{{\\beta}}$ | population expectation of the $\\beta$ weights |
| $\\mu_{{k}}^{{\\alpha}}$ | population expectation of the $\\alpha$ weights |
| $\\Sigma_{{jj}}^{{\\beta}}$ | variance-covariance matrix for participants' adjustments of the $\\beta$ weights |
| $\\Sigma_{{kk}}^{{\\alpha}}$ | variance-covariance matrix for participants' adjustments of the $\\alpha$ weights |
| $\\tau_{{j}}^{{\\beta}}$ | variance among participants in adjustments of the $\\beta$ weights |
| $\\tau_{{k}}^{{\\alpha}}$ | variance among participants in adjustments of the $\\alpha$ weights |
| $R_{{jj}}^{{\\beta}}$ | correlation between participants' adjustments of the $\\beta$ weights |
| $R_{{kk}}^{{\\alpha}}$ | correlation between participants' adjustments of the $\\alpha$ weights |


## Directory structure

```plaintext
./
|-- CHANGES
|-- README.md
|-- dataset_description.json
|-- task-recognition_desc-1HT_posterior_stanfit.pdf
|-- task-recognition_desc-1HT_posterior_stanfit.rds
|-- task-recognition_desc-1HT_posterior_stanfit.txt
|-- task-recognition_desc-1HT_posterior_stanfit_pred1.pdf
|-- task-recognition_desc-1HT_posterior_stanfit_pred2.pdf
|-- task-recognition_desc-1HT_posterior_stanfit_large.pdf
|-- task-recognition_desc-1HT_posterior_stanfit_large.rds
|-- task-recognition_desc-1HT_posterior_stanfit_large_pred1.pdf
|-- task-recognition_desc-1HT_posterior_stanfit_large_pred2.pdf
|-- task-recognition_desc-1HT_posterior_stanmodel.rds
|-- task-recognition_desc-1HT_prior_stanfit.pdf
|-- task-recognition_desc-1HT_prior_stanfit.rds
|-- task-recognition_desc-1HT_prior_stanfit.txt
|-- task-recognition_desc-1HT_prior_stanfit_pred1.pdf
|-- task-recognition_desc-1HT_prior_stanfit_pred2.pdf
|-- task-recognition_desc-1HT_prior_stanmodel.rds
|-- task-recognition_standata.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| standata | data structure needed for STAN model |
| stanmodel | compiled STAN model |
| stanfit | MCMC samples after fiting STAN model |
| prior | model / samples before seeing the data |
| posterior | model / samples after seeing the data |
| pred | prior / posterior predictive data |
| large | increased number of MCMC samples |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |

## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075

Lee, M.D., & Wagenmakers, E.-J. (2013). Bayesian Cognitive Modeling: A Practical Course. Cambridge University Press.

")