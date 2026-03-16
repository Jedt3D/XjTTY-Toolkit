---
title: สี
description: XjColor module ให้เพียงแค่ฟังก์ชันสี, RGB gradients, และสีเชิงความหมาย
---

# สี (XjColor)

**XjColor** เป็น module ที่จัดให้มี convenience functions สำหรับเติมสี text และ background โดยอัตโนมัติ เหตุผลที่เราต้องใช้ XjColor แทน XjANSI โดยตรงคือฟังก์ชันสี XjColor ส่งกลับ text ที่มีสีแล้วพร้อมการรีเซ็ต ซึ่งง่ายกว่าต้องจำหมายเลขสี

## สี Named (Foreground & Background)

### Basic 8 Colors

```xojo
Function Black(text As String) As String
Function Red(text As String) As String
Function Green(text As String) As String
Function Yellow(text As String) As String
Function Blue(text As String) As String
Function Magenta(text As String) As String
Function Cyan(text As String) As String
Function White(text As String) As String
```

### Bright Variants

```xojo
Function BrightBlack(text As String) As String
Function BrightRed(text As String) As String
Function BrightGreen(text As String) As String
Function BrightYellow(text As String) As String
Function BrightBlue(text As String) As String
Function BrightMagenta(text As String) As String
Function BrightCyan(text As String) As String
Function BrightWhite(text As String) As String
```

### Background Colors

```xojo
Function OnBlack(text As String) As String
Function OnRed(text As String) As String
Function OnGreen(text As String) As String
Function OnYellow(text As String) As String
Function OnBlue(text As String) As String
Function OnMagenta(text As String) As String
Function OnCyan(text As String) As String
Function OnWhite(text As String) As String
```

## การจัดรูปแบบและสไตล์

### Text Styling Functions

```xojo
Function BoldText(text As String) As String
```
ทำให้ text เป็น bold

```xojo
Function ItalicText(text As String) As String
```
ทำให้ text เป็น italic

```xojo
Function UnderlineText(text As String) As String
```
เพิ่ม underline ให้กับ text

```xojo
Function DimText(text As String) As String
```
ทำให้ text มืด (darker)

```xojo
Function InverseText(text As String) As String
```
กลับสี foreground และ background

```xojo
Function StrikethroughText(text As String) As String
```
เพิ่ม strikethrough ให้กับ text

## สี Advanced

### RGB Color

```xojo
Function RGB(text As String, r As Integer, g As Integer, b As Integer) As String
```
ทำให้ text มีสีอ้างอิง RGB (0-255 แต่ละช่อง)

### RGB Foreground & Background

```xojo
Function RGBBG(text As String, fgR As Integer, fgG As Integer, fgB As Integer, bgR As Integer, bgG As Integer, bgB As Integer) As String
```
ใช้สี RGB สำหรับทั้ง foreground และ background

### 256-Color Palette

```xojo
Function Color256(text As String, index As Integer) As String
```
ใช้ 256-color palette (index 0-255)

### Gradient Color

```xojo
Function Gradient(text As String, fromR As Integer, fromG As Integer, fromB As Integer, toR As Integer, toG As Integer, toB As Integer) As String
```
สร้าง gradient สี จากสี "from" ไปยังสี "to" บน text แต่ละอักขระ

## สีเชิงความหมาย (Semantic Colors)

```xojo
Function Success(text As String) As String
```
ใช้สีสำหรับข้อความสำเร็จ (โดยทั่วไป สีเขียว)

```xojo
Function Warning(text As String) As String
```
ใช้สีสำหรับข้อความคำเตือน (โดยทั่วไป สีเหลือง)

```xojo
Function Error_(text As String) As String
```
ใช้สีสำหรับข้อความข้อผิดพลาด (โดยทั่วไป สีแดง)

```xojo
Function Info(text As String) As String
```
ใช้สีสำหรับข้อความข้อมูล (โดยทั่วไป สีฟ้า)

```xojo
Function Muted(text As String) As String
```
ใช้สีสำหรับข้อความที่ลดความเด่น (โดยทั่วไป เทา)

## ตัวอย่างการใช้งาน

### ใช้สี Named

```xojo
Var output As String = ""
output = output + XjColor.Red("Error: ") + "Something went wrong"
XjTerminal.Write(output)
```

### ผสม Foreground, Background และ Style

```xojo
Var text As String = XjColor.OnYellow(XjColor.BoldText("Warning"))
XjTerminal.Write(text)
```

### RGB Color สำหรับสีที่เจาะจง

```xojo
Var highlight As String = XjColor.RGB("Important", 255, 165, 0) ' Orange
XjTerminal.Write(highlight)
```

### Gradient Text

```xojo
Var rainbow As String = XjColor.Gradient("Rainbow", 255, 0, 0, 0, 0, 255) ' Red to Blue
XjTerminal.Write(rainbow)
```

### ใช้สีเชิงความหมายสำหรับ Status Message

```xojo
Var status As String = XjColor.Success("✓ Setup complete")
XjTerminal.Write(status)

status = XjColor.Error_("✗ Build failed")
XjTerminal.Write(status)
```

## หมายเหตุการออกแบบ

XjColor ใช้ประโยชน์จาก XjANSI ภายใน และ reset code โดยอัตโนมัติ ทำให้ไม่ต้องจำไว้ว่าต้องเรียก Reset() เอง

สำหรับการควบคุมสี ที่มีความละเอียดมากขึ้น (เช่น style builder ที่ reusable หลายครั้ง) ลอง XjStyle module แทน XjColor
