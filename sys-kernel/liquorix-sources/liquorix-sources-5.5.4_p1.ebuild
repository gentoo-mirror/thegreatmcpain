# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eapi7-ver

COMPRESSTYPE=".tar.gz"
K_USEPV="yes"
UNIPATCH_STRICTORDER="yes"
K_SECURITY_UNSUPPORTED="1"
TAG="5.5-7"

CKV="$(ver_cut 1-2)"
ETYPE="sources"

inherit kernel-2
#detect_version
K_NOSETEXTRAVERSION="don't_set_it"

DESCRIPTION="The Liquorix Kernel Sources v5.x"
HOMEPAGE="http://liquorix.net/"
LIQUORIX_VERSION="${TAG/_p[0-9]*}"
LIQUORIX_FILE="${LIQUORIX_VERSION}${COMPRESSTYPE}"
LIQUORIX_URI="https://github.com/damentz/liquorix-package/archive/${LIQUORIX_FILE}"
SRC_URI="${KERNEL_URI} ${LIQUORIX_URI}";

KEYWORDS="-* ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

KV_FULL="${PVR/_p/-pf}"
S="${WORKDIR}"/linux-"${KV_FULL}"

pkg_setup(){
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the Liquorix developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_prepare(){
	epatch "${DISTDIR}"/"${LIQUORIX_FILE}"
	# Reversing "mm: Proactive Compation" patch due to build error
	#epatch "${FILESDIR}"/reversed-mm-proactive-compaction.patch
	epatch "${FILESDIR}"/4567_distro-Gentoo-Kconfig.patch
	# Might fix ntfs3g fuse crashes
	epatch "${FILESDIR}"/fix-fuse_request_end-crash.patch
}

K_EXTRAEINFO="For more info on liquorix-sources and details on how to report problems, see: \
${HOMEPAGE}."
