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

PKG_NAME="afpfs-ng"
PKG_VERSION="0.8.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://sourceforge.net/projects/afpfs-ng/"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error libgcrypt ncurses"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="afpfs-ng: an Apple Filing Protocol client"
PKG_LONGDESC="afpfs-ng is an Apple Filing Protocol client that will allow BSD, Linux and Mac OS X systems to access files exported from a Mac OS system with AFP over TCP."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           --enable-gcrypt \
                           --disable-fuse"

PKG_MAKE_OPTS_TARGET="-C lib"

makeinstall_target() {
  $MAKEINSTALL -C lib
  $MAKEINSTALL -C include
  make -C lib DESTDIR=$INSTALL install
}
