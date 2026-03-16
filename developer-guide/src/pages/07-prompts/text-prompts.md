---
title: Text Input Prompts
description: XjAskPrompt, XjPasswordPrompt, XjMultiLinePrompt, XjSuggestPrompt for various text input scenarios.
---

# Text Input Prompts

Text input prompts collect string data with various features: validation, history, masking, autocomplete, and line editing.

## XjAskPrompt

Free-form text input with optional validation and history.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetDefault(def)` | String | — | Set default value |
| `SetPlaceholder(p)` | String | — | Set hint text |
| `SetValidator(v)` | XjValidation | — | Add validation |
| `SetModifier(m)` | Integer (MOD_*) | — | Apply transformation (uppercase, lowercase, trim) |
| `AddHistory(item)` | String | — | Pre-populate history |
| `Prompt()` | — | String | Run prompt and return answer |

### Example

```xojo
Var prompt As New XjAskPrompt()
Call prompt.SetQuestion("Enter your name:")
Call prompt.SetPlaceholder("John Doe")
Call prompt.SetValidator(XjValidation.MinLength(2))

Var name As String = prompt.Prompt()
```

## XjPasswordPrompt

Masked password input.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetPrompt(p)` | String | — | Set prompt text |
| `SetMask(mask)` | String | — | Set mask character (default: "*") |
| `SetMinLength(min)` | Integer | — | Set minimum length |
| `Prompt()` | — | String | Run prompt and return password |

### Example

```xojo
Var prompt As New XjPasswordPrompt()
Call prompt.SetPrompt("Enter password: ")
Call prompt.SetMask("*")
Call prompt.SetMinLength(8)

Var password As String = prompt.Prompt()
```

## XjMultiLinePrompt

Multi-line text editor (Ctrl+D to finish).

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetPrompt(p)` | String | — | Set initial prompt |
| `SetDefault(text)` | String | — | Set default text |
| `Prompt()` | — | String | Run editor and return text |

### Example

```xojo
Var prompt As New XjMultiLinePrompt()
Call prompt.SetPrompt("Enter description (Ctrl+D when done):")
Call prompt.SetDefault("Initial text")

Var description As String = prompt.Prompt()
```

## XjSuggestPrompt

Text input with autocomplete suggestions.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetCompleter(c)` | XjCompleter | — | Set autocompleter |
| `Prompt()` | — | String | Run prompt with suggestions |

### Example

```xojo
Var completer As New XjCompleter()
Call completer.Complete(Array("apple", "apricot", "application"))

Var prompt As New XjSuggestPrompt()
Call prompt.SetQuestion("Pick a fruit: ")
Call prompt.SetCompleter(completer)

Var choice As String = prompt.Prompt()
```

## XjCompleter

Autocomplete engine with prefix and fuzzy matching.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Complete(options)` | String() | — | Set option list |
| `GetMatches(input)` | String | String() | Get matching options |
| `FuzzyComplete(input)` | String | String() | Fuzzy match options |

### Example

```xojo
Var completer As New XjCompleter()
Call completer.Complete(Array("create", "commit", "checkout", "config"))

Var matches As String() = completer.GetMatches("co")
// Returns: "commit", "checkout", "config"
```

## Modifiers

| Constant | Value | Effect |
|----------|-------|--------|
| `MOD_UPPERCASE` | 1 | Convert to uppercase |
| `MOD_LOWERCASE` | 2 | Convert to lowercase |
| `MOD_TRIM` | 4 | Trim whitespace |
| `MOD_CAPITALIZE` | 8 | Capitalize first letter |

### Example

```xojo
Var prompt As New XjAskPrompt()
Call prompt.SetQuestion("Name: ")
Call prompt.SetModifier(XjConversion.MOD_UPPERCASE)

Var name As String = prompt.Prompt()  // "john" → "JOHN"
```

## Keyboard Shortcuts

All text input prompts support:

| Shortcut | Action |
|----------|--------|
| Ctrl+A | Move to start |
| Ctrl+E | Move to end |
| Ctrl+K | Delete to end |
| Ctrl+U | Delete to start |
| Ctrl+D | Finish (MultiLine only) |
| Arrows | Navigate cursor |
| Backspace | Delete character |

## Design notes

**Validation**: Validators check input and show error if validation fails. User can retry.

**History**: AskPrompt supports history. Use AddHistory() to pre-populate with previous values. Up/Down arrows navigate history.

**Modifiers**: Modifiers transform input after entry (uppercase, trim, etc.).

**Autocomplete**: Suggest prompts provide completion suggestions as the user types. Press Tab to accept suggestion.

**Defaults**: SetDefault() shows a suggested value. User can clear and enter new text.

!!! note
    Text prompts run synchronously. They handle raw mode, input parsing, and cleanup automatically.
