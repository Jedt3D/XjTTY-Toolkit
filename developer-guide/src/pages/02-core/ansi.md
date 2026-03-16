---
title: ANSI Escape Codes
description: XjANSI module provides low-level ANSI escape code builders for terminal control, text styling, colors, cursor movement, and screen operations.
---

# ANSI Escape Codes

The **XjANSI** module builds ANSI escape sequences for low-level terminal control. These codes control colors, cursor position, screen clearing, mouse tracking, and more.

!!! note
    Most applications use higher-level abstractions (XjColor, XjCursor, XjScreen) instead of calling XjANSI directly. Use XjANSI when you need precise escape sequence control.

## Control Sequences

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `ESC()` | — | String | Returns ESC character (ASCII 27) |
| `CSI()` | — | String | Returns CSI prefix (ESC[) for cursor/screen control |
| `OSC()` | — | String | Returns OSC prefix (ESC]) for operating system command |
| `ST()` | — | String | Returns ST terminator (ESC\) for OSC sequences |
| `SGR(code)` | Integer | String | Select Graphic Rendition — returns complete SGR sequence |
| `Reset()` | — | String | Returns reset sequence (all attributes to default) |

## Text Styling

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Bold()` | — | String | Bold/bright text |
| `Dim()` | — | String | Dim/faint text |
| `Italic()` | — | String | Italic text |
| `Underline()` | — | String | Underlined text |
| `Blink()` | — | String | Blinking text (slow blink) |
| `FastBlink()` | — | String | Blinking text (rapid blink) |
| `Inverse()` | — | String | Swap foreground and background |
| `Strikethrough()` | — | String | Strikethrough text |
| `DoubleUnderline()` | — | String | Double underline |

## Colors

All color methods return SGR sequences that can be concatenated with text:

### Foreground Colors (8-color palette)

| Constant | Value | Color |
|----------|-------|-------|
| `FG_BLACK` | "30" | Black |
| `FG_RED` | "31" | Red |
| `FG_GREEN` | "32" | Green |
| `FG_YELLOW` | "33" | Yellow |
| `FG_BLUE` | "34" | Blue |
| `FG_MAGENTA` | "35" | Magenta |
| `FG_CYAN` | "36" | Cyan |
| `FG_WHITE` | "37" | White |

### Bright Foreground Colors

| Constant | Value | Color |
|----------|-------|-------|
| `FG_BRIGHT_BLACK` | "90" | Bright Black (Gray) |
| `FG_BRIGHT_RED` | "91" | Bright Red |
| `FG_BRIGHT_GREEN` | "92" | Bright Green |
| `FG_BRIGHT_YELLOW` | "93" | Bright Yellow |
| `FG_BRIGHT_BLUE` | "94" | Bright Blue |
| `FG_BRIGHT_MAGENTA` | "95" | Bright Magenta |
| `FG_BRIGHT_CYAN` | "96" | Bright Cyan |
| `FG_BRIGHT_WHITE` | "97" | Bright White |

### Background Colors (8-color palette)

| Constant | Value | Color |
|----------|-------|-------|
| `BG_BLACK` | "40" | Black background |
| `BG_RED` | "41" | Red background |
| `BG_GREEN` | "42" | Green background |
| `BG_YELLOW` | "43" | Yellow background |
| `BG_BLUE` | "44" | Blue background |
| `BG_MAGENTA` | "45" | Magenta background |
| `BG_CYAN` | "46" | Cyan background |
| `BG_WHITE` | "47" | White background |

### Bright Background Colors

| Constant | Value | Color |
|----------|-------|-------|
| `BG_BRIGHT_BLACK` | "100" | Bright Black background |
| `BG_BRIGHT_RED` | "101" | Bright Red background |
| `BG_BRIGHT_GREEN` | "102" | Bright Green background |
| `BG_BRIGHT_YELLOW` | "103" | Bright Yellow background |
| `BG_BRIGHT_BLUE` | "104" | Bright Blue background |
| `BG_BRIGHT_MAGENTA` | "105" | Bright Magenta background |
| `BG_BRIGHT_CYAN` | "106" | Bright Cyan background |
| `BG_BRIGHT_WHITE` | "107" | Bright White background |

### Advanced Color Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `FG256(code)` | Integer (0-255) | String | 256-color foreground |
| `BG256(code)` | Integer (0-255) | String | 256-color background |
| `FGRGB(r, g, b)` | Integer r, g, b (0-255) | String | True color (24-bit) foreground |
| `BGRGB(r, g, b)` | Integer r, g, b (0-255) | String | True color (24-bit) background |

## Cursor Movement

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `CursorUp(n)` | Integer | String | Move cursor up N lines |
| `CursorDown(n)` | Integer | String | Move cursor down N lines |
| `CursorForward(n)` | Integer | String | Move cursor right N columns |
| `CursorBack(n)` | Integer | String | Move cursor left N columns |
| `CursorNextLine(n)` | Integer | String | Move to beginning of next N lines |
| `CursorPrevLine(n)` | Integer | String | Move to beginning of previous N lines |
| `CursorHorizontalAbs(col)` | Integer | String | Move to column (1-based) |
| `CursorPosition(row, col)` | Integer row, col | String | Move to row and column (1-based) |
| `CursorHome()` | — | String | Move to home (1,1) |
| `SaveCursorPosition()` | — | String | Save cursor position |
| `RestoreCursorPosition()` | — | String | Restore cursor position |
| `GetCursorPosition()` | — | String | Query cursor position (CPR) |

## Erase Operations

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `EraseLine()` | — | String | Erase entire line |
| `EraseToEndOfLine()` | — | String | Erase from cursor to end of line |
| `EraseToStartOfLine()` | — | String | Erase from start of line to cursor |
| `EraseDisplay()` | — | String | Erase entire display |
| `EraseToEndOfDisplay()` | — | String | Erase from cursor to end of display |
| `EraseToStartOfDisplay()` | — | String | Erase from start of display to cursor |
| `ClearScrollback()` | — | String | Clear scrollback buffer |

## Screen Modes

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `EnterAlternateScreen()` | — | String | Switch to alternate screen buffer |
| `ExitAlternateScreen()` | — | String | Exit alternate screen buffer |
| `EnterRawMode()` | — | String | Disable line buffering (handled by XjTerminal) |
| `ExitRawMode()` | — | String | Restore line buffering (handled by XjTerminal) |
| `HideCursor()` | — | String | Hide text cursor |
| `ShowCursor()` | — | String | Show text cursor |
| `SetAutoWrap(enable)` | Boolean | String | Enable/disable automatic line wrapping |
| `SetBracketedPasteMode(enable)` | Boolean | String | Enable/disable bracketed paste mode |
| `SetMouseTracking(enable, mode)` | Boolean, Integer | String | Enable mouse tracking (0=normal, 1=any-event) |

## Utilities

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `StripCodes(text)` | String | String | Remove all ANSI codes from text |
| `VisibleLength(text)` | String | Integer | Return visible length (excluding ANSI codes) |

## Examples

### Basic colored output

```xojo
XjTerminal.Write(XjANSI.CSI() + XjANSI.FG_RED + "mRed text" + XjANSI.Reset())
```

### Styled output

```xojo
Var bold As String = XjANSI.Bold()
Var underline As String = XjANSI.Underline()
Var reset As String = XjANSI.Reset()
XjTerminal.Write(bold + underline + "Important" + reset)
```

### Cursor movement

```xojo
XjTerminal.Write(XjANSI.CursorHome())
XjTerminal.Write(XjANSI.EraseLine())
XjTerminal.Write("Start of line")
```

### RGB color

```xojo
Var orange As String = XjANSI.FGRGB(255, 165, 0)
XjTerminal.Write(orange + "Orange text" + XjANSI.Reset())
```

### Strip ANSI codes

```xojo
Var styled As String = XjColor.Red("Error") + " occurred"
Var plain As String = XjANSI.StripCodes(styled)
// plain = "Error occurred"
```

## Performance notes

ANSI methods are lightweight string builders. They concatenate escape codes without I/O. Actual terminal output happens via XjTerminal.Write().

For high-volume output, batch write operations together:

```xojo
Var output As String = XjANSI.CursorHome() + XjANSI.EraseDisplay() + content
XjTerminal.Write(output)
```
