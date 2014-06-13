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

PKG_NAME="libamplayer"
PKG_VERSION="m6"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_SITE="http://www.amlogic.com"
PKG_URL="https://dl.dropboxusercontent.com/u/18902170/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libamplayer: Amlogic media player library for M6"
PKG_LONGDESC="libamplayer: Amlogic media player library for M6"

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
}

configure_target() {
  cd amffmpeg
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
              --extra-cflags="$CFLAGS -I$ROOT/$PKG_BUILD/amavutils/include" \
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
              $FFMPEG_OPTIM \
              $FFMPEG_FPU
  cd ..
}

make_target() {
  make -C amavutils CC="$CC" PREFIX="$SYSROOT_PREFIX/usr"
  mkdir -p $SYSROOT_PREFIX/usr/lib
  cp -PR amavutils/*.so $SYSROOT_PREFIX/usr/lib

  make -C amffmpeg LDFLAGS="-lamavutils" prefix="$SYSROOT_PREFIX/usr" install
  make -C amadec CC="$CC" PREFIX="$SYSROOT_PREFIX/usr" CROSS_PREFIX="$TARGET_PREFIX" install
  make -C amcodec CC="$CC" HEADERS_DIR="$SYSROOT_PREFIX/usr/include/amcodec" PREFIX="$SYSROOT_PREFIX/usr" CROSS_PREFIX="$TARGET_PREFIX" install
  make -C amplayer CC="$CC" PREFIX="$SYSROOT_PREFIX/usr" CROSS_PREFIX="$TARGET_PREFIX" install
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
  cp -PR amavutils/*.so $INSTALL/usr/lib

  make -C amffmpeg prefix="$INSTALL/usr" install
  make -C amadec PREFIX="$INSTALL/usr" install
  make -C amcodec HEADERS_DIR="$INSTALL/usr/include/amcodec" PREFIX="$INSTALL/usr" install
  make -C amplayer CC="$CC" PREFIX="$INSTALL/usr" install
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}
