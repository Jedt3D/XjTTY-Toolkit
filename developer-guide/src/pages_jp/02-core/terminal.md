---
title: ターミナル制御
description: XjTerminalモジュールはrawモード、非ブロッキング入力、ターミナルサイズ、カラーサポート情報を提供します。
---

# ターミナル制御（XjTerminal）

XjTerminalモジュールはOSレベルのターミナル制御機能を提供します。rawモード、ノンブロッキング入力設定、ターミナルサイズ取得、カラーサポート検出などを実装しています。

## Rawモード制御

```xojo
Sub EnableRawMode()
Sub DisableRawMode()
Function IsRawMode() As Boolean
```

Rawモードは標準入力をバイナリモードに設定し、キーボード入力をリアルタイムで受け取ることを可能にします。通常、アプリケーション起動時にrawモードを有効にし、終了時に無効にします。

```xojo
// アプリ開始時
XjTerminal.EnableRawMode()
Try
  // メインループ
Finally
  XjTerminal.DisableRawMode()
End Try
```

## ターミナルサイズ

```xojo
Function Width() As Integer
Function Height() As Integer
Sub GetSize(ByRef w As Integer, ByRef h As Integer)
```

- `Width()` — ターミナルの列数
- `Height()` — ターミナルの行数
- `GetSize()` — サイズを参照パラメータで取得

```xojo
Var w As Integer = XjTerminal.Width()
Var h As Integer = XjTerminal.Height()

XjTerminal.GetSize(Var cols As Integer, Var rows As Integer)
```

## カラーサポート

```xojo
Function SupportsColor() As Boolean
Function ColorDepth() As Integer
```

- `SupportsColor()` — ターミナルがANSIカラーに対応しているかどうか
- `ColorDepth()` — サポートされている色数（8、16、256、またはそれ以上の値）

```xojo
If XjTerminal.SupportsColor() Then
  If XjTerminal.ColorDepth() >= 256 Then
    // 256色以上使用可能
  Else If XjTerminal.ColorDepth() >= 16 Then
    // 16色を使用
  End If
End If
```

## 入出力

```xojo
Function ReadByte() As Integer        // 1バイト読み込み（非ブロッキング）
Sub Write(text As String)              // テキスト出力
Sub EnableNonBlockingInput()
```

- `ReadByte()` — ターミナルから1バイト読み込み（バッファが空の場合は-1を返す）
- `Write()` — ターミナルにテキストを出力
- `EnableNonBlockingInput()` — 非ブロッキング入力を有効化

```xojo
XjTerminal.EnableNonBlockingInput()
Var b As Integer = XjTerminal.ReadByte()
If b >= 0 Then
  // キー入力を受けた
End If
```

## スクリーン制御

```xojo
Sub EnterAlternateScreen()
Sub ExitAlternateScreen()
```

代替スクリーンは、メインバッファを保存してから別の画面に切り替えるXjEventLoopの機能です。終了後に元の画面を復元します。

```xojo
// アプリ開始時
XjTerminal.EnterAlternateScreen()
Try
  // TUIアプリケーション
Finally
  XjTerminal.ExitAlternateScreen()
End Try
```

## マウス制御

```xojo
Sub EnableMouseTracking()
Sub DisableMouseTracking()
```

これらはマウスイベント（クリック、移動、スクロール）の受信を有効・無効にします。XjEventLoopはこれを自動的に管理します。

```xojo
XjTerminal.EnableMouseTracking()
// XjEventLoopでマウスイベント処理
XjTerminal.DisableMouseTracking()
```

## 実装例

```xojo
// ターミナルの初期化
XjTerminal.EnableRawMode()
XjTerminal.EnterAlternateScreen()
Var cols As Integer = XjTerminal.Width()
Var rows As Integer = XjTerminal.Height()

Try
  // レイアウト計算
  Var canvas As New XjCanvas(cols, rows)

  // 描画と入力処理
  While True
    Var b As Integer = XjTerminal.ReadByte()
    If b < 0 Then Continue

    If b = 27 Then  // ESC
      Exit
    End If
  Wend
Finally
  XjTerminal.ExitAlternateScreen()
  XjTerminal.DisableRawMode()
End Try
```

## XjEventLoopとの統合

通常、XjTerminalは直接使用せず、XjEventLoopが自動的にrawモード、代替スクリーン、マウス追跡を管理します。

```xojo
Var loop As New XjEventLoop()
// AutoRawMode、AutoAlternateScreen、AutoHideCursorは自動的にTrue
loop.Run()
```
