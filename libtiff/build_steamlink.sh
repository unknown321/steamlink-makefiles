#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="4.0.9"
PROGNAME="tiff"
#TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="http://download.osgeo.org/libtiff/${PROGNAME}-${VERSION}.tar.gz"

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
	wget $DOWNLOAD_URL -O- | tar xzS || exit 1
fi

#
# Build it
#
pushd "${SRC}"
"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS --prefix=${BUILD}/usr ; pwd || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
make BUILDROOT=${BUILD} install 
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
