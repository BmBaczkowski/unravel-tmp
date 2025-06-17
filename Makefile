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
# FIT MODELS
#------------------------------------------------------------------------------
.PHONY: fit-mdls

# to fit model with large number of MCMC samples, set LARGE=yes
fit-mdls: derivatives
	@echo ""
	@echo "Fitting models..."
	@echo ""
	$(MAKE) -j $(CORES) -f code/results-mdl/Makefile all LARGE=no

#------------------------------------------------------------------------------
# RUN CROSS-VALIDATION
#------------------------------------------------------------------------------
.PHONY: kfold

kfold: fit-mdls
	@echo ""
	@echo "5-fold cross validation..."
	@echo ""
	$(MAKE) -f code/results-mdl-kfold/Makefile all

#------------------------------------------------------------------------------
# RUN KOHONEN 
#------------------------------------------------------------------------------
.PHONY: kohonen

# to fit model with large number of MCMC samples, set LARGE=yes
kohonen: fit-mdls
	@echo ""
	@echo "Kohonen..."
	@echo ""
	$(MAKE) -f code/results-kohonen/Makefile all LARGE=no

#------------------------------------------------------------------------------
# FIT MIXTURE MODELS
#------------------------------------------------------------------------------
.PHONY: fit-mixture

# to fit model with large number of MCMC samples, set LARGE=yes
fit-mixture: fit-mdls
	@echo ""
	@echo "Fitting mixture models..."
	@echo ""
	$(MAKE) -f code/results-mixture/Makefile all LARGE=no


#------------------------------------------------------------------------------
# EXTRACT COVARIATES
#------------------------------------------------------------------------------
.PHONY: mixture-covs

# to fit model with large number of MCMC samples, set LARGE=yes
mixture-covs: fit-mixture RL
	@echo ""
	@echo "Fitting mixture models..."
	@echo ""
	$(MAKE) -f code/results-mixture-covariates/Makefile all LARGE=no

#------------------------------------------------------------------------------
# FIT GP MODELS
#------------------------------------------------------------------------------
.PHONY: GP-rw GP-scr-avg GP-scr_delta

# to fit model with large number of MCMC samples, set LARGE=yes
# with alpha learning rate from Rescorla-Wagner model
GP-rw: derivatives mixture-covs
	@echo ""
	@echo "Fitting GP models (RW)..."
	@echo ""
	$(MAKE) -f code/results-gp/Makefile all VAR=rw LARGE=no

# with SCR (difference between CS+ vs CS-)
GP-scr-delta: derivatives mixture-covs
	@echo ""
	@echo "Fitting GP models (SCR delta)..."
	@echo ""
	$(MAKE) -f code/results-gp/Makefile all VAR=scr_delta LARGE=no

# with SCR (average across CS+ and CS-)
GP-scr-avg: derivatives mixture-covs
	@echo ""
	@echo "Fitting GP models (SCR average)..."
	@echo ""
	$(MAKE) -f code/results-gp/Makefile all VAR=scr_avg LARGE=no


#------------------------------------------------------------------------------
# PLOTS
#------------------------------------------------------------------------------
.PHONY: plots

# set to LARGE=yes if a model with large number of MCMC samples is preferred
plots: 
	$(MAKE) -f code/plots-reproducibility/Makefile all 
	$(MAKE) -f code/plots-mdl/Makefile all LARGE=no
	$(MAKE) -f code/plots-kohonen/Makefile all
	$(MAKE) -f code/plots-mixture/Makefile all LARGE=no
	$(MAKE) -f code/plots-gp/Makefile all LARGE=no

#------------------------------------------------------------------------------
# RUN ALL ANALYSES (default LARGE=no)
#------------------------------------------------------------------------------
.PHONY: all

all: \
	repro \
	RL \
	fit-mdls \
	kfold \
	kohonen \
	fit-mixture \
	mixture-covs \
	GP-rw \
	GP-scr-delta

