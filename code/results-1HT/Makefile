# GNU Makefile

#------------------------------------------------------------------------------
# RUN CONTAINER
#------------------------------------------------------------------------------
.PHONY: test-docker-r

ENGINE := podman
IMG := rstan:2.32.5

test-docker-r:
	$(ENGINE) run --rm --user=root \
	-it -v $(shell pwd):/home/dockeruser $(IMG) bash

RUN_CMD := \
	$(ENGINE) run --rm --user=root \
	-i -v $(shell pwd):/home/dockeruser $(IMG) Rscript

#------------------------------------------------------------------------------
# LOCAL VARS: CODE
#------------------------------------------------------------------------------

CODE_DIR := code/results-1HT
UTILS_DIR := $(CODE_DIR)/utils
SOURCE_DATA_DIR := derivatives-beh
EXP_DIRS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 
TARGET_DATA_DIR := results-1HT

RUN_DATA := $(CODE_DIR)/src/run_data.r
RUN_STANMODEL := $(CODE_DIR)/src/run_stanmodel.r
RUN_STANFIT_PRIOR := $(CODE_DIR)/src/run_prior_stanfit.r
RUN_STANFIT_POSTERIOR := $(CODE_DIR)/src/run_posterior_stanfit.r
RUN_STANFIT_POSTERIOR_LARGE := $(CODE_DIR)/src/run_posterior_stanfit_large.r
RUN_SUMMARY = $(CODE_DIR)/src/run_summary.r
RUN_PLOT_MCMC = $(CODE_DIR)/src/run_plot_mcmc.r
RUN_PLOT_PREDICTIVE = $(CODE_DIR)/src/run_plot_predictive.r

#------------------------------------------------------------------------------
# TARGETS MODALITY AGNOSTIC FILES
#------------------------------------------------------------------------------

DESC = $(TARGET_DATA_DIR)/dataset_description.json
CHANGELOG = $(TARGET_DATA_DIR)/CHANGES
README = $(TARGET_DATA_DIR)/README.md

$(DESC): \
	$(CODE_DIR)/src/generate_dataset_description.r \
	$(CODE_DIR)/sidecars/dataset_description.r 
	$(RUN_CMD) $^ $@

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog.r \
	$(CODE_DIR)/sidecars/changelog.r 
	$(RUN_CMD) $^ $@

$(README): \
	$(CODE_DIR)/src/generate_readme.r \
	$(CODE_DIR)/sidecars/readme.r 
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS DATA
#------------------------------------------------------------------------------

DATA := $(TARGET_DATA_DIR)/task-recognition_standata.rds

$(DATA): \
	$(RUN_DATA) \
	$(EXP_DIRS) \
	$(CODE_DIR)/utils/get_data.r
	$(RUN_CMD) $^ $@


#------------------------------------------------------------------------------
# TARGETS PRIOR
#------------------------------------------------------------------------------

STANMODEL_PRIOR := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanmodel.rds
STANFIT_PRIOR := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanfit.rds
STANFIT_PRIOR_SMRY := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanfit.txt
STANFIT_PRIOR_MCMC := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanfit.pdf
STANFIT_PRIOR_PRED := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanfit_pred1.pdf
STANFIT_PRIOR_PRED_INT := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_prior_stanfit_pred2.pdf

$(STANMODEL_PRIOR): \
	$(RUN_STANMODEL) \
	$(CODE_DIR)/stan/task-recognition_desc-1HT_prior.stan
	$(RUN_CMD) $^ $@

$(STANFIT_PRIOR): \
	$(RUN_STANFIT_PRIOR) \
	$(STANMODEL_PRIOR) \
	$(DATA) \
	$(UTILS_DIR)/select_parnames.r
	$(RUN_CMD) $^ $@

$(STANFIT_PRIOR_SMRY): \
	$(RUN_SUMMARY) \
	$(STANFIT_PRIOR) \
	$(UTILS_DIR)/select_summary_parnames.r
	$(RUN_CMD) $^ $@

$(STANFIT_PRIOR_MCMC): \
	$(RUN_PLOT_MCMC) \
	$(STANFIT_PRIOR) \
	$(UTILS_DIR)/select_plot_parnames.r \
	$(UTILS_DIR)/utils_plot_mcmc_chains.r
	$(RUN_CMD) $^ $@

$(STANFIT_PRIOR_PRED): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_PRIOR) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive.r
	$(RUN_CMD) $^ $@

$(STANFIT_PRIOR_PRED_INT): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_PRIOR) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive_interval.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS POSTERIOR
#------------------------------------------------------------------------------

STANMODEL_POSTERIOR := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanmodel.rds
STANFIT_POSTERIOR := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit.rds
STANFIT_POSTERIOR_SMRY := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit.txt
STANFIT_POSTERIOR_MCMC := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit.pdf
STANFIT_POSTERIOR_PRED := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_pred1.pdf
STANFIT_POSTERIOR_PRED_INT := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_pred2.pdf

$(STANMODEL_POSTERIOR): \
	$(RUN_STANMODEL) \
	$(CODE_DIR)/stan/task-recognition_desc-1HT_posterior.stan
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR): \
	$(RUN_STANFIT_POSTERIOR) \
	$(STANMODEL_POSTERIOR) \
	$(DATA) \
	$(UTILS_DIR)/select_parnames.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_SMRY): \
	$(RUN_SUMMARY) \
	$(STANFIT_POSTERIOR) \
	$(UTILS_DIR)/select_summary_parnames.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_MCMC): \
	$(RUN_PLOT_MCMC) \
	$(STANFIT_POSTERIOR) \
	$(UTILS_DIR)/select_plot_parnames.r \
	$(UTILS_DIR)/utils_plot_mcmc_chains.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_PRED): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_POSTERIOR) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_PRED_INT): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_POSTERIOR) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive_interval.r
	$(RUN_CMD) $^ $@


#------------------------------------------------------------------------------
# TARGETS POSTERIOR LARGE
#------------------------------------------------------------------------------

STANFIT_POSTERIOR_L := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_large.rds
STANFIT_POSTERIOR_L_MCMC := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_large.pdf
STANFIT_POSTERIOR_L_PRED := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_large_pred1.pdf
STANFIT_POSTERIOR_L_PRED_INT := $(TARGET_DATA_DIR)/task-recognition_desc-1HT_posterior_stanfit_large_pred2.pdf


$(STANFIT_POSTERIOR_L): \
	$(RUN_STANFIT_POSTERIOR_LARGE) \
	$(STANMODEL_POSTERIOR) \
	$(DATA) \
	$(UTILS_DIR)/select_parnames.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_L_MCMC): \
	$(RUN_PLOT_MCMC) \
	$(STANFIT_POSTERIOR_L) \
	$(UTILS_DIR)/select_plot_parnames.r \
	$(UTILS_DIR)/utils_plot_mcmc_chains.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_L_PRED): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_POSTERIOR_L) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive.r
	$(RUN_CMD) $^ $@

$(STANFIT_POSTERIOR_L_PRED_INT): \
	$(RUN_PLOT_PREDICTIVE) \
	$(STANFIT_POSTERIOR_L) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive_interval.r
	$(RUN_CMD) $^ $@


#------------------------------------------------------------------------------
# TARGETS ALL
#------------------------------------------------------------------------------
.PHONY: directories all large

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(DATA) \
	$(STANMODEL_PRIOR) \
	$(STANFIT_PRIOR) \
	$(STANFIT_PRIOR_SMRY) \
	$(STANFIT_PRIOR_MCMC) \
	$(STANFIT_PRIOR_PRED) \
	$(STANFIT_PRIOR_PRED_INT) \
	$(STANMODEL_POSTERIOR) \
	$(STANFIT_POSTERIOR) \
	$(STANFIT_POSTERIOR_SMRY) \
	$(STANFIT_POSTERIOR_MCMC) \
	$(STANFIT_POSTERIOR_PRED) \
	$(STANFIT_POSTERIOR_PRED_INT)

large: directories \
	$(DATA) \
	$(STANMODEL_POSTERIOR) \
	$(STANFIT_POSTERIOR_L) \
	$(STANFIT_POSTERIOR_L_MCMC) \
	$(STANFIT_POSTERIOR_L_PRED) \
	$(STANFIT_POSTERIOR_L_PRED_INT)
