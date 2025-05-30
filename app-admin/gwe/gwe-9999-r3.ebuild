# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

inherit meson python-single-r1 gnome2-utils git-r3

DESCRIPTION="Utility which provides info, control the fans, and overclock your NVIDIA card"
HOMEPAGE="https://gitlab.com/leinardi/gwe"

EGIT_REPO_URI="https://gitlab.com/leinardi/gwe.git"
EGIT_SUBMODULES=('-*')
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	dev-libs/gobject-introspection
	dev-libs/libayatana-appindicator
	dev-libs/libdazzle

	$(python_gen_cond_dep '
		>=dev-python/injector-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.8.2[${PYTHON_USEDEP}]
		>=dev-python/peewee-3.17.0[${PYTHON_USEDEP}]
		>=dev-python/py3nvml-0.2.7[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		>=dev-python/python-xlib-0.33[${PYTHON_USEDEP}]
		>=dev-python/pyxdg-0.28[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=dev-python/reactivex-4.0.4[${PYTHON_USEDEP}]
	')
"

DEPEND="${RDEPEND}"

src_prepare() {
	# Prevent meson from running install script.
	sed meson.build \
		-e "s|meson.add_install_script('scripts/meson_post_install.py')||g" \
		-i || die
	default
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	gnome2_schemas_update
}
