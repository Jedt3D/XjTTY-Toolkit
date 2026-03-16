---
title: XjStyle
description: XjStyle class provides an immutable fluent API for building character styling (colors, bold, italic, underline, etc.).
---

# XjStyle

The **XjStyle** class builds immutable style objects using a fluent builder pattern. Styles combine foreground color, background color, and text attributes (bold, italic, underline, etc.).

## Constructor

```xojo
Var style As New XjStyle()
```

All styles start empty (no attributes). Use setter methods to build styles.

## Style Setters (Fluent API)

All setters return a new XjStyle instance with the added attribute:

| Method | Parameter | Returns | Description |
|--------|-----------|---------|-------------|
| `SetFG(colorCode)` | Integer (0-255 or 30-97) | XjStyle | Set foreground color (ANSI code or 256-color) |
| `SetBG(colorCode)` | Integer | XjStyle | Set background color |
| `SetFGRGB(r, g, b)` | Integer (0-255) × 3 | XjStyle | Set foreground to RGB color |
| `SetBGRGB(r, g, b)` | Integer (0-255) × 3 | XjStyle | Set background to RGB color |
| `SetBold()` | — | XjStyle | Apply bold text |
| `SetDim()` | — | XjStyle | Apply dim/faint text |
| `SetItalic()` | — | XjStyle | Apply italic text |
| `SetUnderline()` | — | XjStyle | Apply underline |
| `SetInverse()` | — | XjStyle | Apply inverse (swap FG/BG) |
| `SetStrikethrough()` | — | XjStyle | Apply strikethrough |
| `SetBlink()` | — | XjStyle | Apply blinking text |

## Output Methods

| Method | Parameter | Returns | Description |
|--------|-----------|---------|-------------|
| `ToANSI()` | — | String | Convert style to ANSI escape sequence |
| `Apply(text)` | String | String | Apply style to text (returns styled text with reset) |

## Comparison & Utility

| Method | Parameter | Returns | Description |
|--------|-----------|---------|-------------|
| `Equals(other)` | XjStyle | Boolean | Compare styles for equality |
| `Clone()` | — | XjStyle | Create independent copy |
| `IsEmpty()` | — | Boolean | Return True if no attributes set |

## Shared Factories

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Default()` | — | XjStyle | Return empty style |
| `MakeBold()` | — | XjStyle | Return bold style |
| `FGColor(code)` | Integer | XjStyle | Return style with foreground color |
| `BGColor(code)` | Integer | XjStyle | Return style with background color |
| `MakeFGRGB(r, g, b)` | Integer × 3 | XjStyle | Return style with RGB foreground |
| `MakeBGRGB(r, g, b)` | Integer × 3 | XjStyle | Return style with RGB background |
| `Success()` | — | XjStyle | Return success style (green) |
| `Warning()` | — | XjStyle | Return warning style (yellow) |
| `Danger()` | — | XjStyle | Return danger style (red) |
| `Info()` | — | XjStyle | Return info style (cyan) |
| `Muted()` | — | XjStyle | Return muted style (dim) |
| `Highlight()` | — | XjStyle | Return highlight style (bright yellow) |

## Examples

### Build a style with fluent API

```xojo
Var boldRed As New XjStyle
Call boldRed.SetFG(31).SetBold()
XjTerminal.Write(boldRed.Apply("Bold red text"))
```

!!! note
    In Xojo, you must use `Call` when assigning fluent method chains for side effects, or break long chains into temp variables.

### Break long chains into variables

```xojo
Var style As New XjStyle
Call style.SetFG(31)  // Red
Call style.SetBold()
Call style.SetUnderline()

XjTerminal.Write(style.Apply("Red, bold, underlined"))
```

### Use shared factories

```xojo
Var successStyle As XjStyle = XjStyle.Success()
XjTerminal.Write(successStyle.Apply("✓ Done"))

Var warningStyle As XjStyle = XjStyle.Warning()
XjTerminal.Write(warningStyle.Apply("⚠ Caution"))
```

### RGB colors

```xojo
Var orangeStyle As New XjStyle
Call orangeStyle.SetFGRGB(255, 165, 0)

XjTerminal.Write(orangeStyle.Apply("Orange text"))
```

### Combine foreground and background

```xojo
Var invertedStyle As New XjStyle
Call invertedStyle.SetFG(37)    // White foreground
Call invertedStyle.SetBG(40)    // Black background

XjTerminal.Write(invertedStyle.Apply("Inverted colors"))
```

### Reuse styles across output

```xojo
Var errorStyle As New XjStyle
Call errorStyle.SetFG(31).SetBold()  // Red + Bold

XjTerminal.Write(errorStyle.Apply("Error: "))
XjTerminal.Write("File not found")
XjTerminal.Write(errorStyle.Apply("Error: "))
XjTerminal.Write("Connection timeout")
```

### Style comparison

```xojo
Var style1 As New XjStyle
Call style1.SetFG(31).SetBold()

Var style2 As New XjStyle
Call style2.SetFG(31).SetBold()

If style1.Equals(style2) Then
  XjTerminal.Write("Styles are the same")
End If
```

### Check for empty style

```xojo
Var empty As New XjStyle
Var styled As New XjStyle
Call styled.SetBold()

If empty.IsEmpty() Then
  XjTerminal.Write("Empty style")
End If

If Not styled.IsEmpty() Then
  XjTerminal.Write(styled.Apply("Styled text"))
End If
```

## Design notes

**Immutability**: XjStyle setters return new instances, not modifying the original. This enables safe sharing of styles across components:

```xojo
Var baseStyle As XjStyle = XjStyle.Success()
Var boldSuccess As XjStyle = baseStyle.Clone()
Call boldSuccess.SetBold()

// baseStyle is unchanged
```

**Fluent pattern**: All setters support method chaining:

```xojo
Var s As New XjStyle
Call s.SetFG(31).SetBG(47).SetBold().SetUnderline()
```

However, due to Xojo's restrictions, multi-level chains require temporary variables or `Call` statements.

**Performance**: Style creation is lightweight. Build styles once and reuse them:

```xojo
// Build style once
mErrorStyle = XjStyle.Danger()

// Reuse many times
XjTerminal.Write(mErrorStyle.Apply("Error 1"))
XjTerminal.Write(mErrorStyle.Apply("Error 2"))
XjTerminal.Write(mErrorStyle.Apply("Error 3"))
```

**Apply with reset**: The Apply() method automatically appends the ANSI reset sequence, preventing color/style bleed:

```xojo
Var s As XjStyle = XjStyle.Success()
XjTerminal.Write(s.Apply("Green") + " Normal")  // Works correctly
```

!!! warning
    Style setters take no parameters (e.g., `SetBold()` not `SetBold(True)`). They toggle attributes on; there is no "off" version because Apply() always resets.
