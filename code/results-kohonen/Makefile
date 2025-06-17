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

CODE_DIR := code/results-kohonen
TARGET_DIR := results-kohonen
SOURCE_RSTAN := results-mdl


RUN_KOHONEN := $(CODE_DIR)/src/run_kohonen.r
RUN_PLOT_KOHONEN := $(CODE_DIR)/src/run_plot_kohonen.r
RUN_PLOT_KOHONEN_CLST := $(CODE_DIR)/src/run_plot_kohonen_clusters.r

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
# SOM & HCUT
#------------------------------------------------------------------------------

# to specify 
# make LARGE=yes
ifeq ($(LARGE),yes)
SAMPLES := posterior_large
else
SAMPLES := posterior
endif

MDLS := 1HT 2HT SDT
N := $(words $(MDLS))

STANFITS := $(foreach mdl,$(MDLS),$(SOURCE_RSTAN)/task-recognition_desc-$(mdl)_$(SAMPLES)_stanfit.rds)
SOMS :=  $(foreach mdl,$(MDLS),$(TARGET_DIR)/som_$(mdl).rds)
SOMS_PDFs :=  $(foreach mdl,$(MDLS),$(TARGET_DIR)/som_$(mdl)_diag_list.txt)
SOMS_CLTs :=  $(foreach mdl,$(MDLS),$(TARGET_DIR)/som_$(mdl)_clts_list.txt)

# for som
define make_som
$(1): \
	$(RUN_KOHONEN) \
	$(2) \
	$(CODE_DIR)/utils/utils_run_kohonen.r
	$(RUN_CMD) $$^ $$@ $(3)
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_som,\
$(word $(i),$(SOMS)),\
$(word $(i),$(STANFITS)),\
$(word $(i),$(MDLS))\
)\
)\
)

# for som pdfs
define make_som_pdfs
$(1): \
	$(RUN_PLOT_KOHONEN) \
	$(2)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_som_pdfs,\
$(word $(i),$(SOMS_PDFs)),\
$(word $(i),$(SOMS))\
)\
)\
)

# for som clusters
define make_som_clts
$(1): \
	$(RUN_PLOT_KOHONEN_CLST) \
	$(2)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_som_clts,\
$(word $(i),$(SOMS_CLTs)),\
$(word $(i),$(SOMS))\
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
	$(SOMS) \
	$(SOMS_PDFs) \
	$(SOMS_CLTs) \




