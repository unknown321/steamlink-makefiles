#!/bin/bash
#


export PKG_CONFIG_LIBDIR=/home/unknown/steamlink/steamlink-sdk/rootfs/usr/lib/pkgconfig:/home/unknown/steamlink/steamlink-sdk/rootfs/usr/local/Qt-5.9.1/lib/pkgconfig 
export STEAMLINK_CONFIGURE_OPTS=--host=armv7a-cros-linux-gnueabi --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-sysroot=/home/unknown/steamlink/steamlink-sdk/rootfs
export CC=armv7a-cros-linux-gnueabi-gcc --sysroot=/home/unknown/steamlink/steamlink-sdk/rootfs -marm -mfpu=neon -mfloat-abi=hard 
export PKG_CONFIG_SYSROOT_DIR=/home/unknown/steamlink/steamlink-sdk/rootfs 
export STRIP=armv7a-cros-linux-gnueabi-strip 
export PWD=/home/unknown/steamlink/steamlink-sdk/examples/foo2xqx/foo2zjs
export MARVELL_SDK_PATH=/home/unknown/steamlink/steamlink-sdk 
export HOME=/home/unknown 
export QT_ACCESSIBILITY=1 
export AS=armv7a-cros-linux-gnueabi-as 
export CXX=armv7a-cros-linux-gnueabi-g++ --sysroot=/home/unknown/steamlink/steamlink-sdk/rootfs -marm -mfpu=neon -mfloat-abi=hard
export SHELL=/bin/bash 
export CROSS=armv7a-cros-linux-gnueabi- 
export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1 
export MARVELL_ROOTFS=/home/unknown/steamlink/steamlink-sdk/rootfs
export SHLVL=4 
export CROSS_COMPILE=armv7a-cros-linux-gnueabi-
export LDFLAGS=-static-libgcc -static-libstdc++
export PATH=/home/unknown/steamlink/steamlink-sdk/toolchain/bin:/home/unknown/steamlink/steamlink-sdk/bin:/home/unknown/steamlink/steamlink-sdk/external/qt-everywhere-opensource-src-5.9.1/build/host/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
export CPP=armv7a-cros-linux-gnueabi-cpp --sysroot=/home/unknown/steamlink/steamlink-sdk/rootfs


STEAMLINK_IP="192.168.10.109"
PROGNAME="foo2zjs"
TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="http://foo2zjs.rkkda.com/${PROGNAME}.tar.gz"

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
BUILD="${TOP}/${PROGNAME}-build"
mkdir ${BUILD}
SRC="${TOP}/${PROGNAME}"

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
echo $STEAMLINK_CONFIGURE_OPTS
"${SRC}"/make; pwd || exit 1
"${CROSS}"strip -s ${PROGNAME}
make install DESTDIR=${BUILD} || exit 1
popd
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
