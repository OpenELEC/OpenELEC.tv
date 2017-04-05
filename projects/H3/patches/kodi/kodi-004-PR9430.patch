From b4423b184e08dbb35ce74b019128982436ed2400 Mon Sep 17 00:00:00 2001
From: popcornmix <popcornmix@gmail.com>
Date: Tue, 22 Mar 2016 22:28:13 +0000
Subject: [PATCH] [linux] Move hotplug checking into its own thread

Currently checking for new linux input devices is called from the rendering thread.
We've been getting reports of skipped frames on raspberry pi.

Specifically if eventlirc is active and you have an LIRC capable device connected
the hotplug check is slow and you get a frame skip every ten seconds.

So move this code into its own thread
---
 xbmc/input/linux/LinuxInputDevices.cpp | 54 +++++++++++++++++++++-------------
 xbmc/input/linux/LinuxInputDevices.h   | 14 ++++++++-
 xbmc/windowing/WinEventsLinux.cpp      |  1 +
 xbmc/windowing/WinEventsLinux.h        |  2 ++
 4 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/xbmc/input/linux/LinuxInputDevices.cpp b/xbmc/input/linux/LinuxInputDevices.cpp
index e691aa8..b97a40e 100644
--- a/xbmc/input/linux/LinuxInputDevices.cpp
+++ b/xbmc/input/linux/LinuxInputDevices.cpp
@@ -1085,6 +1085,30 @@ bool CLinuxInputDevice::IsUnplugged()
   return m_bUnplugged;
 }
 
+CLinuxInputDevicesCheckHotplugged::CLinuxInputDevicesCheckHotplugged(CLinuxInputDevices &parent) :
+    CThread("CLinuxInputDevicesCheckHotplugged"), m_parent(parent)
+{
+  Create();
+  SetPriority(THREAD_PRIORITY_BELOW_NORMAL);
+}
+
+CLinuxInputDevicesCheckHotplugged::~CLinuxInputDevicesCheckHotplugged()
+{
+  m_bStop = true;
+  m_quitEvent.Set();
+  StopThread(true);
+}
+
+void CLinuxInputDevicesCheckHotplugged::Process()
+{
+  while (!m_bStop)
+  {
+    m_parent.CheckHotplugged();
+    // every ten seconds
+    m_quitEvent.WaitMSec(10000);
+  }
+}
+
 /*
  * this function is not powerful because it reinitializes a new udev search each
  * time it would be nicer to call this only one time + one time at each hotplug
@@ -1225,10 +1249,6 @@ void CLinuxInputDevices::InitAvailable()
  */
 void CLinuxInputDevices::CheckHotplugged()
 {
-  CSingleLock lock(m_devicesListLock);
-
-  int deviceId = m_devices.size();
-
   /* No devices specified. Try to guess some. */
   for (int i = 0; i < MAX_LINUX_INPUT_DEVICES; i++)
   {
@@ -1236,18 +1256,22 @@ void CLinuxInputDevices::CheckHotplugged()
     bool ispresent = false;
 
     snprintf(buf, 32, "/dev/input/event%d", i);
-
-    for (size_t j = 0; j < m_devices.size(); j++)
     {
-      if (m_devices[j]->GetFileName().compare(buf) == 0)
+      CSingleLock lock(m_devicesListLock);
+      for (size_t j = 0; j < m_devices.size(); j++)
       {
-        ispresent = true;
-        break;
+        if (m_devices[j]->GetFileName().compare(buf) == 0)
+        {
+          ispresent = true;
+          break;
+        }
       }
     }
 
     if (!ispresent && CheckDevice(buf))
     {
+      CSingleLock lock(m_devicesListLock);
+      int deviceId = m_devices.size();
       CLog::Log(LOGINFO, "Found input device %s", buf);
       m_devices.push_back(new CLinuxInputDevice(buf, deviceId));
       ++deviceId;
@@ -1438,18 +1462,6 @@ XBMC_Event CLinuxInputDevices::ReadEvent()
     InitAvailable();
     m_bReInitialize = false;
   }
-  else
-  {
-    time_t now;
-    time(&now);
-
-    if ((now - m_lastHotplugCheck) >= 10)
-    {
-      CheckHotplugged();
-      m_lastHotplugCheck = now;
-    }
-  }
-
   CSingleLock lock(m_devicesListLock);
 
   XBMC_Event event;
diff --git a/xbmc/input/linux/LinuxInputDevices.h b/xbmc/input/linux/LinuxInputDevices.h
index 4c84efa..44a05fe 100644
--- a/xbmc/input/linux/LinuxInputDevices.h
+++ b/xbmc/input/linux/LinuxInputDevices.h
@@ -28,6 +28,7 @@
 #include "threads/SingleLock.h"
 #include "input/touch/ITouchInputHandler.h"
 #include "input/touch/generic/IGenericTouchGestureDetector.h"
+#include "threads/Thread.h"
 
 struct KeymapEntry
 {
@@ -106,7 +107,18 @@ class CLinuxInputDevices
   bool CheckDevice(const char *device);
   std::vector<CLinuxInputDevice*> m_devices;
   bool m_bReInitialize;
-  time_t m_lastHotplugCheck;
+};
+
+class CLinuxInputDevicesCheckHotplugged : protected CThread
+{
+public:
+  CLinuxInputDevicesCheckHotplugged(CLinuxInputDevices &parent);
+  ~CLinuxInputDevicesCheckHotplugged();
+private:
+  CLinuxInputDevices &m_parent;
+  CEvent m_quitEvent;
+protected:
+  virtual void Process();
 };
 
 #endif /* LINUXINPUTDEVICES_H_ */
diff --git a/xbmc/windowing/WinEventsLinux.cpp b/xbmc/windowing/WinEventsLinux.cpp
index aaba119..a958a23 100644
--- a/xbmc/windowing/WinEventsLinux.cpp
+++ b/xbmc/windowing/WinEventsLinux.cpp
@@ -53,6 +53,7 @@ bool CWinEventsLinux::MessagePump()
   if (!m_initialized)
   {
     m_devices.InitAvailable();
+    m_checkHotplug = std::unique_ptr<CLinuxInputDevicesCheckHotplugged>(new CLinuxInputDevicesCheckHotplugged(m_devices));
     m_initialized = true;
   }
 
diff --git a/xbmc/windowing/WinEventsLinux.h b/xbmc/windowing/WinEventsLinux.h
index a17e987..1b1d2f2 100644
--- a/xbmc/windowing/WinEventsLinux.h
+++ b/xbmc/windowing/WinEventsLinux.h
@@ -22,6 +22,7 @@
 #define WINDOW_EVENTS_LINUX_H
 
 #pragma once
+#include <memory>
 #include "windowing/WinEvents.h"
 #include "input/linux/LinuxInputDevices.h"
 
@@ -43,6 +44,7 @@ class CWinEventsLinux : public IWinEvents
 private:
   static bool m_initialized;
   static CLinuxInputDevices m_devices;
+  std::unique_ptr<CLinuxInputDevicesCheckHotplugged> m_checkHotplug;
 };
 
 #endif
