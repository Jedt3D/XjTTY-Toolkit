---
title: フォーカスマネージャー
description: XjFocusManagerはウィジェット間のキーボードフォーカス移動（Tab/Shift+Tab）を管理します。
---

# フォーカスマネージャー（XjFocusManager）

XjFocusManagerはフォーカス可能なウィジェット間でキーボードフォーカスをルーティングする機能を提供します。TabキーとShift+Tabキーでウィジェット間を移動できます。

## コンストラクタ

```xojo
Sub New()
```

## フォーカスチェーン構築

```xojo
Sub BuildChain(root As XjWidget)
```

ウィジェットツリーをトラバースして、フォーカス可能なウィジェットの順序を構築します。

```xojo
Var root As New XjBox()
// ... ウィジェット追加

Var focusManager As New XjFocusManager()
Call focusManager.BuildChain(root)
```

## フォーカス移動

```xojo
Sub FocusNext()
Sub FocusNext()
Function FocusedWidget() As XjWidget
Function FocusCount() As Integer
```

- `FocusNext()` — 次のウィジェットにフォーカス移動
- `FocusPrev()` — 前のウィジェットにフォーカス移動（Shift+Tab相当）
- `FocusedWidget()` — 現在フォーカスを持つウィジェットを取得
- `FocusCount()` — フォーカス可能なウィジェット数

```xojo
Var focusManager As New XjFocusManager()
// ...

If key.IsTab() Then
  If key.IsShift() Then
    focusManager.FocusPrev()
  Else
    focusManager.FocusNext()
  End If
End If

Var focused As XjWidget = focusManager.FocusedWidget()
```

## キーイベント処理

```xojo
Function HandleKey(key As XjKeyEvent) As Boolean
```

キーイベントをフォーカス中のウィジェットにルーティングします。

```xojo
Var focusManager As New XjFocusManager()
// ...

Var handled As Boolean = focusManager.HandleKey(key)
If Not handled Then
  // フォーカス中のウィジェットでハンドルされなかった
End If
```

## 実装例

### シンプルなフォーム

```xojo
Sub BuildFocusableForm()
  // ウィジェット作成
  Var root As New XjBox()
  Call root.SetDirection(XjLayoutNode.DIR_COLUMN)

  Var nameInput As New XjTextInput()
  Call nameInput.SetLabel("Name: ", XjStyle.Default())
  Call root.AddChild(nameInput)

  Var emailInput As New XjTextInput()
  Call emailInput.SetLabel("Email: ", XjStyle.Default())
  Call root.AddChild(emailInput)

  Var passwordInput As New XjTextInput()
  Call passwordInput.SetMask("•")
  Call passwordInput.SetLabel("Password: ", XjStyle.Default())
  Call root.AddChild(passwordInput)

  // フォーカス管理
  Var focusManager As New XjFocusManager()
  Call focusManager.BuildChain(root)

  Var loop As New XjEventLoop()
  loop.OnKeyPress = Function(key As XjKeyEvent) As Boolean
    If key.IsTab() Then
      If key.IsShift() Then
        focusManager.FocusPrev()
      Else
        focusManager.FocusNext()
      End If
      Return True
    End If
    Return focusManager.HandleKey(key)
  End Function

  loop.Run()
End Sub
```

### インタラクティブダイアログ

```xojo
Class Dialog
  Private mRoot As XjWidget
  Private mFocusManager As XjFocusManager

  Sub New()
    mRoot = New XjBox()
    mFocusManager = New XjFocusManager()
  End Sub

  Sub AddControl(control As XjWidget)
    Call mRoot.AddChild(control)
  End Sub

  Sub BuildFocusChain()
    Call mFocusManager.BuildChain(mRoot)
  End Sub

  Function HandleKeyInput(key As XjKeyEvent) As Boolean
    If key.IsTab() Then
      If key.IsShift() Then
        mFocusManager.FocusPrev()
      Else
        mFocusManager.FocusNext()
      End If
      Return True
    ElseIf key.IsEscape() Then
      Return False  // ダイアログ終了
    Else
      Return mFocusManager.HandleKey(key)
    End If
  End Function

  Function GetRoot() As XjWidget
    Return mRoot
  End Function
End Class
```

### ウィザード（複数ステップ）

```xojo
Class Wizard
  Private mSteps() As XjWidget
  Private mCurrentStep As Integer = 0
  Private mFocusManagers() As XjFocusManager

  Sub New()
    ReDim mSteps(3)
    ReDim mFocusManagers(3)

    For i As Integer = 0 To 3
      mSteps(i) = New XjBox()
      mFocusManagers(i) = New XjFocusManager()
    Wend
  End Sub

  Sub AddControlToStep(stepIndex As Integer, control As XjWidget)
    Var step As XjWidget = mSteps(stepIndex)
    Call step.AddChild(control)
  End Sub

  Sub PrepareStep(stepIndex As Integer)
    Call mFocusManagers(stepIndex).BuildChain(mSteps(stepIndex))
    mCurrentStep = stepIndex
  End Sub

  Function HandleKeyInput(key As XjKeyEvent) As Boolean
    If key.IsTab() Then
      Var mgr As XjFocusManager = mFocusManagers(mCurrentStep)
      If key.IsShift() Then
        mgr.FocusPrev()
      Else
        mgr.FocusNext()
      End If
      Return True
    End If
    Return mFocusManagers(mCurrentStep).HandleKey(key)
  End Function

  Function GetCurrentStep() As XjWidget
    Return mSteps(mCurrentStep)
  End Function

  Sub NextStep()
    If mCurrentStep < mSteps.Count - 1 Then
      mCurrentStep = mCurrentStep + 1
      PrepareStep(mCurrentStep)
    End If
  End Sub

  Sub PreviousStep()
    If mCurrentStep > 0 Then
      mCurrentStep = mCurrentStep - 1
      PrepareStep(mCurrentStep)
    End If
  End Sub
End Class
```

### セクション別フォーカス管理

```xojo
Class SectionedForm
  Private mSections() As XjBox
  Private mFocusManagers() As XjFocusManager
  Private mCurrentSection As Integer = 0

  Sub AddSection(title As String)
    Var newSize As Integer = mSections.Count + 1
    Var tmpSections(newSize - 1) As XjBox
    Var tmpManagers(newSize - 1) As XjFocusManager

    For i As Integer = 0 To mSections.Count - 1
      tmpSections(i) = mSections(i)
      tmpManagers(i) = mFocusManagers(i)
    Wend

    mSections = tmpSections
    mFocusManagers = tmpManagers

    Var section As New XjBox()
    Call section.SetTitle(title)
    mSections(newSize - 1) = section
    mFocusManagers(newSize - 1) = New XjFocusManager()
  End Sub

  Sub AddControlToCurrentSection(control As XjWidget)
    Call mSections(mCurrentSection).AddChild(control)
  End Sub

  Sub BuildFocusChains()
    For i As Integer = 0 To mSections.Count - 1
      Call mFocusManagers(i).BuildChain(mSections(i))
    Wend
  End Sub

  Function HandleKeyInput(key As XjKeyEvent) As Boolean
    If key.IsTab() Then
      Var mgr As XjFocusManager = mFocusManagers(mCurrentSection)
      If key.IsShift() Then
        mgr.FocusPrev()
      Else
        mgr.FocusNext()
      End If
      Return True
    End If
    Return mFocusManagers(mCurrentSection).HandleKey(key)
  End Function

  Sub FocusSection(sectionIndex As Integer)
    If sectionIndex >= 0 And sectionIndex < mSections.Count Then
      mCurrentSection = sectionIndex
    End If
  End Sub
End Class
```

## フォーカス可能なウィジェット

フォーカスが可能なウィジェットの条件：
- `IsFocusable()` が Trueを返す
- `HandleKey()` メソッドをオーバーライドしている

通常、以下のウィジェットはフォーカス可能です：
- XjTextInput
- XjSelectPrompt / XjMultiSelectPrompt
- その他のユーザー入力ウィジェット

## フォーカスの視覚化

フォーカス中のウィジェットを視覚的に区別するには、異なるスタイルを使用します：

```xojo
Class FocusableWidget
  Extends XjWidget
  Private mHasFocus As Boolean = False

  Function IsFocusable() As Boolean
    Return True
  End Function

  Sub SetFocused(focused As Boolean)
    mHasFocus = focused
    MarkDirty()
  End Sub

  Sub PaintContent(canvas As XjCanvas, x As Integer, y As Integer,
                   w As Integer, h As Integer)
    Var style As XjStyle
    If mHasFocus Then
      style = XjStyle.Highlight()  // ハイライト色
    Else
      style = XjStyle.Default()
    End If
    // ... 描画
  End Sub
End Class
```
