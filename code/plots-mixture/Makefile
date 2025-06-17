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

CODE_DIR := code/plots-mixture
UTILS_DIR := $(CODE_DIR)/utils
TARGET_DATA_DIR := plots-mixture

HPDI_FUNC := code/utils/QIofMCMC.r
ROPE_FUNC := code/utils/get_p_rope.r

DATA = results-mdl/task-recognition_standata.rds
SOURCE_DATA_DIR := results-mixture

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
MDLS := 1HT 
SAMPLES := posterior_large
else
MDLS := 1HT 2HT
SAMPLES := posterior
endif


CHANGELOG := $(TARGET_DATA_DIR)/CHANGES

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog.r \
	$(CODE_DIR)/sidecars/changelog.r 
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# PLOT 1
#------------------------------------------------------------------------------
DESC1 := $(TARGET_DATA_DIR)/plot1.json

$(DESC1): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description1.r 
	$(RUN_CMD) $^ $@

STANFITS := $(foreach mdl,$(MDLS),$(SOURCE_DATA_DIR)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.rds)
PLOTS1 := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/plot1_$(mdl).pdf)

N := $(words $(STANFITS))

# for plot1
define make_plots1
$(1): \
	$(CODE_DIR)/src/make_plot.r \
	$(DATA) \
	$(2) \
	$(CODE_DIR)/utils/plot_rho_func.r \
	$(CODE_DIR)/utils/plot_hist_func.r \
	$(HPDI_FUNC) \
	$(ROPE_FUNC)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_plots1,\
$(word $(i),$(PLOTS1)),\
$(word $(i),$(STANFITS))\
)\
)\
)

#------------------------------------------------------------------------------
# PLOT 2
#------------------------------------------------------------------------------
DESC2 := $(TARGET_DATA_DIR)/plot2.json

$(DESC2): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description2.r 
	$(RUN_CMD) $^ $@

STANFIT_SDT := $(SOURCE_DATA_DIR)/task-recognition_desc-SDT_$(SAMPLES)_stanfit.rds
PLOT2 := $(TARGET_DATA_DIR)/plot2.pdf

$(PLOT2): \
	$(CODE_DIR)/src/make_plot_SDT.r \
	$(DATA) \
	$(STANFIT_SDT) \
	$(CODE_DIR)/utils/plot_sdt_func.r \
	$(CODE_DIR)/utils/plot_hist_func.r \
	$(HPDI_FUNC) \
	$(ROPE_FUNC)
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories

directories:
	mkdir -p $(TARGET_DATA_DIR)

all: directories \
	$(CHANGELOG) \
	$(DESC1) \
	$(PLOTS1) \
	$(DESC2) \
	$(PLOT2)

