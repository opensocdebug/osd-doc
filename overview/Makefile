PANDOC?=pandoc
PANDOC_OPTIONS?=-s -S -V documentclass=scrartcl -H ../shared/pandoc-header.tex

FILES=pandoc-metadata.yaml \
      overview.md

EXTRA_DEP=Makefile \
          ../shared/pandoc-header.tex

all: specification.pdf

specification.pdf: $(FILES) $(EXTRA_DEP)
	$(PANDOC) $(PANDOC_OPTIONS) -o $@ $(FILES)

