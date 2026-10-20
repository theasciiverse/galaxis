#!/bin/sh
# Builds galaxis with the Asciiverse changes (-DAV_CENTRE) and packs
# dist/galaxis-<target>.tar.gz (.zip for Windows) for av: the program at
# the top, with COPYING, README.adoc, the manual (galaxis.adoc) and
# PATCHES.md.
#
#   CC=cc CURSES_LIBS=-lncurses asciiverse/package.sh x86_64-unknown-linux-musl
#
# CC, CFLAGS, LDFLAGS, CPPFLAGS and CURSES_LIBS as usual.
set -eu
cd "$(dirname "$0")/.."
target="$1"
case "$target" in *windows*) exe=.exe ;; *) exe= ;; esac
${CC:-cc} ${CFLAGS:--O2} ${CPPFLAGS:-} -DAV_CENTRE -Iasciiverse ${LDFLAGS:-} \
  -o "galaxis$exe" galaxis.c ${CURSES_LIBS:--lncurses}
stage=stage/galaxis
rm -rf "$stage" && mkdir -p "$stage" dist
cp "galaxis$exe" COPYING README.adoc galaxis.adoc PATCHES.md "$stage/"
if [ -n "$exe" ]; then
  (cd "$stage" && zip -qr "../../dist/galaxis-$target.zip" .)
else
  tar -czf "dist/galaxis-$target.tar.gz" -C "$stage" .
fi
ls dist
