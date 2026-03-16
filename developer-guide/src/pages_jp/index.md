---
title: 導入
description: XjTTY-ToolkitはXojoコンソールアプリケーション向けのTerminal UI（TUI）ライブラリです。Ruby TTY-Toolkit、Python Prompt Toolkit、Rust IOCraftからインスピレーションを得ています。
---

# 導入

**XjTTY-Toolkit**はXojoコンソールアプリケーション向けの総合的なTerminal UI（TUI）ライブラリです。低レベルのANSIエスケープコードから、高レベルのプロンプトダイアログやウィジェットベースのレイアウトまで、リッチでインタラクティブなターミナルインターフェースを構築するために必要なすべてを提供します。Ruby TTY-Toolkit、Python Prompt Toolkit、Rust IOCraftからインスピレーションを受けています。

## アーキテクチャ層

| レイヤー | コンポーネント数 | 目的 |
|---------|----------------|------|
| 基盤 | 8 | プラットフォーム検出、ANSIコード、ターミナル制御 |
| スタイリング | 3 | テキストスタイル、キャンバス描画 |
| イベント | 4 | キーボード・マウス・リサイズイベント、メインループ |
| レイアウト | 3 | Flexboxライクなレイアウトツリーと解決エンジン |
| ウィジェット | 8 | 基本的なUI部品（テキスト、入力、テーブル、進捗など） |
| プロンプト | 13 | 対話的な質問・選択ダイアログシステム |
| ユーティリティ | 12 | ロガー、CLIオプション、設定、コマンド実行、ページャー |
| YAML UI | 3 | YAML定義からUIツリーを構築 |
| **合計** | **63** | **フル機能のTerminal UI構築フレームワーク** |

## 63コンポーネント

XjTTY-Toolkitは以下の63個のモジュール・クラスで構成されています：

- **基本**（8）：XjPlatform、XjANSI、XjTerminal、XjColor、XjCursor、XjScreen、XjKeyEvent、XjReader
- **スタイリング**（3）：XjStyle、XjCell、XjCanvas、XjSymbols
- **イベント**（4）：XjEvent、XjEventLoop、XjKeyEvent、XjReader
- **レイアウト**（3）：XjConstraint、XjLayoutNode、XjLayoutSolver
- **ウィジェット**（8）：XjWidget、XjBox、XjText、XjTextInput、XjTable、XjProgressBar、XjSpinner、XjTree、XjTreeNode、XjFocusManager
- **プロンプト**（13）：XjPrompt（ファサード）、XjAskPrompt、XjPasswordPrompt、XjSelectPrompt、XjMultiSelectPrompt、XjEnumSelectPrompt、XjExpandPrompt、XjMultiLinePrompt、XjSliderPrompt、XjKeyPressPrompt、XjSuggestPrompt、XjConfirmPrompt、XjCollectPrompt
- **スタイリング・バリデーション**（3）：XjPromptStyle、XjValidation、XjConversion
- **ユーティリティ**（12）：XjLogger、XjOption、XjConfig、XjCommand、XjCommandResult、XjWhich、XjHistory、XjPager、XjFont、XjPie、XjMarkdown、XjInlineRenderer、XjCompleter
- **YAML UI**（3）：XjYAML、XjYAMLNode、XjUIParser

## プラットフォームサポート

- **macOS、Linux、Windows** — 3つのすべての主要プラットフォームで完全サポート
- **64ビット・ARM** — モダンなアーキテクチャに対応
- **256色・True Color（24ビットRGB）** — 自動検出

## クイックスタート

```xojo
// ウィジェット管理アプリの例
Var loop As New XjEventLoop()
Var root As New XjBox()
root.SetDirection(XjLayoutNode.DIR_COLUMN)
root.SetPadding(1, 1, 1, 1)

Var title As New XjText()
title.SetText("Welcome to XjTTY-Toolkit")
root.AddChild(title)

Var input As New XjTextInput()
input.SetPlaceholder("Enter your name...")
root.AddChild(input)

loop.OnKeyPress = Function(key) As Boolean
  If key.IsEscape Then
    loop.Stop_()
    Return True
  End If
  Return False
End Function

loop.OnTick = Sub(tickCount)
  XjScreen.Clear()
  root.Paint(Var canvas As New XjCanvas(XjScreen.Width(), XjScreen.Height()))
  XjTerminal.Write(canvas.Render())
End Sub

loop.Run()
```

## このガイドの構成

このドキュメントは以下のセクションに分かれています：

| セクション | ファイル | 説明 |
|-----------|---------|------|
| コア機能 | 02-core/ | プラットフォーム、ANSI、ターミナル制御 |
| スタイリング | 03-styling/ | スタイル、キャンバス、シンボル |
| イベント | 04-events/ | キーイベント、イベントシステム、ループ |
| レイアウト | 05-layout/ | 制約、ノード、ソルバー |
| ウィジェット | 06-widgets/ | 基本、テキスト、入力、テーブル |
| プロンプト | 07-prompts/ | 質問、選択、バリデーション |
| ユーティリティ | 08-utilities/ | ロガー、オプション、設定、コマンド |
| YAML UI | 09-yaml-ui/ | YAMLパーサー、UIビルダー |

各ページは完全なAPIリファレンスと実装例を含みます。
