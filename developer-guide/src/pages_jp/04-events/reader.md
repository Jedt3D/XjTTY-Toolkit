---
title: 入力リーダー
description: XjReaderクラスはVT100/xtermエスケープシーケンスをパースし、キーボード入力をリアルタイム処理します。
---

# 入力リーダー（XjReader）

XjReaderクラスはターミナルからキーボード入力を読み込み、VT100およびxtermのエスケープシーケンスをパースしてXjKeyEventに変換します。UTF-8マルチバイト文字もサポートしています。

## コンストラクタ

```xojo
Sub New()
```

## キーボード入力読み込み

```xojo
Function ReadKey() As XjKeyEvent
```

ターミナルからキーを読み込み、対応するXjKeyEventを返します。この関数は非ブロッキング入力で動作するため、キーが押されていない場合は`KEY_CHAR`を文字「」で返します。

```xojo
Var reader As New XjReader()
Var key As XjKeyEvent = reader.ReadKey()

If key.KeyCode() = XjKeyEvent.KEY_ESCAPE Then
  XjTerminal.Write("Escape pressed")
End If
```

## テキスト行の読み込み

```xojo
Function ReadLine(prompt As String) As String
```

プロンプトを表示して、ユーザーが入力した行を返します。Backspace、Enter、Ctrl+Uなどの標準的な行編集キーをサポートしています。

```xojo
Var reader As New XjReader()
Var line As String = reader.ReadLine("Enter your name: ")
```

## エスケープシーケンスのサポート

XjReaderは以下のエスケープシーケンスをパースしています：

### 矢印キー
- `ESC[A` — 上矢印
- `ESC[B` — 下矢印
- `ESC[C` — 右矢印
- `ESC[D` — 左矢印

### ナビゲーションキー
- `ESC[H` または `ESC[1~` — Home
- `ESC[F` または `ESC[4~` — End
- `ESC[5~` — Page Up
- `ESC[6~` — Page Down
- `ESC[3~` — Delete

### ファンクションキー
- `ESC[11~` から `ESC[24~` — F1 から F12

### 修飾キー
- Ctrl+文字 — Ctrl修飾付き
- Alt+ESC — Alt修飾付き
- Shift+矢印 — Shift修飾付き

## 実装例

### キーボード入力ハンドラー

```xojo
Sub ProcessKeyboardInput()
  Var reader As New XjReader()

  While True
    Var key As XjKeyEvent = reader.ReadKey()

    If key.IsEscape() Then
      Exit
    ElseIf key.IsArrowUp() Then
      XjTerminal.Write("Up pressed")
    ElseIf key.IsCharKey() Then
      XjTerminal.Write("Character: " + key.Char())
    End If
  Wend
End Sub
```

### インタラクティブなメニュー

```xojo
Class Menu
  Private mReader As New XjReader()
  Private mOptions() As String
  Private mSelectedIndex As Integer = 0

  Sub New(options() As String)
    mOptions = options
  End Sub

  Function Run() As String
    Var reader As New XjReader()

    While True
      DrawMenu()
      Var key As XjKeyEvent = reader.ReadKey()

      If key.IsArrowUp() Then
        mSelectedIndex = Max(0, mSelectedIndex - 1)
      ElseIf key.IsArrowDown() Then
        mSelectedIndex = Min(mOptions.Count - 1, mSelectedIndex + 1)
      ElseIf key.IsEnter() Then
        Return mOptions(mSelectedIndex)
      ElseIf key.IsEscape() Then
        Return ""
      End If
    Wend
  End Function

  Sub DrawMenu()
    XjScreen.Clear()
    For i As Integer = 0 To mOptions.Count - 1
      Var line As String
      If i = mSelectedIndex Then
        line = "> " + mOptions(i)
      Else
        line = "  " + mOptions(i)
      End If
      XjScreen.WriteAt(i + 1, 1, line)
    Wend
  End Sub
End Class
```

### パスワード入力

```xojo
Function GetPassword(prompt As String) As String
  Var reader As New XjReader()
  Var password As String = ""

  XjTerminal.Write(prompt)

  While True
    Var key As XjKeyEvent = reader.ReadKey()

    If key.IsEnter() Then
      XjTerminal.Write(Xojo.Core.NewLine)
      Return password
    ElseIf key.IsBackspace() Then
      If password.Length > 0 Then
        password = password.Left(password.Length - 1)
        XjTerminal.Write(XjANSI.CursorBackward(1) + " " + XjANSI.CursorBackward(1))
      End If
    ElseIf key.IsEscape() Then
      Return ""
    ElseIf key.IsCharKey() Then
      password = password + key.Char()
      XjTerminal.Write("*")
    End If
  Wend
End Function
```

### UTF-8マルチバイト文字のサポート

XjReaderは自動的にUTF-8を処理します：

```xojo
Var reader As New XjReader()
Var key As XjKeyEvent = reader.ReadKey()

// 日本語や絵文字を含む
If key.IsCharKey() Then
  Var char As String = key.Char()  // "あ", "😀" など
  mInputBuffer = mInputBuffer + char
End If
```

### VT100互換性

XjReaderはVT100およびxtermエスケープシーケンスに対応しており、ほぼすべてのターミナルエミュレーターで動作します。

```xojo
// TERM環境変数がxterm、linux、screen などでも動作
Var reader As New XjReader()
```

## XjEventLoopとの関係

XjEventLoopは内部的にXjReaderを使用してキーボード入力をポーリングします。通常、開発者はXjEventLoopのコールバックを使用し、直接XjReaderを操作することはありません。

```xojo
// 低レベル：XjReaderを直接使用
Var reader As New XjReader()
Var key As XjKeyEvent = reader.ReadKey()

// 高レベル：XjEventLoopを使用
Var loop As New XjEventLoop()
loop.OnKeyPress = Function(key) As Boolean
  // キー処理
  Return True
End Function
loop.Run()
```
