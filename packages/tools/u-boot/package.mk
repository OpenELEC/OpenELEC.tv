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
if [ "$UBOOT_VERSION" = "default" ]; then
  PKG_VERSION="2011.03-rc1"
  PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
  PKG_URL="ftp://ftp.denx.de/pub/u-boot/$PKG_NAME-$PKG_VERSION.tar.bz2"
elif [ "$UBOOT_VERSION" = "sunxi" ]; then
  PKG_VERSION="af9f405"
  PKG_SITE="https://github.com/linux-sunxi/u-boot-sunxi"
  PKG_URL="$LAKKA_MIRROR/u-boot-$PKG_VERSION.tar.xz"
elif [ "$UBOOT_VERSION" = "imx6-cuboxi" ]; then
  PKG_VERSION="imx6-e817fa3"
  PKG_SITE="http://imx.solid-run.com/wiki/index.php?title=Building_the_kernel_and_u-boot_for_the_CuBox-i_and_the_HummingBoard"
  PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
elif [ "$UBOOT_VERSION" = "imx6-wandboard" ]; then
  PKG_VERSION="2014.04-rc3"
  PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
  PKG_URL="ftp://ftp.denx.de/pub/u-boot/$PKG_NAME-$PKG_VERSION.tar.bz2"
elif [ "$UBOOT_VERSION" = "odroidc" ]; then
  PKG_VERSION="e7d4447"
  PKG_SITE="http://odroid.com/dokuwiki/doku.php?id=en:c1_building_u-boot"
  PKG_URL="$LAKKA_MIRROR/u-boot-$PKG_VERSION.tar.xz"
elif [ "$UBOOT_VERSION" = "odroidxu3" ]; then
  PKG_VERSION="fe2f831"
  PKG_SITE="http://hardkernel.org"
  PKG_URL="$LAKKA_MIRROR/u-boot-$PKG_VERSION.tar.xz"
else
  exit 0
fi
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain"
if [ "$UBOOT_VERSION" = "sunxi" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET sunxi-tools:host"
elif [ "$UBOOT_VERSION" = "odroidc" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET linaro-arm-toolchain:host"
fi
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  if [ -z "$UBOOT_CONFIG" ]; then
    echo "$TARGET_PLATFORM does not define any u-boot configuration, aborting."
    echo "Please add MACHINE_UBOOT_CONFIG to your platform meta file"
    exit 1
  fi

  if [ -z "$UBOOT_CONFIGFILE" ]; then
    UBOOT_CONFIGFILE="boot.scr"
  fi

  unset LDFLAGS

  if [ "$UBOOT_VERSION" = "odroidc" ]; then
    unset LDFLAGS CFLAGS CPPFLAGS
  fi

# dont use some optimizations because of problems
  MAKEFLAGS=-j1
}

make_target() {
  # get number of targets to build
  UBOOT_TARGET_CNT=0
  for UBOOT_TARGET in $UBOOT_CONFIG; do
    UBOOT_TARGET_CNT=$((UBOOT_TARGET_CNT + 1))
  done

  for UBOOT_TARGET in $UBOOT_CONFIG; do
    if [ "$UBOOT_VERSION" = "odroidc" ]; then
      make CROSS_COMPILE="arm-none-eabi-" mrproper
      make CROSS_COMPILE="arm-none-eabi-" $UBOOT_TARGET
      make CROSS_COMPILE="arm-none-eabi-" HOSTCC="$HOST_CC" HOSTSTRIP="true"
    else
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" mrproper
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" $UBOOT_TARGET
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" HOSTCC="$HOST_CC" HOSTSTRIP="true"
    fi

    # rename files in case of multiple targets
    if [ $UBOOT_TARGET_CNT -gt 1 ]; then
      if [ "$UBOOT_TARGET" = "mx6_cubox-i_config" ]; then
        TARGET_NAME="cuboxi"
      elif [ "$UBOOT_TARGET" = "matrix" ]; then
        TARGET_NAME="matrix"
      elif [ "$UBOOT_TARGET" = "udoo_config" ]; then
        TARGET_NAME="udoo"
      else
        TARGET_NAME="undef"
      fi

      [ -f u-boot.img ] && mv u-boot.img u-boot-$TARGET_NAME.img || :
      [ -f u-boot.imx ] && mv u-boot.imx u-boot-$TARGET_NAME.imx || :
      [ -f SPL ] && mv SPL SPL-$TARGET_NAME || :
    fi
  done
}

makeinstall_target() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
    if [ -f build/tools/mkimage ]; then
      cp build/tools/mkimage $ROOT/$TOOLCHAIN/bin
    else
      cp tools/mkimage $ROOT/$TOOLCHAIN/bin
    fi

  BOOT_CFG="$PROJECT_DIR/$PROJECT/bootloader/boot.cfg"
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

  cp ./u-boot*.imx $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp ./u-boot*.img $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp ./u-boot*.bin $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp ./SPL* $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp ./$UBOOT_CONFIGFILE $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp -PRv $PKG_DIR/scripts/update.sh $INSTALL/usr/share/bootloader

  cp -PR $PROJECT_DIR/$PROJECT/bootloader/uEnv*.txt $INSTALL/usr/share/bootloader 2>/dev/null || :

  if [ "$UBOOT_VERSION" = "sunxi" ]; then
    #cp -RP $PROJECT_DIR/$PROJECT/bootloader/*.bin $INSTALL/usr/share/bootloader
    cp -RP $PROJECT_DIR/$PROJECT/bootloader/uEnv.* $INSTALL/usr/share/bootloader
  fi

  if [ -f "$PROJECT_DIR/$PROJECT/bootloader/boot.ini" ]; then
    cp -PR  $PROJECT_DIR/$PROJECT/bootloader/boot.ini $INSTALL/usr/share/bootloader
  fi
}
