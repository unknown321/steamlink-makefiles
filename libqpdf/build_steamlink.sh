#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="7.0.0"
PROGNAME="qpdf"
#TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="https://github.com/qpdf/qpdf/archive/release-${PROGNAME}-${VERSION}.tar.gz"

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
BUILD="${TOP}/${PROGNAME}-build"
mkdir ${BUILD}
SRC="${TOP}/qpdf-release-${PROGNAME}-${VERSION}"

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
"${SRC}"/autogen.sh
"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS --prefix=${BUILD}/usr --with-random=/dev/urandom ; pwd || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
make BUILDROOT=${BUILD} install
sed -i "s/, libjpeg//g" ${BUILD}/usr/lib/pkgconfig/libqpdf.pc
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
