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

CODE_DIR := code/results-reproducibility
UTILS_DIR := $(CODE_DIR)/utils

SOURCE_DATA_DIR := derivatives-beh
EXP_DIRS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 
TARGET_DATA_DIR := results-reproducibility

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

DESC = $(TARGET_DATA_DIR)/dataset_description.json
CHANGELOG = $(TARGET_DATA_DIR)/CHANGES
README = $(TARGET_DATA_DIR)/README.md
DESCTSV = $(TARGET_DATA_DIR)/descriptions.tsv

TARGET0 = $(TARGET_DATA_DIR)/task-recognition_desc-hitfa_beh.json
TARGET1 = $(TARGET_DATA_DIR)/task-recognition_desc-overallperformance_beh.json
TARGET2 = $(TARGET_DATA_DIR)/task-recognition_desc-cr_beh.json
TARGET3 = $(TARGET_DATA_DIR)/task-recognition_desc-cr_ttest_beh.json
TARGET4 = $(TARGET_DATA_DIR)/task-recognition_desc-cr_anova_beh.json

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories 

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(TARGET0) \
	$(TARGET1) \
	$(TARGET2) \
	$(TARGET3) \
	$(TARGET4)

directories:
	mkdir -p $(TARGET_DATA_DIR)

#------------------------------------------------------------------------------
# TARGETS MODALITY AGNOSTIC FILES
#------------------------------------------------------------------------------

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
# TARGETS BEH HIT and FALSE ALARMS
#------------------------------------------------------------------------------

$(TARGET0): \
	$(CODE_DIR)/src/extract_task-recognition.r \
	$(CODE_DIR)/sidecars/extract_task-recognition.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS BEH OVERALL PERFORMANCE
#------------------------------------------------------------------------------

$(TARGET1): \
	$(CODE_DIR)/src/reproduce_task-recognition_overallperformance.r \
	$(UTILS_DIR)/reproduce_overallperformance.r \
	$(CODE_DIR)/sidecars/reproduce_task-recognition_overallperformance.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS BEH CORRECTED RECOGNITION
#------------------------------------------------------------------------------

$(TARGET2): \
	$(CODE_DIR)/src/reproduce_task-recognition_cr.r \
	$(UTILS_DIR)/reproduce_cr.r \
	$(CODE_DIR)/sidecars/reproduce_task-recognition_cr.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS BEH CORRECTED RECOGNITION : T-TEST
#------------------------------------------------------------------------------

$(TARGET3): \
	$(CODE_DIR)/src/reproduce_task-recognition_cr_ttest.r \
	$(TARGET2) \
	$(UTILS_DIR)/reproduce_ttest.r \
	$(CODE_DIR)/sidecars/reproduce_task-recognition_cr_ttest.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS BEH CORRECTED RECOGNITION : ANOVA
#------------------------------------------------------------------------------

$(TARGET4): \
	$(CODE_DIR)/src/reproduce_task-recognition_cr_anova.r \
	$(TARGET2) \
	$(UTILS_DIR)/reproduce_anova.r \
	$(CODE_DIR)/sidecars/reproduce_task-recognition_cr_anova.r
	$(RUN_CMD) $^ $@

