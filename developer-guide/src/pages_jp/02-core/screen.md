---
title: スクリーン制御
description: XjScreenモジュールはスクリーン消去、スクロール、描画プリミティブをサポートしています。
---

# スクリーン制御（XjScreen）

XjScreenモジュールはターミナルスクリーン全体の制御と低レベル描画プリミティブを提供します。スクリーンクリア、スクロール、テキスト配置、図形描画を実装しています。

## スクリーン消去

```xojo
Sub Clear()
Sub ClearLine()
Sub ClearToEnd()
Sub ClearToStart()
Sub ClearBelow()
Sub ClearAbove()
Sub ClearLines(count As Integer)
```

- `Clear()` — スクリーン全体を消去
- `ClearLine()` — 現在行を消去
- `ClearToEnd()` — カーソル位置から行末までを消去
- `ClearToStart()` — 行頭からカーソル位置までを消去
- `ClearBelow()` — カーソル下のすべての行を消去
- `ClearAbove()` — カーソル上のすべての行を消去
- `ClearLines()` — 指定数の行を消去

```xojo
XjScreen.Clear()
XjScreen.ClearLine()
XjScreen.ClearToEnd()
```

## スクロール

```xojo
Sub ScrollUp(n As Integer)
Sub ScrollDown(n As Integer)
```

スクリーンを上下にスクロールします。

```xojo
XjScreen.ScrollUp(3)    // 3行上にスクロール
XjScreen.ScrollDown(5)  // 5行下にスクロール
```

## ターミナルサイズ

```xojo
Function Width() As Integer
Function Height() As Integer
```

ターミナルの幅と高さを取得します。

```xojo
Var cols As Integer = XjScreen.Width()
Var rows As Integer = XjScreen.Height()
Var canvas As New XjCanvas(cols, rows)
```

## タイトル設定

```xojo
Sub SetTitle(title As String)
```

ターミナルウィンドウのタイトルを設定します。

```xojo
XjScreen.SetTitle("My Console App")
```

## フルスクリーン制御

```xojo
Sub EnterFullscreen()
Sub ExitFullscreen()
```

代替スクリーンに切り替え、元のスクリーンを保存します。XjEventLoopはこれを自動的に管理します。

```xojo
XjScreen.EnterFullscreen()
Try
  // TUIアプリケーション処理
Finally
  XjScreen.ExitFullscreen()
End Try
```

## テキスト配置

```xojo
Sub WriteAt(row As Integer, col As Integer, text As String)
```

指定した行と列にテキストを書き込みます。

```xojo
XjScreen.WriteAt(5, 10, "Status: OK")
XjScreen.WriteAt(10, 1, "Error: Invalid input")
```

## 図形描画

```xojo
Sub DrawHorizontalLine(row As Integer, col As Integer, length As Integer, char As String)
Sub DrawVerticalLine(row As Integer, col As Integer, length As Integer, char As String)
Sub FillRect(row As Integer, col As Integer, width As Integer, height As Integer, char As String)
```

- `DrawHorizontalLine()` — 水平線を描画
- `DrawVerticalLine()` — 垂直線を描画
- `FillRect()` — 矩形を文字で塗りつぶし

```xojo
// 水平線
XjScreen.DrawHorizontalLine(5, 1, 40, "-")

// 垂直線
XjScreen.DrawVerticalLine(5, 10, 10, "|")

// 矩形
XjScreen.FillRect(5, 10, 20, 10, "#")
```

## 実装例

### シンプルなレイアウト

```xojo
Sub DrawLayout()
  XjScreen.Clear()

  Var cols As Integer = XjScreen.Width()
  Var rows As Integer = XjScreen.Height()

  // ヘッダー
  XjScreen.WriteAt(1, 1, "Title")
  XjScreen.DrawHorizontalLine(2, 1, cols, "-")

  // コンテンツ
  XjScreen.WriteAt(4, 1, "Content goes here")

  // フッター
  XjScreen.DrawHorizontalLine(rows - 1, 1, cols, "-")
  XjScreen.WriteAt(rows, 1, "Status line")
End Sub
```

### ボーダー付きボックス

```xojo
Sub DrawBox(row As Integer, col As Integer, width As Integer, height As Integer)
  // 上辺
  XjScreen.DrawHorizontalLine(row, col, width, "-")

  // 左右の辺
  For i As Integer = 1 To height - 2
    XjScreen.WriteAt(row + i, col, "|")
    XjScreen.WriteAt(row + i, col + width - 1, "|")
  Wend

  // 下辺
  XjScreen.DrawHorizontalLine(row + height - 1, col, width, "-")
End Sub
```

## XjCanvasとの関係

通常のTUIアプリケーションでは、XjScreenの低レベル関数より、XjCanvasを使用した方が効率的です。XjCanvasはダブルバッファリングと差分更新をサポートしています。

```xojo
// 低レベル：個別に要素を描画
XjScreen.Clear()
XjScreen.WriteAt(5, 10, "Hello")

// 高レベル：キャンバスに描画してから出力
Var canvas As New XjCanvas(XjScreen.Width(), XjScreen.Height())
canvas.WriteText(5, 10, "Hello", XjStyle.Default())
XjScreen.Clear()
XjTerminal.Write(canvas.Render())
```
