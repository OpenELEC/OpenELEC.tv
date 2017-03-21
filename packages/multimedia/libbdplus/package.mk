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

PKG_NAME="libbdplus"
PKG_VERSION="a908260"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.videolan.org/developers/libbdplus.html"
PKG_GIT_URL="https://git.videolan.org/git/libbdplus.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain libgcrypt libgpg-error"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libbdplus: A project to implement the BD+ System Specifications"
PKG_LONGDESC="libbdplus is a research project to implement the BD+ System Specifications."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-werror \
                           --disable-extra-warnings \
                           --disable-optimizations \
                           --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr \
                           --with-gpg-error-prefix=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld"

if [ "$BLURAY_AACS_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libaacs"
  PKG_CONFIGURE_OPTS_TARGET+=" --with-libaacs"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --without-libaacs"
fi
