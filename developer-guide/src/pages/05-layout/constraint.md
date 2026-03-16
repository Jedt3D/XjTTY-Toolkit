---
title: Constraints
description: XjConstraint class represents size constraints (Fixed, Percent, Auto) with min/max bounds for flexible layout.
---

# Constraints

The **XjConstraint** class defines size constraints for layout nodes. A constraint can be a fixed size, a percentage of available space, automatic (content-based), or a range with min/max bounds.

## Constraint Modes

| Constant | Value | Description |
|----------|-------|-------------|
| `MODE_AUTO` | 0 | Automatic sizing (based on content) |
| `MODE_FIXED` | 1 | Fixed size in columns/rows |
| `MODE_PERCENT` | 2 | Percentage of available space |
| `MODE_MINMAX` | 3 | Range constraint (min and max bounds) |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `Mode()` | Integer | Get constraint mode (MODE_*) |
| `Value()` | Integer | Get primary value (size or percent) |
| `MinValue()` | Integer | Get minimum value |
| `MaxValue()` | Integer | Get maximum value |

## Factory Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Auto()` | — | XjConstraint | Create auto-sizing constraint |
| `Fixed(size)` | Integer | XjConstraint | Create fixed-size constraint |
| `Percent(percent)` | Integer | XjConstraint | Create percentage constraint |
| `MinMax(min, max)` | Integer min, max | XjConstraint | Create range constraint |

## Modification

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetMin(min)` | Integer | XjConstraint | Set minimum value |
| `SetMax(max)` | Integer | XjConstraint | Set maximum value |
| `Clone()` | — | XjConstraint | Create independent copy |

## Solving

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Resolve(available)` | Integer | Integer | Resolve constraint to concrete size given available space |

## Examples

### Fixed size constraint

```xojo
Var fixed As XjConstraint = XjConstraint.Fixed(20)
Var resolved As Integer = fixed.Resolve(100)  // Always 20

XjTerminal.Write("Fixed size: " + resolved.ToString())
```

### Percentage constraint

```xojo
Var percent As XjConstraint = XjConstraint.Percent(50)
Var resolved As Integer = percent.Resolve(100)  // 50% of 100 = 50

XjTerminal.Write("50% of 100: " + resolved.ToString())
```

### Auto constraint

```xojo
Var auto As XjConstraint = XjConstraint.Auto()
// Resolve returns 0; layout engine uses content size

Var widget As New XjText()
Call widget.SetWidth(auto)  // Width determined by text content
```

### Min/max range

```xojo
Var range As XjConstraint = XjConstraint.MinMax(10, 50)
Var resolved1 As Integer = range.Resolve(5)   // Clamped to min: 10
Var resolved2 As Integer = range.Resolve(30)  // Within range: 30
Var resolved3 As Integer = range.Resolve(100) // Clamped to max: 50
```

### Building widgets with constraints

```xojo
Var box As New XjBox()
Call box.SetWidth(XjConstraint.Percent(80))   // 80% of container width
Call box.SetHeight(XjConstraint.Fixed(10))    // Fixed 10 rows
```

### Responsive layout with min/max

```xojo
Var sidebar As New XjBox()
Call sidebar.SetWidth(XjConstraint.MinMax(20, 40))  // Between 20-40 columns

Var mainContent As New XjBox()
Call mainContent.SetWidth(XjConstraint.Percent(100))  // Fill remaining space
```

### Constraint chaining

```xojo
Var constraint As XjConstraint = XjConstraint.Percent(50)
Call constraint.SetMin(10)  // But at least 10
Call constraint.SetMax(100) // And at most 100

Var resolved1 As Integer = constraint.Resolve(5)    // 50% of 5=2.5→max(10)=10
Var resolved2 As Integer = constraint.Resolve(50)   // 50% of 50=25 (within range)
Var resolved3 As Integer = constraint.Resolve(300)  // 50% of 300=150→min(100)=100
```

### Query constraint properties

```xojo
Var fixed As XjConstraint = XjConstraint.Fixed(25)

If fixed.Mode() = XjConstraint.MODE_FIXED Then
  XjTerminal.Write("Fixed to: " + fixed.Value().ToString())
End If

Var range As XjConstraint = XjConstraint.MinMax(10, 50)
XjTerminal.Write("Range: " + range.MinValue().ToString() + "-" + range.MaxValue().ToString())
```

### Copy and modify constraint

```xojo
Var original As XjConstraint = XjConstraint.Percent(50)
Var modified As XjConstraint = original.Clone()
Call modified.SetMin(20)  // Don't shrink below 20 columns

// original unchanged; modified has new min
```

## Design notes

**Resolution algorithm**: Constraint.Resolve() applies constraints in order:
1. If MODE_FIXED: return Value
2. If MODE_PERCENT: return (Value * available) / 100
3. If MODE_MINMAX: clamp resolved value to [Min, Max]
4. If MODE_AUTO: return 0 (layout engine uses content size)

**Flexibility**: Percent and MinMax constraints enable responsive layouts. Use Percent for flexible sizing and MinMax for boundaries.

**Layout integration**: Layout nodes use constraints to determine their final size. XjLayoutSolver calls Resolve() with available space.

**Immutability**: Constraint methods return new instances (except Resolve which is query-only). You can safely share constraints:

```xojo
Var columnWidth As XjConstraint = XjConstraint.Fixed(20)
Call col1.SetWidth(columnWidth)
Call col2.SetWidth(columnWidth)  // Safe to reuse
```

!!! note
    Most applications don't interact with XjConstraint directly. They use string syntax in YAML UI definitions ("auto", "50%", "20-100") which are parsed into constraints automatically.
