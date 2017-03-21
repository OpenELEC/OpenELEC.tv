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

PKG_NAME="libpng"
PKG_VERSION="1.6.28"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.libpng.org/"
PKG_URL="$SOURCEFORGE_SRC/libpng/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="libpng: Portable Network Graphics (PNG) Reference Library"
PKG_LONGDESC="PNG (Portable Network Graphics) is an extensible file format for the lossless, portable, well-compressed storage of raster images. PNG provides a patent-free replacement for GIF and can also replace many common uses of TIFF. Indexed-color, grayscale, and truecolor images are supported, plus an optional alpha channel. Sample depths range from 1 to 16 bits."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_HOST="-DPNG_SHARED=OFF -DPNG_STATIC=ON -DPNG_TESTS=OFF -DCMAKE_SYSTEM_PROCESSOR=$(uname -m)"
PKG_CMAKE_OPTS_TARGET="-DPNG_SHARED=OFF -DPNG_STATIC=ON -DPNG_TESTS=OFF -DCMAKE_SYSTEM_PROCESSOR=$TARGET_ARCH"

post_makeinstall_target() {
  sed -e "s:\([\"'= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" \
      -e "s:libs=\"-lpng16\":libs=\"-lpng16 -lz\":g" \
      -i $SYSROOT_PREFIX/usr/bin/libpng*-config

  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib
}
