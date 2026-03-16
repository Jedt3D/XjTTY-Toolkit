---
title: Symbols
description: XjSymbols module provides Unicode and ASCII glyph sets for terminal UI elements with lazy initialization.
---

# Symbols

The **XjSymbols** module provides a collection of terminal-friendly glyphs for UI elements like checkmarks, crosses, arrows, pointers, and more. Each glyph has both Unicode (default) and ASCII fallback variants.

## Initialization

Symbols are initialized lazily on first use. You can switch between Unicode and ASCII before creating any symbols:

| Method | Returns | Description |
|--------|---------|-------------|
| `EnsureInit()` | — | Initialize symbols (called automatically) |
| `UseUnicode()` | — | Use Unicode glyphs (default on macOS/Linux) |
| `UseASCII()` | — | Use ASCII-only glyphs (default on Windows without Unicode) |

## Symbol Properties

All properties return String (single character or ASCII sequence):

| Property | Unicode | ASCII | Purpose |
|----------|---------|-------|---------|
| `Check` | ✓ | [o] | Success/completion checkmark |
| `Cross` | ✗ | [x] | Failure/error cross |
| `Pointer` | ▶ | -> | Arrow pointer |
| `PointerLeft` | ◀ | <- | Left arrow |
| `PointerUp` | ▲ | /\ | Up arrow |
| `PointerDown` | ▼ | \/ | Down arrow |
| `Circle` | ● | () | Filled circle |
| `CircleOutline` | ○ | () | Hollow circle |
| `Square` | ■ | [#] | Filled square |
| `SquareOutline` | □ | [ ] | Hollow square |
| `Diamond` | ◆ | <> | Filled diamond |
| `DiamondOutline` | ◇ | <> | Hollow diamond |
| `Star` | ★ | (*) | Filled star |
| `StarOutline` | ☆ | (*) | Hollow star |
| `Triangle` | ▲ | /\ | Filled triangle |
| `TriangleOutline` | △ | /\ | Hollow triangle |
| `Line` | ─ | \- | Horizontal line |
| `VerticalLine` | │ | \| | Vertical line |
| `Cross` | ✕ | + | Plus/cross symbol |
| `Ellipsis` | … | ... | Ellipsis (three dots) |
| `Bullet` | • | * | Bullet point |
| `Info` | ⓘ | [i] | Information indicator |
| `Warning` | ⚠ | [!] | Warning symbol |
| `Question` | ❓ | [?] | Question mark |
| `Gear` | ⚙ | (#) | Settings/configuration |
| `Lock` | 🔒 | [L] | Lock symbol |
| `Unlock` | 🔓 | [U] | Unlock symbol |

## Examples

### Basic symbol usage

```xojo
XjTerminal.Write(XjSymbols.Check + " Task completed")
XjTerminal.Write(XjSymbols.Cross + " Task failed")
XjTerminal.Write(XjSymbols.Pointer + " Next item")
```

### Switch to ASCII for compatibility

```xojo
If XjPlatform.IsWindows() Then
  XjSymbols.UseASCII()
Else
  XjSymbols.UseUnicode()
End If

// Now all symbols use the selected set
XjTerminal.Write(XjSymbols.Check + " Complete")
```

### Styled symbols

```xojo
XjTerminal.Write(XjColor.Success(XjSymbols.Check + " Success"))
XjTerminal.Write(XjColor.Error_(XjSymbols.Cross + " Error"))
XjTerminal.Write(XjColor.Warning(XjSymbols.Warning + " Caution"))
```

### Progress indicators with symbols

```xojo
Var tasks As String() = Array("Task 1", "Task 2", "Task 3")
Var completed As Boolean() = Array(True, True, False)

For i As Integer = 0 To tasks.UpperBound
  Var symbol As String = If(completed(i), XjSymbols.Check, XjSymbols.Circle)
  XjTerminal.Write(symbol + " " + tasks(i))
Next
```

### Direction arrows in menu

```xojo
XjTerminal.Write(XjSymbols.PointerUp + " Previous item")
XjTerminal.Write(XjSymbols.PointerDown + " Next item")
XjTerminal.Write(XjSymbols.Pointer + " Select")
```

### Decorative separators

```xojo
// Horizontal line separator
Var line As String = String.FromArray(Array(XjSymbols.Line, XjSymbols.Line, XjSymbols.Line), "")
XjTerminal.Write(line)
```

### Semantic symbol combinations

```xojo
Var success As String = XjColor.Green(XjSymbols.Check) + " All tests passed"
Var warning As String = XjColor.Yellow(XjSymbols.Warning) + " Deprecated API"
Var error As String = XjColor.Red(XjSymbols.Cross) + " Connection failed"

XjTerminal.Write(success)
XjTerminal.Write(warning)
XjTerminal.Write(error)
```

### Check/uncheck list

```xojo
Var items As String() = Array("Option A", "Option B", "Option C")
Var checked As Boolean() = Array(True, False, True)

For i As Integer = 0 To items.UpperBound
  Var mark As String = If(checked(i), XjSymbols.Check, XjSymbols.CircleOutline)
  XjTerminal.Write(mark + " " + items(i))
Next
```

### Status indicators

```xojo
Var status As String = "Running..."
Var spinner As String() = Array("|", "/", "-", "\")
Var frame As Integer = 0

While isRunning
  XjTerminal.Write(spinner(frame Mod spinner.Count) + " " + status)
  frame = frame + 1
Wend
```

## Design notes

**Lazy initialization**: Symbols are built on first access. You can switch UseUnicode/UseASCII anytime before first use, or reinitialize by calling EnsureInit() after switching.

**Platform defaults**: By default, macOS and Linux use Unicode; Windows uses ASCII (unless you explicitly call UseUnicode()).

**Fallback safety**: All ASCII alternatives are printable and visible, ensuring compatibility with the most restrictive terminals.

**String format**: Each symbol is a String (typically 1 character for Unicode, 1-3 for ASCII). They concatenate seamlessly:

```xojo
XjTerminal.Write(XjSymbols.Check + " " + XjColor.Green("Done"))
```

**Styled combination**: Symbols work with any styling:

```xojo
Var styledCheck As String = XjColor.BoldText(XjSymbols.Check)
XjTerminal.Write(styledCheck + " Important item")
```

!!! note
    Symbols are read-only properties. They cannot be customized per-instance. If you need custom symbols, build them using XjCell and XjCanvas instead.
