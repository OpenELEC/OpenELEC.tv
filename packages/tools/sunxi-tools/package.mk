################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="sunxi-tools"
PKG_VERSION="9bf1de0ad822bcd4937356f9621702dfc1a82f1a"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/linux-sunxi/sunxi-tools"
PKG_URL="https://github.com/linux-sunxi/sunxi-tools/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="sunxi-tools: Tools to help hacking Allwinner based devices."
PKG_LONGDESC="sunxi-tools: Tools to help hacking Allwinner based devices."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar xf $ROOT/$SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz -C $ROOT/$BUILD
}

make_host() {
  make fex2bin
}

makeinstall_host() {
  cp -PR fex2bin $ROOT/$TOOLCHAIN/bin/
  cp -PR sunxi-fexc $ROOT/$TOOLCHAIN/bin/
}
	