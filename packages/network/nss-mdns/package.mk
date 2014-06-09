################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2014 Jean-Charles Andlauer (andlauer@gmail.com)
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

PKG_NAME="nss-mdns"
PKG_VERSION="0.10"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GNU LGPL"
PKG_SITE="http://0pointer.de/lennart/projects/nss-mdns/"
PKG_URL="${PKG_SITE}$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain avahi"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="NSS module for Multicast DNS name resolution"
PKG_LONGDESC="nss-mdns is a plugin for the GNU Name Service Switch (NSS) functionality of the GNU C Library (glibc) providing host name resolution via Multicast DNS (aka Zeroconf, aka Apple Rendezvous), effectively allowing name resolution by common Unix/Linux programs in the ad-hoc mDNS domain .local."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/"

MAKEFLAGS="-j1"

post_makeinstall_target() {

  mkdir -p $INSTALL/usr/config
  cp $PKG_DIR/config/nsswitch.mdns4 $INSTALL/usr/config

  mkdir -p $INSTALL/usr/lib
  ln -s ../../lib/libnss_mdns.so.2          $INSTALL/usr/lib/libnss_mdns.so
  ln -s ../../lib/libnss_mdns4.so.2         $INSTALL/usr/lib/libnss_mdns4.so
  ln -s ../../lib/libnss_mdns4_minimal.so.2 $INSTALL/usr/lib/libnss_mdns4_minimal.so
  ln -s ../../lib/libnss_mdns6.so.2         $INSTALL/usr/lib/libnss_mdns6.so
  ln -s ../../lib/libnss_mdns6_minimal.so.2 $INSTALL/usr/lib/libnss_mdns6_minimal.so
  ln -s ../../lib/libnss_mdns_minimal.so.2  $INSTALL/usr/lib/libnss_mdns_minimal.so
}
