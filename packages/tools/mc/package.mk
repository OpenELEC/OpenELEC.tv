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

PKG_NAME="mc"
PKG_VERSION="4.8.11"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.midnight-commander.org/"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host glib pcre slang"
PKG_PRIORITY="optional"
PKG_SECTION="shell/filemanager"
PKG_SHORTDESC="mc: free cross-platform filemanager #fu_cv_sys_stat_statfs2_bsize=yes"
PKG_LONGDESC="Midnight Commander - free cross-platform filemanager and clone of Norton Commander"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

configure_target() {
export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/slang"
export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`

./configure --host=$TARGET_NAME \
 --build=$HOST_NAME \
 --prefix=/usr \
 --exec-prefix=/usr \
 --without-gpm-mouse \
 --disable-vfs-cpio \
 --disable-vfs-fish \
 --disable-vfs-sfs \
 --enable-vfs-extfs \
 --without-mmap \
 --with-subshell \
 --with-internal-edit \
 --without-x \
 --enable-charset \
 --enable-background \
 --with-screen=slang \
 fu_cv_sys_stat_statfs2_bsize=yes

}

post_install() {
  mkdir -p $INSTALL/usr/share/mc/bin
  ln -s /usr/libexec/mc/mc-wrapper.csh $INSTALL/usr/share/mc/bin/mc-wrapper.csh
  ln -s /usr/libexec/mc/mc-wrapper.sh $INSTALL/usr/share/mc/bin/mc-wrapper.sh
  ln -s /usr/libexec/mc/mc.csh $INSTALL/usr/share/mc/bin/mc.csh
  ln -s /usr/libexec/mc/mc.sh $INSTALL/usr/share/mc/bin/mc.sh
  mkdir -p $INSTALL/usr/share/locale
  for fgmo in `ls $ROOT/$PKG_BUILD/.$TARGET_NAME/po/*.gmo`;do
    fname=`basename $fgmo .gmo`
    mkdir -p $INSTALL/usr/share/locale/$fname
    mkdir -p $INSTALL/usr/share/locale/$fname/LC_MESSAGES
    cp -p $fgmo $INSTALL/usr/share/locale/$fname/LC_MESSAGES/mc.mo    
  done
  mkdir -p $INSTALL/usr/share/mc
    cp -P $PKG_DIR/config/mc.lib $INSTALL/usr/share/mc
}