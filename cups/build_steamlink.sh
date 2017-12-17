#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="2.2.6"
PROGNAME="cups"
DOWNLOAD_URL="https://github.com/apple/cups/releases/download/v2.2.6/${PROGNAME}-${VERSION}-source.tar.gz"

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
	wget $DOWNLOAD_URL -O- | tar xzS || exit 1
fi

#
# Build it
#
pushd "${SRC}"
"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS ; pwd || exit 1
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
