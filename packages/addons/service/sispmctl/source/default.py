import os
import xbmc
import xbmcaddon
import subprocess

addon = xbmcaddon.Addon('script.service.sispmctl')
sis = os.path.join(addon.getAddonInfo('path'),'resources','sispmctl')

class MyMonitor( xbmc.Monitor ):

    def __init__( self, *args, **kwargs ):
        xbmc.Monitor.__init__( self )

    def onScreensaverActivated(self):
        subprocess.call([sis, "-f", "all"])

    def onScreensaverDeactivated(self):
        subprocess.call([sis, "-o", "all"])

monitor = MyMonitor()

if __name__ == '__main__':
    print 'XE Screensaver: Python Screensaver Started'


#   they use zip files for packages *sigh*
    subprocess.call(['chmod', '+x', sis]);


#   this is fricking awful.
    while (not xbmc.abortRequested):
        xbmc.sleep(1000);
