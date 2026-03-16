---
title: Layout Nodes
description: XjLayoutNode represents a tree node in the flexbox-like layout system with constraints, padding, margins, and borders.
---

# Layout Nodes

The **XjLayoutNode** class represents a single node in a layout tree. Each node has constraints, padding, margin, border, children, and computed position/size.

## Direction Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `DIR_ROW` | 0 | Horizontal layout (children left to right) |
| `DIR_COLUMN` | 1 | Vertical layout (children top to bottom) |

## Fluent Setters

All setters return the node for chaining:

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetDirection(dir)` | Integer (DIR_ROW or DIR_COLUMN) | XjLayoutNode | Set layout direction |
| `SetWidth(constraint)` | XjConstraint | XjLayoutNode | Set width constraint |
| `SetHeight(constraint)` | XjConstraint | XjLayoutNode | Set height constraint |
| `SetPadding(top, right, bottom, left)` | Integer × 4 | XjLayoutNode | Set inner padding |
| `SetMargin(top, right, bottom, left)` | Integer × 4 | XjLayoutNode | Set outer margin |
| `SetBorder(borderStyle, title)` | Integer style, String title | XjLayoutNode | Set border (0-4, optional title) |
| `SetName(name)` | String | XjLayoutNode | Set node identifier |
| `SetTitle(title)` | String | XjLayoutNode | Set border title text |
| `AddChild(child)` | XjLayoutNode | XjLayoutNode | Add child node (returns self) |

## Child Management

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `ChildCount()` | — | Integer | Get number of children |
| `ChildAt(index)` | Integer | XjLayoutNode | Get child at index (0-based) |
| `RemoveChild(child)` | XjLayoutNode | Boolean | Remove child (returns success) |
| `RemoveAllChildren()` | — | — | Remove all children |

## Computed Properties

These are set by XjLayoutSolver after solving:

| Property | Returns | Description |
|----------|---------|-------------|
| `ComputedX()` | Integer | Absolute X position (column) |
| `ComputedY()` | Integer | Absolute Y position (row) |
| `ComputedWidth()` | Integer | Computed width including border/padding |
| `ComputedHeight()` | Integer | Computed height including border/padding |

## Content Area

| Property | Returns | Description |
|----------|---------|-------------|
| `ContentX()` | Integer | X position of content area (inside padding) |
| `ContentY()` | Integer | Y position of content area (inside padding) |
| `ContentWidth()` | Integer | Width of content area (minus padding/border) |
| `ContentHeight()` | Integer | Height of content area (minus padding/border) |

## Searching

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `FindByName(name)` | String | XjLayoutNode | Find descendant by name (breadth-first) |

## Examples

### Build a layout tree

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
Call root.SetWidth(XjConstraint.Fixed(80))
Call root.SetHeight(XjConstraint.Fixed(24))

Var header As New XjLayoutNode()
Call header.SetWidth(XjConstraint.Percent(100))
Call header.SetHeight(XjConstraint.Fixed(3))
Call header.SetBorder(0, "Header")  // Single-line border with title

Var body As New XjLayoutNode()
Call body.SetDirection(XjLayoutNode.DIR_ROW)
Call body.SetWidth(XjConstraint.Percent(100))
Call body.SetHeight(XjConstraint.Percent(100))

Var sidebar As New XjLayoutNode()
Call sidebar.SetWidth(XjConstraint.Fixed(20))
Call sidebar.SetHeight(XjConstraint.Percent(100))

Var content As New XjLayoutNode()
Call content.SetWidth(XjConstraint.Percent(100))
Call content.SetHeight(XjConstraint.Percent(100))

Call root.AddChild(header)
Call root.AddChild(body)
Call body.AddChild(sidebar)
Call body.AddChild(content)
```

### Set padding and margin

```xojo
Var box As New XjLayoutNode()
Call box.SetWidth(XjConstraint.Fixed(30))
Call box.SetHeight(XjConstraint.Fixed(10))

// Inner spacing (inside border)
Call box.SetPadding(1, 2, 1, 2)  // top, right, bottom, left

// Outer spacing (outside border)
Call box.SetMargin(1, 0, 1, 0)
```

### Add border and title

```xojo
Var panel As New XjLayoutNode()
Call panel.SetBorder(XjCanvas.BORDER_SINGLE, "Settings")

// Or set/update title separately
Call panel.SetTitle("Options")
```

### Find node by name

```xojo
Var root As New XjLayoutNode()
Call root.SetName("root")

Var child As New XjLayoutNode()
Call child.SetName("content")
Call root.AddChild(child)

Var found As XjLayoutNode = root.FindByName("content")
If found <> Nil Then
  XjTerminal.Write("Found node: " + found.ComputedWidth().ToString())
End If
```

### Responsive two-column layout

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_ROW)
Call root.SetWidth(XjConstraint.Percent(100))
Call root.SetHeight(XjConstraint.Percent(100))

Var col1 As New XjLayoutNode()
Call col1.SetWidth(XjConstraint.Percent(30))
Call col1.SetHeight(XjConstraint.Percent(100))

Var col2 As New XjLayoutNode()
Call col2.SetWidth(XjConstraint.Percent(70))
Call col2.SetHeight(XjConstraint.Percent(100))

Call root.AddChild(col1)
Call root.AddChild(col2)

// After solving, col1 and col2 widths are computed
```

### Nested containers

```xojo
Var main As New XjLayoutNode()
Call main.SetDirection(XjLayoutNode.DIR_COLUMN)

Var top As New XjLayoutNode()
Call top.SetHeight(XjConstraint.Fixed(5))

Var middle As New XjLayoutNode()
Call middle.SetDirection(XjLayoutNode.DIR_ROW)
Call middle.SetHeight(XjConstraint.Percent(100))

Var bottom As New XjLayoutNode()
Call bottom.SetHeight(XjConstraint.Fixed(3))

Call main.AddChild(top)
Call main.AddChild(middle)
Call main.AddChild(bottom)
```

### Query computed layout

```xojo
// After XjLayoutSolver.Solve(root, width, height):
Var x As Integer = node.ComputedX()
Var y As Integer = node.ComputedY()
Var w As Integer = node.ComputedWidth()
Var h As Integer = node.ComputedHeight()

// Content area (inside padding):
Var contentX As Integer = node.ContentX()
Var contentY As Integer = node.ContentY()
Var contentW As Integer = node.ContentWidth()
Var contentH As Integer = node.ContentHeight()
```

### Child iteration

```xojo
For i As Integer = 0 To node.ChildCount() - 1
  Var child As XjLayoutNode = node.ChildAt(i)
  XjTerminal.Write("Child " + i.ToString() + ": " + child.ComputedWidth().ToString())
Next
```

## Design notes

**Flexbox-inspired**: XjLayoutNode uses a simplified flexbox model: containers have direction (row/column), children are arranged sequentially.

**Constraint system**: Width and height use XjConstraint, enabling fixed, percentage, and automatic sizing.

**Tree structure**: Nodes form a tree; parent-child relationships define layout hierarchy. XjLayoutSolver recursively computes positions.

**Immutable setters**: All setters return the node for fluent chaining. However, SetPadding/SetMargin take all 4 values at once (no partial updates).

**Padding vs Margin**: Padding is inside the border (affects content area); margin is outside (affects sibling spacing).

**Border and title**: Borders use the 5 box-drawing styles (0=single, 1=double, etc.). Titles appear in the top border.

!!! note
    Most applications use XjUIParser to build layout trees from YAML. Direct XjLayoutNode manipulation is advanced; use high-level widgets instead.
