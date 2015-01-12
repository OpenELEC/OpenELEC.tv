################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2014 Alex Deryskyba (alex@codesnake.com)
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

PKG_NAME="amremote"
PKG_VERSION="aa0a9e8"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_SITE="http://www.amlogic.com"
PKG_URL="https://github.com/codesnake/amremote/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="sysutils/remote"
PKG_SHORTDESC="amremote - IR remote configuration utility for Amlogic-based devices"
PKG_LONGDESC="amremote - IR remote configuration utility for Amlogic-based devices"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp remotecfg $INSTALL/usr/bin
}

post_install() {
  enable_service amlogic-remotecfg.service
}

PKG_SHA256="21763fa87887303bcb481cfc0fddd8db36ebb44736cd49d568d0d9cea11abe43"
