# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/app-text/ispell/ispell-3.3.02.ebuild,v 1.2 2007/11/22 19:25:48 philantrop Exp $

inherit eutils multilib

PATCH_VER="0.2"
DESCRIPTION="fast screen-oriented spelling checker"
HOMEPAGE="http://fmg-www.cs.ucla.edu/geoff/ispell.html"
SRC_URI="http://fmg-www.cs.ucla.edu/geoff/tars/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~x86"
IUSE=""
LINGUAS="bg cs da de es et fi fr ga hu it lt nl no pl pt pt_BR ru sl sv"
for X in ${LINGUAS} ; do
	IUSE="${IUSE} linguas_${X}"
done


DEPEND="sys-apps/sed
		sys-apps/miscfiles
		>=sys-libs/ncurses-5.2
		app-admin/eselect-ispell"
PDEPEND="linguas_fi? ( app-text/tmispell )"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-gentoo-${PATCH_VER}.diff"
	epatch "${FILESDIR}/${P}-fix-getline.diff"

	sed -i -e "s:GENTOO_LIBDIR:$(get_libdir):" local.h.gentoo || die "setting
	libdir failed"
	cp local.h.gentoo local.h
}

src_compile() {
	emake -j1 config.sh || die "configuration failed"

	# Fix config.sh to install to ${D}
	cp -p config.sh config.sh.orig
	sed \
		-e "s:^\(BINDIR='\)\(.*\):\1${D}\2:" \
		-e "s:^\(LIBDIR='\)\(.*\):\1${D}\2:" \
		-e "s:^\(MAN1DIR='\)\(.*\):\1${D}\2:" \
		-e "s:^\(MAN45DIR='\)\(.*\):\1${D}\2:" \
		< config.sh > config.sh.install

	make -j1 
}

src_install() {
	cp -p  config.sh.install config.sh

	# Need to create the directories to install into
	# before 'make install'. Build environment **doesn't**
	# check for existence and create if not already there.
	dodir /usr/bin /usr/$(get_libdir)/ispell /usr/share/info \
		/usr/share/man/man1 /usr/share/man/man5

	emake -j1 install || die "install failed"

	mv "${D}/usr/bin/ispell" "${D}/usr/bin/ispell.real"

	rmdir "${D}"/usr/share/info

	dodoc Contributors README WISHES || die "installing docs failed"
	dosed "${D}"/usr/share/man/man1/ispell.1 || die "dosed failed"
}

pkg_postinst() {
	echo
	ewarn "If you just updated from an older version of ${PN} you *have* to re-emerge"
	ewarn "all your dictionaries to avoid segmentation faults and other problems."
	echo
	elog "ispell was installed under ${ROOT}/usr/bin/ispell.real"
	eselect ispell update --if-unset
	elog "You can manage ${ROOT}/usr/bin/ispell implementations with:"
	elog "	eselect ispell"
	if use linguas_fi ; then
			elog "Using tmispell instead of ispell_fi"
	fi

}
