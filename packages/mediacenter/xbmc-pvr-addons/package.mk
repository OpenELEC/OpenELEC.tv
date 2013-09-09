################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="xbmc-pvr-addons"
PKG_VERSION="frodo-910d7e7"
if [ "$XBMC" = "master" ]; then
  PKG_VERSION="18597fd"
fi
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/opdenkamp/xbmc-pvr-addons"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS="curl"
PKG_BUILD_DEPENDS_TARGET="toolchain curl"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="Various PVR addons for XBMC" 
PKG_LONGDESC="This addons allows XBMC PVR to connect to various TV/PVR backends and tuners."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

if [ "$MYSQL_SUPPORT" = yes ]; then
  PKG_BUILD_DEPENDS="$PKG_BUILD_DEPENDS mysql"
  PKG_DEPENDS="$PKG_DEPENDS mysql"
  PVRADDONS_MYSQL="--enable-mysql"
else
  PVRADDONS_MYSQL="--disable-mysql"
fi

PKG_CONFIGURE_OPTS_TARGET="--enable-addons-with-dependencies $PVRADDONS_MYSQL"
