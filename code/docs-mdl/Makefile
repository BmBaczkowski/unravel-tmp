# GNU Makefile

#------------------------------------------------------------------------------
# RUN CONTAINER
#------------------------------------------------------------------------------
ENGINE := podman
IMG := rstan:2.32.5

RUN_CMD := \
	$(ENGINE) run --rm --user=root \
	-i -v $(shell pwd):/home/dockeruser $(IMG)

#------------------------------------------------------------------------------
# LOCAL VARS
#------------------------------------------------------------------------------

TARGET_DIR := docs-mdl
CODE_DIR := code/docs-mdl

#------------------------------------------------------------------------------
# TARGETS
#------------------------------------------------------------------------------
$(TARGET_DIR)/mdl_1HT.pdf: \
	$(CODE_DIR)/mdl_1HT.tex
	$(RUN_CMD) xelatex -output-directory=$(TARGET_DIR) $<
	rm $(TARGET_DIR)/mdl_1HT.{aux,log}

$(TARGET_DIR)/mdl_1HT_mixture.pdf: \
	$(CODE_DIR)/mdl_1HT_mixture.tex
	$(RUN_CMD) xelatex -output-directory=$(TARGET_DIR) $<
	rm $(TARGET_DIR)/mdl_1HT_mixture.{aux,log}

$(TARGET_DIR)/mdl_1HT_gp.pdf: \
	$(CODE_DIR)/mdl_1HT_gp.tex
	$(RUN_CMD) xelatex -output-directory=$(TARGET_DIR) $<
	rm $(TARGET_DIR)/mdl_1HT_gp.{aux,log}

#------------------------------------------------------------------------------
# ALL
#------------------------------------------------------------------------------
.PHONY: all directory clean

all: directory \
	$(TARGET_DIR)/mdl_1HT.pdf \
	$(TARGET_DIR)/mdl_1HT_mixture.pdf \
	$(TARGET_DIR)/mdl_1HT_gp.pdf

directory:
	mkdir -p $(TARGET_DIR)

clean: 
	rm $(TARGET_DIR)/mdl*.{aux,bbl,bcf,blg,log,out,pdf,run.xml}




