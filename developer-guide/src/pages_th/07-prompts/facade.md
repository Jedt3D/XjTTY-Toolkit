---
title: Prompt Facade
description: XjPrompt module facade ที่ให้ 15 prompt functions สำหรับ high-level user interaction
---

# Prompt Facade (XjPrompt)

**XjPrompt** เป็น module facade ที่ wrap prompt widgets ทั้งหมดเพื่อให้ simple API สำหรับ user interaction — ไม่ต้องสร้าง XjAskPrompt, XjSelectPrompt, เป็นต้น เพียงแค่เรียก `XjPrompt.Ask()`, `XjPrompt.Select_()`, ฯลฯ

## Text Input Prompts

### Ask - Free-form Text

```xojo
Function Ask(question As String, default As String = "") As String
```
ถามผู้ใช้ว่าต้องการป้อนข้อความ พร้อม optional default value

```xojo
Function AskWithHistory(question As String, history As XjHistory, default As String = "") As String
```
ถาม พร้อมการ navigate input history (arrow up/down)

```xojo
Function AskValidated(question As String, default As String, validators() As XjValidation) As String
```
ถาม พร้อมการ validate input — ถ้า invalid, ขอให้พิมพ์ใหม่

### Password - Masked Input

```xojo
Function Password(question As String, mask As String = "*") As String
```
ถาม password — value ถูก mask ในขณะพิมพ์

### MultiLine - Multi-line Editor

```xojo
Function MultiLine(question As String) As String
```
ถาม multi-line text (Enter สำหรับบรรทัดใหม่, Ctrl+D หรือ Ctrl+Z เพื่อ submit)

### Suggest - Autocomplete

```xojo
Function Suggest(question As String, suggestions() As String) As String
```
ถาม พร้อม autocomplete suggestions (ลงมีลาก dropdown)

## Yes/No Prompts

### Confirm - Yes/No

```xojo
Function Confirm(question As String, defaultYes As Boolean = True) As Boolean
```
ถาม yes/no — คืน Boolean

```xojo
Function Deny(question As String, defaultNo As Boolean = True) As Boolean
```
เหมือนกับ Confirm แต่ default เป็น "No"

## Selection Prompts

### Select - Single Choice

```xojo
Function Select_(question As String, choices() As String, perPage As Integer = 7) As String
```
ถาม single choice จาก list — ใช้ arrow keys เพื่อ navigate, Enter เพื่อ select

```xojo
Function MultiSelect(question As String, choices() As String, min As Integer = 0, max As Integer = -1) As String()
```
ถาม multiple choices — space เพื่อ toggle, Enter เพื่อ submit (min/max constraints)

```xojo
Function EnumSelect(question As String, choices() As String) As String
```
ถาม single choice ที่แสดงเป็นหมายเลข (1, 2, 3, ...) ใช้ numeric input

### Expand - Key-based Selection

```xojo
Function Expand(question As String, choices() As String, keys() As String) As String
```
ถาม ท่า key-mapped choices เช่น "(y/n/d)" สำหรับ yes/no/default

## Numeric & Special

### Slider - Numeric Range

```xojo
Function Slider(question As String, min As Integer, max As Integer, step_ As Integer, default As Integer) As Integer
```
ถาม numeric value บน slider — ใช้ arrow keys เพื่อ adjust

### KeyPress - Wait for Single Key

```xojo
Function KeyPress(question As String, timeoutMs As Integer = -1) As XjKeyEvent
```
รอให้ผู้ใช้กด key — ส่งคืน XjKeyEvent (-1 = no timeout)

## Multi-Step

### Collect - Multi-step Form

```xojo
Function Collect() As Dictionary
```
สร้าง XjCollectPrompt — chain ของ Ask/Confirm/Select เป็น form เดียว ส่งคืน Dictionary ของ key=value answers

## Output Helpers

```xojo
Sub Say(msg As String)
```
พิมพ์ข้อความธรรมดา (similar to echo)

```xojo
Sub Ok(msg As String)
```
พิมพ์ข้อความ success (green, ✓)

```xojo
Sub Warn(msg As String)
```
พิมพ์ข้อความ warning (yellow, ⚠)

```xojo
Sub Error_(msg As String)
```
พิมพ์ข้อความ error (red, ✘)

## Styling

```xojo
Sub SetStyle(style As XjPromptStyle)
```
ตั้งค่า global style สำหรับทั้ง prompts (prefix, question, answer, cursor, error)

## ตัวอย่างการใช้งาน

### Simple Ask

```xojo
Var name As String = XjPrompt.Ask("What's your name?")
XjPrompt.Ok("Hello, " + name)
```

### Select with Default

```xojo
Var choices() As String = Array("Red", "Green", "Blue")
Var color As String = XjPrompt.Select_("Choose a color", choices)
```

### Password

```xojo
Var pwd As String = XjPrompt.Password("Enter password")
```

### Confirm

```xojo
If XjPrompt.Confirm("Delete file?", False) Then
  ' Delete
Else
  ' Cancel
End If
```

### MultiSelect

```xojo
Var items() As String = Array("Apple", "Orange", "Banana", "Grape")
Var selected() As String = XjPrompt.MultiSelect("Choose fruits", items)
For i As Integer = 0 To selected.LastRowIndex
  XjPrompt.Say("- " + selected(i))
Wend
```

### Validated Input

```xojo
Var validators() As XjValidation = Array(XjValidation.Required(), XjValidation.MinLength(3))
Var input As String = XjPrompt.AskValidated("Enter username", "guest", validators)
```

### Multi-step Collect

```xojo
Var form As XjCollectPrompt = ' ... build form
Var answers As Dictionary = form.Run()
For Each key As String In answers.Keys
  XjPrompt.Say(key + ": " + answers.Value(key).StringValue)
Wend
```

## หมายเหตุการออกแบบ

XjPrompt ใช้ widget prompt อพื่นใน — XjAskPrompt, XjSelectPrompt, เป็นต้น

SetStyle() ตั้งค่า global style ทั้งหมด prompt (ไม่ต้องตั้งค่า individual prompts)

Ask, Select_, Confirm, Password, Slider เป็น blocking — รอจนกว่าผู้ใช้เสร็จสิ้น

ถ้าต้อง non-blocking prompts ลอง widget prompts โดยตรง (XjAskPrompt, XjSelectPrompt, เป็นต้น) และ integrate กับ XjEventLoop
