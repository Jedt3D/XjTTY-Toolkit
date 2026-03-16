---
title: セルとキャンバス
description: XjCellはスタイル付き文字、XjCanvasは2Dグリッドレンダリング、差分更新、ボックス描画をサポートします。
---

# セルとキャンバス（XjCell、XjCanvas）

XjCellクラスはスタイル付きの単一文字を表し、XjCanvasクラスは2Dグリッドのセルを管理し、効率的な差分レンダリングとボックス描画を提供します。

## XjCell（セル）

セルは文字とそのスタイルの組を表します。

### コンストラクタ

```xojo
Sub New()                        // 空のセル
Sub New(char As String, style As XjStyle)
```

### メソッド

```xojo
Function Char() As String
Sub SetChar(c As String)
Function Style() As XjStyle
Sub SetStyle(s As XjStyle)
Sub Set(char As String, style As XjStyle)
Sub Reset()
Function Equals(other As XjCell) As Boolean
Function Clone() As XjCell
Function Render() As String
```

### セルの使用例

```xojo
Var cell As New XjCell("A", XjStyle.Success())
Var char As String = cell.Char()
Var style As XjStyle = cell.Style()

// セルのレンダリング
Var rendered As String = cell.Render()  // ANSI + 文字 + Reset
```

## XjCanvas（キャンバス）

キャンバスは2D文字グリッドで、テキストレンダリング、図形描画、差分更新をサポートしています。

### コンストラクタと基本メソッド

```xojo
Sub New(width As Integer, height As Integer)
Function GetWidth() As Integer
Function GetHeight() As Integer
Sub Resize(w As Integer, h As Integer)
```

### セル操作

```xojo
Sub SetCell(x As Integer, y As Integer, char As String, style As XjStyle)
Function GetCell(x As Integer, y As Integer) As XjCell
Sub SetChar(x As Integer, y As Integer, char As String)
```

セル（x, y）は0ベースの座標です。

```xojo
Var canvas As New XjCanvas(80, 24)
canvas.SetCell(5, 10, "A", XjStyle.Success())
Var cell As XjCell = canvas.GetCell(5, 10)
```

### テキスト書き込み

```xojo
Sub WriteText(x As Integer, y As Integer, text As String, style As XjStyle)
Sub WriteTextWrapped(x As Integer, y As Integer, maxWidth As Integer,
                      text As String, style As XjStyle)
```

- `WriteText()` — テキストを指定位置に書き込み（折り返しなし）
- `WriteTextWrapped()` — 最大幅で自動折り返し

```xojo
canvas.WriteText(5, 10, "Hello", XjStyle.Success())
canvas.WriteTextWrapped(1, 1, 20, "Long text that wraps", XjStyle.Default())
```

### スクリーン操作

```xojo
Sub Clear()
Sub ClearRegion(x As Integer, y As Integer, w As Integer, h As Integer, style As XjStyle)
Sub FillRegion(x As Integer, y As Integer, w As Integer, h As Integer,
               char As String, style As XjStyle)
```

### ボックス描画

```xojo
Sub DrawBox(x As Integer, y As Integer, w As Integer, h As Integer,
            style As XjStyle, borderStyle As Integer)
Sub DrawHLine(y As Integer, x1 As Integer, x2 As Integer, char As String, style As XjStyle)
Sub DrawVLine(x As Integer, y1 As Integer, y2 As Integer, char As String, style As XjStyle)
```

ボーダースタイル（borderStyle）：

- 0：シングルライン（─│┌┐└┘├┤┬┴┼）
- 1：ダブルライン（═║╔╗╚╝╠╣╦╩╬）
- 2：丸角（─│╭╮╰╯├┤┬┴┼）
- 3：太線（━┃┏┓┗┛┣┫┳┻╋）
- 4：ダッシュ（╌┆╎┄）

```xojo
canvas.DrawBox(5, 5, 20, 10, XjStyle.Default(), 0)  // シングルライン
canvas.DrawBox(30, 5, 20, 10, XjStyle.Default(), 1) // ダブルライン
```

### ブリット（転送）

```xojo
Sub Blit(source As XjCanvas, srcX As Integer, srcY As Integer,
         width As Integer, height As Integer, dstX As Integer, dstY As Integer)
```

別のキャンバスの領域をこのキャンバスにコピーします。

```xojo
Var source As New XjCanvas(10, 10)
// ... sourceに描画
canvas.Blit(source, 0, 0, 10, 10, 20, 20)
```

### スナップショット

```xojo
Function Snapshot() As XjCanvas
```

キャンバスの完全なコピーを取得（差分レンダリング用）。

```xojo
Var prev As XjCanvas = canvas.Snapshot()
// ... キャンバスを変更
Var output As String = canvas.DiffRender(prev)
```

### レンダリング

```xojo
Function Render() As String
Function DiffRender(prev As XjCanvas) As String
Function ToString() As String
```

- `Render()` — スクリーン全体を出力
- `DiffRender()` — 前回のスナップショットから変更部分のみを出力（効率的）
- `ToString()` — デバッグ用のテキスト表現

```xojo
// フルレンダリング
XjTerminal.Write(XjANSI.EraseScreen() + XjANSI.CursorPosition(1, 1))
XjTerminal.Write(canvas.Render())

// 差分レンダリング（次のフレーム以降）
Var prev As XjCanvas = canvas.Snapshot()
// ... キャンバス更新
XjTerminal.Write(canvas.DiffRender(prev))
prev = canvas.Snapshot()
```

## 実装例

### 単純なダッシュボード

```xojo
Var canvas As New XjCanvas(80, 24)

// ボーダー付きボックス
canvas.DrawBox(1, 1, 78, 22, XjStyle.Default(), 0)

// タイトル
canvas.WriteText(3, 2, "Dashboard", XjStyle.MakeBold())

// コンテンツ
canvas.WriteText(3, 5, "Status: ", XjStyle.Default())
canvas.WriteText(11, 5, "Running", XjStyle.Success())

// 出力
XjScreen.Clear()
XjTerminal.Write(canvas.Render())
```

### ウィンドウシステム

```xojo
Class Window
  Private mCanvas As XjCanvas
  Private mX As Integer
  Private mY As Integer
  Private mWidth As Integer
  Private mHeight As Integer
  Private mTitle As String

  Sub New(x As Integer, y As Integer, w As Integer, h As Integer, title As String)
    mX = x
    mY = y
    mWidth = w
    mHeight = h
    mTitle = title
    mCanvas = New XjCanvas(w, h)
  End Sub

  Sub Render(mainCanvas As XjCanvas)
    mCanvas.DrawBox(0, 0, mWidth, mHeight, XjStyle.Default(), 0)
    mCanvas.WriteText(2, 1, mTitle, XjStyle.MakeBold())
    mainCanvas.Blit(mCanvas, 0, 0, mWidth, mHeight, mX, mY)
  End Sub
End Class
```
