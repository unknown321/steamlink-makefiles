#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="0.62.0"
PROGNAME="poppler"
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
sed -i 's/find_package(Freetype/find_library(Freetype/g' CMakeLists.txt
export CMAKE_INCLUDE_PATH="${MARVELL_ROOTFS}/usr/include:${MARVELL_ROOTFS}/usr/local/include"
export CMAKE_LIBRARY_PATH="${MARVELL_ROOTFS}/usr/lib:${MARVELL_ROOTFS}/usr/local/lib"
CMAKE_CONFIGURE_OPTS=" -DENABLE_QT5=OFF \
-DBUILD_QT5_TESTS=OFF \
-DBUILD_GTK_TESTS=OFF \
-DENABLE_CPP=ON \
-DENABLE_XPDF_HEADERS=ON \
-DFREETYPE_INCLUDE_DIRS=${MARVELL_ROOTFS}/usr/include/freetype2/ \
-DCMAKE_INSTALL_PREFIX:PATH=/usr
"
cmake $STEAMLINK_CONFIGURE_OPTS $CMAKE_CONFIGURE_OPTS . ; pwd || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
make DESTDIR=${BUILD} install 
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
