---
title: ระบบ Event
description: XjEvent class สำหรับแทนประเภท event (key, mouse, resize, tick, custom)
---

# ระบบ Event (XjEvent)

**XjEvent** เป็น class ที่แทน event ใดๆ ที่ app อาจได้รับ — keyboard input, mouse click, terminal resize, tick timer, หรือ custom event app-defined สิ่งสำคัญคือ event นี้เป็น discriminated union — มีข้อมูล key หรือ mouse หรือ resize ข้อมูล ไม่เสมอไป

## Constructor

```xojo
Sub New(type As Integer)
```
สร้าง event ของประเภท TYPE_KEY, TYPE_MOUSE, TYPE_RESIZE, TYPE_TICK, หรือ TYPE_CUSTOM

## Factory Methods

```xojo
Shared Function CreateKeyEvent(key As XjKeyEvent) As XjEvent
```
สร้าง key event

```xojo
Shared Function CreateMouseEvent(button As Integer, x As Integer, y As Integer, action As Integer) As XjEvent
```
สร้าง mouse event

```xojo
Shared Function CreateResizeEvent(width As Integer, height As Integer) As XjEvent
```
สร้าง resize event

```xojo
Shared Function CreateTickEvent() As XjEvent
```
สร้าง tick event (timer)

```xojo
Shared Function CreateCustomEvent(name As String, data As String) As XjEvent
```
สร้าง custom event app-defined

## Accessors

```xojo
Function EventType() As Integer
```
ดึง event type (EVENT_KEY, EVENT_MOUSE, EVENT_RESIZE, EVENT_TICK, EVENT_CUSTOM)

```xojo
Function Key() As XjKeyEvent
```
ดึง XjKeyEvent (เฉพาะสำหรับ TYPE_KEY)

```xojo
Function MouseButton() As Integer
Function MouseX() As Integer
Function MouseY() As Integer
Function MouseAction() As Integer
```
ดึง mouse info (เฉพาะสำหรับ TYPE_MOUSE)

```xojo
Function ResizeWidth() As Integer
Function ResizeHeight() As Integer
```
ดึง resize info (เฉพาะสำหรับ TYPE_RESIZE)

```xojo
Function CustomName() As String
Function CustomData() As String
```
ดึง custom event info (เฉพาะสำหรับ TYPE_CUSTOM)

```xojo
Function Timestamp() As UInt64
```
ดึง timestamp millisecond ของ event

## Type Checks

```xojo
Function IsKeyEvent() As Boolean
Function IsMouseEvent() As Boolean
Function IsResizeEvent() As Boolean
Function IsTickEvent() As Boolean
Function IsCustomEvent() As Boolean
```
ตรวจสอบประเภท event

## Event Type Constants

```xojo
Const EVENT_KEY = 1
Const EVENT_MOUSE = 2
Const EVENT_RESIZE = 3
Const EVENT_TICK = 4
Const EVENT_CUSTOM = 5
```

## Mouse Constants

### Buttons

```xojo
Const MOUSE_PRESS = 0
Const MOUSE_RELEASE = 1
Const MOUSE_DRAG = 2
Const MOUSE_SCROLL_UP = 3
Const MOUSE_SCROLL_DOWN = 4
```

## ตัวอย่างการใช้งาน

### ตรวจสอบและจัดการ Event

```xojo
Var event As XjEvent = ' ... from event loop
If event.IsKeyEvent() Then
  Var key As XjKeyEvent = event.Key()
  If key.IsEscape() Then
    ' Exit
  End If
ElseIf event.IsMouseEvent() Then
  Var x As Integer = event.MouseX()
  Var y As Integer = event.MouseY()
  Var action As Integer = event.MouseAction()
  If action = XjEvent.MOUSE_PRESS Then
    ' Handle click at (x, y)
  End If
ElseIf event.IsResizeEvent() Then
  Var w As Integer = event.ResizeWidth()
  Var h As Integer = event.ResizeHeight()
  ' Reflow layout
End If
```

### สร้าง Event

```xojo
Var key As New XjKeyEvent(XjKeyEvent.KEY_ENTER, "", False, False, False)
Var keyEvent As XjEvent = XjEvent.CreateKeyEvent(key)
```

### ดึง Timestamp

```xojo
Var ts As UInt64 = event.Timestamp()
XjTerminal.Write("Event at " + ts.ToString() + "ms")
```

### Custom Event

```xojo
Var custom As XjEvent = XjEvent.CreateCustomEvent("MyEvent", "data")
If custom.IsCustomEvent() Then
  Var name As String = custom.CustomName()
  Var data As String = custom.CustomData()
End If
```

## หมายเหตุการออกแบบ

XjEvent เป็น discriminated union pattern ที่ safe — ไม่มีการ cast unsafe หรือต้องจำเนื้อหา เพียงแค่ check type ก่อน ตามด้วย accessor ที่เหมาะสม

XjEventLoop ส่ง XjEvent ไปยัง handlers (KeyPressHandler, MouseHandler, ResizeHandler, TickHandler)

สำหรับ custom event app-defined ใช้ CreateCustomEvent เพื่อสร้าง และเฉพาะ custom name/data
