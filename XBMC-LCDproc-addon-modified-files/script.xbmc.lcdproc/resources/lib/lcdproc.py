'''
    XBMC LCDproc addon
    Copyright (C) 2012 Team XBMC
    Copyright (C) 2012 Daniel 'herrnst' Scheller
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

import platform
import xbmc
import sys
import os
import re
import telnetlib
import time

from socket import *

__scriptname__ = sys.modules[ "__main__" ].__scriptname__
__settings__ = sys.modules[ "__main__" ].__settings__
__cwd__ = sys.modules[ "__main__" ].__cwd__
__icon__ = sys.modules[ "__main__" ].__icon__

from settings import *
from lcdbase import *

from lcdproc_extra_imon import *
from lcdproc_extra_mdm166a import *
from lcdproc_extra_futaba import *

from infolabels import *

def log(loglevel, msg):
  xbmc.log("### [%s] - %s" % (__scriptname__,msg,), level=loglevel) 
  
MAX_ROWS = 20
MAX_BIGDIGITS = 20
INIT_RETRY_INTERVAL = 2
INIT_RETRY_INTERVAL_MAX = 60

class LCDProc(LcdBase):
  def __init__(self):
    self.m_bStop        = True
    self.m_lastInitAttempt = 0
    self.m_initRetryInterval = INIT_RETRY_INTERVAL
    self.m_used = True
    self.tn = telnetlib.Telnet()
    self.tnsocket = None
    self.m_timeLastSockAction = time.time()
    self.m_timeSocketIdleTimeout = 2
    self.m_strLineText = [None]*MAX_ROWS
    self.m_strLineType = [None]*MAX_ROWS
    self.m_strLineIcon = [None]*MAX_ROWS
    self.m_strDigits = [None]*MAX_BIGDIGITS
    self.m_iProgressBarWidth = 0
    self.m_iProgressBarLine = -1
    self.m_strIconName = "BLOCK_FILLED"
    self.m_iBigDigits = int(8) # 12:45:78 / colons count as digit
    self.m_iOffset = 1
    self.m_strSetLineCmds = ""
    self.m_cExtraIcons = None
    self.m_vPythonVersion = sys.version_info

    if self.m_vPythonVersion < (2, 7):
      log(xbmc.LOGWARNING, "Python < 2.7 detected. Upgrade your Python for optimal results.")

    LcdBase.__init__(self)

  def SendCommand(self, strCmd, bCheckRet):
    countcmds = string.count(strCmd, '\n')
    sendcmd = strCmd
    ret = True

    # Single command without lf
    if countcmds < 1:
      countcmds = 1
      sendcmd += "\n"

    try:
      # Send to server via raw socket to prevent telnetlib tampering with
      # certain chars (especially 0xFF -> telnet IAC)
      self.tnsocket.sendall(sendcmd)
    except:
      # Something bad happened, abort
      log(xbmc.LOGERROR, "SendCommand: Telnet exception - send")
      return False

    # Update last socketaction timestamp
    self.m_timeLastSockAction = time.time()
    
    # Repeat for number of found commands
    for i in range(1, (countcmds + 1)):
      # Read in (multiple) responses
      while True:
        try:
          # Read server reply
          reply = self.tn.read_until("\n",3)            
        except:
          # (Re)read failed, abort
          log(xbmc.LOGERROR, "SendCommand: Telnet exception - reread")
          return False

        # Skip these messages
        if reply[:6] == 'listen':
          continue
        elif reply[:6] == 'ignore':
          continue
        elif reply[:3] == 'key':
          continue
        elif reply[:9] == 'menuevent':
          continue

        # Response seems interesting, so stop here      
        break
      
      if not bCheckRet:
        continue # no return checking desired, so be fine

      if strCmd == 'noop' and reply == 'noop complete\n':
        continue # noop has special reply

      if reply == 'success\n':
        continue
      
      ret = False

    # Leave information something undesired happened
    if ret is False:
      log(xbmc.LOGWARNING, "Reply to '" + strCmd +"' was '" + reply)

    return ret

  def SetupScreen(self):
    # Add screen first
    if not self.SendCommand("screen_add xbmc", True):
      return False

    # Set screen priority
    if not self.SendCommand("screen_set xbmc -priority info", True):
      return False

    # Turn off heartbeat if desired
    if not settings_getHeartBeat():
      if not self.SendCommand("screen_set xbmc -heartbeat off", True):
        return False

    # Initialize command list var
    strInitCommandList = ""

    # Setup widgets (scrollers and hbars first)
    for i in range(1,int(self.m_iRows)+1):
      # Text widgets
      strInitCommandList += "widget_add xbmc lineScroller" + str(i) + " scroller\n"

      # Progress bars
      strInitCommandList += "widget_add xbmc lineProgress" + str(i) + " hbar\n"

      # Reset bars to zero
      strInitCommandList += "widget_set xbmc lineProgress" + str(i) + " 0 0 0\n"

      self.m_strLineText[i-1] = ""
      self.m_strLineType[i-1] = ""

    # Setup icons last
    for i in range(1,int(self.m_iRows)+1):
      # Icons
      strInitCommandList += "widget_add xbmc lineIcon" + str(i) + " icon\n"

      # Default icon
      strInitCommandList += "widget_set xbmc lineIcon" + str(i) + " 0 0 BLOCK_FILLED\n"

      self.m_strLineIcon[i-1] = ""

    for i in range(1,int(self.m_iBigDigits + 1)):
      # Big Digit
      strInitCommandList += "widget_add xbmc lineBigDigit" + str(i) + " num\n"

      # Set Digit
      strInitCommandList += "widget_set xbmc lineBigDigit" + str(i) + " 0 0\n"

      self.m_strDigits[i] = ""

    if not self.SendCommand(strInitCommandList, True):
      return False

    return True

  def Initialize(self):
    connected = False
    if not self.m_used:
      return False#nothing to do

    #don't try to initialize too often
    now = time.time()
    if (now - self.m_lastInitAttempt) < self.m_initRetryInterval:
      return False
    self.m_lastInitAttempt = now

    if self.Connect():
      if LcdBase.Initialize(self):
        # reset the retry interval after a successful connect
        self.m_initRetryInterval = INIT_RETRY_INTERVAL
        self.m_bStop = False
        connected = True

      else:
        log(xbmc.LOGERROR, "Connection successful but LCD.xml has errors, aborting connect")

    if not connected:
      # preventively close socket
      self.CloseSocket()

      # give up after INIT_RETRY_INTERVAL_MAX (60) seconds
      if self.m_initRetryInterval > INIT_RETRY_INTERVAL_MAX:
        self.m_used = False
        log(xbmc.LOGERROR,"Connect failed. Giving up. Please fix any connection problems and restart the addon.")
      else:
        self.m_initRetryInterval = self.m_initRetryInterval * 2
        log(xbmc.LOGERROR,"Connect failed. Retry in %d seconds." % self.m_initRetryInterval)

    return connected

  def DetermineExtraSupport(self):
    rematch_imon = "SoundGraph iMON(.*)LCD"
    rematch_mdm166a = "Targa(.*)mdm166a"
    rematch_imonvfd = "Soundgraph(.*)VFD"
    rematch_futaba = "Futaba TOSD-5711BB"
    
    bUseExtraIcons = settings_getUseExtraElements()

    # Never cause script failure/interruption by this! This is totally optional!
    try:
      # Retrieve driver name for additional functionality
      self.tn.write("info\n")
      reply = str(self.tn.read_until("\n",3)).strip()

      # When the LCDd driver doesn't supply a valid string, inform and return
      if reply == "":
        log(xbmc.LOGNOTICE, "Empty driver information reply")
        return

      log(xbmc.LOGNOTICE, "Driver information reply: " + reply)

      if re.match(rematch_imon, reply):
        log(xbmc.LOGNOTICE, "SoundGraph iMON LCD detected")
        if bUseExtraIcons:
          self.m_cExtraIcons = LCDproc_extra_imon()

        # override bigdigits counter, the imonlcd driver handles bigdigits
        # different: digits count for two columns instead of three
        self.m_iBigDigits = 7

      elif re.match(rematch_mdm166a, reply):
        log(xbmc.LOGNOTICE, "Futaba/Targa USB mdm166a VFD detected")
        if bUseExtraIcons:
          self.m_cExtraIcons = LCDproc_extra_mdm166a()

      elif re.match(rematch_imonvfd, reply):
        log(xbmc.LOGNOTICE, "SoundGraph iMON IR/VFD detected")

      elif re.match(rematch_futaba, reply):
        log(xbmc.LOGNOTICE, "Futaba TOSD-5711BB LED detected")
        if bUseExtraIcons:
          self.m_cExtraIcons = LCDproc_extra_futaba()

      if self.m_cExtraIcons is not None:
        self.m_cExtraIcons.Initialize()

    except:
      pass

  def Connect(self):
    self.CloseSocket()

    try:
      ip = settings_getHostIp()
      port = settings_getHostPort()
      log(xbmc.LOGDEBUG,"Open " + str(ip) + ":" + str(port))
      
      self.tn.open(ip, port)
      # Start a new session
      self.tn.write("hello\n")

      # Receive LCDproc data to determine row and column information
      reply = self.tn.read_until("\n",3)
      log(xbmc.LOGDEBUG,"Reply: " + reply)
      
      # parse reply by regex
      lcdinfo = re.match("^connect .+ protocol ([0-9\.]+) lcd wid (\d+) hgt (\d+) cellwid (\d+) cellhgt (\d+)$", reply)

      # if regex didn't match, LCDproc is incompatible or something's odd
      if lcdinfo is None:
        return False

      # protocol version must currently be 0.3
      if float(lcdinfo.group(1)) != 0.3:
        log(xbmc.LOGERROR, "Only LCDproc protocol 0.3 supported (got " + lcdinfo.group(1) +")")
        return False

      # set up class vars
      self.m_iColumns = int(lcdinfo.group(2))
      self.m_iRows  = int(lcdinfo.group(3))
      self.m_iCellWidth = int(lcdinfo.group(4))
      self.m_iCellHeight = int(lcdinfo.group(5))

      # tell users what's going on
      log(xbmc.LOGNOTICE, "Connected to LCDd at %s:%s, Protocol version %s - Geometry %sx%s characters (%sx%s pixels, %sx%s pixels per character)" % (str(ip), str(port), float(lcdinfo.group(1)), str(self.m_iColumns), str(self.m_iRows), str(self.m_iColumns * self.m_iCellWidth), str(self.m_iRows * self.m_iCellHeight), str(self.m_iCellWidth), str(self.m_iCellHeight)))

      # Set up BigNum values based on display geometry
      if self.m_iColumns < 13:
        self.m_iBigDigits = 0 # No clock
      elif self.m_iColumns < 17:
        self.m_iBigDigits = 5 # HH:MM
      elif self.m_iColumns < 20:
        self.m_iBigDigits = 7 # H:MM:SS on play, HH:MM on clock
      else:
        self.m_iBigDigits = 8 # HH:MM:SS

      # Check LCDproc if we can enable any extras or override values
      # (might override e.g. m_iBigDigits!)
      self.DetermineExtraSupport()

    except:
      log(xbmc.LOGERROR,"Connect: Caught exception, aborting.")
      return False

    # retrieve raw socket object
    self.tnsocket = self.tn.get_socket()
    if self.tnsocket is None:
      log(xbmc.LOGERROR, "Retrieval of socket object failed!")
      return False

    if not self.SetupScreen():
      log(xbmc.LOGERROR, "Screen setup failed!")
      return False      

    return True

  def CloseSocket(self):
    if self.tnsocket:
      # no pyexceptions, please, we're disconnecting anyway
      try:
        # if we served extra elements, (try to) reset them
        if self.m_cExtraIcons is not None:
          if not self.SendCommand(self.m_cExtraIcons.GetClearAllCmd(), True):
            log(xbmc.LOGERROR, "CloseSocket(): Cannot clear extra icons")

        # do gracefully disconnect (send directly as we won't get any response on this)
        self.tn.write("bye\n")
        # and close socket afterwards
        self.tn.close()
      except:
        # exception caught on this, so what? :)
        pass

    # delete/cleanup extra support instance
    del self.m_cExtraIcons
    self.m_cExtraIcons = None

    self.tnsocket = None
    del self.tn
    self.tn = telnetlib.Telnet()

  def IsConnected(self):
    if not self.tnsocket:
      return False

    # Ping only every SocketIdleTimeout seconds
    if (self.m_timeLastSockAction + self.m_timeSocketIdleTimeout) > time.time():
      return True

    if not self.SendCommand("noop", True):
      log(xbmc.LOGERROR, "noop failed in IsConnected(), aborting!")
      return False

    return True

  def SetBackLight(self, iLight):
    if not self.tnsocket:
      return
    log(xbmc.LOGDEBUG, "Switch Backlight to: " + str(iLight))

    # Build command
    if iLight == 0:
      cmd = "screen_set xbmc -backlight off\n"
    elif iLight > 0:
      cmd = "screen_set xbmc -backlight on\n"

    # Send to server
    if not self.SendCommand(cmd, True):
      log(xbmc.LOGERROR, "SetBackLight(): Cannot change backlight state")
      self.CloseSocket()

  def SetContrast(self, iContrast):
    #TODO: Not sure if you can control contrast from client
    return

  def Stop(self):
    self.CloseSocket()
    self.m_bStop = True

  def Suspend(self):
    if self.m_bStop or not self.tnsocket:
      return

    # Build command to suspend screen
    cmd = "screen_set xbmc -priority hidden\n"

    # Send to server
    if not self.SendCommand(cmd, True):
      log(xbmc.LOGERROR, "Suspend(): Cannot suspend")
      self.CloseSocket()

  def Resume(self):
    if self.m_bStop or not self.tnsocket:
      return

    # Build command to resume screen
    cmd = "screen_set xbmc -priority info\n"

    # Send to server
    if not self.SendCommand(cmd, True):
      log(xbmc.LOGERROR, "Resume(): Cannot resume")
      self.CloseSocket()

  def GetColumns(self):
    return int(self.m_iColumns)

  def GetBigDigitTime(self, mode):
      ret = ""
      if not (InfoLabel_IsPlayerPaused() and mode == LCD_MODE.LCD_MODE_SCREENSAVER):
        ret = InfoLabel_GetPlayerTime()[-self.m_iBigDigits:]

      if ret == "": # no usable timestring, e.g. not playing anything
        strSysTime = InfoLabel_GetSystemTime()

        if self.m_iBigDigits >= 8: # return h:m:s
          ret = strSysTime
        elif self.m_iBigDigits >= 5: # return h:m when display too small
          ret = strSysTime[:5]

      return ret

  def SetBigDigits(self, strTimeString, bForceUpdate):
    iOffset = 1
    iDigitCount = 1
    iStringOffset = 0
    strRealTimeString = ""

    if strTimeString == "" or strTimeString == None:
      return

    iStringLength = int(len(strTimeString))

    if self.m_bCenterBigDigits:
      iColons = strTimeString.count(":")
      iWidth  = 3 * (iStringLength - iColons) + iColons
      iOffset = 1 + max(self.m_iColumns - iWidth, 0) / 2

    if iStringLength > self.m_iBigDigits:
      iStringOffset = len(strTimeString) - self.m_iBigDigits
      iOffset = 1;

    if self.m_iOffset != iOffset:
      # on offset change, reset numbers (only) to force redraw
      self.ClearBigDigits(False)
      self.m_iOffset = iOffset

    for i in range(int(iStringOffset), int(iStringLength)):
      if self.m_strDigits[iDigitCount] != strTimeString[i] or bForceUpdate:
        self.m_strDigits[iDigitCount] = strTimeString[i]
        
        if strTimeString[i] == ":":
          self.m_strSetLineCmds += "widget_set xbmc lineBigDigit%i %i 10\n" % (iDigitCount, iOffset)
        elif strTimeString[i].isdigit():
          self.m_strSetLineCmds += "widget_set xbmc lineBigDigit%i %i %s\n" % (iDigitCount, iOffset, strTimeString[i])
        else:
          self.m_strSetLineCmds += "widget_set xbmc lineBigDigit" + str(iDigitCount) + " 0 0\n"

      if strTimeString[i] == ":":
        iOffset += 1
      else:
        iOffset += 3

      iDigitCount += 1

    while iDigitCount <= self.m_iBigDigits:
      if self.m_strDigits[iDigitCount] != "" or bForceUpdate:
        self.m_strDigits[iDigitCount] = ""
        self.m_strSetLineCmds += "widget_set xbmc lineBigDigit" + str(iDigitCount) + " 0 0\n"
      
      iDigitCount += 1

  def SetProgressBar(self, percent, pxWidth):
    self.m_iProgressBarWidth = int(float(percent) * pxWidth)
    return self.m_iProgressBarWidth

  def SetPlayingStateIcon(self):
    bPlaying = InfoLabel_IsPlayerPlaying()
    bPaused = InfoLabel_IsPlayerPaused()
    bForwarding = InfoLabel_IsPlayerForwarding()
    bRewinding = InfoLabel_IsPlayerRewinding()

    self.m_strIconName = "STOP"

    if bForwarding:
      self.m_strIconName = "FF"
    elif bRewinding:
      self.m_strIconName = "FR"
    elif bPaused:
      self.m_strIconName = "PAUSE"
    elif bPlaying:
      self.m_strIconName = "PLAY"

  def GetRows(self):
    return int(self.m_iRows)

  def ClearBigDigits(self, fullredraw = True):
    for i in range(1,int(self.m_iBigDigits + 1)):
      # Clear Digit
      if fullredraw:
        self.m_strSetLineCmds += "widget_set xbmc lineBigDigit" + str(i) + " 0 0\n"
      self.m_strDigits[i] = ""

    # on full redraw, make sure all widget get redrawn by resetting their type
    if fullredraw:
      for i in range(0, int(self.GetRows())):
        self.m_strLineType[i] = ""
        self.m_strLineText[i] = ""
        self.m_strLineIcon[i] = ""

  def ClearLine(self, iLine):
    self.m_strSetLineCmds += "widget_set xbmc lineIcon%i 0 0 BLOCK_FILLED\n" % (iLine)
    self.m_strSetLineCmds += "widget_set xbmc lineProgress%i 0 0 0\n" % (iLine)
    self.m_strSetLineCmds += "widget_set xbmc lineScroller%i 1 %i %i %i m 1 \"\"\n" % (iLine, iLine, self.m_iColumns, iLine)

  def SetLine(self, mode, iLine, strLine, dictDescriptor, bForce):
    if self.m_bStop or not self.tnsocket:
      return

    if iLine < 0 or iLine >= int(self.m_iRows):
      return

    ln = iLine + 1
    bExtraForce = False

    if self.m_strLineType[iLine] != dictDescriptor['type']:
      if dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_BIGSCREEN:
        self.ClearDisplay()
      else:
        if self.m_strLineType[iLine] == LCD_LINETYPE.LCD_LINETYPE_BIGSCREEN:
          self.ClearBigDigits()
        else:
          self.ClearLine(int(iLine + 1))

      self.m_strLineType[iLine] = dictDescriptor['type']
      bExtraForce = True

      if dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_PROGRESS and dictDescriptor['text'] != "":
        self.m_strSetLineCmds += "widget_set xbmc lineScroller%i 1 %i %i %i m 1 \"%s\"\n" % (ln, ln, self.m_iColumns, ln, dictDescriptor['text'])

    if dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_BIGSCREEN:
      strLineLong = self.GetBigDigitTime(mode)
    else:
      strLineLong = strLine

    strLineLong.strip()
  
    iMaxLineLen = dictDescriptor['endx'] - (int(dictDescriptor['startx']) - 1)
    iScrollSpeed = settings_getScrollDelay()
    strScrollMode = settings_getLCDprocScrollMode()

    if len(strLineLong) > iMaxLineLen: # if the string doesn't fit the display...
      if iScrollSpeed != 0:          # add separator when scrolling enabled
        if strScrollMode == "m":     # and scrollmode is marquee
          strLineLong += self.m_strScrollSeparator      
      else:                                       # or cut off
        strLineLong = strLineLong[:iMaxLineLen]
        iScrollSpeed = 1

    iStartX = dictDescriptor['startx']

    # check if update is required
    if strLineLong != self.m_strLineText[iLine] or bForce:
      # bigscreen
      if dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_BIGSCREEN:
        self.SetBigDigits(strLineLong, bExtraForce)
      # progressbar line
      elif dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_PROGRESS:
        self.m_strSetLineCmds += "widget_set xbmc lineProgress%i %i %i %i\n" % (ln, iStartX, ln, self.m_iProgressBarWidth)
      # everything else (text, icontext)
      else:
        if len(strLineLong) < iMaxLineLen and dictDescriptor['align'] != LCD_LINEALIGN.LCD_LINEALIGN_LEFT:
          iSpaces = iMaxLineLen - len(strLineLong)
          if dictDescriptor['align'] == LCD_LINEALIGN.LCD_LINEALIGN_RIGHT:
            iStartX += iSpaces
          elif dictDescriptor['align'] == LCD_LINEALIGN.LCD_LINEALIGN_CENTER:
            iStartX += int(iSpaces / 2)

        self.m_strSetLineCmds += "widget_set xbmc lineScroller%i %i %i %i %i %s %i \"%s\"\n" % (ln, iStartX, ln, self.m_iColumns, ln, strScrollMode, iScrollSpeed, re.escape(strLineLong))

      # cache contents
      self.m_strLineText[iLine] = strLineLong

    if dictDescriptor['type'] == LCD_LINETYPE.LCD_LINETYPE_ICONTEXT:
      if self.m_strLineIcon[iLine] != self.m_strIconName or bExtraForce:
        self.m_strLineIcon[iLine] = self.m_strIconName
        
        self.m_strSetLineCmds += "widget_set xbmc lineIcon%i 1 %i %s\n" % (ln, ln, self.m_strIconName)

  def ClearDisplay(self):
    log(xbmc.LOGDEBUG, "Clearing display contents")

    # clear line buffer first
    self.FlushLines()

    # set all widgets to empty stuff and/or offscreen
    for i in range(1,int(self.m_iRows)+1):
      self.ClearLine(i)

    # add commands to clear big digits
    self.ClearBigDigits()

    # send to display
    self.FlushLines()

  def FlushLines(self):
      if len(self.m_strSetLineCmds) > 0:
        # Send complete command package
        self.SendCommand(self.m_strSetLineCmds, False)

        self.m_strSetLineCmds = ""
