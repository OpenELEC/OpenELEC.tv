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

PKG_NAME="m4"
PKG_VERSION="1.4.18"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="ftp://ftp.gnu.org/pub/gnu/m4/"
PKG_URL="http://ftp.gnu.org/gnu/m4/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="m4: The m4 macro processor"
PKG_LONGDESC="GNU 'M4' is an implementation of the traditional Unix macro processor. It is mostly SVR4 compatible, although it has some extensions (for example, handling more than 9 positional parameters to macros). 'M4' also has built-in functions for including files, running shell commands, doing arithmetic, etc. Autoconf needs GNU 'M4' for generating 'configure' scripts, but not for running them."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="gl_cv_func_gettimeofday_clobber=no --target=$TARGET_NAME"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install
}
