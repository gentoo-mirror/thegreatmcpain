# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Library to provide an easy API to file locking"
HOMEPAGE="https://github.com/WoLpH/portalocker"
SRC_URI="https://github.com/WoLpH/portalocker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
		cd docs || die
		emake html
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc README.rst CHANGELOG.rst
	use doc && dodoc -r docs/_build/html
}
