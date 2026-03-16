---
title: シンボル（グリフ）
description: XjSymbolsモジュールはUnicode/ASCIIグリフセット（チェック、矢印、点など）を提供します。
---

# シンボル（XjSymbols）

XjSymbolsモジュールはターミナルで使用する一般的なUnicodeおよびASCIIシンボル（グリフ）を提供します。チェックマーク、矢印、点、括弧など、UIで頻繁に使用される記号を統一的に処理できます。

## モード管理

```xojo
Sub EnsureInit()
Sub UseASCII()
Sub UseUnicode()
```

- `EnsureInit()` — シンボルセットを初期化（必要に応じて自動実行）
- `UseASCII()` — ASCIIシンボルに切り替え
- `UseUnicode()` — Unicodeシンボルに切り替え（デフォルト）

```xojo
// デフォルトはUnicode
XjSymbols.UseASCII()   // 出力: [x], [ ], [!] など
XjSymbols.UseUnicode() // 出力: ✔, ○, ✘ など
```

## シンボル関数

```xojo
Function Marker() As String           // ❯ または >
Function Check() As String            // ✔ または [x]
Function Cross() As String            // ✘ または [!]
Function Circle() As String           // ● または (*)
Function CircleEmpty() As String      // ○ または ( )
Function Square() As String           // ■ または [x]
Function SquareEmpty() As String      // □ または [ ]
Function ArrowRight() As String       // ▸ または >
Function Bullet() As String           // • または *
Function Ellipsis() As String         // … または ...
Function QuestionMark() As String     // ?
```

## Unicode / ASCII マッピング

| 関数 | Unicode | ASCII |
|------|---------|-------|
| Marker | ❯ | > |
| Check | ✔ | [x] |
| Cross | ✘ | [!] |
| Circle | ● | (*) |
| CircleEmpty | ○ | ( ) |
| Square | ■ | [x] |
| SquareEmpty | □ | [ ] |
| ArrowRight | ▸ | > |
| Bullet | • | * |
| Ellipsis | … | ... |

## 使用例

### プロンプトシステム

```xojo
// 選択肢の前のマーカー
Var marker As String = XjSymbols.Marker() + " Option 1"

// チェックボックス
Var checked As String = XjSymbols.Check() + " Task completed"
Var unchecked As String = XjSymbols.SquareEmpty() + " Task pending"

// リスト
Var item1 As String = XjSymbols.Bullet() + " First item"
Var item2 As String = XjSymbols.Bullet() + " Second item"
```

### ステータスインジケーター

```xojo
Function DrawStatusLine(status As String) As String
  Select Case status
    Case "success"
      Return XjSymbols.Check() + " " + XjColor.Success("Complete")
    Case "error"
      Return XjSymbols.Cross() + " " + XjColor.Error_("Failed")
    Case "pending"
      Return XjSymbols.CircleEmpty() + " " + XjColor.Muted("Waiting")
  End Select
End Function
```

### メニューナビゲーション

```xojo
// 現在選択項目を表示
Function DrawMenu(items() As String, selectedIndex As Integer) As String
  Var output As String = ""
  For i As Integer = 0 To items.Count - 1
    If i = selectedIndex Then
      output = output + XjSymbols.ArrowRight() + " " + items(i)
    Else
      output = output + "  " + items(i)
    End If
    If i < items.Count - 1 Then
      output = output + Xojo.Core.NewLine
    End If
  Wend
  Return output
End Function
```

### ローディングインジケーター

```xojo
Function DrawLoading() As String
  Var frames() As String = Array("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
  Var frame As String = frames(XjSystem.TickCount Mod frames.Count)
  Return frame + " Loading" + XjSymbols.Ellipsis()
End Function
```

### リスト表示

```xojo
Function DrawList(items() As String) As String
  Var output As String = ""
  For i As Integer = 0 To items.Count - 1
    If i = 0 Then
      output = output + XjSymbols.Bullet() + " " + items(i)
    Else
      output = output + Xojo.Core.NewLine + XjSymbols.Bullet() + " " + items(i)
    End If
  Wend
  Return output
End Function
```

## プラットフォーム互換性

Unicodeモードは、UTF-8をサポートするすべてのターミナルで使用できます。古いターミナルやASCIIのみのシステムではASCIIモードに切り替えます。

```xojo
If XjTerminal.SupportsColor() And XjPlatform.IsUnix() Then
  XjSymbols.UseUnicode()
Else
  XjSymbols.UseASCII()
End If
```

## テーマ設定

```xojo
Class UITheme
  Shared Function GetCheckMark() As String
    Return XjSymbols.Check() + " "
  End Function

  Shared Function GetErrorMark() As String
    Return XjSymbols.Cross() + " "
  End Function

  Shared Function GetArrow() As String
    Return XjSymbols.ArrowRight() + " "
  End Function
End Class

// 使用例
Var checkBox As String = UITheme.GetCheckMark() + "Option checked"
```
