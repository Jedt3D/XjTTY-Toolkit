---
title: Prompt พิเศษ
description: Special prompt widget คือ Confirm, Slider, KeyPress, Collect
---

# Special Prompts

Special prompts คือ Confirm (yes/no), Slider (numeric range), KeyPress (single key), Collect (multi-step form)

## XjConfirmPrompt

ถาม yes/no question — Enter = default, y/n = explicit choice

### Constructor

```xojo
Sub New(question As String, defaultYes As Boolean = True)
```
สร้าง confirm prompt

### Configuration

```xojo
Sub SetPromptStyle(style As XjPromptStyle)
```
ตั้งค่า prompt style

### Run

```xojo
Function Run() As Boolean
```
แสดง prompt — คืน True (yes), False (no)

## XjSliderPrompt

ถาม numeric value บน slider — arrow left/right adjust, number keys jump

### Constructor

```xojo
Sub New(question As String, min As Integer, max As Integer, step_ As Integer, default As Integer)
```
สร้าง slider prompt

### Run

```xojo
Function Run() As Integer
```
แสดง slider — คืน selected value

## XjKeyPressPrompt

รอให้ผู้ใช้กด single key

### Constructor

```xojo
Sub New(question As String, timeoutMs As Integer = -1)
```
สร้าง key press prompt (-1 = no timeout)

### Run

```xojo
Function Run() As XjKeyEvent
```
แสดง prompt — รอ key press — คืน XjKeyEvent

## XjCollectPrompt

Multi-step form — chain ของ Ask/Confirm/Password/Select prompt into single flow

### Constructor

```xojo
Sub New()
```
สร้าง collect prompt

### Adding Steps

```xojo
Sub AddAsk(key As String, question As String, default As String = "")
```
เพิ่ม Ask step

```xojo
Sub AddConfirm(key As String, question As String, defaultYes As Boolean = True)
```
เพิ่ม Confirm step

```xojo
Sub AddPassword(key As String, question As String, mask As String = "*")
```
เพิ่ม Password step

```xojo
Sub AddSelect(key As String, question As String, choices() As String)
```
เพิ่ม Select step

### Run

```xojo
Function Run() As Dictionary
```
รัน form ทั้งหมด — คืน Dictionary key=value (key มาจาก AddAsk/AddConfirm/...)

## ตัวอย่างการใช้งาน

### Simple Confirm

```xojo
Var prompt As New XjConfirmPrompt("Delete file?", False)
If prompt.Run() Then
  ' Delete
Else
  ' Cancel
End If
```

### Slider

```xojo
Var prompt As New XjSliderPrompt("Select volume", 0, 100, 10, 50)
Var volume As Integer = prompt.Run()
XjTerminal.Write("Volume: " + volume.ToString())
```

### KeyPress (Interactive Menu)

```xojo
Var prompt As New XjKeyPressPrompt("Press any key", 5000) ' 5 second timeout
Var key As XjKeyEvent = prompt.Run()
If key <> Nil Then
  XjTerminal.Write("You pressed: " + key.KeyName())
End If
```

### Collect - Registration Form

```xojo
Var form As New XjCollectPrompt

form.AddAsk("name", "Full name", "John Doe")
form.AddAsk("email", "Email address")
form.AddPassword("password", "Password")
form.AddConfirm("newsletter", "Subscribe to newsletter?", True)

Var answers As Dictionary = form.Run()

Var name As String = answers.Value("name").StringValue
Var email As String = answers.Value("email").StringValue
Var pwd As String = answers.Value("password").StringValue
Var newsletter As Boolean = answers.Value("newsletter").BooleanValue

XjTerminal.Write("Name: " + name)
XjTerminal.Write("Email: " + email)
XjTerminal.Write("Newsletter: " + newsletter.ToString())
```

### Collect - Configuration Wizard

```xojo
Var form As New XjCollectPrompt

form.AddAsk("dbhost", "Database host", "localhost")
form.AddAsk("dbport", "Database port", "5432")
form.AddSelect("dbtype", "Database type", Array("PostgreSQL", "MySQL", "SQLite"))
form.AddPassword("dbpass", "Database password")
form.AddConfirm("proceed", "Create schema?", False)

Var config As Dictionary = form.Run()

' Access answers
Var host As String = config.Value("dbhost").StringValue
Var port As String = config.Value("dbport").StringValue
Var dbtype As String = config.Value("dbtype").StringValue
Var proceed As Boolean = config.Value("proceed").BooleanValue
```

### Slider - Quality Setting

```xojo
Var prompt As New XjSliderPrompt("Image quality (1-10)", 1, 10, 1, 8)
Var quality As Integer = prompt.Run()
XjTerminal.Write("Selected quality: " + quality.ToString())
```

## Dictionary Access Pattern

```xojo
Var answers As Dictionary = form.Run()

' Get value and convert to appropriate type
Var name As String = answers.Value("name").StringValue
Var count As Integer = answers.Value("count").IntegerValue
Var agree As Boolean = answers.Value("agree").BooleanValue
```

## หมายเหตุการออกแบบ

XjConfirmPrompt ส่งคืน Boolean — ใช้สำหรับ yes/no questions

XjSliderPrompt ใช้ left/right arrows เพื่อ adjust — number keys jump ไปยัง value นั้น

XjKeyPressPrompt timeout ใช้ milliseconds — -1 = no timeout, 0 = immediate return (ไม่รอ)

XjCollectPrompt ใช้ Dictionary เพื่อ store answers — key มาจาก method call (AddAsk, AddSelect, เป็นต้น)

Collect เหมาะสำหรับ wizard/onboarding flow — chain multiple prompts without pausing
