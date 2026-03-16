---
title: Tree Widget
description: XjTree displays hierarchical data with expandable/collapsible nodes and professional box-drawing branches.
---

# Tree Widget

The **XjTree** widget displays hierarchical tree data with expandable nodes, indentation, and box-drawing branch lines. The **XjTreeNode** class represents individual nodes.

## XjTreeNode

### Constructor

```xojo
Var node As New XjTreeNode("Label")
```

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetLabel(label)` | String | — | Set node text |
| `GetLabel()` | — | String | Get node text |
| `AddChild(child)` | XjTreeNode | — | Add child node |
| `ChildCount()` | — | Integer | Get number of children |
| `ChildAt(index)` | Integer | XjTreeNode | Get child by index |
| `SetExpanded(expanded)` | Boolean | — | Expand/collapse node |
| `IsExpanded()` | — | Boolean | Return expand state |
| `SetNodeStyle(style)` | XjStyle | — | Set node label style |

## XjTree

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddRoot(node)` | XjTreeNode | — | Set root node |
| `SetNodeStyle(style)` | XjStyle | — | Set default node style |
| `SetBranchStyle(style)` | XjStyle | — | Set branch line style |
| `SetScrollOffset(offset)` | Integer | — | Scroll to line offset |
| `GetScrollOffset()` | — | Integer | Get current offset |
| `LineCount()` | — | Integer | Get total visible lines |

### Examples

### Build a tree structure

```xojo
Var root As New XjTreeNode("Project")

Var src As New XjTreeNode("src")
Call root.AddChild(src)

Var main As New XjTreeNode("main.xojo")
Call src.AddChild(main)

Var utils As New XjTreeNode("utils.xojo")
Call src.AddChild(utils)

Var resources As New XjTreeNode("resources")
Call root.AddChild(resources)

Var icons As New XjTreeNode("icons")
Call resources.AddChild(icons)

Var tree As New XjTree()
Call tree.AddRoot(root)
```

### Styled tree nodes

```xojo
Var root As New XjTreeNode("Root")
Call root.SetNodeStyle(XjStyle.Success())

Var child1 As New XjTreeNode("Success Item")
Call child1.SetNodeStyle(XjStyle.Success())
Call root.AddChild(child1)

Var child2 As New XjTreeNode("Warning Item")
Call child2.SetNodeStyle(XjStyle.Warning())
Call root.AddChild(child2)

Var tree As New XjTree()
Call tree.AddRoot(root)
```

### Expand/collapse nodes

```xojo
Var parent As New XjTreeNode("Parent")

For i As Integer = 1 To 5
  Var child As New XjTreeNode("Child " + i.ToString())
  Call parent.AddChild(child)
Next

Call parent.SetExpanded(True)  // Show children
// Later:
Call parent.SetExpanded(False) // Hide children
```

### Tree navigation

```xojo
Var tree As New XjTree()
Call tree.AddRoot(buildHierarchy())

Var offset As Integer = tree.GetScrollOffset()
Var total As Integer = tree.LineCount()

XjTerminal.Write("Showing " + offset.ToString() + " of " + total.ToString() + " lines")
```

### File browser tree

```xojo
Sub BuildFileTree(path As String) As XjTreeNode
  Var node As New XjTreeNode(GetFileNameFromPath(path))

  If IsDirectory(path) Then
    Var files As FolderItem = GetFolderItem(path)
    For Each item As FolderItem In files.Children
      Call node.AddChild(BuildFileTree(item.AbsolutePath))
    Next
  End If

  Return node
End Sub

Var tree As New XjTree()
Call tree.AddRoot(BuildFileTree("/home/user/documents"))
```

### Traverse tree

```xojo
Sub PrintTree(node As XjTreeNode, indent As Integer = 0)
  Var prefix As String = String.FromArray(Array(Chr(9)), "").PadRight(indent)
  XjTerminal.Write(prefix + node.GetLabel())

  For i As Integer = 0 To node.ChildCount() - 1
    Call PrintTree(node.ChildAt(i), indent + 2)
  Next
End Sub

Call PrintTree(root)
```

## Design notes

**Expandable nodes**: Nodes with children can be expanded/collapsed via SetExpanded(). Collapsed nodes hide all descendants.

**Box drawing**: Trees use box-drawing characters (├ ├ ─ └ etc.) to show hierarchy visually.

**Scrolling**: Large trees can exceed terminal height. SetScrollOffset() pans the visible window.

**Lazy loading**: You can dynamically add children when nodes are expanded (customize in subclass).

**Styling**: Individual nodes and branch lines can be styled differently for semantic meaning.

!!! note
    Trees are static display widgets. For interactive selection, build custom widgets with key handling for expand/collapse and Up/Down navigation.
