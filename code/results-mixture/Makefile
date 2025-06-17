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

CODE_DIR := code/results-mixture
UTILS_DIR := $(CODE_DIR)/utils
TARGET_DATA_DIR := results-mixture

DATA := results-mdl/task-recognition_standata.rds

RUN_STANMODEL := $(CODE_DIR)/src/run_stanmodel.r
RUN_STANFIT := $(CODE_DIR)/src/run_stanfit.r
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
# TARGETS
#------------------------------------------------------------------------------

# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
SAMPLES := posterior_large
SAMPLES_TYPE := LARGE
else
SAMPLES := posterior
SAMPLES_TYPE := POSTERIOR
endif

MDLS := 1HT 2HT SDT
N := $(words $(MDLS))

STANFILES := $(foreach mdl,$(MDLS),$(CODE_DIR)/stan/$(mdl)_mixture_posterior.stan)
STANMODELS := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_stanmodel.rds)
STANMODELS_TYPE := $(foreach mdl,$(MDLS),$(SAMPLES_TYPE))
STANFITS := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.rds)
STANFITS_SMRY := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.txt)
STANFITS_MCMC := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.pdf)
STANFITS_PRED1 := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_pred1.pdf)
STANFITS_PRED2 := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_pred2.pdf)
PARNAMES := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_parnames_$(mdl).r)
PARNAMES_SMRY := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_summary_parnames_$(mdl).r)
PARNAMES_PLOT := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_plot_parnames_$(mdl).r)


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
ifeq ($(LARGE),yes)

define fit_mdls_large
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA) \
	$(3)
	$(RUN_CMD) $$^ $$@ LARGE
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls_large,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES))\
)\
)\
)

else 

define fit_mdls
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA) \
	$(3)
	$(RUN_CMD) $$^ $$@ POSTERIOR
endef
$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES))\
)\
)\
)

endif


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
# TARGETS ALL
#------------------------------------------------------------------------------
.PHONY: directories all large

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(STANMODELS) \
	$(STANFITS) \
	$(STANFITS_SMRY) \
	$(STANFITS_MCMC) \
	$(STANFITS_PRED1) \
	$(STANFITS_PRED2)

