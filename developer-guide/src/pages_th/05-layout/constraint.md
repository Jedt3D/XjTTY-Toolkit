---
title: Constraint
description: XjConstraint class สำหรับการกำหนดขนาด widget (fixed, percent, auto)
---

# Constraint (XjConstraint)

**XjConstraint** แทนการจำกัดขนาด widget — fixed pixels, percentage ของพื้นที่ว่าง, หรือ auto (ใช้ default content size) สิ่งสำคัญคือเมื่อเขียน layout flexbox-like ต้องบอก widget ขนาดเท่าไร — ควรขยายเต็มที่ คงที่ที่ 20 pixels, หรือใช้ 50% ของ parent width

## Mode Constants

```xojo
Const MODE_AUTO = 0       ' ไม่กำหนด — ให้ child ตัดสินใจ
Const MODE_FIXED = 1      ' ค่าคงที่ pixels
Const MODE_PERCENT = 2    ' ร้อยละของพื้นที่ว่าง
```

## Factory Methods

```xojo
Shared Function Auto() As XjConstraint
```
สร้าง constraint auto — ให้ widget ใช้ content size ของมัน

```xojo
Shared Function Fixed(value As Integer) As XjConstraint
```
สร้าง constraint fixed ที่ value pixels

```xojo
Shared Function Percent(value As Integer) As XjConstraint
```
สร้าง constraint percent ที่ value % (0-100)

```xojo
Shared Function MinMax(min As Integer, max As Integer) As XjConstraint
```
สร้าง constraint ที่มี min/max limits

## Accessors

```xojo
Function Mode() As Integer
```
ดึง MODE_AUTO, MODE_FIXED, หรือ MODE_PERCENT

```xojo
Function Value() As Integer
```
ดึงค่า (pixels สำหรับ FIXED, percentage สำหรับ PERCENT)

```xojo
Function MinValue() As Integer
Function MaxValue() As Integer
```
ดึง min/max clamps (ถ้ามี)

## Resolving

```xojo
Function Resolve(availableSpace As Integer) As Integer
```
คำนวณขนาดสุดท้ายตามพื้นที่ว่างที่ available
- MODE_AUTO: ส่งคืน availableSpace ทั้งหมด
- MODE_FIXED: ส่งคืน value (clamped ระหว่าง min/max)
- MODE_PERCENT: ส่งคืน (availableSpace * value / 100) clamped ระหว่าง min/max

```xojo
Sub SetMin(minValue As Integer)
Sub SetMax(maxValue As Integer)
```
ตั้งค่า min/max limits

## Type Checks

```xojo
Function IsAuto() As Boolean
Function IsFixed() As Boolean
Function IsPercent() As Boolean
```
ตรวจสอบ constraint mode

## Cloning

```xojo
Function Clone() As XjConstraint
```
สร้าง copy ของ constraint นี้

## ตัวอย่างการใช้งาน

### Fixed Width

```xojo
Var width As XjConstraint = XjConstraint.Fixed(20)
Var resolved As Integer = width.Resolve(80) ' ส่งคืน 20
```

### Percent of Available Space

```xojo
Var width As XjConstraint = XjConstraint.Percent(50)
Var resolved As Integer = width.Resolve(80) ' ส่งคืน 40 (50% of 80)
```

### Auto (ใช้ Content Size)

```xojo
Var width As XjConstraint = XjConstraint.Auto()
Var resolved As Integer = width.Resolve(80) ' ส่งคืน 80 (ทั้งหมด)
```

### Fixed พร้อม Min/Max Limits

```xojo
Var constraint As XjConstraint = XjConstraint.Fixed(100)
constraint.SetMin(50)
constraint.SetMax(150)
Var resolved As Integer = constraint.Resolve(80) ' ส่งคืน 80 (clamped ระหว่าง 50-150)
```

### Percent พร้อม Max Limit

```xojo
Var width As XjConstraint = XjConstraint.Percent(75)
width.SetMax(60)
Var resolved As Integer = width.Resolve(100) ' ส่งคืน 60 (75% = 75, แต่ max = 60)
```

## หมายเหตุการออกแบบ

XjConstraint immutable ตามค่าเริ่มต้น — factory methods สร้าง instance ใหม่ SetMin/SetMax แก้ไข immutable constraints

XjLayoutNode ใช้ XjConstraint ในการจัดเก็บ width/height constraints สำหรับแต่ละ widget XjLayoutSolver ส่วนนั้นใช้ Resolve() เพื่อคำนวณขนาดสุดท้ายของ widget
