---
title: Layout Solver
description: XjLayoutSolver module สำหรับการคำนวณขนาดและตำแหน่งของ layout tree
---

# Layout Solver (XjLayoutSolver)

**XjLayoutSolver** เป็น stateless module ที่ algorithm ของการแก้ไข layout — ยินดีรับ XjLayoutNode tree และ available space จากนั้นคำนวณ computed size/position ของแต่ละ node สิ่งสำคัญคือ algorithm นี้ flexbox-like — บอก node ให้ขยายตามโหมด constraint ของตัวเอง

## Main Solve Function

```xojo
Sub Solve(root As XjLayoutNode, availWidth As Integer, availHeight As Integer)
```
คำนวณขนาด/ตำแหน่ง layout ของ root และ children recursively

พารามิเตอร์:
- `root`: node ที่ต้องการ solve
- `availWidth`: ความกว้างพื้นที่ available (ปกติเป็นขนาด terminal)
- `availHeight`: ความสูงพื้นที่ available

## Algorithm

Solve() ทำงานดังนี้:

1. **Set root size** — resolve root's width/height constraint ตามเอา availWidth/availHeight
2. **Calculate inner area** — ลบ padding/border/margin เพื่อหา content area
3. **Resolve fixed/percent children** — คำนวณขนาด children ที่มี FIXED หรือ PERCENT constraint
4. **Distribute remaining space** — ให้ AUTO children ใช้ remaining space
5. **Position along main axis** — จัดตำแหน่ง children ตามแนว row/column
6. **Recurse** — เรียก Solve() บน child nodes

## ตัวอย่างการใช้งาน

### Solve Simple Tree

```xojo
Var root As New XjLayoutNode
root.SetDirection(XjLayoutNode.DIR_COLUMN)
root.SetWidth(XjConstraint.Auto())
root.SetHeight(XjConstraint.Auto())

Var header As New XjLayoutNode
header.SetHeight(XjConstraint.Fixed(3))

Var body As New XjLayoutNode
body.SetHeight(XjConstraint.Percent(100))

root.AddChild(header)
root.AddChild(body)

' Solve with terminal size
Var w As Integer = 80
Var h As Integer = 24
XjLayoutSolver.Solve(root, w, h)

' Now read computed layout
XjTerminal.Write("Header: " + header.ComputedHeight().ToString() + " lines")
XjTerminal.Write("Body: " + body.ComputedHeight().ToString() + " lines")
```

### Multi-Column Layout

```xojo
Var root As New XjLayoutNode
root.SetDirection(XjLayoutNode.DIR_ROW)

Var left As New XjLayoutNode
left.SetWidth(XjConstraint.Percent(25))

Var center As New XjLayoutNode
center.SetWidth(XjConstraint.Percent(50))

Var right As New XjLayoutNode
right.SetWidth(XjConstraint.Percent(25))

root.AddChild(left)
root.AddChild(center)
root.AddChild(right)

XjLayoutSolver.Solve(root, 80, 24)

' left = 20, center = 40, right = 20
```

### Mixed Constraints

```xojo
Var root As New XjLayoutNode
root.SetDirection(XjLayoutNode.DIR_COLUMN)

Var header As New XjLayoutNode
header.SetHeight(XjConstraint.Fixed(2))

Var content As New XjLayoutNode
content.SetHeight(XjConstraint.Percent(80))

Var footer As New XjLayoutNode
footer.SetHeight(XjConstraint.Fixed(1))

root.AddChild(header)
root.AddChild(content)
root.AddChild(footer)

XjLayoutSolver.Solve(root, 80, 24)

' header = 2, content = 18 (80% of remaining), footer = 1, + gaps
```

## หมายเหตุการออกแบบ

XjLayoutSolver stateless — ไม่มี state อยู่ สามารถเรียก Solve() หลายครั้งบน tree เดียว ทำให้เรียกซ้ำได้เมื่อ resize

Algorithm ไม่รองรับ gap/gutter ระหว่าง children อย่างชัดเจน — ใช้ margin บน node เพื่อสร้างช่องว่าง

สำหรับ widget-based layout ดูที่ XjWidget ซึ่ง wrap XjLayoutNode และเพิ่ม rendering/event handling

XjEventLoop ถูก resize loop ทำซ้ำโดยอัตโนมัติ เมื่อ terminal resize อัพเดต layout
