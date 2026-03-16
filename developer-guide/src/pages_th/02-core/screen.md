---
title: หน้าจอ
description: XjScreen module สำหรับการล้างหน้าจอ, การเลื่อน, และการวาดพื้นฐาน
---

# หน้าจอ (XjScreen)

**XjScreen** เป็น module ที่จัดให้มี operations สำหรับการจัดการหน้าจอ terminal เช่น clearing, scrolling, และการวาดรูปทรงพื้นฐาน สิ่งสำคัญคือเราต้องล้างหน้าจอในตำแหน่งที่ถูกต้องเพื่อให้ UI ไม่มีสิ่งปนเปื้อน

## การล้างหน้าจอ

```xojo
Sub Clear()
```
ล้างหน้าจอทั้งหมด และเลื่อนเคอร์เซอร์ไปที่ (1, 1)

```xojo
Sub ClearLine()
```
ล้างบรรทัดปัจจุบันทั้งหมด (เคอร์เซอร์ยังคงอยู่ในบรรทัดเดิม)

```xojo
Sub ClearToEnd()
```
ล้างจากเคอร์เซอร์ถึงส่วนท้ายของบรรทัด

```xojo
Sub ClearToStart()
```
ล้างจากจุดเริ่มต้นของบรรทัดถึงเคอร์เซอร์

```xojo
Sub ClearBelow()
```
ล้างจากเคอร์เซอร์ถึงส่วนท้ายของหน้าจอ

```xojo
Sub ClearAbove()
```
ล้างจากจุดเริ่มต้นของหน้าจอถึงเคอร์เซอร์

```xojo
Sub ClearLines(count As Integer)
```
ล้างจำนวน count บรรทัด (จากตำแหน่งเคอร์เซอร์ไปยังด้านล่าง)

## การเลื่อนหน้าจอ

```xojo
Sub ScrollUp(n As Integer)
Sub ScrollDown(n As Integer)
```
เลื่อนหน้าจอขึ้น/ลง n บรรทัด

## ข้อมูลขนาด

```xojo
Function Width() As Integer
Function Height() As Integer
```
ดึงความกว้างและความสูงของ terminal (คำสั่ง wrapper บน XjTerminal)

## ตั้งชื่อ Window

```xojo
Sub SetTitle(title As String)
```
ตั้งชื่อของ terminal window/tab (ทำงานบน terminal ส่วนใหญ่)

## Fullscreen Mode

```xojo
Sub EnterFullscreen()
```
เข้าไปยัง fullscreen mode (alternate screen buffer) ซ่อนบรรทัดเดิม

```xojo
Sub ExitFullscreen()
```
ออกจาก fullscreen mode และคืนไปยังบรรทัดเดิม

## การวาด Text

```xojo
Sub WriteAt(row As Integer, col As Integer, text As String)
```
เขียน text ที่ตำแหน่ง (row, col) โดยอัตโนมัติเลื่อนเคอร์เซอร์ไปยังจุดนั้น

## การวาดรูปทรง

### เส้น

```xojo
Sub DrawHorizontalLine(row As Integer, col As Integer, length As Integer, char As String)
```
วาดเส้นแนวนอน ความยาว length ตั้งแต่ (row, col) โดยใช้ตัวอักษร char

```xojo
Sub DrawVerticalLine(row As Integer, col As Integer, length As Integer, char As String)
```
วาดเส้นแนวตั้ง ความยาว length ตั้งแต่ (row, col)

### สี่เหลี่ยม

```xojo
Sub FillRect(row As Integer, col As Integer, width As Integer, height As Integer, char As String)
```
เติมสี่เหลี่ยม ขนาด width × height ตั้งแต่ (row, col) โดยใช้ตัวอักษร char

## ตัวอย่างการใช้งาน

### ล้างหน้าจอและเลื่อนไปเริ่มต้น

```xojo
XjScreen.Clear()
XjTerminal.Write("Welcome to XjTTY-Toolkit")
```

### ตั้งชื่อ Window

```xojo
XjScreen.SetTitle("My Terminal App")
```

### วาดเส้นแบ่ง

```xojo
Var w As Integer = XjScreen.Width()
XjScreen.DrawHorizontalLine(5, 1, w, "-")
```

### Fullscreen Mode

```xojo
XjScreen.EnterFullscreen()
' Draw fullscreen content
XjScreen.ExitFullscreen()
```

### เขียนที่หลายตำแหน่ง

```xojo
XjScreen.WriteAt(1, 1, "Title")
XjScreen.WriteAt(3, 1, "Content")
XjScreen.WriteAt(10, 1, "Footer")
```

### เติมพื้นที่

```xojo
' Clear and fill background
XjScreen.ClearBelow()
XjScreen.FillRect(10, 1, 20, 5, " ")
```

## หมายเหตุการออกแบบ

XjScreen ใช้ XjCursor และ XjANSI ภายใน สำหรับแอป TUI ที่ซับซ้อน ลอง XjCanvas module แทน ซึ่งจัดการการอัปเดตและ diff rendering โดยอัตโนมัติ

Fullscreen mode ควรใช้งาน XjEventLoop `AutoAlternateScreen` property แทนการเรียก EnterFullscreen/ExitFullscreen โดยตรง เพื่อให้ cleanup ถูกต้องแม้เมื่อ app ขัดข้อง
