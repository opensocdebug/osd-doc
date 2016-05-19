# Open SoC Debug Documentation

This repository contains much of the documentation around
[Open SoC Debug](http://opensocdebug.org).

The documentation is written in Markdown. The documents can be previewed with reasonable quality in any Markdown-capable application.

For the final documents, pandoc is used to convert into HTML or PDF documents.
Unfortunately, converting Markdown into output formats requires a rather fragile setup of pandoc together with other tools. To deal with this, we are providing a conversion tool, which uses pandoc with various added features inside a Docker container.

In short, the following commands should give you a nice-looking PDF output document of the OSD overview (on a Ubuntu system; use the appropriate commands to install Docker on other Linux distributions)

~~~
$ sudo apt-get install docker.io
$ curl -s -O https://raw.githubusercontent.com/opensocdebug/opensocdebug-doc-converter/master/osd-doc-converter
$ chmod +x osd-doc-converter
$ mkdir output
$ ./osd-doc-converter -f pdf --output output/overview.pdf \
    overview/pandoc-metadata.yaml \
    overview/overview.md

# or, if you prefer HTML output
$ ./osd-doc-converter -f html5 --output output/overview.html \
    overview/pandoc-metadata.yaml \
    overview/overview.md
~~~

Please refer to the [documentation of opensocdebug-doc-converter](https://github.com/opensocdebug/opensocdebug-doc-converter/blob/master/README.md) for more details.
