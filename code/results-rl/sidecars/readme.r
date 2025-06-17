require(glue)

readme <- glue("

# Info

Reinforcement learning models were fitted to behavioral data from a threat conditioning task. These models aimed to predict binary responses indicating shock expectation per condition (CS+ / CS-).
We estimated the model parameters by maximizing the posterior density using the L-BFGS algorithm, rather than employing Markov Chain Monte Carlo (MCMC) methods to sample from the full posterior distribution. 
This approach was selected to obtain point estimates of the parameters. 
Since the priors were weakly informative and the primary aim was point estimation rather than comprehensive uncertainty quantification, maximum a posteriori (MAP) estimation offered a practical and statistically valid solution. 
To assess the adequacy of the point estimates in capturing the observed behavioral patterns, we performed posterior predictive checks. 
Specifically, we visually examined changes in associative strength across trials per condition and calculated the average proportion of shock expectancy across individuals in three trial bins: 1–10, 11–20, and 21–30 trials per condition. 



### Rescorla-Wagner model

$$
x_t = x_{{t-1}} + \\alpha (u_{{t-1}} - x_{{t-1}})
$$

The Rescorla-Wagner (RW) model describes the process of updating predictions of the unconditioned stimulus (US) using a trial-by-trial approach. At each trial, the associative strength $x_t$ represents the prediction of the US, and it is updated based on the signed prediction error, which is the difference between the current prediction $x_t$ and the observed sensory input $u_t$. This prediction error is scaled by a learning rate $\\alpha$, a subject-specific parameter that controls the rate of update. The learning rate is constrained such that $0 < \\alpha < 1$, and it is applied equally to both conditioned stimuli (CS+ and CS-), governing how quickly the subject adjusts their expectations based on previous experiences.

Since the US is binary, $u_t$ takes values 1 (present) or 0 (absent). At the start of the task, we assume that participants have no prior expectation about the stimuli, setting the initial associative strength $x_0$ to 0.5 for both CS+ and CS-.

The model interprets the associative strength $x_t$ as the participant's belief about the probability of the US being present, which corresponds to the probability of a binary response $y_t$. The response is modeled as a Bernoulli-distributed outcome:
$$
y_t \\sim Bernoulli(\\theta_t)
$$
where $\\theta_t = x_t$.

We implement the RW rule within a hierarchical framework, where each participant has an individual learning rate $\\alpha$, modeled as a random variable drawn from a normal distribution with population mean $\\mu$ and variance $\\tau$ in the logit space:
$$
\\alpha \\sim Normal(\\mu, \\tau)
$$
We place weakly informative priors on the population parameters:
$$
\\mu \\sim Normal(0, 2)
$$
$$
\\tau \\sim Gamma(5, 10)
$$

Posterior predictive checks showed that the model consistently predicted slightly higher probabilities than the data shows but within a reasonable range. 
This is likely because the model uses a simple RW rule with a shared learning rate across conditions, and updates both CSs gradually over trials -- it tends to be a bit slower or smoother than the actual behaviour, which can look sharper or more jumpy. 
Specifically, the model seems to perform underfitting on CS- condition -- individuals may  learn to actively suppress expectation more quickly than the RW model allows or are just more deterministic in saying 'no shock.' 


### Hybrid model: Rescorla-Wagner and Pearce-Hall

The Rescorla-Wagner (RW) and Pearce-Hall (PH) models can be integrated into a hybrid model (HM) that incorporates elements of both approaches. This hybrid model retains the signed prediction error concept from the RW rule while introducing an additional term, $\\eta_t$, which represents a dynamic learning rate. The learning rate $\\eta_t$ evolves throughout the experiment according to the following equations:

$$
\\eta_t = \\alpha * |x_{{t-1}} - u_{{t-1}} | + (1-\\alpha) * \\eta_{{t-1}}
$$

$$
x_t = x_{{t-1}} + \\eta_{{t-1}} * (u_{{t-1}} - x_{{t-1}})
$$

Here, $\\alpha$ is a participant-specific positive scaling parameter shared across both conditioned stimuli (CS), capturing how quickly predictions are updated, with the constraint $0 < \\alpha < 1$. Consistent with the RW model, we assumed participants had no specific expectations about the two stimuli, setting the initial associative strengths at $x_0 = 0.5$ for both CS+ and CS-.

As with the RW model, we interpret the associative strength ($x_t$) as the participant's belief about the probability of US presence. This belief determines the likelihood of a binary response ($y_t$), modeled as:
$y_t \\sim Bernoulli(\\theta_t)$, where $\\theta_t = x_t$.

We implement the model within a hierarchical framework, where each participant has an individual scaling parameter $\\alpha$, modeled as a random variable drawn from a normal distribution with population mean $\\mu$ and variance $\\tau$ in the logit space:
$$
\\alpha \\sim Normal(\\mu, \\tau)
$$
We place weakly informative priors on the population parameters:
$$
\\mu \\sim Normal(0, 2)
$$
$$
\\tau \\sim Gamma(5, 10)
$$

Similarly, each participant has an initial value of the dynamic learning rate $\\eta$ sampled from a normal distribution with the population mean $\\mu$ and variance $\\tau$.
 $$
\\eta \\sim Normal(\\mu, \\tau)
$$
We place weakly informative priors on the population parameters of the $\\eta$:
$$
\\mu \\sim Normal(0, 1.5)
$$
$$
\\tau \\sim Gamma(5, 10)
$$

Posterior predictive checks showed similar underfitting as the baselin RW model indicating slightly lower (CS+) or higher (CS-) probabilities than the data shows but within a reasonable range.


## Directory structure

```plaintext
./
|-- CHANGES
|-- README.md
|-- dataset_description.json
|-- task-conditioning_desc-hm_mle.pdf
|-- task-conditioning_desc-hm_mle.rds
|-- task-conditioning_desc-hm_mle.tsv
|-- task-conditioning_desc-hm_samples.rds
|-- task-conditioning_desc-hm_stanmodel.rds
|-- task-conditioning_desc-hm_v.pdf
|-- task-conditioning_desc-rw_mle.pdf
|-- task-conditioning_desc-rw_mle.rds
|-- task-conditioning_desc-rw_mle.tsv
|-- task-conditioning_desc-rw_samples.rds
|-- task-conditioning_desc-rw_stanmodel.rds
|-- task-conditioning_desc-rw_v.pdf
|-- task-conditioning_standata.rds
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| rw | Rescorla-Wagner model |
| hm | hybrid model |
| v | estimated values per RL model |
| mle | maximum likelihood estimation |
| samples | responses generated based on MAP |
| stanmodel | compiled STAN model |
| standata | data structure needed for STAN model |

### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.tsv` | tabular structure (tab-separated values) |

## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075

Tzovara, A., Korn, C. W., & Bach, D. R. (2018). Human Pavlovian fear conditioning conforms to probabilistic learning. In S. J. Gershman (Ed.), PLOS Computational Biology (Vol. 14, Issue 8, p. e1006243). Public Library of Science (PLoS). https://doi.org/10.1371/journal.pcbi.1006243

")