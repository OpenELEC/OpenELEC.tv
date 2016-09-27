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
PKG_DEPENDS_TARGET="toolchain kodi:host kodi:bootstrap xmlstarlet:host Python libz systemd pciutils dbus lzo pcre swig:host libass curl fontconfig fribidi tinyxml libjpeg-turbo freetype libcdio libdvdnav taglib libxml2 libxslt yajl sqlite ffmpeg crossguid giflib opengl"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_BOOTSTRAP="toolchain lzo:host libpng:host libjpeg-turbo:host giflib:host"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi: Kodi Mediacenter"
PKG_LONGDESC="Kodi Media Center (which was formerly named Xbox Media Center or XBMC) is a free and open source cross-platform media player and home entertainment system software with a 10-foot user interface designed for the living-room TV. Its graphical user interface allows the user to easily manage video, photos, podcasts, and music from a computer, optical disk, local network, and the internet using a remote control."

case "$KODIPLAYER_DRIVER" in
  bcm2835-firmware)
    PKG_VERSION="49082fb"
    PKG_GIT_URL="https://github.com/OpenELEC/xbmc.git"
    PKG_GIT_BRANCH="newclock5"
    PKG_KEEP_CHECKOUT="no"
    ;;
  *)
    PKG_VERSION="d51d4ae"
    PKG_GIT_URL="https://github.com/xbmc/xbmc.git"
    PKG_GIT_BRANCH="master"
    PKG_KEEP_CHECKOUT="no"
    ;;
esac

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_CMAKE_SCRIPT_HOST="tools/depends/native/JsonSchemaBuilder/CMakeLists.txt"
PKG_CMAKE_SCRIPT_BOOTSTRAP="tools/depends/native/TexturePacker/CMakeLists.txt"
PKG_CMAKE_SCRIPT_TARGET="project/cmake/CMakeLists.txt"
PKG_PYTHON_VERSION="2.7"

# configure GPU drivers and dependencies:
  get_graphicdrivers

PKG_CMAKE_OPTS_BOOTSTRAP="-DCORE_SOURCE_DIR=$ROOT/$PKG_BUILD"
PKG_CMAKE_OPTS_HOST="-DCORE_SOURCE_DIR=$ROOT/$PKG_BUILD"
PKG_CMAKE_OPTS_TARGET="-DNATIVEPREFIX=$ROOT/$TOOLCHAIN \
                       -DDEPENDS_PATH=$ROOT/$PKG_BUILD/depends \
                       -DWITH_ARCH=$TARGET_ARCH \
                       -DCMAKE_BUILD_TYPE=none \
                       -DPYTHON_INCLUDE_DIRS=$SYSROOT_PREFIX/usr/include/python2.7 \
                       -DGIT_VERSION=$PKG_VERSION \
                       -DENABLE_LDGOLD=OFF \
                       -DENABLE_INTERNAL_FFMPEG=OFF \
                       -DFFMPEG_INCLUDE_DIRS=$SYSROOT_PREFIX/usr \
                       -DENABLE_INTERNAL_CROSSGUID=OFF \
                       -DENABLE_OPENSSL=ON \
                       -DENABLE_SDL=OFF \
                       -DENABLE_CCACHE=OFF \
                       -DENABLE_LIRC=ON \
                       -DENABLE_EVENTCLIENTS=OFF \
                       -DENABLE_LIBUSB=OFF \
                       -DENABLE_UDEV=ON \
                       -DENABLE_XSLT=OFF \
                       -DENABLE_DBUS=ON"


if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" libX11 libXext libdrm libXrandr"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_X11=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_X11=OFF"
fi

if [ "$OPENGL" = "mesa" ]; then
  PKG_DEPENDS_TARGET+=" glu"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPENGL=ON"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPENGLES=OFF"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPENGL=OFF"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPENGLES=ON"
fi

if [ "$ALSA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" alsa-lib"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_ALSA=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_ALSA=OFF"
fi

if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" pulseaudio"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_PULSEAUDIO=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_PULSEAUDIO=OFF"
fi

if [ "$ESPEAK_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" espeak"
fi

if [ "$CEC_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libcec"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_CEC=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_CEC=OFF"
fi

if [ "$KODI_OPTICAL_SUPPORT" = yes ]; then
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPTICAL=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_OPTICAL=OFF"
fi

if [ "$KODI_NONFREE_SUPPORT" = yes ]; then
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_NONFREE=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_NONFREE=OFF"
fi

if [ "$KODI_DVDCSS_SUPPORT" = yes ]; then
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_DVDCSS=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_DVDCSS=OFF"
fi

if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libbluray"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_BLURAY=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_BLURAY=OFF"
fi

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET+=" avahi nss-mdns"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_AVAHI=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_AVAHI=OFF"
fi

if [ "$KODI_MYSQL_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" mariadb"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_MYSQLCLIENT=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_MYSQLCLIENT=OFF"
fi

if [ "$KODI_AIRPLAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libplist"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_PLIST=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_PLIST=OFF"
fi

if [ "$KODI_AIRTUNES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libshairplay"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_AIRTUNES=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_AIRTUNES=OFF"
fi

if [ "$KODI_NFS_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libnfs"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_NFS=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_NFS=OFF"
fi

if [ "$KODI_SAMBA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" samba"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_SMBCLIENT=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_SMBCLIENT=OFF"
fi

if [ "$KODI_WEBSERVER_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libmicrohttpd"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_MICROHTTPD=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_MICROHTTPD=OFF"
fi

if [ "$KODI_UPNP_SUPPORT" = yes ]; then
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_UPNP=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_UPNP=OFF"
fi

if [ "$KODI_SSHLIB_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libssh"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_SSH=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_SSH=OFF"
fi

if [ ! "$KODIPLAYER_DRIVER" = default ]; then
  PKG_DEPENDS_TARGET+=" $KODIPLAYER_DRIVER"

  if [ "$KODIPLAYER_DRIVER" = bcm2835-firmware ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DENABLE_MMAL=ON -DCORE_SYSTEM_NAME=rbpi"
  elif [ "$KODIPLAYER_DRIVER" = libfslvpuwrap ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DENABLE_IMXVPU=ON"
  elif [ "$KODIPLAYER_DRIVER" = libamcodec ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DENABLE_AML=ON"
  fi
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" libvdpau"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_VDPAU=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_VDPAU=OFF"
fi

if [ "$VAAPI_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libva-intel-driver"
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_VAAPI=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DENABLE_VAAPI=OFF"
fi

pre_configure_bootstrap() {
  CXXFLAGS+=" -DTARGET_POSIX -std=c++0x -I$ROOT/$PKG_BUILD/xbmc/linux"
}

makeinstall_bootstrap() {
  rm -f $ROOT/$TOOLCHAIN/bin/TexturePacker
    cp -PR TexturePacker $ROOT/$TOOLCHAIN/bin
}

makeinstall_host() {
  rm -f $ROOT/$TOOLCHAIN/bin/JsonSchemaBuilder
    cp -PR JsonSchemaBuilder $ROOT/$TOOLCHAIN/bin
}

pre_configure_target() {
  export LIBS="$LIBS -lssp -ltermcap"
}

pre_make_target() {
# setup skin dir from default skin
  SKIN_DIR="skin.`tolower $SKIN_DEFAULT`"

# setup default skin inside the sources
  sed -i -e "s|skin.estuary|$SKIN_DIR|g" $ROOT/$PKG_BUILD/xbmc/system.h
  sed -i -e "s|skin.estuary|$SKIN_DIR|g" $ROOT/$PKG_BUILD/system/settings/settings.xml
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/kodi
  rm -rf $INSTALL/usr/bin/kodi-standalone
  rm -rf $INSTALL/usr/share/applications
  rm -rf $INSTALL/usr/share/icons
  rm -rf $INSTALL/usr/share/kodi/cmake
  rm -rf $INSTALL/usr/share/kodi/userdata/iOS
  rm -rf $INSTALL/usr/share/xsessions

  # update addon manifest
    KODI_ADDON_MANIFEST="$INSTALL/usr/share/kodi/system/addon-manifest.xml"
    rm -rf $INSTALL/usr/share/kodi/addons/service.xbmc.versioncheck
      xmlstarlet ed -L -d "/addons/addon[text()='service.xbmc.versioncheck']" $KODI_ADDON_MANIFEST
    rm -rf $INSTALL/usr/share/kodi/addons/skin.estouchy
      xmlstarlet ed -L -d "/addons/addon[text()='skin.estouchy']" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.openelec.tv" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.openelec.settings" $KODI_ADDON_MANIFEST
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "repository.openelec.tv" $KODI_ADDON_MANIFEST

  # more binaddons cross compile badness meh
    sed -e "s:INCLUDE_DIR /usr/include/kodi:INCLUDE_DIR $SYSROOT_PREFIX/usr/include/kodi:g" \
        -e "s:CMAKE_MODULE_PATH /usr/lib/kodi /usr/share/kodi/cmake:CMAKE_MODULE_PATH $SYSROOT_PREFIX/usr/share/kodi/cmake:g" \
        -i $SYSROOT_PREFIX/usr/share/kodi/cmake/KodiConfig.cmake

  mkdir -p $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-config $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi.sh $INSTALL/usr/lib/kodi

  mkdir -p $INSTALL/usr/lib/openelec
    cp $PKG_DIR/scripts/systemd-addon-wrapper $INSTALL/usr/lib/openelec

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/cputemp $INSTALL/usr/bin
      ln -sf cputemp $INSTALL/usr/bin/gputemp
    cp $PKG_DIR/scripts/setwakeup.sh $INSTALL/usr/bin
    cp $ROOT/$PKG_BUILD/tools/EventClients/Clients/Kodi\ Send/kodi-send.py $INSTALL/usr/bin/kodi-send

  if [ "$SKIN_REMOVE_SHIPPED" = "yes" ]; then
    rm -rf $INSTALL/usr/share/kodi/addons/skin.estuary
    xmlstarlet ed -L -d "/addons/addon[text()='skin.estuary']" $KODI_ADDON_MANIFEST
  else
    # Rebrand
      sed -e "s,@DISTRONAME@,$DISTRONAME,g" -i $INSTALL/usr/share/kodi/addons/skin.estuary/1080i/Settings.xml

    rm -rf $INSTALL/usr/share/kodi/addons/skin.estuary/media
    mkdir -p $INSTALL/usr/share/kodi/addons/skin.estuary/media
    cp addons/skin.estuary/media/*.xbt $INSTALL/usr/share/kodi/addons/skin.estuary/media

    mkdir -p $INSTALL/usr/share/kodi/addons/skin.estuary/media/icons/settings
    cp $PKG_DIR/media/openelec.png $INSTALL/usr/share/kodi/addons/skin.estuary/media/icons/settings
  fi

  mkdir -p $INSTALL/usr/share/kodi/addons
    cp -R $PKG_DIR/config/os.openelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.openelec.tv/addon.xml
    cp -R $PKG_DIR/config/repository.openelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@ADDON_URL@|$ADDON_URL|g" -i $INSTALL/usr/share/kodi/addons/repository.openelec.tv/addon.xml

  mkdir -p $INSTALL/usr/lib/python"$PKG_PYTHON_VERSION"/site-packages/kodi
    cp -R $ROOT/$PKG_BUILD/tools/EventClients/lib/python/*.py $INSTALL/usr/lib/python"$PKG_PYTHON_VERSION"/site-packages/kodi

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
