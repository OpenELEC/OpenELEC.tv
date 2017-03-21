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

PKG_NAME="libressl"
PKG_VERSION="2.4.5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.libressl.org/"
PKG_URL="http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="libressl: a FREE version of the SSL/TLS protocol forked from OpenSSL"
PKG_LONGDESC="LibreSSL is a FREE version of the SSL/TLS protocol forked from OpenSSL"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_makeinstall_target() {
  # libressl default location
    mkdir -p $INSTALL/etc/ssl/
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/ssl/cert.pem

  # legacy OpenELEC compat
    mkdir -p $INSTALL/etc/pki/tls/
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/pki/tls/cert.pem

  # Debian/Ubuntu/Gentoo etc. compat
    mkdir -p $INSTALL/etc/ssl/certs/
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/ssl/certs/ca-certificates.crt
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/ssl/certs/ca-bundle.crt

  # Fedora/RHEL compat
    mkdir -p $INSTALL/etc/pki/tls/certs/
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt

  # OpenSUSE compat
    mkdir -p $INSTALL/etc/ssl/
      ln -sf /usr/etc/ssl/cert.pem $INSTALL/etc/ssl/ca-bundle.pem
}
