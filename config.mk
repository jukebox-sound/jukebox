# Project metadata
NAME        = jukebox
VERSION     = 1.1.15.3
DIST        = ${NAME}-${VERSION}

# Installation paths.  All paths are relative to PREFIX unless
# explicitly overridden by the packager.
PREFIX      = /usr
BINDIR      = ${PREFIX}/bin
DATADIR     = ${PREFIX}/share
JUKEBOXDATA = ${DATADIR}/${NAME}
APPDIR      = ${DATADIR}/applications
ICONDIR     = ${DATADIR}/icons/hicolor
MANPREFIX   = ${DATADIR}/man
DOCDIR      = ${DATADIR}/doc/${NAME}
