---
title: ロギング
description: XjLoggerクラスは構造化ログ、レベル、色、JSONフォーマットをサポート。
---

# ロギング（XjLogger）

XjLoggerは構造化ログ、ログレベル、色付け、JSONフォーマット、メタデータをサポートする統合ロガー。

## ログレベル

```xojo
Const LEVEL_DEBUG = 0
Const LEVEL_INFO = 1
Const LEVEL_WARN = 2
Const LEVEL_ERROR = 3
Const LEVEL_FATAL = 4
```

## ロギングメソッド

```xojo
Sub Debug(message As String)
Sub Info(message As String)
Sub Warn(message As String)
Sub Error_(message As String)
Sub Fatal(message As String)
```

```xojo
XjLogger.Debug("Debug message")
XjLogger.Info("Information")
XjLogger.Warn("Warning!")
XjLogger.Error_("An error occurred")
XjLogger.Fatal("Fatal error")
```

## ロガー設定

```xojo
Sub SetLevel(level As Integer)
Sub SetFormat(format As String)            // JSON、Text
Sub SetOutput(filePath As String)          // ファイル出力
Sub SetColorize(colorize As Boolean)
```

```xojo
XjLogger.SetLevel(XjLogger.LEVEL_DEBUG)    // DEBUG以上を表示
XjLogger.SetColorize(True)                 // 色付けON
XjLogger.SetFormat("json")                 // JSON形式
```

## メタデータ

```xojo
Sub AddMetadata(key As String, value As Variant)
Sub ClearMetadata()
```

ログに付加情報を含める。

```xojo
XjLogger.AddMetadata("userId", 12345)
XjLogger.AddMetadata("version", "1.0.0")
XjLogger.Info("User action")
// {"level":"info","message":"User action","userId":12345,"version":"1.0.0"}
```

## 実装例

### アプリケーションログ

```xojo
Sub InitializeApp()
  XjLogger.SetLevel(XjLogger.LEVEL_DEBUG)
  XjLogger.SetColorize(True)

  XjLogger.Info("Application starting")
  XjLogger.Debug("Debug mode enabled")
  XjLogger.Info("Configuration loaded")
  XjLogger.Info("Database connected")
  XjLogger.Info("Ready")
End Sub
```

### エラーハンドリング

```xojo
Sub ProcessFile(filepath As String)
  Try
    XjLogger.Info("Processing: " + filepath)
    // 処理...
    XjLogger.Info("Completed: " + filepath)
  Catch err As RuntimeException
    XjLogger.Error_("Failed to process: " + filepath)
    XjLogger.Error_("Error: " + err.Message)
  End Try
End Sub
```

### パフォーマンスログ

```xojo
Sub TimedOperation()
  XjLogger.AddMetadata("operation", "database_query")

  Var start As Integer = DateTime.Now().SecondsSince1970
  // 処理...
  Var elapsed As Integer = DateTime.Now().SecondsSince1970 - start

  XjLogger.AddMetadata("duration_ms", elapsed)
  XjLogger.Info("Operation completed")
End Sub
```

### JSONログ出力

```xojo
Sub ExportLogs()
  XjLogger.SetFormat("json")
  XjLogger.SetOutput("/var/log/app.json")

  XjLogger.AddMetadata("hostname", "server1")
  XjLogger.AddMetadata("version", "1.0.0")

  XjLogger.Info("Logging to JSON")
  // ファイルに: {"level":"info","message":"...","hostname":"server1",...}
End Sub
```

## ログレベルの使い分け

| レベル | 用途 |
|--------|------|
| DEBUG | 開発中の詳細情報 |
| INFO | 正常な進行状況 |
| WARN | 注意が必要な状況 |
| ERROR | エラーが発生 |
| FATAL | 致命的エラー |
