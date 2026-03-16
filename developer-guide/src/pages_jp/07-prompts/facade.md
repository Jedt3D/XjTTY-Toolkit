---
title: プロンプトファサード
description: XjPromptモジュールはテキスト、選択、確認などの対話的プロンプトを統一的に提供します。
---

# プロンプトファサード（XjPrompt）

XjPromptモジュールは高レベルな対話的UI部品への統一アクセスを提供するファサードパターンの実装です。テキスト入力、選択、確認、スライダー、複数選択など、一般的なユーザー対話を簡潔に実装できます。

## テキストプロンプト

```xojo
Function Ask(question As String) As String
Function AskWithHistory(question As String) As String
Function AskValidated(question As String, validator As XjValidation) As String
Function Password(question As String) As String
Function MultiLine(question As String) As String
Function Suggest(question As String, suggestions() As String) As String
```

### Ask（テキスト質問）

```xojo
Var name As String = XjPrompt.Ask("What is your name?")
```

### Password（パスワード入力）

```xojo
Var pwd As String = XjPrompt.Password("Enter password: ")
```

### Suggest（オートコンプリート）

```xojo
Var commands() As String = Array("list", "load", "list-files", "listen")
Var result As String = XjPrompt.Suggest("Enter command: ", commands)
```

## 選択プロンプト

```xojo
Function Select_(question As String, options() As String) As String
Function MultiSelect(question As String, options() As String) As String
Function EnumSelect(question As String, options() As String) As String
Function Expand(question As String, choices As Dictionary) As String
```

### Select_（単一選択）

```xojo
Var options() As String = Array("Red", "Green", "Blue")
Var color As String = XjPrompt.Select_("Choose color: ", options)
```

### MultiSelect（複数選択）

```xojo
Var features() As String = Array("Feature A", "Feature B", "Feature C")
Var selected() As String = XjPrompt.MultiSelect("Select features: ", features)
```

### EnumSelect（番号付き選択）

```xojo
Var choices() As String = Array("Option 1", "Option 2", "Option 3")
Var answer As String = XjPrompt.EnumSelect("Choose: ", choices)
// 出力: 1) Option 1, 2) Option 2, 3) Option 3
```

### Expand（キーマッピング選択）

```xojo
Var choices As New Dictionary()
choices.Value("y") = "Yes"
choices.Value("n") = "No"
choices.Value("a") = "All"
Var result As String = XjPrompt.Expand("Continue?", choices)
```

## 確認プロンプト

```xojo
Function Confirm(question As String) As Boolean
Function Deny(question As String) As Boolean
```

### Confirm（Yes/No質問）

```xojo
If XjPrompt.Confirm("Do you want to continue?") Then
  // はい
Else
  // いいえ
End If
```

## スペシャルプロンプト

```xojo
Function Slider(question As String, min As Integer, max As Integer) As Integer
Function KeyPress(question As String) As XjKeyEvent
Function Collect(questions As Dictionary) As Dictionary
```

### Slider（数値スライダー）

```xojo
Var value As Integer = XjPrompt.Slider("Select level (1-10): ", 1, 10)
```

### KeyPress（キー入力）

```xojo
Var key As XjKeyEvent = XjPrompt.KeyPress("Press any key...")
```

### Collect（複数質問チェーン）

```xojo
Var questions As New Dictionary()
questions.Value("name") = "What is your name?"
questions.Value("email") = "What is your email?"
questions.Value("age") = "What is your age?"

Var answers As Dictionary = XjPrompt.Collect(questions)
Var name As String = answers.Lookup("name", "")
```

## メッセージ出力

```xojo
Sub Say(message As String)
Sub Ok(message As String)
Sub Warn(message As String)
Sub Error_(message As String)
```

- `Say()` — 通常メッセージ
- `Ok()` — 成功メッセージ（緑）
- `Warn()` — 警告メッセージ（黄）
- `Error_()` — エラーメッセージ（赤）

```xojo
XjPrompt.Say("Processing...")
XjPrompt.Ok("Operation succeeded!")
XjPrompt.Warn("Check your input carefully")
XjPrompt.Error_("An error occurred")
```

## スタイル設定

```xojo
Sub SetStyle(style As XjPromptStyle)
```

プロンプト全体のスタイル（色、シンボル）をカスタマイズ。

```xojo
Var style As New XjPromptStyle()
Call style.SetPrefixStyle(XjStyle.Success())
XjPrompt.SetStyle(style)
```

## 実装例

### インタラクティブセットアップウィザード

```xojo
Sub SetupWizard()
  XjPrompt.Say("Welcome to Setup!")

  Var name As String = XjPrompt.Ask("Project name: ")
  Var type As String = XjPrompt.Select_("Project type: ", Array("Console", "Web", "Library"))
  Var hasTests As Boolean = XjPrompt.Confirm("Include tests?")
  Var features() As String = XjPrompt.MultiSelect("Features: ", Array("Logging", "Config", "CLI"))

  XjPrompt.Ok("Setup complete!")
  XjPrompt.Say("Project created: " + name)
End Sub
```

### 設定値入力フロー

```xojo
Sub ConfigureApp()
  Var config As New Dictionary()

  config.Value("host") = XjPrompt.Ask("Server host: ")
  config.Value("port") = XjPrompt.Slider("Port (1-65535): ", 1, 65535)
  config.Value("debug") = XjPrompt.Confirm("Enable debug mode?")
  config.Value("logLevel") = XjPrompt.Select_("Log level: ", Array("DEBUG", "INFO", "WARN", "ERROR"))

  XjPrompt.Ok("Configuration saved!")
End Sub
```

### ユーザー認証フロー

```xojo
Sub AuthenticateUser()
  While True
    Var username As String = XjPrompt.Ask("Username: ")
    Var password As String = XjPrompt.Password("Password: ")

    If ValidateCredentials(username, password) Then
      XjPrompt.Ok("Login successful!")
      Exit
    Else
      XjPrompt.Error_("Invalid credentials")
    End If
  Wend
End Sub
```

### メニューシステム

```xojo
Sub MainMenu()
  While True
    Var action As String = XjPrompt.Select_("Select action: ", Array(
      "View Profile", "Edit Settings", "View Messages", "Logout"
    ))

    Select Case action
      Case "View Profile"
        ShowProfile()
      Case "Edit Settings"
        EditSettings()
      Case "View Messages"
        ShowMessages()
      Case "Logout"
        XjPrompt.Ok("Goodbye!")
        Exit
    End Select
  Wend
End Sub
```

## フロー例

```xojo
// 1. 情報収集
Var email As String = XjPrompt.Ask("Email: ")
Var subscribe As Boolean = XjPrompt.Confirm("Subscribe to newsletter?")

// 2. 選択
Var plan As String = XjPrompt.Select_("Choose plan: ", Array("Free", "Pro", "Enterprise"))

// 3. 確認
If XjPrompt.Confirm("Confirm selection?") Then
  // 処理実行
  XjPrompt.Ok("Success!")
Else
  XjPrompt.Say("Cancelled")
End If
```

## デフォルトスタイル

XjPromptはデフォルトで以下のスタイルを使用：

| 要素 | スタイル |
|------|---------|
| プリフィックス（❯） | 青 |
| 質問文 | デフォルト |
| 答え | 緑 |
| カーソル | 黄 |
| エラー | 赤 |

これらはXjPromptStyle経由でカスタマイズ可能です。
