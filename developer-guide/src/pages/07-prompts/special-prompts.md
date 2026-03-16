---
title: Special Prompts
description: XjConfirmPrompt, XjSliderPrompt, XjKeyPressPrompt, XjCollectPrompt for specialized input scenarios.
---

# Special Prompts

Specialized prompts for confirmations, numeric input, key waiting, and multi-step forms.

## XjConfirmPrompt

Yes/No confirmation with optional default.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetDefaultYes(yes)` | Boolean | — | Set default (True=Yes, False=No) |
| `Prompt()` | — | Boolean | Run prompt and return answer |

### Example

```xojo
Var prompt As New XjConfirmPrompt()
Call prompt.SetQuestion("Do you want to continue?")
Call prompt.SetDefaultYes(False)  // Default to No

If prompt.Prompt() Then
  XjPrompt.Say("Continuing...")
Else
  XjPrompt.Say("Cancelled.")
End If
```

## XjSliderPrompt

Numeric slider with arrow key adjustment.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetMin(min)` | Integer | — | Set minimum value |
| `SetMax(max)` | Integer | — | Set maximum value |
| `SetStep(step)` | Integer | — | Set step size |
| `SetDefault(val)` | Integer | — | Set initial value |
| `Prompt()` | — | Integer | Run prompt and return value |

### Example

```xojo
Var prompt As New XjSliderPrompt()
Call prompt.SetQuestion("Select level (1-10):")
Call prompt.SetMin(1)
Call prompt.SetMax(10)
Call prompt.SetStep(1)
Call prompt.SetDefault(5)

Var level As Integer = prompt.Prompt()
```

## XjKeyPressPrompt

Wait for a single keypress with optional timeout.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetPrompt(p)` | String | — | Set prompt text |
| `SetTimeout(ms)` | Integer | — | Set timeout (0=no timeout) |
| `Prompt()` | — | XjKeyEvent | Run and return key event |

### Example

```xojo
Var prompt As New XjKeyPressPrompt()
Call prompt.SetPrompt("Press any key to continue...")
Call prompt.SetTimeout(5000)  // 5 second timeout

Var key As XjKeyEvent = prompt.Prompt()
If key <> Nil Then
  XjPrompt.Say("You pressed: " + key.KeyName())
End If
```

## XjCollectPrompt

Multi-step form collecting multiple answers.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddAsk(key, question)` | String key, question | — | Add text input field |
| `AddPassword(key, prompt)` | String key, prompt | — | Add masked password field |
| `AddConfirm(key, question)` | String key, question | — | Add yes/no field |
| `AddSelect(key, question, options)` | String, String, String() | — | Add selection field |
| `Prompt()` | — | Dictionary | Run form and return answers |

### Example

```xojo
Var collector As New XjCollectPrompt()
Call collector.AddAsk("name", "Full name: ")
Call collector.AddPassword("password", "Password: ")
Call collector.AddConfirm("terms", "Accept terms?")
Call collector.AddSelect("role", "Choose role:", Array("Admin", "User", "Guest"))

Var answers As Dictionary = collector.Prompt()

Var name As String = answers.Value("name")
Var password As String = answers.Value("password")
Var agreed As Boolean = answers.Value("terms")
Var role As String = answers.Value("role")
```

### Multi-step workflow

```xojo
Var form As New XjCollectPrompt()
Call form.AddAsk("username", "Username: ")
Call form.AddPassword("password", "Password: ")
Call form.AddPassword("confirm", "Confirm password: ")
Call form.AddConfirm("subscribe", "Subscribe to newsletter?")

Var result As Dictionary = form.Prompt()

// Validate
If result.Value("password") <> result.Value("confirm") Then
  XjPrompt.Error_("Passwords don't match")
Else
  XjPrompt.Ok("Account created!")
End If
```

## Keyboard Controls

### Slider
- Left/Right arrows: Adjust value
- Home: Go to min
- End: Go to max
- Enter: Confirm

### KeyPress
- Any key: Return key event
- Escape: Return nothing
- Timeout: Return nothing if time expires

### CollectPrompt
- Tab: Next field
- Shift+Tab: Previous field
- Enter: Next field (or submit on last)
- Escape: Cancel entire form

## Examples

### Confirm with context

```xojo
XjPrompt.Say("Found 5 matching files")
Var confirm As New XjConfirmPrompt()
Call confirm.SetQuestion("Delete them?")
Call confirm.SetDefaultYes(False)

If Not confirm.Prompt() Then
  XjPrompt.Say("Cancelled")
  Return
End If

XjPrompt.Say("Deleting...")
```

### Volume slider

```xojo
Var prompt As New XjSliderPrompt()
Call prompt.SetQuestion("Volume:")
Call prompt.SetMin(0)
Call prompt.SetMax(100)
Call prompt.SetStep(10)
Call prompt.SetDefault(50)

Var volume As Integer = prompt.Prompt()
XjPrompt.Say("Volume set to " + volume.ToString() + "%")
```

### Wait for action

```xojo
Var prompt As New XjKeyPressPrompt()
Call prompt.SetPrompt("Press SPACE to deploy, ESC to cancel...")
Call prompt.SetTimeout(60000)  // 60 second timeout

Var key As XjKeyEvent = prompt.Prompt()
If key <> Nil And key.GetChar() = " " Then
  Deploy()
End If
```

## Design notes

**Confirm**: SetDefaultYes() determines which option is highlighted at start.

**Slider**: Arrow keys adjust by step. Home/End jump to min/max.

**KeyPress**: Useful for confirmations or waiting for user action before continuing.

**Collect**: Returns Dictionary keyed by field names. All fields are strings (booleans converted to "true"/"false").

**Form validation**: Check returned values after Prompt() completes. Show error and repeat if needed.

!!! note
    CollectPrompt is best for simple multi-step forms. For complex workflows with conditional fields, build a custom interactive form using widgets and event loops.
