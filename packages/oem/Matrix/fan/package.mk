################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="fan"
PKG_VERSION="1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="Fan monitor script"
PKG_LONGDESC="Fan monitor script"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  : # nothing to make
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config
  cp -PR $PKG_DIR/config/* $INSTALL/usr/config
  mkdir -p $INSTALL/usr/bin
  cp -PR $PKG_DIR/bin/* $INSTALL/usr/bin
}

post_install() {
  enable_service fanmonitor.service
}
