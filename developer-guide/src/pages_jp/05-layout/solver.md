---
title: レイアウトソルバー
description: XjLayoutSolverはレイアウトツリーの座標とサイズを計算する、ステートレスな解決エンジンです。
---

# レイアウトソルバー（XjLayoutSolver）

XjLayoutSolverモジュールはステートレスなレイアウト計算エンジンで、XjLayoutNodeツリーの座標と実サイズを計算します。Flexboxアルゴリズムに基づき、制約（Fixed/Percent/Auto）を解決して各ノードの最終位置とサイズを決定します。

## ソルバー実行

```xojo
Sub Solve(root As XjLayoutNode, availableWidth As Integer, availableHeight As Integer)
```

ツリーのルートノード、利用可能な幅・高さを受け取り、全ノードの計算座標を設定します。

```xojo
Var root As XjLayoutNode = CreateLayout()
XjLayoutSolver.Solve(root, 80, 24)  // 80x24のスペースで計算
```

## 処理フロー

1. **ルートノードのサイズ決定** — ルートのコンストレイントを解決
2. **深さ優先走査** — 子ノードを再帰的に処理
3. **制約の解決** — Fixed/Percent/Autoを実ピクセルに変換
4. **位置計算** — DIR_ROWまたはDIR_COLUMNに基づいて配置

## 制約解決のロジック

ソルバーは各制約モードを以下のように処理します：

### Fixed（固定サイズ）
指定されたサイズを使用し、最小・最大値でクランプします。

```xojo
Var constraint As XjConstraint = XjConstraint.Fixed(20).SetMin(10).SetMax(30)
// 実サイズ = 20（10-30の範囲内）
```

### Percent（パーセンテージ）
親の利用可能スペースの指定割合を使用します。

```xojo
Var constraint As XjConstraint = XjConstraint.Percent(50)
// 親が幅100 → 実サイズ = 50
```

### Auto（自動）
兄弟ノードのサイズを計算した後、残り全スペースを割り当てます。

```xojo
Var constraint As XjConstraint = XjConstraint.Auto()
// 他の子が30と20を使う → 残り30を自動ノードに
```

## 使用例

### シンプルなレイアウト計算

```xojo
Sub CalculateLayout()
  // レイアウト定義
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)
  Call root.SetWidth(XjConstraint.Fixed(80))
  Call root.SetHeight(XjConstraint.Fixed(24))

  // ヘッダー：固定高さ3
  Var header As New XjLayoutNode()
  Call header.SetHeight(XjConstraint.Fixed(3))
  Call root.AddChild(header)

  // メイン：残り全て
  Var main As New XjLayoutNode()
  Call main.SetHeight(XjConstraint.Auto())
  Call root.AddChild(main)

  // ソルバー実行
  XjLayoutSolver.Solve(root, 80, 24)

  // 計算結果を確認
  XjLogger.Info("Header: y=" + header.ComputedY().ToString() +
                ", h=" + header.ComputedHeight().ToString())
  XjLogger.Info("Main: y=" + main.ComputedY().ToString() +
                ", h=" + main.ComputedHeight().ToString())
  // 出力:
  // Header: y=0, h=3
  // Main: y=3, h=21
End Sub
```

### 水平レイアウト

```xojo
Sub HorizontalLayout()
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_ROW)
  Call root.SetWidth(XjConstraint.Fixed(100))
  Call root.SetHeight(XjConstraint.Fixed(24))

  // サイドバー：幅25
  Var sidebar As New XjLayoutNode()
  Call sidebar.SetWidth(XjConstraint.Fixed(25))
  Call root.AddChild(sidebar)

  // メイン：残り全て
  Var main As New XjLayoutNode()
  Call main.SetWidth(XjConstraint.Auto())
  Call root.AddChild(main)

  XjLayoutSolver.Solve(root, 100, 24)

  // sidebar: x=0, w=25
  // main: x=25, w=75
End Sub
```

### ネストレイアウト

```xojo
Sub NestedLayout()
  // ルート
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)

  // 上部行：サイドバー＋メイン
  Var topRow As New XjLayoutNode()
  Call topRow.SetDirection(XjLayoutNode.DIR_ROW)
  Call topRow.SetHeight(XjConstraint.Percent(80))

  Var sidebar As New XjLayoutNode()
  Call sidebar.SetWidth(XjConstraint.Fixed(20))
  Call topRow.AddChild(sidebar)

  Var mainArea As New XjLayoutNode()
  Call mainArea.SetWidth(XjConstraint.Auto())
  Call topRow.AddChild(mainArea)

  Call root.AddChild(topRow)

  // フッター
  Var footer As New XjLayoutNode()
  Call footer.SetHeight(XjConstraint.Percent(20))
  Call root.AddChild(footer)

  XjLayoutSolver.Solve(root, 80, 24)

  // 全ノードの座標が計算される
  Var sb_w As Integer = sidebar.ComputedWidth()   // 20
  Var ma_w As Integer = mainArea.ComputedWidth()  // 60
  Var ft_h As Integer = footer.ComputedHeight()   // 4.8 → 5
End Sub
```

### パディングの考慮

```xojo
Sub LayoutWithPadding()
  Var box As New XjLayoutNode()
  Call box.SetWidth(XjConstraint.Fixed(50))
  Call box.SetHeight(XjConstraint.Fixed(20))
  Call box.SetPadding(2, 3, 2, 3)  // 上下2、左右3

  Var child As New XjLayoutNode()
  Call child.SetWidth(XjConstraint.Auto())
  Call box.AddChild(child)

  XjLayoutSolver.Solve(box, 50, 20)

  // box内のコンテンツ領域：
  // 幅 = 50 - 6（左右パディング）= 44
  // 高さ = 20 - 4（上下パディング）= 16
  Var contentWidth As Integer = box.ContentWidth()    // 44
  Var contentHeight As Integer = box.ContentHeight()  // 16
End Sub
```

### 複雑な3カラムレイアウト

```xojo
Sub ComplexLayout()
  Var root As New XjLayoutNode()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)

  // ヘッダー
  Var header As New XjLayoutNode()
  Call header.SetHeight(XjConstraint.Fixed(3))
  Call root.AddChild(header)

  // メインコンテンツ行（3カラム）
  Var mainRow As New XjLayoutNode()
  Call mainRow.SetDirection(XjLayoutNode.DIR_ROW)
  Call mainRow.SetHeight(XjConstraint.Auto())

  // 左サイドバー：20%
  Var left As New XjLayoutNode()
  Call left.SetWidth(XjConstraint.Percent(20))
  Call mainRow.AddChild(left)

  // センター：60%
  Var center As New XjLayoutNode()
  Call center.SetWidth(XjConstraint.Percent(60))
  Call mainRow.AddChild(center)

  // 右パネル：20%
  Var right As New XjLayoutNode()
  Call right.SetWidth(XjConstraint.Percent(20))
  Call mainRow.AddChild(right)

  Call root.AddChild(mainRow)

  // フッター
  Var footer As New XjLayoutNode()
  Call footer.SetHeight(XjConstraint.Fixed(2))
  Call root.AddChild(footer)

  XjLayoutSolver.Solve(root, 100, 30)

  // 計算結果：
  // header: y=0, h=3
  // left: x=0, w=20
  // center: x=20, w=60
  // right: x=80, w=20
  // footer: y=28, h=2
End Sub
```

## パフォーマンス

XjLayoutSolverはO(n)の時間複雑度でツリーを走査します（nはノード数）。大規模レイアウトでも高速に計算できます。

```xojo
// 1000個のノードを含むツリーでも高速
Var largeRoot As XjLayoutNode = BuildLargeTree(1000)
XjLayoutSolver.Solve(largeRoot, 80, 24)  // 高速に完了
```
