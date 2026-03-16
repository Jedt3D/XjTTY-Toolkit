---
title: Box & Text Widgets
description: XjBox is a container widget; XjText displays formatted text with word wrapping and scrolling.
---

# Box & Text Widgets

The **XjBox** widget is a container for grouping and styling child widgets. The **XjText** widget displays styled text with automatic word wrapping and vertical scrolling.

## XjBox

### Alignment Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `ALIGN_LEFT` | 0 | Left align content |
| `ALIGN_CENTER` | 1 | Center align content |
| `ALIGN_RIGHT` | 2 | Right align content |
| `VALIGN_TOP` | 0 | Top align content |
| `VALIGN_MIDDLE` | 1 | Vertically center content |
| `VALIGN_BOTTOM` | 2 | Bottom align content |

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetAlign(align)` | Integer | — | Set horizontal alignment |
| `SetVAlign(valign)` | Integer | — | Set vertical alignment |
| `SetFill(fillChar)` | String | — | Set background fill character |

### Semantic Constructors

| Method | Returns | Description |
|--------|---------|-------------|
| `Info()` | XjBox | Create info box (cyan background) |
| `Warning()` | XjBox | Create warning box (yellow background) |
| `Success()` | XjBox | Create success box (green background) |
| `Error_()` | XjBox | Create error box (red background) |

### Examples

```xojo
Var box As New XjBox()
Call box.SetWidth(XjConstraint.Fixed(40))
Call box.SetHeight(XjConstraint.Fixed(10))
Call box.SetAlign(XjBox.ALIGN_CENTER)
Call box.SetVAlign(XjBox.VALIGN_MIDDLE)

Var text As New XjText()
Call text.SetText("Centered content")
Call box.AddChild(text)
```

### Semantic boxes

```xojo
Var infoBox As XjBox = XjBox.Info()
Call infoBox.SetText("Information message")

Var errorBox As XjBox = XjBox.Error_()
Call errorBox.SetText("An error occurred")
```

## XjText

### Properties & Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetText(text)` | String | — | Set text content |
| `GetText()` | — | String | Get text content |
| `SetAlign(align)` | Integer (ALIGN_*) | — | Set text alignment |
| `SetWrap(wrap)` | Boolean | — | Enable/disable word wrapping |
| `SetScrollOffset(offset)` | Integer | — | Set scroll position (0-based line) |
| `GetScrollOffset()` | — | Integer | Get current scroll offset |
| `LineCount()` | — | Integer | Get total number of lines |

### Examples

```xojo
Var text As New XjText()
Call text.SetText("Hello World")
Call text.SetAlign(XjText.ALIGN_CENTER)
Call text.SetWrap(True)
```

### Scrolling text

```xojo
Var text As New XjText()
Call text.SetText("This is a very long text that will wrap...")
Call text.SetWrap(True)

// Scroll down 5 lines
Call text.SetScrollOffset(5)

// Get total lines
Var total As Integer = text.LineCount()
XjTerminal.Write("Showing " + total.ToString() + " lines")
```

### Multi-line styled text

```xojo
Var content As String = "Line 1" + EndOfLine + "Line 2" + EndOfLine + "Line 3"
Var text As New XjText()
Call text.SetText(content)
Call text.SetAlign(XjText.ALIGN_LEFT)
```

## Design notes

**XjBox children**: XjBox can contain any widgets. Use padding/margin for spacing.

**Text wrapping**: XjText.SetWrap(True) breaks long lines at word boundaries. False keeps lines intact.

**Scrolling**: SetScrollOffset() moves the visible window. LineCount() helps calculate scroll ranges.

**Alignment**: ALIGN_* controls horizontal; VALIGN_* controls vertical. Only meaningful if content is smaller than box.

**Fill character**: SetFill() sets background character (default: space). Use for backgrounds or decorative fills.

!!! note
    XjBox is purely layout/styling. To display text in a box, add an XjText widget as a child.
