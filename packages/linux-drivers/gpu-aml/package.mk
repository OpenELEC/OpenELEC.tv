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

PKG_NAME="gpu-aml"
PKG_VERSION="2016-05-04-2364187a0c"
PKG_REV="1"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/gpu/"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="gpu-aml: Linux drivers for Mali GPUs found in Amlogic Meson SoCs"
PKG_LONGDESC="gpu-aml: Linux drivers for Mali GPUs found in Amlogic Meson SoCs"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  LDFLAGS="" \
  make -C $(get_pkg_build linux) \
       M=$ROOT/$PKG_BUILD/mali \
       CONFIG_MALI400=m \
       CONFIG_MALI450=m
}

makeinstall_target() {
  LDFLAGS="" \
  make -C $(get_pkg_build linux) \
       M=$ROOT/$PKG_BUILD/mali \
       INSTALL_MOD_PATH=$INSTALL \
       INSTALL_MOD_STRIP=1 \
       DEPMOD=: \
       modules_install
}
