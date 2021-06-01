# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 git-r3

DESCRIPTION="Chia's implementation of BIP 158"
HOMEPAGE="https://github.com/Chia-Network/chiabip158"
EGIT_REPO_URI="https://github.com/Chia-Network/chiabip158"
EGIT_COMMIT="${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""
