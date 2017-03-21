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

PKG_NAME="libnl-tiny"
PKG_VERSION="1.0.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/sabotage-linux/libnl-tiny"
PKG_URL="http://ftp.barfooze.de/pub/sabotage/tarballs/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="libnl-tiny: tiny replacement for libnl versions 1 and 2"
PKG_LONGDESC="libnl-tiny is a tiny replacement for libnl versions 1 and 2 whichis a library for applications dealing with netlink socket. It provides an easy to use interface for raw netlink message but also netlink family specific APIs."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

LIBNLTINY_MAKE_OPTS="CC=$CC AR=$AR RANLIB=$RANLIB prefix=/usr SHAREDLIB="

PKG_MAKE_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"
PKG_MAKEINSTALL_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"

