################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="connman-ncurses"
PKG_VERSION="3c34b2e"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/eurogiciel-oss/connman-json-client"
PKG_URL="$LAKKA_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses json-c"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="A ncurses UI for connman"
PKG_LONGDESC="A ncurses UI for connman"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-optimization --enable-debug"

pre_configure_target() {
  if [ -f ../configure ]; then
    sed -i "s|/usr/include/ncurses|$SYSROOT_PREFIX/usr/include/ncurses|g" ../configure
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp connman_ncurses $INSTALL/usr/bin/connman-ncurses
}
