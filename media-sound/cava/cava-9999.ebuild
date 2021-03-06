# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info git-r3 eutils autotools flag-o-matic

DESCRIPTION="Console-based Audio Visualizer for ALSA (=CAVA)"
HOMEPAGE="https://github.com/karlstav/cava"
EGIT_REPO_URI="https://github.com/karlstav/cava.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="sci-libs/fftw:*
		dev-libs/iniparser:4
		sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS="README.md"

pkg_setup() {
		if linux_config_exists ; then
			einfo "Checking kernel configuration at $(linux_config_path)..."
			if ! linux_chkconfig_present SND_ALOOP ; then
				ewarn 'Kernel option CONFIG_SND_ALOOP=[ym] needed but missing'
			fi
		fi
}

src_prepare() {
	# Remove hardcoded '/usr/local/lib' LDFLAG
	sed -i "s|-L/usr/local/lib -Wl,-rpath /usr/local/lib||" Makefile.am || die

	eapply_user
	if [[ "${PV}" = "9999" ]]; then
		git describe --always --tags --dirty > version
	else
		echo ${PV} > version
	fi
	# Make sure we use iniparser:4
	append-cppflags -I/usr/include/iniparser4
	eautoreconf
}

src_configure() {
	econf \
			$(use_enable debug ) \
			--docdir="${EREFIX}"/usr/share/doc/${PF}
}

src_compile() {
	emake SYSTEM_LIBINIPARSER=1
}

src_install() {
	einstalldocs
	emake DESTDIR="${D}" PREFIX=/usr SYSTEM_LIBINIPARSER=1 install
}
