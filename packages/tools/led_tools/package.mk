################################################################################
#      Slice LED driver
#      Copyright (C) 2014 Gordon Hollingworth (gordon@fiveninjas.com)
#
#  This is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  It is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Slice.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="led_tools"
PKG_VERSION="0.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.fiveninjas.com"
PKG_URL="http://updates.fiveninjas.com/src/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libpng"
PKG_DEPENDS_HOST="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="led_tools"
PKG_LONGDESC="LED tools, these are a set of tools to control the LEDs on Slice"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" \
       CFLAGS="$CFLAGS" \
       LDFLAGS="$LDFLAGS"
}

makeinstall_target() {

  mkdir -p $INSTALL/usr/bin
  cp led_png $INSTALL/usr/bin

}
