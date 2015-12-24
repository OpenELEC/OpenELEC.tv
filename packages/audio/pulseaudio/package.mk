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

PKG_NAME="pulseaudio"
PKG_VERSION="7.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://pulseaudio.org/"
PKG_URL="http://www.freedesktop.org/software/pulseaudio/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool json-c alsa-lib libsndfile soxr dbus systemd libressl libcap"
PKG_PRIORITY="optional"
PKG_SECTION="audio"
PKG_SHORTDESC="pulseaudio: Yet another sound server for Unix"
PKG_LONGDESC="PulseAudio is a sound server for Linux and other Unix-like operating systems. It is intended to be an improved drop-in replacement for the Enlightened Sound Daemon (esound or esd). In addition to the features esound provides, PulseAudio has an extensible plugin architecture, support for more than one sink per source, better low-latency behavior, the ability to be embedded into other software, a completely asynchronous C API, a simple command line interface for reconfiguring the daemon while running, flexible and implicit sample type conversion and resampling, and a "Zero-Copy" architecture."

PKG_IS_ADDON="no"

# broken
PKG_AUTORECONF="no"

if [ "$BLUETOOTH_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET sbc"
  PULSEAUDIO_BLUETOOTH="--enable-bluez5"
else
  PULSEAUDIO_BLUETOOTH="--disable-bluez5"
fi

if [ "$AVAHI_DAEMON" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi"
  PULSEAUDIO_AVAHI="--enable-avahi"
else
  PULSEAUDIO_AVAHI="--disable-avahi"
fi

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --disable-nls \
                           --enable-largefile \
                           --disable-rpath \
                           --disable-x11 \
                           --disable-tests \
                           --disable-samplerate \
                           --disable-oss-output \
                           --disable-oss-wrapper \
                           --disable-coreaudio-output \
                           --enable-alsa \
                           --disable-esound \
                           --disable-solaris \
                           --disable-waveout \
                           --disable-glib2 \
                           --disable-gtk3 \
                           --disable-gconf \
                           $PULSEAUDIO_AVAHI \
                           --disable-jack \
                           --disable-asyncns \
                           --disable-tcpwrap \
                           --disable-lirc \
                           --enable-dbus \
                           --disable-bluez4 \
                           $PULSEAUDIO_BLUETOOTH \
                           --disable-bluez5-ofono-headset \
                           --disable-bluez5-native-headset \
                           --enable-udev \
                           --with-udev-rules-dir=/usr/lib/udev/rules.d
                           --disable-hal-compat \
                           --enable-ipv6 \
                           --enable-openssl \
                           --disable-xen \
                           --disable-orc \
                           --disable-manpages \
                           --disable-per-user-esound-socket \
                           --disable-default-build-tests \
                           --disable-legacy-database-entry-format \
                           --with-system-user=root \
                           --with-system-group=root \
                           --with-access-group=root \
                           --without-caps \
                           --without-fftw \
                           --without-speex \
                           --with-soxr \
                           --with-module-dir=/usr/lib/pulse"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/esdcompat
  rm -rf $INSTALL/usr/include
  rm -rf $INSTALL/usr/lib/cmake
  rm -rf $INSTALL/usr/lib/pkgconfig
  rm -rf $INSTALL/usr/lib/systemd
  rm -rf $INSTALL/usr/share/vala
  rm -rf $INSTALL/usr/share/zsh
  rm -rf $INSTALL/usr/share/bash-completion

  cp $PKG_DIR/config/system.pa $INSTALL/etc/pulse/
  cp $PKG_DIR/config/pulseaudio-system.conf $INSTALL/etc/dbus-1/system.d/
}

post_install() {
  enable_service pulseaudio.service
}
