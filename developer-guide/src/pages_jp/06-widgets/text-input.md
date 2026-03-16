---
title: テキスト入力
description: XjTextInputはシングルライン入力フィールドで、カーソル、プレースホルダー、マスク、ラベルをサポート。
---

# テキスト入力（XjTextInput）

XjTextInputはシングルラインのテキスト入力ウィジェットで、ユーザーが文字を入力できます。プレースホルダー、パスワードマスク、ラベル、最大長制限、標準的なキーボードショートカット（Ctrl+A/E/K/U）をサポートしています。

## コンストラクタ

```xojo
Sub New()
```

## 値の管理

```xojo
Function SetValue(value As String) As XjTextInput
Function Value() As String
```

入力フィールドの値を設定・取得します。

```xojo
Var input As New XjTextInput()
Call input.SetValue("Default text")
Var text As String = input.Value()
```

## プレースホルダー

```xojo
Function SetPlaceholder(placeholder As String) As XjTextInput
```

値が空のときに表示されるテキスト（グレイ表示）。

```xojo
Var input As New XjTextInput()
Call input.SetPlaceholder("Enter your name...")
```

## パスワードマスク

```xojo
Function SetMask(maskChar As String) As XjTextInput
```

パスワード入力など、文字を隠す場合に使用します。

```xojo
Var passwordInput As New XjTextInput()
Call passwordInput.SetMask("•")  // 入力文字が•で表示
```

## 最大長制限

```xojo
Function SetMaxLength(maxLength As Integer) As XjTextInput
```

入力できる最大文字数を制限します。

```xojo
Var zipCode As New XjTextInput()
Call zipCode.SetMaxLength(5)
```

## ラベル

```xojo
Function SetLabel(label As String, style As XjStyle) As XjTextInput
```

入力フィールドの前にラベルを表示します。

```xojo
Var input As New XjTextInput()
Call input.SetLabel("Username: ", XjStyle.Success())
```

## キーボードショートカット

XjTextInputは以下のショートカットをサポートしています：

| キー | 機能 |
|------|------|
| Ctrl+A | 行頭に移動 |
| Ctrl+E | 行末に移動 |
| Ctrl+K | カーソル以降を削除 |
| Ctrl+U | 行頭から削除 |
| Ctrl+W | 前の単語を削除 |
| Backspace | 左の文字を削除 |
| Delete | 右の文字を削除 |
| 矢印キー | カーソル移動 |

## 実装例

### シンプルなフォーム

```xojo
Sub BuildForm()
  Var form As New XjBox()
  Call form.SetDirection(XjLayoutNode.DIR_COLUMN)
  Call form.SetPadding(2, 2, 2, 2)

  // 名前フィールド
  Var nameLabel As New XjText()
  Call nameLabel.SetText("Name:")
  Call form.AddChild(nameLabel)

  Var nameInput As New XjTextInput()
  Call nameInput.SetPlaceholder("John Doe")
  Call form.AddChild(nameInput)

  // メールフィールド
  Var emailLabel As New XjText()
  Call emailLabel.SetText("Email:")
  Call form.AddChild(emailLabel)

  Var emailInput As New XjTextInput()
  Call emailInput.SetPlaceholder("user@example.com")
  Call form.AddChild(emailInput)

  // パスワードフィールド
  Var passLabel As New XjText()
  Call passLabel.SetText("Password:")
  Call form.AddChild(passLabel)

  Var passInput As New XjTextInput()
  Call passInput.SetMask("•")
  Call form.AddChild(passInput)
End Sub
```

### ユーザーネーム入力

```xojo
Class UsernameField
  Private mInput As XjTextInput

  Sub New()
    mInput = New XjTextInput()
    Call mInput.SetLabel("Username: ", XjStyle.Info())
    Call mInput.SetPlaceholder("alphanumeric only")
    Call mInput.SetMaxLength(20)
  End Sub

  Function Validate() As Boolean
    Var value As String = mInput.Value()
    If value.Length = 0 Then
      Return False
    End If
    // 英数字のみをチェック
    For i As Integer = 0 To value.Length - 1
      Var ch As String = value.Middle(i, 1)
      If Not (ch >= "a" And ch <= "z" Or ch >= "A" And ch <= "Z" Or ch >= "0" And ch <= "9") Then
        Return False
      End If
    Wend
    Return True
  End Function

  Function GetWidget() As XjTextInput
    Return mInput
  End Function
End Class
```

### パスワード確認

```xojo
Sub PasswordConfirmationFlow()
  Var loop As New XjEventLoop()

  Var passwordInput As New XjTextInput()
  Call passwordInput.SetMask("•")
  Call passwordInput.SetLabel("Password: ", XjStyle.Warning())

  Var confirmInput As New XjTextInput()
  Call confirmInput.SetMask("•")
  Call confirmInput.SetLabel("Confirm:  ", XjStyle.Warning())

  Var messageText As New XjText()
  Call messageText.SetText("")

  loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
    If key.IsTab() Then
      // 次のフィールドに移動
      Return True
    ElseIf key.IsEnter() Then
      If passwordInput.Value() = confirmInput.Value() Then
        Call messageText.SetText("Password confirmed!")
      Else
        Call messageText.SetText("Passwords do not match!")
      End If
      Return True
    ElseIf key.IsEscape() Then
      loop.Stop_()
      Return True
    End If
    Return False
  End Function

  loop.Run()
End Sub
```

### 数値入力フィールド

```xojo
Class NumericInput
  Private mInput As XjTextInput

  Sub New(maxValue As Integer)
    mInput = New XjTextInput()
    Call mInput.SetLabel("Number: ", XjStyle.Default())
    Call mInput.SetMaxLength(maxValue.ToString().Length)
  End Sub

  Function GetValue() As Integer
    Var text As String = mInput.Value()
    If text.Length = 0 Then
      Return 0
    End If
    Try
      Return Integer.FromString(text)
    Catch err As RuntimeException
      Return 0
    End Try
  End Function

  Function GetWidget() As XjTextInput
    Return mInput
  End Function
End Class
```

### 検索フィールド

```xojo
Class SearchField
  Private mInput As XjTextInput
  Private mResults() As String

  Sub New()
    mInput = New XjTextInput()
    Call mInput.SetLabel("Search: ", XjStyle.Info())
    Call mInput.SetPlaceholder("Type to search...")
  End Sub

  Sub OnInput(searchCallback As Delegate)
    // 入力変更時にコールバック実行
  End Sub

  Function GetWidget() As XjTextInput
    Return mInput
  End Function

  Sub SetResults(results() As String)
    mResults = results
  End Sub
End Class
```

## フルーエント設定例

```xojo
Var input As New XjTextInput()
Call input.SetWidth(XjConstraint.Fixed(30))
Call input.SetValue("")
Call input.SetPlaceholder("Enter text...")
Call input.SetLabel("Input: ", XjStyle.Default())
Call input.SetMaxLength(50)
```

## イベント処理

XjTextInputのHandleKey()をオーバーライドして、カスタムキーハンドリングを実装できます。

```xojo
Class ValidatedInput
  Extends XjTextInput

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsCharKey() Then
      Var char As String = key.Char()
      // カスタム検証
      If IsValidCharacter(char) Then
        Return Call MyBase.HandleKey(key)
      Else
        Return True  // 入力を拒否
      End If
    End If
    Return Call MyBase.HandleKey(key)
  End Function

  Private Function IsValidCharacter(char As String) As Boolean
    // 実装...
    Return True
  End Function
End Class
```
