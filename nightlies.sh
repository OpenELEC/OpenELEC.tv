#!/bin/bash

rm -rf target/

DISTRO=Lakka PROJECT=Generic ARCH=x86_64 make image -j9
DISTRO=Lakka PROJECT=Generic ARCH=i386 make image -j9
DISTRO=Lakka PROJECT=RPi ARCH=arm make image -j9
DISTRO=Lakka PROJECT=RPi ARCH=arm make noobs -j9
DISTRO=Lakka PROJECT=RPi2 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=RPi2 ARCH=arm make noobs -j9
DISTRO=Lakka PROJECT=imx6 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=a20 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=a10 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=Bananapi ARCH=arm make image -j9
DISTRO=Lakka PROJECT=OdroidC1 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=OdroidXU3 ARCH=arm make image -j9
DISTRO=Lakka PROJECT=WeTek_Play ARCH=arm make image -j9
DISTRO=Lakka PROJECT=WeTek_Core ARCH=arm make image -j9

for f in target/*; do
  md5sum $f > $f.md5
  sha256sum $f > $f.sha256
done

for f in target/*; do
  dir=`echo $f | sed -e 's/target\/Lakka-\(.*\)-devel-\(.*\)/\1/'`
  mkdir -p target/$dir
  mv $f target/$dir/
done

#scp -r target/* lakka@sources.lakka.tv:sources/nightly/
