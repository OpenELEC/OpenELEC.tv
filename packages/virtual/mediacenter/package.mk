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

PKG_NAME="mediacenter"
PKG_VERSION=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.openelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain $MEDIACENTER $MEDIACENTER-theme-$SKIN_DEFAULT"
PKG_PRIORITY="optional"
PKG_SECTION="virtual"
PKG_SHORTDESC="Mediacenter: Metapackage"
PKG_LONGDESC=""

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

for i in $SKINS; do
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $MEDIACENTER-theme-$i"
done

if [ "$MEDIACENTER" = "kodi" ]; then
# some python stuff needed for various addons
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET Pillow"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET simplejson"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pycrypto"

# audio decoder/encoder addons
#  if [ "$KODI_OPTICAL_SUPPORT" = "yes" ]; then
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.modplug"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.nosefart"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.sidplay"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.snesapu"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.stsound"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.timidity"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audiodecoder.vgmstream"

#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.flac"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.lame"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.vorbis"
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.wav"
#  fi

# various PVR clients
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.argustv"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.demo"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.dvblink"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.dvbviewer"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.filmon"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.hts"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.iptvsimple"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.mediaportal.tvserver"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.mythtv"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.nextpvr"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.njoy"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.pctv"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.stalker"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.vbox"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.vdr.vnsi"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.vuplus"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.wmc"

# visualization addons
#  if [ "$KODI_VIS_FISHBMC" = "yes" ]; then
#    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET visualization.fishbmc"
#  fi
#  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET visualization.spectrum"
#  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET visualization.waveform"

# other packages
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET OpenELEC-settings"
fi

# pvr addons
 PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET"
