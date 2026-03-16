---
title: Key Events
description: XjKeyEvent class represents keyboard input with key codes, character data, and modifier flags.
---

# Key Events

The **XjKeyEvent** class represents a keyboard event with a key code, optional character data, and modifier flags (Ctrl, Shift, Alt, Meta).

## Constructor

```xojo
Var event As New XjKeyEvent(keyCode)
Var eventWithChar As New XjKeyEvent(keyCode, char)
Var eventWithMods As New XjKeyEvent(keyCode, char, ctrlPressed, shiftPressed, altPressed, metaPressed)
```

## Key Codes

All key codes are Integer constants in XjKeyEvent:

| Constant | Value | Description |
|----------|-------|-------------|
| `KEY_ENTER` | 13 | Return/Enter key |
| `KEY_TAB` | 9 | Tab key |
| `KEY_ESCAPE` | 27 | Escape key |
| `KEY_BACKSPACE` | 127 | Backspace key |
| `KEY_DELETE` | 1000 | Delete key (forward delete) |
| `KEY_INSERT` | 1001 | Insert key |
| `KEY_HOME` | 1002 | Home key |
| `KEY_END` | 1003 | End key |
| `KEY_PAGEUP` | 1004 | Page Up key |
| `KEY_PAGEDOWN` | 1005 | Page Down key |
| `KEY_UP` | 1006 | Up arrow key |
| `KEY_DOWN` | 1007 | Down arrow key |
| `KEY_LEFT` | 1008 | Left arrow key |
| `KEY_RIGHT` | 1009 | Right arrow key |
| `KEY_F1`..`KEY_F12` | 2001-2012 | Function keys F1-F12 |
| `KEY_CTRL_A`..`KEY_CTRL_Z` | 3001-3026 | Ctrl+A through Ctrl+Z |
| `KEY_SHIFT_TAB` | 4000 | Shift+Tab (back-tab) |

## Query Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `GetKeyCode()` | Integer | Get key code |
| `GetChar()` | String | Get character (empty if not applicable) |
| `HasChar()` | Boolean | Return True if key represents a character |
| `IsCtrlPressed()` | Boolean | Return True if Ctrl modifier is held |
| `IsShiftPressed()` | Boolean | Return True if Shift modifier is held |
| `IsAltPressed()` | Boolean | Return True if Alt modifier is held |
| `IsMetaPressed()` | Boolean | Return True if Meta/Win key is held |

## Convenience Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `IsCharKey()` | Boolean | Return True if key is a printable character |
| `IsEnter()` | Boolean | Return True if Enter/Return key |
| `IsEscape()` | Boolean | Return True if Escape key |
| `IsTab()` | Boolean | Return True if Tab key |
| `IsBackspace()` | Boolean | Return True if Backspace key |
| `IsDelete()` | Boolean | Return True if Delete key |
| `IsArrow()` | Boolean | Return True if any arrow key |
| `IsArrowUp()` | Boolean | Return True if up arrow |
| `IsArrowDown()` | Boolean | Return True if down arrow |
| `IsArrowLeft()` | Boolean | Return True if left arrow |
| `IsArrowRight()` | Boolean | Return True if right arrow |
| `IsHome()` | Boolean | Return True if Home key |
| `IsEnd()` | Boolean | Return True if End key |
| `IsPageUp()` | Boolean | Return True if Page Up |
| `IsPageDown()` | Boolean | Return True if Page Down |
| `IsFunction()` | Boolean | Return True if function key (F1-F12) |
| `IsFunctionKey(n)` | Boolean | Return True if specific function key (1-12) |

## Display Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `KeyName()` | String | Human-readable key name ("Enter", "Ctrl+C", "F1", etc.) |

## Examples

### Check for specific keys

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsEscape() Then
    // Handle escape
    shouldExit = True
  ElseIf event.IsEnter() Then
    // Handle enter
    ProcessInput()
  ElseIf event.IsTab() Then
    // Handle tab
    MoveFocusForward()
  ElseIf event.IsBackspace() Then
    // Handle backspace
    RemoveCharacter()
  End If
End Sub
```

### Check modifiers with keys

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsCtrlPressed() And event.GetChar() = "c" Then
    // Ctrl+C pressed
    XjTerminal.Write("^C - Exiting")
    shouldExit = True
  ElseIf event.IsCtrlPressed() And event.GetChar() = "s" Then
    // Ctrl+S pressed
    SaveDocument()
  End If
End Sub
```

### Handle character input

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsCharKey() Then
    Var char As String = event.GetChar()
    // Add character to input buffer
    inputBuffer = inputBuffer + char
    XjTerminal.Write(char)
  End If
End Sub
```

### Handle arrow keys

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsArrow() Then
    Select Case True
      Case event.IsArrowUp()
        SelectPrevious()
      Case event.IsArrowDown()
        SelectNext()
      Case event.IsArrowLeft()
        MoveCursorLeft()
      Case event.IsArrowRight()
        MoveCursorRight()
    End Select
  End If
End Sub
```

### Display key name for debugging

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  XjTerminal.Write("You pressed: " + event.KeyName())

  If event.IsCtrlPressed() Then
    XjTerminal.Write(" (with Ctrl)")
  End If
  If event.IsShiftPressed() Then
    XjTerminal.Write(" (with Shift)")
  End If
  If event.IsAltPressed() Then
    XjTerminal.Write(" (with Alt)")
  End If
End Sub
```

### Function key handling

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
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
End Sub
```

### Build a command from modifiers

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsCharKey() Then
    Var command As String = ""

    If event.IsCtrlPressed() Then
      command = command + "Ctrl+"
    End If
    If event.IsAltPressed() Then
      command = command + "Alt+"
    End If
    If event.IsShiftPressed() Then
      command = command + "Shift+"
    End If

    command = command + event.GetChar().UpperCase()

    XjTerminal.Write("Command: " + command)
  End If
End Sub
```

### Navigation shortcuts

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  If event.IsCtrlPressed() Then
    Select Case event.GetChar()
      Case "a"
        MoveToStart()
      Case "e"
        MoveToEnd()
      Case "k"
        DeleteToEnd()
      Case "u"
        DeleteToStart()
    End Select
  End If
End Sub
```

## Design notes

**Key codes vs characters**: Some keys (like Enter, Tab, arrows) produce key codes only. Others (like 'a', '1', '?') produce both character data and a key code.

**Modifier detection**: Use IsCtrlPressed() etc. to detect modifiers independently. Combine with GetChar() or GetKeyCode() for full context.

**Function keys**: F1-F12 have key codes (2001-2012). They don't produce characters. Use IsFunctionKey(n) for specific detection.

**Ctrl shortcuts**: Ctrl+A through Ctrl+Z are represented as key code constants (KEY_CTRL_A, etc.) and also as character codes with IsCtrlPressed() + GetChar().

**Cross-platform**: Special keys (arrows, function keys, etc.) are normalized across platforms. A user pressing the up arrow produces the same event on macOS, Linux, and Windows.

!!! note
    XjKeyEvent is created by XjReader.ReadKey(). Most applications use higher-level APIs (prompts, widgets, event loops) and don't construct key events manually.
