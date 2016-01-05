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

PKG_NAME="pcre"
PKG_VERSION="8.38"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.pcre.org/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="pcre: Perl Compatible Regulat Expressions"
PKG_LONGDESC="The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API. The PCRE library is free, even for building commercial software."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$TOOLCHAIN \
             --enable-utf8 \
             --enable-unicode-properties \
             --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
             --enable-static \
             --enable-utf8 \
             --enable-unicode-properties \
             --with-gnu-ld"

post_makeinstall_host() {
  mv $ROOT/$TOOLCHAIN/bin/pcre-config $ROOT/$TOOLCHAIN/bin/pcre-config.host

  cat >$ROOT/$TOOLCHAIN/bin/pcre-config <<EOT
#!/bin/sh
case "\$1" in
--c*flags*|--libs*)
$ROOT/$TOOLCHAIN/bin/pcre-config.\$DESTIMAGE "\$@" | xargs -n1 | grep -v -e^-I/usr/include\\$ -e^-L/usr/lib\\$ | xargs
;;
*)
$ROOT/$TOOLCHAIN/bin/pcre-config.\$DESTIMAGE "\$@"
;;
esac
EOT

  chmod 0755 $ROOT/$TOOLCHAIN/bin/pcre-config
}

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LDFLAGS="$LDFLAGS -fPIC"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin

  mv $SYSROOT_PREFIX/usr/bin/pcre-config $ROOT/$TOOLCHAIN/bin/pcre-config.target

  cat >$ROOT/$TOOLCHAIN/bin/pcre-config <<EOT
#!/bin/sh
case "\$1" in
--c*flags*|--libs*)
$ROOT/$TOOLCHAIN/bin/pcre-config.\$DESTIMAGE "\$@" | xargs -n1 | grep -v -e^-I/usr/include\\$ -e^-L/usr/lib\\$ | xargs
;;
*)
$ROOT/$TOOLCHAIN/bin/pcre-config.\$DESTIMAGE "\$@"
;;
esac
EOT

  chmod 0755 $ROOT/$TOOLCHAIN/bin/pcre-config
}
