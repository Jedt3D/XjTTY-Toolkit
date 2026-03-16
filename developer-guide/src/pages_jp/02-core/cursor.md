---
title: カーソル制御
description: XjCursorモジュールはカーソルの移動、表示・非表示、位置保存・復元を提供します。
---

# カーソル制御（XjCursor）

XjCursorモジュールはターミナルカーソルの移動と制御を行う高レベル関数を提供します。直接のANSIエスケープコード呼び出しより簡潔で使いやすいインターフェースです。

## 絶対位置移動

```xojo
Sub MoveTo(row As Integer, col As Integer)
Sub MoveToColumn(col As Integer)
Sub Home()
```

- `MoveTo()` — カーソルを指定された行と列に移動（1ベース）
- `MoveToColumn()` — カーソルを現在行の指定列に移動
- `Home()` — カーソルを左上隅（1,1）に移動

```xojo
XjCursor.Home()
XjCursor.MoveTo(10, 5)      // 行10、列5へ
XjCursor.MoveToColumn(20)   // 現在行の列20へ
```

## 相対移動

```xojo
Sub MoveUp(n As Integer)
Sub MoveDown(n As Integer)
Sub MoveLeft(n As Integer)
Sub MoveRight(n As Integer)
Sub NextLine(n As Integer)
Sub PrevLine(n As Integer)
Sub MoveRelative(deltaRow As Integer, deltaCol As Integer)
```

- `MoveUp/Down/Left/Right()` — カーソルをn行またはn列移動
- `NextLine()` — n行下の行頭へ移動
- `PrevLine()` — n行上の行頭へ移動
- `MoveRelative()` — 行と列のオフセットで移動

```xojo
XjCursor.MoveDown(5)        // 5行下へ
XjCursor.MoveRight(10)      // 10列右へ
XjCursor.NextLine(2)        // 2行下の行頭へ
XjCursor.MoveRelative(3, -5) // 3行下、5列左へ
```

## 表示制御

```xojo
Sub Show()
Sub Hide()
```

カーソルの表示・非表示を切り替えます。フルスクリーンのTUIアプリケーションでは、通常カーソルは非表示にします。

```xojo
XjCursor.Hide()
Try
  // TUIアプリケーション処理
Finally
  XjCursor.Show()
End Try
```

## カーソル位置の保存と復元

```xojo
Sub Save()
Sub Restore()
```

カーソル位置をスタックに保存し、後で復元できます。

```xojo
XjCursor.Save()
// 処理
XjCursor.Restore()
```

## カーソル位置の取得

```xojo
Function GetPosition(ByRef row As Integer, ByRef col As Integer) As Boolean
```

カーソルの現在位置を参照パラメータで取得します。成功時はTrueを返します。

```xojo
If XjCursor.GetPosition(Var r As Integer, Var c As Integer) Then
  XjTerminal.Write("Current position: row=" + r.ToString + ", col=" + c.ToString())
End If
```

## 実装例

### ターミナル座標系

ターミナルの座標系は1ベース（行1、列1が左上隅）です。

```xojo
XjCursor.MoveTo(1, 1)       // 左上隅
XjCursor.MoveTo(24, 80)     // 行24、列80へ
```

### カーソルの保存と復元

```xojo
XjCursor.Save()
XjCursor.MoveTo(5, 10)
XjTerminal.Write("Temporary message")
XjCursor.Restore()
// カーソルは元の位置に戻る
```

### 非表示でのレンダリング

```xojo
XjCursor.Hide()
Try
  // スクリーン全体を再描画
  Var canvas As New XjCanvas(XjScreen.Width(), XjScreen.Height())
  // ... 描画処理
  XjScreen.Clear()
  XjTerminal.Write(canvas.Render())
Finally
  XjCursor.Show()
End Try
```

### テキスト位置の計算

```xojo
Function CalculateTextPosition(startCol As Integer, textLength As Integer) As Integer
  // テキスト後のカーソル位置を計算
  Return startCol + textLength
End Function

Var col As Integer = 10
XjCursor.MoveToColumn(col)
XjTerminal.Write("Hello")
Var nextCol As Integer = CalculateTextPosition(col, 5)
XjCursor.MoveToColumn(nextCol)
```

## XjANSIとの関係

XjCursorは内部的にXjANSIのエスケープコード生成関数を使用しています。

```xojo
// これら2つは等価
XjCursor.MoveTo(10, 5)
XjTerminal.Write(XjANSI.CursorPosition(10, 5))

// これら2つは等価
XjCursor.MoveUp(3)
XjTerminal.Write(XjANSI.CursorUp(3))
```
