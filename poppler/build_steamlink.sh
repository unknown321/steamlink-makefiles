#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="0.62.0"
PROGNAME="poppler"
#TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="https://poppler.freedesktop.org/${PROGNAME}-${VERSION}.tar.xz"

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
BUILD="${TOP}/${PROGNAME}-build"
mkdir ${BUILD}
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
pushd "${SRC}"
#env; exit 1
cmake $STEAMLINK_CONFIGURE_OPTS . ; pwd || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
#make BUILDROOT=${BUILD} install 
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
