PKG_NAME="sunxi-tools"
PKG_VERSION="ed6f796"
PKG_SITE="https://github.com/cubieboard/sunxi-tools"
PKG_URL="$LAKKA_MIRROR/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS=""
PKG_DEPENDS_HOST="toolchain libusb:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="extra tools for cubieboards"
PKG_LONGDESC="Tools to help hacking Allwinner A10 (aka sun4i) based devices and it's successors."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

make_host() {
  make clean
  make fex2bin
}

make_target() {
  make clean
  make CC="$TARGET_CC" fex2bin
  make CC="$TARGET_CC" bin2fex
}

makeinstall_host() {
  cp -PR fex2bin $ROOT/$TOOLCHAIN/bin/
  cp -PR fexc $ROOT/$TOOLCHAIN/bin/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp -PR fex2bin $INSTALL/usr/bin
  cp -PR bin2fex $INSTALL/usr/bin
  cp -PR fexc $INSTALL/usr/bin
}

