---
title: YAMLパーサー
description: XjYAMLはインデンテーションベースのYAML解析をサポート。
---

# YAMLパーサー（XjYAML、XjYAMLNode）

YAML形式の設定・UIレイアウト定義をパース。

## XjYAMLNode（パースツリーノード）

```xojo
Function Key() As String
Function Value() As String
Function Children() As XjYAMLNode()
Function GetString(key As String) As String
Function GetInt(key As String) As Integer
Function GetBool(key As String) As Boolean
Function GetChild(key As String) As XjYAMLNode
```

```xojo
Var node As XjYAMLNode = // ... パース結果
Var name As String = node.GetString("name")
Var port As Integer = node.GetInt("port")
Var debug As Boolean = node.GetBool("debug")
```

## XjYAML（パーサーモジュール）

```xojo
Function Parse(yaml As String) As XjYAMLNode
Function ParseFile(filePath As String) As XjYAMLNode
```

```xojo
Var yaml As String = "name: MyApp" + Xojo.Core.NewLine + _
                     "port: 8080" + Xojo.Core.NewLine + _
                     "debug: true"

Var root As XjYAMLNode = XjYAML.Parse(yaml)
Var name As String = root.GetString("name")
```

## YAML 形式

```yaml
# アプリ設定
app:
  name: MyApplication
  version: 1.0.0
  debug: false

database:
  host: localhost
  port: 5432
  user: admin
  password: secret

features:
  - logging
  - cache
  - api
```

## 実装例

### 設定ファイルロード

```xojo
Function LoadConfig(filePath As String) As Dictionary
  Var root As XjYAMLNode = XjYAML.ParseFile(filePath)

  Var config As New Dictionary()
  config.Value("app.name") = root.GetString("app.name")
  config.Value("app.version") = root.GetString("app.version")
  config.Value("db.host") = root.GetString("database.host")
  config.Value("db.port") = root.GetInt("database.port")

  Return config
End Function
```

### ネストされたYAML

```xojo
Sub ParseNestedYAML()
  Var yaml As String = "server:" + Xojo.Core.NewLine + _
                       "  host: localhost" + Xojo.Core.NewLine + _
                       "  port: 3000" + Xojo.Core.NewLine + _
                       "  ssl:" + Xojo.Core.NewLine + _
                       "    enabled: true" + Xojo.Core.NewLine + _
                       "    cert: /path/to/cert"

  Var root As XjYAMLNode = XjYAML.Parse(yaml)
  Var serverNode As XjYAMLNode = root.GetChild("server")

  Var host As String = serverNode.GetString("host")
  Var sslNode As XjYAMLNode = serverNode.GetChild("ssl")
  Var certPath As String = sslNode.GetString("cert")
End Sub
```

### YAML 配列

```yaml
databases:
  - host: localhost
    port: 5432
    name: db1
  - host: remote.example.com
    port: 3306
    name: db2
```

```xojo
Sub ParseDatabases()
  Var root As XjYAMLNode = XjYAML.ParseFile("databases.yaml")
  Var dbsNode As XjYAMLNode = root.GetChild("databases")

  Var databases() As XjYAMLNode = dbsNode.Children()
  For i As Integer = 0 To databases.Count - 1
    Var host As String = databases(i).GetString("host")
    Var port As Integer = databases(i).GetInt("port")
  Wend
End Sub
```
