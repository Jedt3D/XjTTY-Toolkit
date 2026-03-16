---
title: Prompt Facade
description: XjPrompt module provides high-level prompt functions (Ask, Confirm, Select, etc.) for interactive CLI applications.
---

# Prompt Facade

The **XjPrompt** module is the primary API for interactive prompts. It provides simple functions for questions, confirmations, selections, and multi-step flows.

## Text Input Prompts

| Function | Parameter | Returns | Description |
|----------|-----------|---------|-------------|
| `Ask(question)` | String | String | Free-form text input |
| `AskWithHistory(question)` | String | String | Text input with history navigation |
| `AskValidated(question, validator)` | String, XjValidation | String | Text input with validation |
| `Password(prompt)` | String | String | Masked password input |
| `MultiLine(prompt)` | String | String | Multi-line text editor |
| `Suggest(question, options)` | String, String() | String | Text input with autocomplete |

## Selection Prompts

| Function | Parameters | Returns | Description |
|----------|-----------|---------|-------------|
| `Select_(question, options)` | String, String() | String | Single-choice selection |
| `MultiSelect(question, options)` | String, String() | String() | Multi-choice selection |
| `EnumSelect(question, options)` | String, String() | String | Numbered selection |
| `Expand(question, choices)` | String, String() | String | Key-mapped short selection |

## Confirmation Prompts

| Function | Parameters | Returns | Description |
|----------|-----------|---------|-------------|
| `Confirm(question)` | String | Boolean | Yes/No confirmation |
| `Deny(question)` | String | Boolean | No/Yes confirmation (default No) |

## Special Prompts

| Function | Parameters | Returns | Description |
|----------|-----------|---------|-------------|
| `Slider(question, min, max, step)` | String, Integer × 3 | Integer | Numeric slider |
| `KeyPress(prompt, timeout)` | String, Integer | XjKeyEvent | Wait for keypress |
| `Collect(questions)` | Dictionary | Dictionary | Multi-step form |

## Output Helpers

| Function | Parameter | Description |
|----------|-----------|-------------|
| `Say(message)` | String | Print message |
| `Ok(message)` | String | Print success message (green) |
| `Warn(message)` | String | Print warning (yellow) |
| `Error_(message)` | String | Print error (red) |

## Styling

| Method | Parameter | Description |
|--------|-----------|-------------|
| `SetStyle(style)` | XjPromptStyle | Set global prompt theme |

## Examples

### Simple question

```xojo
Var name As String = XjPrompt.Ask("What is your name?")
XjPrompt.Ok("Hello, " + name + "!")
```

### Confirmation

```xojo
If XjPrompt.Confirm("Do you want to continue?") Then
  XjPrompt.Say("Continuing...")
Else
  XjPrompt.Say("Cancelled.")
End If
```

### Single selection

```xojo
Var choice As String = XjPrompt.Select_("Choose an option:", Array("Option A", "Option B", "Option C"))
XjPrompt.Say("You selected: " + choice)
```

### Multi-selection

```xojo
Var choices As String() = XjPrompt.MultiSelect("Select items:", Array("Item 1", "Item 2", "Item 3"))
For Each item As String In choices
  XjPrompt.Say("Selected: " + item)
Next
```

### Password prompt

```xojo
Var password As String = XjPrompt.Password("Enter password: ")
XjPrompt.Say("Password set")
```

### Numbered selection

```xojo
Var choice As String = XjPrompt.EnumSelect("Pick one:", Array("First", "Second", "Third"))
// User enters 1, 2, or 3
```

### Slider input

```xojo
Var value As Integer = XjPrompt.Slider("Select value (1-10):", 1, 10, 1)
XjPrompt.Say("You selected: " + value.ToString())
```

### Multi-step form

```xojo
Var collector As New XjCollectPrompt()
Call collector.AddAsk("name", "Name: ")
Call collector.AddPassword("secret", "Secret: ")
Call collector.AddConfirm("agree", "Do you agree?")

Var results As Dictionary = XjPrompt.Collect(collector)

XjPrompt.Say("Name: " + results.Value("name"))
XjPrompt.Say("Agreed: " + results.Value("agree"))
```

### Validation

```xojo
Var email As String = XjPrompt.AskValidated("Email: ", XjValidation.Pattern("[^@]+@[^@]+"))
XjPrompt.Ok("Email saved: " + email)
```

### Autocomplete suggestion

```xojo
Var choices As String() = Array("apple", "apricot", "banana", "cherry")
Var fruit As String = XjPrompt.Suggest("Pick a fruit: ", choices)
XjPrompt.Say("You chose: " + fruit)
```

### Output messages

```xojo
XjPrompt.Say("Normal message")
XjPrompt.Ok("Success!")
XjPrompt.Warn("Warning!")
XjPrompt.Error_("Error!")
```

### Custom styling

```xojo
Var style As New XjPromptStyle()
Call style.SetPrefix(">>> ")
Call style.SetQuestion(XjStyle.Info())

Call XjPrompt.SetStyle(style)

// All subsequent prompts use this style
Var answer As String = XjPrompt.Ask("Question: ")
```

## Design notes

**Blocking calls**: All prompt functions block until user responds. They handle raw mode and cleanup automatically.

**Multi-step**: Use XjCollectPrompt for forms. It chains prompts and returns a Dictionary with all answers.

**Validation**: XjValidation provides Required, MinLength, MaxLength, Pattern, Custom validators.

**Styling**: XjPromptStyle controls appearance (question color, answer color, prefix, cursor, etc.).

**History**: AskWithHistory() remembers previous inputs (accessible via Up/Down arrows).

**Autocomplete**: Suggest() provides fuzzy matching on a list of suggestions.

!!! note
    Prompts are synchronous. For long-running operations, show a spinner or progress bar separately (outside the prompt).
