---
title: Display Utilities
description: XjFont renders ASCII art text; XjPie draws horizontal bar charts; XjMarkdown renders formatted text.
---

# Display Utilities

Display-focused utilities for ASCII art rendering, bar charts, and markdown formatting.

## XjFont

Render text as ASCII art using a 5×5 block font.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Render(text)` | String | String() | Render text as ASCII art (5 lines) |

Supported characters: A-Z, 0-9, space, and basic punctuation.

### Example

```xojo
Var font As New XjFont()
Var lines As String() = font.Render("HELLO")

For Each line As String In lines
  XjPrompt.Say(line)
Next

// Output:
// ██╗  ██╗███████╗██╗     ██╗     ███████╗
// ██║  ██║██╔════╝██║     ██║     ██╔════╝
// ███████║█████╗  ██║     ██║     █████╗
// ██╔══██║██╔══╝  ██║     ██║     ██╔══╝
// ██║  ██║███████╗███████╗███████╗███████╗
```

### ASCII art title

```xojo
Var font As New XjFont()
Var title As String() = font.Render("APP")

For Each line As String In title
  XjTerminal.Write(XjColor.BoldText(line))
Next
```

## XjPie

Horizontal bar chart with colored segments and legend.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddSlice(label, value, color)` | String, Integer, String | — | Add data segment |
| `SetWidth(width)` | Integer | — | Set chart width |
| `Draw()` | — | String | Render chart |
| `Render()` | — | String | Alias for Draw() |

### Example

```xojo
Var chart As New XjPie()
Call chart.SetWidth(50)
Call chart.AddSlice("Python", 40, XjColor.Blue(""))
Call chart.AddSlice("JavaScript", 30, XjColor.Yellow(""))
Call chart.AddSlice("Go", 20, XjColor.Cyan(""))
Call chart.AddSlice("Rust", 10, XjColor.Red(""))

XjTerminal.Write(chart.Draw())
```

### Output

```
Python      ████████████████████ 40%
JavaScript  ██████████████ 30%
Go          ██████████ 20%
Rust        █████ 10%
```

## XjMarkdown

Render markdown-like syntax to formatted terminal output.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Render(text)` | String | String | Render markdown to ANSI text |

Supported syntax:
- Headers: `# Header`, `## Subheader`, etc.
- Bold: `**text**`
- Italic: `*text*`
- Code: `` `code` ``
- Lists: `- item`, `* item`
- Horizontal rules: `---`, `***`
- Block quotes: `> quote`

### Example

```xojo
Var markdown As String = "# Installation" + EndOfLine + _
  "Run `npm install` to set up." + EndOfLine + _
  "## Options" + EndOfLine + _
  "- Fast mode: `npm install --fast`" + EndOfLine + _
  "- Dev only: `npm install --save-dev`"

Var rendered As String = XjMarkdown.Render(markdown)
XjTerminal.Write(rendered)
```

### README formatting

```xojo
Var readme As String = "# MyProject" + EndOfLine + _
  "" + EndOfLine + _
  "A **fast** and *efficient* CLI tool." + EndOfLine + _
  "" + EndOfLine + _
  "## Getting Started" + EndOfLine + _
  "" + EndOfLine + _
  "1. Clone the repo" + EndOfLine + _
  "2. Run `build.sh`" + EndOfLine + _
  "3. Start using it" + EndOfLine + _
  "" + EndOfLine + _
  "> Note: Requires Python 3.8+"

XjTerminal.Write(XjMarkdown.Render(readme))
```

## Combined Example

### Rich dashboard display

```xojo
// Title
Var font As New XjFont()
Var title As String() = font.Render("STATS")
For Each line As String In title
  XjTerminal.Write(XjColor.BoldText(line))
Next

// Divider
XjTerminal.Write(XjColor.Muted("─────────────────────────────"))

// Chart
Var pie As New XjPie()
Call pie.AddSlice("Completed", 75, XjColor.Green(""))
Call pie.AddSlice("In Progress", 20, XjColor.Yellow(""))
Call pie.AddSlice("Pending", 5, XjColor.Red(""))
XjTerminal.Write(pie.Draw())

// Details (markdown)
Var details As String = "## Summary" + EndOfLine + _
  "- Total tasks: 100" + EndOfLine + _
  "- Success rate: **92%**" + EndOfLine + _
  "- Last updated: " + DateTime.Now.ToString()

XjTerminal.Write(XjMarkdown.Render(details))
```

## Design notes

**XjFont**: ASCII art rendering uses block characters. Results are 5 lines tall. Useful for titles and headers.

**XjPie**: Renders proportional bar chart. Width controls overall size. Totals don't need to equal 100.

**XjMarkdown**: Basic markdown support for documentation and help text. Not a full markdown parser.

**Performance**: All three utilities render quickly. Results are strings; no I/O overhead.

!!! note
    These utilities are for display/output. For structured data, use XjTable instead.
