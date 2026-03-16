---
title: Input Reader
description: XjReader class parses VT100/xterm escape sequences for keyboard and mouse input in raw mode.
---

# Input Reader

The **XjReader** class reads and parses terminal input sequences. It handles VT100/xterm escape sequences for special keys (arrows, function keys, etc.), UTF-8 character decoding, and modifier detection.

!!! note
    XjEventLoop uses XjReader internally. Most applications don't call XjReader directly.

## Reading Keys

| Method | Returns | Description |
|--------|---------|-------------|
| `ReadKey()` | XjKeyEvent | Read and parse next keyboard input event |
| `ReadLine(prompt)` | String | Interactive line editing with history and shortcuts |

## ReadKey Features

XjReader.ReadKey() handles:

- **VT100/xterm sequences**: F1-F12, arrow keys, Home, End, Page Up/Down, Insert, Delete
- **UTF-8 decoding**: Multi-byte Unicode characters
- **Modifier detection**: Ctrl, Shift, Alt, Meta modifiers
- **Special keys**: Tab, Backspace, Enter, Escape
- **Control characters**: Ctrl+A through Ctrl+Z

## ReadLine Features

XjReader.ReadLine(prompt) provides interactive input with:

- **Line editing**: Arrow keys, Home, End, Ctrl+A, Ctrl+E
- **Deletion**: Backspace, Delete, Ctrl+K (delete to end)
- **History**: Up/Down arrows cycle through previous inputs
- **Wrapping**: Long lines wrap in the terminal
- **Visual feedback**: Shows cursor position

## Examples

### Basic key reading

```xojo
XjTerminal.EnableRawMode()
Try
  While True
    Var event As XjKeyEvent = XjReader.ReadKey()

    If event.IsEscape() Then
      Exit While
    End If

    XjTerminal.Write("You pressed: " + event.KeyName())
  Wend
Finally
  XjTerminal.DisableRawMode()
End Try
```

### Check for specific keys

```xojo
Var event As XjKeyEvent = XjReader.ReadKey()

If event.IsArrow() Then
  Select Case True
    Case event.IsArrowUp()
      MoveCursorUp()
    Case event.IsArrowDown()
      MoveCursorDown()
    Case event.IsArrowLeft()
      MoveCursorLeft()
    Case event.IsArrowRight()
      MoveCursorRight()
  End Select
End If
```

### Handle character input with modifiers

```xojo
Var event As XjKeyEvent = XjReader.ReadKey()

If event.IsCharKey() Then
  If event.IsCtrlPressed() Then
    XjTerminal.Write("Ctrl+" + event.GetChar().UpperCase())
  ElseIf event.IsAltPressed() Then
    XjTerminal.Write("Alt+" + event.GetChar())
  Else
    XjTerminal.Write(event.GetChar())
  End If
End If
```

### Function key handling

```xojo
Var event As XjKeyEvent = XjReader.ReadKey()

If event.IsFunction() Then
  Select Case True
    Case event.IsFunctionKey(1)
      ShowHelp()
    Case event.IsFunctionKey(2)
      ShowOptions()
    Case event.IsFunctionKey(10)
      SaveAndExit()
  End Select
End If
```

### Interactive line input

```xojo
XjTerminal.EnableRawMode()
Try
  Var line As String = XjReader.ReadLine("Enter name: ")
  XjTerminal.Write("You entered: " + line)
Finally
  XjTerminal.DisableRawMode()
End Try
```

### Multi-line input loop

```xojo
XjTerminal.EnableRawMode()
Try
  While True
    Var command As String = XjReader.ReadLine("> ")

    If command = "exit" Then
      Exit While
    End If

    ProcessCommand(command)
  Wend
Finally
  XjTerminal.DisableRawMode()
End Try
```

### Build an interactive menu

```xojo
XjTerminal.EnableRawMode()
Try
  While True
    XjTerminal.Write(XjScreen.Clear())
    XjTerminal.Write("Menu:")
    XjTerminal.Write("1. Option A")
    XjTerminal.Write("2. Option B")
    XjTerminal.Write("3. Exit")
    XjTerminal.Write("")

    Var event As XjKeyEvent = XjReader.ReadKey()

    Select Case event.GetChar()
      Case "1"
        HandleOptionA()
      Case "2"
        HandleOptionB()
      Case "3"
        Exit While
    End Select
  Wend
Finally
  XjTerminal.DisableRawMode()
End Try
```

### Detect terminal capabilities

```xojo
Var event As XjKeyEvent = XjReader.ReadKey()

// Test if terminal recognizes arrow keys
If event.IsArrow() Then
  XjTerminal.Write("Terminal supports arrow keys")
Else
  XjTerminal.Write("Arrow keys not recognized")
End If
```

### Handle paste operations

```xojo
Var event As XjKeyEvent = XjReader.ReadKey()

If event.IsCharKey() And event.IsCtrlPressed() And event.GetChar() = "v" Then
  // Bracketed paste mode: wait for paste data
  Var pastedText As String = ""

  While True
    Var nextEvent As XjKeyEvent = XjReader.ReadKey()
    If nextEvent.IsEscape() Then
      Exit While
    End If
    If nextEvent.IsCharKey() Then
      pastedText = pastedText + nextEvent.GetChar()
    End If
  Wend

  XjTerminal.Write("Pasted: " + pastedText)
End If
```

## Design notes

**VT100 parsing**: XjReader recognizes standard VT100 and xterm escape sequences. It's robust against incomplete or malformed sequences.

**UTF-8 support**: Multi-byte UTF-8 characters are automatically decoded. You can read and process Unicode characters transparently.

**Blocking vs non-blocking**: ReadKey() blocks until input is available. For non-blocking input, use XjTerminal.ReadByte() directly and implement your own parsing.

**ReadLine state**: ReadLine() maintains history and cursor position internally. Each call is independent.

**Raw mode requirement**: ReadKey() and ReadLine() require raw mode (XjTerminal.EnableRawMode()). They won't work in standard canonical mode.

**Performance**: Escape sequence parsing is optimized to avoid unnecessary allocations. ReadKey() is fast even with complex key combinations.

!!! note
    XjEventLoop handles calling ReadKey() internally. For most applications, use XjEventLoop instead of calling ReadKey() directly.
