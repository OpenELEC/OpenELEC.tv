################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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
#http://openlinux.amlogic.com:8000/download/ARM/wifi/rtk8188eu-2015-12-15-49b30e22a9.tar.gz
PKG_NAME="rtk8188eu"
PKG_VERSION="2015-12-15-49b30e22a9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/wifi/"
PKG_URL="http://openlinux.amlogic.com:8000/download/ARM/wifi/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Realtek RTL81xxEU Linux 3.x driver"
PKG_LONGDESC="Realtek RTL81xxEU Linux 3.x driver"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  cd rtl8xxx_EU
  make V=1 \
       ARCH=$TARGET_KERNEL_ARCH \
       KSRC=$(kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX
  cd ..
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
    cp rtl8xxx_EU/*.ko $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
}
