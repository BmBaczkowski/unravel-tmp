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

CODE_DIR := code/results-mdl-kfold
UTILS_DIR := $(CODE_DIR)/utils
SOURCE_DATA_DIR := results-mdl
DATA_SOURCE := $(SOURCE_DATA_DIR)/task-recognition_standata.rds
TARGET_DATA_DIR := results-mdl-kfold

RUN_DATA := $(CODE_DIR)/src/run_data.r
RUN_STANMODEL := $(CODE_DIR)/src/run_stanmodel.r
RUN_TRAIN = $(CODE_DIR)/src/run_train_stanfit.r
RUN_TEST = $(CODE_DIR)/src/run_test_stanfit.r
RUN_ELPD_COMP = $(CODE_DIR)/src/run_elpd_comparison.r
#------------------------------------------------------------------------------
# LOCAL VARS
#------------------------------------------------------------------------------


MDLS := 1HT 2HT SDT
FOLDS := 1 2 3 4 5

STANFILES_TRAIN := $(foreach mdl,$(MDLS),$(CODE_DIR)/stan/task-recognition_desc-$(mdl)_posterior.stan)
STANMODELS_TRAIN := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_posterior_stanmodel.rds)
STANMODELS_TRAIN_ALL := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_posterior_stanmodel.rds))
STANFITS_TRAIN := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(k)_posterior_stanfit.rds))

STANFILES_TEST := $(foreach mdl,$(MDLS),$(CODE_DIR)/stan/task-recognition_desc-$(mdl)_holdout.stan)
STANMODELS_TEST := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_holdout_stanmodel.rds)
STANMODELS_TEST_ALL := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_holdout_stanmodel.rds))
STANFITS_TEST := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(k)_holdout_stanfit.rds))

PARNAMES := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(UTILS_DIR)/select_parnames_$(mdl)_posterior.r))
FOLDS_TYPE := $(foreach mdl,$(MDLS),$(foreach k,$(FOLDS),$(k)))
N_MDLS := $(words $(MDLS))
N_FOLDS := $(words $(FOLDS))
N := $(words $(STANFITS_TRAIN))
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

DATA := $(TARGET_DATA_DIR)/task-recognition_standata_kfold.rds

$(DATA): \
	$(RUN_DATA) \
	$(DATA_SOURCE) \
	$(CODE_DIR)/utils/kfold_data.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------

# for stanmodels
define make_mdls
$(1): \
	$(RUN_STANMODEL) \
	$(2)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N_MDLS)),\
$(eval \
$(call make_mdls,\
$(word $(i),$(STANMODELS_TRAIN)),\
$(word $(i),$(STANFILES_TRAIN))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N_MDLS)),\
$(eval \
$(call make_mdls,\
$(word $(i),$(STANMODELS_TEST)),\
$(word $(i),$(STANFILES_TEST))\
)\
)\
)

# for training
define train_mdls
$(1): \
	$(RUN_TRAIN) \
	$(2) \
	$(DATA) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef


$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call train_mdls,\
$(word $(i),$(STANFITS_TRAIN)),\
$(word $(i),$(STANMODELS_TRAIN_ALL)),\
$(word $(i),$(PARNAMES)),\
$(word $(i),$(FOLDS_TYPE))\
)\
)\
)

# for testing
define test_mdls
$(1): \
	$(RUN_TEST) \
	$(2) \
	$(DATA) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call test_mdls,\
$(word $(i),$(STANFITS_TEST)),\
$(word $(i),$(STANMODELS_TEST_ALL)),\
$(word $(i),$(STANFITS_TRAIN)),\
$(word $(i),$(FOLDS_TYPE))\
)\
)\
)

#------------------------------------------------------------------------------
# COMPARISONS
#------------------------------------------------------------------------------

HOLDOUT_2HT := $(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-2HT_$(k)_holdout_stanfit.rds)
HOLDOUT_1HT := $(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-1HT_$(k)_holdout_stanfit.rds)
HOLDOUT_SDT := $(foreach k,$(FOLDS),$(TARGET_DATA_DIR)/task-recognition_desc-SDT_$(k)_holdout_stanfit.rds)

ELPD_2HT_1HT := $(TARGET_DATA_DIR)/task-recognition_desc-2HTvs1HT_elpd.rds
ELPD_2HT_SDT := $(TARGET_DATA_DIR)/task-recognition_desc-2HTvsSDT_elpd.rds
ELPD_1HT_SDT := $(TARGET_DATA_DIR)/task-recognition_desc-1HTvsSDT_elpd.rds

# for ELPD comparison rule
define compare_elpd
$(1): \
	$(RUN_ELPD_COMP) \
	$(2) \
	$(3)
	$(RUN_CMD) $$^ $$@
endef

$(eval \
$(call compare_elpd,\
$(ELPD_2HT_1HT),\
$(HOLDOUT_2HT),\
$(HOLDOUT_1HT)\
))

$(eval \
$(call compare_elpd,\
$(ELPD_2HT_SDT),\
$(HOLDOUT_2HT),\
$(HOLDOUT_SDT)\
))

$(eval \
$(call compare_elpd,\
$(ELPD_1HT_SDT),\
$(HOLDOUT_1HT),\
$(HOLDOUT_SDT)\
))

#------------------------------------------------------------------------------
# TARGETS ALL
#------------------------------------------------------------------------------
.PHONY: all directiory

directory:
	@mkdir -p $(TARGET_DATA_DIR)

all: directory \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(DATA) \
	$(STANMODELS_TRAIN) \
	$(STANMODELS_TEST) \
	$(STANFITS_TRAIN) \
	$(STANFITS_TEST) \
	$(ELPD_2HT_1HT) \
	$(ELPD_2HT_SDT) \
	$(ELPD_1HT_SDT)

