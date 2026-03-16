---
title: UI Builder
description: XjUIParser module สำหรับแปลง YAML เป็น widget tree
---

# UI Builder (XjUIParser)

**XjUIParser** build widget tree จาก YAML text — declarative UI definition แทน programmatic construction

## XjUIParser Module

### Main Functions

```xojo
Function Build(yamlText As String) As XjWidget
```
Parse YAML และ build widget tree — คืน root widget

```xojo
Function BuildFromNode(node As XjYAMLNode) As XjWidget
```
Build widget tree จาก XjYAMLNode (ถ้า already parsed)

### Debug

```xojo
Sub DumpWidgetTree(widget As XjWidget, indent As Integer = 0)
```
พิมพ์ widget hierarchy สำหรับ debug

## YAML Widget Schema

### box - Container

```yaml
- type: box
  title: "Optional Title"
  border: single
  border_color: blue
  padding: "1,2,1,2"
  margin: "1,1,1,1"
  align: center
  valign: middle
  width: "100%"
  height: auto
  children:
    - type: text
      text: "Content"
```

### text - Display Text

```yaml
- type: text
  text: "Display text"
  align: left
  wrap: true
  width: "100%"
  height: auto
```

### textinput/input - Single-line Input

```yaml
- type: textinput
  placeholder: "Enter text..."
  label: "Name:"
  max_length: 50
  mask: "*"
  width: 30
```

### table - Data Table

```yaml
- type: table
  headers: ["Name", "Age", "City"]
  rows:
    - ["Alice", "30", "NYC"]
    - ["Bob", "25", "LA"]
  show_header: true
  show_border: true
  width: "100%"
```

### progressbar/progress - Progress Bar

```yaml
- type: progressbar
  value: 50
  total: 100
  format: ":bar :percent"
  bar_width: 30
```

### spinner - Spinner/Loader

```yaml
- type: spinner
  format: dots
  message: "Loading..."
  interval: 8
```

## Property Parsing

### Constraints (width, height)

```yaml
width: auto              # Auto-size
width: 20               # Fixed 20 pixels
width: "50%"            # 50% of parent
width: "20-100"         # Fixed 20, min 20, max 100
```

### Border Styles

```yaml
border: none            # No border
border: single          # Single line
border: double          # Double line
border: round           # Rounded corners
border: bold            # Bold lines
border: ascii           # ASCII characters
```

### Alignment

```yaml
align: left
align: center
align: right

valign: top
valign: middle
valign: bottom
```

### Colors

```yaml
border_color: black
border_color: 31           # ANSI color code 31 (red)
border_color: "rgb(255,0,0)" # RGB color
```

### Padding & Margin

```yaml
padding: "1,2,1,2"        # top, right, bottom, left
padding: 1                # All sides = 1
margin: "2,2,2,2"
```

## ตัวอย่างการใช้งาน

### Simple Layout

```xojo
Var yaml As String = "- type: box\n" + _
  "  title: \"Main\"\n" + _
  "  children:\n" + _
  "    - type: text\n" + _
  "      text: \"Hello, World!\"\n"

Var root As XjWidget = XjUIParser.Build(yaml)
```

### Form with Inputs

```yaml
- type: box
  title: "Registration"
  border: single
  padding: "1,2,1,2"
  children:
    - type: textinput
      label: "Name:"
      placeholder: "John Doe"
    - type: textinput
      label: "Email:"
      placeholder: "user@example.com"
    - type: textinput
      label: "Password:"
      mask: "*"
```

### Dashboard with Multiple Sections

```yaml
- type: box
  title: "Dashboard"
  border: double
  children:
    - type: box
      title: "Status"
      align: center
      width: "50%"
      children:
        - type: progressbar
          value: 75
          total: 100
          format: ":bar :percent"
    - type: box
      title: "Data"
      width: "50%"
      children:
        - type: table
          headers: ["Item", "Count"]
          rows:
            - ["Requests", "1024"]
            - ["Errors", "12"]
```

### Activity with Spinner

```yaml
- type: box
  title: "Processing"
  children:
    - type: spinner
      format: dots
      message: "Uploading files..."
      interval: 8
```

## Build and Use

```xojo
Var yaml As String = File.ReadTextFile("app.yaml")
Var root As XjWidget = XjUIParser.Build(yaml)

Var canvas As New XjCanvas(80, 24)
XjLayoutSolver.Solve(root.LayoutNode(), 80, 24)
root.Paint(canvas)
XjTerminal.Write(canvas.Render())
```

## Limitations

- YAML ต้องเป็น array ของ widgets (top-level `-`)
- ไม่รองรับ event binding หรือ dynamic content
- Declarative layout เท่านั้น — ไม่มี logic

## หมายเหตุการออกแบบ

XjUIParser convert YAML tree เป็น widget tree — 1:1 mapping ระหว่าง YAML node และ widget

Constraints ใช้ simple string format แทน explicit nested objects

Colors ใช้ named color หรือ ANSI codes หรือ RGB

DumpWidgetTree() helpful สำหรับ debug — แสดง widget hierarchy และ layout properties
