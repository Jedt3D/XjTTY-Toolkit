---
title: Event Loop
description: XjEventLoop is the main application loop that drives interactive terminal applications with keyboard, mouse, resize, and tick events.
---

# Event Loop

The **XjEventLoop** class is the central event dispatcher for interactive terminal applications. It handles keyboard input, mouse tracking, terminal resize events, and periodic tick events, delegating to your callback methods.

## Constructor

```xojo
Var loop As New XjEventLoop(refreshMs)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `refreshMs` | Integer | Tick interval in milliseconds (e.g., 50 for 20 FPS) |

## Running

| Method | Return Type | Description |
|--------|------------|-------------|
| `Run(delegate)` | — | Start event loop (blocks until Stop_() called) |
| `Stop_()` | — | Stop the event loop and return from Run() |
| `IsRunning()` | Boolean | Return True if loop is currently running |

## State

| Method | Returns | Description |
|--------|---------|-------------|
| `TickCount()` | Integer | Total ticks since loop started |
| `ElapsedSeconds()` | Double | Seconds elapsed since loop started |

## Callbacks

Assign callback objects to handle events:

| Property | Type | Description |
|----------|------|-------------|
| `KeyPressHandler` | XjEventLoop.KeyPressHandler delegate | Called on keyboard input |
| `ResizeHandler` | XjEventLoop.ResizeHandler delegate | Called on terminal resize |
| `TickHandler` | XjEventLoop.TickHandler delegate | Called periodically (main loop callback) |

## Auto Modes

| Property | Type | Description |
|----------|------|-------------|
| `AutoRawMode` | Boolean | Enable raw mode automatically (default: True) |
| `AutoAlternateScreen` | Boolean | Use alternate screen automatically (default: False) |
| `AutoHideCursor` | Boolean | Hide cursor automatically (default: True) |
| `AutoMouseTracking` | Boolean | Enable mouse tracking automatically (default: False) |

## Callback Interfaces

Implement these delegate interfaces:

```xojo
Interface KeyPressHandler
  Sub KeyPress(event As XjEvent)
End Interface

Interface ResizeHandler
  Sub Resize(width As Integer, height As Integer)
End Interface

Interface TickHandler
  Sub Tick(event As XjEvent)
End Interface
```

## Examples

### Simple event loop

```xojo
Class MyApp Implements XjEventLoop.TickHandler
  Private mLoop As XjEventLoop
  Private shouldExit As Boolean = False

  Sub Start()
    mLoop = New XjEventLoop(50)  // 50ms ticks
    mLoop.TickHandler = Me
    mLoop.Run(Me)
  End Sub

  Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
    If event.IsKeyEvent() Then
      Var key As XjKeyEvent = event.GetKeyEvent()
      If key.GetChar() = "q" Then
        shouldExit = True
        mLoop.Stop_()
      End If
    End If

    // Redraw
    XjTerminal.Write(XjScreen.Clear())
    XjTerminal.Write("Press 'q' to quit")
  End Sub
End Class
```

### Separate handlers for events and ticks

```xojo
Class MyApp Implements XjEventLoop.TickHandler, XjEventLoop.KeyPressHandler

  Sub Start()
    Var loop As New XjEventLoop(50)
    loop.TickHandler = Me
    loop.KeyPressHandler = Me
    loop.Run(Me)
  End Sub

  Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
    // Main game loop / animation
    UpdateState()
    Redraw()
  End Sub

  Sub KeyPress(event As XjEvent) Implements XjEventLoop.KeyPressHandler
    // Handle immediate keyboard input
    Var key As XjKeyEvent = event.GetKeyEvent()
    HandleKeyInput(key)
  End Sub
End Class
```

### Full-screen application with mouse

```xojo
Class MyApp Implements XjEventLoop.TickHandler

  Sub Start()
    Var loop As New XjEventLoop(33)  // ~30 FPS
    loop.AutoRawMode = True
    loop.AutoAlternateScreen = True
    loop.AutoHideCursor = True
    loop.AutoMouseTracking = True
    loop.TickHandler = Me

    XjTerminal.Write(XjCursor.Hide())
    loop.Run(Me)
    XjTerminal.Write(XjCursor.Show())
  End Sub

  Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
    Select Case event.GetType()
      Case XjEvent.EVENT_KEY
        HandleKeyboard(event.GetKeyEvent())

      Case XjEvent.EVENT_MOUSE
        HandleMouse(event.GetMouseButton(), event.GetMouseRow(), event.GetMouseCol())

      Case XjEvent.EVENT_RESIZE
        HandleResize(event.GetWidth(), event.GetHeight())

      Case XjEvent.EVENT_TICK
        UpdateAnimation(event.GetTickCount())
    End Select

    Redraw()
  End Sub

  Sub HandleKeyboard(key As XjKeyEvent)
    If key.IsEscape() Then
      mLoop.Stop_()
    End If
  End Sub

  Sub HandleMouse(button As Integer, row As Integer, col As Integer)
    Select Case button
      Case XjEvent.MOUSE_LEFT_CLICK
        ProcessClick(row, col)
      Case XjEvent.MOUSE_WHEEL_UP
        ScrollUp()
      Case XjEvent.MOUSE_WHEEL_DOWN
        ScrollDown()
    End Select
  End Sub

  Sub HandleResize(width As Integer, height As Integer)
    RecalculateLayout(width, height)
  End Sub

  Sub UpdateAnimation(tick As Integer)
    // Smooth animation using tick count
  End Sub

  Sub Redraw()
    // Clear and redraw entire screen
  End Sub

End Class
```

### Animation with tick counter

```xojo
Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
  Var tick As Integer = event.GetTickCount()

  // Blink effect every 500ms (with 50ms ticks = every 10 ticks)
  Var blinkVisible As Boolean = (tick \ 10) Mod 2 = 0

  XjTerminal.Write(XjScreen.Clear())

  If blinkVisible Then
    XjTerminal.Write("Hello " + XjColor.Red("World"))
  Else
    XjTerminal.Write("Hello World")
  End If
End Sub
```

### Elapsed time usage

```xojo
Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
  Var elapsed As Double = event.GetTickCount() * 0.05  // 50ms per tick
  Var seconds As Integer = Int(elapsed)
  Var milliseconds As Integer = Int((elapsed - seconds) * 1000)

  XjTerminal.Write("Elapsed: " + seconds.ToString() + "." + milliseconds.ToString("00"))
End Sub
```

### Early exit handling

```xojo
Sub Tick(event As XjEvent) Implements XjEventLoop.TickHandler
  If event.IsKeyEvent() Then
    Var key As XjKeyEvent = event.GetKeyEvent()

    If key.IsCtrlPressed() And key.GetChar() = "c" Then
      XjTerminal.Write("^C - Exiting")
      mLoop.Stop_()
      Return
    End If
  End If

  // Normal tick handling
  UpdateDisplay()
End Sub
```

## Design notes

**Auto modes**: By default, AutoRawMode and AutoHideCursor are True (terminal is put in raw mode and cursor is hidden). AutoAlternateScreen and AutoMouseTracking are False. Change before calling Run():

```xojo
Var loop As New XjEventLoop(50)
loop.AutoAlternateScreen = True  // Use alternate screen buffer
loop.Run(Me)
```

**Tick interval**: The refreshMs parameter determines how often TickHandler is called. Smaller values (e.g., 33ms) create smoother animation but use more CPU. Typical values: 16-50ms.

**Blocking call**: Run() blocks until Stop_() is called. Your callback methods run on the main thread.

**Cleanup**: Auto modes automatically clean up on exit (raw mode disabled, cursor shown, etc.). No manual cleanup needed.

**Tick counting**: TickCount increments on every tick. Use it for periodic actions or frame-based animation.

**Key press timing**: KeyPressHandler (if set) is called immediately on keyboard input, in addition to TickHandler receiving the event.

!!! note
    Most applications only implement TickHandler. KeyPressHandler is optional for applications that need immediate response to keypresses without waiting for the next tick.
