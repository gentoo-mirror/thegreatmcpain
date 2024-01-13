# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager, alternative to npm and yarn"
HOMEPAGE="https://pnpm.io"

SRC_URI="https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-x64 -> ${P}"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

RESTRICT="strip"

S="${WORKDIR}"

src_install() {
	newbin "${DISTDIR}/${P}" ${PN/-bin/}
}
