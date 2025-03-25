
# Title [UNRAVEL]

![Version](https://img.shields.io/badge/version-1.0.0-informational)
[![License](https://img.shields.io/badge/license-CC%20BY--4.0-informational)](https://creativecommons.org/licenses/by/4.0/)
[![Publication Status](https://img.shields.io/badge/publication-preprint-orange)](link)
[![DOI Dataset](https://img.shields.io/badge/source%20data-OSF-informational)](https://osf.io/qpm3t/)
[![BIDS](https://img.shields.io/badge/BIDS-v1.8.0-informational)](https://bids-specification.readthedocs.io/en/v1.8.0/)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-informational)
[![GNU Make Required](https://img.shields.io/badge/requirement-GNU%20make-informational)](https://www.gnu.org/software/make/)
![Container](https://img.shields.io/badge/container-Docker%20%7C%20Podman-informational)
[![Rocker](https://img.shields.io/badge/image-rocker%2Frstudio%3A4.3.2-blue)](https://rocker-project.org/)
[![RStan](https://img.shields.io/badge/software-rstan%3A2.32.5-blue)](https://mc-stan.org/users/interfaces/rstan)

## Description

- Authors: Blazej M. Baczkowski [![ORCID](https://orcid.org/sites/default/files/images/orcid_16x16.png)](https://orcid.org/0000-0002-1825-0097)
- Date: 2024-11-23
- E-mail: bm [dot] baczkowski [at] gmail [dot] com

This is a research compendium for the project XYZ. 
The compendium is organised based on [BIDS](https://bids-specification.readthedocs.io/en/v1.8.0/) standard, but not fully compatible due to custom workflows. 

The results are based on the original dataset sourced from OSF repository [Kalbe and Schwabe](https://osf.io/qpm3t/) shared under CC-BY license and reported in the paper by [Kalbe and Schwabe (2022)](https://doi.org/10.1037/xge0001075). 


## Directory structure

```plaintext
./
|-- README.md                    # Overview and documentation
|-- CHANGES                      # Log of changes and updates
|-- description.json             # Project metadata
|-- Makefile                     # Master workflow to reproduce the repository
|-- code/                        # Code with individual workflows for each analysis component
|-- data-raw/                    # Raw data that has been minimally preprocessed
|-- data-source/                 # Source data directly downloaded from OSF (not included)
|-- derivatives-beh/             # Preprocessed behavioral data (input for the analyses)
|-- derivatives-scr/             # Preprocessed skin conductance response (SCR) data obtained upon request (input for the analysis)
|-- dockerfiles/                 # Dockerfiles to build the computing environment
|-- docs-mdl/                    # Documentation: bayesian graphical models
|-- plots-1HT/                   # Plots of the bayesian 1HT model of memory recognition
|-- plots-gp/                    # Plots of the extended bayesian 1HT with multi-output gaussian process
|-- plots-kohonen/               # Plots of the kohonen self-organizing map used fot clustering
|-- plots-mixture/               # Plots of the extended 1HT model of memory recognition with latent mixture of two groups
|-- plots-reproducibility/       # Plots of the reproducibility section
|-- results-1HT/                 # Results of the bayesian 1HT model of memory recognition
|-- results-gp/                  # Results of the extended bayesian 1HT with multi-output gaussian process
|-- results-kohonen/             # Results of the kohonen self-organizing map used fot clustering
|-- results-mixture/             # Results of the extended 1HT model of memory recognition with latent mixture of two groups
|-- results-reproducibility/     # Results of the reproducibility process
|-- results-rl/                  # Results of the reinforcement learning models (threat conditioning)
```

## Prerequisites        

To successfully reproduce the analysis in this repository, ensure that you have the following tools installed:
1. **GNU Make:** This is used to automate the build process of the project.
2. **Docker/Podman**: Docker / Podman is used to create a containerized environment where the analysis runs in an isolated environment with all necessary dependencies. This approach also isolates the analysis from the host system.

The code was executed with `GNU Make 3.81` and `podman version 5.0.2` on `macOS Ventura 13.6.7 (22G720)` with an Apple M2 Pro chip. If you do not have `podman` installed, you can modify the `Makefile` to use the appropriate container engine (e.g., `docker`). Simply modify the variable `ENGINE` in the `Makefile`.

### Podman Machine Info

| Parameter      | Value                        |
|----------------|------------------------------|
| **OsArch** | linux/arm64: 5.0.3 | 
| **Kernel**     | 6.8.8-300.fc40.aarch64 |
| **CPUs**       | 8 |
| **Memory**     | 32 GB |
| **Disk Size**  | 100 GB |


## Getting Started

### Build the image

A `Dockerfile` is provided in the `dockerfiles` directory. To build the image, navigate to the `dockerfiles` directory and run:
```bash 
cd dockerfiles
make build-docker-r
```

This will create an image called `rstan:2.32.5` that contains all the dependencies needed to run the analysis.

To test the container, run:
```bash 
make test-docker-r
```

### Run the code with `GNU Make`

Once you have the Docker image built, you can use `GNU Make` to run the analysis inside the Docker container. `Make` will automate the process and ensure the proper environment is used.

#### Rebuild everything (not-recommended)

To run all the models: 
```bash 
make all
```

This may overkill your system. By default, small MCMC sampling is performed. 

#### Rebuild specific outcome folders (recommended)

Open master `Makefile` and decide what you want to rebuild. For example:
```bash 
# to download the source data from OSF repository
make download

# to fit 1HT bayesian model (requires data and other pre-requisits)
make 1HT
```


## License 

<p xmlns:cc="http://creativecommons.org/ns#" >This work is licensed under <a href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""></a></p>

## Acknowledgment

Special thanks to Dr. Felix Kalbe for sharing the original dataset.

B.M.B is supported by xyz. 

## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075


