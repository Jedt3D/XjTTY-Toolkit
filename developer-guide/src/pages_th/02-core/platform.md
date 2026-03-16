---
title: การตรวจจับแพลตฟอร์ม
description: XjPlatform module สำหรับตรวจหาระบบปฏิบัติการและสถาปัตยกรรมของเครื่อง
---

# การตรวจจับแพลตฟอร์ม (XjPlatform)

**XjPlatform** เป็น module ที่จัดให้มี API สำหรับตรวจหา platform, operating system, และ architecture ของเครื่องที่กำลังรันโปรแกรม สิ่งสำคัญคือการรู้ว่าโปรแกรมทำงานบนระบบใด เพื่อเลือกใช้ termios (Unix) หรือ Win32 API ให้ถูกต้อง

## API Reference

### ตรวจสอบระบบปฏิบัติการ

```xojo
Function IsWindows() As Boolean
```
คืนค่า `True` ถ้าโปรแกรมทำงานบน Windows

```xojo
Function IsMacOS() As Boolean
```
คืนค่า `True` ถ้าโปรแกรมทำงานบน macOS

```xojo
Function IsLinux() As Boolean
```
คืนค่า `True` ถ้าโปรแกรมทำงานบน Linux

```xojo
Function IsUnix() As Boolean
```
คืนค่า `True` ถ้าโปรแกรมทำงานบนระบบ Unix-like (macOS, Linux)

### ตรวจสอบสถาปัตยกรรม

```xojo
Function Is64Bit() As Boolean
```
คืนค่า `True` ถ้าแอปพลิเคชันถูก compile สำหรับ 64-bit architecture

```xojo
Function IsARM() As Boolean
```
คืนค่า `True` ถ้าโปรแกรมทำงานบน ARM architecture (เช่น Apple Silicon, Raspberry Pi)

### ดึงข้อมูล Platform

```xojo
Function OSName() As String
```
คืนชื่อของระบบปฏิบัติการ เช่น "Windows", "macOS", "Linux"

```xojo
Function Architecture() As String
```
คืนชื่อของ architecture เช่น "x86_64", "arm64"

```xojo
Function PlatformInfo() As String
```
คืนข้อมูล platform ที่สมบูรณ์เป็น string สำหรับ logging หรือ debug, เช่น "macOS 12.6 (arm64)"

## ตัวอย่างการใช้งาน

### ตรวจหาว่ากำลังทำงานบน Windows

```xojo
If XjPlatform.IsWindows() Then
  XjTerminal.Write("Running on Windows")
End If
```

### เลือก code path ตามแพลตฟอร์ม

```xojo
If XjPlatform.IsUnix() Then
  ' Use termios API
Else
  ' Use Win32 API
End If
```

### บันทึกข้อมูล Platform

```xojo
Var info As String = XjPlatform.PlatformInfo()
XjLogger.Info("Platform: " + info)
```

## หมายเหตุการออกแบบ

XjPlatform ใช้ Xojo's built-in platform constants และ introspection ภายใน ไม่มีการเรียก external command หรือ system API เพื่อให้ได้ข้อมูลทั่วไป ทำให้รวดเร็วและไม่มี overhead

สำหรับการตรวจหา platform ที่ละเอียดมากขึ้น (เช่น kernel version, CPU model) ใช้ XjCommand module เพื่อเรียก `uname` หรือ system command อื่นๆ
