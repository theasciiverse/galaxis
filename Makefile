#	Makefile for the galaxis game

# Flags for use with the Linux ncurses package (recommended)
CFLAGS = -g -DNDEBUG  -I/usr/local/include -L/usr/local/lib
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

shar:
	shar READ.ME galaxis.c Makefile galaxis.6 >galaxis.shar

tgz:
	tar -cvf galaxis.tar READ.ME galaxis.c Makefile galaxis.6
	gzip galaxis.tar
