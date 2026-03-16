---
title: Command, Pager, History และอื่นๆ
description: XjCommand สำหรับ shell execution, XjPager สำหรับ content paging, XjWhich/XjHistory
---

# Command, Pager, History

## XjCommand Module

ประมวลผลคำสั่ง shell พร้อม timeout, capture output

### Functions

```xojo
Function Run(command As String, timeout As Integer = 30) As XjCommandResult
```
รัน shell command — block จนกว่าสำเร็จ หรือ timeout — คืน XjCommandResult

```xojo
Function RunSilent(command As String, timeout As Integer = 30) As Integer
```
รัน command แต่ไม่แสดง output — คืน exit code

```xojo
Function Capture(command As String, timeout As Integer = 30) As String
```
รัน command และ capture output — คืน output string

```xojo
Function Success(command As String, timeout As Integer = 30) As Boolean
```
รัน command — คืน True ถ้า exit code = 0

```xojo
Sub DryRun(command As String)
```
พิมพ์ command ที่จะรันโดยไม่ execute

```xojo
Sub RunWithPrinter(command As String, timeout As Integer = 30)
```
รัน command และพิมพ์ output แบบ real-time

## XjCommandResult Class

```xojo
Property Output As String      ' Command output
Property ExitCode As Integer   ' Exit code (0 = success)
Property TimedOut As Boolean   ' True if timeout
```

### Methods

```xojo
Function IsSuccess() As Boolean
```
คืน True ถ้า ExitCode = 0 และไม่ timeout

```xojo
Function Lines() As String()
```
ส่งคืน output ที่แบ่งเป็น array ของ lines

## XjWhich Module

ค้นหา executables ใน PATH

### Functions

```xojo
Function Which(name As String) As String
```
ค้นหา executable path — คืน full path หรือ empty string

```xojo
Function WhichAll(name As String) As String()
```
ค้นหาทั้งหมด executable instances บน PATH

```xojo
Function Exists(name As String) As Boolean
```
ตรวจสอบว่า executable มีในระบบ

## XjHistory Class

ป้อนข้อมูล history บ้าน navigation (arrow up/down)

### Constructor

```xojo
Sub New(maxSize As Integer = 100)
```
สร้าง history ด้วย max entries

### Operations

```xojo
Sub Add(entry As String)
```
เพิ่ม entry ไปยัง history

```xojo
Function Previous(currentValue As String) As String
```
ดึง previous entry — ถ้า current value ไม่ match current position, reset ไปยัง end

```xojo
Function Next_(currentValue As String) As String
```
ดึง next entry

```xojo
Sub Clear()
Sub Reset()
```
ล้าง history หรือ reset navigation pointer

```xojo
Function Count() As Integer
```
ดึงจำนวน entries

```xojo
Function IsNavigating() As Boolean
```
ตรวจสอบว่า currently navigating history (ไม่อยู่ที่ end)

## XjPager Class

Built-in pager สำหรับ display content ที่อาจยาว

### Constructor

```xojo
Sub New()
```
สร้าง pager

### Configuration

```xojo
Sub SetPageSize(lines As Integer)
```
ตั้งค่า page size (number of lines ต่อ page)

### Display

```xojo
Sub Page(content As String)
```
Display content เป็น pages — space/Enter ต่อไป, q quit

```xojo
Function Render() As String
```
คืน rendered output ของ pager (เฉพาะ current page)

## ตัวอย่างการใช้งาน

### Run Command and Capture

```xojo
Var result As XjCommandResult = XjCommand.Run("ls -la", 10)
If result.IsSuccess() Then
  XjTerminal.Write(result.Output)
Else
  XjPrompt.Error_("Command failed")
End If
```

### Run Silently

```xojo
Var exitCode As Integer = XjCommand.RunSilent("make build")
If exitCode = 0 Then
  XjPrompt.Ok("Build successful")
Else
  XjPrompt.Error_("Build failed")
End If
```

### Capture Output

```xojo
Var output As String = XjCommand.Capture("git status")
XjTerminal.Write(output)
```

### Check Command Success

```xojo
If XjCommand.Success("ping -c 1 8.8.8.8", 5) Then
  XjPrompt.Ok("Internet connection OK")
Else
  XjPrompt.Warn("No internet")
End If
```

### Find Executable

```xojo
If XjWhich.Exists("git") Then
  Var gitPath As String = XjWhich.Which("git")
  XjTerminal.Write("Git: " + gitPath)
Else
  XjPrompt.Error_("Git not found")
End If
```

### Input History

```xojo
Var history As New XjHistory(50)
history.Add("select * from users")
history.Add("select count(*) from orders")

' Later
Var prev As String = history.Previous("select")
XjTerminal.Write(prev) ' select count(*) from orders
```

### Pager for Long Content

```xojo
Var pager As New XjPager
pager.SetPageSize(20) ' 20 lines per page

Var content As String = "Line 1\nLine 2\n..." ' 100+ lines
pager.Page(content)
' Display first 20 lines, space/Enter for next page
```

## หมายเหตุการออกแบบ

XjCommand ใช้ shell-specific implementation — Windows = cmd.exe, Unix = /bin/sh

Timeout ในวินาทีเท่านั้น — ใช้สำหรับ prevent hanging commands

RunWithPrinter() stream output real-time — ใช้สำหรับ long-running commands

XjWhich ค้นหา executable บน PATH environment variable

XjHistory เก็บ strings เท่านั้น — ไม่มี execution หรือ formatting

XjPager useful สำหรับแสดง help, logs, large output — ช่วยให้ผู้ใช้ navigate บน terminal
