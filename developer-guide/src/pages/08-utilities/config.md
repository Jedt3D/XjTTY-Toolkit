---
title: Configuration
description: XjConfig provides key-value configuration with file I/O, environment variable overrides, and type conversion.
---

# Configuration

The **XjConfig** class manages application configuration with file loading/saving, environment variable overrides, and type-safe access.

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `Set(key, value)` | String key, String value | — | Set configuration value |
| `Get(key)` | String | String | Get value (empty if not found) |
| `GetDefault(key, default)` | String key, value | String | Get with fallback |
| `Has(key)` | String | Boolean | Check if key exists |
| `Remove(key)` | String | — | Delete key |
| `Count()` | — | Integer | Get number of entries |
| `Keys()` | — | String() | Get all keys |
| `GetInteger(key)` | String | Integer | Get as integer |
| `GetBoolean(key)` | String | Boolean | Get as boolean |
| `SetEnvPrefix(prefix)` | String | — | Set env var prefix for overrides |
| `LoadFromFile(path)` | String | Boolean | Load config file |
| `SaveToFile(path)` | String | Boolean | Save config file |
| `Merge(other)` | XjConfig | — | Merge another config |

## File Formats

Supports simple key=value format:

```
# Comments start with #
database.host=localhost
database.port=5432
database.name=myapp
debug=true
log.level=info
```

## Examples

### Basic configuration

```xojo
Var config As New XjConfig()
Call config.Set("app.name", "MyApp")
Call config.Set("app.version", "1.0.0")
Call config.Set("debug", "false")

Var appName As String = config.Get("app.name")
Var debug As Boolean = config.GetBoolean("debug")
```

### Load from file

```xojo
Var config As New XjConfig()

If config.LoadFromFile("/etc/myapp/config.ini") Then
  XjPrompt.Ok("Config loaded")
Else
  XjPrompt.Error_("Failed to load config")
End If

Var dbHost As String = config.Get("database.host")
Var dbPort As Integer = config.GetInteger("database.port")
```

### Environment variable overrides

```xojo
Var config As New XjConfig()
Call config.Set("database.host", "localhost")
Call config.Set("database.port", "5432")

// Allow env var overrides with MYAPP_ prefix
Call config.SetEnvPrefix("MYAPP_")

// If environment has MYAPP_DATABASE_HOST=prod.example.com
// it will override the config file value
Var host As String = config.Get("database.host")  // Returns env var if set
```

### Save configuration

```xojo
Var config As New XjConfig()
Call config.Set("username", "alice")
Call config.Set("theme", "dark")
Call config.Set("notifications", "true")

If config.SaveToFile(GetConfigPath()) Then
  XjPrompt.Ok("Config saved")
Else
  XjPrompt.Error_("Failed to save config")
End If
```

### Merge configurations

```xojo
Var defaultConfig As New XjConfig()
Call defaultConfig.Set("theme", "light")
Call defaultConfig.Set("font_size", "12")
Call defaultConfig.Set("autosave", "true")

Var userConfig As New XjConfig()
Call userConfig.LoadFromFile(userConfigPath)

// User config overrides defaults
Call defaultConfig.Merge(userConfig)
```

### Type conversion

```xojo
Var config As New XjConfig()
Call config.Set("port", "8080")
Call config.Set("verbose", "yes")
Call config.Set("timeout", "30000")

Var port As Integer = config.GetInteger("port")  // 8080
Var verbose As Boolean = config.GetBoolean("verbose")  // true (accepts "yes", "true", "1")
Var timeout As Integer = config.GetInteger("timeout")  // 30000
```

### Query all settings

```xojo
Var config As New XjConfig()
Call config.LoadFromFile("config.ini")

XjPrompt.Say("Configuration (" + config.Count().ToString() + " settings):")

Var keys As String() = config.Keys()
For Each key As String In keys
  XjPrompt.Say(key + " = " + config.Get(key))
Next
```

### Default values

```xojo
Var config As New XjConfig()
Call config.LoadFromFile("optional_config.ini")

// Provide defaults for missing keys
Var dbHost As String = config.GetDefault("database.host", "localhost")
Var dbPort As Integer = Int(config.GetDefault("database.port", "5432"))
Var workers As Integer = Int(config.GetDefault("worker.count", "4"))
```

## File Format Example

```ini
# Application settings
app.name=MyApp
app.version=1.0.0
app.debug=false

# Database configuration
db.host=localhost
db.port=5432
db.name=myapp
db.user=admin
db.timeout=30

# Logging
log.level=info
log.file=/var/log/myapp.log

# Feature flags
feature.newUI=true
feature.experimental=false
```

## Design notes

**File format**: Simple key=value, one per line. Lines starting with # are comments.

**Environment overrides**: SetEnvPrefix() enables environment variable overrides. With prefix "MYAPP_", setting "db.host" checks env var "MYAPP_DB_HOST".

**Type safety**: GetInteger() and GetBoolean() parse strings. Non-numeric strings return 0; non-boolean return false.

**Merging**: Merge() overwrites keys from source. Use for layering (defaults + user config + environment).

**Hierarchical keys**: Dots separate levels ("db.host" is valid). No special meaning; purely for organization.

!!! note
    XjConfig is designed for application configuration. For command-line arguments, use XjOption instead.
