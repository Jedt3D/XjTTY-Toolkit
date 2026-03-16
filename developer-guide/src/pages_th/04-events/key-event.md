---
title: Key Event
description: XjKeyEvent class สำหรับแทนการกด keyboard event
---

# Key Event (XjKeyEvent)

**XjKeyEvent** แทน single keyboard event — อักขระที่กด, key code (Enter, Escape, arrow, ฯลฯ), และ modifier flags (Ctrl, Alt, Shift) สิ่งสำคัญคือเมื่อผู้ใช้กด keyboard terminal ส่ง escape sequence เราต้อง parse ลำดับนั้นและแปลงมันเป็น XjKeyEvent

## Constructor

```xojo
Sub New(keyCode As Integer, char As String, ctrl As Boolean, alt As Boolean, shift As Boolean)
```
สร้าง key event ที่มี key code, อักขระ, และ modifier flags

## Accessors

```xojo
Function KeyCode() As Integer
```
ดึง key code (KEY_ENTER, KEY_ESCAPE, KEY_CHAR, เป็นต้น)

```xojo
Function Char() As String
```
ดึงอักขระที่กด (เทพ่อที่ KEY_CHAR)

## Modifier Flags

```xojo
Function IsCtrl() As Boolean
Function IsAlt() As Boolean
Function IsShift() As Boolean
```
ตรวจสอบว่า modifier ใดถูกกด

## Key Tests

```xojo
Function IsCharKey() As Boolean
```
คืน `True` ถ้า key code == KEY_CHAR (อักขระธรรมดา)

```xojo
Function IsEnter() As Boolean
Function IsEscape() As Boolean
Function IsTab() As Boolean
Function IsBackspace() As Boolean
Function IsDelete() As Boolean
```
ตรวจสอบพิเศษ key

```xojo
Function IsArrow() As Boolean
```
คืน `True` ถ้าเป็น arrow key (UP, DOWN, LEFT, RIGHT)

```xojo
Function IsArrowUp/Down/Left/Right() As Boolean
```
ตรวจสอบ arrow key เฉพาะ

```xojo
Function IsHome() As Boolean
Function IsEnd() As Boolean
Function IsPageUp() As Boolean
Function IsPageDown() As Boolean
Function IsInsert() As Boolean
```
ตรวจสอบ navigation key อื่นๆ

```xojo
Function IsFunction() As Boolean
```
คืน `True` ถ้าเป็น F1-F12

```xojo
Function IsFunctionKey(num As Integer) As Boolean
```
ตรวจสอบ function key เฉพาะ (1-12)

## Output

```xojo
Function KeyName() As String
```
คืนชื่อ key ในรูป string เช่น "Enter", "Escape", "ArrowUp", "Ctrl+A", "F1"

```xojo
Function ToString() As String
```
เหมือนกับ KeyName()

## Key Code Constants

### Character Key

```xojo
Const KEY_CHAR = 0 ' Regular character
```

### Special Keys

```xojo
Const KEY_ENTER = 1
Const KEY_ESCAPE = 2
Const KEY_TAB = 3
Const KEY_BACKTAB = 4 ' Shift+Tab
Const KEY_BACKSPACE = 5
Const KEY_DELETE = 6
```

### Arrow Keys

```xojo
Const KEY_UP = 10
Const KEY_DOWN = 11
Const KEY_RIGHT = 12
Const KEY_LEFT = 13
```

### Navigation Keys

```xojo
Const KEY_HOME = 14
Const KEY_END = 15
Const KEY_PAGEUP = 16
Const KEY_PAGEDOWN = 17
Const KEY_INSERT = 18
```

### Function Keys

```xojo
Const KEY_F1 = 20
Const KEY_F2 = 21
' ... up to ...
Const KEY_F12 = 31
```

## ตัวอย่างการใช้งาน

### ตรวจสอบ Key ใน Event Handler

```xojo
Var key As XjKeyEvent = ' ... from input reader
If key.IsEscape() Then
  ' Exit app
ElseIf key.IsArrowUp() Then
  ' Move selection up
ElseIf key.IsCharKey() And key.Char() = "q" Then
  ' Quit
End If
```

### ตรวจสอบ Modifier

```xojo
If key.IsCtrl() And key.Char() = "c" Then
  ' Ctrl+C pressed
  ' Cancel operation
End If
```

### ดึงชื่อ Key สำหรับ Display

```xojo
Var keyName As String = key.KeyName()
XjTerminal.Write("You pressed: " + keyName)
```

### ฟังก์ชัน Function Key

```xojo
If key.IsFunction() Then
  Var num As Integer = key.KeyCode() - KEY_F1 + 1
  XjTerminal.Write("Pressed F" + num.ToString())
End If
```

### ตรวจสอบ Shift+Tab

```xojo
If key.KeyCode() = XjKeyEvent.KEY_BACKTAB Then
  ' Focus previous widget
End If
```

## หมายเหตุการออกแบบ

XjKeyEvent ถูก parse โดย XjReader ซึ่ง translate escape sequence เช่น "ESC[A" (arrow up) เป็น XjKeyEvent ที่มี KEY_UP

สำหรับส่วนใหญ่ของ app ไม่ต้อง construct XjKeyEvent ด้วยตัวเอง — ใช้ XjEventLoop callback ซึ่งส่ง XjKeyEvent ที่ parsed แล้ว
