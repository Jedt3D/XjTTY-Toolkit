---
title: サイズ制約
description: XjConstraintクラスはFixed、Percent、Autoモードでウィジェット幅・高さを制御します。
---

# サイズ制約（XjConstraint）

XjConstraintクラスはウィジェットのサイズ指定を統一的に処理し、固定サイズ、パーセンテージ、自動サイズモードをサポートしています。最小・最大値でのクランプ機能もあります。

## モード定数

```xojo
Const MODE_AUTO = 0        // 自動サイズ（コンテンツに合わせる）
Const MODE_FIXED = 1       // 固定サイズ
Const MODE_PERCENT = 2     // パーセンテージ（親サイズの%）
```

## ファクトリーメソッド

```xojo
Shared Function Auto() As XjConstraint
Shared Function Fixed(value As Integer) As XjConstraint
Shared Function Percent(value As Double) As XjConstraint
```

これらのシェアードメソッドで制約インスタンスを生成します。

```xojo
Var fixedWidth As XjConstraint = XjConstraint.Fixed(20)
Var percentHeight As XjConstraint = XjConstraint.Percent(50)
Var autoSize As XjConstraint = XjConstraint.Auto()
```

## 取得メソッド

```xojo
Function Mode() As Integer
Function Value() As Integer
Function MinValue() As Integer
Function MaxValue() As Integer
```

- `Mode()` — MODE_AUTO、MODE_FIXED、MODE_PERCENT のいずれか
- `Value()` — Fixed/Percent モード時の値
- `MinValue/MaxValue()` — クランプの最小・最大値

```xojo
Var constraint As XjConstraint = XjConstraint.Fixed(20)
Var mode As Integer = constraint.Mode()  // MODE_FIXED
Var value As Integer = constraint.Value()  // 20
```

## 制約設定

```xojo
Function SetMin(minValue As Integer) As XjConstraint
Function SetMax(maxValue As Integer) As XjConstraint
```

フルーエントパターンで最小・最大値を設定します。

```xojo
Var constraint As XjConstraint = XjConstraint.Percent(50).SetMin(10).SetMax(100)
```

## モード判定

```xojo
Function IsAuto() As Boolean
Function IsFixed() As Boolean
Function IsPercent() As Boolean
```

```xojo
If constraint.IsFixed() Then
  Var size As Integer = constraint.Value()
ElseIf constraint.IsPercent() Then
  Var percent As Double = constraint.Value()
End If
```

## 制約の解決

```xojo
Function Resolve(availableSpace As Integer) As Integer
```

利用可能な空間を受け取り、実際のピクセルサイズを計算して返します。

```xojo
// 親が幅100を提供
Var width1 As Integer = XjConstraint.Fixed(20).Resolve(100)     // 20
Var width2 As Integer = XjConstraint.Percent(50).Resolve(100)   // 50
Var width3 As Integer = XjConstraint.Auto().Resolve(100)        // 100（利用可能全体）
```

## 複製

```xojo
Function Clone() As XjConstraint
```

制約を複製します。

```xojo
Var original As XjConstraint = XjConstraint.Fixed(20)
Var copy As XjConstraint = original.Clone()
```

## 実装例

### レイアウト定義

```xojo
Sub DefineLayout()
  Var root As New XjLayoutNode()

  // 子要素1：固定幅20
  Var child1 As New XjLayoutNode()
  Call child1.SetWidth(XjConstraint.Fixed(20))

  // 子要素2：親の50%
  Var child2 As New XjLayoutNode()
  Call child2.SetWidth(XjConstraint.Percent(50))

  // 子要素3：残り全て
  Var child3 As New XjLayoutNode()
  Call child3.SetWidth(XjConstraint.Auto())

  Call root.AddChild(child1)
  Call root.AddChild(child2)
  Call root.AddChild(child3)
End Sub
```

### 最小・最大値の制御

```xojo
// 幅は最小20、最大100、デフォルト50%
Var constraint As XjConstraint = XjConstraint.Percent(50).SetMin(20).SetMax(100)

// 親幅が150の場合
Var width As Integer = constraint.Resolve(150)  // 50% = 75（20-100の範囲内）

// 親幅が30の場合
Var width As Integer = constraint.Resolve(30)   // 50% = 15 -> クランプ -> 20
```

### レスポンシブレイアウト

```xojo
Class ResponsiveLayout
  Function GetMainPanelWidth(screenWidth As Integer) As Integer
    // 画面幅に応じた主パネル幅
    If screenWidth < 40 Then
      Return XjConstraint.Auto().Resolve(screenWidth)
    ElseIf screenWidth < 80 Then
      Return XjConstraint.Percent(70).Resolve(screenWidth)
    Else
      Return XjConstraint.Fixed(60).Resolve(screenWidth)
    End If
  End Function

  Function GetSidebarWidth(screenWidth As Integer) As Integer
    // サイドバー幅（最小15、最大25）
    Return XjConstraint.Percent(30).SetMin(15).SetMax(25).Resolve(screenWidth)
  End Function
End Class
```

### グリッドレイアウト

```xojo
Class GridLayout
  Private mColumnCount As Integer
  Private mConstraints() As XjConstraint

  Sub New(columnCount As Integer)
    mColumnCount = columnCount
    ReDim mConstraints(columnCount - 1)

    // 各列を等幅に
    For i As Integer = 0 To columnCount - 1
      mConstraints(i) = XjConstraint.Percent(100.0 / columnCount)
    Wend
  End Sub

  Function GetColumnWidth(screenWidth As Integer, columnIndex As Integer) As Integer
    Return mConstraints(columnIndex).Resolve(screenWidth)
  End Function
End Class

// 使用例
Var grid As New GridLayout(3)  // 3列グリッド
Var col1Width As Integer = grid.GetColumnWidth(90, 0)  // 30
Var col2Width As Integer = grid.GetColumnWidth(90, 1)  // 30
Var col3Width As Integer = grid.GetColumnWidth(90, 2)  // 30
```
