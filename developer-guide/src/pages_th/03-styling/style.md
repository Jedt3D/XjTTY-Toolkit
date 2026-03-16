---
title: XjStyle
description: XjStyle class สำหรับสร้างสไตล์อักขระอย่างไม่มีการเปลี่ยนแปลง (immutable) โดยใช้รูปแบบ fluent builder
---

# XjStyle

**XjStyle** เป็น class ที่ให้ immutable style builder สำหรับการจัดรูปแบบข้อความ (FG color, BG color, bold, italic, underline, เป็นต้น) เหตุผลที่ style ต้องเป็น immutable คือเราอาจใช้สไตล์เดียวกัน หลายครั้งในแอป หากเป็น mutable การเปลี่ยนแปลงหนึ่งจะส่งผลกระทบไปยังทั้งหมด

## Constructor

```xojo
Sub New()
```
สร้าง style ว่างเปล่า (ไม่มีการจัดรูปแบบใดๆ) หรือ:

```xojo
Sub New(other As XjStyle)
```
สร้าง clone ของ style อื่น

## Fluent Setters (แต่ละอันส่งกลับ XjStyle ใหม่)

### Foreground Colors

```xojo
Function SetFG(colorCode As Integer) As XjStyle
```
ตั้งค่า foreground color โดยใช้สี 16 สี (30-37 หรือ 90-97)

```xojo
Function SetFGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
```
ตั้งค่า foreground color โดยใช้ RGB (0-255)

### Background Colors

```xojo
Function SetBG(colorCode As Integer) As XjStyle
```
ตั้งค่า background color

```xojo
Function SetBGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
```
ตั้งค่า background color โดยใช้ RGB

### Text Styling

```xojo
Function SetBold() As XjStyle
Function SetDim() As XjStyle
Function SetItalic() As XjStyle
Function SetUnderline() As XjStyle
Function SetInverse() As XjStyle
Function SetStrikethrough() As XjStyle
Function SetBlink() As XjStyle
```
ตั้งค่าแอตทริบิวต์ text (ไม่ส่งพารามิเตอร์ — เพียงแค่เรียก `SetBold()` เท่านั้น)

## Output

```xojo
Function ToANSI() As String
```
สร้าง ANSI escape sequence สำหรับสไตล์นี้ (เช่น "ESC[1;31m" สำหรับ bold red)

```xojo
Function Apply(text As String) As String
```
ใช้สไตล์กับ text และรีเซ็ต (คืน styled text + reset code)

## Comparison & Cloning

```xojo
Function Equals(other As XjStyle) As Boolean
```
เปรียบเทียบสไตล์ว่าเหมือนกันหรือไม่

```xojo
Function Clone() As XjStyle
```
สร้าง copy ของสไตล์นี้

```xojo
Function IsEmpty() As Boolean
```
ส่งกลับ `True` ถ้าไม่มีการจัดรูปแบบใด (ทั้งหมด default)

## Shared Factory Methods

```xojo
Shared Function Default_() As XjStyle
```
สร้าง style ว่างเปล่า (ไม่มีการจัดรูปแบบ)

```xojo
Shared Function MakeBold() As XjStyle
```
สร้าง style ที่มีเพียง bold

```xojo
Shared Function FGColor(colorCode As Integer) As XjStyle
```
สร้าง style ที่มี FG color เพียง

```xojo
Shared Function BGColor(colorCode As Integer) As XjStyle
```
สร้าง style ที่มี BG color เพียง

```xojo
Shared Function MakeFGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
```
สร้าง style ที่มี RGB FG color เพียง

## Semantic Shared Factory Methods

```xojo
Shared Function Success() As XjStyle
Shared Function Warning() As XjStyle
Shared Function Danger() As XjStyle
Shared Function Info() As XjStyle
Shared Function Muted() As XjStyle
Shared Function Highlight() As XjStyle
```
สร้าง style ที่มีรูปแบบเชิงความหมายล่วงหน้า

## ตัวอย่างการใช้งาน

### สร้างและใช้ Style

```xojo
Var style As New XjStyle
style = style.SetBold().SetFG(XjANSI.FG_RED)
Var styled As String = style.Apply("Error!")
XjTerminal.Write(styled)
```

### ใช้ Shared Factory

```xojo
Var error As XjStyle = XjStyle.Danger()
XjTerminal.Write(error.Apply("Something went wrong"))
```

### Style สำหรับ Semantic Meaning

```xojo
Var successStyle As XjStyle = XjStyle.Success()
Var warningStyle As XjStyle = XjStyle.Warning()
Var infoStyle As XjStyle = XjStyle.Info()

XjTerminal.Write(successStyle.Apply("✓ Complete"))
XjTerminal.Write(warningStyle.Apply("⚠ Caution"))
XjTerminal.Write(infoStyle.Apply("ℹ Note"))
```

### ผสมหลาย Attributes

```xojo
Var style As New XjStyle
style = style.SetBold().SetUnderline().SetFGRGB(100, 200, 255)
XjTerminal.Write(style.Apply("Important"))
```

### เก็บและนำกลับมาใช้

```xojo
Var headerStyle As XjStyle = XjStyle.MakeBold().SetFG(XjANSI.FG_CYAN)

' ใช้หลายครั้ง
XjTerminal.Write(headerStyle.Apply("Section 1"))
XjTerminal.Write(headerStyle.Apply("Section 2"))
```

## หมายเหตุการออกแบบ

XjStyle immutable เพื่อความปลอดภัยจาก thread safety และการเก็บ cache อย่างง่าย หากต้อง modify style ให้สร้างใหม่ (fluent methods สร้างสำเนา ไม่เปลี่ยนแปลงสไตล์ดั้งเดิม)

XjCell และ XjCanvas ใช้ XjStyle ภายในเพื่อเก็บข้อมูล formatting ของแต่ละเซลล์
