#	Makefile for the galaxis game

# Note: When the version changes, you also have to change
#  * the name of the containing directory
#  * the RPM spec file
V=1.1

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
	rm -f galaxis galaxis.shar *~

SOURCES = READ.ME galaxis.c Makefile galaxis.6 galaxis.lsm galaxis.spec

galaxis.shar:
	shar $(SOURCES) >galaxis.shar

galaxis.tar.gz:
	(cd ..; tar -cvf galaxis-$(V)/galaxis.tar `echo $(SOURCES) | sed "/\(^\| \)/s// galaxis-$(V)\//g"`)
	gzip -f galaxis.tar

rpm: galaxis.tar.gz
	cp galaxis.tar.gz /usr/src/SOURCES/galaxis-$(V).tar.gz
	cp galaxis.spec /usr/src/SPECS/galaxis-$(V)-1.spec
	rpm -ba galaxis-$(V)-1.spec
