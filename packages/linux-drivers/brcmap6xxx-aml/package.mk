################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 OpenELEC.tv
#      Copyright (C) 2014-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2016 Alex Deryskyba (alex@codesnake.com)
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

PKG_NAME="brcmap6xxx-aml"
PKG_REV="1"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/wifi/"
PKG_VERSION="2016-08-18-88f3d466c6"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux wlan-firmware"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="brcmap6xxx-aml: Linux drivers for AP6xxx WLAN chips used in some devices based on Amlogic SoCs"
PKG_LONGDESC="brcmap6xxx-aml: Linux drivers for AP6xxx WLAN chips used in some devices based on Amlogic SoCs"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  LDFLAGS="" \
  make V=1 -C $(get_pkg_build linux) \
       M=$ROOT/$PKG_BUILD/bcmdhd_1_201_59_x
}

makeinstall_target() {
  LDFLAGS="" \
  make V=1 -C $(get_pkg_build linux) \
       M=$ROOT/$PKG_BUILD/bcmdhd_1_201_59_x \
       INSTALL_MOD_PATH=$INSTALL/usr \
       INSTALL_MOD_STRIP=1 \
       DEPMOD=: \
       modules_install

  mkdir -p $INSTALL/usr/lib/firmware/brcm
    cp $PKG_DIR/config/config.txt $INSTALL/usr/lib/firmware/brcm
}
