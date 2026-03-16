---
title: Layout Node
description: XjLayoutNode class แทน node ของ flexbox-like layout tree
---

# Layout Node (XjLayoutNode)

**XjLayoutNode** แทน node ของ layout tree — มี constraints, padding, margin, border, และ children XjLayoutNode มีลักษณะคล้ายกับ flexbox — children จัดเรียงอยู่ในแถวหรือคอลัมน์ แต่ละขยายตามขนาด constraint ของตัวเอง

## Direction Constants

```xojo
Const DIR_ROW = 0      ' Children จัดเรียงตามแนวนอน
Const DIR_COLUMN = 1   ' Children จัดเรียงตามแนวตั้ง
```

## Constructor

```xojo
Sub New()
```
สร้าง layout node ว่างเปล่า

## Setting Layout Properties

### Direction

```xojo
Sub SetDirection(dir As Integer)
Function Direction() As Integer
```
ตั้ง/ดึง direction (ROW หรือ COLUMN)

### Size Constraints

```xojo
Sub SetWidth(constraint As XjConstraint)
Sub SetHeight(constraint As XjConstraint)
Function WidthConstraint() As XjConstraint
Function HeightConstraint() As XjConstraint
```
ตั้ง/ดึง width/height constraint

### Spacing

```xojo
Sub SetPadding(top As Integer, right As Integer, bottom As Integer, left As Integer)
Function PaddingTop() As Integer
Function PaddingRight() As Integer
Function PaddingBottom() As Integer
Function PaddingLeft() As Integer
```
ตั้ง/ดึง padding (space ภายในขอบ)

```xojo
Sub SetMargin(top As Integer, right As Integer, bottom As Integer, left As Integer)
Function MarginTop() As Integer
Function MarginRight() As Integer
Function MarginBottom() As Integer
Function MarginLeft() As Integer
```
ตั้ง/ดึง margin (space นอกขอบ)

### Border

```xojo
Sub SetBorder(style As Integer, color As String)
Function BorderStyleValue() As Integer
Function BorderColor() As String
```
ตั้ง/ดึง border style (0=none, 1=single, 2=double, 3=round, 4=bold, 5=ascii) และสี

### Metadata

```xojo
Sub SetName(name As String)
Sub SetTitle(title As String)
Function Name() As String
Function Title() As String
```
ตั้ง/ดึง name (สำหรับ lookup) และ title (สำหรับแสดงข้อความ)

## Children Management

```xojo
Sub AddChild(child As XjLayoutNode)
Function ChildCount() As Integer
Function Child(index As Integer) As XjLayoutNode
```
เพิ่ม/ดึง child nodes

```xojo
Function Parent() As XjLayoutNode
```
ดึง parent node (หรือ Nil)

## Computed Layout

```xojo
Function ComputedX() As Integer
Function ComputedY() As Integer
Function ComputedWidth() As Integer
Function ComputedHeight() As Integer
```
ดึงขนาดและตำแหน่ง computed หลังจาก solve (read-only หลังจาก XjLayoutSolver.Solve)

```xojo
Function ContentX() As Integer
Function ContentY() As Integer
Function ContentWidth() As Integer
Function ContentHeight() As Integer
```
ดึง computed size ของพื้นที่ content (ลบ padding/border)

## Rendering

```xojo
Sub PaintSelf(canvas As XjCanvas)
```
วาดเฉพาะ border/title ของ node นี้ (ไม่ paint children)

```xojo
Sub PaintTo(canvas As XjCanvas)
```
วาด node นี้รวมถึง border/title และ children recursively

## Tree Navigation

```xojo
Function FindByName(name As String) As XjLayoutNode
```
ค้นหา child (recursive) โดยชื่อ

## Dirty Flag

```xojo
Sub MarkDirty()
Function IsDirty() As Boolean
```
ตั้ง/ดึง dirty flag (เพื่อบอก layout solver ต้องคำนวณใหม่)

## ตัวอย่างการใช้งาน

### สร้าง Layout Tree

```xojo
Var root As New XjLayoutNode
root.SetDirection(XjLayoutNode.DIR_COLUMN)
root.SetWidth(XjConstraint.Auto())
root.SetHeight(XjConstraint.Auto())

Var header As New XjLayoutNode
header.SetHeight(XjConstraint.Fixed(3))
header.SetTitle("Header")

Var body As New XjLayoutNode
body.SetHeight(XjConstraint.Percent(80))
body.SetTitle("Content")

root.AddChild(header)
root.AddChild(body)
```

### ตั้งค่า Border

```xojo
Var node As New XjLayoutNode
node.SetBorder(XjLayoutNode.BORDER_SINGLE, "blue")
node.SetPadding(1, 2, 1, 2)
```

### ค้นหา Node

```xojo
Var content As XjLayoutNode = root.FindByName("content")
If content <> Nil Then
  content.SetTitle("Found!")
End If
```

### ตั้งค่า Margins & Padding

```xojo
Var box As New XjLayoutNode
box.SetMargin(2, 2, 2, 2)   ' 2 space นอกตัว
box.SetPadding(1, 1, 1, 1)  ' 1 space ภายในตัว
```

## หมายเหตุการออกแบบ

XjLayoutNode เป็น tree structure — ไม่มี dependencies ระหว่าง nodes คำนวณขนาด/ตำแหน่งสุดท้ายปล่อยให้ XjLayoutSolver

Computed layout (ComputedX/Y/Width/Height) set-only โดย XjLayoutSolver.Solve() — อ่าน-only ก่อน solve ต้องเรียก Solve() เสียก่อน

XjWidget wrap XjLayoutNode และเพิ่ม Paint/HandleKey/HandleTick methods บน layout tree นี้
