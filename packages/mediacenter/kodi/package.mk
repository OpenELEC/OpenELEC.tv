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

PKG_NAME="kodi"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_DEPENDS_TARGET="toolchain kodi:host xmlstarlet:host Python libz systemd pciutils lzo pcre swig:host libass curl fontconfig fribidi tinyxml libjpeg-turbo freetype libcdio libdvdnav taglib libxml2 libxslt yajl sqlite ffmpeg crossguid giflib opengl"
PKG_DEPENDS_HOST="lzo:host libpng:host libjpeg-turbo:host giflib:host"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi: Kodi Mediacenter"
PKG_LONGDESC="Kodi Media Center (which was formerly named Xbox Media Center or XBMC) is a free and open source cross-platform media player and home entertainment system software with a 10-foot user interface designed for the living-room TV. Its graphical user interface allows the user to easily manage video, photos, podcasts, and music from a computer, optical disk, local network, and the internet using a remote control."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

case "$KODIPLAYER_DRIVER" in
  bcm2835-firmware)
    PKG_VERSION="1a415e7"
    PKG_GIT_URL="https://github.com/OpenELEC/xbmc.git"
    PKG_GIT_BRANCH="newclock5"
    PKG_KEEP_CHECKOUT="no"
    ;;
  *)
    PKG_VERSION="abf1aa5"
    PKG_GIT_URL="https://github.com/xbmc/xbmc.git"
    PKG_GIT_BRANCH="master"
    PKG_KEEP_CHECKOUT="no"
    ;;
esac

# configure GPU drivers and dependencies:
  get_graphicdrivers

# for dbus support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET dbus"

if [ "$DISPLAYSERVER" = "x11" ]; then
# for libX11 support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXext libdrm libXrandr"
  KODI_XORG="--enable-x11"
else
  KODI_XORG="--disable-x11"
fi

if [ "$OPENGL" = "mesa" ]; then
# for OpenGL (GLX) support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET glu"
  KODI_OPENGL="--enable-gl --disable-gles"
else
  KODI_OPENGL="--disable-gl --enable-gles"
fi

if [ "$ALSA_SUPPORT" = yes ]; then
# for ALSA support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET alsa-lib"
  KODI_ALSA="--enable-alsa"
else
  KODI_ALSA="--disable-alsa"
fi

if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
# for PulseAudio support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pulseaudio"
  KODI_PULSEAUDIO="--enable-pulse"
else
  KODI_PULSEAUDIO="--disable-pulse"
fi

if [ "$ESPEAK_SUPPORT" = yes ]; then
# for espeak support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET espeak"
fi

if [ "$CEC_SUPPORT" = yes ]; then
# for CEC support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libcec"
  KODI_CEC="--enable-libcec"
else
  KODI_CEC="--disable-libcec"
fi

if [ "$KODI_OPTICAL_SUPPORT" = yes ]; then
  KODI_OPTICAL="--enable-optical-drive"
else
  KODI_OPTICAL="--disable-optical-drive"
fi

if [ "$KODI_NONFREE_SUPPORT" = yes ]; then
# for non-free support
  KODI_NONFREE="--enable-non-free"
else
  KODI_NONFREE="--disable-non-free"
fi

if [ "$KODI_DVDCSS_SUPPORT" = yes ]; then
  KODI_DVDCSS="--enable-dvdcss"
else
  KODI_DVDCSS="--disable-dvdcss"
fi

if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libbluray"
  KODI_BLURAY="--enable-libbluray"
else
  KODI_BLURAY="--disable-libbluray"
fi

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi nss-mdns"
  KODI_AVAHI="--enable-avahi"
else
  KODI_AVAHI="--disable-avahi"
fi

if [ "$KODI_MYSQL_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mariadb"
  KODI_MYSQL="--enable-mysql"
else
  KODI_MYSQL="--disable-mysql"
fi

if [ "$KODI_AIRPLAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libplist"
  KODI_AIRPLAY="--enable-airplay"
else
  KODI_AIRPLAY="--disable-airplay"
fi

if [ "$KODI_AIRTUNES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libshairplay"
  KODI_AIRTUNES="--enable-airtunes"
else
  KODI_AIRTUNES="--disable-airtunes"
fi

if [ "$KODI_NFS_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libnfs"
  KODI_NFS="--enable-nfs"
else
  KODI_NFS="--disable-nfs"
fi

if [ "$KODI_SAMBA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET samba"
  KODI_SAMBA="--enable-samba"
else
  KODI_SAMBA="--disable-samba"
fi

if [ "$KODI_WEBSERVER_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libmicrohttpd"
  KODI_WEBSERVER="--enable-webserver"
else
  KODI_WEBSERVER="--disable-webserver"
fi

if [ "$KODI_UPNP_SUPPORT" = yes ]; then
  KODI_UPNP="--enable-upnp"
else
  KODI_UPNP="--disable-upnp"
fi

if [ "$KODI_SSHLIB_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libssh"
  KODI_SSH="--enable-ssh"
else
  KODI_SSH="--disable-ssh"
fi

if [ ! "$KODIPLAYER_DRIVER" = default ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $KODIPLAYER_DRIVER"

  if [ "$KODIPLAYER_DRIVER" = bcm2835-firmware ]; then
    KODI_OPENMAX="--enable-openmax"
    KODI_PLAYER="--enable-player=omxplayer"
    KODI_CODEC="--with-platform=raspberry-pi"
    BCM2835_INCLUDES="-I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/ \
                      -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"
    KODI_CFLAGS="$KODI_CFLAGS $BCM2835_INCLUDES"
    KODI_CXXFLAGS="$KODI_CXXFLAGS $BCM2835_INCLUDES"
  elif [ "$KODIPLAYER_DRIVER" = libfslvpuwrap ]; then
    KODI_CODEC="--enable-codec=imxvpu"
  elif [ "$KODIPLAYER_DRIVER" = libamcodec ]; then
    KODI_CODEC="--enable-codec=amcodec"
  else
    KODI_OPENMAX="--disable-openmax"
  fi
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
  KODI_VDPAU="--enable-vdpau"
else
  KODI_VDPAU="--disable-vdpau"
fi

if [ "$VAAPI_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva-intel-driver"
  KODI_VAAPI="--enable-vaapi"
else
  KODI_VAAPI="--disable-vaapi"
fi

export CXX_FOR_BUILD="$HOST_CXX"
export CC_FOR_BUILD="$HOST_CC"
export CXXFLAGS_FOR_BUILD="$HOST_CXXFLAGS"
export CFLAGS_FOR_BUILD="$HOST_CFLAGS"
export LDFLAGS_FOR_BUILD="$HOST_LDFLAGS"

export PYTHON_VERSION="2.7"
export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
export ac_python_version="$PYTHON_VERSION"

export GIT_REV="$PKG_VERSION"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_gettimeofday_clobber=no \
                           ac_python_version=$PYTHON_VERSION \
                           --disable-debug \
                           --disable-optimizations \
                           $KODI_OPENGL \
                           $KODI_OPENMAX \
                           $KODI_VDPAU \
                           $KODI_VAAPI \
                           --disable-vtbdecoder \
                           --disable-tegra \
                           --disable-profiling \
                           $KODI_CEC \
                           --enable-udev \
                           --disable-libusb \
                           $KODI_XORG \
                           --disable-ccache \
                           $KODI_ALSA \
                           $KODI_PULSEAUDIO \
                           $KODI_SAMBA \
                           $KODI_NFS \
                           --disable-libcap \
                           $KODI_DVDCSS \
                           --disable-mid \
                           $KODI_AVAHI \
                           $KODI_UPNP \
                           $KODI_MYSQL \
                           $KODI_SSH \
                           $KODI_AIRPLAY \
                           $KODI_AIRTUNES \
                           --disable-libbluetooth \
                           $KODI_NONFREE \
                           $KODI_WEBSERVER \
                           $KODI_OPTICAL \
                           $KODI_BLURAY \
                           --enable-texturepacker \
                           --with-ffmpeg=shared \
                           $KODI_CODEC \
                           $KODI_PLAYER"

build_cmake_hosttool() {
# this build a cmake tool for host with cmake
# usage 'build_cmake_hosttool <path/to/source>'
  mkdir -p $ROOT/$PKG_BUILD/$1/build
  cd $ROOT/$PKG_BUILD/$1/build
    cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
          -DCMAKE_INSTALL_PREFIX=$ROOT/$TOOLCHAIN \
          -DCORE_SOURCE_DIR=$ROOT/$PKG_BUILD \
          ..
    make
  cd $ROOT/$PKG_BUILD
}

pre_configure_host() {
# kodi fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$HOST_NAME

  echo "$PKG_VERSION" > VERSION
}

configure_host() {
  : # not needed
}

make_host() {
  build_cmake_hosttool tools/depends/native/JsonSchemaBuilder
  make -C tools/depends/native/TexturePacker
}

makeinstall_host() {
  cp -PR tools/depends/native/JsonSchemaBuilder/build/JsonSchemaBuilder $ROOT/$TOOLCHAIN/bin
  rm -f $ROOT/$TOOLCHAIN/bin/TexturePacker
  cp -PR tools/depends/native/TexturePacker/native/TexturePacker $ROOT/$TOOLCHAIN/bin
}

pre_build_target() {
# adding fake Makefile for stripped skin
  mkdir -p $PKG_BUILD/addons/skin.estuary/media
  touch $PKG_BUILD/addons/skin.estuary/media/Makefile.in

# autoreconf
  BOOTSTRAP_STANDALONE=1 make -C $PKG_BUILD -f bootstrap.mk
}

pre_configure_target() {
# kodi fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

# libdvd
  cp -P $PKG_DIR/libdvd/libdvd-makefile.in $ROOT/$PKG_BUILD/lib/libdvd/Makefile.in
  export DVD_PREFIX="$SYSROOT_PREFIX"

# kodi should never be built with lto
  strip_lto

  export CFLAGS="$CFLAGS $KODI_CFLAGS"
  export CXXFLAGS="$CXXFLAGS $KODI_CXXFLAGS"
  export LIBS="$LIBS -lz -lssp"

  export JSON_BUILDER=$ROOT/$TOOLCHAIN/bin/JsonSchemaBuilder
}

make_target() {
# setup skin dir from default skin
  SKIN_DIR="skin.`tolower $SKIN_DEFAULT`"

# setup default skin inside the sources
  sed -i -e "s|skin.estuary|$SKIN_DIR|g" $ROOT/$PKG_BUILD/xbmc/system.h
  sed -i -e "s|skin.estuary|$SKIN_DIR|g" $ROOT/$PKG_BUILD/system/settings/settings.xml

  make externals
  make kodi.bin

  if [ "$DISPLAYSERVER" = "x11" ]; then
    make kodi-xrandr
  fi

  if [ "$SKIN_REMOVE_SHIPPED" = "yes" ]; then
    rm -rf addons/skin.estuary
  else
    TexturePacker -input addons/skin.estuary/media/ -output Textures.xbt -dupecheck -use_none
  fi
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/kodi
  rm -rf $INSTALL/usr/bin/kodi-standalone
  rm -rf $INSTALL/usr/bin/xbmc
  rm -rf $INSTALL/usr/bin/xbmc-standalone
  rm -rf $INSTALL/usr/lib/kodi/*.cmake

  # more binaddons cross compile badness meh
  sed -i -e "s:INCLUDE_DIR /usr/include/kodi:INCLUDE_DIR $SYSROOT_PREFIX/usr/include/kodi:g" $SYSROOT_PREFIX/usr/lib/kodi/KodiConfig.cmake

  mkdir -p $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-config $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi.sh $INSTALL/usr/lib/kodi

  mkdir -p $INSTALL/usr/lib/openelec
    cp $PKG_DIR/scripts/systemd-addon-wrapper $INSTALL/usr/lib/openelec

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/cputemp $INSTALL/usr/bin
      ln -sf cputemp $INSTALL/usr/bin/gputemp
    cp $PKG_DIR/scripts/setwakeup.sh $INSTALL/usr/bin
    cp tools/EventClients/Clients/Kodi\ Send/kodi-send.py $INSTALL/usr/bin/kodi-send

  if [ ! "$DISPLAYSERVER" = "x11" ]; then
    rm -rf $INSTALL/usr/lib/kodi/kodi-xrandr
  fi

  rm -rf $INSTALL/usr/share/applications
  rm -rf $INSTALL/usr/share/icons
  rm -rf $INSTALL/usr/share/kodi/addons/service.xbmc.versioncheck
  rm -rf $INSTALL/usr/share/kodi/addons/skin.estouchy
  rm -rf $INSTALL/usr/share/kodi/addons/visualization.vortex
  rm -rf $INSTALL/usr/share/xsessions

  # update addon manifest
    KODI_ADDON_MANIFEST="$INSTALL/usr/share/kodi/system/addon-manifest.xml"
    xmlstarlet ed -L -d "/addons/addon[text()='service.xbmc.versioncheck']" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L -d "/addons/addon[text()='skin.estouchy']" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.openelec.tv" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.openelec.settings" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "repository.openelec.tv" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "repository.kodi.game" $KODI_ADDON_MANIFEST

  if [ ! "$SKIN_REMOVE_SHIPPED" = "yes" ]; then
    # Rebrand
      sed -e "s,@DISTRONAME@,$DISTRONAME,g" -i $INSTALL/usr/share/kodi/addons/skin.estuary/1080i/Settings.xml

    rm -rf $INSTALL/usr/share/kodi/addons/skin.estuary/media
    mkdir -p $INSTALL/usr/share/kodi/addons/skin.estuary/media
    cp Textures.xbt $INSTALL/usr/share/kodi/addons/skin.estuary/media

    mkdir -p $INSTALL/usr/share/kodi/addons/skin.estuary/media/icons/settings
    cp $PKG_DIR/media/openelec.png $INSTALL/usr/share/kodi/addons/skin.estuary/media/icons/settings
  else
    xmlstarlet ed -L -d "/addons/addon[text()='skin.estuary']" $KODI_ADDON_MANIFEST
  fi

  mkdir -p $INSTALL/usr/share/kodi/addons
    cp -R $PKG_DIR/config/os.openelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.openelec.tv/addon.xml
    cp -R $PKG_DIR/config/repository.openelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@ADDON_URL@|$ADDON_URL|g" -i $INSTALL/usr/share/kodi/addons/repository.openelec.tv/addon.xml

  mkdir -p $INSTALL/usr/lib/python"$PYTHON_VERSION"/site-packages/kodi
    cp -R tools/EventClients/lib/python/* $INSTALL/usr/lib/python"$PYTHON_VERSION"/site-packages/kodi

  mkdir -p $INSTALL/usr/share/kodi/config
    cp $PKG_DIR/config/guisettings.xml $INSTALL/usr/share/kodi/config
    cp $PKG_DIR/config/sources.xml $INSTALL/usr/share/kodi/config

# install project specific configs
    if [ -f $PROJECT_DIR/$PROJECT/kodi/guisettings.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/kodi/guisettings.xml $INSTALL/usr/share/kodi/config
    fi

    if [ -f $PROJECT_DIR/$PROJECT/kodi/sources.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/kodi/sources.xml $INSTALL/usr/share/kodi/config
    fi

  mkdir -p $INSTALL/usr/share/kodi/system/
    if [ -f $PROJECT_DIR/$PROJECT/kodi/advancedsettings.xml ]; then
      cp $PROJECT_DIR/$PROJECT/kodi/advancedsettings.xml $INSTALL/usr/share/kodi/system/
    else
      cp $PKG_DIR/config/advancedsettings.xml $INSTALL/usr/share/kodi/system/
    fi

  mkdir -p $INSTALL/usr/share/kodi/system/settings
    if [ -f $PROJECT_DIR/$PROJECT/kodi/appliance.xml ]; then
      cp $PROJECT_DIR/$PROJECT/kodi/appliance.xml $INSTALL/usr/share/kodi/system/settings
    else
      cp $PKG_DIR/config/appliance.xml $INSTALL/usr/share/kodi/system/settings
    fi

  if [ "$KODI_EXTRA_FONTS" = yes ]; then
    mkdir -p $INSTALL/usr/share/kodi/media/Fonts
      cp $PKG_DIR/fonts/*.ttf $INSTALL/usr/share/kodi/media/Fonts
  fi
}

post_install() {
# link default.target to kodi.target
  ln -sf kodi.target $INSTALL/usr/lib/systemd/system/default.target

# enable default services
  enable_service kodi-autostart.service
  enable_service kodi-cleanlogs.service
  enable_service kodi-halt.service
  enable_service kodi-poweroff.service
  enable_service kodi-reboot.service
  enable_service kodi-waitonnetwork.service
  enable_service kodi.service
  enable_service kodi-lirc-suspend.service
}
