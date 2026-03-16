---
title: 特殊プロンプト
description: XjConfirmPrompt、XjSliderPrompt、XjKeyPressPrompt、XjCollectPromptの実装。
---

# 特殊プロンプト（確認、スライダー、キー、複合）

特殊な対話パターンを実装するプロンプト。

## XjConfirmPrompt（Yes/No確認）

シンプルなYes/No質問。

```xojo
Var prompt As New XjConfirmPrompt()
Call prompt.SetQuestion("Continue?")
Call prompt.SetDefaultYes(True)  // デフォルト:Yes

If prompt.Show() Then
  // ユーザーがYes
Else
  // ユーザーがNo
End If
```

表示例: `? Continue? (Y/n)`

## XjSliderPrompt（数値スライダー）

矢印キーで数値を選択。

```xojo
Var prompt As New XjSliderPrompt()
Call prompt.SetQuestion("Select level: ")
Call prompt.SetMin(1)
Call prompt.SetMax(10)
Call prompt.SetDefault(5)
Call prompt.SetStep(1)

Var level As Integer = prompt.Show()
```

キーバインディング：
- 左右矢印 — 値増減
- Home/End — 最小・最大
- Enter — 確定
- Escape — キャンセル

## XjKeyPressPrompt（キー入力待機）

任意のキープレスを待ちます。

```xojo
Var prompt As New XjKeyPressPrompt()
Call prompt.SetMessage("Press any key to continue...")

Var key As XjKeyEvent = prompt.Show()
XjPrompt.Say("You pressed: " + key.KeyName())
```

## XjCollectPrompt（複合質問）

複数の質問をまとめて処理。

```xojo
Var questions As New Dictionary()
questions.Value("name") = "name"     // キーと質問文
questions.Value("email") = "email"
questions.Value("age") = "age"

Var prompt As New XjCollectPrompt()
Call prompt.SetQuestions(questions)

Var answers As Dictionary = prompt.Show()
Var name As String = answers.Lookup("name", "")
Var email As String = answers.Lookup("email", "")
Var age As String = answers.Lookup("age", "")
```

## 実装例

### ファイル削除確認

```xojo
Sub DeleteFile(filename As String)
  Var prompt As New XjConfirmPrompt()
  Call prompt.SetQuestion("Delete '" + filename + "'?")
  Call prompt.SetDefaultYes(False)  // デフォルト:No（安全）

  If prompt.Show() Then
    File.Delete(filename)
    XjPrompt.Ok("File deleted")
  Else
    XjPrompt.Say("Cancelled")
  End If
End Sub
```

### 難易度選択

```xojo
Sub SelectDifficulty()
  Var prompt As New XjSliderPrompt()
  Call prompt.SetQuestion("Game difficulty: ")
  Call prompt.SetMin(1)     // Easy
  Call prompt.SetMax(5)     // Extreme
  Call prompt.SetDefault(3) // Normal
  Call prompt.SetStep(1)

  Var difficulty As Integer = prompt.Show()
  Var levels() As String = Array("Easy", "Normal", "Hard", "Extreme", "Nightmare")
  XjPrompt.Ok("Selected: " + levels(difficulty - 1))
End Sub
```

### 登録フォーム

```xojo
Sub UserRegistration()
  Var questions As New Dictionary()
  questions.Value("username") = "Username: "
  questions.Value("email") = "Email: "
  questions.Value("password") = "Password: "
  questions.Value("age") = "Age: "

  Var prompt As New XjCollectPrompt()
  Call prompt.SetQuestions(questions)

  Var answers As Dictionary = prompt.Show()

  // 検証と保存
  If ValidateAnswers(answers) Then
    RegisterUser(answers)
    XjPrompt.Ok("Registration successful")
  Else
    XjPrompt.Error_("Invalid input")
  End If
End Sub
```

### インタラクティブメニュー

```xojo
Sub InteractiveMenu()
  While True
    XjPrompt.Say("")

    Var choices As New Dictionary()
    choices.Value("v") = "View Profile"
    choices.Value("e") = "Edit Settings"
    choices.Value("q") = "Quit"

    Var prompt As New XjExpandPrompt()
    Call prompt.SetQuestion("Select action: ")
    Call prompt.SetChoices(choices)

    Var action As String = prompt.Show()

    Select Case action
      Case "View Profile"
        ShowProfile()
      Case "Edit Settings"
        EditSettings()
      Case "Quit"
        XjPrompt.Ok("Goodbye!")
        Exit
    End Select
  Wend
End Sub
```

### ゲーム続行確認

```xojo
Sub GameOver(score As Integer)
  XjPrompt.Say("Game Over!")
  XjPrompt.Say("Final Score: " + score.ToString())

  Var prompt As New XjKeyPressPrompt()
  Call prompt.SetMessage("Press any key to return to menu...")

  Call prompt.Show()  // キー入力を待つ
End Sub
```

### オンボーディングフロー

```xojo
Sub OnboardingFlow()
  XjPrompt.Say("Welcome!")

  // ステップ1：姓名
  Var name As String = XjPrompt.Ask("What is your name?")

  // ステップ2：好み確認
  Var darkMode As Boolean = XjPrompt.Confirm("Enable dark mode?")

  // ステップ3：言語選択
  Var language As String = XjPrompt.Select_("Preferred language: ",
    Array("English", "Japanese", "French", "German"))

  // ステップ4：確認
  If XjPrompt.Confirm("Confirm settings?") Then
    SaveUserPreferences(name, darkMode, language)
    XjPrompt.Ok("Setup complete!")
  Else
    XjPrompt.Say("Setup cancelled")
  End If
End Sub
```

### スライダー応用（音量調整）

```xojo
Sub AdjustVolume(currentVolume As Integer)
  Var prompt As New XjSliderPrompt()
  Call prompt.SetQuestion("Volume level: ")
  Call prompt.SetMin(0)
  Call prompt.SetMax(100)
  Call prompt.SetDefault(currentVolume)
  Call prompt.SetStep(5)

  Var newVolume As Integer = prompt.Show()
  SetVolume(newVolume)
  XjPrompt.Ok("Volume set to " + newVolume.ToString() + "%")
End Sub
```

## キーバインディング一覧

| プロンプト | キー | 機能 |
|----------|------|------|
| Confirm | Y/N | Yes/No |
| Slider | ← → | 値変更 |
| Slider | Home/End | 最小・最大 |
| KeyPress | 任意 | キー記録 |
| Collect | Tab | 次の質問 |
| Collect | Shift+Tab | 前の質問 |

## メッセージ表示

```xojo
// スライダー表示例
? Select level:
  [●●●━━━━━━] 30%

// キープレス表示例
  Press any key to continue...

// Confirm表示例
? Continue? (Y/n)
```
