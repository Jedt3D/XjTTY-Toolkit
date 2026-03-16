---
title: テキストスタイル
description: XjStyleクラスはイミュータブルなフルーエントビルダーパターンで、テキスト色、背景色、装飾を組み合わせて定義します。
---

# テキストスタイル（XjStyle）

XjStyleクラスはテキスト描画のスタイル（色、装飾）をイミュータブルなフルーエントビルダーパターンで定義します。前景色、背景色、太字、斜体、下線などの属性を組み合わせることができます。

## コンストラクタ

```xojo
Sub New()                // デフォルトスタイル（スタイルなし）
Sub New(fg As Integer, bg As Integer)    // 前景色と背景色を指定
```

## フルーエントセッター

すべてのセッターは新しいXjStyleインスタンスを返し、チェーン可能です。ただし、Xojoの制限により、3レベル以上のチェーンは一時変数に分割する必要があります。

```xojo
Function SetFG(code As Integer) As XjStyle
Function SetBG(code As Integer) As XjStyle
Function SetFGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
Function SetBGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
Function SetBold() As XjStyle
Function SetDim() As XjStyle
Function SetItalic() As XjStyle
Function SetUnderline() As XjStyle
Function SetInverse() As XjStyle
Function SetStrikethrough() As XjStyle
Function SetBlink() As XjStyle
```

### セッターの使用例

```xojo
// 2レベルのチェーン：OK
Var style As XjStyle = Var s As New XjStyle
Call s.SetFG(XjANSI.FG_RED).SetBold()

// 3レベル以上：一時変数に分割
Var style As New XjStyle
Call style.SetFG(XjANSI.FG_RED)
Call style.SetBG(XjANSI.BG_WHITE)
Call style.SetBold()
```

## スタイル出力

```xojo
Function ToANSI() As String
Function Apply(text As String) As String
```

- `ToANSI()` — スタイルのANSIエスケープコード文字列
- `Apply()` — テキストにスタイルを適用（テキスト + Reset）

```xojo
Var style As New XjStyle
Call style.SetFG(XjANSI.FG_GREEN)
Call style.SetBold()

Var ansiCode As String = style.ToANSI()
Var styledText As String = style.Apply("Success!")
```

## スタイル比較と複製

```xojo
Function Equals(other As XjStyle) As Boolean
Function Clone() As XjStyle
Function IsEmpty() As Boolean
```

- `Equals()` — スタイルが等価か比較
- `Clone()` — スタイルを複製
- `IsEmpty()` — スタイルに何も設定されていないかチェック

```xojo
If style.IsEmpty() Then
  // スタイルが設定されていない
End If

Var newStyle As XjStyle = style.Clone()
```

## シェアードファクトリーメソッド

```xojo
Shared Function Default() As XjStyle         // デフォルトスタイル
Shared Function MakeBold() As XjStyle
Shared Function FGColor(code As Integer) As XjStyle
Shared Function BGColor(code As Integer) As XjStyle
Shared Function MakeFGRGB(r As Integer, g As Integer, b As Integer) As XjStyle
Shared Function Success() As XjStyle        // 緑
Shared Function Warning() As XjStyle        // 黄
Shared Function Danger() As XjStyle         // 赤
Shared Function Info() As XjStyle           // 青
Shared Function Muted() As XjStyle          // グレイ
Shared Function Highlight() As XjStyle      // ハイライト色
```

### ファクトリーメソッドの使用例

```xojo
Var successStyle As XjStyle = XjStyle.Success()
Var errorStyle As XjStyle = XjStyle.Danger()
Var infoStyle As XjStyle = XjStyle.Info()

Var message As String = successStyle.Apply("Operation completed")
```

## 実装例

### テーマの定義

```xojo
Class AppTheme
  Shared Function HeaderStyle() As XjStyle
    Var s As New XjStyle
    Call s.SetFG(XjANSI.FG_BRIGHT_CYAN)
    Call s.SetBold()
    Return s
  End Function

  Shared Function ErrorStyle() As XjStyle
    Var s As New XjStyle
    Call s.SetFG(XjANSI.FG_RED)
    Call s.SetBold()
    Return s
  End Function

  Shared Function SelectedStyle() As XjStyle
    Var s As New XjStyle
    Call s.SetBG(XjANSI.BG_BLUE)
    Call s.SetFG(XjANSI.FG_WHITE)
    Return s
  End Function
End Class
```

### テーブル行のスタイリング

```xojo
Var headerStyle As XjStyle = XjStyle.MakeBold()
Var rowStyle As XjStyle = XjStyle.Default()
Var selectedRowStyle As XjStyle = XjStyle.Highlight()

For i As Integer = 0 To rows.Count - 1
  Var style As XjStyle = If(i = selectedIndex, selectedRowStyle, rowStyle)
  canvas.WriteText(y, 1, rows(i), style)
  y = y + 1
Wend
```

### RGB色の使用

```xojo
// オレンジのテキスト
Var orangeStyle As New XjStyle
Call orangeStyle.SetFGRGB(255, 165, 0)

// 深い青の背景
Var bgStyle As New XjStyle
Call bgStyle.SetBGRGB(0, 51, 102)

Var styledText As String = orangeStyle.Apply("Custom color")
```

## XjCellとの関係

XjStyleはXjCellで使用され、キャンバス上の個々の文字に色と装飾を適用します。

```xojo
Var cell As New XjCell("A", XjStyle.Success())
canvas.SetCell(5, 10, cell.Char(), cell.Style())
```
