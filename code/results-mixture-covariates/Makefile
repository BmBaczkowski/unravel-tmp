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

CODE_DIR := code/results-mixture-covariates
TARGET_DIR := results-mixture-covariates
TARGET_DATA_DIR := results-mixture

SOURCE_DATA_DIR_RAW := data-raw
EXP_DIRS_RAW := \
	$(SOURCE_DATA_DIR_RAW)/study-01 \
	$(SOURCE_DATA_DIR_RAW)/study-02 \
	$(SOURCE_DATA_DIR_RAW)/study-03 \
	$(SOURCE_DATA_DIR_RAW)/study-04 

SOURCE_DATA_DIR := derivatives-beh
EXP_DIRS_DERIVS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 

SOURCE_SCR_DATA_DIR := derivatives-scr
SCR_SOURCE_TSVs := \
	$(SOURCE_SCR_DATA_DIR)/exp1.tsv \
	$(SOURCE_SCR_DATA_DIR)/exp2.tsv \
	$(SOURCE_SCR_DATA_DIR)/exp3.tsv \
	$(SOURCE_SCR_DATA_DIR)/exp4.tsv

RW_SOURCE := results-rl/task-conditioning_desc-rw_mle.tsv

RUN_DATA := $(CODE_DIR)/src/run_data.r

#------------------------------------------------------------------------------
# TARGETS MODALITY AGNOSTIC FILES
#------------------------------------------------------------------------------

DESC = $(TARGET_DIR)/dataset_description.json
CHANGELOG = $(TARGET_DIR)/CHANGES
README = $(TARGET_DIR)/README.md

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

DATA := $(TARGET_DIR)/covariates.rds

$(DATA): \
	$(RUN_DATA) \
	$(EXP_DIRS_RAW) \
	$(EXP_DIRS_DERIVS) \
	$(SCR_SOURCE_TSVs) \
	$(RW_SOURCE) \
	$(CODE_DIR)/utils/get_data.r
	$(RUN_CMD) $^ $@


# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
SAMPLES := posterior_large
else
SAMPLES := posterior
endif

MDLS := 1HT 2HT SDT
N := $(words $(MDLS))

STANFITS := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.rds)
SAMPLES_COVS := $(foreach mdl,$(MDLS),$(TARGET_DIR)/p_z_covariates_$(mdl)_$(SAMPLES)_stanfit.rds)
PLOTS := $(foreach mdl,$(MDLS),$(TARGET_DIR)/ecdf_$(mdl)_$(SAMPLES)_plot.pdf)

# for stanmodels
define extract
$(1): \
	$(CODE_DIR)/src/extract_p_z.r \
	$(2) \
	$(DATA)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call extract,\
$(word $(i),$(SAMPLES_COVS)),\
$(word $(i),$(STANFITS))\
)\
)\
)

# for histograms
define plot
$(1): \
	$(CODE_DIR)/src/plot_hist.r \
	$(2)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call plot,\
$(word $(i),$(PLOTS)),\
$(word $(i),$(SAMPLES_COVS))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS ALL
#------------------------------------------------------------------------------
.PHONY: directories all

directories:
	mkdir -p $(TARGET_DIR)

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(DATA) \
	$(SAMPLES_COVS) \
	$(PLOTS)

