---
title: Table
description: XjTable widget สำหรับแสดงตารางข้อมูลพร้อม headers, alignment, styling
---

# Table (XjTable)

**XjTable** เป็น widget สำหรับแสดง tabular data — headers, rows, columns พร้อมการ control การ width, alignment, border, styling รองรับ auto-width, fixed-width, และ alternating row colors

## Constructor

```xojo
Sub New()
```
สร้าง table widget ว่างเปล่า

## Headers

```xojo
Sub SetHeaders(headers() As String)
Function Headers() As String()
```
ตั้ง/ดึง column headers

## Rows

```xojo
Sub AddRow(cells() As String)
Function RowCount() As Integer
```
เพิ่ม row หนึ่ง / ดึงจำนวน rows

```xojo
Sub ClearRows()
```
ล้างทั้งหมด rows

## Column Sizing

```xojo
Sub SetColumnWidth(col As Integer, width As Integer)
Function ColumnWidth(col As Integer) As Integer
```
ตั้ง/ดึง fixed width สำหรับ column (0 = auto)

## Column Alignment

```xojo
Sub SetColumnAlign(col As Integer, align As Integer)
Function ColumnAlign(col As Integer) As Integer
```
ตั้ง/ดึง alignment: ALIGN_LEFT (0), ALIGN_CENTER (1), ALIGN_RIGHT (2)

## Display Options

```xojo
Sub SetShowHeader(show As Boolean)
Function ShowHeader() As Boolean
```
ตั้ง/ดึง visibility ของ header row

```xojo
Sub SetShowBorder(show As Boolean)
Function ShowBorder() As Boolean
```
ตั้ง/ดึง visibility ของ border

## Border Characters

```xojo
Sub SetBorderChars(style As Integer)
```
ตั้ง border character style: 0=single, 1=double, 2=round, 3=bold, 4=ascii

## Styling

```xojo
Sub SetHeaderStyle(style As XjStyle)
Function HeaderStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ header cells

```xojo
Sub SetCellStyle(style As XjStyle)
Function CellStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ regular cells

```xojo
Sub SetAltRowStyle(style As XjStyle)
Function AltRowStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ alternate rows (odd rows)

## Alignment Constants

```xojo
Const ALIGN_LEFT = 0
Const ALIGN_CENTER = 1
Const ALIGN_RIGHT = 2
```

## ตัวอย่างการใช้งาน

### Table พื้นฐาน

```xojo
Var table As New XjTable
table.SetHeaders(Array("Name", "Age", "City"))
table.AddRow(Array("Alice", "30", "NYC"))
table.AddRow(Array("Bob", "25", "LA"))
table.AddRow(Array("Charlie", "35", "Chicago"))
table.SetWidth(XjConstraint.Percent(100))
table.SetHeight(XjConstraint.Auto())
```

### Table พร้อม Fixed Widths

```xojo
Var table As New XjTable
table.SetHeaders(Array("ID", "Status", "Message"))
table.SetColumnWidth(0, 5)   ' ID = 5 chars
table.SetColumnWidth(1, 10)  ' Status = 10 chars
table.SetColumnWidth(2, 40)  ' Message = 40 chars
table.AddRow(Array("1", "OK", "All good"))
```

### Table พร้อม Styling

```xojo
Var table As New XjTable
table.SetHeaders(Array("Product", "Price"))
table.SetHeaderStyle(XjStyle.MakeBold())
table.SetCellStyle(XjStyle.Default_())
table.SetAltRowStyle(XjStyle.Muted())
table.SetShowBorder(True)
table.SetBorderChars(0) ' single border
table.AddRow(Array("Widget", "$10"))
table.AddRow(Array("Gadget", "$20"))
```

### Table Right-Aligned Numbers

```xojo
Var table As New XjTable
table.SetHeaders(Array("Item", "Price", "Qty", "Total"))
table.SetColumnAlign(1, ALIGN_RIGHT) ' Price right
table.SetColumnAlign(2, ALIGN_CENTER) ' Qty center
table.SetColumnAlign(3, ALIGN_RIGHT) ' Total right
table.AddRow(Array("Apple", "1.50", "2", "3.00"))
table.AddRow(Array("Orange", "2.00", "3", "6.00"))
```

### Dynamic Table

```xojo
Var table As New XjTable
table.SetHeaders(Array("Index", "Value"))

For i As Integer = 1 To 10
  table.AddRow(Array(i.ToString(), "Value " + i.ToString()))
Wend

' Later, clear and reload
table.ClearRows()
For i As Integer = 11 To 20
  table.AddRow(Array(i.ToString(), "Value " + i.ToString()))
Wend
```

## หมายเหตุการออกแบบ

XjTable จัดเก็บ headers และ rows เป็น array ของ string — เก็บข้อมูลธรรมชาติ ไม่มี widget ภายใน cell

SetColumnWidth(0) แปลว่า auto-width — table คำนวณความกว้างตามเนื้อหา

SetShowBorder(False) เหลือแต่ content, SetShowHeader(False) ล้าง headers

XjTable ใช้สำหรับแสดงเท่านั้น — ถ้าต้อง interactive (selection, editing) wrap ในลอง XjSelectPrompt หรือสร้าง custom widget
