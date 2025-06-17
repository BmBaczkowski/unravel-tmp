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

CODE_DIR := code/results-mdl
UTILS_DIR := $(CODE_DIR)/utils
SOURCE_DATA_DIR := derivatives-beh
EXP_DIRS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 
TARGET_DATA_DIR := results-mdl

RUN_DATA := $(CODE_DIR)/src/run_data.r
RUN_STANMODEL := $(CODE_DIR)/src/run_stanmodel.r
RUN_STANFIT := $(CODE_DIR)/src/run_stanfit.r
RUN_SUMMARY = $(CODE_DIR)/src/run_summary.r
RUN_PLOT_MCMC = $(CODE_DIR)/src/run_plot_mcmc.r
RUN_PLOT_PREDICTIVE = $(CODE_DIR)/src/run_plot_predictive.r

#------------------------------------------------------------------------------
# LOCAL VARS
#------------------------------------------------------------------------------

# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
MDLS := 1HT 2HT SDT
STAN_FILES := posterior
SAMPLES := posterior_large
SAMPLES_TYPE := LARGE
else
MDLS := 1HT 2HT SDT
STAN_FILES := prior posterior
SAMPLES := prior posterior
SAMPLES_TYPE := PRIOR POSTERIOR
endif

STANFILES := $(foreach mdl,$(MDLS),$(foreach s,$(STAN_FILES),$(CODE_DIR)/stan/task-recognition_desc-$(mdl)_$(s).stan))
STANMODELS := $(foreach mdl,$(MDLS),$(foreach s,$(STAN_FILES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanmodel.rds))
STANMODELS_TYPE := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES_TYPE),$(s)))
STANFITS := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanfit.rds))
STANFITS_SMRY := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanfit.txt))
STANFITS_MCMC := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanfit.pdf))
STANFITS_PRED1 := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanfit_pred1.pdf))
STANFITS_PRED2 := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(s)_stanfit_pred2.pdf))

PARNAMES := $(foreach mdl,$(MDLS),$(foreach s,$(STAN_FILES),$(UTILS_DIR)/select_parnames_$(mdl)_$(s).r))
PARNAMES_SMRY := $(foreach mdl,$(MDLS),$(foreach s,$(STAN_FILES),$(UTILS_DIR)/select_summary_parnames_$(mdl)_$(s).r))
PARNAMES_PLOT := $(foreach mdl,$(MDLS),$(foreach s,$(STAN_FILES),$(UTILS_DIR)/select_plot_parnames_$(mdl)_$(s).r))

N := $(words $(STANMODELS))

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
$(shell seq 1 $(N)),\
$(eval \
$(call make_mdls,\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(STANFILES))\
)\
)\
)

# for stanfit
define fit_mdls
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef


$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES)),\
$(word $(i),$(STANMODELS_TYPE))\
)\
)\
)

# for stanfit summary
define run_mdls_smry
$(1): \
	$(RUN_SUMMARY) \
	$(2) \
	$(3)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_smry,\
$(word $(i),$(STANFITS_SMRY)),\
$(word $(i),$(STANFITS)),\
$(word $(i),$(PARNAMES_SMRY))\
)\
)\
)

# for stanfit MCMC
define run_mdls_mcmc
$(1): \
	$(RUN_PLOT_MCMC) \
	$(2) \
	$(3) \
	$(UTILS_DIR)/utils_plot_mcmc_chains.r
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_mcmc,\
$(word $(i),$(STANFITS_MCMC)),\
$(word $(i),$(STANFITS)),\
$(word $(i),$(PARNAMES_PLOT))\
)\
)\
)

# for stanfit pred1
define run_mdls_pred1
$(1): \
	$(RUN_PLOT_PREDICTIVE) \
	$(2) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive.r
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_pred1,\
$(word $(i),$(STANFITS_PRED1)),\
$(word $(i),$(STANFITS))\
)\
)\
)

# for stanfit pred2
define run_mdls_pred2
$(1): \
	$(RUN_PLOT_PREDICTIVE) \
	$(2) \
	$(DATA) \
	$(UTILS_DIR)/plot_predictive_interval.r
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_pred2,\
$(word $(i),$(STANFITS_PRED2)),\
$(word $(i),$(STANFITS))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS DATA
#------------------------------------------------------------------------------
.PHONY: all

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(CHANGELOG) \
	$(README) \
	$(DESC) \
	$(STANMODELS) \
	$(STANFITS) \
	$(STANFITS_SMRY) \
	$(STANFITS_MCMC) \
	$(STANFITS_PRED1) \
	$(STANFITS_PRED2)
