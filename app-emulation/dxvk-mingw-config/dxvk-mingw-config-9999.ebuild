# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson multilib-minimal flag-o-matic

DESCRIPTION="dxvk_config.dll library from Valve's Proton (mingw)"
HOMEPAGE="https://github.com/ValveSoftware/dxvk"

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
	"${FILESDIR}/add-dxvk-mingw_config-library.patch"
)

bits() { [[ ${ABI} = amd64 ]] && echo 64 || echo 32; }

dxvk_check_mingw() {
	local -a categories
	use abi_x86_64 && categories+=("cross-x86_64-w64-mingw32")
	use abi_x86_32 && categories+=("cross-i686-w64-mingw32")

	for cat in ${categories[@]}; do
		if ! has_version -b "${cat}/mingw64-runtime[libraries]" ||
				! has_version -b "${cat}/gcc"; then
			eerror "The ${cat} toolchain is not properly installed."
			eerror "Make sure to install ${cat}/gcc with:"
			eerror "EXTRA_ECONF=\"--enable-threads=posix --disable-sjlj-exceptions --with-dwarf2\""
			eerror "and ${cat}/mingw64-runtime with USE=\"libraries\"."
			einfo
			einfo "For a short guide please go to the link below.:"
			einfo "<https://gitlab.com/TheGreatMcPain/thegreatmcpain-overlay/-/tree/master/app-emulation#setting-up-mingw-in-gentoo>"
			einfo
			die "${cat} toolchain required."
		fi
	done
}

pkg_pretend() {
	dxvk_check_mingw
}

pkg_setup() {
	dxvk_check_mingw
}

src_prepare() {
	default

	# For some reason avx is causing issues,
	# so disable it if '-march' is used.
	if [ $(is-flag "-march=*") = "true" ]; then
		append-flags "-mno-avx"
	fi

	replace-flags "-O3" "-O3 -fno-stack-protector"

	# Create versioned setup script
	cp "setup_dxvk.sh" "dxvk-mingw-config-setup"
	sed \
		-e "s#with_dxgi=1#with_dxgi=0#" \
		-e "s#\$action d3d1.*##" \
		-e "s#basedir=.*#basedir=\"${EPREFIX}/usr\"#" -i "dxvk-mingw-config-setup" || die

	bootstrap_dxvk() {
		# Set DXVK location for each ABI
		sed -e "s#x$(bits)#$(get_libdir)/dxvk-mingw-config#" -i "${S}/dxvk-mingw-config-setup" || die

		# Add *FLAGS to cross-file
		sed -i \
			-e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS}" -fpermissive)!" \
			-e "s!@CXXFLAGS@!$(_meson_env_array "${CXXFLAGS}" -fpermissive)!" \
			-e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
			build-win$(bits).txt || die
	}

	multilib_foreach_abi bootstrap_dxvk

	# Clean missed ABI in setup script
	sed -e "s#.*x32.*##" -e "s#.*x64.*##" \
		-i "dxvk-mingw-config-setup" || die
}

multilib_src_configure() {
	local emesonargs=(
		--cross-file="${S}/build-win$(bits).txt"
		--libdir="$(get_libdir)/dxvk-mingw-config"
		--bindir="$(get_libdir)/dxvk-mingw-config"
		--strip
		-Denable_tests=false
		-Denable_dxgi=false
		-Denable_d3d9=false
		-Denable_d3d10=false
		-Denable_d3d11=false
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	# create combined setup helper
	exeinto /usr/bin
	doexe "${S}/dxvk-mingw-config-setup"

	dodoc "${S}/dxvk.conf"

	einstalldocs
}
