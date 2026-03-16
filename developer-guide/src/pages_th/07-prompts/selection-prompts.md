---
title: Selection Prompt
description: Selection prompt widget คือ Select, MultiSelect, Enum, Expand
---

# Selection Prompts

Selection prompts ให้ผู้ใช้เลือก choice จาก list — Select สำหรับ single choice, MultiSelect สำหรับ multiple, Enum สำหรับ numeric, Expand สำหรับ key-mapped

## XjSelectPrompt

ถาม single choice จาก list — ใช้ arrow keys navigate, Enter select

### Constructor

```xojo
Sub New(question As String, choices() As String)
```
สร้าง select prompt

### Configuration

```xojo
Sub SetPerPage(perPage As Integer)
Function PerPage() As Integer
```
ตั้ง/ดึง page size สำหรับ pagination (default 7)

```xojo
Sub DisableChoice(index As Integer)
```
ปิด choice ใดก็ได้ — ไม่สามารถ select

```xojo
Sub SetFilter(enabled As Boolean)
Function FilterEnabled() As Boolean
```
เปิด/ปิด filter mode (Ctrl+K type-ahead search)

### Run

```xojo
Function Run() As String
```
แสดง list และรอ select — คืน selected choice

## XjMultiSelectPrompt

ถาม multiple choices จาก list — ใช้ space toggle, Enter submit

### Constructor

```xojo
Sub New(question As String, choices() As String)
```
สร้าง multi-select prompt

### Configuration

```xojo
Sub SetPerPage(perPage As Integer)
Function PerPage() As Integer
```
ตั้ง/ดึง page size

```xojo
Sub SetMinMax(min As Integer, max As Integer)
```
ตั้ง minimum/maximum selection count

```xojo
Sub DisableChoice(index As Integer)
```
ปิด choice

```xojo
Sub SetFilter(enabled As Boolean)
Function FilterEnabled() As Boolean
```
เปิด/ปิด filter mode

### Run

```xojo
Function Run() As String()
```
แสดง list และรอ select — คืน array ของ selected choices

## XjEnumSelectPrompt

ถาม choice แสดงเป็นหมายเลข (1, 2, 3, ...)

### Constructor

```xojo
Sub New(question As String, choices() As String)
```
สร้าง enum select prompt

### Run

```xojo
Function Run() As String
```
แสดง numbered list — ผู้ใช้พิมพ์หมายเลข — คืน selected choice

## XjExpandPrompt

ถาม choice ที่แสดงเป็น key-mapped (เช่น "y/n/d" for yes/no/default)

### Constructor

```xojo
Sub New(question As String, choices() As String, keys() As String)
```
สร้าง expand prompt — choices คือ text, keys คือ keyboard shortcuts (same length)

### Run

```xojo
Function Run() As String
```
แสดง prompt พร้อม keys — ผู้ใช้กด key — คืน selected choice

## ตัวอย่างการใช้งาน

### Simple Select

```xojo
Var colors() As String = Array("Red", "Green", "Blue")
Var prompt As New XjSelectPrompt("Choose a color", colors)
Var selected As String = prompt.Run()
XjTerminal.Write("You chose: " + selected)
```

### Select พร้อม Pagination

```xojo
Var items() As String = ' ... large array
Var prompt As New XjSelectPrompt("Choose item", items)
prompt.SetPerPage(10) ' Show 10 items per page
Var item As String = prompt.Run()
```

### Select พร้อม Filter

```xojo
Var countries() As String = Array("Australia", "Austria", "Albania", "Algeria", ...)
Var prompt As New XjSelectPrompt("Choose country", countries)
prompt.SetFilter(True)
' Ctrl+K, then type "aus" -> shows Austria, Australia
Var country As String = prompt.Run()
```

### MultiSelect

```xojo
Var fruits() As String = Array("Apple", "Orange", "Banana", "Grape")
Var prompt As New XjMultiSelectPrompt("Choose fruits", fruits)
Var selected() As String = prompt.Run()

For i As Integer = 0 To selected.LastRowIndex
  XjTerminal.Write("- " + selected(i))
Wend
```

### MultiSelect พร้อม Constraints

```xojo
Var items() As String = Array("A", "B", "C", "D")
Var prompt As New XjMultiSelectPrompt("Choose 2-3 items", items)
prompt.SetMinMax(2, 3)
Var selected() As String = prompt.Run()
' Must select between 2 and 3 items
```

### Enum Select

```xojo
Var options() As String = Array("Option 1", "Option 2", "Option 3")
Var prompt As New XjEnumSelectPrompt("Pick one", options)
' Display:
' 1) Option 1
' 2) Option 2
' 3) Option 3
Var choice As String = prompt.Run()
```

### Expand (Yes/No/Default)

```xojo
Var choices() As String = Array("Yes", "No", "Default")
Var keys() As String = Array("y", "n", "d")
Var prompt As New XjExpandPrompt("Continue?", choices, keys)
' Display: Continue? (y/n/d)
Var answer As String = prompt.Run()
```

### Expand (Git-style)

```xojo
Var choices() As String = Array("Yes, stash it", "No, discard", "Manual review")
Var keys() As String = Array("s", "d", "m")
Var prompt As New XjExpandPrompt("Stash changes?", choices, keys)
Var action As String = prompt.Run()
```

## หมายเหตุการออกแบบ

XjSelectPrompt ใช้ arrow keys (↑/↓) navigate, Space/Enter select

XjMultiSelectPrompt ใช้ arrow keys navigate, Space toggle current, Enter submit

XjEnumSelectPrompt เหมาะสำหรับ choices เล็กน้อย (1-9 items) — ผู้ใช้พิมพ์หมายเลข

XjExpandPrompt เหมาะสำหรับ choices ที่ short & distinct keys (git-like UX)

DisableChoice(index) ปิด option ที่ต้องการ (ไม่สามารถ select) — แสดง grayed out

Filter mode (Ctrl+K) ใช้สำหรับ large lists — type-ahead search
