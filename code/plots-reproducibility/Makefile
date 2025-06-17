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

CODE_DIR := code/plots-reproducibility
UTILS_DIR := $(CODE_DIR)/utils

SOURCE_DATA_DIR := results-reproducibility
SRC1 := $(SOURCE_DATA_DIR)/task-recognition_desc-overallperformance_beh.tsv
SRC2 := $(SOURCE_DATA_DIR)/task-recognition_desc-cr_ttest_beh.tsv
SRC3 := $(SOURCE_DATA_DIR)/task-recognition_desc-cr_anova_beh.tsv
SRC_FILES := $(SRC1) $(SRC2) $(SRC3)
SOURCE_TSV := $(SOURCE_DATA_DIR)/task-recognition_desc-hitfa_beh.tsv
TARGET_DATA_DIR := plots-reproducibility

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

CHANGELOG := $(TARGET_DATA_DIR)/CHANGES
PLOT1 := $(TARGET_DATA_DIR)/plot1.pdf
DESC1 := $(TARGET_DATA_DIR)/plot1.json
PLOT2 := $(TARGET_DATA_DIR)/plot2.pdf
DESC2 := $(TARGET_DATA_DIR)/plot2.json

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories 

all: directories \
	$(CHANGELOG) \
	$(DESC1) \
	$(PLOT1) \
	$(DESC2) \
	$(PLOT2)
	
directories:
	mkdir -p $(TARGET_DATA_DIR)

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog.r \
	$(CODE_DIR)/sidecars/changelog.r 
	$(RUN_CMD) $^ $@

$(PLOT1): \
	$(CODE_DIR)/src/make_plot.r \
	$(SRC_FILES) \
	$(CODE_DIR)/utils/subplots.r 
	$(RUN_CMD) $^ $@

$(DESC1): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description.r 
	$(RUN_CMD) $^ $@

$(PLOT2): \
	$(CODE_DIR)/src/make_plot2.r \
	$(SOURCE_TSV)
	$(RUN_CMD) $^ $@

$(DESC2): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description2.r 
	$(RUN_CMD) $^ $@