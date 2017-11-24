#!/bin/bash
#

STEAMLINK_IP="192.168.10.109"
VERSION="4.4"
DOWNLOAD_URL="http://http.debian.net/debian/pool/main/b/bash/bash_${VERSION}.orig.tar.xz"
PROGNAME="bash"

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
BUILD="${TOP}/${PROGNAME}-build"
SRC="${TOP}/${PROGNAME}-${VERSION}"

#
# Download the source
#
if [ ! -d "${SRC}" ]; then
	wget $DOWNLOAD_URL -O- | tar xJS || exit 1
fi

#
# Build it
#
mkdir -p "${BUILD}"
pushd "${BUILD}"
"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
popd

#
# All done!
#
echo "Build complete!"
echo
echo "To copy ${PROGNAME} to the Steam Link, run:"
echo "scp \"${BUILD}/${PROGNAME}\" root@${STEAMLINK_IP}:/home/steam/bin/"
echo "don't forget supplied .inputrc for working HOME and END keys"
