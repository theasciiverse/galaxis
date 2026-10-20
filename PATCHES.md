# Changes from upstream

This is the Asciiverse edition of Galaxis, Eric S. Raymond's curses
version of Christian Franz's Macintosh game (begun 1994, BSD-2-Clause),
from ESR's own repository, gitlab.com/esr/galaxis (the `upstream`
remote), at release 1.13 (`089605a`, 2026-02-22), with its full history.
No distribution packages Galaxis (not in Debian). The `asciiverse`
branch carries the changes below.

## Code

- **The mouse hint is looked up by its terminfo name, `kmous`.**
  tigetstr() takes terminfo names; "Km" is the termcap one, for which it
  returns (char *)-1, so "Your mouse may work" never showed, though the
  mouse does work.
- **Mouse events getmouse() cannot read are ignored instead of ending
  the game.** A release of the right button or a turn of the scroll
  wheel printed "Mouse input error. Exiting." and quit.
- **Centred, and following a resized terminal** (under `AV_CENTRE`,
  asciiverse/centre.h, so other builds are unchanged): galaxis.c draws on
  an 80x24 pad (the name stdscr, and printw and mvprintw, point at it),
  refresh() copies the pad to the middle of the terminal, getch() shows
  it and waits for a key on the terminal's own screen, a resize centres
  it again, and mouse positions are translated back to the game's
  coordinates. (Assigning the pad to curses' stdscr does not hold:
  curses puts its own value back; and waiting for keys on the pad has
  curses refresh it at the top left.)
- **Windows** (MinGW and PDCurses): `<termios.h>` (unused) left out and
  SIGQUIT installed only where it exists; PDCurses has no terminfo, so
  the mouse hint shows without asking it.

Galaxis keeps no files, so nothing moves to a data folder.

## Packaging

- `asciiverse/package.sh` builds with the changes above and packs
  `galaxis-<target>` with the program, COPYING, README.adoc, the manual
  (galaxis.adoc) and this file. Upstream's Makefile, which builds the
  man page with asciidoctor, is left as it is.
- `.github/workflows/release.yml`: static musl Linux (Alpine, x86-64 and
  ARM64), macOS (Intel and Apple silicon, system ncurses) and Windows
  x86-64 (MinGW, PDCurses 3.9 wincon), on our tags (`*-av.*`).
- `asciiverse/record.sh` records the catalog preview,
  `asciiverse/galaxis.cast`, while `asciiverse/drive.py` plays: it
  remembers each probe's count (the directions, of eight, in which it
  sees a lifeboat, each counting only its first), looks for lifeboat
  placements agreeing with every count, and probes the square most of
  them share. The take finds all four lifeboats in 19 tries.

## Checked

Linux, native and static (Alpine): played at 100x30 and 120x40,
resized in play and in the help, keys, arrow keys and mouse clicks on
the centred board. AddressSanitizer and UBSan clean over random-key,
mouse and resize soaks. Windows: cross-built and played under Wine
(probes, quitting). macOS: not built here.
