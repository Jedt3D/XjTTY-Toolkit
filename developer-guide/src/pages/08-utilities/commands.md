---
title: Commands & Utilities
description: XjCommand executes shell commands; XjPager pages large output; XjWhich finds executables; XjHistory manages input history.
---

# Commands & Utilities

Utilities for shell execution, output paging, executable discovery, and input history management.

## XjCommand & XjCommandResult

Shell command execution with timeout and result capture.

### XjCommand Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Run(cmd)` | String | XjCommandResult | Execute command and return result |
| `RunSilent(cmd)` | String | Boolean | Execute without output (returns success) |
| `Capture(cmd)` | String | String | Run and return output |
| `DryRun(cmd)` | String | — | Print command without executing |

### XjCommandResult Properties

| Property | Returns | Description |
|----------|---------|-------------|
| `Output()` | String | Standard output |
| `ExitCode()` | Integer | Exit code (0=success) |
| `TimedOut()` | Boolean | Whether execution timed out |
| `IsSuccess()` | Boolean | True if exit code was 0 |
| `Lines()` | String() | Output split into lines |

### Example

```xojo
Var result As XjCommandResult = XjCommand.Run("ls -la")

If result.IsSuccess() Then
  For Each line As String In result.Lines()
    XjPrompt.Say(line)
  Next
Else
  XjPrompt.Error_("Command failed with code " + result.ExitCode().ToString())
End If
```

## XjPager

Display large content with keyboard navigation.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetPageSize(lines)` | Integer | — | Set visible lines per page |
| `Page(content)` | String | — | Display content interactively |

### Example

```xojo
Var pager As New XjPager()
Call pager.SetPageSize(20)

Var result As XjCommandResult = XjCommand.Run("man ls")
Call pager.Page(result.Output())
```

## XjWhich

Find executables in system PATH.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Which(name)` | String | String | Find executable path (empty if not found) |
| `WhichAll(name)` | String | String() | Find all matching executables |
| `Exists(name)` | String | Boolean | Check if executable exists |

### Example

```xojo
Var pythonPath As String = XjWhich.Which("python3")
If pythonPath.IsEmpty Then
  XjPrompt.Error_("python3 not found in PATH")
Else
  XjPrompt.Ok("Found: " + pythonPath)
End If
```

## XjHistory

Input history with Up/Down navigation.

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Add(item)` | String | — | Add item to history |
| `Previous()` | — | String | Navigate to previous item |
| `Next_()` | — | String | Navigate to next item |
| `Reset()` | — | — | Return to current (no history) |
| `Count()` | — | Integer | Get history size |
| `Clear()` | — | — | Delete all history |
| `IsNavigating()` | — | Boolean | True if viewing history |

### Example

```xojo
Var history As New XjHistory()
Call history.Add("select * from users")
Call history.Add("select * from products")
Call history.Add("select * from orders")

Var previous As String = history.Previous()  // "select * from orders"
Var earlier As String = history.Previous()   // "select * from products"
Call history.Reset()  // Return to current (no history entry)
```

## Combined Examples

### Run command and page output

```xojo
Var cmd As String = "find /home -name '*.txt' -type f"
Var result As XjCommandResult = XjCommand.Run(cmd)

If result.IsSuccess() Then
  Var pager As New XjPager()
  Call pager.SetPageSize(20)
  Call pager.Page(result.Output())
Else
  XjPrompt.Error_("Find failed")
End If
```

### Check if tool exists before using

```xojo
Var gitPath As String = XjWhich.Which("git")
If gitPath.IsEmpty Then
  XjPrompt.Error_("Git not found. Please install Git.")
  Return
End If

Var result As XjCommandResult = XjCommand.Run("git status")
XjPrompt.Say(result.Output())
```

### Interactive command with history

```xojo
Var history As New XjHistory()

While True
  Var cmd As String = XjPrompt.Ask("$ ")

  If cmd = "exit" Then
    Exit While
  End If

  Call history.Add(cmd)

  Var result As XjCommandResult = XjCommand.Run(cmd)
  If result.IsSuccess() Then
    XjPrompt.Say(result.Output())
  Else
    XjPrompt.Error_("Error: " + result.Output())
  End If
Next
```

### Dry run before executing

```xojo
Var cmd As String = "rm -rf /tmp/cache"

XjPrompt.Warn("Would execute: " + cmd)
Call XjCommand.DryRun(cmd)

If XjPrompt.Confirm("Execute this command?") Then
  Var result As XjCommandResult = XjCommand.Run(cmd)
  If result.IsSuccess() Then
    XjPrompt.Ok("Done")
  End If
End If
```

## Design notes

**Command execution**: Commands run with system shell. Include full paths for maximum portability.

**Exit codes**: ExitCode()=0 indicates success. Other values indicate errors. Check IsSuccess() for simple boolean.

**Timeouts**: Commands have default timeout (implementation-dependent). Exceeding timeout sets TimedOut()=true.

**Pager interaction**: XjPager handles Space/Enter for next page, 'q' to quit, and other navigation keys.

**PATH search**: Which() searches standard PATH directories. WhichAll() returns all matches in order.

**History limits**: History has default max size (implementation-dependent). Older items are automatically discarded.

!!! note
    XjCommand runs blocking. For long operations, show progress indicators or spinners alongside execution.
