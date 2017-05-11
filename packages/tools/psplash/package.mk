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

PKG_NAME="psplash"
PKG_VERSION="5b3c1cc"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://git.yoctoproject.org/cgit/cgit.cgi/psplash"
PKG_GIT_URL="http://git.yoctoproject.org/git/psplash"
PKG_DEPENDS_INIT="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="psplash: Boot splash screen based on Fedora's Plymouth code"
PKG_LONGDESC="PSplash is a userspace graphical boot splash screen for mainly embedded Linux devices supporting a 16bpp or 32bpp framebuffer."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_init() {
  if [ -f $PROJECT_DIR/$PROJECT/splash/splash.h ]; then
    PSPLASH_SPLASH="$PROJECT_DIR/$PROJECT/splash/splash.h"
  elif [ -f $DISTRO_DIR/$DISTRO/splash/splash.h ]; then
    PSPLASH_SPLASH="$DISTRO_DIR/$DISTRO/splash/splash.h"
  else
    PSPLASH_SPLASH="$PKG_DIR/splash/splash.h"
  fi
  cp $PSPLASH_SPLASH $ROOT/$PKG_BUILD/psplash-poky-img.h

  sed -e "s:#define PSPLASH_IMG_FULLSCREEN 0:#define PSPLASH_IMG_FULLSCREEN 1:g" \
      -i $ROOT/$PKG_BUILD/psplash-config.h

  sed -e "s:#define PSPLASH_BACKGROUND_COLOR 0xec,0xec,0xe1:#define PSPLASH_BACKGROUND_COLOR 0x00,0x00,0x00:g" \
      -e "s:#define PSPLASH_TEXT_COLOR 0x6d,0x6d,0x70:#define PSPLASH_TEXT_COLOR 0x96,0xc8,0xea:g" \
      -i $ROOT/$PKG_BUILD/psplash-colors.h
}

makeinstall_init() {
  mkdir -p $INSTALL/bin
    cp -P psplash $INSTALL/bin
}
