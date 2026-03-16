---
title: UI Builder
description: XjUIParser builds widget trees from YAML UI definitions with automatic layout and styling.
---

# UI Builder

The **XjUIParser** module builds interactive widget trees from YAML markup, automatically handling layout, constraints, borders, and colors.

## Building

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Build(yaml)` | String | XjWidget | Build widget tree from YAML string |
| `BuildFromNode(node)` | XjYAMLNode | XjWidget | Build from parse tree |
| `DumpWidgetTree(widget)` | XjWidget | String | Debug: print widget hierarchy |

## Supported Widgets

| Widget | YAML Type | Description |
|--------|-----------|-------------|
| Box | `box` | Container with styling and alignment |
| Text | `text` | Display formatted text |
| TextInput | `input` | Single-line text field |
| Table | `table` | Tabular data display |
| ProgressBar | `progress` | Progress indicator |
| Spinner | `spinner` | Activity indicator |
| Tree | `tree` | Hierarchical tree display |

## Constraint Syntax

| Syntax | Example | Meaning |
|--------|---------|---------|
| `auto` | `width: auto` | Automatic sizing (content-based) |
| `NUMpx` or `NUM` | `width: 20` | Fixed 20 columns |
| `NUM%` | `width: 50%` | 50% of container |
| `MIN-MAX` | `width: 10-50` | Range: min 10, max 50 |

## Color & Alignment

| Property | Values | Example |
|----------|--------|---------|
| `color` | Color name or RGB | `color: red`, `color: #FF5733` |
| `bg_color` | Color name or RGB | `bg_color: blue` |
| `align` | left, center, right | `align: center` |
| `valign` | top, middle, bottom | `valign: middle` |

## Border Styles

| Style | Number | Appearance |
|-------|--------|-------------|
| single | 0 | ─ │ ┌ ┐ └ ┘ |
| double | 1 | ═ ║ ╔ ╗ ╚ ╝ |
| round | 2 | ─ │ ╭ ╮ ╰ ╯ |
| bold | 3 | ━ ┃ ┏ ┓ ┗ ┛ |
| ascii | 4 | \- \| + + + + |

## Examples

### Simple layout

```yaml
type: box
width: 100%
height: 100%
border: single
title: My App
children:
  - type: text
    text: "Welcome!"
    color: green
```

### Two-column layout

```yaml
type: box
width: 100%
height: 100%
direction: row
children:
  - type: box
    width: 30%
    height: 100%
    border: single
    title: Sidebar
    children:
      - type: text
        text: "Menu"
  - type: box
    width: 70%
    height: 100%
    border: double
    title: Content
    children:
      - type: text
        text: "Main area"
```

### Form with input fields

```yaml
type: box
width: 80
height: auto
border: single
title: Settings
padding: [1, 2, 1, 2]
children:
  - type: text
    text: "Name:"
  - type: input
    width: 40
    placeholder: "Enter your name"
  - type: text
    text: "Email:"
  - type: input
    width: 40
    placeholder: "user@example.com"
```

### Table display

```yaml
type: table
width: 100%
height: 20
headers: ["ID", "Name", "Status"]
rows:
  - ["1", "Task A", "Complete"]
  - ["2", "Task B", "Pending"]
  - ["3", "Task C", "Failed"]
show_border: true
border_style: single
```

### Progress display

```yaml
type: box
width: 50
height: 5
border: single
title: Download
children:
  - type: progress
    value: 65
    total: 100
    format: ":bar :percent"
```

### Tree structure

```yaml
type: tree
width: 40
height: 30
title: File Browser
root:
  label: "Project"
  expanded: true
  children:
    - label: "src"
      children:
        - label: "main.xojo"
        - label: "utils.xojo"
    - label: "docs"
      children:
        - label: "README.md"
```

## Building from Code

```xojo
Var uiYAML As String = _
  "type: box" + EndOfLine + _
  "width: 100%" + EndOfLine + _
  "height: 100%" + EndOfLine + _
  "border: single" + EndOfLine + _
  "title: Main Window" + EndOfLine + _
  "children:" + EndOfLine + _
  "  - type: text" + EndOfLine + _
  "    text: 'Hello, World!'" + EndOfLine + _
  "    color: green"

Var root As XjWidget = XjUIParser.Build(uiYAML)

// Now paint and interact with root
Var canvas As New XjCanvas(80, 24)
Call root.Paint(canvas)
XjTerminal.Write(canvas.Render())
```

## Debug Output

```xojo
Var widget As XjWidget = XjUIParser.Build(yaml)
Var debug As String = XjUIParser.DumpWidgetTree(widget)
XjPrompt.Say(debug)

// Output:
// XjBox (root)
//   ├─ XjText (title)
//   ├─ XjBox (sidebar)
//   │   └─ XjTextInput (name_input)
//   └─ XjBox (content)
//       └─ XjTable (data_table)
```

## Design notes

**Declarative**: YAML UI definition is declarative. The parser builds the widget tree automatically.

**Constraints**: Constraint syntax is flexible: auto, fixed, percentage, min-max.

**Direction**: Box direction is row (horizontal) or column (vertical). Default: column.

**Nesting**: Widgets can nest arbitrarily. Children are laid out according to parent direction.

**Colors**: Both named colors (red, green, blue, etc.) and RGB hex values are supported.

**Padding/Margin**: Specified as [top, right, bottom, left] array (all 4 values required).

**Border styles**: Use number 0-4 (single, double, round, bold, ascii) or style name.

!!! note
    XjUIParser is convenient for static UIs. For dynamic, data-driven interfaces, build widgets programmatically in Xojo code.
