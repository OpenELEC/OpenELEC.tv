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

PKG_NAME="crazycat"
PKG_VERSION="91b04ea"
PKG_REV="1"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://bitbucket.org/CrazyCat/linux-tbs-drivers/"
PKG_URL="http://mycvh.de/openelec/crazycat-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Linux TBS tuner drivers + additions from CrazyCat"
PKG_LONGDESC="Linux TBS tuner drivers + additions from CrazyCat"
PKG_AUTORECONF="no"

make_target() {
  cd $ROOT/$PKG_BUILD
  [ "$TARGET_ARCH" = "i386" ] && ./v4l/tbs-x86_r3.sh
  [ "$TARGET_ARCH" = "x86_64" ] && ./v4l/tbs-x86_64.sh
  LDFLAGS="" make DIR=$(kernel_path) prepare
  LDFLAGS="" make DIR=$(kernel_path)
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$(get_module_dir)/updates/tbs
  find $ROOT/$PKG_BUILD/ -name \*.ko -exec cp {} $INSTALL/lib/modules/$(get_module_dir)/updates/tbs \;
}
