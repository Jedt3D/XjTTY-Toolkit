---
title: ANSI Escape Code
description: XjANSI module สำหรับสร้าง ANSI escape sequence สำหรับสี, จัดรูปแบบ, และการควบคุม terminal
---

# ANSI Escape Code (XjANSI)

**XjANSI** เป็น module ที่จัดให้มี builder functions สำหรับสร้าง ANSI escape sequence ตามมาตรฐาน VT100/xterm สำคัญคือต่อเมื่อคุณเขียนข้อความที่มีสี, bold, หรือเลื่อนเคอร์เซอร์ ลำดับ escape code ต้องมีรูปแบบที่ถูกต้องเพื่อให้ terminal แปลความหมายได้

## การสร้าง Escape Sequence

### ส่วนประกอบพื้นฐาน

```xojo
Function ESC() As String
```
คืนอักขระ Escape (U+001B)

```xojo
Function CSI() As String
```
คืน Control Sequence Introducer (ESC + "[") สำหรับ SGR และ cursor commands

```xojo
Function OSC() As String
```
คืน Operating System Command introducer สำหรับ hyperlinks และ terminal title

```xojo
Function ST() As String
```
คืน String Terminator (ESC + "\") สำหรับปิด OSC sequence

```xojo
Function SGR(code As Integer) As String
```
สร้าง Select Graphic Rendition sequence สำหรับ style ชิ้นเดียว เช่น `SGR(1)` ส่งกลับ "ESC[1m" (bold)

```xojo
Function SGRMulti(codes() As Integer) As String
```
สร้าง SGR sequence สำหรับหลายรายการพร้อมกัน เช่น `SGRMulti(1, 31)` ส่งกลับ "ESC[1;31m" (bold red)

```xojo
Function Reset() As String
```
คืน reset sequence (ESC[0m) เพื่อปิดสไตล์ทั้งหมด

## การจัดรูปแบบ (Styling)

### Bold, Dim, Italic

```xojo
Function Bold() As String
```
คืน "ESC[1m" — bold text

```xojo
Function Dim_() As String
```
คืน "ESC[2m" — dimmed (darker) text

```xojo
Function Italic() As String
```
คืน "ESC[3m" — italic text

```xojo
Function Underline() As String
```
คืน "ESC[4m" — underlined text

```xojo
Function Blink() As String
```
คืน "ESC[5m" — blinking text (หมายเหตุ: หลายๆ terminal ปิดใช้งานนี้)

```xojo
Function Inverse() As String
```
คืน "ESC[7m" — inverse video (สลับสีเบื้องหน้า/พื้นหลัง)

```xojo
Function Hidden() As String
```
คืน "ESC[8m" — hidden/invisible text

```xojo
Function Strikethrough() As String
```
คืน "ESC[9m" — strikethrough text

### ปิดการจัดรูปแบบ

```xojo
Function BoldOff() As String
```
คืน "ESC[22m" — ปิด bold และ dim

```xojo
Function ItalicOff() As String
```
คืน "ESC[23m" — ปิด italic

```xojo
Function UnderlineOff() As String
```
คืน "ESC[24m" — ปิด underline

```xojo
Function InverseOff() As String
```
คืน "ESC[27m" — ปิด inverse

## สี (Colors)

### สี Foreground (16 สี)

```xojo
Function FG(colorCode As Integer) As String
```
สร้าง foreground color sequence สำหรับสี 16 สีมาตรฐาน (30-37 สำหรับปกติ, 90-97 สำหรับสี bright)

### สี Foreground (256 & RGB)

```xojo
Function FG256(index As Integer) As String
```
สร้าง foreground color sequence โดยใช้ 256-color palette

```xojo
Function FGRGB(r As Integer, g As Integer, b As Integer) As String
```
สร้าง foreground color sequence โดยใช้ RGB values (0-255 แต่ละสี)

### สี Background

```xojo
Function BG(colorCode As Integer) As String
```
สร้าง background color sequence สำหรับสี 16 สี

```xojo
Function BG256(index As Integer) As String
```
สร้าง background color sequence โดยใช้ 256-color palette

```xojo
Function BGRGB(r As Integer, g As Integer, b As Integer) As String
```
สร้าง background color sequence โดยใช้ RGB values

```xojo
Function DefaultFG() As String
```
คืน sequence เพื่อรีเซ็ต foreground color เป็นค่าเริ่มต้น

```xojo
Function DefaultBG() As String
```
คืน sequence เพื่อรีเซ็ต background color เป็นค่าเริ่มต้น

## การเลื่อนและตำแหน่งเคอร์เซอร์ (Cursor)

```xojo
Function CursorUp(n As Integer) As String
Function CursorDown(n As Integer) As String
Function CursorForward(n As Integer) As String
Function CursorBackward(n As Integer) As String
```
เลื่อนเคอร์เซอร์ n ครั้งในทิศทางที่ระบุ

```xojo
Function CursorNextLine(n As Integer) As String
Function CursorPrevLine(n As Integer) As String
```
เลื่อนไปยังบรรทัดถัดไป/ก่อนหน้า n ครั้งและชิดซ้าย

```xojo
Function CursorColumn(col As Integer) As String
```
เลื่อนไปยังคอลัมน์ที่ระบุ (1-indexed)

```xojo
Function CursorPosition(row As Integer, col As Integer) As String
```
เลื่อนไปยังตำแหน่งเฉพาะ (row, col) 1-indexed

```xojo
Function CursorSave() As String
```
บันทึกตำแหน่งเคอร์เซอร์ปัจจุบัน

```xojo
Function CursorRestore() As String
```
คืนค่าตำแหน่งเคอร์เซอร์ที่บันทึกไว้

```xojo
Function CursorShow() As String
```
ทำให้เคอร์เซอร์มองเห็นได้

```xojo
Function CursorHide() As String
```
ซ่อนเคอร์เซอร์

```xojo
Function CursorRequestPosition() As String
```
ส่งคำขอให้ terminal ส่งกลับตำแหน่งเคอร์เซอร์ปัจจุบัน (ใช้ใน XjReader)

## ลบข้อมูล (Erase)

```xojo
Function EraseToEndOfLine() As String
```
ลบจากเคอร์เซอร์ถึงส่วนท้ายของบรรทัดปัจจุบัน

```xojo
Function EraseToStartOfLine() As String
```
ลบจากจุดเริ่มต้นของบรรทัดถึงเคอร์เซอร์

```xojo
Function EraseLine() As String
```
ลบบรรทัดปัจจุบันทั้งหมด

```xojo
Function EraseUp() As String
Function EraseDown() As String
```
ลบข้างบน/ข้างล่างเคอร์เซอร์

```xojo
Function EraseScreen() As String
```
ลบหน้าจอทั้งหมด

## การเลื่อนหน้าจอ (Scroll)

```xojo
Function ScrollUp(n As Integer) As String
Function ScrollDown(n As Integer) As String
```
เลื่อนหน้าจอขึ้น/ลง n บรรทัด

## การควบคุมหน้าจอ (Screen Control)

```xojo
Function AlternateScreenEnter() As String
Function AlternateScreenExit() As String
```
เข้า/ออกจาก alternate screen buffer (สำหรับแอป fullscreen)

```xojo
Function MouseTrackingEnable() As String
Function MouseTrackingDisable() As String
```
เปิด/ปิด mouse tracking

```xojo
Function AutoWrapDisable() As String
Function AutoWrapEnable() As String
```
ปิด/เปิด automatic line wrapping

```xojo
Function BracketedPasteEnable() As String
Function BracketedPasteDisable() As String
```
เปิด/ปิด bracketed paste mode (เพื่อป้องกันการเรียกใช้บรรทัด ขณะวางข้อความ)

```xojo
Function SetTitle(title As String) As String
```
ตั้งชื่อของ terminal window/tab

```xojo
Function Hyperlink(url As String, text As String) As String
```
สร้าง hyperlink ที่ clickable ในบาง terminal

## การทำให้สะอาด (Strip & Analysis)

```xojo
Function StripCodes(text As String) As String
```
ลบ ANSI escape code ทั้งหมดออกจาก text และคืนข้อความธรรมชาติ

```xojo
Function VisibleLength(text As String) As Integer
```
คำนวณความยาว visual ของ text โดยไม่นับ ANSI code

## ค่าคงที่สี (Color Constants)

### สี Foreground (30-37)

```xojo
Const FG_BLACK = 30
Const FG_RED = 31
Const FG_GREEN = 32
Const FG_YELLOW = 33
Const FG_BLUE = 34
Const FG_MAGENTA = 35
Const FG_CYAN = 36
Const FG_WHITE = 37
```

### สี Foreground สว่าง (90-97)

```xojo
Const FG_BRIGHT_BLACK = 90
Const FG_BRIGHT_RED = 91
Const FG_BRIGHT_GREEN = 92
Const FG_BRIGHT_YELLOW = 93
Const FG_BRIGHT_BLUE = 94
Const FG_BRIGHT_MAGENTA = 95
Const FG_BRIGHT_CYAN = 96
Const FG_BRIGHT_WHITE = 97
```

### สี Background (40-47)

```xojo
Const BG_BLACK = 40
Const BG_RED = 41
Const BG_GREEN = 42
Const BG_YELLOW = 43
Const BG_BLUE = 44
Const BG_MAGENTA = 45
Const BG_CYAN = 46
Const BG_WHITE = 47
```

### สี Background สว่าง (100-107)

```xojo
Const BG_BRIGHT_BLACK = 100
Const BG_BRIGHT_RED = 101
Const BG_BRIGHT_GREEN = 102
Const BG_BRIGHT_YELLOW = 103
Const BG_BRIGHT_BLUE = 104
Const BG_BRIGHT_MAGENTA = 105
Const BG_BRIGHT_CYAN = 106
Const BG_BRIGHT_WHITE = 107
```

## ตัวอย่างการใช้งาน

### สร้าง Bold Red Text

```xojo
Var codes() As Integer = Array(1, 31) ' Bold, FG Red
Var seq As String = XjANSI.SGRMulti(codes)
Var text As String = seq + "Error!" + XjANSI.Reset()
XjTerminal.Write(text)
```

### เลื่อนเคอร์เซอร์และลบบรรทัด

```xojo
XjTerminal.Write(XjANSI.CursorUp(2) + XjANSI.EraseLine())
```

### RGB Color Foreground

```xojo
Var rgb As String = XjANSI.FGRGB(255, 128, 0) ' Orange
XjTerminal.Write(rgb + "Orange text" + XjANSI.DefaultFG())
```

## หมายเหตุการออกแบบ

XjANSI ผลิต escape sequence โครงสร้างที่ถูกต้อง แต่ไม่มีการ cache ตั้งแต่ลำดับ code นั้นสั้น ถ้าคุณต้อง emit code เดียวกันหลายครั้ง ลองเก็บผลลัพธ์ในตัวแปร เพื่อหลีกเลี่ยงการสร้าง string ซ้ำๆ
