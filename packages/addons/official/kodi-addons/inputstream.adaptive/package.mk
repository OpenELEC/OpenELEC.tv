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

PKG_NAME="inputstream.adaptive"
PKG_VERSION="aa0d511"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/peak3d/inputstream.adaptive"
PKG_GIT_URL="https://github.com/liberty-developer/inputstream.adaptive"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain kodi-platform expat"
PKG_PRIORITY="optional"
PKG_SECTION=""
PKG_SHORTDESC="inputstream.adaptive an adaptive file addon for kodi's new InputStream Interface"
PKG_LONGDESC="inputstream.adaptive: This is an adaptive file addon for kodi's new InputStream Interface."
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="kodi.inputstream"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/share/kodi \
                       -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  cd $ROOT/$PKG_BUILD/wvdecrypter
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/share/kodi \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        .
  make

  mkdir -p $INSTALL/usr/lib/kodi/addons/$PKG_NAME/lib
    cp -P libssd_wv.so $INSTALL/usr/lib/kodi/addons/$PKG_NAME/lib
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
    cp -PR $PKG_BUILD/.install_pkg/usr/share/kodi/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/
    cp -PL $PKG_BUILD/.install_pkg/usr/lib/kodi/addons/$PKG_NAME/*.so $ADDON_BUILD/$PKG_ADDON_ID/

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
    cp -P $PKG_BUILD/wvdecrypter/libssd_wv.so $ADDON_BUILD/$PKG_ADDON_ID/lib
}
