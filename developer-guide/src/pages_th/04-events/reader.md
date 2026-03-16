---
title: ตัวอ่าน Input
description: XjReader class ที่ parse VT100/xterm escape sequence จาก stdin เป็น XjKeyEvent
---

# ตัวอ่าน Input (XjReader)

**XjReader** เป็น class ที่ parse escape sequence จากการกดแป้นพิมพ์ (keyboard input) ออกเป็น XjKeyEvent ตัวอย่างเช่น เมื่อผู้ใช้กด arrow up ดั้งเดิมส่ง "ESC[A" (3 bytes) ลง stdin XjReader ต้อง recognize ลำดับนั้นและแปลงเป็น XjKeyEvent ที่มี KEY_UP ดังนั้นการทำงานจึงสำคัญ

## Constructor

```xojo
Sub New()
```
สร้าง reader ใหม่

## Reading Input

```xojo
Function ReadKey() As XjKeyEvent
```
อ่าน bytes จาก stdin แล้ว parse ตัดสินใจส่งกลับ XjKeyEvent — จะรอ (blocking) จนกว่าจะได้ key ที่สมบูรณ์ (ตัวอักษรเดียว หรือ escape sequence ที่สมบูรณ์)

```xojo
Function ReadLine(prompt As String) As String
```
แสดง prompt แล้วอ่านบรรทัดข้อความจากผู้ใช้ สนับสนุน cursor editing (arrows, backspace, delete)

## Escape Sequence Parsing

XjReader รู้จัก:
- **Single characters** — "a", "1", " " → XjKeyEvent(KEY_CHAR, "a", ...)
- **Control sequences** — Ctrl+A, Ctrl+C → XjKeyEvent(KEY_CHAR, "A", isCtrl=True, ...)
- **CSI sequences** — "ESC[A" (arrow up), "ESC[1;2H" (Shift+Home) → XjKeyEvent(KEY_UP, ...) หรือ KEY_HOME + shift flag
- **SS3 sequences** — "ESSC" sequences สำหรับ function keys
- **UTF-8 multi-byte** — "é", "中" → XjKeyEvent(KEY_CHAR, "é", ...)
- **Alt+char** — ESC ตามด้วย character → XjKeyEvent(KEY_CHAR, "a", isAlt=True, ...)

## ตัวอย่างการใช้งาน

### อ่าน Single Key

```xojo
Var reader As New XjReader
Var key As XjKeyEvent = reader.ReadKey()
Select Case key.KeyCode()
Case XjKeyEvent.KEY_ENTER
  XjTerminal.Write("Enter pressed")
Case XjKeyEvent.KEY_ESCAPE
  XjTerminal.Write("Escape pressed")
Case Else
  XjTerminal.Write("Key: " + key.KeyName())
End Select
```

### อ่าน Line

```xojo
Var reader As New XjReader
Var input As String = reader.ReadLine("Enter your name: ")
XjTerminal.Write("You entered: " + input)
```

### Loop อ่าน Keys

```xojo
Var reader As New XjReader
While True
  Var key As XjKeyEvent = reader.ReadKey()
  If key.IsEscape() Then
    Exit
  End If
  XjTerminal.Write("Pressed: " + key.KeyName())
Wend
```

## หมายเหตุการออกแบบ

XjReader ทำงานใน raw mode (XjTerminal.EnableRawMode()) เพื่ออ่านแต่ละ byte — ถ้า raw mode ไม่เปิด ReadKey() อาจไม่ทำงานที่คาดหวัง

ReadKey() เป็น blocking — จะรอ input ตราบ — ถ้าต้อง non-blocking ลอง XjTerminal.EnableNonBlockingInput() ตามด้วยลูป polling

สำหรับส่วนใหญ่ของ app ไม่ต้อง use XjReader โดยตรง — ใช้ XjEventLoop ที่ wrap มันแล้ว และส่ง parsed XjKeyEvent ไปยัง handler

XjEventLoop เรียก ReadKey() ภายในและส่ง XjEvent ไปยัง KeyPressHandler callback
