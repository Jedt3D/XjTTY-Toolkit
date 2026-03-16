---
title: Event Loop
description: XjEventLoop class ช่วยปล่อยประเทศ terminal app event ทั้งหมด (keyboard, mouse, resize, tick)
---

# Event Loop (XjEventLoop)

**XjEventLoop** เป็น main application loop ที่จัดเก็บอักษรปัจจุบัน, mouse events, terminal resizes, และ timer ticks จากนั้นส่งเหตุการณ์ไปยังผู้จัดการแบบ callback สิ่งสำคัญคือ event loop จัดการ raw mode, alternate screen, mouse tracking, และ cleanup โดยอัตโนมัติ

## Constructor

```xojo
Sub New(refreshMs As Integer = 33)
```
สร้าง event loop ที่ tick ทุก refreshMs milliseconds (เริ่มต้น 33 = ~30 FPS)

## Main Loop

```xojo
Sub Run()
```
เริ่มต้น event loop — เปิด raw mode, เข้า alternate screen (ถ้า auto), poll events, เรียก handlers, repeat จนกว่า Stop_() ถูกเรียก

```xojo
Sub Stop_()
```
ออกจาก event loop — ปิด raw mode, ออก alternate screen (ถ้า auto), cleanup

```xojo
Function IsRunning() As Boolean
```
ตรวจสอบว่า loop กำลังรันอยู่

## Status

```xojo
Function TickCount() As UInt64
```
ดึงจำนวน ticks ตั้งแต่ loop เริ่มต้น

```xojo
Function ElapsedSeconds() As Double
```
ดึงเวลาผ่านไปเป็นวินาที

```xojo
Function LastWidth() As Integer
Function LastHeight() As Integer
```
ดึงขนาด terminal จากครั้งสุดท้ายที่ตรวจสอบ

## Handler Registration

```xojo
Sub SetOnKeyPress(handler As KeyPressHandler)
```
ตั้งค่า callback สำหรับ key event

```xojo
Sub SetOnResize(handler As ResizeHandler)
```
ตั้งค่า callback สำหรับ resize event

```xojo
Sub SetOnTick(handler As TickHandler)
```
ตั้งค่า callback สำหรับ tick event

```xojo
Sub SetOnMouse(handler As MouseHandler)
```
ตั้งค่า callback สำหรับ mouse event

## Auto-Management Properties

```xojo
Property AutoRawMode As Boolean
```
เปิด raw mode อัตโนมัติที่ Run() (ค่าเริ่มต้น True)

```xojo
Property AutoAlternateScreen As Boolean
```
เข้า/ออก alternate screen อัตโนมัติ (ค่าเริ่มต้น True)

```xojo
Property AutoHideCursor As Boolean
```
ซ่อนเคอร์เซอร์ขณะรัน (ค่าเริ่มต้น True)

## Delegate Signatures

```xojo
Delegate KeyPressHandler(key As XjKeyEvent) As Boolean
```
Callback สำหรับ key event คืน `True` เพื่อบอก handler ต่อไป, `False` เพื่อยกเลิก bubbling

```xojo
Delegate ResizeHandler(width As Integer, height As Integer) As Boolean
```
Callback สำหรับ resize event

```xojo
Delegate TickHandler(tickCount As UInt64) As Boolean
```
Callback สำหรับ timer tick

```xojo
Delegate MouseHandler(button As Integer, x As Integer, y As Integer, action As Integer) As Boolean
```
Callback สำหรับ mouse event

## ตัวอย่างการใช้งาน

### Event Loop พื้นฐาน

```xojo
Var loop As New XjEventLoop
loop.SetOnKeyPress(Function(key As XjKeyEvent) As Boolean
  If key.IsEscape() Then
    loop.Stop_()
  End If
  Return True
End Function)
loop.Run()
```

### ทั้ง Key, Mouse, Resize และ Tick

```xojo
Var loop As New XjEventLoop(16) ' ~60 FPS

loop.SetOnKeyPress(Function(key As XjKeyEvent) As Boolean
  XjTerminal.Write("Key: " + key.KeyName())
  Return True
End Function)

loop.SetOnMouse(Function(btn As Integer, x As Integer, y As Integer, action As Integer) As Boolean
  XjTerminal.Write("Click at " + x.ToString() + "," + y.ToString())
  Return True
End Function)

loop.SetOnResize(Function(w As Integer, h As Integer) As Boolean
  XjTerminal.Write("Resized to " + w.ToString() + "x" + h.ToString())
  Return True
End Function)

loop.SetOnTick(Function(tickCount As UInt64) As Boolean
  ' 60 times per second
  Return True
End Function)

loop.Run()
```

### ปิดการใช้งาน Auto-Management

```xojo
Var loop As New XjEventLoop
loop.AutoRawMode = False
loop.AutoAlternateScreen = False
' Manually manage mode
XjTerminal.EnableRawMode()
loop.Run()
XjTerminal.DisableRawMode()
```

### ตรวจสอบสถานะ Loop

```xojo
If loop.IsRunning() Then
  XjTerminal.Write("Elapsed: " + loop.ElapsedSeconds().ToString() + " seconds")
  XjTerminal.Write("Ticks: " + loop.TickCount().ToString())
End If
```

## หมายเหตุการออกแบบ

XjEventLoop ใช้ XjTerminal, XjCursor, XjScreen, XjReader ภายใน เพื่อจัดการ I/O ต่ำ level และ parsing

Event handler คืนค่า Boolean เพื่ออนุญาต event bubbling — คืน False เพื่อหยุด propagation ไปยัง handlers ถัดไป

AutoRawMode, AutoAlternateScreen, AutoHideCursor ลดการจัดการ boilerplate — ในกรณีส่วนใหญ่ ให้มันเปิดอยู่

สำหรับ app ที่ซับซ้อนมากขึ้น ลอง XjWidget และ XjFocusManager ซึ่ง wrap XjEventLoop และจัดการการส่งต่อ event ไปยัง widget hierarchy
