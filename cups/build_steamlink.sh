#!/bin/bash
#
STEAMLINK_IP="192.168.10.109"
VERSION="2.2.6"
PROGNAME="cups"
TARGET_DIR="/home/steam/opt"
DOWNLOAD_URL="https://github.com/apple/cups/releases/download/v2.2.6/${PROGNAME}-${VERSION}-source.tar.gz"

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
"${SRC}"/configure $STEAMLINK_CONFIGURE_OPTS ; pwd || exit 1
make || exit 1
"${CROSS}"strip -s ${PROGNAME}
make BUILDROOT=${BUILD} install 
popd
cp cgi.types ${PROGNAME}-build/etc/${PROGNAME}/
tar -cf ${PROGNAME}-build.tar ${PROGNAME}-build  
#
# All done!
#
echo "Build complete!"
echo
echo "To copy ${PROGNAME} to the Steam Link, run:"
echo "scp \"${PROGNAME}-build.tar\" root@${STEAMLINK_IP}:/home/steam/opt/"
echo "unpack archive:"
echo "cd /home/steam/opt/ && tar -xf ${PROGNAME}-build.tar"
echo "add paths to your .bashrc:"
echo "PATH=$PATH:~/bin:/home/steam/opt/cups/usr/bin:/home/steam/opt/cups/usr/sbin"
echo "export LD_LIBRARY_PATH=:/home/steam/libs:/home/steam/opt/cups/usr/lib"
echo "run:"
echo "cupsd -c /home/steam/opt/cups/etc/cups/cupsd.conf -s /home/steam/opt/cups/etc/cups/cups-files.conf -f"
echo "cupsctl --remote-admin"
