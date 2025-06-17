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

CODE_DIR := code/results-rl
SOURCE_DATA_DIR := derivatives-beh
EXP_DIRS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 
TARGET_DATA_DIR := results-rl

RUN_DATA := $(CODE_DIR)/src/run_data.r
RUN_STANMODEL := $(CODE_DIR)/src/run_stanmodel.r
RUN_MLE := $(CODE_DIR)/src/run_mle.r
RUN_SAMPLES := $(CODE_DIR)/src/run_samples.r
RUN_MLE_EXTRACT := $(CODE_DIR)/src/run_extract_mle.r
RUN_PLOT_MLE_PPRED := $(CODE_DIR)/src/run_plot_predictive.r

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

DATA := $(TARGET_DATA_DIR)/task-conditioning_standata.rds

$(DATA): \
	$(RUN_DATA) \
	$(EXP_DIRS) \
	$(CODE_DIR)/utils/get_data.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS MODEL
#------------------------------------------------------------------------------

STANMODEL1 := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_stanmodel.rds
STANMODEL2 := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_stanmodel.rds

$(STANMODEL1): \
	$(RUN_STANMODEL) \
	$(CODE_DIR)/stan/rw.stan
	$(RUN_CMD) $^ $@

$(STANMODEL2): \
	$(RUN_STANMODEL) \
	$(CODE_DIR)/stan/hm.stan
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS MLE RESCORLA
#------------------------------------------------------------------------------

MLE1 := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_mle.rds
MLE1_SAMPLES := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_samples.rds
MLE1_EST := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_mle.tsv
MLE1_PLOT_PPRED := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_mle.pdf
MLE1_PLOT_V := $(TARGET_DATA_DIR)/task-conditioning_desc-rw_v.pdf


$(MLE1): \
	$(RUN_MLE) \
	$(STANMODEL1) \
	$(DATA)
	$(RUN_CMD) $^ $@

$(MLE1_SAMPLES): \
	$(RUN_SAMPLES) \
	$(STANMODEL1) \
	$(MLE1) \
	$(DATA)
	$(RUN_CMD) $^ $@

$(MLE1_EST): \
	$(RUN_MLE_EXTRACT) \
	$(MLE1) \
	$(DATA) \
	$(CODE_DIR)/utils/extract_mle_rw.r
	$(RUN_CMD) $^ $@

$(MLE1_PLOT_PPRED): \
	$(RUN_PLOT_MLE_PPRED) \
	$(MLE1_SAMPLES) \
	$(DATA) \
	$(CODE_DIR)/utils/plot_predictive_mle.r
	$(RUN_CMD) $^ $@

$(MLE1_PLOT_V): \
	$(RUN_PLOT_MLE_PPRED) \
	$(MLE1) \
	$(DATA) \
	$(CODE_DIR)/utils/plot_values_mle.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS MLE HYBRID
#------------------------------------------------------------------------------

MLE2 := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_mle.rds
MLE2_SAMPLES := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_samples.rds
MLE2_EST := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_mle.tsv
MLE2_PLOT_PPRED := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_mle.pdf
MLE2_PLOT_V := $(TARGET_DATA_DIR)/task-conditioning_desc-hm_v.pdf


$(MLE2): \
	$(RUN_MLE) \
	$(STANMODEL2) \
	$(DATA)
	$(RUN_CMD) $^ $@

$(MLE2_SAMPLES): \
	$(RUN_SAMPLES) \
	$(STANMODEL2) \
	$(MLE2) \
	$(DATA)
	$(RUN_CMD) $^ $@

$(MLE2_EST): \
	$(RUN_MLE_EXTRACT) \
	$(MLE2) \
	$(DATA) \
	$(CODE_DIR)/utils/extract_mle_hm.r
	$(RUN_CMD) $^ $@

$(MLE2_PLOT_PPRED): \
	$(RUN_PLOT_MLE_PPRED) \
	$(MLE2_SAMPLES) \
	$(DATA) \
	$(CODE_DIR)/utils/plot_predictive_mle.r
	$(RUN_CMD) $^ $@

$(MLE2_PLOT_V): \
	$(RUN_PLOT_MLE_PPRED) \
	$(MLE2) \
	$(DATA) \
	$(CODE_DIR)/utils/plot_values_mle.r
	$(RUN_CMD) $^ $@


#------------------------------------------------------------------------------
# TARGETS ALL
#------------------------------------------------------------------------------
.PHONY: directories all

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(DESCTSV) \
	$(DATA) \
	$(STANMODEL1) \
	$(MLE1) \
	$(MLE1_SAMPLES) \
	$(MLE1_EST) \
	$(MLE1_PLOT_PPRED) \
	$(MLE1_PLOT_V) \
	$(STANMODEL2) \
	$(MLE2) \
	$(MLE2_SAMPLES) \
	$(MLE2_EST) \
	$(MLE2_PLOT_PPRED) \
	$(MLE2_PLOT_V)
