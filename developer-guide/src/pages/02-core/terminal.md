---
title: Terminal Control
description: XjTerminal module provides raw mode I/O, terminal size detection, color support, mouse tracking, and alternate screen management.
---

# Terminal Control

The **XjTerminal** module handles low-level terminal I/O, raw mode setup, and platform-specific terminal operations. It abstracts away termios (Unix) vs Win32 API differences.

## Raw Mode

Raw mode disables line buffering and allows character-by-character input with immediate processing.

| Method | Return Type | Description |
|--------|------------|-------------|
| `EnableRawMode()` | — | Enable raw mode (non-blocking, non-buffered input) |
| `DisableRawMode()` | — | Disable raw mode (restore canonical input) |
| `IsRawMode()` | Boolean | Return whether raw mode is currently enabled |

## Terminal Dimensions

| Method | Return Type | Description |
|--------|------------|-------------|
| `Width()` | Integer | Terminal width in columns |
| `Height()` | Integer | Terminal height in rows |
| `GetSize(byref width, byref height)` | — | Get both dimensions (more efficient) |

## Color Support

| Method | Return Type | Description |
|--------|------------|-------------|
| `SupportsColor()` | Boolean | Return True if terminal supports color |
| `ColorDepth()` | Integer | Return color depth (1=mono, 8=16 colors, 256=256 colors, 16777216=24-bit RGB) |

## I/O Operations

| Method | Parameters | Return Type | Description |
|--------|-----------|------------|-------------|
| `ReadByte()` | — | Integer | Read single byte (-1 if no data available) |
| `Write(text)` | String | — | Write text to terminal |
| `Flush()` | — | — | Flush output buffer |
| `EnableNonBlockingInput()` | — | — | Make ReadByte() non-blocking |

## Alternate Screen

The alternate screen buffer allows full-screen applications to manage display without affecting scrollback history.

| Method | Return Type | Description |
|--------|------------|-------------|
| `EnterAlternateScreen()` | — | Switch to alternate screen buffer |
| `ExitAlternateScreen()` | — | Exit alternate screen buffer and restore previous |
| `IsAlternateScreenActive()` | Boolean | Return True if alternate screen is active |

## Mouse Tracking

| Method | Parameters | Return Type | Description |
|--------|-----------|------------|-------------|
| `EnableMouseTracking()` | — | — | Enable mouse event reporting |
| `DisableMouseTracking()` | — | — | Disable mouse event reporting |

## Examples

### Safe raw mode usage

```xojo
XjTerminal.EnableRawMode()
Try
  // Read keyboard input byte-by-byte
  Var b As Integer = XjTerminal.ReadByte()
  // Process byte...
Finally
  XjTerminal.DisableRawMode()
End Try
```

### Detect terminal capabilities

```xojo
If Not XjTerminal.SupportsColor() Then
  XjColor.DisableColors()
End If

Select Case XjTerminal.ColorDepth()
  Case 1
    XjTerminal.Write("Monochrome terminal")
  Case 8, 16
    XjTerminal.Write("16-color terminal")
  Case 256
    XjTerminal.Write("256-color terminal")
  Case Else
    XjTerminal.Write("True color (24-bit) terminal")
End Select
```

### Full-screen application

```xojo
XjTerminal.EnableRawMode()
XjTerminal.EnterAlternateScreen()
XjTerminal.EnableNonBlockingInput()
XjTerminal.EnableMouseTracking()

Try
  // Your full-screen app loop
  Var loop As New XjEventLoop(50) // 50ms ticks
  loop.Run(Me)
Finally
  XjTerminal.DisableMouseTracking()
  XjTerminal.ExitAlternateScreen()
  XjTerminal.DisableRawMode()
End Try
```

### Monitor terminal resize

```xojo
Var width As Integer
Var height As Integer
Var prevWidth As Integer = -1
Var prevHeight As Integer = -1

While Not shouldExit
  XjTerminal.GetSize(width, height)
  If width <> prevWidth Or height <> prevHeight Then
    XjTerminal.Write("Terminal resized: " + width.ToString() + "x" + height.ToString())
    prevWidth = width
    prevHeight = height
  End If
  // ... continue processing
Wend
```

### Conditional coloring

```xojo
If XjTerminal.SupportsColor() Then
  XjTerminal.Write(XjColor.Green("Success!"))
Else
  XjTerminal.Write("[OK] Success!")
End If
```

## Design notes

**Auto-recovery**: XjEventLoop automatically manages raw mode and alternate screen cleanup if an exception occurs.

**Cross-platform**: Platform detection (XjPlatform) automatically selects termios on Unix or Win32 API on Windows. No manual setup required.

**Non-blocking input**: EnableNonBlockingInput() is required for event loops that poll keyboard without blocking. Disable it when not needed (restores standard blocking behavior).

!!! warning
    Always pair EnableRawMode() with DisableRawMode() in a Try/Finally block. Leaving raw mode enabled will disable terminal editing for subsequent programs.
