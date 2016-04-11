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

PKG_NAME="visualization.shadertoy"
PKG_VERSION="5b64785"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/notspiff/visualization.shadertoy"
PKG_GIT_URL="https://github.com/notspiff/visualization.shadertoy"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_PRIORITY="optional"
PKG_SECTION=""
PKG_SHORTDESC="visualization.shadertoy"
PKG_LONGDESC="visualization.shadertoy"
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.player.musicviz"

if [ ! "$OPENGL" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL glew"
fi

if [ "$OPENGLES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
fi

configure_target() {
  if [ "$KODIPLAYER_DRIVER" = bcm2835-firmware ]; then
    BCM2835_INCLUDES="-I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/ \
                      -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"
    export CFLAGS="$CFLAGS $BCM2835_INCLUDES"
    export CXXFLAGS="$CXXFLAGS $BCM2835_INCLUDES"
  fi

  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/lib/kodi \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        ..
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -PR $PKG_BUILD/.install_pkg/usr/share/kodi/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/
  cp -PL $PKG_BUILD/.install_pkg/usr/lib/kodi/addons/$PKG_NAME/*.so $ADDON_BUILD/$PKG_ADDON_ID/
}
