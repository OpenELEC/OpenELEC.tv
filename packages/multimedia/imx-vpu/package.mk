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

PKG_NAME="imx-vpu"
PKG_VERSION="5.4.33"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_SITE="http://www.freescale.com"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain firmware-imx"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="imx-vpu: platform specific unit tests for mxc platform"
PKG_LONGDESC="imx-vpu: platform specific unit tests for mxc platform"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make DIRS="vpu" CFLAGS="$CFLAGS" PLATFORM=IMX6Q
}

makeinstall_target() {
  make DIRS="vpu" PLATFORM=IMX6Q DEST_DIR=$SYSROOT_PREFIX install
  make DIRS="vpu" PLATFORM=IMX6Q DEST_DIR=$INSTALL install
}
