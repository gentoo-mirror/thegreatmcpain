# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Additional style plugins for Qt5 (gtk2, cleanlooks, plastic, motif)"
HOMEPAGE="https://code.qt.io/cgit/qt/qtstyleplugins"
COMMIT="335dbece103e2cbf6c7cf819ab6672c2956b17b3"
KEYWORDS="amd64 ~arm x86"
SRC_URI="https://github.com/qt/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LGPL-2"
SLOT="5"
IUSE=""

DEPEND="
	dev-qt/qtgui:5=
	dev-qt/qtdbus:5=
	x11-libs/gtk+:2
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake5
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst(){
	echo
	einfo "To make QT5 applications use the gtk2 style"
	einfo "insert the following into your ~/.xprofile or ~/.profile:"
	einfo "QT_QPA_PLATFORMTHEME=gtk2"
	einfo "If you're using Wayland with GNOME, do this in your ~/.pam_environment:"
	einfo "QT_QPA_PLATFORMTHEME OVERRIDE=gtk2"
	einfo "Optionally, you can use the x11-misc/qt5ct app to do that."
	echo
}
