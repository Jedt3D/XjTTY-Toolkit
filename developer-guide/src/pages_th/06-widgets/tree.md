---
title: Tree
description: XjTree widget สำหรับแสดง hierarchical data และ XjTreeNode data structure
---

# Tree (XjTree & XjTreeNode)

**XjTree** แสดง hierarchical (tree) structure พร้อมการ expand/collapse XjTreeNode แทนแต่ละ node ในต้นไม้

## XjTreeNode

### Constructor

```xojo
Sub New(label As String)
```
สร้าง tree node ที่มี label

### Label

```xojo
Sub SetLabel(label As String)
Function Label() As String
```
ตั้ง/ดึง text label ของ node

### Children

```xojo
Sub AddChild(child As XjTreeNode)
Function Child(index As Integer) As XjTreeNode
Function ChildCount() As Integer
```
เพิ่ม/ดึง child nodes

### Expand/Collapse

```xojo
Sub SetExpanded(expanded As Boolean)
Function IsExpanded() As Boolean
```
ตั้ง/ดึง expanded state

```xojo
Function IsLeaf() As Boolean
```
ตรวจสอบว่าเป็น leaf node (ไม่มี children)

### Styling

```xojo
Sub SetNodeStyle(style As XjStyle)
Function NodeStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ node นี้

## XjTree

### Constructor

```xojo
Sub New()
```
สร้าง tree widget ว่างเปล่า

### Root & Data

```xojo
Sub AddRoot(root As XjTreeNode)
Sub SetData(roots() As XjTreeNode)
```
ตั้งค่า root node(s) — tree สามารถมี multiple root ได้

### Styling

```xojo
Sub SetNodeStyle(style As XjStyle)
Function NodeStyle() As XjStyle
```
ตั้ง/ดึง default style สำหรับ nodes

```xojo
Sub SetBranchStyle(style As XjStyle)
Function BranchStyle() As XjStyle
```
ตั้ง/ดึง style สำหรับ branch lines (│ ├ └)

### Display

```xojo
Sub SetScrollOffset(offset As Integer)
Function ScrollOffset() As Integer
```
ตั้ง/ดึง vertical scroll offset

```xojo
Function LineCount() As Integer
```
ดึงจำนวน lines ที่ render

### Rebuild

```xojo
Sub Rebuild()
```
ปรับปรุง internal line cache (เรียก หลัง SetExpanded)

## ตัวอย่างการใช้งาน

### Simple Tree

```xojo
Var root As New XjTreeNode("Projects")

Var web As New XjTreeNode("Web")
web.AddChild(New XjTreeNode("HTML"))
web.AddChild(New XjTreeNode("CSS"))
web.AddChild(New XjTreeNode("JavaScript"))
root.AddChild(web)

Var desktop As New XjTreeNode("Desktop")
desktop.AddChild(New XjTreeNode("Xojo"))
desktop.AddChild(New XjTreeNode("C++"))
root.AddChild(desktop)

Var tree As New XjTree
tree.AddRoot(root)
tree.SetWidth(XjConstraint.Percent(100))
```

### Styled Tree

```xojo
Var tree As New XjTree
Var nodeStyle As XjStyle = XjStyle.Default_()
Var branchStyle As XjStyle = XjStyle.Muted()

tree.SetNodeStyle(nodeStyle)
tree.SetBranchStyle(branchStyle)

Var root As New XjTreeNode("Files")
' Add children...
tree.AddRoot(root)
```

### Tree พร้อม Expand/Collapse

```xojo
Var root As New XjTreeNode("Root")
Var folder1 As New XjTreeNode("Folder 1")
folder1.AddChild(New XjTreeNode("File 1"))
folder1.AddChild(New XjTreeNode("File 2"))
root.AddChild(folder1)

Var tree As New XjTree
tree.AddRoot(root)

' Initially collapsed
root.FindByName("Folder 1").SetExpanded(False)

' Later, expand
root.FindByName("Folder 1").SetExpanded(True)
tree.Rebuild()
```

### Tree Scrolling

```xojo
Var tree As New XjTree
' ... add many nodes ...
tree.SetHeight(XjConstraint.Fixed(10))

' Scroll down
tree.SetScrollOffset(0)
tree.SetScrollOffset(5)
tree.SetScrollOffset(10)

Var maxScroll As Integer = tree.LineCount() - 10
```

## Tree Display Format

Tree ใช้ box-drawing characters สำหรับแสดง hierarchy:

```
Projects
├─ Web
│  ├─ HTML
│  ├─ CSS
│  └─ JavaScript
└─ Desktop
   ├─ Xojo
   └─ C++
```

## หมายเหตุการออกแบบ

XjTreeNode เป็น pure data structure — ไม่มี rendering logic

XjTree wrap tree node และเพิ่ม rendering และ scroll management

Rebuild() ปรับปรุง internal line cache — ต้องเรียกหลัง SetExpanded() เพื่อให้ rendering ถูกต้อง

Tree ไม่ support interactive selection โดยกำเนิด — ถ้าต้อง interactive ลองสร้าง wrapper widget ที่ track selected node
