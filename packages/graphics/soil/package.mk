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

PKG_NAME="soil"
PKG_VERSION="1.16"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="CCPL"
PKG_SITE="http://www.lonesock.net/soil.html"
PKG_URL="http://www.lonesock.net/files/soil.zip"
PKG_SOURCE_DIR="$PKG_NAME"
PKG_DEPENDS_TARGET="toolchain mesa"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="A tiny C lib primarily for loading textures into OpenGL"
PKG_LONGDESC="A tiny C lib primarily for loading textures into OpenGL"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  mv "$PKG_BUILD/Simple OpenGL Image Library"/* $PKG_BUILD/ && rm -r "$PKG_BUILD/Simple OpenGL Image Library"
}

pre_make_target() {
  sed "s/1.07-20071110/$PKG_VERSION/" -i Makefile
  export CFLAGS="$CFLAGS -fPIC"
}

pre_makeinstall_target() {
  export DESTDIR=$SYSROOT_PREFIX
}
