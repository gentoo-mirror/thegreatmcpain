# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson multilib-minimal flag-o-matic toolchain-funcs

DESCRIPTION="A Vulkan-based translation layer for Direct3D 10/11"
HOMEPAGE="https://github.com/doitsujin/dxvk"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/doitsujin/dxvk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
fi

LICENSE="ZLIB"
SLOT=0

RESTRICT="test strip"

RDEPEND="
	|| (
		>=app-emulation/wine-vanilla-3.14:*[${MULTILIB_USEDEP},vulkan]
		>=app-emulation/wine-staging-3.14:*[${MULTILIB_USEDEP},vulkan]
	)"
DEPEND="${RDEPEND}
	dev-util/glslang"

if [[ ${PV} != "9999" ]] ; then
	S="${WORKDIR}/dxvk-${PV}"
fi

PATCHES=(
	"${FILESDIR}/flags.patch"
)

bits() { [[ ${ABI} = amd64 ]] && echo 64 || echo 32; }

is_mingw() {
	# For some reason tc-getCXX won't work correctly for this,
	# so I'm just going to see if the files exist.
	if [[ ${ABI} = amd64 ]]; then
		if which x86_64-w64-mingw32-g++ >/dev/null; then
			return 0
		else
			return 1
		fi
	else
		if which i686-w64-mingw32-g++ >/dev/null; then
			return 0
		else
			return 1
		fi
	fi
}

dxvk_check_mingw() {
	if ! is_mingw; then
		ewarn
		ewarn "You need to have a mingw32 toolchain installed."
		ewarn "To set up a mingw32 toolchain please read the 'Setting up Mingw in Gentoo' section here."
		ewarn "https://gitlab.com/TheGreatMcPain/thegreatmcpain-overlay/app-emulation#setting-up-mingw-in-gentoo"
		ewarn
		die "Mingw32 toolchain required."
	fi
}

dxvk_check_requirements() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! tc-is-gcc || [[ $(gcc-major-version) -lt 7 || $(gcc-major-version) -eq 7 && $(gcc-minor-version) -lt 3 ]]; then
			die "At least gcc 7.3 is required"
		fi
	fi
}

pkg_pretend() {
	multilib_foreach_abi dxvk_check_mingw
	dxvk_check_requirements
}

pkg_setup() {
	multilib_foreach_abi dxvk_check_mingw
	dxvk_check_requirements
}

src_prepare() {
	default

	replace-flags "-O3" "-O3 -fno-stack-protector"

	# Create versioned setup script
	cp "setup_dxvk.sh" "dxvk-mingw-setup"
	sed -e "s#basedir=.*#basedir=\"${EPREFIX}/usr\"#" -i "dxvk-mingw-setup" || die

	bootstrap_dxvk() {
		# Set DXVK location for each ABI
		sed -e "s#x$(bits)#$(get_libdir)/dxvk-mingw#" -i "${S}/dxvk-mingw-setup" || die

		# Add *FLAGS to cross-file
		sed -i \
			-e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS}")!" \
			-e "s!@CXXFLAGS@!$(_meson_env_array "${CXXFLAGS}")!" \
			-e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
			build-win$(bits).txt || die
	}

	multilib_foreach_abi bootstrap_dxvk

	# Clean missed ABI in setup script
	sed -e "s#.*x32.*##" -e "s#.*x64.*##" \
		-i "dxvk-mingw-setup" || die
}

multilib_src_configure() {
	local emesonargs=(
		--cross-file="${S}/build-win$(bits).txt"
		--libdir="$(get_libdir)/dxvk-mingw"
		--bindir="$(get_libdir)/dxvk-mingw"
		--strip
		-Denable_tests=false
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	# create combined setup helper
	exeinto /usr/bin
	doexe "${S}/dxvk-mingw-setup"

	dodoc "${S}/dxvk.conf"

	einstalldocs
}
