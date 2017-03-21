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

PKG_NAME="appdirs"
PKG_VERSION="1.4.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/appdirs"
PKG_URL="https://pypi.python.org/packages/88/99/293dac0b3cdf58ce029ec5393624fac5c6bde52f737f9775bd9ef608ec98/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="appdirs: Python module for determining appropriate platform-specific dirs"
PKG_LONGDESC="appdirs is a small Python module for determining appropriate platform-specific dirs, e.g. a user data dir."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
  : # nothing todo
}

makeinstall_host() {
  python setup.py install --prefix=$ROOT/$TOOLCHAIN
}
