#	Makefile for the galaxis game

# Note: When the version changes, you also have to change
# the RPM spec file and the LSM.
VERS=1.2

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

clean:
	rm -f galaxis galaxis.shar galaxis-*.rpm galaxis-*.tar.gz *~

SOURCES = READ.ME galaxis.c Makefile galaxis.6 galaxis.lsm galaxis.spec

galaxis-$(VERS).tar.gz: $(SOURCES)
	@ls $(SOURCES) | sed s:^:galaxis-$(VERS)/: >MANIFEST
	@(cd ..; ln -s galaxis galaxis-$(VERS))
	(cd ..; tar -czvf galaxis/galaxis-$(VERS).tar.gz `cat galaxis/MANIFEST`)
	@(cd ..; rm galaxis-$(VERS))

galaxis-$(VERS).shar:
	shar $(SOURCES) >galaxis-$(VERS).shar

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
