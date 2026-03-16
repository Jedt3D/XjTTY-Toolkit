---
title: Platform Detection
description: XjPlatform module provides cross-platform OS and architecture detection for macOS, Linux, and Windows.
---

# Platform Detection

The **XjPlatform** module detects your operating system and architecture at runtime, enabling platform-specific code paths and feature detection.

## Methods

| Method | Return Type | Description |
|--------|------------|-------------|
| `IsWindows()` | Boolean | Returns True if running on Windows |
| `IsMacOS()` | Boolean | Returns True if running on macOS |
| `IsLinux()` | Boolean | Returns True if running on Linux |
| `IsUnix()` | Boolean | Returns True if running on Unix-like system (macOS or Linux) |
| `Is64Bit()` | Boolean | Returns True if running 64-bit architecture |
| `IsARM()` | Boolean | Returns True if running on ARM architecture (Apple Silicon, etc.) |
| `OSName()` | String | Returns human-readable OS name ("Windows", "macOS", "Linux") |
| `Architecture()` | String | Returns architecture string ("x86_64", "aarch64", "arm64", etc.) |
| `PlatformInfo()` | String | Returns detailed platform string ("macOS 14.2 arm64", etc.) |

## Examples

### Basic platform detection

```xojo
If XjPlatform.IsWindows() Then
  XjTerminal.Write("Running on Windows")
ElseIf XjPlatform.IsMacOS() Then
  XjTerminal.Write("Running on macOS")
ElseIf XjPlatform.IsLinux() Then
  XjTerminal.Write("Running on Linux")
End If
```

### Platform-specific feature initialization

```xojo
Var useUnicode As Boolean = Not XjPlatform.IsWindows()
If useUnicode Then
  XjSymbols.UseUnicode()
Else
  XjSymbols.UseASCII()
End If
```

### Display system information

```xojo
XjTerminal.Write("Platform: " + XjPlatform.PlatformInfo())
XjTerminal.Write("OS: " + XjPlatform.OSName())
XjTerminal.Write("Architecture: " + XjPlatform.Architecture())
XjTerminal.Write("64-bit: " + XjPlatform.Is64Bit().ToString())
```

### Conditional logging

```xojo
If XjPlatform.IsUnix() Then
  // Use Unix-specific paths
  Var logPath As String = "/var/log/myapp.log"
Else
  // Use Windows paths
  Var logPath As String = "C:\Logs\myapp.log"
End If
```

## Design notes

XjPlatform caches detection results at module initialization time for performance. Detection happens automatically on first use; you don't need to initialize anything explicitly.

Platform detection is used internally by other modules (XjTerminal, XjScreen, XjANSI) to select the appropriate implementation. In most cases, you won't call XjPlatform directly — it works behind the scenes.
