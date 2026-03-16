---
title: Text Prompt
description: Text input prompt widget คือ Ask, Password, MultiLine, Suggest
---

# Text Prompts

Text prompts รับข้อความจากผู้ใช้ — Ask สำหรับ free-form, Password สำหรับ masked, MultiLine สำหรับหลายบรรทัด, Suggest สำหรับ autocomplete

## XjAskPrompt

ถาม free-form text ด้วย validation และ default value

### Constructor

```xojo
Sub New(question As String, default As String = "")
```
สร้าง ask prompt

### Configuration

```xojo
Sub SetDefault(value As String)
Function Default() As String
```
ตั้ง/ดึง default value (แสดงในวงเล็บ)

```xojo
Sub AddValidation(validator As XjValidation)
```
เพิ่ม validator — ถ้า input ล้มเหลว validator, แสดง error และขอให้พิมพ์ใหม่

```xojo
Sub SetModifier(modifier As Integer)
```
ตั้งค่า input modifier (uppercase, lowercase, capitalize, strip, ฯลฯ)

```xojo
Sub SetPromptStyle(style As XjPromptStyle)
```
ตั้งค่า prompt style (prefix, question, cursor, error)

```xojo
Sub SetHistory(history As XjHistory)
```
ตั้งค่า input history — navigate arrow up/down

### Run

```xojo
Function Run() As String
```
แสดง prompt และรอ input — คืน string ที่ input

## XjPasswordPrompt

ถาม password — value ถูก mask เมื่อพิมพ์

### Constructor

```xojo
Sub New(question As String, mask As String = "*")
```
สร้าง password prompt

### Configuration

```xojo
Sub SetMask(maskChar As String)
Function Mask() As String
```
ตั้ง/ดึง mask character

```xojo
Sub SetPromptStyle(style As XjPromptStyle)
```
ตั้งค่า prompt style

### Run

```xojo
Function Run() As String
```
แสดง prompt และรอ input — คืน unmasked password

## XjMultiLinePrompt

ถาม multi-line text (Enter เพิ่มบรรทัด, Ctrl+D หรือ Ctrl+Z submit)

### Constructor

```xojo
Sub New(question As String)
```
สร้าง multi-line prompt

### Run

```xojo
Function Run() As String
```
แสดง prompt และรอ input — คืน multi-line string (lines คั่นด้วย newline)

## XjSuggestPrompt

ถาม text พร้อม autocomplete suggestions

### Constructor

```xojo
Sub New(question As String, completer As XjCompleter)
```
สร้าง suggest prompt

```xojo
Sub New(question As String, suggestions() As String)
```
สร้าง suggest prompt จาก array suggestions

### Run

```xojo
Function Run() As String
```
แสดง prompt พร้อม dropdown suggestions — ใช้ arrow down/up เพื่อ select suggestion, Tab/Enter เพื่อ complete

## ตัวอย่างการใช้งาน

### Simple Ask

```xojo
Var prompt As New XjAskPrompt("What's your name?")
Var name As String = prompt.Run()
XjTerminal.Write("Hello, " + name)
```

### Ask พร้อม Default

```xojo
Var prompt As New XjAskPrompt("City", "NYC")
Var city As String = prompt.Run()
' แสดง: City [NYC]: _
```

### Ask พร้อม Validation

```xojo
Var prompt As New XjAskPrompt("Email")
prompt.AddValidation(XjValidation.Required("Email required"))
prompt.AddValidation(XjValidation.MinLength(5, "Email too short"))
Var email As String = prompt.Run()
```

### Ask พร้อม History

```xojo
Var history As New XjHistory
history.Add("john@example.com")
history.Add("jane@example.com")

Var prompt As New XjAskPrompt("Email")
prompt.SetHistory(history)
Var email As String = prompt.Run()
' Arrow up/down เพื่อ navigate history
```

### Password

```xojo
Var prompt As New XjPasswordPrompt("Enter password", "*")
Var pwd As String = prompt.Run()
' Display: Enter password: **** (but input is "secret")
```

### MultiLine

```xojo
Var prompt As New XjMultiLinePrompt("Describe the issue:")
Var description As String = prompt.Run()
' Type multiple lines, Ctrl+D to submit
```

### Suggest

```xojo
Var languages() As String = Array("Python", "Rust", "Go", "JavaScript", "Xojo")
Var completer As New XjCompleter(languages)

Var prompt As New XjSuggestPrompt("Favorite language", completer)
Var lang As String = prompt.Run()
' Type "py" -> suggestions show "Python"
' Arrow down to select, Tab to complete
```

## Modifier Constants (for SetModifier)

```xojo
Const MOD_NONE = 0          ' No modification
Const MOD_UP = 1            ' Uppercase
Const MOD_DOWN = 2          ' Lowercase
Const MOD_CAPITALIZE = 3    ' Capitalize first letter
Const MOD_STRIP = 4         ' Trim whitespace
```

## หมายเหตุการออกแบบ

XjAskPrompt ต้อง AddValidation() หลัง New — validators ตรวจสอบตามลำดับ ถ้าตัวใด fail แสดง error message

XjPasswordPrompt ไม่ validate — เพียงแค่ input password ที่ masked

XjMultiLinePrompt รอ Ctrl+D หรือ Ctrl+Z เพื่อ submit — Enter = newline

XjSuggestPrompt ใช้ XjCompleter ภายใน — completer ทำ prefix/substring matching บน suggestions

ทั้งหมดส่งคืน blocking function — รอจนกว่าผู้ใช้ submit
