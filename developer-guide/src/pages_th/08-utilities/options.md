---
title: CLI Options
description: XjOption class สำหรับ argument parser ที่สร้าง auto-generated help text
---

# CLI Options (XjOption)

**XjOption** เป็น argument parser สำหรับ command-line applications — define options (--flag), flags (boolean), arguments (positional), จากนั้น parse command-line args และ auto-generate help text

## Constructor

```xojo
Sub New(appName As String = "", appDescription As String = "")
```
สร้าง option parser ด้วย app name และ description

## Adding Arguments

### Options (--flag value)

```xojo
Sub AddOption(name As String, short As String, long As String, description As String, default As String = "")
```
เพิ่ม option ที่รับค่า (เช่น --host localhost)

ตัวอย่าง:
```
AddOption("host", "h", "host", "Database host", "localhost")
```
ใช้: `--host 192.168.1.1` หรือ `-h 192.168.1.1`

### Flags (boolean)

```xojo
Sub AddFlag(name As String, short As String, long As String, description As String)
```
เพิ่ม flag ที่ boolean (เช่น --verbose)

ตัวอย่าง:
```
AddFlag("verbose", "v", "verbose", "Enable verbose output")
```
ใช้: `--verbose` หรือ `-v`

### Arguments (positional)

```xojo
Sub AddArgument(name As String, description As String, required As Boolean = False)
```
เพิ่ม positional argument (ไม่มี prefix)

ตัวอย่าง:
```
AddArgument("command", "Command to run", True)
AddArgument("file", "Input file", False)
```
ใช้: `program start input.txt`

## Parsing

```xojo
Sub Parse(args() As String)
```
Parse command-line args array

## Getting Values

```xojo
Function GetString(name As String, default As String = "") As String
```
ดึง option value เป็น string

```xojo
Function GetFlag(name As String) As Boolean
```
ดึง flag value (True ถ้า flag ถูกกำหนด)

```xojo
Function GetInteger(name As String, default As Integer = 0) As Integer
```
ดึง option value เป็น integer

```xojo
Function Has(name As String) As Boolean
```
ตรวจสอบว่า option/argument ถูกกำหนด

## Help

```xojo
Function Help() As String
```
สร้าง auto-generated help text พร้อมทั้ง options, flags, arguments

```xojo
Sub PrintHelp()
```
พิมพ์ help ไปยัง terminal

## ตัวอย่างการใช้งาน

### Simple CLI Tool

```xojo
Var opts As New XjOption("mytool", "A tool for something")
opts.AddOption("output", "o", "output", "Output file", "result.txt")
opts.AddFlag("verbose", "v", "verbose", "Enable verbose output")
opts.AddArgument("input", "Input file", True)

Var args() As String = CommandLine.Split
opts.Parse(args)

Var input As String = opts.GetString("input")
Var output As String = opts.GetString("output")
Var verbose As Boolean = opts.GetFlag("verbose")

If verbose Then
  XjPrompt.Say("Processing: " + input)
End If
```

### Server Configuration

```xojo
Var opts As New XjOption("server", "Web server")
opts.AddOption("host", "h", "host", "Listen address", "0.0.0.0")
opts.AddOption("port", "p", "port", "Listen port", "8080")
opts.AddOption("workers", "w", "workers", "Worker threads", "4")
opts.AddFlag("ssl", "s", "ssl", "Enable SSL")
opts.AddFlag("debug", "d", "debug", "Debug mode")

opts.Parse(CommandLine.Split())

Var host As String = opts.GetString("host")
Var port As Integer = opts.GetInteger("port")
Var workers As Integer = opts.GetInteger("workers")
Var ssl As Boolean = opts.GetFlag("ssl")
```

### File Processing

```xojo
Var opts As New XjOption("processor", "Process files")
opts.AddArgument("input", "Input file path", True)
opts.AddArgument("output", "Output file path", False)
opts.AddOption("format", "f", "format", "Output format", "json")
opts.AddFlag("compress", "z", "compress", "Compress output")
opts.AddFlag("verify", "", "verify", "Verify after processing")

opts.Parse(CommandLine.Split())

Var input As String = opts.GetString("input")
Var output As String = opts.GetString("output", "output.json")
Var format As String = opts.GetString("format")
Var compress As Boolean = opts.GetFlag("compress")

' Process file...
```

### Help Text Generation

```xojo
Var opts As New XjOption("tool", "Description of tool")
opts.AddOption("config", "c", "config", "Config file path")
opts.AddFlag("help", "h", "help", "Show this help message")

Var helpText As String = opts.Help()
XjTerminal.Write(helpText)

' Output:
' Usage: tool [options] [arguments]
' Description of tool
'
' Options:
'   -c, --config <value>    Config file path
'   -h, --help             Show this help message
```

## Usage Pattern

```
Usage: program [options] [arguments]
Examples:
  program --verbose input.txt
  program -o output.txt -f json input.txt
```

## หมายเหตุการออกแบบ

AddOption สร้าง option ที่รับค่า (flag + argument)

AddFlag สร้าง boolean flag (ตัวอักษรหรือ long option)

AddArgument สร้าง positional argument (ต้อง required ก่อน optional)

GetString/GetInteger/GetFlag ส่งคืนค่าเสมอ — ใช้ default ถ้าไม่ได้กำหนด

Has() ตรวจสอบว่า option ถูกกำหนด — ใช้เพื่อ required arguments

Help() auto-generate help text จาก definition ทั้งหมด
