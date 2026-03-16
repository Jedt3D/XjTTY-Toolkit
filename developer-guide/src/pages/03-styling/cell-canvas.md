---
title: Cell & Canvas
description: XjCell represents styled characters; XjCanvas is a 2D grid for composable rendering with diff updates and box drawing support.
---

# Cell & Canvas

The **XjCell** class represents a single character with style. The **XjCanvas** class is a 2D grid of cells for composable rendering with automatic diff updates and professional box-drawing.

## XjCell

A cell is a character + style pair.

### Constructor

```xojo
Var cell As New XjCell()
Var styledCell As New XjCell("A", boldRedStyle)
```

### Properties & Methods

| Method | Parameter | Returns | Description |
|--------|-----------|---------|-------------|
| `Char()` | — | String | Get character (single Unicode char) |
| `SetChar(c)` | String | — | Set character |
| `Style()` | — | XjStyle | Get style |
| `SetStyle(style)` | XjStyle | — | Set style |
| `Set(char, style)` | String, XjStyle | — | Set both character and style |
| `Reset()` | — | — | Clear to space with default style |
| `Equals(other)` | XjCell | Boolean | Compare cells |
| `Clone()` | — | XjCell | Create independent copy |
| `Render()` | — | String | Render cell as styled ANSI string |

### Example

```xojo
Var cell As New XjCell()
Call cell.SetChar("X")
Call cell.SetStyle(XjStyle.Danger())

XjTerminal.Write(cell.Render())
```

## XjCanvas

A canvas is a 2D grid of styled cells with diff-based rendering and professional box drawing.

### Constructor

```xojo
Var canvas As New XjCanvas(width, height)
```

### Dimensions

| Method | Returns | Description |
|--------|---------|-------------|
| `Width()` | Integer | Grid width in columns |
| `Height()` | Integer | Grid height in rows |
| `Size()` | Integer | Total cell count (width × height) |

### Cell Operations

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Cell(row, col)` | Integer row, col | XjCell | Get cell at position (1-based) |
| `SetCell(row, col, cell)` | Integer row, col; XjCell | — | Set cell at position |
| `SetChar(row, col, char)` | Integer row, col; String | — | Set character at position (keep style) |
| `SetStyle(row, col, style)` | Integer row, col; XjStyle | — | Set style at position (keep char) |
| `Clear()` | — | — | Clear all cells to space |
| `ClearRect(row, col, w, h)` | Integer row, col, w, h | — | Clear rectangle |

### Text Operations

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `WriteText(row, col, text)` | Integer row, col; String | — | Write plain text (no wrapping) |
| `WriteTextStyled(row, col, text, style)` | Integer row, col; String; XjStyle | — | Write text with uniform style |
| `WriteTextWrapped(row, col, text, maxWidth, style)` | Integer row, col; String; Integer; XjStyle | — | Write text with word wrapping |

### Region Operations

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Fill(row, col, w, h, char, style)` | Integer row, col, w, h; String; XjStyle | — | Fill rectangle with character and style |
| `Blit(sourceCanvas, fromRow, fromCol, toRow, toCol, w, h)` | XjCanvas; Integer × 6 | — | Copy rectangle from another canvas |
| `Snapshot()` | — | String | Return complete canvas as string |

### Box Drawing

Canvas supports 5 box-drawing styles:

| Style | Constant | Characters | Appearance |
|-------|----------|-----------|-------------|
| Single | `BORDER_SINGLE` (0) | ─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ | Traditional single line |
| Double | `BORDER_DOUBLE` (1) | ═ ║ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬ | Heavy double line |
| Round | `BORDER_ROUND` (2) | ─ │ ╭ ╮ ╰ ╯ ├ ┤ ┬ ┴ ┼ | Rounded corners |
| Bold | `BORDER_BOLD` (3) | ━ ┃ ┏ ┓ ┗ ┛ ┣ ┫ ┳ ┻ ╋ | Heavy/bold lines |
| ASCII | `BORDER_ASCII` (4) | \- \| + + + + \+ \+ \+ \+ \+ | ASCII-only fallback |

### Box Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `DrawBox(row, col, w, h, style)` | Integer row, col, w, h; Integer style | — | Draw hollow box outline |
| `DrawHLine(row, col, length, style)` | Integer row, col, length; Integer style | — | Draw horizontal line |
| `DrawVLine(row, col, length, style)` | Integer row, col, length; Integer style | — | Draw vertical line |
| `DrawFilled(row, col, w, h, borderStyle, bgStyle)` | Integer row, col, w, h; Integer, XjStyle | — | Draw filled box |

### Rendering

| Method | Returns | Description |
|--------|---------|-------------|
| `Render()` | String | Full render (clear screen + absolute positioning) |
| `DiffRender(previous)` | String | Diff render (only changed cells) |
| `ToString()` | String | String representation for debugging |

## Examples

### Build and render a canvas

```xojo
Var canvas As New XjCanvas(40, 10)

// Write content
Call canvas.WriteTextStyled(1, 1, "Welcome", XjStyle.Success())
Call canvas.WriteTextStyled(3, 1, "Enter your name:", XjStyle.Info())

// Draw a box
Call canvas.DrawBox(5, 1, 30, 3, XjCanvas.BORDER_SINGLE)

// Render to screen
XjTerminal.Write(canvas.Render())
```

### Use different box styles

```xojo
Var canvas As New XjCanvas(50, 20)

// Single-line box
Call canvas.DrawBox(1, 1, 15, 5, XjCanvas.BORDER_SINGLE)
Call canvas.WriteTextStyled(2, 3, "Single", XjStyle.Default())

// Double-line box
Call canvas.DrawBox(1, 20, 15, 5, XjCanvas.BORDER_DOUBLE)
Call canvas.WriteTextStyled(2, 22, "Double", XjStyle.Default())

// Rounded corners
Call canvas.DrawBox(8, 1, 15, 5, XjCanvas.BORDER_ROUND)
Call canvas.WriteTextStyled(9, 3, "Rounded", XjStyle.Default())

XjTerminal.Write(canvas.Render())
```

### Fill region with background color

```xojo
Var canvas As New XjCanvas(30, 10)

// Create background style
Var bgStyle As New XjStyle
Call bgStyle.SetBG(47)  // White background

// Fill header area
Call canvas.Fill(1, 1, 30, 2, " ", bgStyle)
Call canvas.WriteTextStyled(1, 2, "Application Title", XjStyle.Default())

XjTerminal.Write(canvas.Render())
```

### Copy region between canvases

```xojo
Var src As New XjCanvas(10, 10)
Call src.WriteTextStyled(1, 1, "Source", XjStyle.Success())

Var dst As New XjCanvas(20, 20)
Call dst.Blit(src, 1, 1, 5, 5, 10, 10)

XjTerminal.Write(dst.Render())
```

### Multi-line text with wrapping

```xojo
Var canvas As New XjCanvas(30, 10)

Var longText As String = "This is a long piece of text that needs to be wrapped at word boundaries."
Call canvas.WriteTextWrapped(1, 1, longText, 28, XjStyle.Default())

XjTerminal.Write(canvas.Render())
```

### Diff rendering for animation

```xojo
Var canvas As New XjCanvas(40, 20)
Var prevOutput As String = ""

For frame As Integer = 1 To 100
  Call canvas.Clear()
  Call canvas.WriteTextStyled(10, 20, "Frame: " + frame.ToString(), XjStyle.Info())

  Var output As String = canvas.DiffRender(prevOutput)
  XjTerminal.Write(output)
  prevOutput = output
Next
```

## Design notes

**1-based coordinates**: All canvas methods use 1-based row/column indexing.

**Immutable cells**: Cell modification creates new cell objects. Use SetChar() or SetStyle() to modify canvas content.

**Diff rendering**: DiffRender() only updates cells that changed since the last render, reducing flicker and improving performance. For smooth animation, save the previous output and pass it:

```xojo
Var prev As String = ""
While True
  prev = canvas.DiffRender(prev)
  XjTerminal.Write(prev)
End While
```

**Box drawing**: Box methods automatically select appropriate corners and intersections. Choose BORDER_ASCII for maximum compatibility with limited terminals.

**Text wrapping**: WriteTextWrapped() respects word boundaries. Text is wrapped at spaces; lines are not hyphenated.

!!! note
    Canvas uses absolute positioning (CursorMoveTo commands) in Render() output. This enables placing the canvas anywhere on screen without pre-clearing the display.
