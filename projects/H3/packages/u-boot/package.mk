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

PKG_NAME="u-boot"
if [ "$UBOOT_VERSION" = "2016.03-rc2" ]; then
  PKG_VERSION="2016.03-rc2"
  PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
  PKG_URL="ftp://ftp.denx.de/pub/u-boot/$PKG_NAME-$PKG_VERSION.tar.bz2"
fi
PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain sunxi-tools:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  if [ -z "$UBOOT_CONFIG" ]; then
    echo "$TARGET_PLATFORM does not define any u-boot configuration, aborting."
    echo "Please add UBOOT_CONFIG to your project options file."
    exit 1
  fi

  if [ -z "$UBOOT_CONFIGFILE" ]; then
    UBOOT_CONFIGFILE="boot.scr"
  fi

  unset LDFLAGS

# dont build in parallel because of problems
  MAKEFLAGS=-j1
}

make_target() {
    make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" $UBOOT_CONFIG
    make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" HOSTCC="$HOST_CC" HOSTSTRIP="true"
    fex2bin $PROJECT_DIR/$PROJECT/devices/$DEVICE/sys_config/$FEXFILE script.bin
}

makeinstall_target() {
  mkdir -p $ROOT/$TOOLCHAIN/bin

  if [ -f build/tools/mkimage ]; then
    cp build/tools/mkimage $ROOT/$TOOLCHAIN/bin
  elif [ -f tools/mkimage ]; then
    cp tools/mkimage $ROOT/$TOOLCHAIN/bin
  fi

  if [ -n "$DEVICE" -a -r "$PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/boot.cfg" ]; then
    BOOT_CFG="$PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/boot.cfg"
  else
    BOOT_CFG="$PROJECT_DIR/$PROJECT/bootloader/boot.cfg"
  fi
  
  if [ -r "$BOOT_CFG" ]; then
    cp $BOOT_CFG boot.cfg
    mkimage -A "$TARGET_ARCH" \
            -O u-boot \
            -T script \
            -C none \
            -n "$DISTRONAME Boot" \
            -d boot.cfg \
            $UBOOT_CONFIGFILE
  fi

  mkdir -p $INSTALL/usr/share/bootloader

  if [ -f "./u-boot-sunxi-with-spl.bin" ]; then
    cp -PRv ./u-boot-sunxi-with-spl.bin $INSTALL/usr/share/bootloader
  fi

  cp -PRv ./$UBOOT_CONFIGFILE $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp -PR $PROJECT_DIR/$PROJECT/devices/$DEVICE/u-boot/uEnv.txt $INSTALL/usr/share/bootloader 2>/dev/null || :
}
