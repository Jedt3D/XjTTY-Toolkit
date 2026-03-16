---
title: 選択プロンプト
description: XjSelectPrompt、XjMultiSelectPrompt、XjEnumSelectPrompt、XjExpandPromptの実装。
---

# 選択プロンプト（選択系ウィジェット）

ユーザーが複数の選択肢から選ぶプロンプト。

## XjSelectPrompt（単一選択）

矢印キーで選択肢を移動し、Enterで確定。

```xojo
Var options() As String = Array("Red", "Green", "Blue")
Var prompt As New XjSelectPrompt()
Call prompt.SetQuestion("Choose color: ")
Call prompt.SetOptions(options)

Var selected As String = prompt.Show()
```

キーバインディング：
- 上下矢印 — 選択移動
- Enter — 確定
- Escape — キャンセル

## XjMultiSelectPrompt（複数選択）

スペースキーで複数選択、Enterで確定。

```xojo
Var options() As String = Array("Feature A", "Feature B", "Feature C")
Var prompt As New XjMultiSelectPrompt()
Call prompt.SetQuestion("Select features: ")
Call prompt.SetOptions(options)
Call prompt.SetMinSelected(1)
Call prompt.SetMaxSelected(2)

Var selected() As String = prompt.Show()
```

機能：
- スペース — 選択/解除
- 上下矢印 — 移動
- Enter — 確定
- 最小・最大選択数制限

## XjEnumSelectPrompt（番号付き選択）

1～9の数字キーで選択。

```xojo
Var options() As String = Array("Option A", "Option B", "Option C")
Var prompt As New XjEnumSelectPrompt()
Call prompt.SetQuestion("Select: ")
Call prompt.SetOptions(options)

Var selected As String = prompt.Show()
// 表示: 1) Option A, 2) Option B, 3) Option C
// ユーザーが「2」を押す → "Option B"を返す
```

## XjExpandPrompt（キーマッピング選択）

キーマッピングで選択肢を展開。git風のプロンプト。

```xojo
Var choices As New Dictionary()
choices.Value("y") = "Yes"
choices.Value("n") = "No"
choices.Value("a") = "All"
choices.Value("d") = "Done"

Var prompt As New XjExpandPrompt()
Call prompt.SetQuestion("Continue? (y/n/a/d): ")
Call prompt.SetChoices(choices)

Var selected As String = prompt.Show()
```

表示: `(y)es / (n)o / (a)ll / (d)one`

## 実装例

### 単一選択フロー

```xojo
Sub SelectDatabase()
  Var databases() As String = Array("MySQL", "PostgreSQL", "SQLite", "MongoDB")

  Var prompt As New XjSelectPrompt()
  Call prompt.SetQuestion("Select database: ")
  Call prompt.SetOptions(databases)

  Var selected As String = prompt.Show()
  XjPrompt.Ok("Selected: " + selected)
End Sub
```

### 複数機能選択

```xojo
Sub SelectFeatures()
  Var allFeatures() As String = Array(
    "Authentication",
    "Logging",
    "Caching",
    "Testing",
    "Documentation"
  )

  Var prompt As New XjMultiSelectPrompt()
  Call prompt.SetQuestion("Select features to include: ")
  Call prompt.SetOptions(allFeatures)
  Call prompt.SetMinSelected(1)
  Call prompt.SetMaxSelected(3)

  Var selected() As String = prompt.Show()
  For i As Integer = 0 To selected.Count - 1
    XjPrompt.Say("✓ " + selected(i))
  Wend
End Sub
```

### インストールウィザード

```xojo
Sub InstallWizard()
  // ライセンス同意
  Var choices As New Dictionary()
  choices.Value("y") = "I agree"
  choices.Value("n") = "I disagree"

  Var licensePrompt As New XjExpandPrompt()
  Call licensePrompt.SetQuestion("Do you accept the license? ")
  Call licensePrompt.SetChoices(choices)

  If licensePrompt.Show() <> "I agree" Then
    XjPrompt.Error_("Installation cancelled")
    Return
  End If

  // インストール先選択
  Var locations() As String = Array("/usr/local", "/opt", "/home/user/apps")
  Var locPrompt As New XjSelectPrompt()
  Call locPrompt.SetQuestion("Install location: ")
  Call locPrompt.SetOptions(locations)

  Var location As String = locPrompt.Show()

  // オプション機能
  Var features() As String = Array("CLI Tools", "Documentation", "Examples", "Source Code")
  Var featPrompt As New XjMultiSelectPrompt()
  Call featPrompt.SetQuestion("Select components: ")
  Call featPrompt.SetOptions(features)

  Var selected() As String = featPrompt.Show()

  XjPrompt.Ok("Installation configured")
End Sub
```

### アクション確認

```xojo
Sub DeleteConfirmation(itemName As String)
  Var choices As New Dictionary()
  choices.Value("y") = "Yes, delete"
  choices.Value("n") = "No, keep"
  choices.Value("b") = "Backup and delete"

  Var prompt As New XjExpandPrompt()
  Call prompt.SetQuestion("Delete '" + itemName + "'? ")
  Call prompt.SetChoices(choices)

  Var action As String = prompt.Show()
  Select Case action
    Case "Yes, delete"
      Delete_(itemName)
    Case "Backup and delete"
      Backup(itemName)
      Delete_(itemName)
    Case Else
      XjPrompt.Say("Cancelled")
  End Select
End Sub
```

### スクロール対応（多数オプション）

```xojo
Function SelectFromLargeList(items() As String) As String
  Var prompt As New XjSelectPrompt()
  Call prompt.SetQuestion("Select item: ")
  Call prompt.SetOptions(items)
  Call prompt.SetPageSize(10)  // 10項目ずつ表示

  Return prompt.Show()
End Function
```

## 表示例

### SelectPrompt
```
? Choose color:
  ❯ Red
    Green
    Blue
```

### MultiSelectPrompt
```
? Select features: (Space to toggle, Enter to confirm)
  ☑ Feature A
  ☐ Feature B
  ☑ Feature C
```

### EnumSelectPrompt
```
? Select:
  1) Option A
  2) Option B
  3) Option C
```

### ExpandPrompt
```
? Continue? (y)es / (n)o / (a)ll:
```
