#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="9.22"
PROGNAME="ghostscript"
TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs922/${PROGNAME}-${VERSION}.tar.gz"

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
export CFLAGSAUX=" "
rm -rf ${SRC}/libpng
"${SRC}"/autogen.sh $STEAMLINK_CONFIGURE_OPTS --with-arch_h=/home/unknown/steamlink/steamlink-sdk/examples/ghostscript/arch.h --without-x --with-system-libtiff --without-jbig2dec || exit 1
#"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS  || exit 1
sed -i 's/^CCAUX=.*/CCAUX=gcc/g' ${SRC}/Makefile
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
make DESTDIR=${BUILD} install 
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
echo
echo "To copy ${PROGNAME} to the Steam Link, run:"
echo "scp \"${PROGNAME}-build.tar\" root@${STEAMLINK_IP}:/home/steam/opt/"
