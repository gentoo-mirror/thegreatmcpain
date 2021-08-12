# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2034
EAPI=7

DESCRIPTION="Wine Mono is a replacement for the .NET runtime and class libraries in Wine"
HOMEPAGE="https://www.winehq.org/"
SRC_URI="https://github.com/madewokherd/${PN}/releases/download/${P}/${P}-x86.msi"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT MPL-1.1"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/wine/mono"
	doins "${DISTDIR}/${P}-x86.msi"
}
