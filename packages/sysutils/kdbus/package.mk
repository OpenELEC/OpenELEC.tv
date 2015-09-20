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

PKG_NAME="kdbus"
PKG_VERSION="245fe93"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/gregkh/kdbus"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="required"
PKG_SECTION="system"
PKG_SHORTDESC="Linux kernel D-Bus implementation"
PKG_LONGDESC="kdbus is an inter-process communication bus system controlled by the kernel. It provides user-space with an API to create buses and send unicast and multicast messages to one, or many, peers connected to the same bus. It does not enforce any layout on the transmitted data, but only provides the transport layer used for message interchange between peers."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  KERNELVER=$(kernel_version) \
  KERNELDIR=$(get_build_dir linux) \
  make module
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$(get_module_dir)/kernel/ipc/kdbus
    cp $ROOT/$PKG_BUILD/ipc/kdbus/*.ko $INSTALL/lib/modules/$(get_module_dir)/kernel/ipc/kdbus/
}
