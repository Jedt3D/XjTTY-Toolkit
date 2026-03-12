# XjTTY-Toolkit vs Ruby TTY-Toolkit — Gap Analysis

## Foundation Layer (Layer 0-3) — BUILT

| Ruby TTY Component | XjTTY Equivalent | Status | Notes |
|---|---|---|---|
| **tty-platform** | `XjPlatform` | Done | OS, arch, 64-bit detection |
| **tty-cursor** | `XjCursor` + `XjANSI` | Done | Movement, save/restore, show/hide, position query |
| **tty-screen** | `XjScreen` + `XjTerminal` | Done | Size, clear, scroll, alternate screen |
| **tty-color** | `XjTerminal.SupportsColor/ColorDepth` | Done | Detection + NO_COLOR support |
| **pastel** | `XjColor` + `XjStyle` | Done | Named colors, RGB, 256-color, chainable styles, gradient. Missing: `alias_color`, `detach` (reusable style presets) |
| **tty-reader** | `XjReader` + `XjKeyEvent` | Done | Raw key reading, VT100 parsing, UTF-8, basic readline. Missing: history, event subscriber pattern |
| **tty-which** | — | Gap | Find executables in PATH. macOS/Linux: `which`, Windows CMD: `where`, PowerShell: `Get-Command`. Can also implement pure Xojo by scanning PATH env var. |
| *(no equivalent)* | `XjCanvas` + `XjCell` | Done | 2D render buffer — Ruby TTY doesn't have this (from IOCraft) |

## Planned vs Ruby TTY — Component-by-Component

| Ruby TTY Component | XjTTY Plan | Status | Gap Details |
|---|---|---|---|
| **tty-prompt** (13 prompt types) | Phase 4: `XjPrompt` | Planned | Full 13 types below |
| **tty-table** | Phase 3: `XjTable` | Planned | Ruby has: 3 renderers (basic/ascii/unicode), alignment, column widths, padding, resize, multiline cells, filter |
| **tty-progressbar** | Phase 3: `XjProgressBar` | Planned | Ruby has: format tokens (`:bar :percent :eta :rate`), multi-bar with tree display, indeterminate mode, events |
| **tty-spinner** | Phase 3: `XjSpinner` | Planned | Ruby has: 30+ animation formats, multi-spinner tree, auto_spin thread, success/error marks |
| **tty-box** | Phase 3: `XjBox` | Planned | Ruby has: absolute positioning, title (top/bottom), 3 border styles, padding, alignment, semantic presets (info/warn/success/error). `XjCanvas.DrawBox` covers basic borders |
| **tty-tree** | Phase 3: `XjTree` | Planned | Directory/hierarchy tree display with node/leaf DSL, numbered format |
| **tty-font** | Phase 5: `XjFont` | Planned | Large ASCII art text (doom, block, starwars, etc.) |
| **tty-pie** | Phase 5: `XjPie` | Planned | Terminal pie charts with legend |
| **tty-markdown** | Phase 5: `XjMarkdown` | Planned | Render markdown in terminal (headers, lists, code blocks, tables, syntax highlighting) |
| **tty-logger** | Phase 5: `XjLogger` | Planned | Structured colored logging with levels, formatters (text/json), handlers, filters, metadata |
| **tty-link** | `XjANSI.Hyperlink` | Done | OSC 8 hyperlinks. Missing: terminal capability detection for link support |
| **tty-pager** | Phase 5: `XjPager` | Planned | Content paging (system pager / pure-Xojo fallback) |
| **tty-command** | Phase 5: `XjCommand` | Planned | Shell command execution with printers, dry-run, timeout |
| **tty-file** | — | Deferred | File manipulation (inject, diff, download, template) — Xojo has FolderItem already |
| **tty-config** | Phase 5: `XjConfig` | Planned | App configuration (YAML/JSON read/write, validation, env vars, aliases) |
| **tty-option** | Phase 5: `XjOption` | Planned | CLI argument parser with declarative DSL, help generation |

## XjPrompt — Full 13 Prompt Types

| # | Ruby TTY Method | XjPrompt Method | Description |
|---|---|---|---|
| 1 | `ask` | `Ask()` | Free-form text input — default value, validation (regex/proc), type conversion (`:int`, `:float`, `:bool`, `:date`, etc.), input modifiers (`:up`, `:down`, `:strip`) |
| 2 | `yes?` | `Confirm()` | Boolean yes/no — configurable default `(Y/n)` or `(y/N)` |
| 3 | `no?` | `Deny()` | Boolean no/yes — inverse default of Confirm |
| 4 | `mask` | `Password()` | Secret input — displays bullets instead of characters |
| 5 | `select` | `Select()` | Single-choice menu — arrow key navigation, filtering, pagination, disabled items |
| 6 | `multi_select` | `MultiSelect()` | Multiple-choice — space to toggle, min/max count, filtering |
| 7 | `enum_select` | `EnumSelect()` | Numbered list — type number to choose |
| 8 | `expand` | `Expand()` | Compact key-based menu — single-key selection with `h` for help expansion |
| 9 | `collect` | `Collect()` | Structured data gathering — builds nested Dictionary from multiple prompts |
| 10 | `multiline` | `MultiLine()` | Multi-line text — Ctrl+D to finish, returns array of lines |
| 11 | `slider` | `Slider()` | Numeric range — arrow keys to slide between min/max with step |
| 12 | `keypress` | `KeyPress()` | Single key capture — optional timeout |
| 13 | `suggest` | `Suggest()` | Auto-completion input — fuzzy matching against word list |

### Output helpers

| Ruby TTY | XjPrompt | Purpose |
|---|---|---|
| `say` | `Say()` | Neutral output |
| `ok` | `Ok()` | Green success message |
| `warn` | `Warn()` | Yellow warning message |
| `error` | `Error_()` | Red error message |

### Supporting systems each prompt relies on

| System | What it does | Priority |
|---|---|---|
| **Conversion** | `:int`, `:float`, `:bool`, `:date`, `:list`, `:map`, custom lambda | High — used by `Ask` |
| **Validation** | Regex, proc, range, required | High — used by `Ask`, `Collect` |
| **Input modifiers** | `:up`, `:down`, `:capitalize`, `:strip`, `:chomp` | Medium |
| **Pagination** | Auto-paginate long lists with `per_page` | High — used by `Select`, `MultiSelect` |
| **Filtering** | Type-to-filter in menus | High — used by `Select`, `MultiSelect` |
| **Symbols config** | Custom marker `>`, check mark, cross mark | Medium |
| **Color config** | `active_color`, `help_color` | Medium |

## Unique to XjTTY (Not in Ruby TTY)

These come from IOCraft and Prompt Toolkit:

| Component | Source Inspiration | Purpose |
|---|---|---|
| `XjCanvas` (2D render buffer) | IOCraft Canvas | Cell-based rendering with diff |
| `XjLayoutNode` / flexbox layout | IOCraft/taffy | Declarative layout |
| `XjWidget` base + component tree | IOCraft components | Composable UI widgets |
| `XjEventLoop` (app loop) | IOCraft render_loop | Main loop with timer refresh |
| Fuzzy/Nested/Path completers | Prompt Toolkit | Advanced autocompletion |
| YAML UI definition | Our design | Declarative UI from markup |

## Summary Scorecard

| Category | Ruby TTY | XjTTY Done | XjTTY Planned | Gaps |
|---|---|---|---|---|
| Platform/Terminal | 5 | 4 | 1 (which) | 0 |
| Input | 3 (reader, prompt, option) | 1 | 2 | 0 |
| Display/Widgets | 9 | 1 (link) | 8 | 0 |
| System/IO | 3 (command, file, pager) | 0 | 2 | 1 (file — deferred, Xojo has FolderItem) |
| Config/Styling | 2 (config, pastel) | 1 | 1 | 0 |
| **Totals** | **22** | **7** | **14** | **1 deferred** |

## Implementation Phases

### Phase 1: Event System & App Loop
- XjEventLoop — Main loop, timer refresh, resize detection
- XjEvent — Base event class (key, mouse, resize, custom)
- XjEventEmitter — Observer pattern for event dispatch

### Phase 2: Layout Engine
- XjLayoutNode — Flexbox-like layout tree node
- XjConstraint — Size constraints (fixed, percent, min/max, auto)
- XjLayoutSolver — Compute positions/sizes

### Phase 3: Widget System
- XjWidget (base), XjBox, XjText, XjTextInput
- XjTable, XjProgressBar, XjSpinner, XjTree

### Phase 4: Full Prompt System
- XjPrompt — All 13 prompt types
- Conversion, validation, pagination, filtering systems
- XjCompleter — Word, Fuzzy, Nested, Path completers (powers Suggest)

### Phase 5: Utility Modules
- XjWhich, XjLogger, XjPager, XjOption, XjConfig
- XjFont, XjPie, XjMarkdown (nice-to-have)

### Phase 6: YAML UI Definition
- XjUIParser — Parse YAML-like syntax to widget trees
