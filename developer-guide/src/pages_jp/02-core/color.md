---
title: カラー機能
description: XjColorモジュールは色指定、カラー適用、グラデーション、セマンティックカラーの便利関数を提供します。
---

# カラー機能（XjColor）

XjColorモジュールはターミナルテキストに色を適用するための高レベルな便利関数を提供します。名前付きカラー、RGB色、256色パレット、グラデーション、セマンティック色などをサポートしています。

## 名前付き前景色

```xojo
Function Black(text As String) As String
Function Red(text As String) As String
Function Green(text As String) As String
Function Yellow(text As String) As String
Function Blue(text As String) As String
Function Magenta(text As String) As String
Function Cyan(text As String) As String
Function White(text As String) As String
```

8つの基本色です。各関数はテキストをその色で囲みます。

```xojo
Var redText As String = XjColor.Red("Error!")
Var greenText As String = XjColor.Green("Success")
```

## 明るい色

```xojo
Function BrightBlack(text As String) As String  // ダークグレイ
Function BrightRed(text As String) As String
Function BrightGreen(text As String) As String
Function BrightYellow(text As String) As String
Function BrightBlue(text As String) As String
Function BrightMagenta(text As String) As String
Function BrightCyan(text As String) As String
Function BrightWhite(text As String) As String
```

8つの明るい色（または「高輝度」色）です。

## テキストスタイル

```xojo
Function BoldText(text As String) As String
Function ItalicText(text As String) As String
Function UnderlineText(text As String) As String
Function DimText(text As String) As String
Function InverseText(text As String) As String
Function StrikethroughText(text As String) As String
```

テキストにスタイルを適用します。色と組み合わせられます。

```xojo
Var emphasis As String = XjColor.BoldText(XjColor.Red("Important!"))
```

## RGB色（True Color）

```xojo
Function RGB(text As String, r As Integer, g As Integer, b As Integer) As String
Function RGBBG(text As String, r As Integer, g As Integer, b As Integer) As String
```

- `RGB()` — 前景色をRGBで指定
- `RGBBG()` — 背景色をRGBで指定

値は0-255の範囲です。

```xojo
Var customColor As String = XjColor.RGB("Special", 200, 100, 50)
Var bgColor As String = XjColor.RGBBG("Highlight", 50, 100, 200)
```

## 256色パレット

```xojo
Function Color256(text As String, index As Integer) As String
```

256色パレット（0-255）から色を選択します。

```xojo
Var orange As String = XjColor.Color256("Warning", 208)
```

## グラデーション

```xojo
Function Gradient(text As String, fromR As Integer, fromG As Integer, fromB As Integer,
                  toR As Integer, toG As Integer, toB As Integer) As String
```

テキスト内の各文字に、開始色から終了色へのグラデーションを適用します。

```xojo
Var gradient As String = XjColor.Gradient("Rainbow", 255, 0, 0, 0, 0, 255)
```

## 背景色

```xojo
Function OnRed(text As String) As String
Function OnGreen(text As String) As String
Function OnBlue(text As String) As String
Function OnYellow(text As String) As String
Function OnWhite(text As String) As String
Function OnBlack(text As String) As String
Function OnBrightRed(text As String) As String
// ... 他の明るい色
```

背景色を指定します。

```xojo
Var highlight As String = XjColor.OnYellow(XjColor.Black("Alert"))
```

## セマンティックカラー

```xojo
Function Success(text As String) As String
Function Warning(text As String) As String
Function Error_(text As String) As String
Function Info(text As String) As String
Function Muted(text As String) As String
```

アプリケーション意味論に基づいた色です：

- `Success()` — 緑（成功メッセージ）
- `Warning()` — 黄色（警告メッセージ）
- `Error_()` — 赤（エラーメッセージ）
- `Info()` — 青（情報メッセージ）
- `Muted()` — グレイ（強調されていないテキスト）

```xojo
XjTerminal.Write(XjColor.Success("Operation completed") + Xojo.Core.NewLine)
XjTerminal.Write(XjColor.Warning("Check your input") + Xojo.Core.NewLine)
XjTerminal.Write(XjColor.Error_("Something went wrong") + Xojo.Core.NewLine)
```

## 使用例

```xojo
// ログ出力
Var message As String = XjColor.BoldText(XjColor.Green("[INFO]")) + " Setup complete"
XjTerminal.Write(message)

// ステータス表示
Var status As String = "Status: " + XjColor.Success("Active")
XjTerminal.Write(status)

// テーブル行の強調
For i As Integer = 0 To rows.Count - 1
  If i = selectedIndex Then
    XjTerminal.Write(XjColor.OnBlue(rows(i)))
  Else
    XjTerminal.Write(rows(i))
  End If
Wend

// グラデーション効果
Var title As String = XjColor.Gradient("Welcome", 255, 100, 0, 0, 200, 255)
XjTerminal.Write(title)
```

## カラーと色選択の組み合わせ

複数のカラー関数を組み合わせることで、複雑な色指定ができます。

```xojo
// 背景に緑の文字
Var result As String = XjColor.Green(XjColor.OnWhite("Success!"))

// イタリック体の赤い文字
Var emphasis As String = XjColor.ItalicText(XjColor.Red("Important"))

// 太字のセマンティック色
Var alert As String = XjColor.BoldText(XjColor.Warning("Caution"))
```
