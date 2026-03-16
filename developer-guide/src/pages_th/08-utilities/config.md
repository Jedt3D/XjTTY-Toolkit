---
title: Configuration
description: XjConfig class สำหรับจัดเก็บ key-value config พร้อม file I/O และ environment override
---

# Configuration (XjConfig)

**XjConfig** จัดเก็บ key-value configuration — load/save ไป text file, override ด้วย environment variables

## Constructor

```xojo
Sub New()
```
สร้าง config dictionary ว่างเปล่า

## Setting & Getting Values

```xojo
Sub Set(key As String, value As String)
Function Get(key As String, default As String = "") As String
Function Has(key As String) As Boolean
Sub Remove(key As String)
```
ตั้ง/ดึง/ตรวจสอบ/ลบ key-value pair

## Type Conversions

```xojo
Function GetInteger(key As String, default As Integer = 0) As Integer
Function GetBoolean(key As String, default As Boolean = False) As Boolean
```
ดึง value เป็น integer/boolean

## List Operations

```xojo
Function Count() As Integer
Function Keys() As String()
```
ดึงจำนวนและ list ของทั้งหมด keys

## Environment Variables

```xojo
Sub SetEnvPrefix(prefix As String)
```
ตั้งค่า prefix สำหรับ environment variable override

ตัวอย่าง: prefix="APP_" -> APP_DATABASE_HOST override "database_host"

## File I/O

```xojo
Sub LoadFromFile(path As String)
```
โหลด config จาก text file (key=value format, line-by-line)

```xojo
Sub SaveToFile(path As String)
```
บันทึก config ไป text file

## Merging

```xojo
Sub Merge(other As XjConfig)
```
merge ค่าจาก XjConfig อื่น (overwrite existing keys)

## ตัวอย่างการใช้งาน

### Simple Config

```xojo
Var config As New XjConfig
config.Set("database_host", "localhost")
config.Set("database_port", "5432")
config.Set("database_name", "myapp")

Var host As String = config.Get("database_host")
Var port As String = config.Get("database_port")
```

### Type Conversion

```xojo
Var config As New XjConfig
config.Set("port", "8080")
config.Set("debug", "true")

Var port As Integer = config.GetInteger("port") ' 8080
Var debug As Boolean = config.GetBoolean("debug") ' True
```

### Load from File

```xojo
Var config As New XjConfig
config.LoadFromFile("/etc/myapp/config.conf")

' config.conf:
' database_host=localhost
' database_port=5432
' database_name=myapp
' debug=false

Var host As String = config.Get("database_host")
```

### Environment Override

```xojo
Var config As New XjConfig
config.LoadFromFile("config.conf")
config.SetEnvPrefix("MYAPP_")

' Now MYAPP_DATABASE_HOST env var overrides "database_host" from file
Var host As String = config.Get("database_host")
```

### Save Config

```xojo
Var config As New XjConfig
config.Set("api_key", "secret123")
config.Set("log_level", "info")

config.SaveToFile("user_config.conf")
' Creates file with key=value pairs
```

### Merge Configs

```xojo
Var defaults As New XjConfig
defaults.Set("timeout", "30")
defaults.Set("retries", "3")

Var user As New XjConfig
user.LoadFromFile("~/.myapp.conf")

defaults.Merge(user) ' User config overrides defaults
```

### Check Keys

```xojo
Var config As New XjConfig
config.Set("feature_a", "enabled")
config.Set("feature_b", "disabled")

If config.Has("feature_a") Then
  ' Feature enabled
End If

Var allKeys() As String = config.Keys()
For Each key As String In allKeys
  XjPrompt.Say(key + ": " + config.Get(key))
Wend
```

## Config File Format

```
database_host=localhost
database_port=5432
database_name=myapp
debug=false
api_timeout=30
log_level=info
features=feature1,feature2
```

## Environment Variable Pattern

```bash
# Set in shell
export MYAPP_DATABASE_HOST=prod.example.com
export MYAPP_DEBUG=false

# In code
config.SetEnvPrefix("MYAPP_")
config.Set("database_host", "localhost")
# Result: "prod.example.com" (from env var, not from Set)
```

## หมายเหตุการออกแบบ

LoadFromFile() อ่าน text file บรรทัด-ต่อบรรทัด โดยคาดหวัง key=value format

SaveToFile() เขียน text file ในรูป key=value

SetEnvPrefix() ทำให้ environment variables override loaded config — ใช้สำหรับ deploy-time overrides (production ไม่ต้องแก้ไข config file)

GetInteger/GetBoolean ทำ type conversion อัตโนมัติ — ถ้า parse fail ใช้ default

Merge() ยินดีออก overwrite — ตัวแรกคือ base, ตัวที่สองคือ override
