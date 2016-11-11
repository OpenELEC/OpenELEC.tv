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

PKG_NAME="linux"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain cpio:host kmod:host pciutils xz:host wireless-regdb keyutils irqbalance"
PKG_DEPENDS_INIT="toolchain cpu-firmware:init"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="linux"
PKG_SHORTDESC="linux26: The Linux kernel 2.6 precompiled kernel binary image and modules"
PKG_LONGDESC="This package contains a precompiled kernel image and the modules."
case "$LINUX" in
  amlogic-3.10)
    PKG_VERSION="8b1bb2b"
    PKG_GIT_URL="https://github.com/codesnake/linux.git"
    PKG_GIT_BRANCH="amlogic-3.10.y"
    PKG_PATCH_DIRS="linux-3.10 amlogic-3.10"
    KERNEL_EXTRA_CONFIG+=" kernel-3.x"
    ;;
  amlogic-3.14)
    PKG_VERSION="069e204"
#    PKG_GIT_URL="https://github.com/codesnake/linux-amlogic.git"
    PKG_GIT_URL="https://github.com/LibreELEC/linux-amlogic.git"
    PKG_GIT_BRANCH="amlogic-3.14.y"
    PKG_PATCH_DIRS="linux-3.14 amlogic-3.14"
    KERNEL_EXTRA_CONFIG+=" kernel-3.x"
    ;;
  imx6)
    PKG_VERSION="f14907b"
    PKG_GIT_URL="https://github.com/xbianonpi/xbian-sources-kernel.git"
    PKG_GIT_BRANCH="imx6-4.4.y"
    PKG_DEPENDS_TARGET+=" imx6-status-led imx6-soc-fan"
    PKG_PATCH_DIRS="linux-4.4 imx6-4.4"
    ;;
  rpi)
    PKG_VERSION="74fdf71"
    PKG_GIT_URL="https://github.com/OpenELEC/linux.git"
    PKG_GIT_BRANCH="raspberry-rpi-4.9.y"
    PKG_PATCH_DIRS="linux-4.9"
    ;;
  linux-4.8)
    PKG_VERSION="4.8.6"
    PKG_URL="http://www.kernel.org/pub/linux/kernel/v4.x/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_PATCH_DIRS="linux-4.8"
    ;;
  *)
    PKG_VERSION="4.9-rc4"
    PKG_URL="http://www.kernel.org/pub/linux/kernel/v4.x/testing/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_PATCH_DIRS="linux-4.9"
    ;;
esac

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_HOST="headers_check"

[ "$BUILD_ANDROID_BOOTIMG" = "yes" ] && PKG_DEPENDS_TARGET+=" mkbootimg:host"
[ "$SWAP_SUPPORT" = yes ]            && KERNEL_EXTRA_CONFIG+=" swap"
[ "$NFS_SUPPORT" = yes ]             && KERNEL_EXTRA_CONFIG+=" nfs"
[ "$SAMBA_SUPPORT" = yes ]           && KERNEL_EXTRA_CONFIG+=" samba"
[ "$ISCSI_SUPPORT" = yes ]           && KERNEL_EXTRA_CONFIG+=" iscsi"
[ "$BLUETOOTH_SUPPORT" = yes ]       && KERNEL_EXTRA_CONFIG+=" bluetooth"
[ "$UVESAFB_SUPPORT" = yes ]         && KERNEL_EXTRA_CONFIG+=" uvesafb"

post_patch() {
  if [ -f $PROJECT_DIR/$PROJECT/$PKG_NAME/$PKG_NAME.$TARGET_ARCH.conf ]; then
    KERNEL_CFG_FILE=$PROJECT_DIR/$PROJECT/$PKG_NAME/$PKG_NAME.$TARGET_ARCH.conf
  else
    KERNEL_CFG_FILE=$PKG_DIR/config/$PKG_NAME.$TARGET_ARCH.conf
  fi

  cp $KERNEL_CFG_FILE $PKG_BUILD/.config

  sed -i -e "s|^ARCH[[:space:]]*?=.*$|ARCH = $TARGET_KERNEL_ARCH|" \
         -e "s|^CROSS_COMPILE[[:space:]]*?=.*$|CROSS_COMPILE = ${TARGET_NAME}-|" \
         $PKG_BUILD/Makefile

  if [ ! "$BUILD_ANDROID_BOOTIMG" = "yes" ]; then
    sed -i -e "s|^CONFIG_INITRAMFS_SOURCE=.*$|CONFIG_INITRAMFS_SOURCE=\"$ROOT/$BUILD/image/initramfs.cpio\"|" $PKG_BUILD/.config
  fi

  # set default hostname based on $DISTRONAME
    sed -i -e "s|@DISTRONAME@|$DISTRONAME|g" $PKG_BUILD/.config

  # copy some extra firmware to linux tree
    cp -R $PKG_DIR/firmware/* $PKG_BUILD/firmware

  # ask for new config options after kernel update
    make -C $PKG_BUILD oldconfig

  # set default config
    for config in $(find $PKG_DIR/config -type f -name default-*.config 2>&1); do
      if [ -f $config ]; then
        echo ">>> include $config ..."
        cat $config >> $PKG_BUILD/.config
      fi
    done
    for config in $(find $PROJECT_DIR/$PROJECT/$PKG_NAME -type f -name default-*.config 2>&1); do
      if [ -f $config ]; then
        echo ">>> include $config ..."
        cat $config >> $PKG_BUILD/.config
      fi
    done
    for config in $(find $DISTRO_DIR/$DISTRO/$PKG_NAME -type f -name default-*.config 2>&1); do
      if [ -f $config ]; then
        echo ">>> include $config ..."
        cat $config >> $PKG_BUILD/.config
      fi
    done

  # set extra config
    for config in $KERNEL_EXTRA_CONFIG; do
      if [ -f $PKG_DIR/config/extra-${config}.config ]; then
        echo ">>> include $PKG_DIR/config/extra-${config}.config ..."
        cat $PKG_DIR/config/extra-${config}.config >> $PKG_BUILD/.config
      fi
      if [ -f $PROJECT_DIR/$PROJECT/$PKG_NAME/extra-${config}.config ]; then
        echo ">>> include $PROJECT_DIR/$PROJECT/$PKG_NAME/extra-${config}.config ..."
        cat $PROJECT_DIR/$PROJECT/$PKG_NAME/extra-${config}.config >> $PKG_BUILD/.config
      fi
      if [ -f $DISTRO_DIR/$DISTRO/$PKG_NAME/extra-${config}.config ]; then
        echo ">>> include $DISTRO_DIR/$DISTRO/$PKG_NAME/extra-${config}.config ..."
        cat $DISTRO_DIR/$DISTRO/$PKG_NAME/extra-${config}.config >> $PKG_BUILD/.config
      fi
    done

    make -C $PKG_BUILD olddefconfig
}

makeinstall_host() {
  make INSTALL_HDR_PATH=dest headers_install
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -R dest/include/* $SYSROOT_PREFIX/usr/include
}

pre_make_target() {
  # regdb
  cp $(get_pkg_build wireless-regdb)/db.txt $ROOT/$PKG_BUILD/net/wireless/db.txt

  if [ "$BOOTLOADER" = "u-boot" ]; then
    ( cd $ROOT
      $SCRIPTS/build u-boot
    )
  fi
}

make_target() {
  unset LDFLAGS

  make modules
  make INSTALL_MOD_PATH=$INSTALL DEPMOD="$ROOT/$TOOLCHAIN/bin/depmod" INSTALL_MOD_STRIP=1 modules_install
  rm -f $INSTALL/lib/modules/*/build
  rm -f $INSTALL/lib/modules/*/source

  ( cd $ROOT
    rm -rf $ROOT/$BUILD/initramfs
    $SCRIPTS/install initramfs
  )

  if [ "$BOOTLOADER" = "u-boot" ]; then
    if [ -n "$KERNEL_UBOOT_EXTRA_TARGET" -o -n "$KERNEL_UBOOT_DT_IMAGE" ]; then
      for extra_target in "$KERNEL_UBOOT_EXTRA_TARGET" $(basename "$KERNEL_UBOOT_DT_IMAGE") ; do
        make $extra_target
      done
    fi
  fi

  make $KERNEL_TARGET $KERNEL_MAKE_EXTRACMD

  if [ "$BUILD_ANDROID_BOOTIMG" = "yes" ]; then
    mkbootimg --kernel arch/$TARGET_KERNEL_ARCH/boot/$KERNEL_TARGET --ramdisk $ROOT/$BUILD/image/initramfs.cpio \
      $ANDROID_BOOTIMG_OPTIONS --output arch/$TARGET_KERNEL_ARCH/boot/boot.img
    mv -f arch/$TARGET_KERNEL_ARCH/boot/boot.img arch/$TARGET_KERNEL_ARCH/boot/$KERNEL_TARGET
  fi
}

makeinstall_target() {
  if [ "$BOOTLOADER" = "u-boot" -o "$BOOTLOADER" = "bcm2835-firmware" ]; then
    mkdir -p $INSTALL/usr/share/bootloader
    for dtb in arch/$TARGET_KERNEL_ARCH/boot/dts/*.dtb; do
      [ -f $dtb ] && cp -p $dtb $INSTALL/usr/share/bootloader
    done

    if [ "$BOOTLOADER" = "u-boot" ]; then
      if [ -f arch/$TARGET_KERNEL_ARCH/boot/dts/$KERNEL_UBOOT_DT_IMAGE ]; then
        cp -p arch/$TARGET_KERNEL_ARCH/boot/dts/$KERNEL_UBOOT_DT_IMAGE $INSTALL/usr/share/bootloader/dtb.img
      fi
    elif [ "$BOOTLOADER" = "bcm2835-firmware" ]; then
      mkdir -p $INSTALL/usr/share/bootloader/overlays
      for dtbo in arch/$TARGET_KERNEL_ARCH/boot/dts/overlays/*.dtbo; do
        [ -f $dtbo ] && cp -p $dtbo $INSTALL/usr/share/bootloader/overlays
      done
      cp -p arch/$TARGET_KERNEL_ARCH/boot/dts/overlays/README $INSTALL/usr/share/bootloader/overlays
    fi
  fi
}

make_init() {
 : # reuse make_target()
}

makeinstall_init() {
  if [ -n "$INITRAMFS_MODULES" ]; then
    mkdir -p $INSTALL/etc
    mkdir -p $INSTALL/lib/modules

    for i in $INITRAMFS_MODULES; do
      module=`find .install_pkg/lib/modules/$(get_module_dir)/kernel -name $i.ko`
      if [ -n "$module" ]; then
        echo $i >> $INSTALL/etc/modules
        cp $module $INSTALL/lib/modules/$(basename $module)
      fi
    done
  fi

  if [ "$UVESAFB_SUPPORT" = yes ]; then
    mkdir -p $INSTALL/lib/modules
      uvesafb=`find .install_pkg/lib/modules/$(get_module_dir)/kernel -name uvesafb.ko`
      cp $uvesafb $INSTALL/lib/modules/$(basename $uvesafb)
  fi

  echo "mkdir -p dev" >> $FAKEROOT_SCRIPT_INIT
  echo "mknod -m 600 dev/console c 5 1" >> $FAKEROOT_SCRIPT_INIT
}

post_install() {
  mkdir -p $INSTALL/lib/firmware/
    ln -sf /storage/.config/firmware/ $INSTALL/lib/firmware/updates

  # bluez looks in /etc/firmware/
    ln -sf /lib/firmware/ $INSTALL/etc/firmware
}
