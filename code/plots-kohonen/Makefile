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

CODE_DIR := code/plots-kohonen
UTILS_DIR := $(CODE_DIR)/utils
TARGET_DATA_DIR := plots-kohonen
SOURCE_DATA_DIR := results-kohonen

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------

CHANGELOG := $(TARGET_DATA_DIR)/CHANGES

$(CHANGELOG): \
	$(CODE_DIR)/src/generate_changelog.r \
	$(CODE_DIR)/sidecars/changelog.r 
	$(RUN_CMD) $^ $@

DESC1 := $(TARGET_DATA_DIR)/plot1.json

$(DESC1): \
	$(CODE_DIR)/src/generate_plot_description.r \
	$(CODE_DIR)/sidecars/plot_description1.r 
	$(RUN_CMD) $^ $@


MDLS := 1HT 2HT SDT
N := $(words $(MDLS))
SOMS := $(foreach mdl,$(MDLS),$(SOURCE_DATA_DIR)/som_$(mdl).rds)
PLOTS1 := $(foreach mdl,$(MDLS),$(TARGET_DATA_DIR)/plot1_$(mdl).pdf)

# for plot1
define make_plots1
$(1): \
	$(CODE_DIR)/src/make_plot.r \
	$(2)
	$(RUN_CMD) $$^ $$@
endef

$(foreach i,\
$(shell seq 1 $(N)),\
$(eval \
$(call make_plots1,\
$(word $(i),$(PLOTS1)),\
$(word $(i),$(SOMS))\
)\
)\
)


#------------------------------------------------------------------------------
# TARGETS PHONY
#------------------------------------------------------------------------------
.PHONY: all directories foo

all: directories \
	$(CHANGELOG) \
	$(DESC1) \
	$(PLOTS1) \

directories:
	mkdir -p $(TARGET_DATA_DIR)

