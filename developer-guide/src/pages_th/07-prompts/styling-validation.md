---
title: การจัดรูปแบบและ Validation
description: XjPromptStyle สำหรับจัดรูปแบบ prompt, XjValidation สำหรับ validate input, XjConversion สำหรับ modify input
---

# การจัดรูปแบบและ Validation

## XjPromptStyle

ตั้งค่า global style สำหรับทั้ง prompt elements

### Properties

```xojo
Property PrefixStyle As XjStyle
```
Style สำหรับ prefix (ตัวอักษรข้างหน้า question เช่น "?")

```xojo
Property QuestionStyle As XjStyle
```
Style สำหรับ question text

```xojo
Property AnswerStyle As XjStyle
```
Style สำหรับ answer/input text

```xojo
Property HelpStyle As XjStyle
```
Style สำหรับ help text (suggestions, alternatives)

```xojo
Property ErrorStyle As XjStyle
```
Style สำหรับ error messages

```xojo
Property ActiveStyle As XjStyle
```
Style สำหรับ active/highlighted items (เช่น selected choice)

```xojo
Property InactiveStyle As XjStyle
```
Style สำหรับ inactive items (non-selected choices)

```xojo
Property DisabledStyle As XjStyle
```
Style สำหรับ disabled items

```xojo
Property CursorStyle As XjStyle
```
Style สำหรับ cursor (في input)

```xojo
Property FilterStyle As XjStyle
```
Style สำหรับ filter input (Ctrl+K mode)

```xojo
Property PlaceholderStyle As XjStyle
```
Style สำหรับ placeholder text

### Shared Factory

```xojo
Shared Function Default_() As XjPromptStyle
```
สร้าง default style set

## XjValidation

Validators สำหรับ input — Required, MinLength, MaxLength, RangeInt, InList, Custom

### Shared Factory Methods

```xojo
Shared Function Required(message As String = "") As XjValidation
```
กำหนด input ต้องไม่ว่างเปล่า

```xojo
Shared Function MinLength(n As Integer, message As String = "") As XjValidation
```
กำหนด input ต้องอย่างน้อย n ตัวอักษร

```xojo
Shared Function MaxLength(n As Integer, message As String = "") As XjValidation
```
กำหนด input ต้องไม่เกิน n ตัวอักษร

```xojo
Shared Function RangeInt(min As Integer, max As Integer, message As String = "") As XjValidation
```
กำหนด input ต้องเป็น integer ระหว่าง min และ max

```xojo
Shared Function InList(values() As String, message As String = "") As XjValidation
```
กำหนด input ต้องเป็นหนึ่ง values

### Instance Method

```xojo
Function Validate(value As String, ByRef errorMessage As String) As Boolean
```
ทำ validate — คืน True ถ้า pass, False ถ้า fail และตั้ง errorMessage

## XjConversion

Input modifiers — uppercase, lowercase, capitalize, strip

### Shared Functions

```xojo
Function ToInteger(value As String, ByRef result As Integer) As Boolean
```
Parse string เป็น integer

```xojo
Function ToDouble(value As String, ByRef result As Double) As Boolean
```
Parse string เป็น double

```xojo
Function ToBool(value As String) As Boolean
```
Parse string เป็น boolean (y/yes/true/1 = True)

```xojo
Sub ApplyModifier(value As String, modifier As Integer) As String
```
ใช้ modifier บน string

### Modifier Constants

```xojo
Const MOD_NONE = 0          ' No change
Const MOD_UP = 1            ' UPPERCASE
Const MOD_DOWN = 2          ' lowercase
Const MOD_CAPITALIZE = 3    ' Capitalize first letter
Const MOD_STRIP = 4         ' Trim whitespace
```

## ตัวอย่างการใช้งาน

### ตั้งค่า Global Prompt Style

```xojo
Var style As New XjPromptStyle
style.PrefixStyle = XjStyle.MakeBold().SetFG(XjANSI.FG_BLUE)
style.QuestionStyle = XjStyle.Default_()
style.AnswerStyle = XjStyle.MakeBold()
style.ErrorStyle = XjStyle.Danger()

XjPrompt.SetStyle(style)
```

### Validate Required & MinLength

```xojo
Var prompt As New XjAskPrompt("Username")
prompt.AddValidation(XjValidation.Required("Username required"))
prompt.AddValidation(XjValidation.MinLength(3, "Must be 3+ characters"))

Var username As String = prompt.Run()
```

### Validate InList

```xojo
Var prompt As New XjAskPrompt("Environment")
Var valid() As String = Array("dev", "staging", "prod")
prompt.AddValidation(XjValidation.InList(valid, "Must be dev/staging/prod"))

Var env As String = prompt.Run()
```

### Validate RangeInt

```xojo
Var prompt As New XjAskPrompt("Port")
prompt.AddValidation(XjValidation.RangeInt(1024, 65535, "Port must be 1024-65535"))

Var portStr As String = prompt.Run()
Var port As Integer = Val(portStr)
```

### Apply Input Modifier

```xojo
Var prompt As New XjAskPrompt("City")
prompt.SetModifier(XjConversion.MOD_CAPITALIZE)

Var city As String = prompt.Run()
' "new york" -> "New york"
```

### Parse Numeric Input

```xojo
Var input As String = XjPrompt.Ask("Enter number")
Var num As Integer
If XjConversion.ToInteger(input, num) Then
  XjPrompt.Ok("Number: " + num.ToString())
Else
  XjPrompt.Error_("Not a valid number")
End If
```

### Custom Validation

ลอง XjAskPrompt เพื่อสร้าง custom validator:

```xojo
Var prompt As New XjAskPrompt("Email")

' Validate using pattern (simplified)
Var customValidator As New XjValidation
' Custom validation logic in Validate() method

prompt.AddValidation(customValidator)
Var email As String = prompt.Run()
```

## หมายเหตุการออกแบบ

XjPromptStyle ตั้งค่าทั่วโลก — ทุก prompt ใช้ style นี้ (ไม่ต้องตั้ง individual widgets)

XjValidation validators chain — AddValidation() หลาย ตัว ตรวจสอบ ตามลำดับ

Message parameter ใน Required/MinLength/... เป็น optional — ถ้าบอก ใช้ default message

ApplyModifier() modify input เมื่อแสดง only — actual value ไม่เปลี่ยน

ToInteger/ToDouble ส่งคืน Boolean — ใช้เพื่อ check ถ้า parse สำเร็จ
