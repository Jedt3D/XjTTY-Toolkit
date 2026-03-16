---
title: Logger
description: XjLogger class สำหรับการบันทึกข้อมูล structured colored logging พร้อม levels และ JSON output
---

# Logger (XjLogger)

**XjLogger** บันทึก messages พร้อม level (DEBUG, INFO, WARN, ERROR, FATAL), timestamp, colors, และ JSON formatting ช่วยให้ debug application ได้ง่ายขึ้น

## Constructor

```xojo
Sub New(name As String = "")
```
สร้าง logger ด้วย optional name (ใช้สำหรับ identification ใน output)

## Configuration

```xojo
Sub SetLevel(level As Integer)
Function Level() As Integer
```
ตั้ง/ดึง minimum log level (LEVEL_DEBUG, LEVEL_INFO, LEVEL_WARN, LEVEL_ERROR, LEVEL_FATAL)

```xojo
Sub SetColor(useColor As Boolean)
Function ColorEnabled() As Boolean
```
เปิด/ปิด colored output

```xojo
Sub SetJSON(useJSON As Boolean)
Function JSONEnabled() As Boolean
```
เปิด/ปิด JSON formatting

```xojo
Sub SetTimestamp(showTimestamp As Boolean)
Function TimestampEnabled() As Boolean
```
เปิด/ปิด timestamp ใน output

## Logging Methods

```xojo
Sub Debug(message As String, metadata As String = "")
Sub Info(message As String, metadata As String = "")
Sub Warn(message As String, metadata As String = "")
Sub Error_(message As String, metadata As String = "")
Sub Fatal(message As String, metadata As String = "")
```
บันทึก message ในระดับ level ต่างๆ พร้อม optional metadata

## Log Level Constants

```xojo
Const LEVEL_DEBUG = 0
Const LEVEL_INFO = 1
Const LEVEL_WARN = 2
Const LEVEL_ERROR = 3
Const LEVEL_FATAL = 4
```

## ตัวอย่างการใช้งาน

### Simple Logging

```xojo
Var logger As New XjLogger("MyApp")
logger.SetLevel(XjLogger.LEVEL_INFO)

logger.Info("Application started")
logger.Warn("Low memory warning")
logger.Error_("Failed to connect to server")
```

### Logging พร้อม Metadata

```xojo
Var logger As New XjLogger("Database")
logger.Info("Connected to database", "host=localhost port=5432")
logger.Warn("Slow query detected", "duration=2500ms query_id=123")
logger.Error_("Connection timeout", "retry_count=3")
```

### JSON Logging

```xojo
Var logger As New XjLogger("API")
logger.SetJSON(True)
logger.SetColor(False)

logger.Info("Request received", "method=POST path=/api/users status=201")
' Output: {"level":"info","logger":"API","message":"Request received",...}
```

### Log Levels

```xojo
Var logger As New XjLogger("App")
logger.SetLevel(XjLogger.LEVEL_WARN)

logger.Debug("Debug info") ' Skipped (below WARN)
logger.Info("Info message") ' Skipped (below WARN)
logger.Warn("Warning!")     ' Logged
logger.Error_("Error!")     ' Logged
```

### Colored Output

```xojo
Var logger As New XjLogger("MyApp")
logger.SetColor(True)
logger.SetTimestamp(True)

logger.Debug("Debug: " + result)    ' Cyan
logger.Info("Starting...")          ' Green
logger.Warn("Deprecated feature")   ' Yellow
logger.Error_("Connection failed")  ' Red
logger.Fatal("Unrecoverable error") ' Bold Red
```

### No Timestamp

```xojo
Var logger As New XjLogger("Server")
logger.SetTimestamp(False)

logger.Info("Started")
logger.Info("Ready")
' Output: (no timestamp prefix)
```

## Output Format

Default format:
```
[TIMESTAMP] [LEVEL] [LOGGER] MESSAGE
```

JSON format:
```json
{
  "timestamp": "2026-03-13T10:30:45Z",
  "level": "info",
  "logger": "MyApp",
  "message": "Application started",
  "metadata": "version=1.0"
}
```

## หมายเหตุการออกแบบ

XjLogger ใช้ XjColor ภายใน สำหรับสี — DEBUG=cyan, INFO=green, WARN=yellow, ERROR=red, FATAL=bold red

SetLevel() ล็ต filter logs ในการ runtime — Debug logs ไม่ output ถ้า level >= INFO

Metadata ใช้สำหรับ contextual info — key=value pairs, comma-separated

JSON mode ยังคงใช้ metadata เป็น string (ไม่ parse เป็น JSON object) — ใช้สำหรับ structured logging tools
