################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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
PKG_VERSION="4.8.19"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.midnight-commander.org"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host glib pcre netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="mc: visual file manager"
PKG_LONGDESC="GNU Midnight Commander is a visual file manager, licensed under GNU General Public License and therefore qualifies as Free Software. It's a feature rich full-screen text mode application that allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.1"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_search_addwstr=yes \
            --sysconfdir=/storage/.kodi/addons/tools.mc/etc \
            --datadir=/storage/.kodi/addons/tools.mc/data \
            --libdir=/storage/.kodi/addons/tools.mc/mclib \
            --disable-mclib \
            --disable-aspell \
            --disable-vfs \
            --disable-doxygen-doc \
            --disable-doxygen-dot \
            --disable-doxygen-html \
            --with-sysroot=$SYSROOT_PREFIX \
            --with-screen=ncurses \
            --without-x \
            --with-gnu-ld \
            --without-libiconv-prefix \
            --without-libintl-prefix \
            --with-internal-edit \
            --without-diff-viewer \
            --with-subshell"

pre_configure_target() {
  export LDFLAGS=$(echo $LDFLAGS | sed -e "s|-Wl,--as-needed||")
  export LIBS="-lcurses -lterminfo"
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage/.kodi/addons/tools.mc/data/locale
  rm -rf $INSTALL/storage/.kodi/addons/tools.mc/data/mc/help/mc.hlp.*
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -Pa $PKG_BUILD/.install_pkg/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -Pa $PKG_BUILD/.install_pkg/storage/.kodi/addons/tools.mc/* $ADDON_BUILD/$PKG_ADDON_ID
}
