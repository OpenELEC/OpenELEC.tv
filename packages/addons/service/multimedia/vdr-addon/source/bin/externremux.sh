#!/bin/bash

echo -ne 'Content-type: video/mpeg\r\n'
echo -ne '\r\n'

ffmpeg -i - -vcodec mpeg4 -b 4096000 -vf scale=512:288 -acodec mp2 -ab 32000 -ar 44100 -ac 1 -async 50 -f mpegts pipe:1
