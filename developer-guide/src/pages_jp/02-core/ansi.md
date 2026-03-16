---
title: ANSIエスケープコード
description: XjANSIモジュールはターミナルカラー、スタイル、カーソル、スクリーン制御のANSIエスケープコードを生成します。36個の色定数とすべての制御メソッドを含みます。
---

# ANSIエスケープコード（XjANSI）

XjANSIモジュールはターミナル制御に必要なすべてのANSIエスケープコード生成関数を提供します。テキストのスタイリング、カラー指定、カーソル移動、スクリーンクリア、マウス追跡、ハイパーリンク挿入など、幅広い機能をサポートしています。

## 基本制御

```xojo
Function ESC() As String               // ESC文字（\x1B）
Function CSI() As String               // Control Sequence Introducer（ESC[）
Function OSC() As String               // Operating System Command（ESC]）
Function ST() As String                // String Terminator（ESC\）
Function SGR(code As Integer) As String    // Select Graphic Rendition
Function SGRMulti(codes() As Integer) As String  // 複数のSGRコード
Function Reset() As String             // すべてのスタイルをリセット
```

## テキストスタイル

```xojo
Function Bold() As String
Function Dim_() As String              // Dim（より暗い）
Function Italic() As String
Function Underline() As String
Function Blink() As String
Function Inverse() As String           // 前景色と背景色を反転
Function Hidden() As String            // 非表示テキスト
Function Strikethrough() As String
Function BoldOff() As String
Function ItalicOff() As String
Function UnderlineOff() As String
Function InverseOff() As String
```

## 前景色（テキスト色）

```xojo
Function FG(colorCode As Integer) As String       // 標準色（30-37）
Function BG(colorCode As Integer) As String       // 背景色（40-47）
Function FG256(index As Integer) As String        // 256色パレット（0-255）
Function BG256(index As Integer) As String
Function FGRGB(r As Integer, g As Integer, b As Integer) As String  // True Color（24ビット）
Function BGRGB(r As Integer, g As Integer, b As Integer) As String
Function DefaultFG() As String         // デフォルト前景色に戻す
Function DefaultBG() As String         // デフォルト背景色に戻す
```

## カーソル制御

```xojo
Function CursorUp(n As Integer) As String
Function CursorDown(n As Integer) As String
Function CursorForward(n As Integer) As String
Function CursorBackward(n As Integer) As String
Function CursorNextLine(n As Integer) As String   // n行下の行頭へ
Function CursorPrevLine(n As Integer) As String   // n行上の行頭へ
Function CursorColumn(col As Integer) As String   // 指定列へ移動
Function CursorPosition(row As Integer, col As Integer) As String  // (行,列)へ移動
Function CursorSave() As String        // カーソル位置を保存
Function CursorRestore() As String     // カーソル位置を復元
Function CursorShow() As String
Function CursorHide() As String
Function CursorRequestPosition() As String  // カーソル位置をリクエスト
```

## スクリーン消去

```xojo
Function EraseToEndOfLine() As String
Function EraseToStartOfLine() As String
Function EraseLine() As String
Function EraseDown() As String         // カーソル下の全行を消去
Function EraseUp() As String           // カーソル上の全行を消去
Function EraseScreen() As String       // スクリーン全体を消去
```

## スクロール

```xojo
Function ScrollUp(n As Integer) As String
Function ScrollDown(n As Integer) As String
```

## スクリーン制御

```xojo
Function AlternateScreenEnter() As String  // 別スクリーンに切り替え
Function AlternateScreenExit() As String
Function MouseTrackingEnable() As String
Function MouseTrackingDisable() As String
Function AutoWrapDisable() As String
Function AutoWrapEnable() As String
Function BracketedPasteEnable() As String
Function BracketedPasteDisable() As String
Function SetTitle(title As String) As String  // ターミナルウィンドウタイトル
Function Hyperlink(url As String, text As String) As String  // クリック可能リンク
```

## ユーティリティ

```xojo
Function StripCodes(text As String) As String  // ANSIコード除去
Function VisibleLength(text As String) As Integer  // 見かけ上の文字数
```

## 色定数（36個）

### 標準色（前景色）
```xojo
Const FG_BLACK = 30
Const FG_RED = 31
Const FG_GREEN = 32
Const FG_YELLOW = 33
Const FG_BLUE = 34
Const FG_MAGENTA = 35
Const FG_CYAN = 36
Const FG_WHITE = 37
```

### 明るい色（前景色）
```xojo
Const FG_BRIGHT_BLACK = 90
Const FG_BRIGHT_RED = 91
Const FG_BRIGHT_GREEN = 92
Const FG_BRIGHT_YELLOW = 93
Const FG_BRIGHT_BLUE = 94
Const FG_BRIGHT_MAGENTA = 95
Const FG_BRIGHT_CYAN = 96
Const FG_BRIGHT_WHITE = 97
```

### 標準色（背景色）
```xojo
Const BG_BLACK = 40
Const BG_RED = 41
Const BG_GREEN = 42
Const BG_YELLOW = 43
Const BG_BLUE = 44
Const BG_MAGENTA = 45
Const BG_CYAN = 46
Const BG_WHITE = 47
```

### 明るい色（背景色）
```xojo
Const BG_BRIGHT_BLACK = 100
Const BG_BRIGHT_RED = 101
Const BG_BRIGHT_GREEN = 102
Const BG_BRIGHT_YELLOW = 103
Const BG_BRIGHT_BLUE = 104
Const BG_BRIGHT_MAGENTA = 105
Const BG_BRIGHT_CYAN = 106
Const BG_BRIGHT_WHITE = 107
```

## 使用例

```xojo
// テキストスタイル
Var redBold As String = XjANSI.FG(XjANSI.FG_RED) + XjANSI.Bold() + "Error!" + XjANSI.Reset()

// カーソル移動
XjTerminal.Write(XjANSI.CursorPosition(10, 5) + "Text at row 10, col 5")

// スクリーンクリア
XjTerminal.Write(XjANSI.EraseScreen() + XjANSI.CursorPosition(1, 1))

// 256色とTrue Color
Var color256 As String = XjANSI.FG256(208) + "Orange text"
Var trueColor As String = XjANSI.FGRGB(255, 100, 50) + "Custom RGB"

// ハイパーリンク
Var link As String = XjANSI.Hyperlink("https://example.com", "Click here")
```
