---
title: Unicode และ ASCII Symbols
description: XjSymbols module ให้ unicode glyph ที่ support fallback ไป ASCII
---

# XjSymbols

**XjSymbols** เป็น module ที่จัดให้มี Unicode glyph symbols (check mark, cross, pointers, เป็นต้น) พร้อม automatic fallback ไป ASCII ถ้า terminal ไม่รองรับ Unicode สิ่งสำคัญคือแทนที่จะ hardcode "✔" ลองใช้ `XjSymbols.Check()` ซึ่งจะเลือก Unicode หรือ ASCII ตามที่ terminal รองรับ

## Initialization

```xojo
Sub EnsureInit()
```
เริ่มต้น symbol set โดยอัตโนมัติ เรียก lazy-init (ไม่ต้องเรียกด้วยตัวเองปกติแล้ว)

```xojo
Sub UseASCII()
```
บังคับให้ใช้ ASCII fallback แม้ terminal รองรับ Unicode

```xojo
Sub UseUnicode()
```
บังคับให้ใช้ Unicode symbols (ค่าเริ่มต้น)

## Symbol Properties

```xojo
Function Marker() As String
```
คืน "❯" (unicode) หรือ ">" (ASCII) — สำหรับ marker/pointer

```xojo
Function Check() As String
```
คืน "✔" (unicode) หรือ "[x]" (ASCII) — สำหรับ checkmark

```xojo
Function Cross() As String
```
คืน "✘" (unicode) หรือ "[!]" (ASCII) — สำหรับ cross/error mark

```xojo
Function Circle() As String
```
คืน "●" (unicode) หรือ "(*)" (ASCII) — สำหรับ filled circle

```xojo
Function CircleEmpty() As String
```
คืน "○" (unicode) หรือ "( )" (ASCII) — สำหรับ empty circle

```xojo
Function Square() As String
```
คืน "■" (unicode) หรือ "[x]" (ASCII) — สำหรับ filled square

```xojo
Function SquareEmpty() As String
```
คืน "□" (unicode) หรือ "[ ]" (ASCII) — สำหรับ empty square

```xojo
Function ArrowRight() As String
```
คืน "▸" (unicode) หรือ ">" (ASCII) — สำหรับ right arrow

```xojo
Function Bullet() As String
```
คืน "•" (unicode) หรือ "*" (ASCII) — สำหรับ bullet point

```xojo
Function Ellipsis() As String
```
คืน "…" (unicode) หรือ "..." (ASCII) — สำหรับ ellipsis

```xojo
Function QuestionMark() As String
```
คืน "?" — question mark (เหมือนกันทั้ง Unicode และ ASCII)

## ตัวอย่างการใช้งาน

### สร้าง Status Messages

```xojo
Var success As String = XjSymbols.Check() + " Setup complete"
Var error As String = XjSymbols.Cross() + " Build failed"
XjTerminal.Write(success)
XjTerminal.Write(error)
```

### ใช้ใน List

```xojo
Var marker As String = XjSymbols.Marker()
XjTerminal.Write(marker + " First item")
XjTerminal.Write(marker + " Second item")
XjTerminal.Write(marker + " Third item")
```

### ใช้กับสไตล์

```xojo
Var checkStyle As XjStyle = XjStyle.Success()
Var msg As String = checkStyle.Apply(XjSymbols.Check()) + " Done"
XjTerminal.Write(msg)
```

### Selection List

```xojo
Var selected As String = XjSymbols.Marker() + " Option 1"
Var unselected As String = "  Option 2"
XjTerminal.Write(selected)
XjTerminal.Write(unselected)
```

### Fallback ไป ASCII

```xojo
' บนไม่รองรับ Unicode
XjSymbols.UseASCII()
XjTerminal.Write(XjSymbols.Check()) ' prints "[x]"

' บังคับ Unicode
XjSymbols.UseUnicode()
XjTerminal.Write(XjSymbols.Check()) ' prints "✔"
```

## หมายเหตุการออกแบบ

XjSymbols lazy-init คือไม่ instantiate symbol set จนกว่า EnsureInit() ถูกเรียก หรือเมื่อฟังก์ชัน symbol แรกถูกเรียก นี้ช่วยลดการเตรียมในการสตาร์ทแอปพลิเคชัน

Symbol set ถูกเลือกบน automatic detection ของ TERM environment variable (เช่น "xterm-256color", "linux") รองรับ Unicode หรือ "dumb" terminal ไม่รองรับ

XjTree, XjSpinner, และ prompt modules ใช้ XjSymbols ภายในสำหรับการแสดงผล
