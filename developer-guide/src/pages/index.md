---
title: Introduction
description: XjTTY-Toolkit is a comprehensive Terminal UI (TUI) library for Xojo, inspired by Ruby TTY-Toolkit, Python Prompt Toolkit, and Rust IOCraft.
---

# Introduction

**XjTTY-Toolkit** is a full-featured Terminal UI (TUI) library for Xojo console applications. It provides everything needed to build rich, interactive terminal interfaces — from low-level ANSI escape codes to high-level prompt dialogs and widget-based layouts.

The toolkit is inspired by **Ruby's TTY-Toolkit**, **Python's Prompt Toolkit**, and **Rust's IOCraft**, adapted for Xojo's language features and cross-platform capabilities.

## Architecture overview

The library is organized in layers, each building on the one below:

| Layer | Components | Purpose |
|-------|-----------|---------|
| **Core** | XjPlatform, XjANSI, XjTerminal, XjColor, XjCursor, XjScreen | Platform detection, raw terminal I/O, ANSI escape codes |
| **Styling** | XjStyle, XjCell, XjCanvas, XjSymbols | Immutable style builder, character cells, 2D rendering grid |
| **Events** | XjKeyEvent, XjEvent, XjEventLoop, XjReader | Keyboard/mouse parsing, main loop with tick/resize callbacks |
| **Layout** | XjConstraint, XjLayoutNode, XjLayoutSolver | Flexbox-like constraint-based layout engine |
| **Widgets** | XjWidget, XjBox, XjText, XjTextInput, XjTable, XjProgressBar, XjSpinner, XjTree, XjFocusManager | Paintable UI components with focus management |
| **Prompts** | XjPrompt, XjAskPrompt, XjConfirmPrompt, XjSelectPrompt, ... (13 types) | Interactive inline prompt dialogs |
| **Utilities** | XjLogger, XjOption, XjConfig, XjCommand, XjPager, XjFont, XjPie, XjMarkdown, XjHistory | CLI helpers, logging, configuration, display utilities |
| **YAML UI** | XjYAML, XjYAMLNode, XjUIParser | Declarative UI definition from YAML markup |

## 63 components

The library contains 63 carefully designed components across 7 development phases. All have been analyzed and optimized for Big O performance.

## Platform support

XjTTY-Toolkit runs on **macOS**, **Linux**, and **Windows**. Platform-specific code (termios vs Win32) is handled internally by XjPlatform and XjTerminal.

## Quick start

```xojo
// Simple colored output
XjTerminal.Write(XjColor.Green("Hello, ") + XjColor.BoldText("World!") + XjANSI.Reset())

// Interactive prompt
Var name As String = XjPrompt.Ask("What is your name?")
XjPrompt.Ok("Welcome, " + name + "!")

// Confirmation
If XjPrompt.Confirm("Continue?") Then
  XjPrompt.Say("Let's go!")
End If
```

## What's in this guide

| Section | What you'll learn |
|---------|-------------------|
| [Platform Detection](core/platform.html) | Cross-platform OS and architecture detection |
| [ANSI Escape Codes](core/ansi.html) | Low-level terminal control sequences |
| [Terminal Control](core/terminal.html) | Raw mode, terminal size, byte-level I/O |
| [Colors](core/color.html) | Convenience color functions, gradients, semantic colors |
| [Cursor](core/cursor.html) | Cursor movement and visibility |
| [Screen](core/screen.html) | Screen clearing, scrolling, fullscreen, drawing |
| [XjStyle](styling/style.html) | Immutable style builder with fluent API |
| [Cell & Canvas](styling/cell-canvas.html) | Character cells and 2D rendering grid |
| [Symbols](styling/symbols.html) | Unicode/ASCII glyph sets |
| [Key Events](events/key-event.html) | Keyboard event representation |
| [Event System](events/event.html) | Discriminated union for all event types |
| [Event Loop](events/event-loop.html) | Main application loop |
| [Input Reader](events/reader.html) | VT100/xterm escape sequence parser |
| [Constraints](layout/constraint.html) | Size constraints for layout |
| [Layout Nodes](layout/layout-node.html) | Flexbox-like layout tree |
| [Layout Solver](layout/solver.html) | Stateless layout computation |
| [Widgets](widgets/widget.html) | Base widget class |
| [Box & Text](widgets/box-text.html) | Container and text display widgets |
| [TextInput](widgets/text-input.html) | Single-line text input widget |
| [Table](widgets/table.html) | Tabular data display |
| [ProgressBar & Spinner](widgets/progress-spinner.html) | Progress indicators |
| [Tree](widgets/tree.html) | Hierarchical tree display |
| [Focus Manager](widgets/focus-manager.html) | Tab-based focus cycling |
| [Prompt Facade](prompts/facade.html) | Top-level prompt API |
| [Text Prompts](prompts/text-prompts.html) | Ask, Password, MultiLine, Suggest |
| [Selection Prompts](prompts/selection-prompts.html) | Select, MultiSelect, EnumSelect, Expand |
| [Special Prompts](prompts/special-prompts.html) | Confirm, Slider, KeyPress, Collect |
| [Styling & Validation](prompts/styling-validation.html) | Prompt themes and input validation |
| [Logger](utilities/logger.html) | Structured colored logging |
| [CLI Options](utilities/options.html) | Argument parser with auto help |
| [Configuration](utilities/config.html) | Key-value config with file I/O |
| [Commands & Pager](utilities/commands.html) | Shell execution and content paging |
| [Font, Pie & Markdown](utilities/display.html) | ASCII art, charts, markdown rendering |
| [YAML Parser](yaml/parser.html) | Simple YAML parser |
| [UI Builder](yaml/ui-builder.html) | YAML-to-widget-tree builder |

## Getting started

Start with [Platform Detection](core/platform.html) to understand how the toolkit detects your environment, then explore [ANSI Escape Codes](core/ansi.html) for low-level terminal control. For interactive applications, jump to [Prompts](prompts/facade.html) or [Event Loop](events/event-loop.html).
