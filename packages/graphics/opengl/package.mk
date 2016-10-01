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

PKG_NAME="opengl"
case $OPENGL in
  mesa|bcm2835-firmware)
    PKG_VERSION="1"
    PKG_REV="1"
    PKG_ARCH="any"
    PKG_LICENSE="OSS"
    PKG_SITE="http://www.openelec.tv"
    PKG_URL=""
    PKG_DEPENDS_TARGET="toolchain $OPENGL"
    PKG_PRIORITY="optional"
    PKG_SECTION="virtual"
    PKG_SHORTDESC="opengl: virtual package to build OpenGL(X/ES) support"
    PKG_LONGDESC="opengl is a virtual package to build OpenGL(X/ES) support."
    ;;
  gpu-viv-bin-mx6q)
    PKG_VERSION="$OPENGL-3.10.17-1.0.2"
    PKG_REV="1"
    PKG_ARCH="arm"
    PKG_LICENSE="nonfree"
    PKG_SITE="http://www.freescale.com"
    PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_TARGET="toolchain gpu-viv-g2d"
    PKG_PRIORITY="optional"
    PKG_SECTION="graphics"
    PKG_SHORTDESC="gpu-viv-bin-mx6q: OpenGL-ES and VIVANTE driver for imx6q"
    PKG_LONGDESC="gpu-viv-bin-mx6q: OpenGL-ES and VIVANTE driver for imx6q"
    ;;
  imx-gpu-viv)
    PKG_VERSION="$OPENGL-5.0.11.p4.5"
    PKG_REV="1"
    PKG_ARCH="arm"
    PKG_LICENSE="nonfree"
    PKG_SITE="http://www.freescale.com"
    PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_TARGET="toolchain"
    PKG_PRIORITY="optional"
    PKG_SECTION="graphics"
    PKG_SHORTDESC="opengl-imx-gpu-viv: OpenGL-ES and VIVANTE driver for imx6q"
    PKG_LONGDESC="opengl-imx-gpu-viv: OpenGL-ES and VIVANTE driver for imx6q"
    ;;
  meson6)
    PKG_VERSION="$OPENGL-r5p1-01rel0-armhf"
    PKG_REV="1"
    PKG_ARCH="arm"
    PKG_LICENSE="nonfree"
    PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/filesystem/"
    PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_TARGET="toolchain"
    PKG_PRIORITY="optional"
    PKG_SECTION="graphics"
    PKG_SHORTDESC="opengl-meson6: OpenGL ES pre-compiled libraries for Mali 400 GPUs found in Amlogic Meson6 SoCs"
    PKG_LONGDESC="opengl-meson6: OpenGL ES pre-compiled libraries for Mali 400 GPUs found in Amlogic Meson6 SoCs. The libraries could be found in a Linux buildroot released by Amlogic at http://openlinux.amlogic.com:8000/download/ARM/filesystem/. See the opengl package."
    ;;
  meson8)
    PKG_VERSION="$OPENGL-r5p1-01rel0-armhf"
    PKG_REV="1"
    PKG_ARCH="arm"
    PKG_LICENSE="nonfree"
    PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/filesystem/"
    PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_TARGET="toolchain"
    PKG_PRIORITY="optional"
    PKG_SECTION="graphics"
    PKG_SHORTDESC="opengl-meson8: OpenGL ES pre-compiled libraries for Mali 450 GPUs found in Amlogic Meson8 SoCs"
    PKG_LONGDESC="opengl-meson8: OpenGL ES pre-compiled libraries for Mali 450 GPUs found in Amlogic Meson8 SoCs. The libraries could be found in a Linux buildroot released by Amlogic at http://openlinux.amlogic.com:8000/download/ARM/filesystem/. See the opengl package."
    ;;
  meson-gxbb)
    PKG_VERSION="$OPENGL-r6p1-01rel0"
    PKG_REV="1"
    PKG_ARCH="arm aarch64"
    PKG_LICENSE="nonfree"
    PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/filesystem/"
    PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_TARGET="toolchain"
    PKG_PRIORITY="optional"
    PKG_SECTION="graphics"
    PKG_SHORTDESC="opengl-meson-gxbb: OpenGL ES pre-compiled libraries for Mali 450 GPUs found in Amlogic Meson8 SoCs"
    PKG_LONGDESC="opengl-meson-gxbb: OpenGL ES pre-compiled libraries for Mali 450 GPUs found in Amlogic Meson8 SoCs. The libraries could be found in a Linux buildroot released by Amlogic at http://openlinux.amlogic.com:8000/download/ARM/filesystem/. See the opengl package."
    ;;
esac

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$TARGET_FLOAT" = "softfp" -o "$TARGET_FLOAT" = "soft" ]; then
  FLOAT="softfp"
elif [ "$TARGET_FLOAT" = "hard" ]; then
  FLOAT="hardfp"
fi

if [ "$OPENGL" = "meson6" -o "$OPENGL" = "meson8" -o "$OPENGL" = "meson-gxbb" ]; then
  OPENGL_INCLUDES="usr/include/*"
  OPENGL_LIBRARYS="usr/lib/*.so*"
elif [ "$OPENGL" = "gpu-viv-bin-mx6q" ]; then
  OPENGL_INCLUDES="$FLOAT/usr/include/*"
  OPENGL_LIBRARYS="$FLOAT/usr/lib/libEGL-fb.so \
                   $FLOAT/usr/lib/libEGL.so* \
                   $FLOAT/usr/lib/libGLES_CL.so \
                   $FLOAT/usr/lib/libGLES_CM.so \
                   $FLOAT/usr/lib/libGLESv1_CL.so* \
                   $FLOAT/usr/lib/libGLESv1_CM.so* \
                   $FLOAT/usr/lib/libGLESv2-fb.so \
                   $FLOAT/usr/lib/libGLESv2.so* \
                   $FLOAT/usr/lib/libGLSLC.so* \
                   $FLOAT/usr/lib/libGAL-fb.so \
                   $FLOAT/usr/lib/libGAL.so* \
                   $FLOAT/usr/lib/libVIVANTE-fb.so \
                   $FLOAT/usr/lib/libVIVANTE.so* \
                   $FLOAT/usr/lib/libOpenCL.so"
elif [ "$OPENGL" = "imx-gpu-viv" ]; then
  OPENGL_INCLUDES="$FLOAT/gpu-core/usr/include/* \
                   $FLOAT/g2d/usr/include/*"
  OPENGL_LIBRARYS="$FLOAT/gpu-core/usr/lib/libEGL-fb.so \
                   $FLOAT/gpu-core/usr/lib/libEGL.so* \
                   $FLOAT/gpu-core/usr/lib/libGLES_CL.so* \
                   $FLOAT/gpu-core/usr/lib/libGLES_CM.so* \
                   $FLOAT/gpu-core/usr/lib/libGLESv1_CL.so* \
                   $FLOAT/gpu-core/usr/lib/libGLESv1_CM.so* \
                   $FLOAT/gpu-core/usr/lib/libGLESv2-fb.so \
                   $FLOAT/gpu-core/usr/lib/libGLESv2.so* \
                   $FLOAT/gpu-core/usr/lib/libGAL-fb.so \
                   $FLOAT/gpu-core/usr/lib/libGAL.so* \
                   $FLOAT/gpu-core/usr/lib/libGAL_egl.fb.so \
                   $FLOAT/gpu-core/usr/lib/libGAL_egl.so* \
                   $FLOAT/gpu-core/usr/lib/libVIVANTE-fb.so \
                   $FLOAT/gpu-core/usr/lib/libVIVANTE.so* \
                   $FLOAT/gpu-core/usr/lib/libOpenCL.so \
                   $FLOAT/gpu-core/usr/lib/libVSC.so \
                   $FLOAT/g2d/usr/lib/libg2d*.so*"
fi

make_target() {
 : # nothing todo
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PRv $OPENGL_INCLUDES $SYSROOT_PREFIX/usr/include

  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PRv $OPENGL_LIBRARYS $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/lib
    cp -PRv $OPENGL_LIBRARYS $INSTALL/usr/lib
}

if [ ! "$OPENGL" = "mesa" ]; then
  post_install() {
    enable_service unbind-console.service
  }
fi
