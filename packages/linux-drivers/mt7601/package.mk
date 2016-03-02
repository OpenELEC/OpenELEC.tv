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

PKG_NAME="mt7601"
PKG_VERSION="e35628dc0b4c8d35f668efce9bab6bd603a0a6f3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/porjo/mt7601"
PKG_URL="https://github.com/porjo/mt7601/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Mediatek MT7601 Linux 3.x driver"
PKG_LONGDESC="Mediatek MT7601 Linux 3.x driver"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar xf $ROOT/$SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz -C $ROOT/$BUILD
}

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make -C src V=1 \
       ARCH=$TARGET_KERNEL_ARCH \
       LINUX_SRC=$(kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
    cp src/os/linux/mt7601Usta.ko $INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME
  mkdir -p $INSTALL/etc/Wireless/RT2870STA
    cp src/RT2870STA.dat $INSTALL/etc/Wireless/RT2870STA
}
