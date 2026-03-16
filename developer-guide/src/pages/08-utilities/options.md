---
title: CLI Options
description: XjOption provides argument parsing with auto-generated help, flags, options, and positional arguments.
---

# CLI Options

The **XjOption** class parses command-line arguments with support for short flags (-h), long options (--help), and positional arguments. It auto-generates help text.

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddOption(name, short, desc)` | String name, short, desc | — | Add option (--name value) |
| `AddFlag(name, short, desc)` | String name, short, desc | — | Add boolean flag (--flag) |
| `AddArgument(name, desc)` | String name, desc | — | Add positional argument |
| `Parse(args)` | String() | Boolean | Parse arguments (returns success) |
| `GetString(name)` | String | String | Get option value |
| `GetFlag(name)` | String | Boolean | Get flag state |
| `GetInteger(name)` | String | Integer | Get integer option |
| `Has(name)` | String | Boolean | Check if option was provided |
| `Help()` | — | String | Generate help text |

## Examples

### Basic argument parser

```xojo
Var opts As New XjOption()
Call opts.AddOption("input", "i", "Input file path")
Call opts.AddOption("output", "o", "Output file path")
Call opts.AddFlag("verbose", "v", "Enable verbose output")
Call opts.AddArgument("command", "Command to execute")

Var args As String() = CommandLine.Arguments
If Not opts.Parse(args) Then
  XjPrompt.Error_(opts.Help())
  Return
End If

Var input As String = opts.GetString("input")
Var output As String = opts.GetString("output")
Var verbose As Boolean = opts.GetFlag("verbose")
Var command As String = opts.GetString("command")
```

### Usage with defaults

```xojo
Var opts As New XjOption()
Call opts.AddOption("level", "l", "Log level (0-4)")
Call opts.AddFlag("color", "c", "Enable colors")
Call opts.AddFlag("json", "j", "JSON output")

Call opts.Parse(CommandLine.Arguments)

Var level As Integer = 1  // Default
If opts.Has("level") Then
  level = opts.GetInteger("level")
End If

Var useColor As Boolean = Not opts.GetFlag("color")  // Default: true unless disabled
Var useJSON As Boolean = opts.GetFlag("json")  // Default: false
```

### Print help

```xojo
Var opts As New XjOption()
Call opts.AddOption("config", "c", "Config file path")
Call opts.AddFlag("help", "h", "Show this help message")
Call opts.AddArgument("action", "Action to perform")

If opts.GetFlag("help") Then
  XjPrompt.Say(opts.Help())
  Return
End If
```

### Validate required options

```xojo
Var opts As New XjOption()
Call opts.AddOption("name", "n", "User name (required)")
Call opts.AddOption("email", "e", "Email address (required)")

Call opts.Parse(CommandLine.Arguments)

If Not opts.Has("name") Or Not opts.Has("email") Then
  XjPrompt.Error_("Missing required options: --name, --email")
  XjPrompt.Say(opts.Help())
  Return
End If
```

### Advanced example

```xojo
Class CLI
  Sub Run()
    Var opts As New XjOption()

    // Define options
    Call opts.AddOption("host", "h", "Server host (default: localhost)")
    Call opts.AddOption("port", "p", "Server port (default: 8080)")
    Call opts.AddFlag("verbose", "v", "Verbose logging")
    Call opts.AddFlag("ssl", "s", "Use HTTPS")
    Call opts.AddArgument("command", "Command (start|stop|restart)")

    // Parse
    If Not opts.Parse(CommandLine.Arguments) Then
      ShowError(opts.Help())
      Return
    End If

    // Get values with defaults
    Var host As String = opts.GetString("host")
    If host.IsEmpty Then host = "localhost"

    Var port As Integer = opts.GetInteger("port")
    If port = 0 Then port = 8080

    Var verbose As Boolean = opts.GetFlag("verbose")
    Var useSSL As Boolean = opts.GetFlag("ssl")
    Var command As String = opts.GetString("command")

    // Process command
    Select Case command
      Case "start"
        StartServer(host, port, useSSL, verbose)
      Case "stop"
        StopServer(host, port)
      Case "restart"
        StopServer(host, port)
        StartServer(host, port, useSSL, verbose)
      Case Else
        ShowError("Unknown command: " + command)
    End Select
  End Sub
End Class
```

## Help Output Example

```
Usage: myapp [OPTIONS] COMMAND

Arguments:
  COMMAND              Command to execute

Options:
  -h, --host STRING    Server host
  -p, --port INTEGER   Server port
  -v, --verbose        Verbose logging
  -s, --ssl            Use HTTPS
  --help               Show this help message
```

## Design notes

**Naming**: Option names can be accessed by full name (e.g., "input") or shortcut (e.g., "i").

**Syntax**:
- Options take values: `--name value` or `-n value`
- Flags are boolean: `--verbose` or `-v` (presence means True)
- Arguments are positional: `command arg1 arg2`

**Defaults**: Options/flags default to empty string or False. Check Has() or provide explicit defaults.

**Help generation**: Help() auto-generates text from option descriptions. Keep descriptions concise.

**Type conversion**: GetInteger() parses string to integer. GetString() returns raw value.

!!! note
    For complex CLI applications, XjOption provides basic parsing. For advanced features (subcommands, environment variables, config files), integrate XjConfig and XjCommand modules.
