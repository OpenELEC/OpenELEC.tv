#!/bin/bash
#

config=/var/config/rtorrent.conf

if [ ! -f $config ];then
   echo "Could not find config file $config"
   echo "exiting..."
   exit 1
fi

if [ "$#" -lt 1 ] 
then
   echo "Need input"
   echo "Exiting..."
   exit 1
fi

# Load config.
. $config

# Load vars.
HASH=$1
shift

FROM="$@"
FROM="${FROM%/}"

NAME=${FROM##*/}

MATCH=${FROM%/*}
MATCH=${MATCH##*/}

# Determin where to store...
for RTORRENT_DIR in ${RTORRENT_DIRS//,/ } ;do
   if [[ "$MATCH" == "$RTORRENT_DIR" ]];then
      STORE=${RTORRENT_COMPLETE_DIR}${RTORRENT_DIR}
   fi
done 

# Do on complete action
if [ "$STORE" ] ;then

   # Make sure series are in a dir with series.name.sNN, if possible.
   if [ ! -d "$FROM" ];then
      DIR=${NAME%[e,E][0-9]*}
      STORE="$STORE/$DIR"
   fi

   if [ $RTORRENT_ON_COMPLETE == Move ] ;then
      mkdir "$STORE"
      xmlrpc2scgi.py -p 'scgi://localhost:5000' d.set_directory $HASH "$STORE"
      mv "$FROM" "$STORE"
   elif [ $RTORRENT_ON_COMPLETE == Link ] ;then
      mkdir "$STORE"
      ln -sf "$FROM" "$STORE"
   fi

fi

# Notify user
xbmc-send -a "Notification(rTorrent - Download Completed,$NAME,10000)"

