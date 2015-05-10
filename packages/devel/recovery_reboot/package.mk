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

PKG_NAME="recovery_reboot"
PKG_VERSION="0.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://amlinux.ru/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain busybox"
PKG_DEPENDS_TARGET="toolchain busybox"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="reboot recovery"
PKG_LONGDESC="reboot recovery"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

makeinstall_target() {
  mkdir -p $INSTALL/sbin
  cp -f otaflash $INSTALL/sbin
  cp -f recoveryflash $INSTALL/sbin
  cp -f factoryreset $INSTALL/sbin
  cp -f reboot $INSTALL/sbin
  cp -f update $INSTALL/sbin
  chmod 777 $INSTALL/sbin/update

}
