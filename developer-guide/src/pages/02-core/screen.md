---
title: Screen
description: XjScreen module provides screen clearing, scrolling, fullscreen mode, and drawing primitives for terminal output.
---

# Screen

The **XjScreen** module handles screen operations like clearing, scrolling, fullscreen mode, and drawing basic shapes. All methods return ANSI escape sequences.

## Clearing

| Method | Returns | Description |
|--------|---------|-------------|
| `Clear()` | String | Clear entire screen and move cursor to home (1,1) |
| `ClearLine()` | String | Clear current line |
| `ClearToEnd()` | String | Erase from cursor to end of display |
| `ClearToStart()` | String | Erase from start of display to cursor |
| `ClearBelow()` | String | Erase from cursor to end of line and all lines below |
| `ClearAbove()` | String | Erase from start of line to cursor and all lines above |
| `ClearLines(count)` | String | Clear N lines from current position downward |

## Scrolling

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `ScrollUp(lines)` | Integer | String | Scroll display up N lines |
| `ScrollDown(lines)` | Integer | String | Scroll display down N lines |

## Screen Dimensions

| Method | Returns | Description |
|--------|---------|-------------|
| `Width()` | Integer | Terminal width in columns |
| `Height()` | Integer | Terminal height in rows |
| `SetTitle(text)` | String | Set terminal window title |

## Fullscreen Mode

| Method | Returns | Description |
|--------|---------|-------------|
| `EnterFullscreen()` | String | Enter fullscreen mode (alternate screen buffer) |
| `ExitFullscreen()` | String | Exit fullscreen mode |

## Drawing Primitives

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `WriteAt(row, col, text)` | Integer row, col; String text | String | Write text at specific position |
| `DrawHorizontalLine(row, col, length, char)` | Integer row, col, length; String char | String | Draw horizontal line |
| `DrawVerticalLine(row, col, length, char)` | Integer row, col, length; String char | String | Draw vertical line |
| `FillRect(row, col, width, height, char)` | Integer row, col, width, height; String char | String | Fill rectangle with character |

## Examples

### Clear and home

```xojo
// Standard clear
XjTerminal.Write(XjScreen.Clear())

// Clear and explicitly return to home
XjTerminal.Write(XjScreen.Clear() + XjCursor.Home())
```

### Partial clearing

```xojo
// Clear from current position to end
XjTerminal.Write(XjScreen.ClearToEnd())

// Clear only current line
XjTerminal.Write(XjCursor.MoveToColumn(1) + XjScreen.ClearLine())
```

### Terminal dimensions

```xojo
Var width As Integer = XjScreen.Width()
Var height As Integer = XjScreen.Height()

XjTerminal.Write("Terminal: " + width.ToString() + "x" + height.ToString())
```

### Fullscreen application

```xojo
XjTerminal.Write(XjScreen.EnterFullscreen())

Try
  // Your fullscreen app
  Var loop As New XjEventLoop(50)
  loop.Run(Me)
Finally
  XjTerminal.Write(XjScreen.ExitFullscreen())
End Try
```

### Set window title

```xojo
XjTerminal.Write(XjScreen.SetTitle("My App v1.0"))
```

### Write at specific location

```xojo
// Position and write without moving cursor between
XjTerminal.Write(XjScreen.WriteAt(5, 10, "Text here"))
```

### Draw simple box

```xojo
// Draw border using characters
Var top As String = XjScreen.WriteAt(1, 1, "+---+")
Var left As String = XjScreen.WriteAt(2, 1, "|")
Var right As String = XjScreen.WriteAt(2, 5, "|")
Var bottom As String = XjScreen.WriteAt(3, 1, "+---+")

XjTerminal.Write(top + left + right + bottom)
```

### Fill rectangle

```xojo
// Fill 10x5 rectangle with spaces at position (3, 5)
XjTerminal.Write(XjScreen.FillRect(3, 5, 10, 5, " "))

// Then write content over it
XjTerminal.Write(XjScreen.WriteAt(5, 7, "Content"))
```

### Scroll content

```xojo
// Scroll up 3 lines
XjTerminal.Write(XjScreen.ScrollUp(3))

// Write new content
XjTerminal.Write("New line at bottom")
```

### Progress indicator update

```xojo
// Save position, update progress, restore
XjTerminal.Write(XjCursor.Save())
XjTerminal.Write(XjScreen.WriteAt(1, 1, "Progress: 50%     "))
XjTerminal.Write(XjCursor.Restore())
```

### Partition screen into zones

```xojo
Var w As Integer = XjScreen.Width()
Var h As Integer = XjScreen.Height()

// Header zone: top 3 rows
XjTerminal.Write(XjScreen.WriteAt(1, 1, "HEADER".PadRight(w)))

// Content zone: middle rows
For row As Integer = 4 To h - 2
  XjTerminal.Write(XjScreen.WriteAt(row, 1, "Content line"))
Next

// Footer zone: bottom 2 rows
XjTerminal.Write(XjScreen.WriteAt(h - 1, 1, "FOOTER".PadRight(w)))
```

## Design notes

**String concatenation**: All methods return escape sequences that can be combined:

```xojo
Var setup As String = XjScreen.Clear() + XjCursor.Home() + XjScreen.SetTitle("App")
XjTerminal.Write(setup)
```

**Coordinate system**: Uses 1-based coordinates (row 1, column 1 is top-left), matching terminal conventions.

**Fullscreen pattern**: Always pair EnterFullscreen() with ExitFullscreen() in a Try/Finally block to restore the previous screen state.

!!! warning
    On some terminals, entering fullscreen mode may disable the scrollback buffer. Be careful when using fullscreen for long-running applications that need to preserve history.

**Box drawing**: For professional-looking boxes, use XjCanvas instead, which handles box-drawing characters automatically.
