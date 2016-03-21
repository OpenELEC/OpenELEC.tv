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

PKG_NAME="libump"
PKG_VERSION="ec0680628744f30b8fac35e41a7bd8e23e59c39f"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/linux-sunxi/libump"
PKG_URL="https://github.com/linux-sunxi/libump/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="libump: ARMs Universal Memory Provider userspace library."
PKG_LONGDESC="ARMs Universal Memory Provider userspace library. This library is a requirement for ARMs binary Mali driver."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

unpack() {
  tar xf $ROOT/$SOURCES/libump/$PKG_VERSION.tar.gz -C $ROOT/$BUILD
}
