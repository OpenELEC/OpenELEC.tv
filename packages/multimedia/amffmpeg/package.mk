################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2014 Alex Deryskyba (alex@codesnake.com)
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

PKG_NAME="amffmpeg"
PKG_VERSION="m6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://ffmpeg.org"
PKG_URL="https://dl.dropboxusercontent.com/u/18902170/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libamavutils"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="amffmpeg is a complete solution to record, convert and stream audio and video, modified by Amlogic."
PKG_LONGDESC="amffmpeg is a complete solution to record, convert and stream audio and video, modified by Amlogic."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$DEBUG" = yes ]; then
  FFMPEG_DEBUG="--enable-debug --disable-stripping"
else
  FFMPEG_DEBUG="--disable-debug --enable-stripping"
fi

if [ "$OPTIMIZATIONS" = size ]; then
  FFMPEG_OPTIM="--disable-small"
else
  FFMPEG_OPTIM="--disable-small"
fi

case "$TARGET_FPU" in
  neon*)
      FFMPEG_FPU="--enable-neon"
  ;;
  vfp*)
      FFMPEG_FPU=""
  ;;
  *)
      FFMPEG_FPU=""
  ;;
esac

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  export pkg_config="$ROOT/$TOOLCHAIN/bin/pkg-config"

# ffmpeg fails building with LTO support
  strip_lto

# ffmpeg fails running with GOLD support
  strip_gold
}

configure_target() {
  ./configure --prefix=/usr \
              --cpu=$TARGET_CPU \
              --arch=$TARGET_ARCH \
              --enable-cross-compile \
              --cross-prefix=$TARGET_PREFIX \
              --sysroot=$SYSROOT_PREFIX \
              --target-os=linux \
              --nm="$NM" \
              --ar="$AR" \
              --as="$CC" \
              --cc="$CC" \
              --ld="$CC" \
              --host-cc="$HOST_CC" \
              --host-cflags="$HOST_CFLAGS" \
              --host-ldflags="$HOST_LDFLAGS" \
              --host-libs="-lm" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS" \
              --extra-libs="" \
              --build-suffix="" \
              --enable-gpl \
              --enable-shared \
              --disable-static \
              --disable-doc \
              $FFMPEG_DEBUG \
              --enable-optimizations \
              --disable-ffprobe \
              --disable-ffplay \
              --disable-ffserver \
              --disable-ffmpeg \
              --disable-avdevice \
              --disable-encoders \
              --enable-postproc \
              --enable-avfilter \
              --enable-pthreads \
              --disable-muxers \
              --disable-altivec \
              --disable-amd3dnow \
              --disable-amd3dnowext \
              --disable-mmx \
              --disable-mmx2 \
              --disable-sse \
              --disable-ssse3 \
              --disable-armv5te \
              --disable-armv6t2 \
              --disable-iwmmxt \
              --disable-mmi \
              --disable-vis \
              --disable-yasm \
              --disable-w32threads \
              --disable-x11grab \
              --enable-runtime-cpudetect \
              --enable-pic \
              --enable-librtmp \
              $FFMPEG_OPTIM \
              $FFMPEG_FPU
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}
