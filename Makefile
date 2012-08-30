#	Makefile for the galaxis game

VERS=$(shell sed <galaxis.spec -n -e '/Version: \(.*\)/s//\1/p')

# Flags for use with the Linux ncurses package (recommended)
CFLAGS = -g -DNDEBUG  # -I/usr/local/include -L/usr/local/lib
TERMLIB = -lncurses
CC = gcc

# Flags for use with stock curses
#CFLAGS = -DNDEBUG
#TERMLIB = -lcurses
#CC = gcc

galaxis: galaxis.c
	$(CC) $(CFLAGS) -o galaxis galaxis.c $(TERMLIB)

galaxis.6: galaxis.xml
	xmlto man galaxis.xml
galaxis.html: galaxis.xml
	xmlto html-nochunks galaxis.xml

install: galaxis.6 uninstall
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/bin/
	install -m 755 -o 0 -g 0 galaxis $(ROOT)/usr/bin/galaxis
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/share/man/man6/
	install -m 755 -o 0 -g 0 galaxis.6 $(ROOT)/usr/share/man/man6/galaxis.6

uninstall:
	rm -f ${ROOT}/usr/bin/galaxis ${ROOT}/usr/share/man/man6/galaxis.6

clean:
	rm -f galaxis galaxis.6 galaxis-*.rpm galaxis-*.tar.gz *~
	rm -f SHIPPER.* *.html

SOURCES = README COPYING galaxis.c Makefile galaxis.xml galaxis.spec

galaxis-$(VERS).tar.gz: $(SOURCES) galaxis.6
	tar --transform='s:^:galaxis-$(VERS)/:' --show-transformed-names -cvzf galaxis-$(VERS).tar.gz

dist: galaxis-$(VERS).tar.gz

release: galaxis-$(VERS).tar.gz galaxis.html
	shipper -u -m -t; make clean
