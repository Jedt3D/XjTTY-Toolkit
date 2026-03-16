---
title: Colors
description: XjColor module provides convenient color functions, gradients, semantic colors, and text styling for terminal output.
---

# Colors

The **XjColor** module offers convenience functions for colored and styled text without building ANSI codes manually. All methods return styled strings ready to print.

## Basic Colors

All colors return styled text (prefix + content + reset):

```xojo
Var output As String = XjColor.Red("Error")
XjTerminal.Write(output)
```

### Named foreground colors

| Method | Color |
|--------|-------|
| `Black(text)` | Black text |
| `Red(text)` | Red text |
| `Green(text)` | Green text |
| `Yellow(text)` | Yellow text |
| `Blue(text)` | Blue text |
| `Magenta(text)` | Magenta text |
| `Cyan(text)` | Cyan text |
| `White(text)` | White text |

### Bright foreground colors

| Method | Color |
|--------|-------|
| `BrightBlack(text)` | Bright Black (Gray) |
| `BrightRed(text)` | Bright Red |
| `BrightGreen(text)` | Bright Green |
| `BrightYellow(text)` | Bright Yellow |
| `BrightBlue(text)` | Bright Blue |
| `BrightMagenta(text)` | Bright Magenta |
| `BrightCyan(text)` | Bright Cyan |
| `BrightWhite(text)` | Bright White |

### Text styling

| Method | Effect |
|--------|--------|
| `BoldText(text)` | Bold/bright text |
| `DimText(text)` | Dim/faint text |
| `ItalicText(text)` | Italic text |
| `UnderlineText(text)` | Underlined text |
| `StrikethroughText(text)` | Strikethrough text |
| `InverseText(text)` | Swap foreground/background |

## Background Colors

Apply background color while keeping foreground:

| Method | Color |
|--------|-------|
| `OnBlack(text)` | Black background |
| `OnRed(text)` | Red background |
| `OnGreen(text)` | Green background |
| `OnYellow(text)` | Yellow background |
| `OnBlue(text)` | Blue background |
| `OnMagenta(text)` | Magenta background |
| `OnCyan(text)` | Cyan background |
| `OnWhite(text)` | White background |

### Bright background colors

| Method | Color |
|--------|-------|
| `OnBrightBlack(text)` | Bright Black background |
| `OnBrightRed(text)` | Bright Red background |
| `OnBrightGreen(text)` | Bright Green background |
| `OnBrightYellow(text)` | Bright Yellow background |
| `OnBrightBlue(text)` | Bright Blue background |
| `OnBrightMagenta(text)` | Bright Magenta background |
| `OnBrightCyan(text)` | Bright Cyan background |
| `OnBrightWhite(text)` | Bright White background |

## Advanced Colors

### RGB Color

True color (24-bit) support. Returns styled text with RGB foreground:

| Method | Parameters | Description |
|--------|-----------|-------------|
| `RGB(text, r, g, b)` | String text, Integer r, g, b (0-255) | RGB foreground color |
| `RGBBG(text, r, g, b)` | String text, Integer r, g, b (0-255) | RGB background color |

### 256-Color Palette

| Method | Parameters | Description |
|--------|-----------|-------------|
| `Color256(text, code)` | String text, Integer code (0-255) | 256-color foreground |
| `BGColor256(text, code)` | String text, Integer code (0-255) | 256-color background |

### Gradients

Smooth color transitions across text:

| Method | Parameters | Description |
|--------|-----------|-------------|
| `Gradient(text, startR, startG, startB, endR, endG, endB)` | String text, 6× Integer (0-255) | RGB gradient from start to end color |
| `Rainbow(text)` | String text | Predefined rainbow gradient |

## Semantic Colors

High-level color functions with semantic meaning:

| Method | Parameter | Description |
|--------|-----------|-------------|
| `Success(text)` | String | Green color for success messages |
| `Warning(text)` | String | Yellow color for warnings |
| `Error_(text)` | String | Red color for errors |
| `Info(text)` | String | Cyan color for informational messages |
| `Muted(text)` | String | Dim gray for secondary text |
| `Highlight(text)` | String | Bright yellow for highlights |

## Global Control

| Method | Return Type | Description |
|--------|------------|-------------|
| `DisableColors()` | — | Disable all color output (returns plain text) |
| `EnableColors()` | — | Re-enable color output |
| `AreColorsEnabled()` | Boolean | Return whether colors are currently enabled |

## Examples

### Basic colored output

```xojo
XjTerminal.Write(XjColor.Red("Error: ") + "something went wrong")
XjTerminal.Write(XjColor.Green("✓ Success!"))
```

### Semantic colors

```xojo
XjTerminal.Write(XjColor.Success("All tests passed"))
XjTerminal.Write(XjColor.Warning("Running in debug mode"))
XjTerminal.Write(XjColor.Error_("Connection timeout"))
```

### Combined styles

```xojo
Var important As String = XjColor.BoldText(XjColor.Red("CRITICAL"))
XjTerminal.Write(important)
```

### RGB colors

```xojo
// Custom orange: RGB(255, 165, 0)
XjTerminal.Write(XjColor.RGB("Warning", 255, 165, 0))

// Custom gradient
XjTerminal.Write(XjColor.Gradient("Gradient", 255, 0, 0, 0, 0, 255))
```

### Conditional colors based on terminal support

```xojo
If XjTerminal.SupportsColor() Then
  Select Case XjTerminal.ColorDepth()
    Case 256
      XjTerminal.Write(XjColor.Color256("Text", 196)) // 256-color palette
    Case Else
      XjTerminal.Write(XjColor.BrightRed("Text")) // Use basic colors
  End Select
Else
  XjTerminal.Write("[ERROR] Something went wrong")
End If
```

### Conditional disabling

```xojo
If Environment.OSVersion.StartsWith("Windows") And Not hasTrue ColorSupport Then
  XjColor.DisableColors()
End If

XjTerminal.Write(XjColor.Green("This respects the setting"))
```

### Background and foreground

```xojo
// Red text on white background
XjTerminal.Write(XjColor.OnWhite(XjColor.Red("Alert")))
```

## Design notes

**Automatic reset**: All color functions automatically append the ANSI reset sequence. Colors don't bleed into subsequent text.

**Composable**: Colors can be nested since each function handles its own reset:

```xojo
Var result As String = XjColor.Bold(XjColor.Red("Bold Red"))
```

**Performance**: Color functions are lightweight string builders. They don't perform I/O — only XjTerminal.Write() does.

**Disabling colors**: Call `XjColor.DisableColors()` before using any color functions to get plain text instead. Useful for piping output to files or CI/CD systems that don't support ANSI codes.
