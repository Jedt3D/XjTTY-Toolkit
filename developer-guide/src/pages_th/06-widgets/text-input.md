---
title: TextInput
description: XjTextInput widget สำหรับการป้อนข้อความบรรทัดเดียว
---

# TextInput (XjTextInput)

**XjTextInput** เป็น input widget สำหรับเก็บข้อความบรรทัดเดียว รองรับ cursor editing (arrows, backspace, delete), password mask, validation, และ label

## Constructor

```xojo
Sub New()
```
สร้าง text input widget ว่างเปล่า

## Content & Value

```xojo
Sub SetValue(value As String)
Function Value() As String
```
ตั้ง/ดึงค่า input (text ที่ผู้ใช้พิมพ์)

## Placeholder

```xojo
Sub SetPlaceholder(placeholder As String)
Function Placeholder() As String
```
ตั้ง/ดึง placeholder text (แสดงเมื่อ value ว่างเปล่า)

```xojo
Sub SetPlaceholderStyle(style As XjStyle)
Function PlaceholderStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ placeholder

## Password Masking

```xojo
Sub SetMask(maskChar As String)
Function Mask() As String
```
ตั้ง/ดึง mask character — ถ้ากำหนด ทั้ง value ถูก render เป็น mask char แทน (เช่น "*" สำหรับ password)

## Constraints

```xojo
Sub SetMaxLength(maxLength As Integer)
Function MaxLength() As Integer
```
ตั้ง/ดึง max length ที่ input ยอมรับ (0 = unlimited)

## Label

```xojo
Sub SetLabel(label As String, style As XjStyle)
Function Label() As String
Function LabelStyle() As XjStyle
```
ตั้ง/ดึง label และ style (label แสดงก่อน input)

## Styling

```xojo
Sub SetCursorStyle(style As XjStyle)
Function CursorStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับเคอร์เซอร์

## Keyboard Shortcuts

TextInput รองรับ shortcuts เหล่านี้:

| Shortcut | การทำงาน |
|----------|---------|
| Ctrl+A | ไปจุดเริ่มต้น text |
| Ctrl+E | ไปส่วนท้าย text |
| Ctrl+K | ลบจากเคอร์เซอร์ถึงส่วนท้าย |
| Ctrl+U | ลบทั้งหมด |
| ← / → | ขยับเคอร์เซอร์ |
| Backspace | ลบอักขระก่อนหน้า |
| Delete | ลบอักขระปัจจุบัน |
| Home / End | ไปจุดเริ่มต้น/ส่วนท้าย |

## ตัวอย่างการใช้งาน

### Input พื้นฐาน

```xojo
Var input As New XjTextInput
input.SetValue("John")
input.SetPlaceholder("Enter name")
input.SetWidth(XjConstraint.Fixed(30))
```

### Password Input

```xojo
Var password As New XjTextInput
password.SetMask("*")
password.SetPlaceholder("Password")
password.SetLabel("Password:", XjStyle.Default_())
```

### Input พร้อม Label

```xojo
Var email As New XjTextInput
email.SetLabel("Email:", XjStyle.MakeBold())
email.SetValue("user@example.com")
email.SetWidth(XjConstraint.Fixed(40))
```

### Input พร้อม Max Length

```xojo
Var code As New XjTextInput
code.SetMaxLength(6)
code.SetPlaceholder("000000")
```

### ตรวจสอบค่า

```xojo
Var input As New XjTextInput
input.SetValue("hello")
If input.Value().Length > 0 Then
  XjTerminal.Write("Input: " + input.Value())
End If
```

## หมายเหตุการออกแบบ

XjTextInput ใช้ XjReader ภายในเพื่อจัดการ keyboard input และ cursor position

Mask ส่งผลต่อการแสดงเท่านั้น — Value() ยังคงส่งคืน unmasked text

MaxLength ป้องกันผู้ใช้พิมพ์เกิน — เมื่อ reach limit, key press ถูก ignore

Label แสดงตัวอักษรไม่ใช่ part ของ value — ใช้สำหรับ context เท่านั้น

XjAskPrompt มี wrapper สำหรับ XjTextInput ที่มี validation และ prompt-style handling
