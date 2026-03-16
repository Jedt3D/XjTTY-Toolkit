---
title: การควบคุม Terminal
description: XjTerminal module สำหรับการตั้งค่าโหมดดิบ, การอ่านไบต์, ขนาด terminal และอื่นๆ
---

# การควบคุม Terminal (XjTerminal)

**XjTerminal** เป็น module ที่จัดให้มี low-level API สำหรับควบคุม terminal ตั้งแต่ enable raw mode, อ่านไบต์โดยไม่บล็อก, ไปจนถึงได้รู้ขนาด terminal สิ่งสำคัญคือสำหรับ interactive app ต้องปิดการใช้งาน line buffering (cooked mode) และรับทราบว่า terminal มีขนาดเท่าไร

## โหมด Terminal

### Enable/Disable Raw Mode

```xojo
Sub EnableRawMode()
```
เปิด raw mode — ปิด line buffering, echo, และ signal handling เพื่อให้ app ได้รับแต่ละ keypress ทันที บน Unix ใช้ termios, บน Windows ใช้ SetConsoleMode

```xojo
Sub DisableRawMode()
```
ปิด raw mode — คืนค่า terminal กลับไปเป็นสถานะเดิม (cooked mode)

```xojo
Function IsRawMode() As Boolean
```
ส่งกลับ `True` ถ้า raw mode เปิดอยู่

## ข้อมูลขนาด Terminal

```xojo
Function Width() As Integer
```
ดึงความกว้างของ terminal (จำนวนคอลัมน์)

```xojo
Function Height() As Integer
```
ดึงความสูงของ terminal (จำนวนบรรทัด)

```xojo
Sub GetSize(ByRef w As Integer, ByRef h As Integer)
```
ดึงขนาด terminal ทั้งสองมิติพร้อมกัน (มีประสิทธิภาพกว่าเรียก Width/Height แยกกัน)

## การตรวจสอบสีและสมรรถนะ

```xojo
Function SupportsColor() As Boolean
```
ส่งกลับ `True` ถ้า terminal รองรับสี (ตรวจสอบ TERM environment variable)

```xojo
Function ColorDepth() As Integer
```
ส่งกลับจำนวนสีที่ terminal รองรับ: 1 (monochrome), 16 (basic), 256 (256-color), หรือ 16777216 (true color/24-bit RGB)

## การอ่านข้อมูล Input

```xojo
Function ReadByte() As Integer
```
อ่านไบต์เดียว (0-255) จาก stdin โดยไม่บล็อก ถ้าไม่มีข้อมูล คืน -1 (เฉพาะใน raw mode)

## การเขียนข้อมูล Output

```xojo
Sub Write(text As String)
```
เขียน text ไปยัง stdout ใช้สำหรับทั้ง plain text และ ANSI escape sequence

## Non-Blocking Input

```xojo
Sub EnableNonBlockingInput()
```
ตั้งค่า stdin เป็น non-blocking mode เพื่อให้ ReadByte() ไม่รอ

## Alternate Screen

```xojo
Sub EnterAlternateScreen()
```
เข้าไปยัง alternate screen buffer (ซ่อนบรรทัดเดิม) ใช้สำหรับแอป fullscreen เช่น vim

```xojo
Sub ExitAlternateScreen()
```
ออกจาก alternate screen buffer และคืนไปยัง main buffer

## Mouse Tracking

```xojo
Sub EnableMouseTracking()
```
เปิด mouse event reporting ให้ app ได้รับ click, drag, scroll

```xojo
Sub DisableMouseTracking()
```
ปิด mouse event reporting

## ตัวอย่างการใช้งาน

### ตั้งค่า Raw Mode และอ่าน Keypress

```xojo
XjTerminal.EnableRawMode()
Var byte As Integer = XjTerminal.ReadByte()
If byte > 0 Then
  XjTerminal.Write("Pressed: " + Chr(byte))
End If
XjTerminal.DisableRawMode()
```

### ดึงขนาด Terminal

```xojo
Var w, h As Integer
XjTerminal.GetSize(w, h)
XjTerminal.Write("Terminal is " + w.ToString() + "x" + h.ToString())
```

### ตรวจสอบสี

```xojo
If XjTerminal.SupportsColor() Then
  Var depth As Integer = XjTerminal.ColorDepth()
  If depth >= 256 Then
    ' Safe to use 256-color palette
  End If
End If
```

### Alternate Screen (Fullscreen App)

```xojo
XjTerminal.EnableRawMode()
XjTerminal.EnterAlternateScreen()
' Draw app
XjTerminal.ExitAlternateScreen()
XjTerminal.DisableRawMode()
```

## หมายเหตุการออกแบบ

XjTerminal สั่งการ platform-specific ผ่านทาง XjPlatform:
- บน Unix (macOS, Linux): ใช้ termios system call
- บน Windows: ใช้ Console API

แทนการเรียก XjTerminal โดยตรง เราแนะนำใช้ XjEventLoop ซึ่งจัดการ raw mode, alternate screen และ mouse tracking โดยอัตโนมัติ
