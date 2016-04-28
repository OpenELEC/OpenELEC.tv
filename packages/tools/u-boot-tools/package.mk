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

PKG_NAME="u-boot-tools"
PKG_VERSION="108f841"
PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
PKG_GIT_URL="git://git.denx.de/u-boot.git"
PKG_GIT_BRANCH="master"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  for UBOOT_TARGET in $UBOOT_CONFIG; do
    make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" $UBOOT_TARGET
    break
  done
  make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" cross_tools
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp -PR tools/mkimage $INSTALL/usr/bin
}
