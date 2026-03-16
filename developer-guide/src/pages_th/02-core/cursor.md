---
title: เคอร์เซอร์
description: XjCursor module สำหรับการเคลื่อนไหว, การแสดง/ซ่อน และสถานะของเคอร์เซอร์
---

# เคอร์เซอร์ (XjCursor)

**XjCursor** เป็น module ที่จัดให้มี convenience functions สำหรับควบคุมเคอร์เซอร์ terminal แทนการต้องสร้าง ANSI escape code ด้วยตัวเอง เคอร์เซอร์คือตำแหน่งที่จะ emit ข้อความต่อไป สิ่งสำคัญคือการเคลื่อนย้ายเคอร์เซอร์ไปยังตำแหน่งที่ถูกต้องก่อนเขียน

## การเคลื่อนไหวเคอร์เซอร์

### เคลื่อนไปยังตำแหน่งสัมบูรณ์

```xojo
Sub MoveTo(row As Integer, col As Integer)
```
เลื่อนเคอร์เซอร์ไปยังตำแหน่ง (row, col) โดยใช้ 1-based indexing

```xojo
Sub MoveToColumn(col As Integer)
```
เลื่อนเคอร์เซอร์ไปยังคอลัมน์ที่ระบุ โดยคงบรรทัดปัจจุบัน

```xojo
Sub Home()
```
เลื่อนเคอร์เซอร์ไปที่ (1, 1) — จุดเริ่มต้นซ้ายบน

### เคลื่อนไปแบบสัมพัทธ์

```xojo
Sub MoveUp(n As Integer)
Sub MoveDown(n As Integer)
Sub MoveLeft(n As Integer)
Sub MoveRight(n As Integer)
```
เลื่อนเคอร์เซอร์ n ครั้งในทิศทางที่ระบุ

```xojo
Sub MoveRelative(deltaRow As Integer, deltaCol As Integer)
```
เลื่อนเคอร์เซอร์ตามจำนวน delta ที่ระบุ

### เคลื่อนไปยังบรรทัดอื่น

```xojo
Sub NextLine(n As Integer)
Sub PrevLine(n As Integer)
```
เลื่อนไปยังบรรทัดถัดไป/ก่อนหน้า n ครั้ง และชิดซ้าย (คอลัมน์ 1)

## การบันทึก & การคืนค่า

```xojo
Sub Save()
```
บันทึกตำแหน่งเคอร์เซอร์ปัจจุบัน (ไว้บนที่ stack ของ terminal)

```xojo
Sub Restore()
```
คืนค่าตำแหน่งเคอร์เซอร์ที่บันทึกไว้

## การแสดง & การซ่อน

```xojo
Sub Show()
```
ทำให้เคอร์เซอร์มองเห็นได้

```xojo
Sub Hide()
```
ซ่อนเคอร์เซอร์ (แต่ยังคงอยู่ที่ตำแหน่งเดิม)

## สถานะเคอร์เซอร์

```xojo
Function GetPosition(ByRef row As Integer, ByRef col As Integer) As Boolean
```
ส่งคำขอให้ terminal ส่งกลับตำแหน่งเคอร์เซอร์ปัจจุบัน บันทึกผลลัพธ์ใน row/col และคืน `True` ถ้าสำเร็จ (อาจไม่ได้ทำงานบน terminal บางตัว)

## ตัวอย่างการใช้งาน

### เลื่อนไปยังจุดใจกลาง

```xojo
XjCursor.MoveTo(10, 40)
XjTerminal.Write("Centered text")
```

### บันทึกตำแหน่งและเลื่อนกลับ

```xojo
XjCursor.Save()
XjCursor.MoveTo(1, 1)
XjTerminal.Write("Header")
XjCursor.Restore()
XjTerminal.Write("Back to saved position")
```

### เลื่อนไปยังช่องมุมขวา

```xojo
Var w, h As Integer
XjTerminal.GetSize(w, h)
XjCursor.MoveTo(h, w)
XjTerminal.Write("Corner")
```

### แสดง/ซ่อนเคอร์เซอร์

```xojo
XjCursor.Hide() ' ซ่อนขณะแสดงเนื้อหา
' Draw app
XjCursor.Show() ' แสดงเมื่อเสร็จ
```

### ขยับไปยังบรรทัดถัดไปและชิดซ้าย

```xojo
XjCursor.NextLine(1)
XjTerminal.Write("Next line, column 1")
```

## หมายเหตุการออกแบบ

XjCursor ใช้ XjANSI ภายใน ตัวอย่างเช่น `MoveTo(10, 40)` จะเรียก `XjANSI.CursorPosition(10, 40)` ปกติแล้วไม่ต้องกังวลกับรายละเอียดนี้

สำหรับแอป fullscreen ที่ต้องการควบคุมการวาดพิกเซลต่างๆ ลอง XjCanvas module ซึ่งจัดการเลื่อนเคอร์เซอร์โดยอัตโนมัติ
