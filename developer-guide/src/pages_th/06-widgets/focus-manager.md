---
title: Focus Manager
description: XjFocusManager class สำหรับจัดการ keyboard focus ระหว่าง widgets
---

# Focus Manager (XjFocusManager)

**XjFocusManager** ย่อมให้ Tab/Shift+Tab navigation ระหว่าง focusable widgets ไปหา Widget hierarchy — ใช้ CollectFocusable() เพื่อสร้าง focus chain จากนั้นปล่อยให้ handler ส่งต่อ keyboard input ไปยัง focused widget

## Constructor

```xojo
Sub New()
```
สร้าง focus manager ว่างเปล่า

## Building Focus Chain

```xojo
Sub BuildChain(root As XjWidget)
```
รวบรวม focusable widgets จาก root widget hierarchy โดยใช้ CollectFocusable() แนวหุ่นเหมือนกับลำดับจากบนลงล่าง tree traversal

## Navigation

```xojo
Sub FocusNext()
```
เลื่อน focus ไปยัง focusable widget ถัดไป (wrap around ที่ส่วนท้าย)

```xojo
Sub FocusPrev()
```
เลื่อน focus ไปยัง focusable widget ก่อนหน้า (wrap around ที่จุดเริ่มต้น)

## Status

```xojo
Function FocusedWidget() As XjWidget
```
ดึง currently focused widget (หรือ Nil ถ้าไม่มี)

```xojo
Function FocusCount() As Integer
```
ดึงจำนวน focusable widgets ใน chain

## Event Routing

```xojo
Function HandleKey(key As XjKeyEvent) As Boolean
```
ส่งต่อ keyboard event ไปยัง focused widget — ถ้า Tab ให้ FocusNext(), ถ้า Shift+Tab ให้ FocusPrev(), มิฉะนั้นส่งต่อ HandleKey() ของ focused widget

## ตัวอย่างการใช้งาน

### สร้าง Focus Chain

```xojo
Var form As New XjBox
form.SetTitle("Form")

Var input1 As New XjTextInput
input1.SetLabel("Name:", XjStyle.Default_())

Var input2 As New XjTextInput
input2.SetLabel("Email:", XjStyle.Default_())

form.AddChild(input1)
form.AddChild(input2)

Var manager As New XjFocusManager
manager.BuildChain(form)
```

### Focus Navigation

```xojo
Var manager As New XjFocusManager
manager.BuildChain(root)

' Move to next focusable widget
manager.FocusNext()

' Or previous
manager.FocusPrev()

' Check what's focused
If manager.FocusedWidget() <> Nil Then
  XjTerminal.Write("Focused: " + manager.FocusedWidget().Name())
End If
```

### Keyboard Event Routing

```xojo
Var manager As New XjFocusManager
manager.BuildChain(root)

' In event loop:
Var key As XjKeyEvent = ' ... from reader
If manager.HandleKey(key) Then
  ' Tab or widget consumed key
Else
  ' Key not consumed
End If
```

### Focus Chain Info

```xojo
Var manager As New XjFocusManager
manager.BuildChain(root)

Var count As Integer = manager.FocusCount()
XjTerminal.Write("Focusable widgets: " + count.ToString())

If count > 0 Then
  Var first As XjWidget = manager.FocusedWidget()
  If first <> Nil Then
    XjTerminal.Write("First focused: " + first.Name())
  End If
End If
```

## Focus Chain Order

Focus chain ถูก build โดย tree traversal (depth-first, pre-order):

```
Form
├─ Input 1 (focus index 0)
├─ Input 2 (focus index 1)
├─ Button  (focus index 2)
└─ Checkbox (focus index 3)

Tab: 0 -> 1 -> 2 -> 3 -> 0 (wrap)
Shift+Tab: 0 -> 3 -> 2 -> 1 -> 0 (wrap)
```

## หมายเหตุการออกแบบ

BuildChain() ต้องเรียกหลัง widget hierarchy สร้างเสร็จ — มันสแกน tree และสร้าง list ของ focusable widgets

HandleKey() ตรวจสอบ Tab/Shift+Tab แรก — ถ้าใช่ให้ FocusNext()/FocusPrev() มิฉะนั้นส่งต่อ HandleKey() ของ focused widget

FocusedWidget() ส่งคืน Nil ถ้า chain ว่างเปล่า (ไม่มี focusable widgets)

XjEventLoop ปกติ integrates FocusManager — ลอง XjWidget's SetFocusable() และ SetFocused() เพื่อ control focus state
