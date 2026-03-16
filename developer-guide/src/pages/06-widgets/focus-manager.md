---
title: Focus Manager
description: XjFocusManager handles Tab-based focus cycling among widgets in an application.
---

# Focus Manager

The **XjFocusManager** class manages keyboard focus for interactive widgets. It enables Tab/Shift+Tab navigation among focusable widgets and routes keyboard events to the focused widget.

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `BuildChain(root)` | XjWidget | — | Build focus chain from widget tree |
| `FocusNext()` | — | — | Move focus to next focusable widget |
| `FocusPrev()` | — | — | Move focus to previous widget |
| `FocusCount()` | — | Integer | Get total focusable widgets |
| `FocusedWidget()` | — | XjWidget | Get currently focused widget |
| `SetFocused(widget)` | XjWidget | Boolean | Set focus to specific widget |
| `HandleKey(event)` | XjKeyEvent | Boolean | Route keyboard to focused widget |

## Examples

### Build focus chain from widget tree

```xojo
Var root As New XjBox()

Var input1 As New XjTextInput()
Call root.AddChild(input1)

Var input2 As New XjTextInput()
Call root.AddChild(input2)

Var select As New XjSelectPrompt()
Call root.AddChild(select)

Var focusManager As New XjFocusManager()
Call focusManager.BuildChain(root)

XjTerminal.Write("Found " + focusManager.FocusCount().ToString() + " focusable widgets")
```

### Handle Tab navigation

```xojo
Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
  If event.IsKeyEvent() Then
    Var key As XjKeyEvent = event.GetKeyEvent()

    If key.IsTab() Then
      If key.IsShiftPressed() Then
        mFocusManager.FocusPrev()
      Else
        mFocusManager.FocusNext()
      End If
    Else
      // Route other keys to focused widget
      Var focusedWidget As XjWidget = mFocusManager.FocusedWidget()
      If focusedWidget <> Nil Then
        Call focusedWidget.HandleKey(key)
      End If
    End If
  End If

  Redraw()
End Sub
```

### Set focus programmatically

```xojo
Var focusManager As New XjFocusManager()
Call focusManager.BuildChain(root)

// Set focus to specific widget
Var success As Boolean = focusManager.SetFocused(myWidget)

If success Then
  XjTerminal.Write("Focus set to widget")
Else
  XjTerminal.Write("Widget is not focusable")
End If
```

### Focus indicator on render

```xojo
Sub Redraw()
  For i As Integer = 0 To mFocusManager.FocusCount() - 1
    Var widget As XjWidget = mFocusManager.FocusedWidget()

    If widget = currentWidget Then
      // Highlight focused widget
      Call canvas.WriteTextStyled(1, 1, "> " + GetWidgetLabel(widget), XjStyle.Highlight())
    Else
      Call canvas.WriteTextStyled(1, 1, "  " + GetWidgetLabel(widget), XjStyle.Default())
    End If
  Next
End Sub
```

### Focus aware event handling

```xojo
Sub HandleKeyEvent(event As XjKeyEvent)
  Select Case True
    Case event.IsTab()
      If event.IsShiftPressed() Then
        mFocusManager.FocusPrev()
      Else
        mFocusManager.FocusNext()
      End If

    Case event.IsEscape()
      shouldExit = True

    Case Else
      // Let focused widget handle it
      If Not mFocusManager.HandleKey(event) Then
        // Fallback if widget doesn't handle
        HandleGlobalShortcut(event)
      End If
  End Select
End Sub
```

### Query focus state

```xojo
Var focusManager As New XjFocusManager()
Call focusManager.BuildChain(root)

Var focused As XjWidget = focusManager.FocusedWidget()
If focused <> Nil Then
  XjTerminal.Write("Focused widget: " + focused.GetName())
  XjTerminal.Write("Total focusable: " + focusManager.FocusCount().ToString())
End If
```

## Design notes

**Focus chain**: BuildChain() traverses the widget tree depth-first and collects all focusable widgets in order.

**Tab navigation**: FocusNext() and FocusPrev() cycle through the chain. Reaching the end wraps to the beginning.

**Event routing**: HandleKey() checks if the focused widget handles the key. Returns True if handled, False if not.

**Focusable widgets**: Only widgets with IsFocusable()=True are included in the chain. Use SetFocusable() to control.

**Visual feedback**: Your render code should visually indicate which widget is focused (highlight, border, etc.).

!!! note
    XjEventLoop uses XjFocusManager internally if you have focusable widgets. For simple applications, the framework handles focus automatically.
