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

PKG_NAME="w_scan"
PKG_VERSION="20170107"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://wirbel.htpc-forum.de/w_scan/index2.html"
PKG_URL="http://wirbel.htpc-forum.de/w_scan/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="w_scan: eine kleine Anwendung zum Scannen von ATSC/DVB-C/S/T Transpondern/Bouquets nach Sendern und Erstellen einer VDR channels.conf."
PKG_LONGDESC="w_scan ist eine kleine Anwendung zum Scannen von ATSC/DVB-C/S/T Transpondern/Bouquets nach Sendern und Erstellen einer VDR channels.conf."

PKG_AUTORECONF="yes"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.1"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_BUILD/.$TARGET_NAME/w_scan $ADDON_BUILD/$PKG_ADDON_ID/bin
}
