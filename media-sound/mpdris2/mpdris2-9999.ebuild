# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7,8} )

inherit python-r1 autotools eutils git-r3

MY_PN="${PN/d/D}"

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"
HOMEPAGE="https://github.com/eonpatapon/mpDris2"
EGIT_REPO_URI="https://github.com/eonpatapon/mpDris2.git"
#EGIT_REPO_URI="git://github.com/eonpatapon/mpDris2.git"
#EGIT_BRANCH="python-3"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

LANGS="fr nl"

for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
done

DEPEND="
	>=dev-python/dbus-python-0.80[$PYTHON_USEDEP]
	>=dev-python/pygobject-3.28.3[$PYTHON_USEDEP]
	>=dev-python/python-mpd-0.3.0[$PYTHON_USEDEP]"

DOCS="AUTHORS COPYING INSTALL NEWS README README.md"

src_prepare() {
	default
	eautoreconf
}

_clean_up_locales() {
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "l10n_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/"${lang}" || die
	done
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"

	_clean_up_locales

}
