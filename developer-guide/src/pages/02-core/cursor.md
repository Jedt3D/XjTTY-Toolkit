---
title: Cursor
description: XjCursor module provides cursor movement, visibility control, and position queries for terminal applications.
---

# Cursor

The **XjCursor** module handles cursor positioning, movement, and visibility in the terminal. All methods return ANSI escape sequences.

## Movement

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `MoveTo(row, col)` | Integer row, col | String | Move cursor to row and column (1-based) |
| `MoveUp(n)` | Integer | String | Move cursor up N lines |
| `MoveDown(n)` | Integer | String | Move cursor down N lines |
| `MoveLeft(n)` | Integer | String | Move cursor left N columns |
| `MoveRight(n)` | Integer | String | Move cursor right N columns |
| `MoveToColumn(col)` | Integer | String | Move to column within current line (1-based) |
| `NextLine(n)` | Integer | String | Move to start of next N lines |
| `PrevLine(n)` | Integer | String | Move to start of previous N lines |
| `Home()` | — | String | Move to top-left corner (1,1) |
| `MoveRelative(dx, dy)` | Integer dx, dy | String | Move relative to current position |

## Visibility

| Method | Return Type | Description |
|--------|------------|-------------|
| `Show()` | String | Make cursor visible |
| `Hide()` | String | Hide cursor |

## Position

| Method | Return Type | Description |
|--------|------------|-------------|
| `GetPosition()` | String | Query cursor position (returns CPR escape sequence; requires raw mode) |

## Position Saving

| Method | Return Type | Description |
|--------|------------|-------------|
| `Save()` | String | Save current cursor position |
| `Restore()` | String | Restore previously saved position |

## Examples

### Simple cursor movement

```xojo
// Move to column 10 on current line
XjTerminal.Write(XjCursor.MoveToColumn(10))
XjTerminal.Write("Start here")

// Move up 2 lines, then right 5 columns
XjTerminal.Write(XjCursor.MoveUp(2) + XjCursor.MoveRight(5))
```

### Save and restore position

```xojo
// Save current position
XjTerminal.Write(XjCursor.Save())

// Write progress indicator at specific location
XjTerminal.Write(XjCursor.MoveTo(10, 50))
XjTerminal.Write("Progress: 50%")

// Return to saved position
XjTerminal.Write(XjCursor.Restore())
```

### Hide cursor during output

```xojo
XjTerminal.Write(XjCursor.Hide())

Try
  // Your drawing/output code
  For i As Integer = 1 To 100
    XjTerminal.Write("Line " + i.ToString())
  Next
Finally
  XjTerminal.Write(XjCursor.Show())
End Try
```

### Hide cursor for full-screen apps

```xojo
XjTerminal.Write(XjCursor.Hide())

Try
  Var loop As New XjEventLoop(50)
  loop.Run(Me)
Finally
  XjTerminal.Write(XjCursor.Show())
End Try
```

### Navigate to specific locations

```xojo
// Clear screen and position at center
Var width As Integer = XjTerminal.Width()
Var height As Integer = XjTerminal.Height()
Var centerCol As Integer = width \ 2
Var centerRow As Integer = height \ 2

XjTerminal.Write(XjScreen.Clear())
XjTerminal.Write(XjCursor.MoveTo(centerRow, centerCol))
XjTerminal.Write("Centered text")
```

### Cursor movement with relative positioning

```xojo
// Move down 3 lines, right 10 columns
XjTerminal.Write(XjCursor.MoveRelative(10, 3))

// Or use absolute positioning
XjTerminal.Write(XjCursor.MoveTo(5, 15))
```

### Multi-line prompt with cursor control

```xojo
XjTerminal.Write("Enter your name: ")
Var nameStart As String = XjCursor.Save()

XjTerminal.Write("(Hint: First and Last)")
XjTerminal.Write(XjCursor.MoveLeft(20)) // Adjust for prompt length

' User enters name here
Var name As String = "John Doe"
XjTerminal.Write(XjCursor.Restore())
```

## Design notes

**Coordinate system**: All cursor methods use 1-based coordinates (row 1, column 1 is top-left). This matches ANSI escape sequence conventions.

**String concatenation**: All methods return escape sequences that can be concatenated with text and other escape sequences:

```xojo
Var combined As String = XjCursor.Home() + XjScreen.Clear() + "Ready"
XjTerminal.Write(combined)
```

**Position queries**: GetPosition() is advanced. It sends a CPR (Cursor Position Report) query and requires raw mode to read the response. Use it cautiously in interactive applications.

**Visible positioning**: MoveTo() immediately positions the cursor. The text you write appears at that location, without explicit cursor movement between lines.

!!! note
    The XjCursor module only returns escape sequences. Actual cursor movement happens when XjTerminal.Write() sends the sequences to the terminal.
