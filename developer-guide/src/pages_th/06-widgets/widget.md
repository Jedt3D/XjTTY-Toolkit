---
title: Widget Base Class
description: XjWidget class base สำหรับสร้าง reusable UI component ในลำดับชั้น widget
---

# Widget Base Class (XjWidget)

**XjWidget** เป็น abstract base class สำหรับ UI components — text, buttons, inputs, tables, ฯลฯ Widget แต่ละอันมี XjLayoutNode, style, และ handler methods สำหรับ painting และ keyboard handling สิ่งสำคัญคือ widget hierarchies มีความคล้ายคลึง DOM — parent contains children, Paint() recurse, event routing

## Constructor

```xojo
Sub New()
```
สร้าง widget ว่างเปล่า

## Layout

```xojo
Function LayoutNode() As XjLayoutNode
```
ดึง layout node ของ widget นี้

```xojo
Sub SetWidth(constraint As XjConstraint)
Sub SetHeight(constraint As XjConstraint)
Sub SetBorder(style As Integer, color As String)
Sub SetPadding(top As Integer, right As Integer, bottom As Integer, left As Integer)
Sub SetMargin(top As Integer, right As Integer, bottom As Integer, left As Integer)
Sub SetTitle(title As String)
Sub SetName(name As String)
Sub SetDirection(dir As Integer)
```
ตั้งค่าคุณสมบัติของ layout

## Children

```xojo
Sub AddChild(child As XjWidget)
Function ChildCount() As Integer
Function Child(index As Integer) As XjWidget
Function Parent() As XjWidget
```
จัดการชั้น widget hierarchy

## State

```xojo
Function Name() As String
Sub SetStyle(style As XjStyle)
Function Style() As XjStyle
Function IsVisible() As Boolean
Sub SetVisible(visible As Boolean)
Function IsFocusable() As Boolean
Function IsFocused() As Boolean
Sub SetFocused(focused As Boolean)
Sub MarkDirty()
Function IsDirty() As Boolean
```
ดึง/ตั้งค่า state ของ widget

## Template Methods (Override สำหรับ custom widgets)

```xojo
Sub Paint(canvas As XjCanvas)
```
Paint widget นี้และ children ทั้งหมด (template method) — template นี้เรียก PaintContent() หลังจาก PaintBorder

```xojo
Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer, w As Integer, h As Integer)
```
Override สำหรับ paint content เฉพาะของ widget — rectangle (x, y, w, h) คือ inner content area

```xojo
Function HandleKey(key As XjKeyEvent) As Boolean
```
Override สำหรับ handle keyboard input — คืน True ถ้า widget consume event

```xojo
Sub HandleTick(tickCount As UInt64)
```
Override สำหรับ handle timer tick (สำหรับ animation)

## Tree Navigation

```xojo
Function FindByName(name As String) As XjWidget
```
ค้นหา widget (recursive) โดยชื่อ

```xojo
Sub CollectFocusable(into As List)
```
รวบรวมทั้งหมด focusable widget ในลำดับชั้นใน list

## ตัวอย่างการใช้งาน

### สร้าง Custom Widget

```xojo
Class MyCustomWidget Extends XjWidget
  Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer, w As Integer, h As Integer)
    canvas.WriteText(x, y, "Custom content", Me.Style())
  End Sub

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsEscape() Then
      Return True ' Consume
    End If
    Return False ' Not consumed
  End Function
End Class
```

### สร้าง Hierarchy

```xojo
Var root As New XjBox
root.SetWidth(XjConstraint.Auto())
root.SetHeight(XjConstraint.Auto())

Var header As New XjText
header.SetText("My App")
header.SetHeight(XjConstraint.Fixed(1))

Var content As New XjText
content.SetText("Hello, world!")

root.AddChild(header)
root.AddChild(content)

Var canvas As New XjCanvas(80, 24)
root.Paint(canvas)
```

### Focus Management

```xojo
Var widget As XjWidget = ' ... find widget
If widget.IsFocusable() Then
  widget.SetFocused(True)
End If
```

### Collect Focusable Widgets

```xojo
Var focusable As New List
root.CollectFocusable(focusable)
For i As Integer = 0 To focusable.Count - 1
  Var w As XjWidget = focusable.Item(i)
  ' Tab through widgets
Wend
```

## หมายเหตุการออกแบบ

Widget ทั้งหมด subclass XjWidget และ override PaintContent/HandleKey/HandleTick ตามต้องการ

Widget ทำงานกับ XjLayoutNode ภายใน — Paint() ไม่ต้อง compute layout จาก scratch แต่ใช้ ComputedX/Y/Width/Height ที่คำนวณโดย XjLayoutSolver ก่อนหน้านี้

ต้องทำการ Paint() ใหม่ใน main loop ปกติหลังจาก HandleKey() หรือ HandleTick() เพราะ widget อาจเปลี่ยนแปลงสถานะ

XjFocusManager ใช้ CollectFocusable() และ HandleKey() เพื่อ route keyboard input ไปยัง focused widget
