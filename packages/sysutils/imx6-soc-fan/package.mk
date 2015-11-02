################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2015 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="imx6-soc-fan"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_SITE="http://www.openelec.tv/"
PKG_URL=""
PKG_DEPENDS_TARGET="imx6-status-led"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="i.MX6 SoC fan monitor"
PKG_LONGDESC="i.MX6 SoC fan monitor for TBS Matrix system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  : # nothing
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config
  cp $PKG_DIR/config/* $INSTALL/usr/config

  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/bin/* $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/lib/openelec
  cp $PKG_DIR/scripts/* $INSTALL/usr/lib/openelec
}

post_install() {
  enable_service imx6-soc-fan-monitor.service
}
