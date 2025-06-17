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

CODE_DIR := code/results-gp
UTILS_DIR := $(CODE_DIR)/utils
TARGET_DATA_DIR := results-gp

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
SAMPLES := posterior_large
SAMPLES_TYPE := LARGE
else
MDLS := 1HT 2HT SDT
SAMPLES := posterior
SAMPLES_TYPE := POSTERIOR
endif

ifndef VAR
$(error VAR is not set. Please run as: make VAR=value [rw|scr_avg|scr_delta])
endif

STANFILES := $(foreach mdl,$(MDLS),$(CODE_DIR)/stan/task-recognition_desc-$(mdl)_posterior_gp.stan)
STANMODELS := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_posterior_stanmodel_gp.rds)
STANMODELS_TYPE := $(foreach mdl,$(MDLS),$(foreach s,$(SAMPLES_TYPE),$(s)))
STANFITS := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_$(VAR).rds)
STANFITS_SMRY := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_$(VAR).txt)
STANFITS_MCMC := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_$(VAR).pdf)
STANFITS_PRED := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_$(VAR)_pred.pdf)

PARNAMES := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_parnames_$(mdl)_posterior.r)
PARNAMES_SMRY := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_summary_parnames_$(mdl)_posterior.r)
PARNAMES_PLOT := $(foreach mdl,$(MDLS),$(UTILS_DIR)/select_plot_parnames_$(mdl)_posterior.r)

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

STANDATA := results-mdl/task-recognition_standata.rds
COVS := results-mixture-covariates/covariates.rds

DATA_RW := $(TARGET_DATA_DIR)/task-recognition_standata_gp_rw.rds
DATA_SCR_AVG := $(TARGET_DATA_DIR)/task-recognition_standata_gp_scr_avg.rds
DATA_SCR_DELTA := $(TARGET_DATA_DIR)/task-recognition_standata_gp_scr_delta.rds

$(DATA_RW): \
	$(RUN_DATA) \
	$(STANDATA) \
	$(COVS) \
	$(CODE_DIR)/utils/get_data_gp_rw.r
	$(RUN_CMD) $^ $@

$(DATA_SCR_AVG): \
	$(RUN_DATA) \
	$(STANDATA) \
	$(COVS) \
	$(CODE_DIR)/utils/get_data_gp_scr_avg.r
	$(RUN_CMD) $^ $@

$(DATA_SCR_DELTA): \
	$(RUN_DATA) \
	$(STANDATA) \
	$(COVS) \
	$(CODE_DIR)/utils/get_data_gp_scr_delta.r
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

# for stanfit
define fit_mdls_rw
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA_RW) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef

define fit_mdls_scr_delta
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA_SCR_DELTA) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef

define fit_mdls_scr_avg
$(1): \
	$(RUN_STANFIT) \
	$(2) \
	$(DATA_SCR_AVG) \
	$(3)
	$(RUN_CMD) $$^ $$@ $(4)
endef


# for stanfit summary
define run_mdls_smry
$(1): \
	$(RUN_SUMMARY) \
	$(2) \
	$(3)
	$(RUN_CMD) $$^ $$@
endef

# for stanfit MCMC
define run_mdls_mcmc
$(1): \
	$(RUN_PLOT_MCMC) \
	$(2) \
	$(3) \
	$(UTILS_DIR)/utils_plot_mcmc_chains.r
	$(RUN_CMD) $$^ $$@
endef

# for stanfit pred
define run_mdls_pred_rw
$(1): \
	$(RUN_PLOT_PREDICTIVE) \
	$(2) \
	$(DATA_RW) \
	$(UTILS_DIR)/utils_plot_predictive.r
	$(RUN_CMD) $$^ $$@
endef

define run_mdls_pred_scr_delta
$(1): \
	$(RUN_PLOT_PREDICTIVE) \
	$(2) \
	$(DATA_SCR_DELTA) \
	$(UTILS_DIR)/utils_plot_predictive.r
	$(RUN_CMD) $$^ $$@
endef

define run_mdls_pred_scr_avg
$(1): \
	$(RUN_PLOT_PREDICTIVE) \
	$(2) \
	$(DATA_SCR_AVG) \
	$(UTILS_DIR)/utils_plot_predictive.r
	$(RUN_CMD) $$^ $$@
endef

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------


$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_mdls,\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(STANFILES))\
)\
)\
)


ifeq ($(VAR),rw)
$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls_rw,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES)),\
$(word $(i),$(STANMODELS_TYPE))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_pred_rw,\
$(word $(i),$(STANFITS_PRED)),\
$(word $(i),$(STANFITS))\
)\
)\
)

else ifeq ($(VAR),scr_avg)
$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls_scr_avg,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES)),\
$(word $(i),$(STANMODELS_TYPE))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_pred_scr_avg,\
$(word $(i),$(STANFITS_PRED)),\
$(word $(i),$(STANFITS))\
)\
)\
)

else ifeq ($(VAR),scr_delta)
$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call fit_mdls_scr_delta,\
$(word $(i),$(STANFITS)),\
$(word $(i),$(STANMODELS)),\
$(word $(i),$(PARNAMES)),\
$(word $(i),$(STANMODELS_TYPE))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call run_mdls_pred_scr_delta,\
$(word $(i),$(STANFITS_PRED)),\
$(word $(i),$(STANFITS))\
)\
)\
)

endif


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


#------------------------------------------------------------------------------
# TARGETS DATA
#------------------------------------------------------------------------------
.PHONY: all directories create-volume

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(DESC) \
	$(README) \
	$(CHANGELOG) \
	$(DATA_RW) \
	$(DATA_SCR_AVG) \
	$(DATA_SCR_DELTA) \
	$(STANMODELS) \
	$(STANFITS) \
	$(STANFITS_SMRY) \
	$(STANFITS_MCMC) \
	$(STANFITS_PRED) \

