#	Makefile for the galaxis game

# Note: When the version changes, you also have to change the RPM spec file.
VERS=1.5

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

install: galaxis.6 uninstall
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/local/bin/
	install -m 755 -o 0 -g 0 galaxis $(ROOT)/usr/local/bin/galaxis
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/local/man/man6/
	install -m 755 -o 0 -g 0 galaxis.6 $(ROOT)/usr/local/man/man1/galaxis.6

uninstall:
	rm -f ${ROOT}/usr/bin/galaxis ${ROOT}/usr/share/man/man6/galaxis.6

clean:
	rm -f galaxis galaxis.6 galaxis-*.rpm galaxis-*.tar.gz *~

SOURCES = READ.ME COPYING galaxis.c Makefile galaxis.xml galaxis.spec

galaxis-$(VERS).tar.gz: $(SOURCES) galaxis.6
	@ls $(SOURCES) galaxis.6 | sed s:^:galaxis-$(VERS)/: >MANIFEST
	@(cd ..; ln -s galaxis galaxis-$(VERS))
	(cd ..; tar -czvf galaxis/galaxis-$(VERS).tar.gz `cat galaxis/MANIFEST`)
	@(cd ..; rm galaxis-$(VERS))

dist: galaxis-$(VERS).tar.gz

RPMROOT=/usr/src/redhat
rpm: dist
	rpmbuild -ta galaxis-$(VERS).tar.gz
	cp $(RPMROOT)/RPMS/*/galaxis-$(VERS)*.rpm .
	cp $(RPMROOT)/SRPMS/galaxis-$(VERS)*.src.rpm .
