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

CODE_DIR := code/derivatives-beh
SOURCE_DATA_DIR := data-raw
EXP_DIRS := \
	$(SOURCE_DATA_DIR)/study-01 \
	$(SOURCE_DATA_DIR)/study-02 \
	$(SOURCE_DATA_DIR)/study-03 \
	$(SOURCE_DATA_DIR)/study-04 
TARGET_DATA_DIR := derivatives-beh

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

DESC := $(TARGET_DATA_DIR)/dataset_description.json
CHANGELOG := $(TARGET_DATA_DIR)/CHANGES
README := $(TARGET_DATA_DIR)/README.md

TARGET1a := $(TARGET_DATA_DIR)/task-recognition_desc-reduced_beh.json
TARGET1b := $(TARGET_DATA_DIR)/task-recognition_desc-reducedFixed_beh.json
TARGET2 := $(TARGET_DATA_DIR)/task-conditioning_desc-rl_beh.json

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
# TARGETS BEH RECOGNITION
#------------------------------------------------------------------------------

$(TARGET1a): \
	$(CODE_DIR)/src/transform_task-recognition_oldnew_reduced.r \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_oldnew_reduced.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

$(TARGET1b): \
	$(CODE_DIR)/src/transform_task-recognition_oldnew_reduced_fixed.r \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_oldnew_reduced_fixed.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

$(TARGET2): \
	$(CODE_DIR)/src/transform_task-conditioning.r \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_conditioning.r \
	$(EXP_DIRS)
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories 

directories:
	mkdir -p $(TARGET_DATA_DIR)
	
all: directories \
	$(TARGET1a) \
	$(TARGET2) \
	$(DESC) \
	$(CHANGELOG) \
	$(README)


