---
title: XjCell และ XjCanvas
description: XjCell สำหรับแต่ละอักขระที่มีสไตล์, XjCanvas สำหรับตารางอักขระ 2 มิติที่มี diff rendering
---

# XjCell และ XjCanvas

**XjCell** แทนอักขระเดียวพร้อมกับสไตล์ (FG/BG color, bold, italic, เป็นต้น) **XjCanvas** เป็นตารางอักขระ 2 มิติ (grid) ที่จัดเก็บ XjCell ทุกตัว สิ่งสำคัญคือการใช้ Canvas คุณสามารถเขียนไปยัง buffer ก่อน แล้วค่อย render กับ screen ทีหลัง แทนที่จะเขียนไปยัง terminal โดยตรง ซึ่งช่วยลดจำนวน I/O

## XjCell

### Constructor

```xojo
Sub New()
```
สร้าง cell ว่างเปล่า (space character, no style)

```xojo
Sub New(char As String, style As XjStyle)
```
สร้าง cell ที่มีอักขระและสไตล์

### Accessors

```xojo
Function Char() As String
Sub SetChar(c As String)
```
ดึง/ตั้งค่าอักขระ

```xojo
Function Style() As XjStyle
Sub SetStyle(s As XjStyle)
```
ดึง/ตั้งค่าสไตล์

### Batch Updates

```xojo
Sub Set(char As String, style As XjStyle)
```
ตั้งค่าอักขระและสไตล์พร้อมกัน

```xojo
Sub Reset()
```
รีเซ็ต cell กลับไปเป็นว่างเปล่า

### Comparison

```xojo
Function Equals(other As XjCell) As Boolean
```
เปรียบเทียบ cell ว่าเหมือนกันหรือไม่

```xojo
Function Clone() As XjCell
```
สร้าง copy ของ cell นี้

### Output

```xojo
Function Render() As String
```
ส่งกลับ ANSI sequence พร้อม text สำหรับ cell นี้

## XjCanvas

### Constructor & Sizing

```xojo
Sub New(width As Integer, height As Integer)
```
สร้าง canvas ขนาด width × height

```xojo
Function GetWidth() As Integer
Function GetHeight() As Integer
```
ดึงขนาด canvas

```xojo
Sub Resize(w As Integer, h As Integer)
```
เปลี่ยนขนาด canvas (clear content)

### Setting Cells

```xojo
Sub SetCell(x As Integer, y As Integer, char As String, style As XjStyle)
```
ตั้งค่าเซลล์ที่ (x, y) — ใช้ 1-based indexing

```xojo
Function GetCell(x As Integer, y As Integer) As XjCell
```
ดึงเซลล์ที่ (x, y)

```xojo
Sub SetChar(x As Integer, y As Integer, char As String)
```
ตั้งค่าเพียงอักขระที่ (x, y) โดยคงสไตล์เดิม

### Writing Text

```xojo
Sub WriteText(x As Integer, y As Integer, text As String, style As XjStyle)
```
เขียน text ตั้งแต่ (x, y) โดยใช้สไตล์เดียวกัน (ไม่ wrap)

```xojo
Sub WriteTextWrapped(x As Integer, y As Integer, maxWidth As Integer, text As String, style As XjStyle)
```
เขียน text โดยทำ word wrapping ที่ maxWidth

### Region Operations

```xojo
Sub Clear()
```
ล้าง canvas ทั้งหมด

```xojo
Sub ClearRegion(x As Integer, y As Integer, w As Integer, h As Integer)
```
ล้างพื้นที่สี่เหลี่ยม ขนาด w × h ตั้งแต่ (x, y)

```xojo
Sub FillRegion(x As Integer, y As Integer, w As Integer, h As Integer, char As String, style As XjStyle)
```
เติมพื้นที่สี่เหลี่ยมด้วยอักขระและสไตล์

### Drawing Boxes

```xojo
Sub DrawBox(x As Integer, y As Integer, w As Integer, h As Integer, style As XjStyle, borderStyle As Integer)
```
วาดกรอบสี่เหลี่ยม ขนาด w × h ตั้งแต่ (x, y)

borderStyle: 0 (single), 1 (double), 2 (round), 3 (bold), 4 (ascii)

### Lines

```xojo
Sub DrawHLine(x As Integer, y As Integer, length As Integer, style As XjStyle)
Sub DrawVLine(x As Integer, y As Integer, length As Integer, style As XjStyle)
```
วาดเส้นแนวนอน/ตั้ง

### Advanced Operations

```xojo
Sub Blit(source As XjCanvas, srcX As Integer, srcY As Integer, srcW As Integer, srcH As Integer, dstX As Integer, dstY As Integer)
```
คัดลอกพื้นที่สี่เหลี่ยมจาก canvas อื่น

```xojo
Function Snapshot() As XjCanvas
```
สร้าง deep copy ของ canvas นี้

### Rendering

```xojo
Function Render() As String
```
ส่งกลับ full ANSI render (clear screen + home + all cells)

```xojo
Function DiffRender(previous As XjCanvas) As String
```
ส่งกลับ diff render เทียบกับ canvas ก่อนหน้า (ประสิทธิภาพ)

```xojo
Function ToString() As String
```
ส่งกลับ plain text (ไม่มี ANSI code) สำหรับ logging/debug

## ตัวอย่างการใช้งาน

### สร้าง Cell

```xojo
Var errorStyle As XjStyle = XjStyle.Danger()
Var cell As New XjCell("E", errorStyle)
XjTerminal.Write(cell.Render())
```

### สร้าง Canvas และวาด

```xojo
Var canvas As New XjCanvas(80, 24)
Var headerStyle As XjStyle = XjStyle.MakeBold()
canvas.WriteText(1, 1, "Welcome", headerStyle)
canvas.DrawBox(2, 3, 30, 10, XjStyle.Default_(), 0)
XjTerminal.Write(canvas.Render())
```

### Diff Rendering (Performance)

```xojo
Var prev As XjCanvas = canvas.Snapshot()
' Modify canvas
canvas.SetChar(10, 5, "X")
' Only write changed cells
XjTerminal.Write(canvas.DiffRender(prev))
```

### Word Wrapping Text

```xojo
Var canvas As New XjCanvas(40, 10)
Var longText As String = "This is a very long line that should wrap at the specified width"
canvas.WriteTextWrapped(1, 1, 35, longText, XjStyle.Default_())
XjTerminal.Write(canvas.Render())
```

### หลายกรอบ

```xojo
Var canvas As New XjCanvas(50, 20)
Var boxStyle As XjStyle = XjStyle.MakeFGRGB(0, 255, 0)
canvas.DrawBox(1, 1, 20, 8, boxStyle, 0)
canvas.DrawBox(22, 1, 20, 8, boxStyle, 1)
canvas.DrawBox(43, 1, 7, 8, boxStyle, 2)
XjTerminal.Write(canvas.Render())
```

## หมายเหตุการออกแบบ

Canvas ใช้ 1-based indexing (row 1, col 1) เพื่อให้สอดคล้องกับ Terminal และ Cursor modules

DiffRender เป็น optimization — ถ้าแต่ละ frame ต้อง render frame ทั้งหมด ลอง Render() เพียง แต่ถ้า update frame ทีละส่วนเล็กน้อย DiffRender จะเร็วมาก

XjEventLoop ใช้ Canvas ภายในสำหรับการจัดการการ render อย่างมีประสิทธิภาพ
