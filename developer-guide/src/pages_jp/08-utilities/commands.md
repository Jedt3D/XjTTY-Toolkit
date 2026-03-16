---
title: コマンド実行とユーティリティ
description: XjCommand、XjWhich、XjHistory、XjPagerの実装詳細。
---

# コマンド実行とユーティリティ（XjCommand、XjWhich、XjHistory、XjPager）

外部プログラム実行、実行ファイル検索、入力履歴管理、ページャー機能。

## XjCommand（コマンド実行）

シェルコマンドを実行して出力をキャプチャ。

```xojo
Function Execute(command As String) As XjCommandResult
Function Execute(command As String, timeoutMs As Integer) As XjCommandResult
```

```xojo
Var result As XjCommandResult = XjCommand.Execute("ls -la")
If result.ExitCode = 0 Then
  XjTerminal.Write(result.Output)
Else
  XjPrompt.Error_("Command failed: " + result.Output)
End If
```

### XjCommandResult

```xojo
Function ExitCode() As Integer
Function Output() As String
Function TimedOut() As Boolean
```

```xojo
Var result As XjCommandResult = XjCommand.Execute("echo 'hello'", 5000)
If result.TimedOut() Then
  XjPrompt.Error_("Command timed out")
Else
  XjTerminal.Write(result.Output)
End If
```

## XjWhich（実行ファイル検索）

PATHから実行ファイルを探索。

```xojo
Function Which(programName As String) As String
```

```xojo
Var pythonPath As String = XjWhich.Which("python3")
If pythonPath.Length > 0 Then
  XjTerminal.Write("Found: " + pythonPath)
Else
  XjPrompt.Error_("python3 not found")
End If
```

## XjHistory（入力履歴）

ユーザー入力の履歴を管理。

```xojo
Sub Add(entry As String)
Function Previous() As String
Function Next() As String
Function GetAll() As String()
Sub Clear()
```

```xojo
Var history As New XjHistory()
Call history.Add("ls -la")
Call history.Add("cd /tmp")

// 上矢印キー
Var prev As String = history.Previous()  // "cd /tmp"
Var prev2 As String = history.Previous() // "ls -la"

// 下矢印キー
Var next As String = history.Next()      // "cd /tmp"
```

## XjPager（ページャー）

長いテキストをページ単位で表示。

```xojo
Function Show(content As String) As Variant
```

```xojo
Var text As String = GetLongContent()
Var result As Variant = XjPager.Show(text)
// 'q'で終了、矢印キーで移動
```

キーバインディング：
- Space / Page Down — 次ページ
- Page Up — 前ページ
- Home / End — 最初・最後
- 'q' — 終了

## 実装例

### コマンド実行パイプライン

```xojo
Sub ProcessData()
  XjPrompt.Say("Running pipeline...")

  // ステップ1
  Var step1 As XjCommandResult = XjCommand.Execute("cat data.txt")
  If step1.ExitCode <> 0 Then
    XjPrompt.Error_("Step 1 failed")
    Return
  End If

  // ステップ2
  Var step2 As XjCommandResult = XjCommand.Execute("sort | uniq")
  XjPrompt.Ok("Pipeline complete")
End Sub
```

### 外部ツール検証

```xojo
Sub CheckDependencies()
  Var required() As String = Array("python", "git", "curl")

  For i As Integer = 0 To required.Count - 1
    Var path As String = XjWhich.Which(required(i))
    If path.Length > 0 Then
      XjPrompt.Ok(required(i) + ": " + path)
    Else
      XjPrompt.Error_(required(i) + ": not found")
    End If
  Wend
End Sub
```

### コマンド履歴

```xojo
Class CommandShell
  Private mHistory As XjHistory

  Sub New()
    mHistory = New XjHistory()
  End Sub

  Sub RunCommand(command As String)
    Call mHistory.Add(command)

    Var result As XjCommandResult = XjCommand.Execute(command)
    XjTerminal.Write(result.Output)
  End Sub

  Sub ShowHistory()
    Var all() As String = mHistory.GetAll()
    For i As Integer = 0 To all.Count - 1
      XjTerminal.Write((i + 1).ToString() + ": " + all(i))
    Wend
  End Sub
End Class
```

### ヘルプページャー

```xojo
Sub DisplayHelp()
  Var helpText As String = "Help for MyApp" + Xojo.Core.NewLine + Xojo.Core.NewLine
  helpText = helpText + "Commands:" + Xojo.Core.NewLine
  helpText = helpText + "  list     - List items" + Xojo.Core.NewLine
  helpText = helpText + "  add      - Add item" + Xojo.Core.NewLine
  // ... more help text

  Call XjPager.Show(helpText)
End Sub
```

### パッケージマネージャー

```xojo
Sub InstallPackage(packageName As String)
  XjPrompt.Say("Installing " + packageName + "...")

  Var pmPath As String = XjWhich.Which("npm")
  If pmPath.Length = 0 Then
    XjPrompt.Error_("npm not found. Please install Node.js")
    Return
  End If

  Var result As XjCommandResult = XjCommand.Execute(
    "npm install " + packageName,
    60000  // 60秒タイムアウト
  )

  If result.TimedOut() Then
    XjPrompt.Warn("Installation timed out")
  ElseIf result.ExitCode = 0 Then
    XjPrompt.Ok(packageName + " installed")
  Else
    XjPrompt.Error_("Installation failed")
  End If
End Sub
```

## 実行例

```xojo
Sub Main()
  // コマンド実行
  Var result As XjCommandResult = XjCommand.Execute("uname -a", 5000)
  XjTerminal.Write("OS: " + result.Output)

  // 依存性チェック
  If XjWhich.Which("docker").Length = 0 Then
    XjPrompt.Error_("Docker not installed")
  End If

  // 長いテキスト表示
  Var helpText As String = GetLongHelpText()
  Call XjPager.Show(helpText)
End Sub
```
