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
# LOCAL VARS
#------------------------------------------------------------------------------

CODE_DIR := code/plots-gp
UTILS_DIR := $(CODE_DIR)/utils
TARGET_DATA_DIR := plots-gp

HPDI_FUNC := code/utils/QIofMCMC.r
P_ROPE_FUNC := code/utils/get_p_rope.r

SOURCE_DATA_DIR := results-gp
DATA_RW = $(SOURCE_DATA_DIR)/task-recognition_standata_gp_rw.rds
DATA_SCR_AVG = $(SOURCE_DATA_DIR)/task-recognition_standata_gp_scr_avg.rds
DATA_SCR_DELTA = $(SOURCE_DATA_DIR)/task-recognition_standata_gp_scr_delta.rds


# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
MDLS := 1HT 2HT SDT
SAMPLES := posterior_large
else
MDLS := 1HT 2HT SDT
SAMPLES := posterior
endif

N := $(words $(MDLS))
STANFITS_RW := $(foreach mdl,$(MDLS),$(SOURCE_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_rw.rds)
STANFITS_SCR_AVG := $(foreach mdl,$(MDLS),$(SOURCE_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_scr_avg.rds)
STANFITS_SCR_DELTA:= $(foreach mdl,$(MDLS),$(SOURCE_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit_gp_scr_delta.rds)

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------
CHANGELOG := $(TARGET_DATA_DIR)/CHANGES

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog.r \
	$(CODE_DIR)/sidecars/changelog.r 
	$(RUN_CMD) $^ $@


FUNCS_RW := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/latent_functions_$(mdl)_$(SAMPLES)_gp_rw.rds)
FUNCS_SCR_AVG := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/latent_functions_$(mdl)_$(SAMPLES)_gp_scr_avg.rds)
FUNCS_SCR_DELTA := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/latent_functions_$(mdl)_$(SAMPLES)_gp_scr_delta.rds)

define extract_func_rw
$(1): \
	$(CODE_DIR)/src/extract_latent_functions.r \
	$(DATA_RW) \
	$(2) \
	$(HPDI_FUNC) \
	$(P_ROPE_FUNC)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call extract_func_rw,\
$(word $(i),$(FUNCS_RW)),\
$(word $(i),$(STANFITS_RW))\
)\
)\
)

define extract_func_scr_delta
$(1): \
	$(CODE_DIR)/src/extract_latent_functions.r \
	$(DATA_SCR_DELTA) \
	$(2) \
	$(HPDI_FUNC) \
	$(P_ROPE_FUNC)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call extract_func_scr_delta,\
$(word $(i),$(FUNCS_SCR_DELTA)),\
$(word $(i),$(STANFITS_SCR_DELTA))\
)\
)\
)

define extract_func_scr_avg
$(1): \
	$(CODE_DIR)/src/extract_latent_functions.r \
	$(DATA_SCR_AVG) \
	$(2) \
	$(HPDI_FUNC) \
	$(P_ROPE_FUNC)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call extract_func_scr_avg,\
$(word $(i),$(FUNCS_SCR_AVG)),\
$(word $(i),$(STANFITS_SCR_AVG))\
)\
)\
)


$(foreach i,$(shell seq 1 $(N)),$(eval $(call extract_func,$(word $(i),$(FUNCS_RW)),$(DATA_RW))))
$(foreach i,$(shell seq 1 $(N)),$(eval $(call extract_func,$(word $(i),$(FUNCS_SCR_AVG)),$(DATA_SCR_AVG))))
$(foreach i,$(shell seq 1 $(N)),$(eval $(call extract_func,$(word $(i),$(FUNCS_SCR_DELTA)),$(DATA_SCR_DELTA))))

DESC1 := $(TARGET_DATA_DIR)/plot1.json
DESC2 := $(TARGET_DATA_DIR)/plot2.json
DESC3 := $(TARGET_DATA_DIR)/plot3.json

$(DESC1): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description1.r 
	$(RUN_CMD) $^ $@

$(DESC2): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description2.r 
	$(RUN_CMD) $^ $@

$(DESC3): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description3.r 
	$(RUN_CMD) $^ $@

PLOTS_RW := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/plot1_$(mdl)_$(SAMPLES).pdf)
PLOTS_SCR_DELTA := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/plot2_$(mdl)_$(SAMPLES).pdf)
PLOTS_SCR_AVG := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/plot3_$(mdl)_$(SAMPLES).pdf)

define make_plot
$(1): \
	$(CODE_DIR)/src/make_plot.r \
	$(2) \
	$(CODE_DIR)/utils/plot_gp_func.r
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_plot,\
$(word $(i),$(PLOTS_RW)),\
$(word $(i),$(FUNCS_RW))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_plot,\
$(word $(i),$(PLOTS_SCR_DELTA)),\
$(word $(i),$(FUNCS_SCR_DELTA))\
)\
)\
)

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_plot,\
$(word $(i),$(PLOTS_SCR_AVG)),\
$(word $(i),$(FUNCS_SCR_AVG))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(CHANGELOG) \
	$(DESC1) \
	$(DESC2) \
	$(FUNCS_RW) \
	$(PLOTS_RW) \
	$(FUNCS_SCR_DELTA) \
	$(PLOTS_SCR_DELTA) \
