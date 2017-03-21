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

PKG_NAME="fuse-exfat"
PKG_VERSION="1.2.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/relan/exfat"
PKG_URL="https://github.com/relan/exfat/releases/download/v$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="fuse-exfat: aims to provide a full-featured exFAT file system implementation for GNU/Linux other Unix-like systems as a FUSE module."
PKG_LONGDESC="This project aims to provide a full-featured exFAT file system implementation for GNU/Linux other Unix-like systems as a FUSE module."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"
