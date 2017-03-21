################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="bluez"
PKG_VERSION="5.44"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.bluez.org/"
PKG_URL="http://www.kernel.org/pub/linux/bluetooth/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain dbus glib readline netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="bluez: Bluetooth Tools and System Daemons for Linux."
PKG_LONGDESC="Bluetooth Tools and System Daemons for Linux."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking \
                           --disable-silent-rules \
                           --disable-library \
                           --enable-udev \
                           --disable-cups \
                           --disable-obex \
                           --enable-client \
                           --disable-systemd \
                           --enable-tools \
                           --enable-datafiles \
                           --disable-experimental \
                           --enable-deprecated \
                           --enable-sixaxis \
                           --with-gnu-ld \
                           storagedir=/storage/.cache/bluetooth"

if [ "$DEBUG" = "yes" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-debug"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-debug"
fi

if [ "$DEVTOOLS" = "yes" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-monitor --enable-test"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-monitor --disable-test"
fi

pre_configure_target() {
# bluez fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

  export LIBS="-lncurses -lterminfo"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/bccmd
  rm -rf $INSTALL/usr/bin/bluemoon
  rm -rf $INSTALL/usr/bin/ciptool
  rm -rf $INSTALL/usr/share/dbus-1

  mkdir -p $INSTALL/usr/bin
    cp tools/btinfo $INSTALL/usr/bin
    cp tools/btmgmt $INSTALL/usr/bin

  mkdir -p $INSTALL/etc/bluetooth
    echo "[Policy]" > $INSTALL/etc/bluetooth/main.conf
    echo "AutoEnable=true" >> $INSTALL/etc/bluetooth/main.conf
}

post_install() {
  enable_service bluetooth.service
  enable_service obex.service
}
