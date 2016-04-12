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

PKG_NAME="configtools"
PKG_VERSION="706fbe5"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://git.savannah.gnu.org/cgit/config.git"
PKG_GIT_URL="http://git.savannah.gnu.org/r/config.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_HOST=""
PKG_SHORTDESC="configtools"
PKG_LONGDESC="configtools"

make_host() {
  :
}

makeinstall_host() {
  mkdir -p $ROOT/$TOOLCHAIN/configtools
  cp config.* $ROOT/$TOOLCHAIN/configtools
}
