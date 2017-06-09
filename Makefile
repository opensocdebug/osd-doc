# Build the OSD Documentation
#
# Note: this Makefile is *not* used by Read The Docs, it exec()'s the conf.py
# file directly. Hence, all special build steps here are only relevant for
# local builds, not for RTD builds. Add all build steps which should be executed
# in RTD builds as Python code into the conf.py file.
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = .venv/bin/sphinx-build
SPHINXPROJ    = OpenSoCDebug
SOURCEDIR     = src
BUILDDIR      = build

SVG2PDF       = inkscape
SVG2PDF_FLAGS =

# Build a list of SVG files to convert to PDFs
IMAGES_SVG_REL := $(shell find $(SOURCEDIR) -iname '*.svg' -printf '%P\n')
IMAGES_PDF := $(addprefix $(BUILDDIR)/,$(IMAGES_SVG_REL:.svg=.pdf))


# Put it first so that "make" without argument is like "make help".
help: .venv
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.venv:
	echo Creating Python venv for Sphinx build
	python3 -m venv .venv
	.venv/bin/pip -q install --upgrade pip
	.venv/bin/pip -q install -r requirements.txt

.SECONDEXPANSION:
$(IMAGES_PDF): %.pdf : $$(subst $$(BUILDDIR),$$(SOURCEDIR),%).svg
	mkdir -p $(@D)
	$(SVG2PDF) -f $< -A $@

# Convert images from SVG to PDF for LaTeX PDF output
images-pdf: $(IMAGES_PDF)

# Convert images to PDF before running the LaTeX PDF build
latexpdf: .venv Makefile images-pdf
	@$(SPHINXBUILD) -M latexpdf "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

clean-images:
	-rm $(IMAGES_PDF)

clean: .venv Makefile clean-images
	@$(SPHINXBUILD) -M clean "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

distclean:
	-rm -rf .venv build sphinx/__pycache__


.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
.DEFAULT:
	# Dependencies for this special target are ignored by make, as discussed in
	# http://stackoverflow.com/questions/26875072/dependencies-for-special-make-target-default-not-firing
	# We hack around that by calling the target explicitly.
	make .venv

	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
