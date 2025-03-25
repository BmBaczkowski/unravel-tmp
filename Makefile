# GNU Makefile

#------------------------------------------------------------------------------
# LOCAL VARS
#------------------------------------------------------------------------------
ENGINE := podman
IMG := rstan:2.32.5
CORES := 4

RUN_CMD := \
	$(ENGINE) run --rm --user=root \
	-i -v $(shell pwd):/home/dockeruser $(IMG) Rscript

#------------------------------------------------------------------------------
# TEST DOCKER
#------------------------------------------------------------------------------
.PHONY: test-docker-r

# Test docker container
test-docker-r:
	$(ENGINE) run --rm --user=root \
	-it -v $(shell pwd):/home/dockeruser $(IMG) bash

#------------------------------------------------------------------------------
# DOWNLOAD SOURCE DATA 
#------------------------------------------------------------------------------
.PHONY: download

download:
	$(MAKE) -f code/data-source/Makefile all

#------------------------------------------------------------------------------
# TRANSFORM SOURCE -> RAW
#------------------------------------------------------------------------------
.PHONY: raw

raw: 
	@echo ""
	@echo "Transforming source data into raw data..."
	@echo ""
	$(MAKE) -j $(CORES) -f code/data-raw/Makefile all

#------------------------------------------------------------------------------
# GENERATE DERIVATIVES FROM BEH RAW DATA
#------------------------------------------------------------------------------
.PHONY: derivatives

derivatives: raw
	@echo ""
	@echo "Generating derivatives..."
	@echo ""
	$(MAKE) -j $(CORES) -f code/derivatives-beh/Makefile all

#------------------------------------------------------------------------------
# TEST REPRODUCIBILITY ON RECOGNITION DATA
#------------------------------------------------------------------------------
.PHONY: repro

repro: derivatives
	@echo ""
	@echo "Testing reproducibility..."
	@echo ""
	$(MAKE) -j $(CORES) -f code/results-reproducibility/Makefile all


#------------------------------------------------------------------------------
# FIT REINFORCEMENT LEARNING MODELS
#------------------------------------------------------------------------------
.PHONY: RL

RL: derivatives
	@echo ""
	@echo "Fitting RL models..."
	@echo ""
	$(MAKE) -j $(CORES) -f code/results-rl/Makefile all

#------------------------------------------------------------------------------
# GRAPHICAL MODELS
#------------------------------------------------------------------------------
.PHONY: mdls

mdls: 
	$(MAKE) -f code/docs-mdl/Makefile all


#------------------------------------------------------------------------------
# FIT 1HT MODEL
#------------------------------------------------------------------------------
.PHONY: 1HT

1HT: derivatives mdls
	@echo ""
	@echo "Fitting 1HT model..."
	@echo ""
	$(MAKE) -f code/results-1HT/Makefile all

# to fit model with large number of MCMC samples, use
# $(MAKE) -f code/results-1HT/Makefile large

#------------------------------------------------------------------------------
# FIT 1HT MODEL EXTENDED WITH GP
#------------------------------------------------------------------------------
.PHONY: GP

GP: derivatives mdls
	@echo ""
	@echo "Fitting 1HT model extended with GP..."
	@echo ""
	$(MAKE) -f code/results-gp/Makefile all

# to fit model with large number of MCMC samples, use
# $(MAKE) -f code/results-gp/Makefile large
# this takes about 3 hours on my machine

#------------------------------------------------------------------------------
# RUN KOHONEN 
#------------------------------------------------------------------------------
.PHONY: kohonen

kohonen: 1HT
	@echo ""
	@echo "Kohonen..."
	@echo ""
	$(MAKE) -f code/results-kohonen/Makefile all

# requires large MCMC samples from 1HT to reproduce the reported results
# $(MAKE) -f code/results-kohonen/Makefile all LARGE=1

#------------------------------------------------------------------------------
# FIT MIXTURE 1HT
#------------------------------------------------------------------------------
.PHONY: mixture

mixture: derivatives mdls
	@echo ""
	@echo "Fitting mixture 1HT model..."
	@echo ""
	$(MAKE) -f code/results-mixture/Makefile all

# to fit model with large number of MCMC samples, use
# $(MAKE) -f code/results-mixture/Makefile large
# this takes about 3 hours on my machine

#------------------------------------------------------------------------------
# PLOTS
#------------------------------------------------------------------------------
.PHONY: plots plots_large

plots: 
	$(MAKE) -f code/plots-reproducibility/Makefile all
	$(MAKE) -f code/plots-1HT/Makefile all
	$(MAKE) -f code/plots-kohonen/Makefile all
	$(MAKE) -f code/plots-mixture/Makefile all
	$(MAKE) -f code/plots-gp/Makefile all

plots_large: 
	$(MAKE) -f code/plots-reproducibility/Makefile all
	$(MAKE) -f code/plots-1HT/Makefile all SLOW=1
	$(MAKE) -f code/plots-kohonen/Makefile all LARGE=1
	$(MAKE) -f code/plots-mixture/Makefile all SLOW=1
	$(MAKE) -f code/plots-gp/Makefile all SLOW=1
