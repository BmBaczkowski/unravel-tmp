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

CODE_DIR := code/data-raw

STUDIES = 1 2 3 4

SOURCE_DATA_DIR1 := data-source/Exp_1 
SOURCE_DATA_DIR2 := data-source/Exp_2 
SOURCE_DATA_DIR3 := data-source/Exp_3 
SOURCE_DATA_DIR4 := data-source/Exp_4 
SOURCE_DATA_DIRS := $(foreach i,$(STUDIES),$(SOURCE_DATA_DIR$(i)))

TARGET_DATA_DIR1 := data-raw/study-01
TARGET_DATA_DIR2 := data-raw/study-02
TARGET_DATA_DIR3 := data-raw/study-03
TARGET_DATA_DIR4 := data-raw/study-04

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------
DESC = data-raw/dataset_description.json
CHANGELOG = data-raw/CHANGES
README = data-raw/README.md

TARGETS_PRE = $(foreach i,$(STUDIES),$(TARGET_DATA_DIR$(i))/task-preconditioning_beh.json)
TARGETS_COND= $(foreach i,$(STUDIES),$(TARGET_DATA_DIR$(i))/task-conditioning_beh.json)
TARGETS_POST = $(foreach i,$(STUDIES),$(TARGET_DATA_DIR$(i))/task-postconditioning_beh.json)

TARGET_RECON1 = $(TARGET_DATA_DIR1)/task-recognition_beh.json
TARGET_RECON2 = $(TARGET_DATA_DIR2)/task-recognition_beh.json
TARGET_RECON3 = $(TARGET_DATA_DIR3)/task-recognition_beh.json
TARGET_RECON4 = $(TARGET_DATA_DIR4)/task-recognition_beh.json

#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------

define make_targets_pre
$(1): \
	$(CODE_DIR)/src/extract_task-preconditioning_exp-1234.r \
	$(2) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_pre_post_conditioning_exp1234.r
	$(RUN_CMD) $$^ $$@
endef

define make_targets_cond
$(1): \
	$(CODE_DIR)/src/extract_task-conditioning_exp-1234.r \
	$(2) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_conditioning_exp1234.r
	$(RUN_CMD) $$^ $$@
endef

define make_targets_post
$(1): \
	$(CODE_DIR)/src/extract_task-postconditioning_exp-1234.r \
	$(2) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_pre_post_conditioning_exp1234.r
	$(RUN_CMD) $$^ $$@
endef

#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories 

all: directories \
	$(DESC) \
	$(CHANGELOG) \
	$(README) \
	$(TARGETS_PRE) \
	$(TARGETS_COND) \
	$(TARGETS_POST) \
	$(TARGET_RECON1) \
	$(TARGET_RECON2) \
	$(TARGET_RECON3) \
	$(TARGET_RECON4)

directories:
	mkdir -p $(TARGET_DATA_DIR1)
	mkdir -p $(TARGET_DATA_DIR2)
	mkdir -p $(TARGET_DATA_DIR3)
	mkdir -p $(TARGET_DATA_DIR4)

#------------------------------------------------------------------------------
# TARGETS MODALITY AGNOSTIC FILES
#------------------------------------------------------------------------------

$(DESC): \
	$(CODE_DIR)/src/generate_dataset_description1234.r \
	$(CODE_DIR)/sidecars/dataset_description.r
	$(RUN_CMD) $^ $@

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog1234.r \
	$(CODE_DIR)/sidecars/changelog.r
	$(RUN_CMD) $^ $@

$(README): \
	$(CODE_DIR)/src/generate_readme1234.r \
	$(CODE_DIR)/sidecars/readme.r
	$(RUN_CMD) $^ $@

#------------------------------------------------------------------------------
# TARGETS BEH PRE-CONDITIONING
#------------------------------------------------------------------------------

$(foreach i,\
$(shell seq 1 4),\
$(eval \
$(call make_targets_pre,\
$(word $(i),$(TARGETS_PRE)),\
$(word $(i),$(SOURCE_DATA_DIRS))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS BEH CONDITIONING
#------------------------------------------------------------------------------

$(foreach i,\
$(shell seq 1 4),\
$(eval \
$(call make_targets_cond,\
$(word $(i),$(TARGETS_COND)),\
$(word $(i),$(SOURCE_DATA_DIRS))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS BEH POST-CONDITIONING
#------------------------------------------------------------------------------

$(foreach i,\
$(shell seq 1 4),\
$(eval \
$(call make_targets_post,\
$(word $(i),$(TARGETS_POST)),\
$(word $(i),$(SOURCE_DATA_DIRS))\
)\
)\
)

#------------------------------------------------------------------------------
# TARGETS BEH RECOGNITION
#------------------------------------------------------------------------------

$(TARGET_RECON1): \
	$(CODE_DIR)/src/extract_task-recognition_exp-1.r \
	$(SOURCE_DATA_DIR1) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_exp1.r 
	$(RUN_CMD) $^ $@

$(TARGET_RECON2): \
	$(CODE_DIR)/src/extract_task-recognition_exp-234.r \
	$(SOURCE_DATA_DIR2) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_exp234.r 
	$(RUN_CMD) $^ $@

$(TARGET_RECON3): \
	$(CODE_DIR)/src/extract_task-recognition_exp-234.r \
	$(SOURCE_DATA_DIR3) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_exp234.r 
	$(RUN_CMD) $^ $@

$(TARGET_RECON4): \
	$(CODE_DIR)/src/extract_task-recognition_exp-234.r \
	$(SOURCE_DATA_DIR4) \
	$(CODE_DIR)/utils/utils.r \
	$(CODE_DIR)/sidecars/task_recognition_exp234.r 
	$(RUN_CMD) $^ $@