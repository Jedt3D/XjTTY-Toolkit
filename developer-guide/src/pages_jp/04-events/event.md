---
title: イベントシステム
description: XjEventクラスは鑑別共用体パターンで、キー、マウス、リサイズ、カスタムイベントを統一的に処理します。
---

# イベントシステム（XjEvent）

XjEventクラスはキーボード入力、マウス操作、ターミナルリサイズなど、異なる種類のイベントを統一的に表現する鑑別共用体パターンの実装です。

## イベントタイプ定数

```xojo
Const EVENT_KEY = 1
Const EVENT_MOUSE = 2
Const EVENT_RESIZE = 3
Const EVENT_TICK = 4
Const EVENT_CUSTOM = 5
```

## マウスイベントタイプ

```xojo
Const MOUSE_PRESS = 0
Const MOUSE_RELEASE = 1
Const MOUSE_MOTION = 2
Const MOUSE_SCROLL_UP = 3
Const MOUSE_SCROLL_DOWN = 4
```

## ファクトリーメソッド（イベント生成）

```xojo
Shared Function CreateKeyEvent(key As XjKeyEvent) As XjEvent

Shared Function CreateMouseEvent(button As Integer, x As Integer, y As Integer,
                                  ctrl As Boolean, alt As Boolean, shift As Boolean) As XjEvent

Shared Function CreateResizeEvent(width As Integer, height As Integer) As XjEvent

Shared Function CreateTickEvent(tickCount As Integer) As XjEvent

Shared Function CreateCustomEvent(customData As Variant) As XjEvent
```

## イベント判定メソッド

```xojo
Function IsKeyEvent() As Boolean
Function IsMouseEvent() As Boolean
Function IsResizeEvent() As Boolean
Function IsTickEvent() As Boolean
Function IsCustomEvent() As Boolean
Function EventType() As Integer
```

## イベント取得メソッド

```xojo
Function Key() As XjKeyEvent                    // キーイベントの取得

Function MouseButton() As Integer               // マウスボタンの種類
Function MouseX() As Integer                    // マウス X座標（0ベース）
Function MouseY() As Integer                    // マウス Y座標（0ベース）
Function MouseCtrl() As Boolean
Function MouseAlt() As Boolean
Function MouseShift() As Boolean

Function ResizeWidth() As Integer               // リサイズ後の幅
Function ResizeHeight() As Integer              // リサイズ後の高さ

Function TickCount() As Integer                 // ティック番号

Function CustomData() As Variant                // カスタムイベントのデータ
```

## イベント情報

```xojo
Function Timestamp() As Integer                 // イベント発生時刻（ミリ秒）
```

## 使用例

### キーイベント処理

```xojo
Sub HandleEvent(evt As XjEvent)
  If evt.IsKeyEvent() Then
    Var key As XjKeyEvent = evt.Key()
    If key.IsEscape() Then
      XjTerminal.Write("Escape pressed")
    ElseIf key.IsCharKey() Then
      XjTerminal.Write("Character: " + key.Char())
    End If
  End If
End Sub
```

### マウスイベント処理

```xojo
Sub HandleMouseEvent(evt As XjEvent)
  If evt.IsMouseEvent() Then
    Var button As Integer = evt.MouseButton()
    Var x As Integer = evt.MouseX()
    Var y As Integer = evt.MouseY()

    Select Case button
      Case XjEvent.MOUSE_PRESS
        XjTerminal.Write("Click at (" + x.ToString() + "," + y.ToString() + ")")
      Case XjEvent.MOUSE_SCROLL_UP
        XjTerminal.Write("Scroll up")
      Case XjEvent.MOUSE_SCROLL_DOWN
        XjTerminal.Write("Scroll down")
    End Select
  End If
End Sub
```

### リサイズイベント処理

```xojo
Sub HandleResizeEvent(evt As XjEvent)
  If evt.IsResizeEvent() Then
    Var newWidth As Integer = evt.ResizeWidth()
    Var newHeight As Integer = evt.ResizeHeight()

    // レイアウトを再計算
    Var canvas As New XjCanvas(newWidth, newHeight)
    // ... 描画処理
  End If
End Sub
```

### ティックイベント処理

```xojo
Sub HandleTickEvent(evt As XjEvent)
  If evt.IsTickEvent() Then
    Var tickCount As Integer = evt.TickCount()

    // アニメーション更新
    If tickCount Mod 10 = 0 Then
      // 10フレームごとにアニメーション更新
    End If
  End If
End Sub
```

### カスタムイベント処理

```xojo
Sub HandleCustomEvent(evt As XjEvent)
  If evt.IsCustomEvent() Then
    Var data As Variant = evt.CustomData()
    XjTerminal.Write("Custom event: " + data.ToString())
  End If
End Sub
```

### 統一的なイベント処理

```xojo
Sub ProcessEvent(evt As XjEvent)
  Select Case evt.EventType()
    Case XjEvent.EVENT_KEY
      HandleKeyboardInput(evt.Key())

    Case XjEvent.EVENT_MOUSE
      HandleMouseClick(evt.MouseButton(), evt.MouseX(), evt.MouseY())

    Case XjEvent.EVENT_RESIZE
      HandleTerminalResize(evt.ResizeWidth(), evt.ResizeHeight())

    Case XjEvent.EVENT_TICK
      HandleTimerTick(evt.TickCount())

    Case XjEvent.EVENT_CUSTOM
      HandleCustomEvent(evt.CustomData())
  End Select
End Sub
```

### イベントディスパッチャー

```xojo
Class EventDispatcher
  Private mHandlers As New Dictionary()

  Sub On(eventType As Integer, handler As Delegate)
    Var key As String = eventType.ToString()
    mHandlers.Value(key) = handler
  End Sub

  Sub Dispatch(evt As XjEvent)
    Var key As String = evt.EventType().ToString()
    Var handler As Delegate = mHandlers.Lookup(key, Nil)
    If handler <> Nil Then
      handler.Invoke(evt)
    End If
  End Sub
End Class

// 使用例
Var dispatcher As New EventDispatcher()
dispatcher.On(XjEvent.EVENT_KEY, AddressOf HandleKeyEvent)
dispatcher.On(XjEvent.EVENT_RESIZE, AddressOf HandleResizeEvent)
dispatcher.Dispatch(evt)
```
