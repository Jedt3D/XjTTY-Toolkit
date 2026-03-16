---
title: プラットフォーム検出
description: XjPlatformモジュールはmacOS、Linux、Windowsなどの実行時プラットフォーム情報を提供します。
---

# プラットフォーム検出（XjPlatform）

XjPlatformモジュールは、実行時にオペレーティングシステム、アーキテクチャ、プラットフォーム機能の情報を取得するための統一されたインターフェースを提供します。macOS、Linux、Windowsなどの異なるプラットフォーム固有の実装を抽象化します。

## プラットフォーム判定メソッド

```xojo
Function IsWindows() As Boolean
Function IsMacOS() As Boolean
Function IsLinux() As Boolean
Function IsUnix() As Boolean
Function Is64Bit() As Boolean
Function IsARM() As Boolean
```

これらのメソッドはプラットフォームの種類とアーキテクチャを判定します。

### プラットフォーム判定の使用例

```xojo
If XjPlatform.IsWindows() Then
  // Windows固有の処理
  XjTerminal.SetTitle("My App - Windows")
ElseIf XjPlatform.IsMacOS() Then
  // macOS固有の処理
  XjTerminal.SetTitle("My App - macOS")
ElseIf XjPlatform.IsLinux() Then
  // Linux固有の処理
  XjTerminal.SetTitle("My App - Linux")
End If

If XjPlatform.Is64Bit() Then
  Var largeBuffer(1000000) As Byte
End If

If XjPlatform.IsARM() Then
  // ARM（M1/M2など）固有の最適化
End If
```

## プラットフォーム情報取得

```xojo
Function OSName() As String
Function Architecture() As String
Function PlatformInfo() As String
```

- `OSName()` — オペレーティングシステムの名前（例：「macOS 14.2」「Ubuntu 22.04」「Windows 11」）
- `Architecture()` — アーキテクチャの名前（例：「x86_64」「arm64」）
- `PlatformInfo()` — 人間が読める形のプラットフォーム情報（例：「macOS 14.2 on arm64」）

### プラットフォーム情報の例

```xojo
Var info As String = XjPlatform.PlatformInfo()
XjLogger.Info("Running on: " + info)
// 出力: "Running on: macOS 14.2 on arm64"
```

## ユースケース

**条件付きコンパイル**：プラットフォーム判定は、実行時にプラットフォーム固有のコードパスを選択するのに役立ちます。

**ログ出力**：アプリケーション起動時にプラットフォーム情報をログに記録することで、デバッグやサポートが容易になります。

**パフォーマンス最適化**：64ビットやARMアーキテクチャ検出により、メモリバッファサイズやアルゴリズム選択を最適化できます。
