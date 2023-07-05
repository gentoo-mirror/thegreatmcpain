# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python dependency injection framework, inspired by Guice"
HOMEPAGE="https://pypi.org/project/injector/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
