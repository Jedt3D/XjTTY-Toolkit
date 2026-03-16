---
title: YAML Parser
description: XjYAML parses indentation-based YAML; XjYAMLNode provides typed access to parse tree.
---

# YAML Parser

The **XjYAML** module parses simple indentation-based YAML. The **XjYAMLNode** class represents the parse tree.

## Supported YAML Syntax

- **Mappings**: `key: value`
- **Sequences**: `- item`
- **Nesting**: Via indentation
- **Comments**: Lines starting with `#`
- **Strings**: Quoted (`"..."`, `'...'`) or unquoted
- **Numbers**: Integers and decimals
- **Booleans**: `true`, `false`, `yes`, `no`

## XjYAML

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Parse(yaml)` | String | XjYAMLNode | Parse YAML string to tree |

### Example

```xojo
Var yaml As String = "name: Alice" + EndOfLine + _
  "age: 30" + EndOfLine + _
  "hobbies:" + EndOfLine + _
  "  - reading" + EndOfLine + _
  "  - hiking"

Var root As XjYAMLNode = XjYAML.Parse(yaml)
```

## XjYAMLNode

Tree node with key/value/children access.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Key()` | — | String | Get node key |
| `Value()` | — | String | Get node value |
| `AddChild(child)` | XjYAMLNode | — | Add child node |
| `ChildCount()` | — | Integer | Get number of children |
| `ChildAt(index)` | Integer | XjYAMLNode | Get child by index (0-based) |
| `HasKey(key)` | String | Boolean | Check if child with key exists |
| `Child(key)` | String | XjYAMLNode | Get first child matching key |
| `StringValue()` | — | String | Get value as string |
| `IntValue()` | — | Integer | Get value as integer |
| `BoolValue()` | — | Boolean | Get value as boolean |
| `ChildrenWithKey(key)` | String | XjYAMLNode() | Get all children with key |
| `Dump()` | — | String | Return YAML representation |

### Example

```xojo
Var root As XjYAMLNode = XjYAML.Parse(configYAML)

Var name As String = root.Child("name").StringValue()
Var age As Integer = root.Child("age").IntValue()

Var hobbies As XjYAMLNode = root.Child("hobbies")
For i As Integer = 0 To hobbies.ChildCount() - 1
  Var hobby As String = hobbies.ChildAt(i).StringValue()
  XjPrompt.Say(hobby)
Next
```

## Examples

### Parse configuration

```xojo
Var configYAML As String = _
  "database:" + EndOfLine + _
  "  host: localhost" + EndOfLine + _
  "  port: 5432" + EndOfLine + _
  "  name: myapp" + EndOfLine + _
  "server:" + EndOfLine + _
  "  host: 0.0.0.0" + EndOfLine + _
  "  port: 8080" + EndOfLine + _
  "  ssl: true"

Var root As XjYAMLNode = XjYAML.Parse(configYAML)

Var dbHost As String = root.Child("database").Child("host").StringValue()
Var dbPort As Integer = root.Child("database").Child("port").IntValue()
Var serverPort As Integer = root.Child("server").Child("port").IntValue()
```

### Parse list of objects

```xojo
Var yaml As String = _
  "users:" + EndOfLine + _
  "  - name: Alice" + EndOfLine + _
  "    role: admin" + EndOfLine + _
  "  - name: Bob" + EndOfLine + _
  "    role: user"

Var root As XjYAMLNode = XjYAML.Parse(yaml)
Var users As XjYAMLNode = root.Child("users")

For i As Integer = 0 To users.ChildCount() - 1
  Var user As XjYAMLNode = users.ChildAt(i)
  Var name As String = user.Child("name").StringValue()
  Var role As String = user.Child("role").StringValue()
  XjPrompt.Say(name + " (" + role + ")")
Next
```

### Query nested values

```xojo
Var root As XjYAMLNode = XjYAML.Parse(yaml)

// Check if key exists before accessing
If root.HasKey("database") Then
  Var db As XjYAMLNode = root.Child("database")
  Var host As String = db.Child("host").StringValue()
Else
  XjPrompt.Warn("Database config not found")
End If
```

### Dump node back to YAML

```xojo
Var root As XjYAMLNode = XjYAML.Parse(originalYAML)
Var yamlOutput As String = root.Dump()
XjPrompt.Say(yamlOutput)
```

## YAML Format Examples

### Simple mapping

```yaml
name: Alice
age: 30
active: true
```

### Nested mapping

```yaml
database:
  host: localhost
  port: 5432
  credentials:
    user: admin
    password: secret
```

### Sequence

```yaml
items:
  - apple
  - banana
  - cherry
```

### Complex structure

```yaml
application:
  name: MyApp
  version: 1.0.0
  servers:
    - name: web1
      host: 10.0.1.1
      port: 8080
    - name: web2
      host: 10.0.1.2
      port: 8080
  features:
    - auth
    - caching
    - logging
```

## Design notes

**Indentation-based**: YAML uses spaces (not tabs) for indentation. Consistency is required.

**Comments**: Lines starting with `#` are ignored.

**Type inference**: Values are strings by default. Use IntValue()/BoolValue() for type conversion.

**Key access**: Child(key) returns the first matching child. ChildrenWithKey() returns all matches.

**Sequences**: Sequences are nodes with multiple children (no key). Access via ChildAt() indexing.

**Dump**: Dump() reconstructs YAML from the parse tree. Format may differ from input but content is equivalent.

!!! note
    XjYAML is a simple parser for basic YAML. It doesn't support all YAML features (anchors, aliases, flow syntax). For complex YAML, consider external parsers.
