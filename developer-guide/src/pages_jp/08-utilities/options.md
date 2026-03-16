---
title: CLIオプション解析
description: XjOptionクラスはコマンドライン引数を解析し、自動ヘルプテキストを生成。
---

# CLIオプション解析（XjOption）

XjOptionはコマンドライン引数を解析し、自動ヘルプテキスト生成、型変換、検証をサポート。

## コンストラクタ

```xojo
Sub New(name As String)
```

## オプション定義

```xojo
Sub AddOption(shortName As String, longName As String, description As String, required As Boolean)
Sub AddFlag(shortName As String, longName As String, description As String)
Sub AddArgument(name As String, description As String, required As Boolean)
```

```xojo
Var parser As New XjOption("myapp")
Call parser.AddFlag("v", "version", "Show version")
Call parser.AddOption("i", "input", "Input file", True)
Call parser.AddArgument("output", "Output file", True)
```

## 解析と取得

```xojo
Function Parse(args() As String) As Boolean
Function GetOption(name As String) As String
Function HasFlag(name As String) As Boolean
Function GetArgument(name As String) As String
Function GetHelp() As String
```

```xojo
Var parser As New XjOption("myapp")
// ... オプション定義

If Not parser.Parse(CommandLine.Arguments) Then
  XjTerminal.Write(parser.GetHelp())
  Return
End If

Var input As String = parser.GetOption("input")
Var output As String = parser.GetArgument("output")
```

## 実装例

### ファイル処理アプリ

```xojo
Sub Main()
  Var parser As New XjOption("fileproc")
  Call parser.AddFlag("h", "help", "Show this help")
  Call parser.AddFlag("v", "verbose", "Verbose output")
  Call parser.AddOption("i", "input", "Input file", True)
  Call parser.AddOption("o", "output", "Output file", False)
  Call parser.AddOption("f", "format", "Output format", False)
  Call parser.AddArgument("command", "Command to run", True)

  If Not parser.Parse(CommandLine.Arguments) Or parser.HasFlag("help") Then
    XjTerminal.Write(parser.GetHelp())
    Return
  End If

  Var inputFile As String = parser.GetOption("input")
  Var command As String = parser.GetArgument("command")
  Var verbose As Boolean = parser.HasFlag("verbose")

  ProcessFile(inputFile, command, verbose)
End Sub
```

### サーバーアプリ

```xojo
Sub StartServer()
  Var parser As New XjOption("server")
  Call parser.AddOption("p", "port", "Port number", False)
  Call parser.AddOption("h", "host", "Host address", False)
  Call parser.AddFlag("d", "daemon", "Run as daemon")
  Call parser.AddFlag("s", "ssl", "Enable SSL")

  If Not parser.Parse(CommandLine.Arguments) Then
    XjTerminal.Write(parser.GetHelp())
    Return
  End If

  Var port As Integer = 8080
  Var portStr As String = parser.GetOption("port")
  If portStr.Length > 0 Then
    port = Integer.FromString(portStr)
  End If

  Var host As String = parser.GetOption("host")
  If host.Length = 0 Then
    host = "localhost"
  End If

  RunServer(host, port, parser.HasFlag("daemon"), parser.HasFlag("ssl"))
End Sub
```

## ヘルプテキスト自動生成

```xojo
// 定義から自動生成：
Var parser As New XjOption("tool")
Call parser.AddFlag("h", "help", "Show this help")
Call parser.AddOption("i", "input", "Input file", True)
Call parser.AddFlag("v", "verbose", "Verbose output")

// 出力:
// Usage: tool -i FILE [-v] [OPTIONS]
//
// Options:
//   -h, --help      Show this help
//   -i, --input     Input file (required)
//   -v, --verbose   Verbose output
```

## バリデーション

```xojo
Sub AddOptionWithValidator(shortName As String, longName As String,
                           description As String, validator As Delegate)
```

オプション値のバリデーション。

```xojo
Function ValidatePort(value As String) As Boolean
  Var port As Integer = Integer.FromString(value)
  Return port >= 1 And port <= 65535
End Function

Var parser As New XjOption("app")
Call parser.AddOptionWithValidator("p", "port", "Port", AddressOf ValidatePort)
```
