# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Gives you the performance of web Discord with the confort of Discord Desktop"
HOMEPAGE="https://github.com/Vencord/Vesktop"
SRC_URI="https://github.com/Vencord/Vesktop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox" # TODO Make this install offline.

#DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/pnpm-bin
"

S="${WORKDIR}/Vesktop-${PV}"

src_compile() {
	pnpm i
	pnpm package:dir
}

src_install() {
	insinto /usr/lib/vencord
	doins -r dist/linux-unpacked/.

	# Fix executable permissions
	fperms +x /usr/lib/vencord/vencorddesktop
	fperms +x /usr/lib/vencord/chrome_crashpad_handler
	fperms +x /usr/lib/vencord/chrome-sandbox
	fperms +x /usr/lib/vencord/*.so*

	domenu "${FILESDIR}/vesktop.desktop"
	doicon static/icon.png
	dodoc LICENSE

	dosym /usr/lib/vencord/vencorddesktop /usr/bin/vesktop
}
