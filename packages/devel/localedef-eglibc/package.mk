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

PKG_NAME="localedef-eglibc"
PKG_VERSION="2.14.1-r17443-ptx1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://public.pengutronix.de"
PKG_URL="http://public.pengutronix.de/mirror/software/ptxdist/temporary-src/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="localedef: Locale definition compiler"
PKG_LONGDESC="The localedef program reads the indicated charmap and input files, compiles them to a form usable by the locale(7) functions in the C library, and places the six output files in the outputpath directory."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--prefix=/usr --with-glibc=../eglibc"

CFLAGS+=" -fgnu89-inline"

makeinstall_host() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
    cp localedef $ROOT/$TOOLCHAIN/bin
}
