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

PKG_NAME="sunxi-uboot-patch"
PKG_VERSION="1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://moinejf.free.fr/opi2/"
PKG_URL="http://moinejf.free.fr/opi2/make_uboot.tar.gz"
PKG_DEPENDS_HOST=""
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Adds script.bin to U-Boot for Allwinner versions"
PKG_LONGDESC="Adds script.bin to U-Boot for Allwinner versions"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar xf $ROOT/$SOURCES/$PKG_NAME/make_uboot.tar.gz -C $ROOT/$BUILD
  mv $ROOT/$BUILD/make_uboot $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION
}

make_host() {
  make update_uboot
}

makeinstall_host() {
  cp -PR update_uboot $ROOT/$TOOLCHAIN/bin/
}
