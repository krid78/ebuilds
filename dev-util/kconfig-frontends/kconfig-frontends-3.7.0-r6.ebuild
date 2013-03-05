# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools mercurial

EHG_REPO_URI="http://ymorin.is-a-geek.org/hg/kconfig-frontends"
EHG_REVISION="aeffa50eadee"

DESCRIPTION="A Proof-of-concept packaging of the kconfig parser and frontends"
HOMEPAGE="http://ymorin.is-a-geek.org/projects/kconfig-frontends"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ncurses qt4 gtk utils"

DEPEND="ncurses? ( sys-libs/ncurses )
        qt4? ( dev-qt/qtcore )
        gtk? ( x11-libs/gtk+:2 )
		"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README ) # NEWS file is empty

src_prepare () {
	_elibtoolize --copy --force
	eaclocal -Wall --force
	eautoconf -Wall --force
	eautoheader -Wall --force
	eautomake --foreign --add-missing --copy -Wall --force
	#alternative
	#cd ${S} && ./bootstrap
}

src_configure () {
	local myconf
	if use ncurses; then
		myconf="${myconf} --enable-mconf --enable-nconf"
	fi
	if use gtk; then
		myconf="${myconf} --enable-gconf"
	fi
	if use qt4; then
		myconf="${myconf} --enable-qconf"
	fi
	if use utils; then
		myconf="${myconf} --enable-utils"
	fi
	econf \
		--disable-silent-rules \
		--enable-wall \
		--enable-werror \
		--enable-config-prefix=HLCONF_ \
		--enable-conf \
		${myconf}
}

src_compile () {
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc ${DOC} || die
}

pkg_postinst() {
	elog "config uses 'HLCONF_' as the default symbol prefix. Set the environment"
	elog "variable CONFIG_ to the prefix to use. Eg.: CONFIG_=\"FOO_\" config ..."
}
