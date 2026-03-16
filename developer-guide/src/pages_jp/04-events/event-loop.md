---
title: イベントループ
description: XjEventLoopクラスはメインアプリケーションループをRawモード、代替スクリーン、イベント処理を自動管理します。
---

# イベントループ（XjEventLoop）

XjEventLoopクラスはXojoコンソールアプリケーションの主要なメインループを実装します。キーボード入力、マウス追跡、ウィンドウリサイズ、定期的なティックを処理し、Rawモード・代替スクリーン・カーソル非表示を自動管理します。

## コンストラクタ

```xojo
Sub New(refreshMs As Integer = 33)
```

refreshMsはティック間隔（ミリ秒）です。デフォルトの33msは約30FPSに相当します。

```xojo
Var loop As New XjEventLoop()          // デフォルト（30 FPS）
Var loop As New XjEventLoop(16)        // 60 FPS
Var loop As New XjEventLoop(100)       // 10 FPS
```

## 自動管理フラグ

```xojo
Property AutoRawMode As Boolean = True
Property AutoAlternateScreen As Boolean = True
Property AutoHideCursor As Boolean = True
```

これらのフラグはルーティング開始時に対応する機能を自動的に有効化し、終了時に無効化します。

```xojo
Var loop As New XjEventLoop()
loop.AutoRawMode = True               // 自動的にRawモードを有効化
loop.AutoAlternateScreen = True       // 自動的に代替スクリーンに切り替え
loop.AutoHideCursor = True            // 自動的にカーソルを非表示化
loop.Run()
```

## メインループ制御

```xojo
Sub Run()
Sub Stop_()
```

- `Run()` — イベントループを開始（イベントが発生するまでブロック）
- `Stop_()` — ループを停止

```xojo
Var loop As New XjEventLoop()

loop.OnKeyPress = Function(key) As Boolean
  If key.IsEscape() Then
    loop.Stop_()
    Return True
  End If
  Return False
End Function

loop.Run()
```

## ルーティング情報

```xojo
Function TickCount() As Integer
Function IsRunning() As Boolean
Function ElapsedSeconds() As Double
Function LastWidth() As Integer
Function LastHeight() As Integer
```

- `TickCount()` — 発生したティックの総数
- `IsRunning()` — ループが実行中か
- `ElapsedSeconds()` — ループ開始からの経過秒数
- `LastWidth/Height()` — 最後のウィンドウサイズ

```xojo
While loop.IsRunning()
  If loop.TickCount() Mod 30 = 0 Then
    // 1秒ごとに実行
  End If
Wend
```

## コールバック設定

```xojo
Property OnKeyPress As Delegate
Property OnResize As Delegate
Property OnTick As Delegate
```

これらのデリゲートはイベント発生時に呼び出されます。

### OnKeyPress

```xojo
loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
  If key.IsEscape() Then
    loop.Stop_()
    Return True  // イベント処理済み
  End If
  Return False   // イベント未処理
End Function
```

### OnResize

```xojo
loop.OnResize = Sub(width As Integer, height As Integer)
  // ウィンドウがリサイズされた
  Var canvas As New XjCanvas(width, height)
  // ... 再レイアウト
End Sub
```

### OnTick

```xojo
loop.OnTick = Sub(tickCount As Integer)
  // フレーム更新処理
  If tickCount Mod 30 = 0 Then
    XjScreen.Clear()
    // ... キャンバス描画
    XjTerminal.Write(canvas.Render())
  End If
End Sub
```

## 実装例

### シンプルなTUIアプリケーション

```xojo
Sub Main()
  Var loop As New XjEventLoop()
  Var root As New XjBox()
  Var canvas As XjCanvas

  loop.OnResize = Sub(w As Integer, h As Integer)
    canvas = New XjCanvas(w, h)
  End Sub

  loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
    If key.IsEscape() Then
      loop.Stop_()
      Return True
    End If
    Return False
  End Function

  loop.OnTick = Sub(tickCount As Integer)
    XjScreen.Clear()
    root.Paint(canvas)
    XjTerminal.Write(canvas.Render())
  End Sub

  loop.Run()
End Sub
```

### 状態管理付きアプリケーション

```xojo
Class AppState
  Property SelectedIndex As Integer = 0
  Property Message As String = ""
  Property IsRunning As Boolean = True
End Class

Sub RunApp()
  Var state As New AppState()
  Var loop As New XjEventLoop(33)

  loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
    If key.IsEscape() Then
      state.IsRunning = False
      loop.Stop_()
      Return True
    ElseIf key.IsArrowUp() Then
      state.SelectedIndex = Max(0, state.SelectedIndex - 1)
      Return True
    ElseIf key.IsArrowDown() Then
      state.SelectedIndex = Min(9, state.SelectedIndex + 1)
      Return True
    End If
    Return False
  End Function

  loop.OnTick = Sub(tickCount As Integer)
    // 状態に基づいて描画
    RenderUI(state)
  End Sub

  loop.Run()
End Sub
```

### アニメーション

```xojo
Class Spinner
  Private mFrames() As String = Array("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
  Private mFrameIndex As Integer = 0

  Function Next() As String
    mFrameIndex = (mFrameIndex + 1) Mod mFrames.Count
    Return mFrames(mFrameIndex)
  End Function
End Class

Sub RunAnimatedApp()
  Var spinner As New Spinner()
  Var loop As New XjEventLoop(100)  // 10 FPS

  loop.OnTick = Sub(tickCount As Integer)
    Var frame As String = spinner.Next()
    XjTerminal.Write(XjANSI.CursorPosition(1, 1))
    XjTerminal.Write(frame + " Loading")
  End Sub

  loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
    If key.IsEscape() Then
      loop.Stop_()
      Return True
    End If
    Return False
  End Function

  loop.Run()
End Sub
```

## XjEventLoopのライフサイクル

1. **初期化** — `New XjEventLoop()`
2. **設定** — `OnKeyPress`、`OnResize`、`OnTick`を設定
3. **開始** — `Run()` を呼び出し
4. **処理** — イベント発生時にコールバック呼び出し
5. **停止** — `Stop_()` または終了キー
6. **クリーンアップ** — AutoフラグがtrueならRawモード無効化など

```xojo
Var loop As New XjEventLoop()
// ... コールバック設定
loop.Run()  // ブロック
// ... ここは loop.Stop_() の後に実行
```
