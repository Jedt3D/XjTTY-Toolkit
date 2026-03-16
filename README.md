# XjTTY-Toolkit

A comprehensive Terminal UI (TUI) toolkit for Xojo, inspired by Ruby TTY-Toolkit, Python Prompt Toolkit, and Rust IOCraft.

## Features

XjTTY-Toolkit provides everything you need to build rich console applications in Xojo:

- **Cross-Platform**: Works on macOS, Linux, and Windows
- **63 Ready-to-Use Components**: From basic primitives to complex widgets
- **Event-Driven Architecture**: Built on a clean event loop system
- **Flexible Layout Engine**: Flexbox-like layout solver with constraints
- **13 Prompt Types**: Ask, Confirm, Password, Select, MultiSelect, EnumSelect, Expand, MultiLine, Slider, KeyPress, Suggest, and Collect
- **Rich Styling**: Colors, bold, italic, underline, inverse effects
- **YAML UI Definition**: Declarative widget tree building from markup
- **Canvas Rendering**: 2D grid with diff updates and 5 box-drawing styles
- **Keyboard & Mouse Input**: Full VT100/xterm support
- **Command Execution**: Shell command runner with timeout handling
- **Configuration Management**: Key-value config with file I/O and env overrides
- **Structured Logging**: Colored, leveled logging with JSON output support

## Project Structure

```
XjTTYToolkit/
├── App.xojo_code                 # Demo application
├── XjTTYLib/                      # Library folder containing:
│   ├── Core Modules:
│   │   ├── XjPlatform             # Platform detection
│   │   ├── XjANSI                 # ANSI escape code builders
│   │   ├── XjTerminal             # Raw mode, terminal I/O
│   │   ├── XjCursor               # Cursor control
│   │   └── XjScreen               # Screen clearing, scrolling
│   ├── Styling:
│   │   ├── XjColor                # Convenience color functions
│   │   ├── XjStyle                # Immutable style builder
│   │   └── XjCell                 # Single character + style
│   ├── Events:
│   │   ├── XjEvent                # Discriminated union events
│   │   ├── XjKeyEvent             # Key event with 31 key codes
│   │   ├── XjReader               # VT100/xterm parser
│   │   └── XjEventLoop            # Main app loop with callbacks
│   ├── Layout:
│   │   ├── XjConstraint           # Size constraints
│   │   ├── XjLayoutNode           # Layout tree node
│   │   └── XjLayoutSolver         # Stateless layout resolver
│   ├── Widgets:
│   │   ├── XjWidget               # Base widget class
│   │   ├── XjBox                  # Container widget
│   │   ├── XjText                 # Text display with wrapping
│   │   ├── XjTextInput            # Single-line input
│   │   ├── XjTable                # Table with headers
│   │   ├── XjProgressBar          # Progress bar with format tokens
│   │   ├── XjSpinner              # Animated spinners
│   │   ├── XjTree                 # Hierarchy display
│   │   └── XjFocusManager         # Focus cycling and routing
│   ├── Prompts:
│   │   ├── XjPrompt               # Facade module (13 prompt types)
│   │   ├── XjAskPrompt            # Free-form text input
│   │   ├── XjConfirmPrompt        # Yes/No confirmation
│   │   ├── XjPasswordPrompt       # Masked password input
│   │   ├── XjSelectPrompt         # Single-choice list
│   │   ├── XjMultiSelectPrompt    # Multi-choice list
│   │   ├── XjEnumSelectPrompt     # Inline numbered choice
│   │   ├── XjExpandPrompt         # Key-mapped expansion
│   │   ├── XjMultiLinePrompt      # Multi-line editor
│   │   ├── XjSliderPrompt         # Numeric slider
│   │   ├── XjKeyPressPrompt       # Wait for keypress
│   │   ├── XjSuggestPrompt        # Input with autocomplete
│   │   ├── XjCollectPrompt        # Multi-step prompt chain
│   │   ├── XjPromptStyle          # Prompt theming
│   │   ├── XjValidation           # Input validators
│   │   └── XjInlineRenderer       # Inline rendering engine
│   ├── Utilities:
│   │   ├── XjWhich                # Find executables in PATH
│   │   ├── XjLogger               # Structured logging
│   │   ├── XjPager                # Content pager with navigation
│   │   ├── XjOption               # CLI argument parser
│   │   ├── XjConfig               # Key-value configuration
│   │   ├── XjFont                 # ASCII art text (5×5 font)
│   │   ├── XjPie                  # Horizontal bar charts
│   │   ├── XjMarkdown             # Terminal markdown renderer
│   │   └── XjCommand              # Shell command execution
│   ├── YAML UI:
│   │   ├── XjYAML                 # Indentation-based YAML parser
│   │   ├── XjYAMLNode             # YAML parse tree node
│   │   └── XjUIParser             # YAML-to-widget builder
│   └── Other:
│       ├── XjCanvas               # 2D grid rendering
│       ├── XjSymbols              # Unicode/ASCII glyphs
│       └── XjConversion           # Input modifiers
├── developer-guide/               # Multilingual documentation (EN/JP/TH)
└── LICENSE                        # MIT License
```

## Quick Start

```xojo
// Basic prompt usage
Var name As String = XjPrompt.Ask("What is your name?")
Var confirmed As Boolean = XjPrompt.Confirm("Continue?")

// Select from a list
Var options() As String = Array("Option 1", "Option 2", "Option 3")
Var choice As String = XjPrompt.Select_("Choose an option", options)

// Multi-select
Var items() As String = Array("Item A", "Item B", "Item C")
Var selected() As String = XjPrompt.MultiSelect("Select items", items, 1, 2)

// Password input
Var password As String = XjPrompt.Password("Enter password")

// Slider
Var value As Integer = XjPrompt.Slider("Select value", 0, 100, 50)

// Wait for keypress
Call XjPrompt.KeyPress("Press any key to continue")

// Collect multiple answers
Var answers As Dictionary = XjPrompt.Collect()
answers.Value("name") = XjPrompt.Ask("Name:")
answers.Value("email") = XjPrompt.Ask("Email:")
answers.Value("age") = XjPrompt.Slider("Age:", 0, 120, 25)
```

## Widget System

```xojo
// Build a simple widget tree
Var mainBox As New XjBox()
mainBox.SetBorder(True).SetTitle("Demo")

Var text1 As New XjText("Hello, World!")
Var progressBar As New XjProgressBar(0, 100, 75)

mainBox.Add(text1)
mainBox.Add(progressBar)

// Create event loop and run
Var loop As New XjEventLoop(mainBox)
loop.Run()
```

## YAML UI Definition

```yaml
# ui.yaml
type: box
border: true
title: "YAML Demo"
padding: 2
children:
  - type: text
    text: "Welcome to XjTTY-Toolkit"
    style:
      fg: green
      bold: true
  - type: progress
    value: 75
    total: 100
```

```xojo
// Load and render
Var uiNode As XjYAMLNode = XjYAML.Parse("ui.yaml")
Var widget As XjWidget = XjUIParser.Build(uiNode)
Var loop As New XjEventLoop(widget)
loop.Run()
```

## Documentation

Full developer documentation is available in the `developer-guide/` directory in three languages:

- **English**: `developer-guide/src/pages/`
- **日本語**: `developer-guide/src/pages_jp/`
- **ไทย**: `developer-guide/src/pages_th/`

To build the documentation:
```bash
cd developer-guide
python3 build.py
```

Open `developer-guide/dist/index.html` in your browser.

## Requirements

- Xojo 2025r3.1 or later
- macOS 10.15+, Windows 10+, or Linux – currently tested on macOS only

## Building

1. Open `XjTTYToolkit.xojo_project` in Xojo IDE
2. Select the target platform (macOS/Windows/Linux)
3. Press Command+R (macOS) or F5 (Windows) to build and run

## Performance

All 63 components have been optimized for Big O complexity. Key optimizations include:

- String concatenation → array+join in loops (O(n) vs O(n²))
- Pre-computed lowercase values for case-insensitive matching
- Dirty-flag caching for expensive operations
- Array-based buffers for high-frequency operations
- Single-pass parsing for YAML and markdown

See `PERFORMANCE_EVAL.md` for detailed analysis.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please ensure:

1. Code follows existing patterns and conventions
2. All components maintain Big O efficiency
3. Documentation is updated for new features
4. Tests pass on all target platforms

## Acknowledgments

Inspired by:
- [Ruby TTY-Toolkit](https://github.com/piotrmurach/tty-toolkit)
- [Python Prompt Toolkit](https://github.com/prompt-toolkit/python-prompt-toolkit)
- [Rust IOCraft](https://github.com/i18n-site/rust_i18n_toolkit)

## Author

Worajedt Sitthidumrong

## Version

Version 0.7.1 - All 7 phases complete with critical macOS Tahoe heap corruption fix, parallel-array canvas optimization, and Phase 8 Kitchen Sink demo proposal
