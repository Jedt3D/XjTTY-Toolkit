---
title: 表示ユーティリティ
description: XjFont、XjPie、XjMarkdownで高度なテキスト表示。
---

# 表示ユーティリティ（XjFont、XjPie、XjMarkdown）

ASCII アート、グラフ、マークダウンレンダリング。

## XjFont（ASCIIアート）

5×5ブロックフォントでテキストをASCIアート化。

```xojo
Function Render(text As String) As String
```

```xojo
Var title As String = XjFont.Render("HELLO")
// 出力:
// █   █ █████ █     █     █████
// █   █ █     █     █     █
// █████ ████  █     █     ████
// █   █ █     █     █     █
// █   █ █████ █████ █████ █████

XjTerminal.Write(title)
```

## XjPie（パイチャート）

水平棒グラフで数値を表示。

```xojo
Sub New()
Function AddSegment(label As String, value As Integer, style As XjStyle) As XjPie
Function Render() As String
```

```xojo
Var pie As New XjPie()
Call pie.AddSegment("JavaScript", 40, XjStyle.Success())
Call pie.AddSegment("Python", 35, XjStyle.Warning())
Call pie.AddSegment("Go", 25, XjStyle.Info())

XjTerminal.Write(pie.Render())
// 出力:
// JavaScript  ████████████████░░░░░░░░░░░░░░ 40%
// Python      ███████████████░░░░░░░░░░░░░░░░ 35%
// Go          ██████████░░░░░░░░░░░░░░░░░░░░░ 25%
```

## XjMarkdown（マークダウンレンダリング）

ターミナルでマークダウンをレンダリング。

```xojo
Function Render(markdown As String) As String
```

サポート：
- ヘッダー（#～###）
- 強調（**bold**、*italic*）
- リスト（-、*）
- コードブロック（```）
- 水平線（---）

```xojo
Var md As String = "# Title" + Xojo.Core.NewLine + _
                   "This is **bold** and *italic*" + Xojo.Core.NewLine + _
                   "- Item 1" + Xojo.Core.NewLine + _
                   "- Item 2"

Var output As String = XjMarkdown.Render(md)
XjTerminal.Write(output)
```

## 実装例

### ウェルカムバナー

```xojo
Sub ShowBanner()
  Var banner As String = XjFont.Render("MyApp")
  XjTerminal.Write(banner)

  XjPrompt.Say("Welcome to MyApp v1.0.0")
  XjPrompt.Say("Type 'help' for more information")
End Sub
```

### 統計情報表示

```xojo
Sub ShowStatistics()
  Var pie As New XjPie()
  Call pie.AddSegment("Completed", 72, XjStyle.Success())
  Call pie.AddSegment("In Progress", 18, XjStyle.Info())
  Call pie.AddSegment("Failed", 10, XjStyle.Danger())

  XjTerminal.Write(pie.Render())
End Sub
```

### マークダウンドキュメント表示

```xojo
Sub DisplayREADME()
  Var readme As String = "# MyApp Documentation" + Xojo.Core.NewLine + _
                         Xojo.Core.NewLine + _
                         "## Installation" + Xojo.Core.NewLine + _
                         "```" + Xojo.Core.NewLine + _
                         "$ npm install myapp" + Xojo.Core.NewLine + _
                         "```" + Xojo.Core.NewLine + _
                         Xojo.Core.NewLine + _
                         "## Usage" + Xojo.Core.NewLine + _
                         "- **list**: Show items" + Xojo.Core.NewLine + _
                         "- **add**: Add new item" + Xojo.Core.NewLine + _
                         "- **delete**: Remove item"

  Var output As String = XjMarkdown.Render(readme)
  Call XjPager.Show(output)
End Sub
```

### レポート生成

```xojo
Sub GenerateReport()
  Var title As String = XjFont.Render("REPORT")
  XjTerminal.Write(title)

  XjTerminal.Write(Xojo.Core.NewLine)
  XjPrompt.Say("## Summary")

  Var pie As New XjPie()
  Call pie.AddSegment("Success", 150, XjStyle.Success())
  Call pie.AddSegment("Warnings", 35, XjStyle.Warning())
  Call pie.AddSegment("Errors", 15, XjStyle.Danger())

  XjTerminal.Write(pie.Render())
End Sub
```
