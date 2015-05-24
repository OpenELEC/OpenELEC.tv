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

PKG_NAME="util-linux"
PKG_VERSION="2.26.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="http://www.kernel.org/pub/linux/utils/util-linux/v2.26/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_INIT="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="util-linux: Miscellaneous system utilities for Linux"
PKG_LONGDESC="The util-linux package contains a large variety of low-level system utilities that are necessary for a Linux system to function. Among many features, Util-linux contains the fdisk configuration tool and the login program."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-gtk-doc \
                           --disable-nls \
                           --disable-rpath \
                           --enable-tls \
                           --enable-libuuid \
                           --enable-libblkid \
                           --enable-libmount \
                           --enable-libsmartcols \
                           --disable-mount \
                           --enable-losetup \
                           --enable-fsck \
                           --disable-partx \
                           --enable-uuidd \
                           --disable-mountpoint \
                           --disable-fallocate \
                           --disable-unshare \
                           --disable-nsenter \
                           --disable-setpriv \
                           --disable-eject \
                           --disable-cramfs \
                           --disable-bfs \
                           --disable-minix \
                           --disable-fdformat \
                           --disable-hwclock \
                           --disable-wdctl \
                           --disable-switch-root \
                           --disable-pivot-root \
                           --enable-tunelp \
                           --disable-kill \
                           --enable-deprecated-last \
                           --disable-last \
                           --disable-utmpdump \
                           --disable-line \
                           --disable-mesg \
                           --disable-raw \
                           --disable-rename \
                           --disable-reset \
                           --disable-vipw \
                           --disable-newgrp \
                           --disable-chfn-chsh \
                           --enable-chsh-only-listed \
                           --disable-login \
                           --disable-login-chown-vcs \
                           --disable-login-stat-mail \
                           --disable-nologin \
                           --disable-sulogin \
                           --disable-su \
                           --disable-runuser \
                           --disable-ul \
                           --disable-more \
                           --disable-pg \
                           --disable-setterm \
                           --disable-schedutils \
                           --disable-wall \
                           --disable-write \
                           --disable-bash-completion \
                           --disable-pylibmount \
                           --disable-pg-bell \
                           --disable-use-tty-group \
                           --disable-makeinstall-chown \
                           --disable-makeinstall-setuid \
                           --with-gnu-ld \
                           --without-selinux \
                           --without-audit \
                           --without-udev \
                           --without-ncurses \
                           --without-slang \
                           --without-utempter \
                           --without-python \
                           --without-systemdsystemunitdir"
if [ "$SERIAL_CONSOLE" != yes ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-agetty"
fi

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET \
                         --enable-static \
                         --disable-shared"

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET \
                         --prefix=/ \
                         --bindir=/bin \
                         --sbindir=/sbin \
                         --sysconfdir=/etc \
                         --libexecdir=/lib \
                         --localstatedir=/var \
                         --enable-static --disable-shared"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin
  rm -rf $INSTALL/usr/share

  mkdir -p $INSTALL/usr/sbin
    cp .libs/blkid $INSTALL/usr/sbin
    cp .libs/fsck $INSTALL/usr/sbin
    cp .libs/losetup $INSTALL/usr/sbin

  if [ "$SWAP_SUPPORT" = "yes" ]; then
    cp .libs/swapon $INSTALL/usr/sbin
    cp .libs/swapoff $INSTALL/usr/sbin

    mkdir -p $INSTALL/usr/lib/openelec
      cp -PR $PKG_DIR/scripts/mount-swap $INSTALL/usr/lib/openelec

    mkdir -p $INSTALL/etc
      cat $PKG_DIR/config/swap.conf | \
        sed -e "s,@SWAPFILESIZE@,$SWAPFILESIZE,g" \
            -e "s,@SWAP_ENABLED_DEFAULT@,$SWAP_ENABLED_DEFAULT,g" \
            > $INSTALL/etc/swap.conf
  fi

  if [ "$SERIAL_CONSOLE" = yes ]; then
    mkdir -p $INSTALL/sbin
      cp agetty $INSTALL/sbin
  fi
}

post_makeinstall_init() {
  rm -rf $INSTALL/bin
  rm -rf $INSTALL/sbin

  if [ $INITRAMFS_PARTED_SUPPORT = "yes" ]; then
    # install libuuid and libblkid here, needed by 'parted'
    rm -rf $INSTALL/lib/libmount.so*

    mkdir -p $INSTALL/sbin
      cp mkfs $INSTALL/sbin
  else
    rm -rf $INSTALL/lib
  fi

  mkdir -p $INSTALL/sbin
    cp fsck $INSTALL/sbin
}

post_install () {
  if [ "$SWAP_SUPPORT" = "yes" ]; then
    enable_service swap.service
  fi
}
