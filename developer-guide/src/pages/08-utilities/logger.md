---
title: Logger
description: XjLogger provides structured colored logging with severity levels, timestamps, metadata, and JSON format.
---

# Logger

The **XjLogger** class provides structured logging with severity levels (Debug, Info, Warn, Error, Fatal), optional timestamps, metadata, and JSON export.

## Log Levels

| Constant | Value | Description |
|----------|-------|-------------|
| `LEVEL_DEBUG` | 0 | Debug information |
| `LEVEL_INFO` | 1 | General information |
| `LEVEL_WARN` | 2 | Warnings |
| `LEVEL_ERROR` | 3 | Error messages |
| `LEVEL_FATAL` | 4 | Fatal/critical errors |

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetLevel(level)` | Integer | — | Set minimum log level |
| `SetColor(enable)` | Boolean | — | Enable/disable color output |
| `SetJSON(enable)` | Boolean | — | Enable JSON format |
| `SetTimestamp(enable)` | Boolean | — | Show timestamps |
| `Debug(msg, meta)` | String, Dictionary | — | Log debug message |
| `Info(msg, meta)` | String, Dictionary | — | Log info message |
| `Warn(msg, meta)` | String, Dictionary | — | Log warning |
| `Error_(msg, meta)` | String, Dictionary | — | Log error |
| `Fatal(msg, meta)` | String, Dictionary | — | Log fatal error |

## Constructor

```xojo
Var logger As New XjLogger()
```

## Examples

### Basic logging

```xojo
Var logger As New XjLogger()
Call logger.SetLevel(XjLogger.LEVEL_INFO)
Call logger.SetColor(True)
Call logger.SetTimestamp(True)

Call logger.Debug("Debug info")
Call logger.Info("Application started")
Call logger.Warn("Deprecated API used")
Call logger.Error_("File not found")
Call logger.Fatal("Out of memory")
```

### Logging with metadata

```xojo
Var logger As New XjLogger()

Var meta As New Dictionary
Call meta.Value("user", "alice")
Call meta.Value("action", "login")
Call meta.Value("ip", "192.168.1.100")

Call logger.Info("User logged in", meta)
```

### JSON logging

```xojo
Var logger As New XjLogger()
Call logger.SetJSON(True)  // Output as JSON lines
Call logger.SetTimestamp(True)

Call logger.Info("Service started")

// Outputs:
// {"level":"info","message":"Service started","timestamp":"2024-01-15T10:30:45Z"}
```

### Log level filtering

```xojo
Var logger As New XjLogger()
Call logger.SetLevel(XjLogger.LEVEL_WARN)  // Only Warn, Error, Fatal

Call logger.Debug("This won't appear")
Call logger.Info("This won't appear")
Call logger.Warn("This will appear")
Call logger.Error_("This will appear")
```

### Structured error logging

```xojo
Var logger As New XjLogger()

Try
  DoSomething()
Catch err As Exception
  Var meta As New Dictionary
  Call meta.Value("error", err.Message)
  Call meta.Value("errorNumber", err.ErrorNumber)
  Call logger.Error_("Operation failed", meta)
End Try
```

### Request logging

```xojo
Var logger As New XjLogger()

Sub LogRequest(method As String, path As String, statusCode As Integer, duration As Integer)
  Var meta As New Dictionary
  Call meta.Value("method", method)
  Call meta.Value("path", path)
  Call meta.Value("status", statusCode)
  Call meta.Value("duration_ms", duration)

  Var msg As String = method + " " + path
  If statusCode >= 400 Then
    Call logger.Error_(msg, meta)
  Else
    Call logger.Info(msg, meta)
  End If
End Sub
```

### Multi-field structured logging

```xojo
Var logger As New XjLogger()
Call logger.SetJSON(True)

Var meta As New Dictionary
Call meta.Value("version", "1.0.0")
Call meta.Value("environment", "production")
Call meta.Value("hostname", GetHostName())
Call meta.Value("pid", GetProcessID())

Call logger.Info("Application started", meta)
```

## Output Formats

### Text format (default)

```
[2024-01-15 10:30:45] INFO: Service started
[2024-01-15 10:30:46] WARN: Deprecated API used
[2024-01-15 10:30:47] ERROR: Connection timeout
```

### JSON format

```json
{"level":"info","message":"Service started","timestamp":"2024-01-15T10:30:45Z"}
{"level":"warn","message":"Deprecated API used","timestamp":"2024-01-15T10:30:46Z"}
{"level":"error","message":"Connection timeout","timestamp":"2024-01-15T10:30:47Z"}
```

## Design notes

**Severity levels**: Set minimum level to filter out lower-priority messages. LEVEL_INFO is typical for production.

**Metadata**: Pass metadata as Dictionary for structured data. JSON format includes all metadata fields.

**Color output**: Colors make logs easier to scan. Disable for piping to files or CI/CD systems.

**Timestamps**: Timestamps help with debugging. Format is ISO 8601 (YYYY-MM-DDTHH:MM:SSZ).

**JSON format**: JSON output is suitable for log aggregation systems (ELK, Splunk, CloudWatch).

**Performance**: Logging below the set level has minimal overhead (messages are not formatted).

!!! note
    XjLogger is for application logging. For user-facing messages, use XjPrompt.Say(), Ok(), Warn(), Error_() instead.
