---
title: ツリーウィジェット
description: XjTreeとXjTreeNodeで階層構造を表示します。展開・折りたたみ、ボックス描画、スクロール対応。
---

# ツリーウィジェット（XjTree、XjTreeNode）

XjTreeは階層構造（ディレクトリツリーやメニューなど）を表示するウィジェットです。XjTreeNodeは各ノードを表現し、展開・折りたたみをサポートしています。

## XjTreeNode（ツリーノード）

階層構造の個別要素を表します。

### コンストラクタ

```xojo
Sub New(label As String)
```

### ノード管理

```xojo
Sub AddChild(child As XjTreeNode)
Function ChildCount() As Integer
Function Child(index As Integer) As XjTreeNode
Function IsLeaf() As Boolean
```

```xojo
Var root As New XjTreeNode("Files")
Var folder As New XjTreeNode("Documents")
Var file As New XjTreeNode("report.txt")

Call folder.AddChild(file)
Call root.AddChild(folder)

Var hasChildren As Boolean = Not root.IsLeaf()
```

### ノード情報

```xojo
Function Label() As String
Sub SetLabel(label As String)
```

```xojo
Var node As New XjTreeNode("Original")
Call node.SetLabel("Updated")
Var label As String = node.Label()
```

### 展開状態

```xojo
Function IsExpanded() As Boolean
Sub SetExpanded(expanded As Boolean)
```

```xojo
Var node As New XjTreeNode("Folder")
Call node.SetExpanded(True)   // 展開
Call node.SetExpanded(False)  // 折りたたみ
```

### スタイリング

```xojo
Function SetNodeStyle(style As XjStyle) As XjTreeNode
```

ノードラベルのスタイルを設定。

```xojo
Var node As New XjTreeNode("Important")
Call node.SetNodeStyle(XjStyle.Warning())
```

## XjTree（ツリーウィジェット）

ツリー全体を管理・表示するウィジェット。

### コンストラクタ

```xojo
Sub New()
```

### ルート管理

```xojo
Sub AddRoot(root As XjTreeNode)
Function GetData() As XjTreeNode
```

```xojo
Var tree As New XjTree()
Var root As New XjTreeNode("Root")
Call tree.AddRoot(root)
Var data As XjTreeNode = tree.GetData()
```

### スタイリング

```xojo
Function SetNodeStyle(style As XjStyle) As XjTree
Function SetBranchStyle(style As XjStyle) As XjTree
```

ノードと枝線のスタイルを設定。

```xojo
Var tree As New XjTree()
Call tree.SetNodeStyle(XjStyle.Default())
Call tree.SetBranchStyle(XjStyle.Muted())
```

### スクロール

```xojo
Function SetScrollOffset(offset As Integer) As XjTree
Function LineCount() As Integer
```

表示行数が多い場合のスクロール制御。

```xojo
Var tree As New XjTree()
// ... ツリー構築
Var lines As Integer = tree.LineCount()
Call tree.SetScrollOffset(0)  // 最上部から表示
```

### ツリー再構築

```xojo
Sub Rebuild()
```

ツリーデータ変更後に呼び出し（レイアウト更新）。

```xojo
Var tree As New XjTree()
// ... ツリーデータ変更
Call tree.Rebuild()
```

## 実装例

### ディレクトリ構造表示

```xojo
Function BuildFileTree() As XjTree
  Var tree As New XjTree()

  Var root As New XjTreeNode("📁 projects")
  Call root.SetExpanded(True)

  Var project1 As New XjTreeNode("📁 app-a")
  Call project1.SetExpanded(True)
  Call project1.AddChild(New XjTreeNode("📄 main.xojo"))
  Call project1.AddChild(New XjTreeNode("📄 config.ini"))

  Var project2 As New XjTreeNode("📁 app-b")
  Call project2.AddChild(New XjTreeNode("📄 main.xojo"))

  Call root.AddChild(project1)
  Call root.AddChild(project2)

  Call tree.AddRoot(root)
  Return tree
End Function
```

### メニューツリー

```xojo
Function BuildMenuTree() As XjTree
  Var tree As New XjTree()

  Var root As New XjTreeNode("Menu")
  Call root.SetExpanded(True)

  // File メニュー
  Var fileMenu As New XjTreeNode("File")
  Call fileMenu.AddChild(New XjTreeNode("New"))
  Call fileMenu.AddChild(New XjTreeNode("Open"))
  Call fileMenu.AddChild(New XjTreeNode("Save"))
  Call fileMenu.AddChild(New XjTreeNode("Exit"))
  Call root.AddChild(fileMenu)

  // Edit メニュー
  Var editMenu As New XjTreeNode("Edit")
  Call editMenu.AddChild(New XjTreeNode("Undo"))
  Call editMenu.AddChild(New XjTreeNode("Redo"))
  Call editMenu.AddChild(New XjTreeNode("Cut"))
  Call editMenu.AddChild(New XjTreeNode("Copy"))
  Call editMenu.AddChild(New XjTreeNode("Paste"))
  Call root.AddChild(editMenu)

  // Help メニュー
  Var helpMenu As New XjTreeNode("Help")
  Call helpMenu.AddChild(New XjTreeNode("About"))
  Call helpMenu.AddChild(New XjTreeNode("Manual"))
  Call root.AddChild(helpMenu)

  Call tree.AddRoot(root)
  Return tree
End Function
```

### 組織図

```xojo
Function BuildOrgChart() As XjTree
  Var tree As New XjTree()

  Var ceo As New XjTreeNode("CEO")
  Call ceo.SetExpanded(True)

  // 部長
  Var engMgr As New XjTreeNode("Engineering Manager")
  Call engMgr.SetExpanded(True)
  Call engMgr.AddChild(New XjTreeNode("Developer 1"))
  Call engMgr.AddChild(New XjTreeNode("Developer 2"))

  Var salesMgr As New XjTreeNode("Sales Manager")
  Call salesMgr.AddChild(New XjTreeNode("Sales Rep 1"))
  Call salesMgr.AddChild(New XjTreeNode("Sales Rep 2"))

  Call ceo.AddChild(engMgr)
  Call ceo.AddChild(salesMgr)

  Call tree.AddRoot(ceo)
  Return tree
End Function
```

### セマンティックスタイリング

```xojo
Sub BuildStyledTree()
  Var tree As New XjTree()

  Var root As New XjTreeNode("Project")
  Call root.SetNodeStyle(XjStyle.Success())
  Call root.SetExpanded(True)

  // エラー
  Var errors As New XjTreeNode("Errors")
  Call errors.SetNodeStyle(XjStyle.Danger())
  Call errors.AddChild(New XjTreeNode("Line 42: syntax error"))

  // 警告
  Var warnings As New XjTreeNode("Warnings")
  Call warnings.SetNodeStyle(XjStyle.Warning())
  Call warnings.AddChild(New XjTreeNode("Unused variable"))

  // 情報
  Var info As New XjTreeNode("Info")
  Call info.SetNodeStyle(XjStyle.Info())
  Call info.AddChild(New XjTreeNode("3 files modified"))

  Call root.AddChild(errors)
  Call root.AddChild(warnings)
  Call root.AddChild(info)

  Call tree.AddRoot(root)
End Sub
```

### インタラクティブツリー

```xojo
Class InteractiveTree
  Extends XjTree
  Private mSelectedNode As XjTreeNode

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsArrowRight() Then
      If mSelectedNode <> Nil And Not mSelectedNode.IsLeaf() Then
        Call mSelectedNode.SetExpanded(True)
        Call Rebuild()
        MarkDirty()
        Return True
      End If
    ElseIf key.IsArrowLeft() Then
      If mSelectedNode <> Nil Then
        Call mSelectedNode.SetExpanded(False)
        Call Rebuild()
        MarkDirty()
        Return True
      End If
    ElseIf key.IsEnter() Then
      // ノード選択確定
      Return True
    End If
    Return False
  End Function

  Sub SetSelectedNode(node As XjTreeNode)
    mSelectedNode = node
  End Sub

  Function GetSelectedNode() As XjTreeNode
    Return mSelectedNode
  End Function
End Class
```

### 動的ツリー更新

```xojo
Class DynamicTree
  Private mTree As XjTree
  Private mRoot As XjTreeNode

  Sub New()
    mTree = New XjTree()
    mRoot = New XjTreeNode("Dynamic Tree")
    Call mRoot.SetExpanded(True)
    Call mTree.AddRoot(mRoot)
  End Sub

  Sub AddItem(parentLabel As String, itemLabel As String)
    // parentLabelに該当するノードを見つけて子を追加
    Var parent As XjTreeNode = FindNode(mRoot, parentLabel)
    If parent <> Nil Then
      Call parent.AddChild(New XjTreeNode(itemLabel))
      Call mTree.Rebuild()
    End If
  End Sub

  Private Function FindNode(node As XjTreeNode, label As String) As XjTreeNode
    If node.Label() = label Then
      Return node
    End If

    For i As Integer = 0 To node.ChildCount() - 1
      Var found As XjTreeNode = FindNode(node.Child(i), label)
      If found <> Nil Then
        Return found
      End If
    Wend

    Return Nil
  End Function

  Function GetTree() As XjTree
    Return mTree
  End Function
End Class
```

## ツリーレイアウト

ツリーは通常、以下の形式で表示されます：

```
Root
├─ Child 1
│  ├─ Grandchild 1
│  └─ Grandchild 2
├─ Child 2
│  └─ Grandchild 3
└─ Child 3
```

ボックス描画文字（─、│、├、└）は自動的に選択されます。
