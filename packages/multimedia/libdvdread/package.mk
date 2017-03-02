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

PKG_NAME="libdvdread"
PKG_VERSION="17d99db"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/xbmc/libdvdread"
PKG_GIT_URL="https://github.com/xbmc/libdvdread.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain libdvdcss"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libdvdread: a library which provides a simple foundation for reading DVDs."
PKG_LONGDESC="libdvdread is a library which provides a simple foundation for reading DVDs."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-libdvdcss --with-pic"

pre_configure_target() {
  export CFLAGS="$CFLAGS -D_XBMC -DHAVE_DVDCSS_DVDCSS_H"
}
