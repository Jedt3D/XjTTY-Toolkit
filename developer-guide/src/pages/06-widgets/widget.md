---
title: Widgets
description: XjWidget is the base class for all paintable UI components with layout, focus, and event handling.
---

# Widgets

The **XjWidget** class is the base for all UI components (text, buttons, inputs, etc.). Widgets own a layout node, respond to events, and are painted to a canvas.

## Constructor

```xojo
Var widget As New XjWidget()
```

## Layout Node Access

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `GetLayoutNode()` | — | XjLayoutNode | Access underlying layout node |
| `SetWidth(constraint)` | XjConstraint | — | Set width constraint |
| `SetHeight(constraint)` | XjConstraint | — | Set height constraint |
| `SetPadding(t, r, b, l)` | Integer × 4 | — | Set padding |
| `SetMargin(t, r, b, l)` | Integer × 4 | — | Set margin |
| `SetBorder(style, title)` | Integer, String | — | Set border and title |
| `SetName(name)` | String | — | Set widget identifier |

## Children Management

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddChild(widget)` | XjWidget | — | Add child widget |
| `RemoveChild(widget)` | XjWidget | Boolean | Remove child widget |
| `ChildCount()` | — | Integer | Get number of children |
| `ChildAt(index)` | Integer | XjWidget | Get child by index |

## Focus & Selection

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `IsFocusable()` | — | Boolean | Return True if widget can receive focus |
| `IsFocused()` | — | Boolean | Return True if widget currently focused |
| `SetFocusable(canFocus)` | Boolean | — | Enable/disable focus capability |

## Painting & Rendering

| Method | Parameter | Returns | Description |
|--------|-----------|---------|-------------|
| `Paint(canvas)` | XjCanvas | — | Paint widget and all children to canvas |
| `PaintSelf(canvas)` | XjCanvas | — | Paint only this widget (no children) |
| `MarkDirty()` | — | — | Mark widget for redraw |

## Template Methods (Override)

Subclasses override these methods to implement custom behavior:

```xojo
// Called during Paint() to draw widget content
Sub PaintContent(canvas As XjCanvas)
End Sub

// Called to handle keyboard input
Function HandleKey(event As XjKeyEvent) As Boolean
  Return False  // True if handled; False to propagate
End Function

// Called on every tick
Sub HandleTick(tickCount As Integer)
End Sub
```

## Searching

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `FindByName(name)` | String | XjWidget | Find descendant by name |
| `CollectFocusable()` | — | XjWidget() | Collect all focusable descendants |

## Examples

### Custom widget implementation

```xojo
Class MyWidget Extends XjWidget
  Private mText As String = ""

  Sub SetText(text As String)
    mText = text
    MarkDirty()
  End Sub

  Sub PaintContent(canvas As XjCanvas)
    Call canvas.WriteTextStyled(1, 1, mText, XjStyle.Success())
  End Sub

  Function HandleKey(event As XjKeyEvent) As Boolean
    If event.GetChar() = "a" Then
      mText = mText + "A"
      MarkDirty()
      Return True
    End If
    Return False
  End Function
End Class
```

### Widget tree with children

```xojo
Var container As New XjBox()
Call container.SetWidth(XjConstraint.Percent(100))
Call container.SetHeight(XjConstraint.Percent(100))
Call container.SetBorder(0, "Container")

Var header As New XjText()
Call header.SetText("Header")
Call header.SetHeight(XjConstraint.Fixed(3))

Var body As New XjBox()
Call body.SetHeight(XjConstraint.Percent(100))

Call container.AddChild(header)
Call container.AddChild(body)
```

### Find widget by name

```xojo
Var root As New XjBox()
Call root.SetName("root")

Var content As New XjText()
Call content.SetName("content")
Call root.AddChild(content)

Var found As XjWidget = root.FindByName("content")
If found <> Nil Then
  XjTerminal.Write("Found widget")
End If
```

### Collect focusable widgets

```xojo
Var root As New XjBox()

Var input1 As New XjTextInput()
Call root.AddChild(input1)

Var input2 As New XjTextInput()
Call root.AddChild(input2)

Var focusableWidgets As XjWidget() = root.CollectFocusable()
XjTerminal.Write("Found " + focusableWidgets.Count.ToString() + " focusable widgets")
```

### Custom widget with state

```xojo
Class Counter Extends XjWidget
  Private mCount As Integer = 0

  Sub Increment()
    mCount = mCount + 1
    MarkDirty()
  End Sub

  Sub Decrement()
    mCount = mCount - 1
    MarkDirty()
  End Sub

  Function HandleKey(event As XjKeyEvent) As Boolean
    Select Case event.GetChar()
      Case "+"
        Increment()
        Return True
      Case "-"
        Decrement()
        Return True
    End Select
    Return False
  End Function

  Sub PaintContent(canvas As XjCanvas)
    Var style As XjStyle = XjStyle.Info()
    Call canvas.WriteTextStyled(1, 1, "Count: " + mCount.ToString(), style)
  End Sub
End Class
```

### Nested widget hierarchy

```xojo
Var screen As New XjBox()
Call screen.SetWidth(XjConstraint.Percent(100))
Call screen.SetHeight(XjConstraint.Percent(100))

Var header As New XjBox()
Call header.SetHeight(XjConstraint.Fixed(3))
Call screen.AddChild(header)

Var mainArea As New XjBox()
Call mainArea.SetHeight(XjConstraint.Percent(100))
Call screen.AddChild(mainArea)

Var footer As New XjBox()
Call footer.SetHeight(XjConstraint.Fixed(2))
Call screen.AddChild(footer)

// Paint all widgets
Call screen.Paint(canvas)
```

## Design notes

**Layout integration**: Each widget owns a XjLayoutNode. Calling SetWidth, SetHeight, etc. modifies the layout node.

**Template method pattern**: Subclasses override PaintContent, HandleKey, HandleTick to implement custom behavior. Don't override Paint() unless you need full control.

**Marking dirty**: Call MarkDirty() whenever widget state changes to trigger redraw.

**Parent-child**: Widgets form a tree. AddChild() automatically handles parent references.

**Focus model**: Only focusable widgets can receive keyboard input. Use IsFocusable()/SetFocusable() to control.

**Painting**: Paint() recursively paints all children. PaintSelf() paints only the widget.

!!! note
    XjWidget is the base for high-level widgets (XjBox, XjText, XjTextInput, etc.). Most applications use high-level widgets instead of extending XjWidget directly.
