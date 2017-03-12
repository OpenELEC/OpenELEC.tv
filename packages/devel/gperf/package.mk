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

# libcap,systemd,eudev depends on gperf and must be patched for gperf >= 3.1

PKG_NAME="gperf"
PKG_VERSION="3.0.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/gperf/"
PKG_URL="https://ftp.gnu.org/pub/gnu/gperf/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="gperf: a perfect hash function generator"
PKG_LONGDESC="GNU gperf is a perfect hash function generator. For a given list of strings, it produces a hash function and hash table, in form of C or C++ code, for looking up a value depending on the input string. The hash function is perfect, which means that the hash table has no collisions, and the hash table lookup needs a single string comparison only."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
