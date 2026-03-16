---
title: Box และ Text
description: XjBox (container) และ XjText (display) widget
---

# Box และ Text

## XjBox (Container Widget)

**XjBox** เป็น container widget — ประกอบด้วย padding, border, background fill, และ content alignment จะมีประโยชน์สำหรับจัดกลุ่มไปว์เจต

### Constructor

```xojo
Sub New()
```
สร้าง box ว่างเปล่า

### Content Alignment

```xojo
Sub SetContentAlign(align As Integer)
Function ContentAlign() As Integer
```
ตั้ง/ดึง horizontal alignment: ALIGN_LEFT (0), ALIGN_CENTER (1), ALIGN_RIGHT (2)

```xojo
Sub SetContentVAlign(valign As Integer)
Function ContentVAlign() As Integer
```
ตั้ง/ดึง vertical alignment: VALIGN_TOP (0), VALIGN_MIDDLE (1), VALIGN_BOTTOM (2)

### Background Fill

```xojo
Sub SetFill(char As String, style As XjStyle)
```
ตั้งค่า character และ style สำหรับเติม background

### Semantic Constructors

```xojo
Shared Function Info(title As String) As XjBox
Shared Function Warning(title As String) As XjBox
Shared Function Success(title As String) As XjBox
Shared Function Error_(title As String) As XjBox
```
สร้าง box ที่มีชื่อเรื่องและสี semantic (blue, yellow, green, red)

## XjText (Display Widget)

**XjText** เป็น display widget สำหรับแสดง text ธรรมดา รองรับ word wrapping, alignment, scroll

### Constructor

```xojo
Sub New()
```
สร้าง text widget ว่างเปล่า

### Content

```xojo
Sub SetText(text As String)
Function Text() As String
```
ตั้ง/ดึง text content

### Formatting

```xojo
Sub SetAlign(align As Integer)
Function Align() As Integer
```
ตั้ง/ดึง alignment: ALIGN_LEFT (0), ALIGN_CENTER (1), ALIGN_RIGHT (2)

```xojo
Sub SetWrap(wrap As Boolean)
Function Wrap() As Boolean
```
เปิด/ปิด word wrapping

### Scrolling

```xojo
Sub SetScrollOffset(offset As Integer)
Function ScrollOffset() As Integer
```
ตั้ง/ดึง offset scroll บรรทัด

```xojo
Function LineCount() As Integer
```
ดึงจำนวนบรรทัดที่ render (สำหรับการคำนวณ max scroll)

## ตัวอย่างการใช้งาน

### XjBox Container

```xojo
Var panel As New XjBox
panel.SetWidth(XjConstraint.Fixed(40))
panel.SetHeight(XjConstraint.Fixed(10))
panel.SetBorder(0, "blue") ' single border, blue
panel.SetPadding(1, 2, 1, 2)
panel.SetTitle("Options")

Var text As New XjText
text.SetText("Choose one:")
panel.AddChild(text)
```

### XjBox Semantic

```xojo
Var error As XjBox = XjBox.Error_("Critical Error")
error.SetWidth(XjConstraint.Percent(100))
error.SetHeight(XjConstraint.Fixed(5))
```

### XjText Centered

```xojo
Var heading As New XjText
heading.SetText("Welcome")
heading.SetAlign(XjBox.ALIGN_CENTER)
heading.SetStyle(XjStyle.MakeBold())
```

### XjText Word Wrapped

```xojo
Var desc As New XjText
desc.SetText("This is a long description that will be wrapped to fit within the available width")
desc.SetWrap(True)
desc.SetWidth(XjConstraint.Fixed(30))
```

### Scrollable Text

```xojo
Var scroll As New XjText
scroll.SetText("Line 1\nLine 2\nLine 3\nLine 4\nLine 5")
scroll.SetHeight(XjConstraint.Fixed(3))
scroll.SetScrollOffset(0)
' Scroll down
scroll.SetScrollOffset(1)
```

## Alignment Constants

```xojo
Const ALIGN_LEFT = 0
Const ALIGN_CENTER = 1
Const ALIGN_RIGHT = 2
Const VALIGN_TOP = 0
Const VALIGN_MIDDLE = 1
Const VALIGN_BOTTOM = 2
```

## หมายเหตุการออกแบบ

XjBox ส่วนใหญ่ใช้สำหรับ layout — เก็บ children widget ภายในและจัดตำแหน่ง ส่วน XjText ใช้สำหรับแสดงข้อความเท่านั้น (ไม่มี children)

SetFill() ของ XjBox มีประโยชน์สำหรับสร้างพื้นหลังที่มีสี — ถ้าไม่มีการตั้งค่า ก็ปล่อยเป็นสีเริ่มต้นของ terminal

XjText.LineCount() ใช้ calculate scroll range — ถ้าได้ 5 บรรทัด height 3, max scroll = 2
