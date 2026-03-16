---
title: TextInput Widget
description: XjTextInput is a single-line text input widget with cursor, placeholder, masking, and keyboard shortcuts.
---

# TextInput Widget

The **XjTextInput** widget provides single-line text input with built-in cursor management, placeholder text, character masking, and keyboard shortcuts (Ctrl+A, Ctrl+E, Ctrl+K, Ctrl+U).

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetValue(text)` | String | — | Set input text |
| `GetValue()` | — | String | Get current input text |
| `SetPlaceholder(text)` | String | — | Set hint text (shown when empty) |
| `SetMask(char)` | String | — | Set mask character (e.g., "*" for passwords) |
| `SetMaxLength(length)` | Integer | — | Set maximum input length |
| `SetLabel(label)` | String | — | Set label text |

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+A | Move cursor to start |
| Ctrl+E | Move cursor to end |
| Ctrl+K | Delete from cursor to end |
| Ctrl+U | Delete from start to cursor |
| Backspace | Delete character before cursor |
| Delete | Delete character at cursor |
| Arrows | Move cursor left/right |
| Home | Move to start |
| End | Move to end |

## Examples

### Basic text input

```xojo
Var input As New XjTextInput()
Call input.SetValue("Default text")
Call input.SetPlaceholder("Enter text...")
Call input.SetWidth(XjConstraint.Fixed(30))
```

### Password input

```xojo
Var password As New XjTextInput()
Call password.SetPlaceholder("Enter password")
Call password.SetMask("*")
Call password.SetMaxLength(20)
```

### Input with label

```xojo
Var nameInput As New XjTextInput()
Call nameInput.SetLabel("Name: ")
Call nameInput.SetPlaceholder("John Doe")
Call nameInput.SetMaxLength(50)
```

### Bounded input

```xojo
Var zip As New XjTextInput()
Call zip.SetMaxLength(5)
Call zip.SetPlaceholder("12345")

Var username As New XjTextInput()
Call username.SetMaxLength(20)
Call username.SetPlaceholder("username")
```

### Retrieve input value

```xojo
Var input As New XjTextInput()
Call input.SetValue("initial")

// Later, after user edits:
Var finalValue As String = input.GetValue()
XjTerminal.Write("You entered: " + finalValue)
```

## Design notes

**Single-line only**: XjTextInput handles one line. For multi-line input, use XjMultiLinePrompt.

**Horizontal scrolling**: If text is longer than widget width, the input automatically scrolls left/right to keep cursor visible.

**Masking**: SetMask() replaces all characters with the mask character (visual only; GetValue() returns actual text).

**MaxLength**: SetMaxLength() prevents input beyond the limit. User can't type additional characters.

**Placeholder**: Placeholder text appears gray (muted style) when input is empty. It disappears on focus.

**Keyboard control**: All standard line-editing shortcuts work automatically. Override HandleKey() in a subclass to add custom shortcuts.

!!! note
    XjTextInput is typically used within prompts (XjAskPrompt) or full-screen applications. For simple prompts, use XjPrompt.Ask() instead.
