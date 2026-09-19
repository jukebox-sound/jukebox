.POSIX:

include config.mk

PERL       = perl
PODCHECKER = podchecker
POD2MAN    = pod2man
INSTALL    = install

BUILDDIR = build
MANDIR   = ${BUILDDIR}/man

MODULES = \
	apeheader.pm \
	flacheader.pm \
	jukebox_123.pm \
	jukebox_dbus.pm \
	jukebox_gstreamer-0.10.pm \
	jukebox_gstreamer-1.x.pm \
	jukebox_layout.pm \
	jukebox_list.pm \
	jukebox_mplayer.pm \
	jukebox_mpv.pm \
	jukebox_server.pm \
	jukebox_songs.pm \
	jukebox_tags.pm \
	m4aheader.pm \
	mp3header.pm \
	mpcheader.pm \
	oggheader.pm \
	simple_http.pm \
	simple_http_AE.pm \
	simple_http_wget.pm \
	wvheader.pm

PODS = \
	jukebox.1.pod \
	jukeboxrc.5.pod \
	jukebox-layouts.7.pod \
	jukebox-plugins.7.pod

MANPAGES = \
	${MANDIR}/jukebox.1 \
	${MANDIR}/jukeboxrc.5 \
	${MANDIR}/jukebox-layouts.7 \
	${MANDIR}/jukebox-plugins.7

DOCS = README.md COPYING COPYRIGHT

all: man

man: ${MANPAGES}

${MANDIR}/jukebox.1: jukebox.1.pod
	mkdir -p "${MANDIR}"
	${POD2MAN} --utf8 --section=1 --release="${NAME} ${VERSION}" \
		--center="${NAME} manual" $< $@

${MANDIR}/jukeboxrc.5: jukeboxrc.5.pod
	mkdir -p "${MANDIR}"
	${POD2MAN} --utf8 --section=5 --release="${NAME} ${VERSION}" \
		--center="${NAME} manual" $< $@

${MANDIR}/jukebox-layouts.7: jukebox-layouts.7.pod
	mkdir -p "${MANDIR}"
	${POD2MAN} --utf8 --section=7 --release="${NAME} ${VERSION}" \
		--center="${NAME} manual" $< $@

${MANDIR}/jukebox-plugins.7: jukebox-plugins.7.pod
	mkdir -p "${MANDIR}"
	${POD2MAN} --utf8 --section=7 --release="${NAME} ${VERSION}" \
		--center="${NAME} manual" $< $@

check: man
	@set -e; for pod in ${PODS}; do \
		${PODCHECKER} "$$pod" >/dev/null; \
	done
	@test -s "${MANDIR}/jukebox.1"
	@test -s "${MANDIR}/jukeboxrc.5"
	@test -s "${MANDIR}/jukebox-layouts.7"
	@test -s "${MANDIR}/jukebox-plugins.7"

install: all
	mkdir -p "${DESTDIR}${BINDIR}"
	${INSTALL} -m 755 jukebox.pl "${DESTDIR}${BINDIR}/jukebox"

	mkdir -p "${DESTDIR}${JUKEBOXDATA}"
	${INSTALL} -m 755 iceserver.pl "${DESTDIR}${JUKEBOXDATA}/iceserver.pl"
	${INSTALL} -m 644 ${MODULES} jukeboxrc.default "${DESTDIR}${JUKEBOXDATA}/"

	mkdir -p "${DESTDIR}${JUKEBOXDATA}/plugins"
	${INSTALL} -m 644 plugins/*.pm "${DESTDIR}${JUKEBOXDATA}/plugins/"
	mkdir -p "${DESTDIR}${JUKEBOXDATA}/layouts"
	${INSTALL} -m 644 layouts/*.layout "${DESTDIR}${JUKEBOXDATA}/layouts/"

	@set -e; find pix -type f -print | while IFS= read -r src; do \
		dst="${DESTDIR}${JUKEBOXDATA}/$$src"; \
		mkdir -p "$$(dirname "$$dst")"; \
		${INSTALL} -m 644 "$$src" "$$dst"; \
	done

	mkdir -p "${DESTDIR}${APPDIR}"
	${INSTALL} -m 644 jukebox.desktop "${DESTDIR}${APPDIR}/jukebox.desktop"
	mkdir -p "${DESTDIR}${ICONDIR}/scalable/apps"
	${INSTALL} -m 644 pix/jukebox.svg \
		"${DESTDIR}${ICONDIR}/scalable/apps/jukebox.svg"

	mkdir -p "${DESTDIR}${MANPREFIX}/man1"
	${INSTALL} -m 644 "${MANDIR}/jukebox.1" \
		"${DESTDIR}${MANPREFIX}/man1/jukebox.1"
	mkdir -p "${DESTDIR}${MANPREFIX}/man5"
	${INSTALL} -m 644 "${MANDIR}/jukeboxrc.5" \
		"${DESTDIR}${MANPREFIX}/man5/jukeboxrc.5"
	mkdir -p "${DESTDIR}${MANPREFIX}/man7"
	${INSTALL} -m 644 "${MANDIR}/jukebox-layouts.7" \
		"${DESTDIR}${MANPREFIX}/man7/jukebox-layouts.7"
	${INSTALL} -m 644 "${MANDIR}/jukebox-plugins.7" \
		"${DESTDIR}${MANPREFIX}/man7/jukebox-plugins.7"

	mkdir -p "${DESTDIR}${DOCDIR}"
	${INSTALL} -m 644 ${DOCS} "${DESTDIR}${DOCDIR}/"

uninstall:
	rm -f "${DESTDIR}${BINDIR}/jukebox"
	rm -rf "${DESTDIR}${JUKEBOXDATA}"
	rm -f "${DESTDIR}${APPDIR}/jukebox.desktop"
	rm -f "${DESTDIR}${ICONDIR}/scalable/apps/jukebox.svg"
	rm -f "${DESTDIR}${MANPREFIX}/man1/jukebox.1"
	rm -f "${DESTDIR}${MANPREFIX}/man5/jukeboxrc.5"
	rm -f "${DESTDIR}${MANPREFIX}/man7/jukebox-layouts.7"
	rm -f "${DESTDIR}${MANPREFIX}/man7/jukebox-plugins.7"
	rm -rf "${DESTDIR}${DOCDIR}"

check-install: check
	rm -rf "${BUILDDIR}/stage"
	${MAKE} DESTDIR="${BUILDDIR}/stage" install
	test -x "${BUILDDIR}/stage${BINDIR}/jukebox"
	test -f "${BUILDDIR}/stage${JUKEBOXDATA}/jukebox_layout.pm"
	test -f "${BUILDDIR}/stage${JUKEBOXDATA}/plugins/artistinfo.pm"
	test -f "${BUILDDIR}/stage${JUKEBOXDATA}/layouts/main.layout"
	test -f "${BUILDDIR}/stage${MANPREFIX}/man5/jukeboxrc.5"

clean:
	rm -rf "${BUILDDIR}"
	rm -f "${DIST}.tar.gz"

dist: clean
	git archive --format=tar.gz -o "${DIST}.tar.gz" \
		--prefix="${DIST}/" HEAD

.PHONY: all man check install uninstall check-install clean dist
