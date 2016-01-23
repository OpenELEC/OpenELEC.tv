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

PKG_NAME="kodi-theme-slice"
PKG_VERSION="0.9.18u"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.fiveninjas.com"
PKG_URL="http://updates.fiveninjas.com/src/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi led_tools"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi-theme-Slice: Slice media center default skin"
PKG_LONGDESC="Slice skin:  Optimised skin for the Slice media player"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  TexturePacker -input media/ \
                -output Textures.xbt \
                -dupecheck \
                -use_none
  for i in `ls themes`; do
    echo Packing theme $i
    TexturePacker -input themes/$i/ \
                  -output $i.xbt \
                  -dupecheck \
                  -use_none
  done
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/kodi/addons/skin.slice
    cp -R */ $INSTALL/usr/share/kodi/addons/skin.slice
    rm -rf $INSTALL/usr/share/kodi/addons/skin.slice/media
    cp *.xml $INSTALL/usr/share/kodi/addons/skin.slice

  mkdir -p $INSTALL/usr/share/kodi/addons/skin.slice/media
    cp Textures.xbt $INSTALL/usr/share/kodi/addons/skin.slice/media
    for i in `ls themes`; do
      cp $i.xbt $INSTALL/usr/share/kodi/addons/skin.slice/media
    done
}

