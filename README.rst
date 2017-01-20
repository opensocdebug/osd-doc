Documentation for Open SoC Debug (OSD)
======================================

This repository contains most documentation content for the Open SoC Debug project.
It consists of design/overview documents, the Open SoC Debug specification, and implementer documentation.
Some documentation is auto-generated from different repositories, such as API documentations for the reference implementation.

View the documentation
----------------------

You can view the documentation generated from this repository online at
http://osd-test.readthedocs.org


Build the documentation
-----------------------

The documentation is converted to HTML and PDF using `Sphinx <http://www.sphinx-doc.org/>`.
To build the HTML documentation locally, run ``make html`` inside the top-level source directory, or run ``make latexpdf`` for a PDF version.
You can find the resulting documentation in a sub-folder of the ``build`` directory.
