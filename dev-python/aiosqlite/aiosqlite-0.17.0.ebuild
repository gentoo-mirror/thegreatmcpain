# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS="pyproject.toml"

inherit distutils-r1

DESCRIPTION="asyncio bridge to the standard sqlite3 module"
HOMEPAGE="
	https://aiosqlite.omnilib.dev
	https://pypi.org/project/aiosqlite
	https://github.com/jreese/aiosqlite
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

RDEPEND="dev-python/typing-extensions[${PYTHON_USEDEP}]"
BDEPEND=""

# AttributeError: 'str' object has no attribute 'supported'
#distutils_enable_sphinx docs dev-python/m2r
