# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="Mausezahn is a free fast traffic generator written in C which allows you to send nearly every possible and impossible packet."
HOMEPAGE="http://www.perihel.at/sec/mz/index.html"
SRC_URI="http://www.perihel.at/sec/mz/mz-0.40.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-libs/libpcap-0.8
>=net-libs/libnet-1.1
>=dev-libs/libcli-1.9.1
>=dev-util/cmake-2.8"
RDEPEND="${DEPEND}"

MY_P="mz-${PV}"
S=${WORKDIR}/${MY_P}

src_prepare() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
}
