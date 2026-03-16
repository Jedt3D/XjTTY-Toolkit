---
title: Selection Prompts
description: XjSelectPrompt, XjMultiSelectPrompt, XjEnumSelectPrompt, XjExpandPrompt for choosing from lists.
---

# Selection Prompts

Selection prompts let users choose one or more items from a list using arrow keys, space, or number entry.

## XjSelectPrompt

Single-choice selection with arrow key navigation.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetOptions(opts)` | String() | — | Set choice list |
| `SetPageSize(size)` | Integer | — | Set visible items per page |
| `SetDefault(opt)` | String | — | Set pre-selected option |
| `Prompt()` | — | String | Run prompt and return choice |

### Example

```xojo
Var prompt As New XjSelectPrompt()
Call prompt.SetQuestion("Choose environment:")
Call prompt.SetOptions(Array("Development", "Staging", "Production"))
Call prompt.SetDefault("Development")

Var choice As String = prompt.Prompt()
```

## XjMultiSelectPrompt

Multi-choice selection with space toggle and min/max bounds.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetOptions(opts)` | String() | — | Set choice list |
| `SetMin(min)` | Integer | — | Set minimum selections |
| `SetMax(max)` | Integer | — | Set maximum selections |
| `Prompt()` | — | String() | Run prompt and return choices |

### Example

```xojo
Var prompt As New XjMultiSelectPrompt()
Call prompt.SetQuestion("Select features:")
Call prompt.SetOptions(Array("Feature A", "Feature B", "Feature C", "Feature D"))
Call prompt.SetMin(1)
Call prompt.SetMax(3)

Var selected As String() = prompt.Prompt()
```

## XjEnumSelectPrompt

Numbered selection — user enters 1, 2, 3, etc.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `SetOptions(opts)` | String() | — | Set choice list |
| `Prompt()` | — | String | Run prompt and return choice |

### Example

```xojo
Var prompt As New XjEnumSelectPrompt()
Call prompt.SetQuestion("Choose one:")
Call prompt.SetOptions(Array("Option A", "Option B", "Option C"))

Var choice As String = prompt.Prompt()  // User enters 1, 2, or 3
```

## XjExpandPrompt

Key-mapped short selection (like git's y/n/d).

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetQuestion(q)` | String | — | Set prompt text |
| `AddChoice(key, label)` | String key, label | — | Add choice (key is shortcut) |
| `Prompt()` | — | String | Run prompt and return selected key |

### Example

```xojo
Var prompt As New XjExpandPrompt()
Call prompt.SetQuestion("Stash changes?")
Call prompt.AddChoice("y", "Yes, stash")
Call prompt.AddChoice("n", "No, discard")
Call prompt.AddChoice("d", "Show diff")

Var choice As String = prompt.Prompt()  // User presses 'y', 'n', or 'd'
```

## Features

### Pagination

Large lists automatically paginate:

```xojo
Var prompt As New XjSelectPrompt()
Call prompt.SetPageSize(10)  // Show 10 items at a time
```

### Disabled choices

Some selections allow disabling certain options (context-dependent).

### Filtering

Live filtering available in larger selections (type to filter).

### Keyboard Navigation

| Key | Action |
|-----|--------|
| Arrow Up/Down | Navigate choices |
| Space | Toggle selection (MultiSelect) |
| Enter | Confirm selection |
| Escape | Cancel |
| Home/End | Jump to first/last |
| Page Up/Down | Jump to next page |

## Examples

### Select with confirmation

```xojo
Var prompt As New XjSelectPrompt()
Call prompt.SetQuestion("Continue?")
Call prompt.SetOptions(Array("Yes", "No"))
Call prompt.SetDefault("No")

Var answer As String = prompt.Prompt()
If answer = "Yes" Then
  // Process
End If
```

### Multi-select with constraints

```xojo
Var permissions As New XjMultiSelectPrompt()
Call permissions.SetQuestion("Grant permissions:")
Call permissions.SetOptions(Array("Read", "Write", "Execute", "Delete"))
Call permissions.SetMin(1)      // At least one
Call permissions.SetMax(3)      // At most three

Var selected As String() = permissions.Prompt()
```

### Compact expansion menu

```xojo
Var menu As New XjExpandPrompt()
Call menu.SetQuestion("Action:")
Call menu.AddChoice("c", "Create")
Call menu.AddChoice("r", "Read")
Call menu.AddChoice("u", "Update")
Call menu.AddChoice("d", "Delete")

Var action As String = menu.Prompt()
```

### Enum with default

```xojo
Var prompt As New XjEnumSelectPrompt()
Call prompt.SetQuestion("Priority:")
Call prompt.SetOptions(Array("Low", "Medium", "High", "Critical"))

Var priority As String = prompt.Prompt()
```

## Design notes

**Pagination**: Selections with more items than page size automatically show next/prev indicators.

**Filtering**: Larger lists support live filtering (type to filter visible options).

**Default selection**: SetDefault() pre-highlights an option. User can change it.

**Min/Max bounds**: MultiSelectPrompt enforces selection count limits. Cannot confirm outside bounds.

**Keyboard control**: All selection methods use arrow keys for navigation and standard shortcuts.

!!! note
    Selection prompts use keyboard-driven UI for fast navigation. Mouse support is available if the terminal supports it.
