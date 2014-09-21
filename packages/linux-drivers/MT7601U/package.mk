################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2014 Christian Hewitt (chewitt@openelec.tv)
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

PKG_NAME="MT7601U"
PKG_VERSION="7a438c9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
# mediatek: PKG_SITE="http://www.mediatek.com/en/downloads/mt7601u-usb/"
PKG_SITE="https://github.com/porjo/mt7601"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Mediatek MT7601U Linux 3.x driver"
PKG_LONGDESC="Mediatek MT7601U Linux 3.x driver"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {

  cd src

  sed -i '200s|.*LINUX_SRC.*|LINUX_SRC = '$(kernel_path)'|' Makefile
  sed -i '203s|.*LINUX_SRC_MODULE.*|LINUX_SRC_MODULE = '$INSTALL'/lib/modules/'$(get_module_dir)'/kernel/drivers/net/wireless/|' Makefile
  local CROSS_COMPILE=$(echo $TARGET_PREFIX | sed 's|.*/||')
  sed -i '204s|CROSS_COMPILE =|CROSS_COMPILE = '$CROSS_COMPILE'\
ARCH = '$TARGET_ARCH'\
export ARCH\
export CROSS_COMPILE|' Makefile

  make osdrv

}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
    cp os/linux/mt7601Usta.ko $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME

  mkdir -p $INSTALL/lib/firmware/MT7601USTA
    cp RT2870STA.dat $INSTALL/lib/firmware/MT7601USTA/MT7601USTA.dat
}
