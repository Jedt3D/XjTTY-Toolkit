---
title: キーイベント
description: XjKeyEventクラスはキーボード入力（キーコード、文字、修飾キー）を表します。31種類のキーコードをサポート。
---

# キーイベント（XjKeyEvent）

XjKeyEventクラスはキーボード入力を表現し、押されたキー、文字、修飾キー（Ctrl、Alt、Shift）情報を含みます。

## キーコード定数

```xojo
Const KEY_CHAR = 0              // 通常文字キー
Const KEY_ENTER = 1             // Enter
Const KEY_ESCAPE = 2            // Esc
Const KEY_TAB = 3               // Tab
Const KEY_BACKSPACE = 4         // Backspace
Const KEY_HOME = 5              // Home
Const KEY_END = 6               // End
Const KEY_DELETE = 7            // Delete
Const KEY_ARROW_UP = 8          // 上矢印
Const KEY_ARROW_DOWN = 9        // 下矢印
Const KEY_ARROW_LEFT = 10       // 左矢印
Const KEY_ARROW_RIGHT = 11      // 右矢印
Const KEY_PAGE_UP = 12          // Page Up
Const KEY_PAGE_DOWN = 13        // Page Down
Const KEY_CTRL_A = 14           // Ctrl+A
Const KEY_CTRL_C = 15           // Ctrl+C
Const KEY_CTRL_D = 16           // Ctrl+D
Const KEY_CTRL_E = 17           // Ctrl+E
Const KEY_CTRL_K = 18           // Ctrl+K
Const KEY_CTRL_U = 19           // Ctrl+U
Const KEY_CTRL_W = 20           // Ctrl+W
Const KEY_CTRL_L = 21           // Ctrl+L
Const KEY_CTRL_N = 22           // Ctrl+Next
Const KEY_CTRL_P = 23           // Ctrl+Previous
Const KEY_CTRL_H = 24           // Ctrl+Help/History
Const KEY_F1 = 25
Const KEY_F2 = 26
Const KEY_F3 = 27
Const KEY_F4 = 28
Const KEY_F5 = 29
Const KEY_F6 = 30
Const KEY_F12 = 31
```

## コンストラクタ

```xojo
Sub New(keyCode As Integer, char As String, ctrl As Boolean,
        alt As Boolean, shift As Boolean)
```

```xojo
Var enterKey As New XjKeyEvent(XjKeyEvent.KEY_ENTER, "", False, False, False)
Var charKey As New XjKeyEvent(XjKeyEvent.KEY_CHAR, "A", True, False, False)  // Ctrl+A
```

## 取得メソッド

```xojo
Function KeyCode() As Integer
Function Char() As String
Function IsCtrl() As Boolean
Function IsAlt() As Boolean
Function IsShift() As Boolean
```

## キー判定メソッド

```xojo
Function IsCharKey() As Boolean     // 通常文字キー
Function IsEnter() As Boolean
Function IsEscape() As Boolean
Function IsTab() As Boolean
Function IsBackspace() As Boolean
Function IsArrow() As Boolean       // いずれかの矢印キー
Function IsArrowUp() As Boolean
Function IsArrowDown() As Boolean
Function IsArrowLeft() As Boolean
Function IsArrowRight() As Boolean
Function IsPageUp() As Boolean
Function IsPageDown() As Boolean
Function IsHome() As Boolean
Function IsEnd() As Boolean
Function IsDelete() As Boolean
Function IsCtrlSequence() As Boolean // Ctrl+文字キー
```

```xojo
Var key As XjKeyEvent = GetKeyEvent()

If key.IsArrowUp() Then
  // 上矢印キー
ElseIf key.IsEnter() Then
  // Enter キー
ElseIf key.IsCharKey() Then
  Var char As String = key.Char()
End If
```

## テキスト表現

```xojo
Function KeyName() As String
Function ToString() As String
```

- `KeyName()` — キーの名前（「Enter」「Escape」「A」など）
- `ToString()` — デバッグ用の完全な表現

```xojo
Var key As New XjKeyEvent(XjKeyEvent.KEY_ARROW_UP, "", False, True, False)
XjTerminal.Write(key.KeyName())  // 出力: "Alt+Up"
```

## 使用例

### テキスト入力の処理

```xojo
Function HandleInput(key As XjKeyEvent) As Boolean
  If key.IsEscape() Then
    Return False  // 終了
  ElseIf key.IsBackspace() Then
    If mInputBuffer.Length > 0 Then
      mInputBuffer = mInputBuffer.Left(mInputBuffer.Length - 1)
    End If
  ElseIf key.IsCharKey() Then
    mInputBuffer = mInputBuffer + key.Char()
  End If
  Return True
End Function
```

### ナビゲーション

```xojo
Function HandleNavigation(key As XjKeyEvent, ByRef selectedIndex As Integer,
                          itemCount As Integer)
  If key.IsArrowUp() Then
    selectedIndex = Max(0, selectedIndex - 1)
  ElseIf key.IsArrowDown() Then
    selectedIndex = Min(itemCount - 1, selectedIndex + 1)
  ElseIf key.IsEnter() Then
    // 選択確定
  End If
End Function
```

### Ctrl+修飾キーの処理

```xojo
Sub ProcessCtrlKey(key As XjKeyEvent)
  If key.IsCtrl() Then
    Select Case key.KeyCode()
      Case XjKeyEvent.KEY_CTRL_C
        XjTerminal.Write("Interrupt signal")
      Case XjKeyEvent.KEY_CTRL_D
        XjTerminal.Write("EOF signal")
      Case XjKeyEvent.KEY_CTRL_L
        XjScreen.Clear()
    End Select
  End If
End Sub
```

### キーバインディングシステム

```xojo
Class KeyBindings
  Private mBindings As New Dictionary()

  Sub Bind(keyCode As Integer, ctrl As Boolean, alt As Boolean, shift As Boolean, handler As Delegate)
    Var key As String = GetKeyString(keyCode, ctrl, alt, shift)
    mBindings.Value(key) = handler
  End Sub

  Function Handle(key As XjKeyEvent) As Boolean
    Var keyStr As String = GetKeyString(key.KeyCode(), key.IsCtrl(), key.IsAlt(), key.IsShift())
    Var handler As Delegate = mBindings.Lookup(keyStr, Nil)
    If handler <> Nil Then
      handler.Invoke()
      Return True
    End If
    Return False
  End Function

  Private Function GetKeyString(code As Integer, ctrl As Boolean,
                                alt As Boolean, shift As Boolean) As String
    Var s As String = ""
    If ctrl Then s = s + "C+"
    If alt Then s = s + "A+"
    If shift Then s = s + "S+"
    Return s + code.ToString()
  End Function
End Class
```
