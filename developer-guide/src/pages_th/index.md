---
title: บทนำ
description: XjTTY-Toolkit เป็นไลบรารี Terminal UI (TUI) สำหรับแอปพลิเคชัน Xojo Console ได้แรงบันดาลใจจาก Ruby TTY-Toolkit, Python Prompt Toolkit และ Rust IOCraft
---

# บทนำ

**XjTTY-Toolkit** เป็นไลบรารี Terminal UI (TUI) แบบครบวงจรสำหรับแอปพลิเคชัน Xojo Console ให้ทุกอย่างที่จำเป็นสำหรับสร้าง terminal interface ที่สมบูรณ์และโต้ตอบได้ — ตั้งแต่ ANSI escape code ระดับต่ำ ไปจนถึง prompt dialog ระดับสูงและ widget-based layout

Toolkit นี้ได้แรงบันดาลใจจาก **Ruby's TTY-Toolkit**, **Python's Prompt Toolkit** และ **Rust's IOCraft** ปรับให้เหมาะกับ Xojo

## ภาพรวมสถาปัตยกรรม

ไลบรารีจัดเรียงเป็นชั้น แต่ละชั้นสร้างต่อจากชั้นด้านล่าง:

| ชั้น | คอมโพเนนต์ | วัตถุประสงค์ |
|------|----------|-----------|
| ระดับพื้นฐาน | XjPlatform, XjANSI, XjTerminal | ANSI escape code, platform detection, low-level terminal control |
| สี & จัดรูปแบบ | XjColor, XjStyle, XjCell, XjCanvas | Colors, styling, character cells, 2D rendering |
| อินพุต | XjKeyEvent, XjReader, XjEventLoop | Key parsing, VT100 sequences, event dispatch |
| Layout | XjConstraint, XjLayoutNode, XjLayoutSolver | Flexbox-like sizing and positioning |
| Widget | XjWidget, XjBox, XjText, XjTable, XjProgressBar, XjSpinner, XjTree | Reusable UI components |
| Dialog | XjPrompt, XjAskPrompt, XjSelectPrompt, ... | High-level user input and confirmation |
| Utility | XjLogger, XjOption, XjConfig, XjCommand, XjFont, XjPie, XjMarkdown | Logging, CLI args, configuration, shell commands |
| YAML UI | XjYAML, XjUIParser | Declarative UI definition language |

## 63 คอมโพเนนต์

ไลบรารีประกอบด้วย 63 คอมโพเนนต์ ผ่าน 7 เฟสของการพัฒนา ทั้งหมดถูกวิเคราะห์และ optimize ด้าน Big O performance แล้ว เรามาดูกันว่าชั้นต่างๆ ทำงานร่วมกันอย่างไร

## รองรับหลายแพลตฟอร์ม

XjTTY-Toolkit ทำงานบน macOS, Linux และ Windows โค้ดเฉพาะแพลตฟอร์ม (termios vs Win32) ถูกจัดการภายในโดย XjPlatform และ XjTerminal ซึ่งหมายความว่าแอปพลิเคชันของคุณสามารถเขียนครั้งเดียวและทำงานได้ทุกแพลตฟอร์ม

## เริ่มต้นอย่างรวดเร็ว

```xojo
Var loop As New XjEventLoop
loop.SetOnKeyPress(Function(key As XjKeyEvent) As Boolean
  If key.IsEscape Then
    loop.Stop_()
  End If
  Return True
End Function)
loop.Run()
```

## เนื้อหาในคู่มือนี้

| ส่วน | หัวข้อ |
|------|--------|
| Core | Platform Detection, ANSI Codes, Terminal Control, Colors, Cursor, Screen |
| Styling | Style Builder, Cell & Canvas, Unicode Symbols |
| Events | Key Event, Event System, Event Loop, Input Reader |
| Layout | Constraints, Layout Nodes, Layout Solver |
| Widgets | Widget Base, Box & Text, TextInput, Table, Progress & Spinner, Tree, Focus Manager |
| Prompts | Prompt Facade, Text Prompts, Selection Prompts, Special Prompts, Styling & Validation |
| Utilities | Logger, CLI Options, Config, Commands, Display (Font, Pie, Markdown) |
| YAML UI | YAML Parser, UI Builder |

เอกสารนี้ครอบคลุมแต่ละคอมโพเนนต์อย่างถ่องแท้ — API reference, ตัวอย่าง, และ use case ธรรมชาติสำหรับเมื่อใช้กรรมการใดกรรมการหนึ่ง
