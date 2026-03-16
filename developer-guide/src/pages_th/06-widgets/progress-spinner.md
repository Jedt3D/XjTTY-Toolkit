---
title: ProgressBar และ Spinner
description: XjProgressBar สำหรับแสดงความก้าวหน้า XjSpinner สำหรับแสดงกิจกรรมที่ทำงาน
---

# ProgressBar และ Spinner

## XjProgressBar

**XjProgressBar** แสดง linear progress bar พร้อมการ format custom (percent, ETA, current/total)

### Constructor

```xojo
Sub New()
```
สร้าง progress bar ว่างเปล่า

### Values

```xojo
Sub SetValue(value As Integer)
Sub SetTotal(total As Integer)
Function Value() As Integer
Function Total() As Integer
```
ตั้ง/ดึง current value และ total (100%)

### Progress Calculation

```xojo
Function Percent() As Integer
```
คำนวณ percent (value / total * 100)

```xojo
Function IsComplete() As Boolean
```
ตรวจสอบว่า value >= total

```xojo
Sub Advance(amount As Integer)
```
เพิ่ม amount ให้กับ value

```xojo
Sub Reset()
```
รีเซ็ต value เป็น 0

### Formatting

```xojo
Sub SetFormat(format As String)
```
ตั้งค่า format string โดยใช้ tokens:
- `:bar` — progress bar visual
- `:percent` — current percent (0-100)
- `:current` — current value
- `:total` — total value
- `:eta` — estimated time remaining (milliseconds)

```xojo
Sub SetBarWidth(width As Integer)
```
ตั้งค่า width ของ bar (characters)

### Characters & Styling

```xojo
Sub SetFilledChar(char As String)
Sub SetEmptyChar(char As String)
Sub SetHeadChar(char As String)
Function FilledChar() As String
Function EmptyChar() As String
Function HeadChar() As String
```
ตั้ง/ดึง characters สำหรับ filled, empty, head ของ bar

```xojo
Sub SetFilledStyle(style As XjStyle)
Sub SetEmptyStyle(style As XjStyle)
Function FilledStyle() As XjStyle
Function EmptyStyle() As XjStyle
```
ตั้ง/ดึง styles สำหรับ filled/empty portions

### Indeterminate (Pulse)

```xojo
Sub SetIndeterminate(indeterminate As Boolean)
Function IsIndeterminate() As Boolean
```
ตั้ง/ดึง indeterminate mode (pulse animation เมื่อ total ไม่รู้)

## XjSpinner

**XjSpinner** แสดง animated spinner/loading indicator พร้อมข้อความ

### Constructor

```xojo
Sub New()
```
สร้าง spinner ว่างเปล่า

### Format/Animation

```xojo
Sub SetFormat(formatName As String)
```
เลือก animation format:
- "dots" — ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏
- "dots2" — ⣾⣽⣻⢿⡿⣟⣯⣷
- "dots3" — ⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓
- "line" — ─\|/
- "arc" — ◜◠◝◞◡◟
- "star" — ✶✸✹✺✹✷
- "bounce" — ⠁⠂⠄⠂
- "arrow" — ←↖↑↗→↘↓↙
- "clock" — 🕐🕑🕒🕓🕔🕕🕖🕗
- "moon" — ◑◐◒◓
- "bar" — ▁▃▄▅▆▇█▇▆▅▄▃
- "blocks" — ▖▘▝▗

```xojo
Sub SetFrames(frames() As String)
```
ตั้งค่า custom frames array

### Speed

```xojo
Sub SetInterval(ticks As Integer)
```
ตั้งค่า interval (ticks) ระหว่าง frames (lower = faster)

### Message

```xojo
Sub SetMessage(message As String)
Function Message() As String
```
ตั้ง/ดึง message แสดงตัดสินใจถัดจาก spinner

### Styling

```xojo
Sub SetSpinnerStyle(style As XjStyle)
Sub SetMessageStyle(style As XjStyle)
Function SpinnerStyle() As XjStyle
Function MessageStyle() As XjStyle
```
ตั้ง/ดึง styles สำหรับ spinner และ message

### Success/Error Marks

```xojo
Sub SetSuccessMark(mark As String)
Sub SetErrorMark(mark As String)
```
ตั้งค่า mark ที่แสดงเมื่อ Success() หรือ Error_() ถูกเรียก

```xojo
Sub Success(message As String)
Sub Error_(message As String)
```
แสดง success/error mark และข้อความ, หยุด animation

```xojo
Function IsRunning() As Boolean
```
ตรวจสอบว่า spinner กำลัง animate

## ตัวอย่างการใช้งาน

### Progress Bar พื้นฐาน

```xojo
Var bar As New XjProgressBar
bar.SetTotal(100)
bar.SetFormat(":bar :percent")

For i As Integer = 0 To 100
  bar.SetValue(i)
  ' Render and display
  Wait(50) ' milliseconds
Wend
```

### Progress Bar พร้อม ETA

```xojo
Var bar As New XjProgressBar
bar.SetTotal(50)
bar.SetFormat("Downloading :current/:total (:eta)")

Var start As UInt64 = System.Ticks
For i As Integer = 1 To 50
  bar.SetValue(i)
  Var elapsed As UInt64 = System.Ticks - start
  ' Update ETA calculation
Wend
```

### Indeterminate Progress

```xojo
Var bar As New XjProgressBar
bar.SetIndeterminate(True)
bar.SetFormat(":bar Loading...")
' Animate without knowing total
```

### Spinner พื้นฐาน

```xojo
Var spinner As New XjSpinner
spinner.SetFormat("dots")
spinner.SetMessage("Processing...")
spinner.SetInterval(8)
' Animate each tick
```

### Spinner พร้อม Success

```xojo
Var spinner As New XjSpinner
spinner.SetFormat("dots")
spinner.SetMessage("Uploading...")
spinner.SetSuccessMark("✓")

' Later:
spinner.Success("Upload complete!")
```

### Custom Spinner Animation

```xojo
Var spinner As New XjSpinner
spinner.SetFrames(Array("◐", "◓", "◑", "◒"))
spinner.SetInterval(10)
spinner.SetMessage("Custom animation")
```

## หมายเหตุการออกแบบ

XjProgressBar ต้องเรียก Advance() หรือ SetValue() บ่อยเพื่อให้ render ทันสมัย

XjSpinner ต้องเรียก HandleTick() ใน event loop เพื่อให้ animate — ไม่ต้องเรียก SetValue() เอง

Progress bar format string ใช้ simple token replacement — ไม่มี conditional logic แต่เพียงแค่ concatenate parts

Indeterminate mode ใช้สำหรับ operations ที่ไม่รู้ total (เช่น network I/O) — pulse back & forth indefinitely
