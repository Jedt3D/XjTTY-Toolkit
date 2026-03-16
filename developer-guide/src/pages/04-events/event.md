---
title: Event System
description: XjEvent class is a discriminated union representing all event types (keyboard, mouse, resize, tick, custom).
---

# Event System

The **XjEvent** class is a discriminated union that can hold any event type: key, mouse, resize, tick, or custom. It's used by XjEventLoop and XjReader to deliver all event types through a single interface.

## Event Type Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `EVENT_KEY` | 1 | Keyboard input event |
| `EVENT_MOUSE` | 2 | Mouse input event |
| `EVENT_RESIZE` | 3 | Terminal resize event |
| `EVENT_TICK` | 4 | Timer tick event |
| `EVENT_CUSTOM` | 5 | Custom user event |

## Mouse Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `MOUSE_LEFT_CLICK` | 0 | Left mouse button click |
| `MOUSE_RIGHT_CLICK` | 1 | Right mouse button click |
| `MOUSE_MIDDLE_CLICK` | 2 | Middle mouse button click |
| `MOUSE_WHEEL_UP` | 3 | Mouse wheel scroll up |
| `MOUSE_WHEEL_DOWN` | 4 | Mouse wheel scroll down |
| `MOUSE_MOVE` | 5 | Mouse move (no buttons) |

## Factory Methods

Create events using factory methods:

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `CreateKeyEvent(keyEvent)` | XjKeyEvent | XjEvent | Create key event |
| `CreateResizeEvent(width, height)` | Integer, Integer | XjEvent | Create resize event |
| `CreateMouseEvent(button, row, col)` | Integer button, row, col | XjEvent | Create mouse event |
| `CreateTickEvent(tickCount)` | Integer | XjEvent | Create tick event |
| `CreateCustomEvent(tag, data)` | String tag; Any | XjEvent | Create custom event |

## Type Checking

| Method | Returns | Description |
|--------|---------|-------------|
| `GetType()` | Integer | Get event type (EVENT_KEY, EVENT_MOUSE, etc.) |
| `IsKeyEvent()` | Boolean | Return True if key event |
| `IsMouseEvent()` | Boolean | Return True if mouse event |
| `IsResizeEvent()` | Boolean | Return True if resize event |
| `IsTickEvent()` | Boolean | Return True if tick event |
| `IsCustomEvent()` | Boolean | Return True if custom event |

## Data Access

Access event data after type checking:

| Method | Returns | Description |
|--------|---------|-------------|
| `GetKeyEvent()` | XjKeyEvent | Get key event data (if IsKeyEvent) |
| `GetMouseButton()` | Integer | Get mouse button code |
| `GetMouseRow()` | Integer | Get mouse row (1-based) |
| `GetMouseCol()` | Integer | Get mouse column (1-based) |
| `GetWidth()` | Integer | Get new width (if resize) |
| `GetHeight()` | Integer | Get new height (if resize) |
| `GetTickCount()` | Integer | Get tick count (if tick) |
| `GetCustomTag()` | String | Get custom event tag |
| `GetCustomData()` | Any | Get custom event data |

## Examples

### Dispatch event in event loop

```xojo
Sub HandleEvent(event As XjEvent)
  Select Case event.GetType()
    Case XjEvent.EVENT_KEY
      HandleKeyInput(event.GetKeyEvent())

    Case XjEvent.EVENT_MOUSE
      HandleMouseInput(event.GetMouseButton(), event.GetMouseRow(), event.GetMouseCol())

    Case XjEvent.EVENT_RESIZE
      HandleResize(event.GetWidth(), event.GetHeight())

    Case XjEvent.EVENT_TICK
      HandleTick(event.GetTickCount())

    Case XjEvent.EVENT_CUSTOM
      HandleCustomEvent(event.GetCustomTag(), event.GetCustomData())
  End Select
End Sub
```

### Create and dispatch custom event

```xojo
// In your event loop
Var customEvent As XjEvent = XjEvent.CreateCustomEvent("download_complete", downloadedData)
HandleEvent(customEvent)
```

### Handle mouse click

```xojo
If event.IsMouseEvent() Then
  Select Case event.GetMouseButton()
    Case XjEvent.MOUSE_LEFT_CLICK
      XjTerminal.Write("Left click at " + event.GetMouseRow().ToString() + "," + event.GetMouseCol().ToString())

    Case XjEvent.MOUSE_RIGHT_CLICK
      ShowContextMenu(event.GetMouseRow(), event.GetMouseCol())

    Case XjEvent.MOUSE_WHEEL_UP
      ScrollUp()

    Case XjEvent.MOUSE_WHEEL_DOWN
      ScrollDown()
  End Select
End If
```

### Handle terminal resize

```xojo
If event.IsResizeEvent() Then
  Var newWidth As Integer = event.GetWidth()
  Var newHeight As Integer = event.GetHeight()

  XjTerminal.Write("Terminal resized to " + newWidth.ToString() + "x" + newHeight.ToString())

  // Recalculate layout
  RecalculateLayout(newWidth, newHeight)
  Redraw()
End If
```

### Handle tick events

```xojo
If event.IsTickEvent() Then
  Var tick As Integer = event.GetTickCount()

  If tick Mod 10 = 0 Then
    // Every 10 ticks (e.g., every 500ms with 50ms tick interval)
    UpdateAnimation()
  End If

  Redraw()
End If
```

### Type-safe event handling with guard

```xojo
If event.IsKeyEvent() Then
  Var keyEvent As XjKeyEvent = event.GetKeyEvent()

  If keyEvent.IsEscape() Then
    shouldExit = True
  ElseIf keyEvent.IsArrow() Then
    HandleNavigation(keyEvent)
  ElseIf keyEvent.IsCharKey() Then
    HandleCharInput(keyEvent.GetChar())
  End If
End If
```

### Combined event handling

```xojo
Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
  // Handle all event types
  If event.IsKeyEvent() Then
    Var key As XjKeyEvent = event.GetKeyEvent()
    If key.GetChar() = "q" Then
      mLoop.Stop_()
    End If
  ElseIf event.IsMouseEvent() Then
    HandleMouseClick(event.GetMouseButton(), event.GetMouseRow(), event.GetMouseCol())
  ElseIf event.IsResizeEvent() Then
    HandleTerminalResize(event.GetWidth(), event.GetHeight())
  End If

  Redraw()
End Sub
```

## Design notes

**Discriminated union pattern**: XjEvent is a discriminated union (tagged union). It can hold any single event type, but not multiple types. Always check the type before accessing data:

```xojo
If event.IsKeyEvent() Then
  Var key As XjKeyEvent = event.GetKeyEvent()
  // Safe to access key-specific methods
End If
```

**Safe data access**: Calling GetKeyEvent() on a non-key event returns an empty key event. Always type-check first.

**Factory pattern**: Use factory methods to create events. Don't construct XjEvent directly.

**Event loop integration**: XjEventLoop creates and dispatches XjEvent objects via your callback methods. You rarely create events manually.

**Custom events**: Use EVENT_CUSTOM to implement domain-specific events (download complete, socket data, etc.). The custom data can be any object.

!!! note
    Events are immutable. Once created, they cannot be modified. Create a new event if you need different data.
