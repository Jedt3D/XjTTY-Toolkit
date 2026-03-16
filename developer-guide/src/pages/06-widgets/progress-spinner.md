---
title: ProgressBar & Spinner Widgets
description: XjProgressBar shows progress with format tokens; XjSpinner provides animated loading indicators.
---

# ProgressBar & Spinner

The **XjProgressBar** widget displays progress with customizable format, animated bar, and indeterminate mode. The **XjSpinner** widget shows rotating activity indicators.

## XjProgressBar

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetValue(value)` | Integer | — | Set current progress (0-100 or custom max) |
| `SetTotal(total)` | Integer | — | Set total value (for calculations) |
| `SetFormat(fmt)` | String | — | Set format string with tokens |
| `SetBarChars(empty, fill)` | String × 2 | — | Set bar characters |
| `SetIndeterminate(enable)` | Boolean | — | Enable bouncing animation |

### Format Tokens

| Token | Description |
|-------|-------------|
| `:bar` | Progress bar (animated fill) |
| `:percent` | Percentage (0-100) |
| `:current` | Current value |
| `:total` | Total value |
| `:eta` | Estimated time remaining |

### Examples

```xojo
Var progress As New XjProgressBar()
Call progress.SetValue(50)
Call progress.SetTotal(100)
Call progress.SetFormat(":bar :percent")

// Animate progress
For i As Integer = 0 To 100
  Call progress.SetValue(i)
  Redraw()
  System.Sleep(100)
Next
```

### Indeterminate progress

```xojo
Var spinner As New XjProgressBar()
Call spinner.SetIndeterminate(True)
Call spinner.SetFormat("Loading... :bar")

// The bar bounces back and forth
While isLoading
  Redraw()
  System.Sleep(50)
Wend
```

### Custom format

```xojo
Var progress As New XjProgressBar()
Call progress.SetValue(75)
Call progress.SetTotal(100)
Call progress.SetFormat("[ETA: :eta] :bar :percent")
```

## XjSpinner

### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetMessage(msg)` | String | — | Set spinner message |
| `SetInterval(ms)` | Integer | — | Set frame interval (milliseconds) |
| `SetFormat(fmt)` | Integer format | — | Set spinner format (0-12+) |
| `Success()` | — | — | Show success mark and stop |
| `Error_()` | — | — | Show error mark and stop |
| `GetFrame()` | — | String | Get current frame |

### Spinner Formats

| Format | Type | Description |
|--------|------|-------------|
| 0 | dots | Animated dots (. .. ...) |
| 1 | line | Rotating line (\| / - \) |
| 2 | arc | Rotating arc (◜ ◠ ◝ ◞) |
| 3 | star | Rotating star |
| 4 | bounce | Bouncing ball |
| 5 | square | Rotating square |
| 6 | circle | Rotating circle |
| 7+ | Additional formats | Various animations |

### Examples

```xojo
Var spinner As New XjSpinner()
Call spinner.SetMessage("Loading files...")
Call spinner.SetFormat(0)  // Dots format
Call spinner.SetInterval(100)

While isLoading
  XjTerminal.Write(XjCursor.SavePosition())
  XjTerminal.Write(spinner.GetFrame() + " " + spinner.GetMessage())
  XjTerminal.Write(XjCursor.Restore())

  System.Sleep(spinner.GetInterval())
Wend

Call spinner.Success()  // Show checkmark
```

### Completion indicators

```xojo
Var spinner As New XjSpinner()
Call spinner.SetMessage("Processing...")
Call spinner.SetFormat(0)

Try
  DoHeavyWork()
  Call spinner.Success()  // Green checkmark
Catch err As Exception
  Call spinner.Error_()   // Red X mark
End Try
```

### Multiple spinners

```xojo
Var spinner1 As New XjSpinner()
Call spinner1.SetMessage("Task 1")
Call spinner1.SetFormat(1)  // Line format

Var spinner2 As New XjSpinner()
Call spinner2.SetMessage("Task 2")
Call spinner2.SetFormat(2)  // Arc format

While tasksRunning
  XjTerminal.Write(spinner1.GetFrame() + " " + spinner1.GetMessage())
  XjTerminal.Write(spinner2.GetFrame() + " " + spinner2.GetMessage())
  System.Sleep(100)
Wend
```

## Design notes

**ProgressBar**: The :bar token shows a visual progress bar. Frame-by-frame animation requires calling Redraw() regularly.

**ETA calculation**: The :eta token estimates remaining time based on SetTotal() and progress rate.

**Spinner updates**: Call GetFrame() to get the current animation frame. Advance frames manually or let the interval control timing.

**Success/Error**: Call spinner.Success() or spinner.Error_() to complete with a visual indicator.

**Format selection**: Dots and line formats work everywhere. Unicode formats (arc, star) require terminal support.

!!! note
    For inline progress in prompts, use XjProgressBar with SetIndeterminate(True). For full-screen spinners, use XjEventLoop with tick-based frame updates.
