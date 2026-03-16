---
title: YAML Parser
description: XjYAML module สำหรับ parse indentation-based YAML และ XjYAMLNode parse tree
---

# YAML Parser (XjYAML & XjYAMLNode)

**XjYAML** เป็น lightweight indentation-based YAML parser (ไม่เป็น spec-compliant แต่ cover common cases)

**XjYAMLNode** แทน node ของ parse tree — key/value/children

## XjYAML Module

### Function

```xojo
Function Parse(text As String) As XjYAMLNode
```
Parse YAML string — คืน root node

## XjYAMLNode Class

### Constructor

```xojo
Sub New(key As String = "", value As String = "")
```
สร้าง YAML node

### Properties

```xojo
Function Key() As String
Function Value() As String
```
ดึง key และ value

### Children

```xojo
Sub AddChild(node As XjYAMLNode)
Function ChildCount() As Integer
Function ChildAt(index As Integer) As XjYAMLNode
```
จัดการ child nodes

### Lookup

```xojo
Function HasKey(key As String) As Boolean
Function Child(key As String) As XjYAMLNode
```
ค้นหา child โดยชื่อ key

```xojo
Function ChildrenWithKey(key As String) As XjYAMLNode()
```
ดึงทั้งหมด children ที่มี key เดียว (สำหรับ duplicate keys)

### Type Accessors (ดึง typed values)

```xojo
Function StringValue(key As String, default As String = "") As String
Function IntValue(key As String, default As Integer = 0) As Integer
Function BoolValue(key As String, default As Boolean = False) As Boolean
```
ดึง value เป็น string/integer/boolean

### Display

```xojo
Function Dump(indent As Integer = 0) As String
```
สร้าง string representation ของ node และ children (สำหรับ debug)

## YAML Syntax Supported

```yaml
# Comments
key: value
nested:
  child_key: child_value
  another: test
list:
  - item 1
  - item 2
  - item 3
multi_key: value1
multi_key: value2    # Duplicate keys
```

## ตัวอย่างการใช้งาน

### Parse Simple YAML

```xojo
Var yaml As String = "host: localhost\nport: 5432\ndebug: true"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

Var host As String = root.StringValue("host")
Var port As Integer = root.IntValue("port")
Var debug As Boolean = root.BoolValue("debug")
```

### Parse Nested Structure

```xojo
Var yaml As String = "database:\n  host: localhost\n  port: 5432\n  name: myapp"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

Var dbNode As XjYAMLNode = root.Child("database")
If dbNode <> Nil Then
  Var host As String = dbNode.StringValue("host")
  Var port As Integer = dbNode.IntValue("port")
End If
```

### Parse List

```xojo
Var yaml As String = "servers:\n  - host1.com\n  - host2.com\n  - host3.com"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

Var serversNode As XjYAMLNode = root.Child("servers")
If serversNode <> Nil Then
  For i As Integer = 0 To serversNode.ChildCount() - 1
    Var server As XjYAMLNode = serversNode.ChildAt(i)
    XjTerminal.Write(server.Value())
  Wend
End If
```

### Access Typed Values

```xojo
Var yaml As String = "count: 42\nenabled: false\nname: app"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

Var count As Integer = root.IntValue("count") ' 42
Var enabled As Boolean = root.BoolValue("enabled") ' False
Var name As String = root.StringValue("name") ' "app"
```

### Handle Missing Keys

```xojo
Var root As XjYAMLNode = XjYAML.Parse("name: test")

' Missing key returns default
Var port As Integer = root.IntValue("port", 8080) ' 8080
Var debug As Boolean = root.BoolValue("debug", True) ' True
```

### Duplicate Keys

```xojo
Var yaml As String = "rule: allow\nrule: deny"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

Var rules() As XjYAMLNode = root.ChildrenWithKey("rule")
For i As Integer = 0 To rules.LastRowIndex
  XjTerminal.Write(rules(i).Value())
Wend
' Output: allow, deny
```

### Debug Output

```xojo
Var yaml As String = "app:\n  name: MyApp\n  version: 1.0"
Var root As XjYAMLNode = XjYAML.Parse(yaml)

XjTerminal.Write(root.Dump())
' Output:
' root:
'   app:
'     name: MyApp
'     version: 1.0
```

## YAML Limitations

- Indentation-based เท่านั้น (ไม่รองรับ quoted strings, special types)
- Comments ต้องเป็นบรรทัดเดียว (#)
- ไม่รองรับ anchors, aliases
- Duplicate keys เก็บเป็น children ที่แยก (ไม่ override)

## หมายเหตุการออกแบบ

XjYAML parser ง่าย ไม่ได้ YAML spec-compliant — ออกแบบมาสำหรับ config files เท่านั้น

Indentation ต้องเป็น 2 space หรือ tab — ไม่ support mixed

StringValue/IntValue/BoolValue ทำ type conversion อัตโนมัติ

Duplicate keys เก็บเป็น multiple children ที่มี key เดียว — ใช้ ChildrenWithKey() เพื่อดึงทั้งหมด

XjUIParser ใช้ XjYAML เพื่อ parse UI definition YAML
