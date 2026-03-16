---
title: プログレスバーとスピナー
description: XjProgressBarは進捗表示、XjSpinnerはアニメーション表示ウィジェットです。カスタムフォーマット、成功・エラーマークに対応。
---

# プログレスバーとスピナー（XjProgressBar、XjSpinner）

XjProgressBarは処理の進捗を表示し、XjSpinnerはアニメーション付きの待機状態を表示するウィジェットです。

## XjProgressBar（プログレスバー）

ファイルダウンロード、データ処理などの進捗を可視化します。

### コンストラクタ

```xojo
Sub New()
```

### 値管理

```xojo
Function SetValue(value As Integer) As XjProgressBar
Function SetTotal(total As Integer) As XjProgressBar
Function Value() As Integer
Function Percent() As Integer
Function IsComplete() As Boolean
Sub Advance(amount As Integer)
Sub Reset()
```

- `SetValue/SetTotal()` — 現在値と総容量を設定
- `Advance()` — 進捗を増加
- `IsComplete()` — 完了したか確認

```xojo
Var progress As New XjProgressBar()
Call progress.SetTotal(100)
Call progress.SetValue(0)

While progress.Value() < progress.Total()
  Call progress.Advance(10)
Wend
```

### フォーマット

```xojo
Function SetFormat(format As String) As XjProgressBar
```

フォーマット文字列内のトークン：
- `:bar` — プログレスバー表示
- `:percent` — パーセンテージ
- `:current` — 現在値
- `:total` — 総容量
- `:eta` — 推定残り時間

```xojo
Var progress As New XjProgressBar()
Call progress.SetFormat("[{:bar}] {:percent}% ({:current}/{:total})")
// 出力例: [████████░░░░░░] 50% (50/100)
```

### バー表示カスタマイズ

```xojo
Function SetBarWidth(width As Integer) As XjProgressBar
Function SetFilledChar(char As String) As XjProgressBar
Function SetEmptyChar(char As String) As XjProgressBar
Function SetHeadChar(char As String) As XjProgressBar
Function SetFilledStyle(style As XjStyle) As XjProgressBar
Function SetEmptyStyle(style As XjStyle) As XjProgressBar
```

```xojo
Var progress As New XjProgressBar()
Call progress.SetBarWidth(40)
Call progress.SetFilledChar("█")
Call progress.SetEmptyChar("░")
Call progress.SetFilledStyle(XjStyle.Success())
```

### 不確定モード

```xojo
Function SetIndeterminate(indeterminate As Boolean) As XjProgressBar
```

進捗が不確定な場合（完了時間が未知）、アニメーション状態を表示。

```xojo
Var progress As New XjProgressBar()
Call progress.SetIndeterminate(True)  // バーがアニメーション
```

## XjSpinner（スピナー）

待機状態をアニメーション表示します。

### コンストラクタ

```xojo
Sub New()
```

### フォーマット選択

```xojo
Function SetFormat(name As String) As XjSpinner
```

利用可能なフォーマット：
- dots, line, arc, star, bounce, arrow, clock, moon, bar, blocks

```xojo
Var spinner As New XjSpinner()
Call spinner.SetFormat("dots")     // ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏
// または
Call spinner.SetFormat("arrow")    // ←↖↑↗→↘↓↙
```

### フレーム設定

```xojo
Function SetFrames(frames() As String) As XjSpinner
Function SetInterval(tickInterval As Integer) As XjSpinner
```

カスタムフレームと更新間隔を設定。

```xojo
Var spinner As New XjSpinner()
Var frames() As String = Array("▖", "▘", "▝", "▗")
Call spinner.SetFrames(frames)
Call spinner.SetInterval(2)  // 2ティック間隔で更新
```

### メッセージとスタイル

```xojo
Function SetMessage(message As String) As XjSpinner
Function SetSpinnerStyle(style As XjStyle) As XjSpinner
Function SetMessageStyle(style As XjStyle) As XjSpinner
```

スピナーの横にメッセージを表示。

```xojo
Var spinner As New XjSpinner()
Call spinner.SetFormat("dots")
Call spinner.SetMessage("Loading...")
Call spinner.SetSpinnerStyle(XjStyle.Success())
Call spinner.SetMessageStyle(XjStyle.Default())
```

### 成功・エラー表示

```xojo
Function SetSuccessMark(mark As String) As XjSpinner
Function SetErrorMark(mark As String) As XjSpinner
Function Success(message As String) As XjSpinner
Function Error_(message As String) As XjSpinner
Sub Stop_()
```

処理完了時に成功またはエラーマークを表示。

```xojo
Var spinner As New XjSpinner()
Call spinner.SetFormat("dots")
Call spinner.SetMessage("Processing...")

// 処理実行...

// 完了
Call spinner.Success("Complete!")
// または
Call spinner.Error_("Failed!")
```

## 実装例

### ファイルダウンロード進捗

```xojo
Sub DownloadFile(filename As String)
  Var progress As New XjProgressBar()
  Call progress.SetTotal(100)
  Call progress.SetFormat("[{:bar}] {:percent}% ({:current}/{:total}) {:eta}")

  For i As Integer = 0 To 100 Step 10
    Call progress.SetValue(i)
    // ダウンロード処理
  Wend
End Sub
```

### 初期化プログレス

```xojo
Function InitializeApp() As Boolean
  Var progress As New XjProgressBar()
  Call progress.SetFormat("Initialize: {:percent}%")

  Var steps() As String = Array("Loading config", "Connecting DB", "Reading cache", "Building UI")

  For i As Integer = 0 To steps.Count - 1
    Call progress.SetValue(i * 100 / steps.Count)
    // 各ステップ実行
  Wend

  Call progress.SetValue(100)
  Return True
End Function
```

### ローディングスピナー

```xojo
Sub WaitForProcess()
  Var spinner As New XjSpinner()
  Call spinner.SetFormat("dots")
  Call spinner.SetMessage("Processing...")

  // 長時間処理
  While Processing()
    // スピナー更新
  Wend

  // 成功表示
  Call spinner.Success("Done!")
End Sub
```

### ステータスインジケーター

```xojo
Class TaskProgress
  Private mSpinner As XjSpinner
  Private mProgress As XjProgressBar

  Sub New(taskName As String)
    // スピナー
    mSpinner = New XjSpinner()
    Call mSpinner.SetFormat("line")
    Call mSpinner.SetMessage(taskName + "...")

    // プログレスバー
    mProgress = New XjProgressBar()
    Call mProgress.SetTotal(100)
    Call mProgress.SetFormat("[{:bar}] {:percent}%")
  End Sub

  Sub UpdateProgress(percent As Integer)
    Call mProgress.SetValue(percent)
  End Sub

  Sub Complete(success As Boolean)
    If success Then
      Call mSpinner.Success("Completed")
    Else
      Call mSpinner.Error_("Failed")
    End If
  End Sub

  Function GetSpinner() As XjSpinner
    Return mSpinner
  End Function

  Function GetProgress() As XjProgressBar
    Return mProgress
  End Function
End Class
```

### マルチタスク進捗

```xojo
Sub DownloadMultipleFiles(urls() As String)
  Var mainProgress As New XjProgressBar()
  Call mainProgress.SetTotal(urls.Count)
  Call mainProgress.SetFormat("Overall: {:current}/{:total}")

  For i As Integer = 0 To urls.Count - 1
    Var spinner As New XjSpinner()
    Call spinner.SetMessage("Downloading " + urls(i))
    Call spinner.SetFormat("dots")

    // ファイルダウンロード...

    Call spinner.Success("Downloaded")
    Call mainProgress.Advance(1)
  Wend
End Sub
```

## バーフォーマットのカスタマイズ

```xojo
Var progress As New XjProgressBar()
Call progress.SetBarWidth(50)
Call progress.SetFilledChar("▓")      // 濃いグラデーション
Call progress.SetEmptyChar("░")       // 薄いグラデーション
Call progress.SetHeadChar("▒")        // 先端
Call progress.SetFormat("[{:bar}] {:percent}%")
```

## フルーエント設定例

```xojo
Var progress As New XjProgressBar()
Call progress.SetTotal(100)
Call progress.SetValue(0)
Call progress.SetBarWidth(30)
Call progress.SetFilledStyle(XjStyle.Success())
Call progress.SetFormat("[{:bar}] {:percent}%")

Var spinner As New XjSpinner()
Call spinner.SetFormat("dots")
Call spinner.SetMessage("Loading")
Call spinner.SetSpinnerStyle(XjStyle.Info())
```
