#	Makefile for the galaxis game
#
# SPDX-FileCopyrightText: (C) Eric S. Raymond <esr@thyrsus.com>
# SPDX-License-Identifier: BSD-2-Clause

PREFIX      ?= /usr/local
BINDIR      ?= $(PREFIX)/bin
DATADIR     ?= $(PREFIX)/share
MANDIR      ?= $(DATADIR)/man

# Flags for use with the Linux ncurses package (recommended)
CFLAGS += -O -Wall -Werror
TERMLIB = -lncurses
CC = gcc

VERSION=$(shell sed -n <NEWS.adoc '/^[0-9]/s/:.*//p' | head -1)

# Rules

# Note: to suppress the footers with timestamps being generated in HTML,
# we use "-a nofooter".
# To debug asciidoc problems, you may need to run "xmllint --nonet --noout --valid"
# on the intermediate XML that throws an error.
.SUFFIXES: .html .adoc .6

.adoc.6:
	asciidoctor -D. -a nofooter -b manpage $<
.adoc.html:
	asciidoctor -D. -a nofooter -a webfonts! $<

.PHONY: clean cppcheck spellcheck reflow install uninstall version dist release refresh

# Build

build: galaxis galaxis.6

galaxis: galaxis.c
	$(CC) $(CFLAGS) -o galaxis galaxis.c $(TERMLIB)

clean:
	rm -f galaxis galaxis.6 galaxis-*.tar.gz *~ *.html

# Validate

reflow:
	@clang-format --style="{IndentWidth: 8, UseTab: ForIndentation}" -i $$(find . -name "*.[ch]")

CPPCHECKOPTS =
cppcheck:
	@cppcheck --quiet -DREVISION=$(VERSION) $(CPPCHECKOPTS) galaxis.c

spellcheck:
	@spellcheck galaxis.adoc

# Install/uninstall

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 galaxis $(DESTDIR)$(BINDIR)/galaxis
	install galaxis.1 $(DESTDIR)$(MANDIR)/man1/galaxis.6

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/galaxis
	rm -f $(DESTDIR)$(MANDIR)/man1/galaxis.6

# Export

version:
	@echo $(VERSION)

SOURCES = README.adoc COPYING NEWS.adoc control galaxis.c Makefile galaxis.adoc galaxis.desktop galaxis.png

galaxis-$(VERSION).tar.gz: $(SOURCES)
	mkdir galaxis-$(VERSION)
	cp -r $(SOURCES) galaxis-$(VERSION)
	tar -czf galaxis-$(VERSION).tar.gz galaxis-$(VERSION)
	rm -fr galaxis-$(VERSION)
	ls -l galaxis-$(VERSION).tar.gz

dist: galaxis-$(VERSION).tar.gz

release: galaxis-$(VERSION).tar.gz galaxis.html
	shipper version=$(VERSION) | sh -e -x

refresh: galaxis.html
	shipper -N -w version=$(VERSION) | sh -e -x

# end
