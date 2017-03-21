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

PKG_NAME="dbus-python"
PKG_VERSION="1.2.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://freedesktop.org/wiki/Software/dbus"
PKG_URL="https://dbus.freedesktop.org/releases/dbus-python/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python dbus dbus-glib"
PKG_PRIORITY="optional"
PKG_SECTION="python/system"
PKG_SHORTDESC="dbus-python: A message bus system"
PKG_LONGDESC="D-BUS is a message bus, used for sending messages between applications. Conceptually, it fits somewhere in between raw sockets and CORBA in terms of complexity. D-BUS supports broadcast messages, asynchronous messages (thus decreasing latency), authentication, and more. It is designed to be low-overhead; messages are sent using a binary protocol, not using XML. D-BUS also supports a method call mapping for its messages, but it is not required; this makes using the system quite simple."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export PYTHON_INCLUDES="$($SYSROOT_PREFIX/usr/bin/python2-config --includes)"
  export PYTHON_LIBS="$($SYSROOT_PREFIX/usr/bin/python2-config --ldflags)"
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  find $INSTALL/usr/lib -name "*.pyc" -exec rm -rf "{}" ";"
}
