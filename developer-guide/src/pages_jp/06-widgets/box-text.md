---
title: ボックスとテキスト
description: XjBoxはコンテナ、XjTextはテキスト表示ウィジェットです。配置、塗りつぶし、セマンティックプリセットをサポート。
---

# ボックスとテキスト（XjBox、XjText）

XjBoxはコンテナウィジェット、XjTextは静的テキスト表示ウィジェットです。レイアウト、配置、スタイリング、セマンティックプリセットを提供します。

## XjBox（ボックスコンテナ）

XjBoxは他のウィジェットを含むコンテナです。背景塗りつぶし、テキスト配置、セマンティック色をサポートしています。

### コンストラクタ

```xojo
Sub New()
```

### 配置設定

```xojo
Function SetContentAlign(align As Integer) As XjBox
Function SetContentVAlign(valign As Integer) As XjBox
```

配置定数：
- 0：左/上
- 1：中央
- 2：右/下

```xojo
Var box As New XjBox()
Call box.SetContentAlign(1)    // 水平中央
Call box.SetContentVAlign(1)   // 垂直中央
```

### 背景塗りつぶし

```xojo
Function SetFill(char As String, style As XjStyle) As XjBox
```

背景を指定文字とスタイルで塗りつぶします。

```xojo
Var box As New XjBox()
Call box.SetFill(" ", XjStyle.Success())  // 緑背景
```

### セマンティックプリセット（シェアード）

```xojo
Shared Function Info(title As String) As XjBox
Shared Function Warning(title As String) As XjBox
Shared Function Success(title As String) As XjBox
Shared Function Error_(title As String) As XjBox
```

事前設定されたボックスを生成します。

```xojo
// 青いボーダーのInfo ボックス
Var info As XjBox = XjBox.Info("Information")

// 黄のWarningボックス
Var warning As XjBox = XjBox.Warning("Alert")

// 赤のErrorボックス
Var error As XjBox = XjBox.Error_("Error")

// 緑のSuccessボックス
Var success As XjBox = XjBox.Success("Complete")
```

## XjText（テキスト表示）

XjTextは静的テキストを表示するウィジェットです。折り返し、配置、スクロールをサポートしています。

### コンストラクタ

```xojo
Sub New()
```

### テキスト設定

```xojo
Function SetText(text As String) As XjText
Function Text() As String
```

表示するテキストを設定・取得します。

```xojo
Var text As New XjText()
Call text.SetText("Hello, World!")
Var content As String = text.Text()
```

### 配置

```xojo
Function SetAlign(align As Integer) As XjText
```

配置定数：
- 0：左寄せ
- 1：中央
- 2：右寄せ

```xojo
Var text As New XjText()
Call text.SetText("Centered")
Call text.SetAlign(1)  // 中央配置
```

### 折り返し

```xojo
Function SetWrap(wrap As Boolean) As XjText
```

True に設定するとテキストが自動折り返しされます。

```xojo
Var text As New XjText()
Call text.SetText("Long text that might exceed the width...")
Call text.SetWrap(True)  // 自動折り返し有効
```

### スクロール

```xojo
Function SetScrollOffset(offset As Integer) As XjText
Function LineCount() As Integer
```

複数行テキストのスクロール位置を制御します。

```xojo
Var text As New XjText()
Call text.SetText("Line 1\nLine 2\nLine 3\nLine 4")
Call text.SetScrollOffset(1)  // 1行目からスクロール
Var lines As Integer = text.LineCount()  // 4
```

## 実装例

### ダイアログボックス

```xojo
Function CreateDialog(title As String, message As String) As XjBox
  Var dialog As New XjBox()
  Call dialog.SetBorder(0, XjANSI.FG_CYAN)
  Call dialog.SetTitle(title)
  Call dialog.SetPadding(2, 3, 2, 3)

  Var messageText As New XjText()
  Call messageText.SetText(message)
  Call messageText.SetWrap(True)
  Call messageText.SetAlign(1)

  Call dialog.AddChild(messageText)
  Return dialog
End Function

// 使用例
Var dlg As XjBox = CreateDialog("Confirm", "Do you want to continue?")
```

### レイアウト構造

```xojo
Sub BuildUI()
  // ルートボックス
  Var root As New XjBox()
  Call root.SetContentAlign(1)
  Call root.SetContentVAlign(1)

  // ヘッダーパネル（Info色）
  Var header As XjBox = XjBox.Info("Welcome")
  Call header.SetHeight(XjConstraint.Fixed(5))
  Call root.AddChild(header)

  // メッセージテキスト
  Var message As New XjText()
  Call message.SetText("This is a test application")
  Call message.SetAlign(1)
  Call root.AddChild(message)

  // 警告パネル（Warning色）
  Var warning As XjBox = XjBox.Warning("Notice")
  Call warning.SetHeight(XjConstraint.Fixed(4))
  Call root.AddChild(warning)
End Sub
```

### 複数パネルレイアウト

```xojo
Function CreatePanelLayout() As XjBox
  // メインコンテナ
  Var main As New XjBox()
  Call main.SetDirection(XjLayoutNode.DIR_COLUMN)

  // 上部：タイトル
  Var titlePanel As New XjBox()
  Call titlePanel.SetFill(" ", XjStyle.Success())
  Call titlePanel.SetHeight(XjConstraint.Fixed(3))

  Var title As New XjText()
  Call title.SetText("Dashboard")
  Call title.SetAlign(1)
  Call titlePanel.AddChild(title)
  Call main.AddChild(titlePanel)

  // 中央：コンテンツ
  Var contentPanel As New XjBox()
  Call contentPanel.SetPadding(1, 1, 1, 1)
  Call contentPanel.SetHeight(XjConstraint.Auto())

  Var content As New XjText()
  Call content.SetText("Main content area")
  Call contentPanel.AddChild(content)
  Call main.AddChild(contentPanel)

  // 下部：ステータス
  Var statusPanel As New XjBox()
  Call statusPanel.SetFill(" ", XjStyle.Muted())
  Call statusPanel.SetHeight(XjConstraint.Fixed(2))

  Var status As New XjText()
  Call status.SetText("Ready")
  Call status.SetAlign(1)
  Call statusPanel.AddChild(status)
  Call main.AddChild(statusPanel)

  Return main
End Function
```

### テキストスクロール

```xojo
Class ScrollablePanel
  Private mText As XjText
  Private mScrollPos As Integer = 0

  Sub New(content As String)
    mText = New XjText()
    Call mText.SetText(content)
    Call mText.SetWrap(True)
  End Sub

  Sub ScrollUp()
    mScrollPos = Max(0, mScrollPos - 1)
    Call mText.SetScrollOffset(mScrollPos)
  End Sub

  Sub ScrollDown()
    Var lines As Integer = mText.LineCount()
    mScrollPos = Min(lines - 1, mScrollPos + 1)
    Call mText.SetScrollOffset(mScrollPos)
  End Sub

  Function GetWidget() As XjText
    Return mText
  End Function
End Class
```

## フルーエント設定例

```xojo
// ボックス設定をチェーン
Var box As New XjBox()
Call box.SetWidth(XjConstraint.Fixed(40))
Call box.SetHeight(XjConstraint.Fixed(15))
Call box.SetPadding(1, 2, 1, 2)
Call box.SetBorder(0, XjANSI.FG_BLUE)

// テキスト設定をチェーン
Var text As New XjText()
Call text.SetText("Styled text")
Call text.SetAlign(1)
Call text.SetWrap(True)
```
