#	Makefile for the galaxis game

# Note: When the version changes, you also have to change
# the RPM spec file and the LSM.
VERS=1.4

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
	cp galaxis /usr/bin
	cp galaxis.6 /usr/share/man/man6/galaxis.6

uninstall:
	rm -f /usr/bin/install /usr/share/man/man6/galaxis.6

clean:
	rm -f galaxis galaxis.6 galaxis-*.rpm galaxis-*.tar.gz *~

SOURCES = READ.ME COPYING galaxis.c Makefile galaxis.xml galaxis.lsm galaxis.spec

galaxis-$(VERS).tar.gz: $(SOURCES) galaxis.6
	@ls $(SOURCES) galaxis.6 | sed s:^:galaxis-$(VERS)/: >MANIFEST
	@(cd ..; ln -s galaxis galaxis-$(VERS))
	(cd ..; tar -czvf galaxis/galaxis-$(VERS).tar.gz `cat galaxis/MANIFEST`)
	@(cd ..; rm galaxis-$(VERS))

dist: galaxis-$(VERS).tar.gz

RPMROOT=/usr/src/redhat
RPM = rpm
RPMFLAGS = -ba
rpm: dist
	cp galaxis-$(VERS).tar.gz $(RPMROOT)/SOURCES;
	cp galaxis.spec $(RPMROOT)/SPECS
	cd $(RPMROOT)/SPECS; $(RPM) $(RPMFLAGS) galaxis.spec	
	cp $(RPMROOT)/RPMS/`arch|sed 's/i[4-9]86/i386/'`/galaxis-$(VERS)*.rpm .
	cp $(RPMROOT)/SRPMS/galaxis-$(VERS)*.src.rpm .
