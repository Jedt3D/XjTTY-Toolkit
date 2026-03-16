---
title: テキストプロンプト
description: XjAskPrompt、XjPasswordPrompt、XjMultiLinePrompt、XjSuggestPromptの実装詳細。
---

# テキストプロンプト（XjAskPrompt、XjPasswordPrompt、XjMultiLinePrompt、XjSuggestPrompt）

テキスト入力に関連するプロンプトクラスの詳細な実装。

## XjAskPrompt（自由入力）

ユーザーが自由にテキストを入力します。バリデーション機能あり。

```xojo
Var prompt As New XjAskPrompt()
Call prompt.SetQuestion("Enter your name: ")
Call prompt.SetPlaceholder("John Doe")
Call prompt.SetMaxLength(50)

Var answer As String = prompt.Show()
```

### バリデーション付き

```xojo
Var validator As New XjValidation()
Call validator.AddRule(XjValidation.REQUIRED)
Call validator.AddRule(XjValidation.MIN_LENGTH, 3)

Var prompt As New XjAskPrompt()
Call prompt.SetQuestion("Username: ")
Call prompt.SetValidator(validator)

Var username As String = prompt.Show()
```

## XjPasswordPrompt（パスワード入力）

入力文字をマスクして表示します。

```xojo
Var prompt As New XjPasswordPrompt()
Call prompt.SetQuestion("Password: ")
Call prompt.SetMaskChar("•")

Var password As String = prompt.Show()
```

### 確認付きパスワード

```xojo
Var pwd1 As String = XjPrompt.Password("Enter password: ")
Var pwd2 As String = XjPrompt.Password("Confirm password: ")

If pwd1 <> pwd2 Then
  XjPrompt.Error_("Passwords do not match")
End If
```

## XjMultiLinePrompt（複数行入力）

複数行のテキストを入力できます。

```xojo
Var prompt As New XjMultiLinePrompt()
Call prompt.SetQuestion("Enter description (Ctrl+D to finish): ")
Call prompt.SetMaxLines(10)

Var text As String = prompt.Show()
```

キーバインディング：
- Ctrl+D — 入力完了
- Ctrl+C — キャンセル
- 矢印キー — カーソル移動
- Backspace — 削除

## XjSuggestPrompt（オートコンプリート）

入力中に候補を表示します。プレフィックスマッチングをサポート。

```xojo
Var suggestions() As String = Array(
  "Apple", "Application", "Apply", "Append",
  "Banana", "Base", "Basic"
)

Var prompt As New XjSuggestPrompt()
Call prompt.SetQuestion("Command: ")
Call prompt.SetSuggestions(suggestions)

Var result As String = prompt.Show()
```

### マッチング戦略

- プレフィックスマッチ：「ap」→「Apple」「Application」「Apply」
- サブストリングマッチ：「ana」→「Banana」

## 実装例

### メールアドレス入力

```xojo
Function GetEmail() As String
  Var validator As New XjValidation()
  Call validator.AddRule(XjValidation.PATTERN, ".+@.+\..+")

  Var prompt As New XjAskPrompt()
  Call prompt.SetQuestion("Email: ")
  Call prompt.SetValidator(validator)

  Return prompt.Show()
End Function
```

### マルチラインエディタ

```xojo
Sub EditDescription()
  Var prompt As New XjMultiLinePrompt()
  Call prompt.SetQuestion("Enter description (Ctrl+D to save): ")
  Call prompt.SetMaxLines(20)

  Var description As String = prompt.Show()
  If description.Length > 0 Then
    SaveDescription(description)
  End If
End Sub
```

### ファイルパス入力

```xojo
Function SelectFilePath() As String
  Var suggestions() As String = GetAvailableFiles()

  Var prompt As New XjSuggestPrompt()
  Call prompt.SetQuestion("File path: ")
  Call prompt.SetSuggestions(suggestions)

  Return prompt.Show()
End Function
```

### セッション管理

```xojo
Sub LoginFlow()
  // ユーザー名
  Var userValidator As New XjValidation()
  Call userValidator.AddRule(XjValidation.MIN_LENGTH, 3)

  Var userPrompt As New XjAskPrompt()
  Call userPrompt.SetQuestion("Username: ")
  Call userPrompt.SetValidator(userValidator)
  Var username As String = userPrompt.Show()

  // パスワード
  Var pwdPrompt As New XjPasswordPrompt()
  Call pwdPrompt.SetQuestion("Password: ")
  Var password As String = pwdPrompt.Show()

  // 認証
  If Authenticate(username, password) Then
    XjPrompt.Ok("Login successful")
  Else
    XjPrompt.Error_("Login failed")
  End If
End Sub
```

## キーボードショートカット

すべてのテキストプロンプトは以下をサポート：

| キー | 機能 |
|------|------|
| Ctrl+A | 行頭 |
| Ctrl+E | 行末 |
| Ctrl+K | 行末まで削除 |
| Ctrl+U | 行頭から削除 |
| Ctrl+C | キャンセル |
| Enter | 確定 |
| Backspace | 左の文字削除 |
| Delete | 右の文字削除 |
