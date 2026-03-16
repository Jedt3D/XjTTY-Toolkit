---
title: レイアウトノード
description: XjLayoutNodeクラスはFlexboxライクなレイアウトツリーを構成し、枠線、タイトル、パディング、マージンをサポートします。
---

# レイアウトノード（XjLayoutNode）

XjLayoutNodeクラスはFlexboxに似たフレキシブルレイアウトツリーを構築するためのノードです。方向（行・列）、サイズ制約、パディング、マージン、枠線、タイトル等を指定できます。

## 方向定数

```xojo
Const DIR_ROW = 0      // 水平方向（左から右）
Const DIR_COLUMN = 1   // 垂直方向（上から下）
```

## レイアウト設定

```xojo
Sub SetDirection(direction As Integer)
Sub SetWidth(constraint As XjConstraint)
Sub SetHeight(constraint As XjConstraint)
Sub SetPadding(top As Integer, right As Integer, bottom As Integer, left As Integer)
Sub SetMargin(top As Integer, right As Integer, bottom As Integer, left As Integer)
```

### 設定例

```xojo
Var node As New XjLayoutNode()
Call node.SetDirection(XjLayoutNode.DIR_COLUMN)
Call node.SetWidth(XjConstraint.Auto())
Call node.SetHeight(XjConstraint.Fixed(10))
Call node.SetPadding(1, 2, 1, 2)      // 上1、右2、下1、左2
Call node.SetMargin(1, 1, 1, 1)       // 上1、右1、下1、左1
```

## スタイル設定

```xojo
Sub SetBorder(style As Integer, color As Integer)
Sub SetName(name As String)
Sub SetTitle(title As String)
```

- `SetBorder()` — ボーダースタイル（0-4）と色
- `SetName()` — ノードの識別名
- `SetTitle()` — ボーダー内に表示するタイトル

```xojo
Var node As New XjLayoutNode()
Call node.SetBorder(0, XjANSI.FG_BLUE)
Call node.SetTitle("My Box")
```

## 子ノード管理

```xojo
Sub AddChild(child As XjLayoutNode)
```

親ノードに子ノードを追加します。

```xojo
Var parent As New XjLayoutNode()
Var child As New XjLayoutNode()
Call parent.AddChild(child)
```

## レイアウト情報の取得

```xojo
Function ComputedX() As Integer       // 計算された X座標
Function ComputedY() As Integer       // 計算された Y座標
Function ComputedWidth() As Integer
Function ComputedHeight() As Integer
Function ContentX() As Integer        // コンテンツ開始X（パディング後）
Function ContentY() As Integer        // コンテンツ開始Y（パディング後）
Function ContentWidth() As Integer
Function ContentHeight() As Integer
```

これらは`XjLayoutSolver.Solve()`実行後に値が設定されます。

```xojo
Var root As New XjLayoutNode()
Call root.SetWidth(XjConstraint.Fixed(80))
Call root.SetHeight(XjConstraint.Fixed(24))

// ソルバーで解決
XjLayoutSolver.Solve(root, 80, 24)

// レイアウト情報を取得
Var x As Integer = root.ComputedX()
Var y As Integer = root.ComputedY()
Var w As Integer = root.ComputedWidth()
Var h As Integer = root.ComputedHeight()
```

## 描画

```xojo
Sub PaintSelf(canvas As XjCanvas)
Sub PaintTo(canvas As XjCanvas)
```

- `PaintSelf()` — ノード自身のボーダー・タイトルのみを描画
- `PaintTo()` — ボーダー・タイトル・子要素全てを描画

```xojo
Var canvas As New XjCanvas(80, 24)
Var root As New XjLayoutNode()
// ... レイアウト設定

XjLayoutSolver.Solve(root, 80, 24)
Call root.PaintTo(canvas)  // ツリー全体を描画
```

## ノード検索

```xojo
Function FindByName(name As String) As XjLayoutNode
```

ツリーから指定名のノードを検索して返します。見つからない場合はNilを返します。

```xojo
Var root As New XjLayoutNode()
Var mainPanel As New XjLayoutNode()
Call mainPanel.SetName("main")
Call root.AddChild(mainPanel)

Var found As XjLayoutNode = root.FindByName("main")
If found <> Nil Then
  // ノード見つかった
End If
```

## 実装例

### シンプルなレイアウト

```xojo
Sub CreateLayout() As XjLayoutNode
  // ルート：列方向レイアウト
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
  Call root.SetWidth(XjConstraint.Auto())
  Call root.SetHeight(XjConstraint.Auto())

  // ヘッダー
  Var header As New XjLayoutNode()
  Call header.SetHeight(XjConstraint.Fixed(3))
  Call header.SetBorder(0, XjANSI.FG_CYAN)
  Call header.SetTitle("Header")
  Call root.AddChild(header)

  // メインコンテンツ
  Var main As New XjLayoutNode()
  Call main.SetHeight(XjConstraint.Auto())
  Call main.SetPadding(1, 1, 1, 1)
  Call main.SetName("main")
  Call root.AddChild(main)

  Return root
End Sub
```

### 複雑なネストレイアウト

```xojo
Sub CreateComplexLayout() As XjLayoutNode
  // ルート：列方向
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)

  // 上部：行方向（サイドバー + メイン）
  Var topRow As New XjLayoutNode()
  Call topRow.SetDirection(XjLayoutNode.DIR_ROW)
  Call topRow.SetHeight(XjConstraint.Percent(80))

  // サイドバー
  Var sidebar As New XjLayoutNode()
  Call sidebar.SetWidth(XjConstraint.Fixed(20))
  Call sidebar.SetBorder(1, XjANSI.FG_GREEN)
  Call topRow.AddChild(sidebar)

  // メインコンテンツ
  Var main As New XjLayoutNode()
  Call main.SetWidth(XjConstraint.Auto())
  Call main.SetBorder(1, XjANSI.FG_YELLOW)
  Call topRow.AddChild(main)

  Call root.AddChild(topRow)

  // フッター
  Var footer As New XjLayoutNode()
  Call footer.SetHeight(XjConstraint.Fixed(3))
  Call footer.SetBorder(1, XjANSI.FG_MAGENTA)
  Call root.AddChild(footer)

  Return root
End Sub
```

### パディングとマージン

```xojo
Sub DemonstratePaddingMargin()
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
  Call root.SetPadding(1, 2, 1, 2)     // ルートのパディング

  Var child As New XjLayoutNode()
  Call child.SetMargin(1, 1, 1, 1)     // 子のマージン
  Call child.SetBorder(0, XjANSI.FG_RED)
  Call root.AddChild(child)

  // マージンはルートの枠線から距離を取る
  // パディングは子の枠線から内部コンテンツまでの距離
End Sub
```

## XjLayoutSolverとの関係

ノードをセットアップした後、`XjLayoutSolver.Solve()`でツリー全体の計算座標を決定します。

```xojo
Var root As XjLayoutNode = CreateLayout()
XjLayoutSolver.Solve(root, 80, 24)  // 80x24のスペースで解決

// この後、ComputedX/Y等が利用可能
```
