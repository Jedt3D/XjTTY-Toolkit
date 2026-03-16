---
title: Layout Solver
description: XjLayoutSolver module computes absolute positions and sizes for layout trees using a constraint-based algorithm.
---

# Layout Solver

The **XjLayoutSolver** module solves layout trees. It's a stateless solver that recursively computes absolute X/Y positions and widths/heights for all nodes given container dimensions.

## Solving

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Solve(root, width, height)` | XjLayoutNode, Integer width, height | — | Compute layout for entire tree |

## Algorithm

The solver executes 5 passes on the layout tree:

1. **Constraint resolution**: Convert constraints (percent, auto) to concrete sizes using available space
2. **Main axis layout**: Arrange children along primary direction (row/column)
3. **Cross axis layout**: Center/align children perpendicular to primary direction
4. **Border/padding accounting**: Adjust content area for padding and borders
5. **Recursion**: Repeat for all descendants

## Examples

### Solve a layout tree

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
Call root.SetWidth(XjConstraint.Fixed(80))
Call root.SetHeight(XjConstraint.Fixed(24))

Var header As New XjLayoutNode()
Call header.SetWidth(XjConstraint.Percent(100))
Call header.SetHeight(XjConstraint.Fixed(3))
Call root.AddChild(header)

Var body As New XjLayoutNode()
Call body.SetWidth(XjConstraint.Percent(100))
Call body.SetHeight(XjConstraint.Percent(100))
Call root.AddChild(body)

// Solve: compute all absolute positions/sizes
Call XjLayoutSolver.Solve(root, 80, 24)

// Now query computed values:
XjTerminal.Write("Header: " + header.ComputedX().ToString() + "," + header.ComputedY().ToString())
XjTerminal.Write("Size: " + header.ComputedWidth().ToString() + "x" + header.ComputedHeight().ToString())
```

### Multi-column layout

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_ROW)

Var col1 As New XjLayoutNode()
Call col1.SetWidth(XjConstraint.Percent(33))
Call col1.SetHeight(XjConstraint.Percent(100))

Var col2 As New XjLayoutNode()
Call col2.SetWidth(XjConstraint.Percent(33))
Call col2.SetHeight(XjConstraint.Percent(100))

Var col3 As New XjLayoutNode()
Call col3.SetWidth(XjConstraint.Percent(34))
Call col3.SetHeight(XjConstraint.Percent(100))

Call root.AddChild(col1)
Call root.AddChild(col2)
Call root.AddChild(col3)

Call XjLayoutSolver.Solve(root, 100, 30)

// col1 width = 33, col2 width = 33, col3 width = 34
// Each positioned at X = 0, 33, 66 respectively
```

### Padding and border accounting

```xojo
Var container As New XjLayoutNode()
Call container.SetWidth(XjConstraint.Fixed(50))
Call container.SetHeight(XjConstraint.Fixed(20))
Call container.SetPadding(1, 2, 1, 2)  // top, right, bottom, left
Call container.SetBorder(0, "Title")   // Border takes 1 column/row

Call XjLayoutSolver.Solve(container, 50, 20)

// Computed sizes include border:
XjTerminal.Write("Container: " + container.ComputedWidth().ToString())  // 50

// Content area is smaller:
XjTerminal.Write("Content: " + container.ContentWidth().ToString())  // 50 - 2 (left) - 2 (right) - 0 (border) = 46
XjTerminal.Write("Content area at: " + container.ContentX().ToString() + "," + container.ContentY().ToString())
```

### Nested containers with auto sizing

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
Call root.SetWidth(XjConstraint.Percent(100))
Call root.SetHeight(XjConstraint.Percent(100))

Var header As New XjLayoutNode()
Call header.SetWidth(XjConstraint.Percent(100))
Call header.SetHeight(XjConstraint.Fixed(3))

Var body As New XjLayoutNode()
Call body.SetDirection(XjLayoutNode.DIR_ROW)
Call body.SetWidth(XjConstraint.Percent(100))
Call body.SetHeight(XjConstraint.Percent(100))  // Fills remaining space

Var sidebar As New XjLayoutNode()
Call sidebar.SetWidth(XjConstraint.Fixed(25))
Call sidebar.SetHeight(XjConstraint.Percent(100))

Var content As New XjLayoutNode()
Call content.SetWidth(XjConstraint.Percent(100))
Call content.SetHeight(XjConstraint.Percent(100))

Call root.AddChild(header)
Call root.AddChild(body)
Call body.AddChild(sidebar)
Call body.AddChild(content)

Var width As Integer = XjTerminal.Width()
Var height As Integer = XjTerminal.Height()

Call XjLayoutSolver.Solve(root, width, height)

// All positions computed:
// header: (0,0) to (width, 3)
// body: (0,3) to (width, height-3)
// sidebar: (0,3) to (25, height-3)
// content: (25,3) to (width-25, height-3)
```

### Min/max constraints in layout

```xojo
Var root As New XjLayoutNode()
Call root.SetDirection(XjLayoutNode.DIR_ROW)

Var col1 As New XjLayoutNode()
Call col1.SetWidth(XjConstraint.MinMax(20, 40))  // Between 20-40 columns

Var col2 As New XjLayoutNode()
Call col2.SetWidth(XjConstraint.Percent(100))    // Fill remaining

Call root.AddChild(col1)
Call root.AddChild(col2)

Call XjLayoutSolver.Solve(root, 100, 30)

// col1 width = 40 (or less if 100 cols not enough)
// col2 width = 60 (or more if col1 is smaller)
```

### Query solved positions for rendering

```xojo
Sub RenderLayout(root As XjLayoutNode)
  Call RenderNode(root)
End Sub

Sub RenderNode(node As XjLayoutNode)
  // Get computed position/size
  Var x As Integer = node.ComputedX()
  Var y As Integer = node.ComputedY()
  Var w As Integer = node.ComputedWidth()
  Var h As Integer = node.ComputedHeight()

  // Render node at (x, y) with size w×h
  RenderBorderAndPadding(node, x, y, w, h)

  // Render children
  For i As Integer = 0 To node.ChildCount() - 1
    Call RenderNode(node.ChildAt(i))
  Next
End Sub
```

## Design notes

**Stateless**: XjLayoutSolver is a module (not a class). The Solve() method doesn't maintain state. You can call it repeatedly with different trees.

**In-place computation**: Solve() modifies the layout tree in-place, setting ComputedX, ComputedY, ComputedWidth, ComputedHeight on each node.

**Recursive algorithm**: The solver processes the entire tree in one pass. Each node is visited exactly once.

**Performance**: The solver is O(n) where n is the number of nodes. It's fast enough for dynamic relayout on every frame.

**Constraint resolution**: Percent constraints are resolved using available space at each level. A child with 50% width gets 50% of its parent's content width (minus padding).

**Direction semantics**: DIR_ROW arranges children left-to-right; DIR_COLUMN arranges top-to-bottom. Children in a row share the height; children in a column share the width.

!!! note
    XjEventLoop and XjUIParser automatically call XjLayoutSolver. Manual solver calls are needed only for custom layout handling.
