#!/bin/sh
FB_TYPE="$(grep '^0 ' /proc/fb | sed 's/[^[:space:]] //')"

if [ "$FB_TYPE" == "inteldrmfb" ]; then
  OUTPUT=`/usr/bin/xrandr -display :0 -q | sed '/ connected/!d;s/ .*//;q'`
  for out in $OUTPUT ; do
    /usr/bin/xrandr -display :0 --output $out --set "Broadcast RGB" "Full"
  done
fi
