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

PKG_NAME="brcmfmac_sdio-firmware"
PKG_VERSION="0.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/OpenELEC/OpenELEC.tv"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="firmware"
PKG_SHORTDESC="brcmfmac_sdio-firmware: firmware for brcm bluetooth devices"
PKG_LONGDESC="Firmware for Broadcom Bluetooth devices and brcm-patchram-plus that downloads a patchram files in the HCD format to the Bluetooth based silicon and combo chips and other utility functions."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_SHA256="3b84712cc56a0c073558718b7c8fdc0cc3c457e7bc804139e9df9b0e3c3d8247"
