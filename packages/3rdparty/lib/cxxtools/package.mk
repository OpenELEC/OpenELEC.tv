################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="cxxtools"
PKG_VERSION="2.2.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL-2"
PKG_SITE="http://www.tntnet.org/cxxtools.html"
PKG_URL="http://www.tntnet.org/download/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="python/web"
PKG_SHORTDESC="cxxtools: a collection of general-purpose C++ classes"
PKG_LONGDESC="Cxxtools is a collection of general-purpose C++ classes"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-demos --with-atomictype=pthread --disable-unittest"
PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-demos --with-atomictype=pthread --disable-unittest"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LDFLAGS="$LDFLAGS -fPIC"
}


post_makeinstall_host() {
  mv $ROOT/$TOOLCHAIN/bin/cxxtools-config $ROOT/$TOOLCHAIN/bin/cxxtools-config.host

  cat >$ROOT/$TOOLCHAIN/bin/cxxtools-config <<EOT
#!/bin/sh
case "\$1" in
--c*flags*|--libs*)
$ROOT/$TOOLCHAIN/bin/cxxtools-config.\$DESTIMAGE "\$@" | xargs -n1 | grep -v -e^-I/usr/include\\$ -e^-L/usr/lib\\$ | xargs
;;
*)
$ROOT/$TOOLCHAIN/bin/cxxtools-config.\$DESTIMAGE "\$@"
;;
esac
EOT

  chmod 0755 $ROOT/$TOOLCHAIN/bin/cxxtools-config
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin

  mv $SYSROOT_PREFIX/usr/bin/cxxtools-config $ROOT/$TOOLCHAIN/bin/cxxtools-config.target

  cat >$ROOT/$TOOLCHAIN/bin/cxxtools-config <<EOT
#!/bin/sh
case "\$1" in
--c*flags*|--libs*)
$ROOT/$TOOLCHAIN/bin/cxxtools-config.\$DESTIMAGE "\$@" | xargs -n1 | grep -v -e^-I/usr/include\\$ -e^-L/usr/lib\\$ | xargs
;;
*)
$ROOT/$TOOLCHAIN/bin/cxxtools-config.\$DESTIMAGE "\$@"
;;
esac
EOT

  chmod 0755 $ROOT/$TOOLCHAIN/bin/cxxtools-config
}
