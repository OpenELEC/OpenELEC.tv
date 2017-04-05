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
PKG_VERSION="b7e092e"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/linux-sunxi/sunxi-tools"
PKG_GIT_URL="https://github.com/linux-sunxi/sunxi-tools.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_HOST=""
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="sunxi-tools: Tools to help hacking Allwinner based devices."
PKG_LONGDESC="sunxi-tools: Tools to help hacking Allwinner based devices."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
  make clean
  make fex2bin
}

make_target() {
  make clean
  make CC="$TARGET_CC" fex2bin
  make CC="$TARGET_CC" bin2fex
}

makeinstall_host() {
  cp -PR fex2bin $ROOT/$TOOLCHAIN/bin/
  cp -PR sunxi-fexc $ROOT/$TOOLCHAIN/bin/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp -PR fex2bin $INSTALL/usr/bin
  cp -PR bin2fex $INSTALL/usr/bin
  cp -PR sunxi-fexc $INSTALL/usr/bin
}
