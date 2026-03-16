---
title: 設定管理
description: XjConfigクラスはKey-Value設定、ファイルI/O、環境変数オーバーライドをサポート。
---

# 設定管理（XjConfig）

XjConfigはKey-Value設定の読み込み・保存、環境変数オーバーライド、型変換をサポート。

## コンストラクタ

```xojo
Sub New()
```

## 設定操作

```xojo
Sub Set(key As String, value As String)
Function Get(key As String) As String
Function GetInt(key As String) As Integer
Function GetBool(key As String) As Boolean
Function Has(key As String) As Boolean
Sub Remove(key As String)
Sub Clear()
```

```xojo
Var config As New XjConfig()
Call config.Set("database.host", "localhost")
Call config.Set("database.port", "5432")
Call config.Set("debug", "true")

Var host As String = config.Get("database.host")
Var port As Integer = config.GetInt("database.port")
Var debug As Boolean = config.GetBool("debug")
```

## ファイルI/O

```xojo
Function LoadFile(filePath As String) As Boolean
Sub SaveFile(filePath As String)
```

```xojo
Var config As New XjConfig()
If config.LoadFile("/etc/myapp/config.ini") Then
  // ロード成功
Else
  // ロード失敗
End If

config.SaveFile("/etc/myapp/config.ini")
```

## 環境変数オーバーライド

```xojo
Sub LoadEnv(prefix As String)
```

環境変数で設定値をオーバーライド。

```xojo
Var config As New XjConfig()
Call config.LoadFile("config.ini")
Call config.LoadEnv("MYAPP")  // MYAPP_*の環境変数で上書き

// MYAPP_DATABASE_HOST=prodhost の場合、database.hostが上書きされる
```

## 実装例

### アプリケーション設定

```xojo
Sub LoadApplicationConfig()
  Var config As New XjConfig()

  // デフォルト値
  Call config.Set("app.name", "MyApp")
  Call config.Set("app.version", "1.0.0")
  Call config.Set("app.debug", "false")

  // 設定ファイルから読み込み
  Call config.LoadFile(ExpandPath("~/.myapp/config.ini"))

  // 環境変数でオーバーライド
  Call config.LoadEnv("MYAPP")

  Return config
End Sub
```

### データベース接続設定

```xojo
Function GetDatabaseConfig() As Dictionary
  Var config As New XjConfig()
  Call config.LoadFile("db.conf")

  Var dbConfig As New Dictionary()
  dbConfig.Value("host") = config.Get("db.host")
  dbConfig.Value("port") = config.GetInt("db.port")
  dbConfig.Value("user") = config.Get("db.user")
  dbConfig.Value("password") = config.Get("db.password")
  dbConfig.Value("database") = config.Get("db.name")

  Return dbConfig
End Function
```

### 機能フラグ

```xojo
Sub CheckFeatures()
  Var config As New XjConfig()
  Call config.LoadFile("features.ini")

  If config.GetBool("feature.newUI") Then
    LoadNewUI()
  Else
    LoadClassicUI()
  End If

  If config.GetBool("feature.experimental") Then
    EnableExperimentalFeatures()
  End If
End Sub
```

## 設定ファイル形式

```ini
# config.ini
[app]
name=MyApp
debug=true

[database]
host=localhost
port=5432
user=admin
password=secret
```

## 環境変数プリフィックス

```bash
# 環境変数で設定
export MYAPP_DATABASE_HOST=prodhost
export MYAPP_DATABASE_PORT=3306
export MYAPP_DEBUG=false
```

```xojo
Var config As New XjConfig()
Call config.LoadFile("default.conf")
Call config.LoadEnv("MYAPP")  // MYAPP_*で上書き
```

## デフォルト値の処理

```xojo
Function GetConfigValue(key As String, defaultValue As String) As String
  Var config As New XjConfig()
  Call config.LoadFile("app.conf")

  If config.Has(key) Then
    Return config.Get(key)
  Else
    Return defaultValue
  End If
End Function
```

## 設定プロファイル

```xojo
Sub LoadProfile(profile As String)
  Var config As New XjConfig()

  Select Case profile
    Case "development"
      Call config.LoadFile("config.dev.ini")
    Case "staging"
      Call config.LoadFile("config.staging.ini")
    Case "production"
      Call config.LoadFile("config.prod.ini")
  End Select

  Return config
End Sub
```
