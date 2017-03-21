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

PKG_NAME="simplejson"
PKG_VERSION="3.10.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://pypi.python.org/pypi/simplejson"
PKG_URL="https://pypi.python.org/packages/40/ad/52c1f3a562df3b210e8f165e1aa243a178c454ead65476a39fa3ce1847b6/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/system"
PKG_SHORTDESC="simplejson: a simple, fast, complete, correct and extensible JSON <http://json.org> encoder and decoder for Python 2.5+."
PKG_LONGDESC="simplejson is a simple, fast, complete, correct and extensible JSON <http://json.org> encoder and decoder for Python 2.5+. It is pure Python code with no dependencies, but includes an optional C extension for a serious speed boost."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  strip_lto
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
