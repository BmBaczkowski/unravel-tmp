# GNU Makefile

#------------------------------------------------------------------------------
# LOCAL VARS
#------------------------------------------------------------------------------
ENGINE := podman
IMG := rstan:2.32.5
CODE_DIR_BASE := code/data-source/
DATA_SOURCE_DIR := data-source
CUR_DIR := $(shell pwd)

RUN_CMD := \
    $(ENGINE) run --rm --user=root -i -v $(CUR_DIR):/home/dockeruser $(IMG) Rscript

#------------------------------------------------------------------------------
# TESTING
#------------------------------------------------------------------------------
.PHONY: test-docker-r

# Test docker container
test-docker-r:
	$(ENGINE) run --rm --user=root \
	-it -v $(CUR_DIR):/home/dockeruser $(IMG) bash

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------
.PHONY: all clean

all: $(DATA_SOURCE_DIR)
clean: 
	@rm -fr $(DATA_SOURCE_DIR)
	@echo ""
	@echo "Source data removed"
	@echo ""


$(DATA_SOURCE_DIR): \
	$(CODE_DIR_BASE)/src/download_data.r \
	$(CODE_DIR_BASE)/misc/data_urls.txt
	$(RUN_CMD) $^ $@

