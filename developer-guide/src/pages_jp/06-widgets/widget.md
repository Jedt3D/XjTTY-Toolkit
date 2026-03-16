---
title: ウィジェット基底クラス
description: XjWidgetは全ウィジェットの基底クラスで、レイアウトノード、描画、イベント処理を提供します。
---

# ウィジェット基底クラス（XjWidget）

XjWidgetクラスはすべてのUI部品の基底クラスで、レイアウトツリー管理、描画、キーボード・タイマーイベント処理を実装します。テンプレートメソッドパターンを使用し、サブクラスがPaintContent()とHandleKey()をオーバーライドして機能を実装します。

## コンストラクタ

```xojo
Sub New()
```

各ウィジェットはXjLayoutNodeを所有し、これ経由でレイアウト情報にアクセスします。

## レイアウトアクセス

```xojo
Function LayoutNode() As XjLayoutNode
```

ウィジェットが所有するレイアウトノードを取得します。

```xojo
Var widget As New XjWidget()
Var layoutNode As XjLayoutNode = widget.LayoutNode()
Call layoutNode.SetWidth(XjConstraint.Fixed(20))
```

## レイアウト設定（フルーエント）

```xojo
Function Set(name As String) As XjWidget
Function SetWidth(constraint As XjConstraint) As XjWidget
Function SetHeight(constraint As XjConstraint) As XjWidget
Function SetPadding(top As Integer, right As Integer, bottom As Integer, left As Integer) As XjWidget
Function SetMargin(top As Integer, right As Integer, bottom As Integer, left As Integer) As XjWidget
Function SetBorder(style As Integer, color As Integer) As XjWidget
Function SetTitle(title As String) As XjWidget
```

これらはレイアウトノードの設定メソッドのラッパーで、フルーエントパターンを提供します。

```xojo
Var widget As New XjBox()
Call widget.SetWidth(XjConstraint.Fixed(40))
Call widget.SetHeight(XjConstraint.Fixed(10))
Call widget.SetPadding(1, 2, 1, 2)
```

## 子ウィジェット管理

```xojo
Sub AddChild(child As XjWidget)
Function ChildCount() As Integer
Function Child(index As Integer) As XjWidget
```

ウィジェットは階層構造を形成できます。

```xojo
Var parent As New XjBox()
Var child1 As New XjText()
Var child2 As New XjText()

Call parent.AddChild(child1)
Call parent.AddChild(child2)

For i As Integer = 0 To parent.ChildCount() - 1
  Var child As XjWidget = parent.Child(i)
Wend
```

## 描画

```xojo
Sub Paint(canvas As XjCanvas)
Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer, w As Integer, h As Integer)
```

- `Paint()` — テンプレートメソッド：ボーダーを描画して、PaintContent()を呼び出し
- `PaintContent()` — サブクラスが実装：ウィジェットの実際の内容を描画

サブクラスはPaintContent()をオーバーライドして内容を実装します。

```xojo
Class MyWidget
  Extends XjWidget

  Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer, w As Integer, h As Integer)
    // キャンバスに描画（x, yが開始位置、w, hが利用可能なサイズ）
    canvas.WriteText(x, y, "Hello", XjStyle.Success())
  End Sub
End Class
```

## イベント処理

```xojo
Function HandleKey(key As XjKeyEvent) As Boolean
Sub HandleTick(tickCount As Integer)
```

- `HandleKey()` — キーイベント処理（イベント処理済みならTrue）
- `HandleTick()` — 定期的なティック処理（アニメーション等）

```xojo
Class MyWidget
  Extends XjWidget

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsEnter() Then
      // Enter キー処理
      Return True  // イベント処理済み
    End If
    Return False   // イベント未処理（親に伝播）
  End Function

  Sub HandleTick(tickCount As Integer)
    If tickCount Mod 30 = 0 Then
      // 1秒ごとに実行（30 FPS想定）
    End If
  End Sub
End Class
```

## フォーカス管理

```xojo
Function IsFocusable() As Boolean
Function IsFocused() As Boolean
```

- `IsFocusable()` — ウィジェットがキーボードフォーカスを受け入れるか
- `IsFocused()` — 現在フォーカスを持つているか

```xojo
If widget.IsFocusable() Then
  // キーボード入力を受け付ける
End If
```

## 状態管理

```xojo
Sub MarkDirty()
```

ウィジェットを再描画が必要な状態（ダーティ）とマークします。

```xojo
Sub UpdateContent(newContent As String)
  // 内容更新
  mContent = newContent
  MarkDirty()  // 次のフレームで再描画
End Sub
```

## 実装例

### カスタムウィジェット

```xojo
Class ProgressDisplay
  Extends XjWidget
  Private mValue As Integer = 0
  Private mMax As Integer = 100

  Sub SetValue(value As Integer)
    mValue = Min(value, mMax)
    MarkDirty()
  End Sub

  Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer,
                   w As Integer, h As Integer)
    Var percent As Integer = Int(mValue * 100 / mMax)
    Var barWidth As Integer = Int(w * percent / 100)

    // プログレスバーを描画
    For i As Integer = 0 To barWidth - 1
      canvas.SetCell(x + i, y, "█", XjStyle.Success())
    Wend

    For i As Integer = barWidth To w - 1
      canvas.SetCell(x + i, y, "░", XjStyle.Muted())
    Wend

    // パーセンテージテキスト
    Var text As String = percent.ToString() + "%"
    canvas.WriteText(x + w - text.Length, y, text, XjStyle.Default())
  End Sub
End Class
```

### 操作可能なウィジェット

```xojo
Class SelectableList
  Extends XjWidget
  Private mItems() As String
  Private mSelectedIndex As Integer = 0

  Sub SetItems(items() As String)
    mItems = items
    mSelectedIndex = 0
    MarkDirty()
  End Sub

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsArrowUp() Then
      mSelectedIndex = Max(0, mSelectedIndex - 1)
      MarkDirty()
      Return True
    ElseIf key.IsArrowDown() Then
      mSelectedIndex = Min(mItems.Count - 1, mSelectedIndex + 1)
      MarkDirty()
      Return True
    End If
    Return False
  End Function

  Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer,
                   w As Integer, h As Integer)
    For i As Integer = 0 To Min(mItems.Count - 1, h - 1)
      Var style As XjStyle
      If i = mSelectedIndex Then
        style = XjStyle.Highlight()
      Else
        style = XjStyle.Default()
      End If

      canvas.WriteText(x, y + i, mItems(i), style)
    Wend
  End Sub
End Class
```

## ウィジェット階層

```
XjWidget（基底）
  ├─ XjBox（コンテナ）
  ├─ XjText（テキスト表示）
  ├─ XjTextInput（テキスト入力）
  ├─ XjTable（テーブル）
  ├─ XjProgressBar（プログレスバー）
  ├─ XjSpinner（スピナー）
  └─ XjTree（ツリー）
```

各ウィジェットはXjWidgetを拡張し、PaintContent()やHandleKey()をオーバーライドして機能を実装します。
