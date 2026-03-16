---
title: スタイリングとバリデーション
description: XjPromptStyle、XjValidation、XjConversionでプロンプトをカスタマイズ。
---

# スタイリングとバリデーション（XjPromptStyle、XjValidation、XjConversion）

プロンプトの外観と入力検証をカスタマイズ。

## XjPromptStyle（スタイル）

プロンプト全体のテーマを定義。

```xojo
Var style As New XjPromptStyle()
Call style.SetPrefixStyle(XjStyle.Success())       // プリフィックス（❯）
Call style.SetQuestionStyle(XjStyle.Default())     // 質問文
Call style.SetAnswerStyle(XjStyle.Success())       // 答え
Call style.SetCursorStyle(XjStyle.Warning())       // カーソル
Call style.SetErrorStyle(XjStyle.Danger())         // エラー

XjPrompt.SetStyle(style)
```

## XjValidation（バリデーション）

入力検証ルール。

```xojo
Var validator As New XjValidation()
Call validator.AddRule(XjValidation.REQUIRED)
Call validator.AddRule(XjValidation.MIN_LENGTH, 3)
Call validator.AddRule(XjValidation.MAX_LENGTH, 20)
Call validator.AddRule(XjValidation.PATTERN, "^[a-z0-9]+$")

Var prompt As New XjAskPrompt()
Call prompt.SetValidator(validator)
```

### バリデーションルール

```xojo
Const REQUIRED = "required"                    // 必須
Const MIN_LENGTH = "minLength"
Const MAX_LENGTH = "maxLength"
Const PATTERN = "pattern"                      // 正規表現
Const CUSTOM = "custom"                        // カスタム関数
Const EMAIL = "email"
Const URL = "url"
Const NUMERIC = "numeric"
```

## XjConversion（変換）

入力値の自動変換。

```xojo
Var converter As New XjConversion()
converter.Uppercase()   // 大文字に変換
converter.Lowercase()   // 小文字に変換
converter.Trim()        // 空白削除
converter.ToCamelCase() // キャメルケース
```

## 実装例

### メールアドレス入力

```xojo
Sub GetEmail() As String
  Var validator As New XjValidation()
  Call validator.AddRule(XjValidation.EMAIL)

  Var prompt As New XjAskPrompt()
  Call prompt.SetQuestion("Email: ")
  Call prompt.SetValidator(validator)

  Return prompt.Show()
End Sub
```

### ユーザー名検証

```xojo
Sub GetUsername() As String
  Var validator As New XjValidation()
  Call validator.AddRule(XjValidation.MIN_LENGTH, 3)
  Call validator.AddRule(XjValidation.MAX_LENGTH, 16)
  Call validator.AddRule(XjValidation.PATTERN, "^[a-zA-Z0-9_]+$")

  Var prompt As New XjAskPrompt()
  Call prompt.SetQuestion("Username: ")
  Call prompt.SetValidator(validator)

  Return prompt.Show()
End Sub
```

### カスタムバリデーション

```xojo
Function ValidateCustom(value As String) As Boolean
  Return value.Length >= 5 And value.Contains("@")
End Function

Var validator As New XjValidation()
Call validator.AddRule(XjValidation.CUSTOM, AddressOf ValidateCustom)
```

### 数値入力

```xojo
Sub GetAge() As Integer
  Var validator As New XjValidation()
  Call validator.AddRule(XjValidation.NUMERIC)
  Call validator.AddRule(XjValidation.MIN_LENGTH, 1)
  Call validator.AddRule(XjValidation.MAX_LENGTH, 3)

  Var prompt As New XjAskPrompt()
  Call prompt.SetQuestion("Age: ")
  Call prompt.SetValidator(validator)

  Var ageStr As String = prompt.Show()
  Return Integer.FromString(ageStr)
End Sub
```

### テーマ設定

```xojo
Sub SetCustomTheme()
  Var style As New XjPromptStyle()

  // ダークモーム
  Call style.SetPrefixStyle(XjStyle.Default())
  Call style.SetQuestionStyle(XjStyle.Muted())
  Call style.SetAnswerStyle(XjStyle.Success())
  Call style.SetCursorStyle(XjStyle.Success())
  Call style.SetErrorStyle(XjStyle.Danger())

  XjPrompt.SetStyle(style)
End Sub
```

### 複合検証

```xojo
Sub RegisterUser()
  // ユーザー名
  Var userValidator As New XjValidation()
  Call userValidator.AddRule(XjValidation.MIN_LENGTH, 3)
  Call userValidator.AddRule(XjValidation.PATTERN, "^[a-z0-9_]+$")

  Var userPrompt As New XjAskPrompt()
  Call userPrompt.SetQuestion("Username: ")
  Call userPrompt.SetValidator(userValidator)
  Var username As String = userPrompt.Show()

  // メール
  Var emailValidator As New XjValidation()
  Call emailValidator.AddRule(XjValidation.EMAIL)

  Var emailPrompt As New XjAskPrompt()
  Call emailPrompt.SetQuestion("Email: ")
  Call emailPrompt.SetValidator(emailValidator)
  Var email As String = emailPrompt.Show()

  // パスワード
  Var pwdValidator As New XjValidation()
  Call pwdValidator.AddRule(XjValidation.MIN_LENGTH, 8)

  Var pwdPrompt As New XjPasswordPrompt()
  Call pwdPrompt.SetQuestion("Password: ")
  Call pwdPrompt.SetValidator(pwdValidator)
  Var password As String = pwdPrompt.Show()

  // 登録
  SaveUser(username, email, password)
  XjPrompt.Ok("User registered!")
End Sub
```

### 入力変換の例

```xojo
Sub GetProjectName() As String
  Var converter As New XjConversion()
  Call converter.Trim()          // 空白削除
  Call converter.ToCamelCase()   // キャメルケース

  Var prompt As New XjAskPrompt()
  Call prompt.SetQuestion("Project name: ")
  Call prompt.SetConverter(converter)

  Return prompt.Show()  // "my project" → "MyProject"
End Sub
```

## バリデーションエラーメッセージ

```xojo
Var validator As New XjValidation()
Call validator.AddRule(XjValidation.REQUIRED)
Call validator.SetErrorMessage(XjValidation.REQUIRED, "This field is required")
Call validator.SetErrorMessage(XjValidation.MIN_LENGTH, "Minimum 3 characters")
```

## プリセットバリデーション

```xojo
// パスワード
Function PasswordValidator() As XjValidation
  Var v As New XjValidation()
  Call v.AddRule(XjValidation.MIN_LENGTH, 8)
  Call v.AddRule(XjValidation.PATTERN, "^(?=.*[A-Z])(?=.*[0-9])")
  Return v
End Function

// URL
Function URLValidator() As XjValidation
  Var v As New XjValidation()
  Call v.AddRule(XjValidation.URL)
  Return v
End Function

// 電話番号
Function PhoneValidator() As XjValidation
  Var v As New XjValidation()
  Call v.AddRule(XjValidation.PATTERN, "^[0-9\-()+ ]+$")
  Return v
End Function
```
