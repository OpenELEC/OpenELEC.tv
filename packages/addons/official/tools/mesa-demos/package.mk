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

PKG_NAME="mesa-demos"
PKG_VERSION="8.3.0"
PKG_REV="0"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="OSS"
PKG_SITE="http://www.mesa3d.org/"
PKG_URL="ftp://ftp.freedesktop.org/pub/mesa/demos/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 mesa glu glew"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="mesa-demos: Mesa 3D demos"
PKG_LONGDESC="Mesa 3D demos - installed are the well known glxinfo and glxgears."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.1"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--without-glut"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/.$TARGET_NAME/src/xdemos/glxdemo $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -P $PKG_BUILD/.$TARGET_NAME/src/xdemos/glxgears $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -P $PKG_BUILD/.$TARGET_NAME/src/xdemos/glxinfo $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
