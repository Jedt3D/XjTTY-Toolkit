---
title: Styling & Validation
description: XjPromptStyle for theming prompts; XjValidation for input constraints; XjConversion for text transforms.
---

# Styling & Validation

XjPromptStyle customizes prompt appearance. XjValidation enforces input constraints. XjConversion transforms input text.

## XjPromptStyle

Controls prompt visual styling.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetPrefix(p)` | String | — | Set prompt prefix (default: "?") |
| `SetQuestion(s)` | XjStyle | — | Set question text style |
| `SetAnswer(s)` | XjStyle | — | Set answer text style |
| `SetCursor(c)` | String | — | Set cursor character |
| `SetError(s)` | XjStyle | — | Set error message style |
| `SetPlaceholder(s)` | XjStyle | — | Set placeholder style |
| `SetIndicator(i)` | String | — | Set success/error indicator |
| `SetHighlight(s)` | XjStyle | — | Set highlighted option style |
| `SetDisabled(s)` | XjStyle | — | Set disabled option style |
| `SetHelp(s)` | XjStyle | — | Set help text style |
| `SetHint(h)` | String | — | Set hint text |

### Example

```xojo
Var style As New XjPromptStyle()
Call style.SetPrefix(">>> ")
Call style.SetQuestion(XjStyle.Success())
Call style.SetAnswer(XjStyle.BoldText())
Call style.SetError(XjStyle.Danger())
Call style.SetCursor("▶ ")

Call XjPrompt.SetStyle(style)

// All subsequent prompts use this style
Var name As String = XjPrompt.Ask("Name: ")
```

## XjValidation

Input validators enforce constraints on user input.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Required()` | — | XjValidation | Text cannot be empty |
| `MinLength(len)` | Integer | XjValidation | Minimum character count |
| `MaxLength(len)` | Integer | XjValidation | Maximum character count |
| `RangeInt(min, max)` | Integer × 2 | XjValidation | Integer in range |
| `InList(options)` | String() | XjValidation | Value must be in list |
| `Pattern(regex)` | String | XjValidation | Match regex pattern |
| `Custom(fn)` | Function | XjValidation | Custom validation function |
| `Validate(text)` | String | String | Validate and return error (empty if valid) |

### Example

```xojo
// Required field
Var name As String = XjPrompt.AskValidated("Name: ", XjValidation.Required())

// Min/max length
Var pin As String = XjPrompt.AskValidated("PIN: ", XjValidation.MinLength(4).MaxLength(6))

// Email pattern
Var email As String = XjPrompt.AskValidated("Email: ", XjValidation.Pattern("[^@]+@[^@]+\.[^@]+"))

// One of a list
Var choice As String = XjPrompt.AskValidated("Color: ", XjValidation.InList(Array("red", "green", "blue")))
```

## XjConversion

Text transformation functions (uppercase, lowercase, trim, etc.).

| Constant | Value | Effect |
|----------|-------|--------|
| `MOD_UPPERCASE` | 1 | Convert to uppercase |
| `MOD_LOWERCASE` | 2 | Convert to lowercase |
| `MOD_TRIM` | 4 | Trim leading/trailing whitespace |
| `MOD_CAPITALIZE` | 8 | Capitalize first letter |

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `ToInteger(text)` | String | Integer | Parse as integer |
| `ToDouble(text)` | String | Double | Parse as double |
| `ToBool(text)` | String | Boolean | Parse as boolean |
| `ApplyModifier(text, mod)` | String, Integer | String | Apply transformation |

### Example

```xojo
// Apply modifier to input
Var prompt As New XjAskPrompt()
Call prompt.SetQuestion("Name: ")
Call prompt.SetModifier(XjConversion.MOD_UPPERCASE)

Var name As String = prompt.Prompt()  // "john" → "JOHN"

// Convert string to number
Var numStr As String = XjPrompt.Ask("Age: ")
Var age As Integer = XjConversion.ToInteger(numStr)

// Parse boolean
Var boolStr As String = XjPrompt.Ask("Continue? (yes/no): ")
Var shouldContinue As Boolean = XjConversion.ToBool(boolStr)
```

## XjInlineRenderer

Advanced: Renders inline prompt output to terminal (used internally).

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Begin()` | — | — | Start rendering |
| `End_()` | — | — | Finish rendering |
| `Render(text)` | String | — | Render output |
| `RenderSettled(text)` | String | — | Render settled state |
| `ReadKey()` | — | XjKeyEvent | Read keyboard input |

## Combined Example

### Custom styled validation prompt

```xojo
// Setup custom style
Var style As New XjPromptStyle()
Call style.SetPrefix("→ ")
Call style.SetQuestion(XjStyle.Info())
Call style.SetError(XjStyle.Danger())
Call XjPrompt.SetStyle(style)

// Create validator
Var emailValidator As XjValidation = XjValidation.Pattern("[^@]+@[^@]+")

// Prompt with validation
Var email As String = XjPrompt.AskValidated("Email: ", emailValidator)

// Transform output
Var normalized As String = XjConversion.ApplyModifier(email, XjConversion.MOD_LOWERCASE)
Call XjConversion.ApplyModifier(normalized, XjConversion.MOD_TRIM)

XjPrompt.Ok("Email saved: " + normalized)
```

## Design notes

**Global style**: XjPrompt.SetStyle() sets the theme for all subsequent prompts. Create once, reuse everywhere.

**Chained validators**: Validators can be chained (though implementation may vary).

**Error feedback**: Validation errors show to user; they can retry until input passes.

**Modifiers**: Applied after input is entered. Useful for normalization (uppercase usernames, trim whitespace).

**Conversions**: ToInteger/ToDouble parse strings. Use them after getting string input from prompts.

**Pattern syntax**: Patterns use standard regex syntax. Keep patterns simple for user clarity.

!!! note
    Custom validation functions are advanced. For simple cases, use built-in validators (Required, MinLength, Pattern, InList).
