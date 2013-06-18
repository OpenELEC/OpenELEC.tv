#!/bin/bash

# Update XBMC Librarys
sleep 2
xbmc-send -a "UpdateLibrary(video)"
sleep 2
xbmc-send -a "UpdateLibrary(music)"

