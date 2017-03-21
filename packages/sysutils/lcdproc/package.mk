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

PKG_NAME="lcdproc"
PKG_VERSION="3f6d1a4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://lcdproc.org/"
PKG_GIT_URL="https://github.com/lcdproc/lcdproc.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain libusb libhid libftdi1"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="lcdproc: Software to display system information from your Linux/*BSD box on a LCD"
PKG_LONGDESC="LCDproc is a piece of software that displays real-time system information from your Linux/*BSD box on a LCD. The server supports several serial devices: Matrix Orbital, Crystal Fontz, Bayrad, LB216, LCDM001 (kernelconcepts.de), Wirz-SLI, Cwlinux(.com) and PIC-an-LCD; and some devices connected to the LPT port: HD44780, STV5730, T6963, SED1520 and SED1330. Various clients are available that display things like CPU load, system load, memory usage, uptime, and a lot more."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-libusb-1-0 --enable-libusb \
                           --enable-libftdi \
                           --disable-libX11 \
                           --disable-libpng \
                           --enable-libhid \
                           --disable-ethlcd \
                           --enable-drivers=$LCD_DRIVER,!curses,!svga \
                           --enable-seamless-hbars"

IFS=$','
for i in $LCD_DRIVER; do
  case $i in
    glcd)
      PKG_DEPENDS_TARGET+=" freetype serdisplib"
      PKG_CONFIGURE_OPTS_TARGET+=" --enable-freetype --with-ft-prefix=$SYSROOT_PREFIX/usr"    
      ;;
    hd44780)
      PKG_DEPENDS_TARGET+=" libugpio"
      ;;
    irtrans)
      if [ "$IRSERVER_SUPPORT" = yes ]; then
        PKG_DEPENDS_TARGET+=" irserver"
      fi
      ;;
    *)
  esac
done
unset IFS

pre_make_target() {
  # dont build parallel
    MAKEFLAGS=-j1
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/lcd*.conf
  rm -rf $INSTALL/usr/bin

  sed -e "s|^DriverPath=.*$|DriverPath=/usr/lib/lcdproc/|" \
      -e "s|^Driver=.*$|Driver=irtrans|" \
      -e "s|^#Foreground=.*$|Foreground=no|" \
      -e "s|^#ServerScreen=.*$|ServerScreen=blank|" \
      -e "s|^#Backlight=.*$|Backlight=open|" \
      -e "s|^#Heartbeat=.*$|Heartbeat=open|" \
      -e "s|^#TitleSpeed=.*$|TitleSpeed=4|" \
      -e "s|^#Hello=\"  Welcome to\"|Hello=\"Welcome to\"|" \
      -e "s|^#Hello=\"   LCDproc!\"|Hello=\"$DISTRONAME\"|" \
      -e "s|^#GoodBye=\"Thanks for using\"|GoodBye=\"Thanks for using\"|" \
      -e "s|^#GoodBye=\"   LCDproc!\"|GoodBye=\"$DISTRONAME\"|" \
      -e "s|^#normal_font=.*$|normal_font=/usr/share/fonts/liberation/LiberationMono-Bold.ttf|" \
      -i $INSTALL/etc/LCDd.conf

    mkdir -p $INSTALL/usr/lib/openelec
      cp $PKG_DIR/scripts/lcd-wrapper $INSTALL/usr/lib/openelec
}

post_install() {
  enable_service lcdd.service
}
