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

PKG_NAME="opengles-mali"
PKG_VERSION="2.0+C1_fb"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/filesystem/"
PKG_URL="http://sources.openelec.tv/devel/opengl-meson6-r4p0-01-armhf.tar.xz"
PKG_DEPENDS_TARGET="toolchain libamcodec"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="OpenGL ES pre-compiled libraries for Mali 400 GPUs found in Amlogic Meson6 SoCs"
PKG_LONGDESC="OpenGL ES pre-compiled libraries for Mali 400 GPUs found in Amlogic Meson6 SoCs. The libraries could be found in a Linux buildroot released by Amlogic at http://openlinux.amlogic.com:8000/download/ARM/filesystem/. See the opengl package."
PKG_SOURCE_DIR="$(basename ${PKG_URL/.tar.xz})"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  $SCRIPTS/extract $PKG_NAME $(basename $PKG_URL) $BUILD
}

make_target() {
 : nothing
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR usr/lib/*.so* $SYSROOT_PREFIX/usr/lib
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PR usr/include/* $SYSROOT_PREFIX/usr/include
  mkdir -p $INSTALL/usr/lib
    cp -PR usr/lib/*.so* $INSTALL/usr/lib
}

post_install() {
  enable_service unbind-console.service
}
