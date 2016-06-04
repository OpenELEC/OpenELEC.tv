'''
    XBMC LCDproc addon
    Copyright (C) 2012 Team XBMC
    
    Support for extra symbols on Futaba TOSD-5711BB LED displays
    Copyright (C) 2014 Blackeagle
    Original C implementation (C) 2010 Christian Leuschen
    
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

import xbmc
import sys

__scriptname__ = sys.modules[ "__main__" ].__scriptname__
__settings__ = sys.modules[ "__main__" ].__settings__
__cwd__ = sys.modules[ "__main__" ].__cwd__
__icon__ = sys.modules[ "__main__" ].__icon__

from lcdproc import *
from lcdbase import LCD_EXTRAICONS
from extraicons import *
from lcdproc_extra_base import *

def log(loglevel, msg):
  xbmc.log("### [%s] - %s" % (__scriptname__,msg,), level=loglevel) 
  
# extra icon bitmasks
class FUTABA_ICONS:
  ICON_VOLUME           = 0x01 << 0
  ICON_SHUFFLE          = 0x01 << 1
  ICON_MUTE             = 0x01 << 2
  ICON_PHONE            = 0x01 << 3
  ICON_REC              = 0x01 << 4
  ICON_RADIO            = 0x01 << 5
  ICON_DVD              = 0x01 << 6
  ICON_VCD              = 0x01 << 7
  ICON_CD               = 0x01 << 8
  ICON_MUSIC            = 0x01 << 9 
  ICON_PHOTO            = 0x01 << 10
  ICON_TV               = 0x01 << 11
  ICON_DISK             = 0x01 << 12
  ICON_CH_5_1           = 0x01 << 13
  ICON_CH_7_1           = 0x01 << 14
  ICON_REPEAT           = 0x01 << 15
  ICON_ALL              = 0x01 << 16
  ICON_REW              = 0x01 << 17
  ICON_PAUSE            = 0x01 << 18
  ICON_PLAY             = 0x01 << 19
  ICON_TIMER            = 0x01 << 20
  ICON_GUIDE_1          = 0x01 << 21
  ICON_GUIDE_2          = 0x01 << 22
  ICON_HOME             = 0x01 << 23
  ICON_EJECT            = 0x01 << 24
  ICON_FWD              = 0x01 << 25
  ICON_VOLUME_BAR       = 0x01 << 26
  ICON_DUMMY            = 0x01 << 30 # we set this but throw it away

  

class LCDproc_extra_futaba(LCDproc_extra_base):
  def __init__(self):
    self.m_iOutputValueOldIcons = 1
    self.m_iOutputValueIcons = 0

    LCDproc_extra_base.__init__(self)

  # private
  def _SetBarDo(self, barnum, percent):
     
    # volume indicator
    if barnum == 2:
      bitmask = 0x3C000000
      bitshift = 26
      scale = 10
    else:
      return

    if percent < 0:
      rpercent = 0
    elif percent > 100:
      rpercent = 100
    else:
      rpercent = percent

    self.m_iOutputValueIcons = (self.m_iOutputValueIcons &~ bitmask)
    self.m_iOutputValueIcons |= (int(scale * (rpercent / 100)) << bitshift) & bitmask

  # private
  def _SetIconStateDo(self, bitmask, state):
    if state:
      self.m_iOutputValueIcons |= bitmask
    else:
      self.m_iOutputValueIcons &= ~bitmask

  def Initialize(self):
    self.SetBar(1, float(0))

  def SetOutputIcons(self):
    ret = ""
    percent = InfoLabel_GetVolumePercent()
    bitmask = 0x3C000000
    scale = 10
    if percent < 0:
      rpercent = 0
    elif percent > 100:
      rpercent = 100
    else:
      rpercent = percent
    self.m_iOutputValueIcons = (self.m_iOutputValueIcons &~ bitmask) 
    self.m_iOutputValueIcons |= (int(scale * (rpercent / 100)) << 26) & bitmask
     

    if self.m_iOutputValueIcons != self.m_iOutputValueOldIcons:
      self.m_iOutputValueOldIcons = self.m_iOutputValueIcons
      ret += "output %d\n" % (self.m_iOutputValueIcons)

    return ret

  def GetOutputCommands(self):
    return self.SetOutputIcons()

  def SetBar(self, barnum, percent):
    self._SetBarDo(barnum, percent)

  def SetIconState(self, icon, state):
    # General states
                
        
    if icon == LCD_EXTRAICONS.LCD_EXTRAICON_MUTE:
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUTE, state)

    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_PLAYING:
      self._SetIconStateDo(FUTABA_ICONS.ICON_PLAY, state)

    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_PAUSE:
      self._SetIconStateDo(FUTABA_ICONS.ICON_PAUSE, state)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_FWD:
      self._SetIconStateDo(FUTABA_ICONS.ICON_FWD, state) 
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_REW:
      self._SetIconStateDo(FUTABA_ICONS.ICON_REW, state)   
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_SHUFFLE:
      self._SetIconStateDo(FUTABA_ICONS.ICON_SHUFFLE, state)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_REPEAT:
      self._SetIconStateDo(FUTABA_ICONS.ICON_REPEAT, state)

    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_RECORD:
      self._SetIconStateDo(FUTABA_ICONS.ICON_REC, state)

    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_VOLUME:
      self._SetIconStateDo(FUTABA_ICONS.ICON_VOLUME, state)
      
                
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_MUSIC:
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, state)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_PHOTO:
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, state)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, False)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_TV:
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, state)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, False)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_MOVIE:
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, state)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_WEBRADIO:
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, state)
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, False)
      
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_DISC_IN:
      self._SetIconStateDo(FUTABA_ICONS.ICON_DISK, state)

    
    # Output channels
    
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_OUT_2_0:
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_5_1, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_7_1, False)
    
    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_OUT_5_1:
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_7_1, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_5_1, state)

    elif icon == LCD_EXTRAICONS.LCD_EXTRAICON_OUT_7_1:
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_5_1, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_CH_7_1, state)
      
     

  def ClearIconStates(self, category):
    if category == LCD_EXTRAICONCATEGORIES.LCD_ICONCAT_MODES:
      self._SetIconStateDo(FUTABA_ICONS.ICON_TV, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_PHOTO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_MUSIC, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_DVD, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_RADIO, False)
      self._SetIconStateDo(FUTABA_ICONS.ICON_HOME, True)

 
  def GetClearAllCmd(self):
    self.m_iOutputValueOldIcons = 0
    self.m_iOutputValueIcons = 0

    return "output 0\n"
