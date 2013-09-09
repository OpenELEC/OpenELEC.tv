################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="alsa-lib"
PKG_VERSION="1.0.27.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.alsa-project.org/"
PKG_URL="ftp://ftp.alsa-project.org/pub/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS="alsa-utils"
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="audio"
PKG_SHORTDESC="alsa-lib: Advanced Linux Sound Architecture library"
PKG_LONGDESC="ALSA (Advanced Linux Sound Architecture) is the next generation Linux Sound API. It provides much finer (->better) access to the sound hardware, has a unbeatable mixer API and supports stuff like multi channel hardware, digital outs and ins, uninterleaved sound data access, and an oss emulation layer (for the old applications). It is the prefered API for professional sound apps under Linux."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

if [ "$DEBUG" = yes ]; then
  ALSA_DEBUG=--with-debug
else
  ALSA_DEBUG=--without-debug
fi

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--with-plugindir=/usr/lib/alsa \
                           --disable-python \
                           $ALSA_DEBUG \
                           --disable-dependency-tracking"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"

  # alsa-lib fails building with LTO support
    strip_lto
}

post_configure_target() {
  sed -i 's/.*PKGLIBDIR.*/#define PKGLIBDIR ""/' include/config.h
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin

  mkdir -p $INSTALL/etc/modprobe.d
    cp -PR $PKG_DIR/config/alsa-base.conf $INSTALL/etc/modprobe.d
  mkdir -p $INSTALL/usr/config
    cp -PR $PKG_DIR/config/modprobe.d $INSTALL/usr/config
}

post_install() {
  add_group audio 63
}
