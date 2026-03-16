---
title: Display (Font, Pie, Markdown)
description: XjFont สำหรับ ASCII art, XjPie สำหรับ horizontal bar chart, XjMarkdown สำหรับ terminal markdown
---

# Display Utilities

## XjFont Module

สร้าง ASCII art text โดยใช้ 5×5 block font

### Function

```xojo
Function Render(text As String, style As XjStyle = Nil) As String()
```
แปลง text เป็น array ของ 5 strings (5 lines of ASCII art)

รองรับ: A-Z (uppercase), 0-9, space, วรรค punctuation

### ตัวอย่าง

```xojo
Var lines() As String = XjFont.Render("HELLO")
For i As Integer = 0 To lines.LastRowIndex
  XjTerminal.Write(lines(i))
Wend

' Output (5 lines):
'  ███   █████  █      █      ███
' █   █ █      █      █     █
' █████ ████   █      █      ███
' █   █ █      █      █          █
' █   █ █████  █████  █████  ███
```

## XjPie Class

Horizontal bar chart ด้วย colored segments

### Constructor

```xojo
Sub New()
```
สร้าง pie chart ว่างเปล่า

### Adding Data

```xojo
Sub AddSlice(label As String, value As Integer)
```
เพิ่ม slice (segment) พร้อม label และ value

### Configuration

```xojo
Sub SetWidth(width As Integer)
Function Width() As Integer
```
ตั้ง/ดึง width ของ bar

```xojo
Sub SetColor(useColor As Boolean)
Function ColorEnabled() As Boolean
```
เปิด/ปิด colored segments

### Display

```xojo
Function Draw() As String
```
สร้าง colored bar

```xojo
Function Render() As String()
```
สร้าง array ของ strings (bar + legend)

## XjMarkdown Module

Terminal markdown renderer — headers, bold, italic, code, lists, code blocks

### Function

```xojo
Function Render(text As String) As String
```
แปลง markdown ไป terminal output

### Supported Markdown

```
# Header 1
## Header 2
### Header 3

**bold text**
*italic text*
`inline code`

- Unordered list
- Item 2
  - Nested

1. Ordered list
2. Item 2

```
code block
multi-line
```

--- (horizontal rule)
```

### ตัวอย่าง

```xojo
Var md As String = "# Title\n**Bold** and *italic* text\n- Item 1\n- Item 2"
Var output As String = XjMarkdown.Render(md)
XjTerminal.Write(output)
```

## ตัวอย่างการใช้งาน

### ASCII Art Text

```xojo
Var banner() As String = XjFont.Render("XjTTY")
For i As Integer = 0 To banner.LastRowIndex
  XjTerminal.Write(banner(i))
Wend
```

### Pie Chart - Server Resources

```xojo
Var pie As New XjPie
pie.AddSlice("CPU", 65)
pie.AddSlice("Memory", 25)
pie.AddSlice("Disk", 10)
pie.SetWidth(60)
pie.SetColor(True)

Var output() As String = pie.Render()
For i As Integer = 0 To output.LastRowIndex
  XjTerminal.Write(output(i))
Wend

' Output:
' [████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░] 65%
' [██████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 25%
' [█████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 10%
```

### Pie Chart - Time Distribution

```xojo
Var pie As New XjPie
pie.AddSlice("Sleep", 420) ' 7 hours
pie.AddSlice("Work", 480)  ' 8 hours
pie.AddSlice("Recreation", 240) ' 4 hours
pie.AddSlice("Other", 120) ' 2 hours
pie.SetWidth(50)

Var legend() As String = pie.Render()
For i As Integer = 0 To legend.LastRowIndex
  XjTerminal.Write(legend(i))
Wend
```

### Markdown Help Text

```xojo
Var helpMarkdown As String = "# Help\n" + _
  "## Commands\n" + _
  "- **start** - Start service\n" + _
  "- **stop** - Stop service\n" + _
  "\n" + _
  "## Options\n" + _
  "`--verbose` - Enable verbose output\n"

Var help As String = XjMarkdown.Render(helpMarkdown)
XjPrompt.Say(help)
```

### Markdown README

```xojo
Var readme As String = "# MyApp\n" + _
  "\nSimple *terminal* application.\n" + _
  "\n## Features\n" + _
  "- **Fast**\n" + _
  "- **Easy**\n" + _
  "- `Open source`\n"

Var rendered As String = XjMarkdown.Render(readme)
XjTerminal.Write(rendered)
```

## หมายเหตุการออกแบบ

XjFont ใช้ 5×5 block font — A-Z เท่านั้น, lowercase ถูก convert เป็น uppercase

XjPie เป็น horizontal bar chart เท่านั้น — ไม่ support pie chart classic

XjMarkdown single-pass renderer — ไม่ parse full AST, เพียง pattern matching สำหรับ common syntax

XjFont.Render() ส่งคืน array 5 strings — ผู้ใช้ต้อง loop และ print แต่ละ line

XjPie.Render() ส่งคืน array ของ bar + legend lines
