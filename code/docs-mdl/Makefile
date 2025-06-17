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
# TARGETS
#------------------------------------------------------------------------------
TARGET_DIR := docs-mdl
CODE_DIR := code/docs-mdl
1HT := $(TARGET_DIR)/mdl_1HT.pdf
1HT_TEX := $(CODE_DIR)/mdl_1HT.tex
1HT_TREE := $(TARGET_DIR)/tree_1HT.pdf
1HT_TREE_TEX := $(CODE_DIR)/tree_1HT.tex
1HT_MIX := $(TARGET_DIR)/mdl_1HT_mixture.pdf
1HT_MIX_TEX := $(CODE_DIR)/mdl_1HT_mixture.tex
1HT_GP := $(TARGET_DIR)/mdl_1HT_gp.pdf
1HT_GP_TEX := $(CODE_DIR)/mdl_1HT_gp.tex
2HT := $(TARGET_DIR)/mdl_2HT.pdf
2HT_TEX := $(CODE_DIR)/mdl_2HT.tex
2HT_TREE := $(TARGET_DIR)/tree_2HT.pdf
2HT_TREE_TEX := $(CODE_DIR)/tree_2HT.tex
2HT_MIX := $(TARGET_DIR)/mdl_2HT_mixture.pdf
2HT_MIX_TEX := $(CODE_DIR)/mdl_2HT_mixture.tex
2HT_GP := $(TARGET_DIR)/mdl_2HT_gp.pdf
2HT_GP_TEX := $(CODE_DIR)/mdl_2HT_gp.tex
SDT := $(TARGET_DIR)/mdl_SDT.pdf
SDT_TEX := $(CODE_DIR)/mdl_SDT.tex

# rule
define render
$(1): \
	$(2)
	$(RUN_CMD) xelatex -output-directory=$(TARGET_DIR) $$<
	rm $(TARGET_DIR)/*.{log,aux}
endef

$(eval $(call render,$(1HT),$(1HT_TEX)))
$(eval $(call render,$(1HT_TREE),$(1HT_TREE_TEX)))
$(eval $(call render,$(1HT_MIX),$(1HT_MIX_TEX)))
$(eval $(call render,$(1HT_GP),$(1HT_GP_TEX)))
$(eval $(call render,$(2HT),$(2HT_TEX)))
$(eval $(call render,$(2HT_TREE),$(2HT_TREE_TEX)))
$(eval $(call render,$(2HT_MIX),$(2HT_MIX_TEX)))
$(eval $(call render,$(2HT_GP),$(2HT_GP_TEX)))
$(eval $(call render,$(SDT),$(SDT_TEX)))

#------------------------------------------------------------------------------
# ALL
#------------------------------------------------------------------------------
.PHONY: all directory clean

all: directory \
	$(1HT) \
	$(1HT_TREE) \
	$(1HT_MIX) \
	$(1HT_GP) \
	$(2HT) \
	$(2HT_TREE) \
	$(2HT_MIX) \
	$(2HT_GP) \
	$(SDT)

directory:
	mkdir -p $(TARGET_DIR)

clean: 
	rm $(TARGET_DIR)/mdl*.{aux,bbl,bcf,blg,log,out,pdf,run.xml}




