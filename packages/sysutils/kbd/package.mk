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

PKG_NAME="kbd"
PKG_VERSION="1.15.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="ftp://devel.altlinux.org/legion/kbd/"
PKG_URL="ftp://ftp.altlinux.org/pub/people/legion/kbd/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="kbd: Keyboard and console utilities for Linux"
PKG_LONGDESC="The Linux Console Tools are a set of programs allowing the user to setup/customize your console (restricted meaning: text mode screen + keyboard only)."

PKG_IS_ADDON="no"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

configure_target() {
  ./configure  --host=$TARGET_NAME \
             --build=$HOST_NAME \
             --prefix=/usr \
             --sysconfdir=/etc \
             --datadir=/usr/share/kbd \
             --localstatedir=/var
}

post_make_target() {
  make DESTDIR=$INSTALL
}

makeinstall_target() {
  make DESTDIR=$INSTALL \
  install

  cp $PKG_DIR/config/ru-utf.map.gz $INSTALL/usr/share/kbd/keymaps/
  
  mkdir -p $INSTALL/etc/profile.d
  cp $PKG_DIR/config/locale.conf $INSTALL/etc/profile.d/

  mkdir -p $INSTALL/usr/lib/locale
  cp -R $PKG_DIR/config/locale/* $INSTALL/usr/lib/locale/
}
