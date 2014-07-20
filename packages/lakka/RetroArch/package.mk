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

PKG_NAME="RetroArch"
PKG_VERSION="b320225"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="$LAKKA_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain alsa-lib freetype retroarch-assets"
PKG_PRIORITY="optional"
PKG_SECTION="RetroArch"
PKG_SHORTDESC="Reference frontend for the libretro API."
PKG_LONGDESC="RetroArch is the reference frontend for the libretro API. Popular examples of implementations for this API includes videogame system emulators and game engines, but also more generalized 3D programs. These programs are instantiated as dynamic libraries. We refer to these as libretro cores."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$PROJECT" == "RPi" ]; then
  export PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"
  export LDFLAGS="$LDFLAGS -lGLESv2"
fi

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  if [ "$PROJECT" == "Cubieboard2" ]; then
    ./configure --disable-vg --disable-ffmpeg --disable-sdl --disable-x11 --disable-xvideo --enable-gles --disable-kms --enable-neon --enable-fbo --enable-mali_fbdev --enable-lakka --enable-freetype
  else
    ./configure --disable-vg --disable-ffmpeg --disable-sdl --disable-x11 --disable-xvideo --enable-lakka
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/etc
    cp $ROOT/$PKG_BUILD/retroarch $INSTALL/usr/bin
    cp $ROOT/$PKG_BUILD/tools/retroarch-joyconfig $INSTALL/usr/bin
    cp $ROOT/$PKG_BUILD/retroarch.cfg $INSTALL/etc
  
  # General configuration
  sed -i -e "s/# libretro_path = \"\/path\/to\/libretro.so\"/libretro_path = \"\/usr\/lib\/libretro\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# rgui_browser_directory =/rgui_browser_directory =\/storage\/roms/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# content_directory =/content_directory =\/storage\/roms/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# savefile_directory =/savefile_directory =\/storage\/savefiles/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# savestate_directory =/savestate_directory =\/storage\/savestates/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# system_directory =/system_directory =\/storage\/system/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# screenshot_directory =/screenshot_directory =\/storage\/screenshots/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_shader_dir =/video_shader_dir =\/storage\/shaders/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# rgui_show_start_screen = true/rgui_show_start_screen = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# assets_directory =/assets_directory =\/usr\/share\/retroarch/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# menu_driver = \"rgui\"/menu_driver = \"lakka\"/" $INSTALL/etc/retroarch.cfg
  
  # Video
  sed -i -e "s/# video_fullscreen = false/video_fullscreen = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_smooth = true/video_smooth = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_aspect_ratio_auto = false/video_aspect_ratio_auto = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_vsync = true/video_vsync = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_threaded = false/video_threaded = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_font_path =/video_font_path =\/usr\/share\/fonts\/liberation\/LiberationSans-Regular.ttf/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_font_size = 48/video_font_size = 32/" $INSTALL/etc/retroarch.cfg
  
  # Input
  sed -i -e "s/# input_driver = sdl/input_driver = udev/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_autodetect_enable = true/input_autodetect_enable = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# joypad_autoconfig_dir =/joypad_autoconfig_dir = \/etc\/retroarch-joypad-autoconfig/" $INSTALL/etc/retroarch.cfg
  
  # Misc
  sed -i -e "s/# video_gpu_screenshot = true/video_gpu_screenshot = false/" $INSTALL/etc/retroarch.cfg
}

post_install() {  
  # link default.target to retroarch.target
  ln -sf retroarch.target $INSTALL/usr/lib/systemd/system/default.target
  
  enable_service retroarch.service
}
