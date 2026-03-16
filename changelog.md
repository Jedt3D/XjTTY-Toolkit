# Changelog

All notable changes to XjTTY-Toolkit will be documented in this file.

## [0.7.1] - 2026-03-17

### Fixed
- **CRITICAL: Heap corruption on macOS Tahoe** — XjCell and XjLayoutNode refactored to use shared static style instances and eliminate per-frame allocations. macOS xzone malloc was corrupting XjStyle pointers when allocating >100k objects/second (4800 cells × 30fps), causing SIGSEGV in heap operations. Now uses pattern: never dereference before replacement, cache statics for border/title styles, share style references instead of cloning.
- **XjCell.SetStyle** — no longer clones or dereferences mStyle; always replaces reference with static default or source style
- **XjLayoutNode.PaintSelf** — caches border and title XjStyle objects in static variables to avoid per-frame allocation

### Changed
- **XjCanvas refactored to parallel arrays** — XjCanvas now stores characters and styles in separate mChars/mStyles arrays instead of wrapping them in XjCell objects, reducing object allocation overhead and improving render throughput
- **DiffRender optimized** — updated to work directly with character/style arrays instead of XjCell dereferences

### Added
- **KITCHEN_SINK_PROPOSAL.md** — Comprehensive Phase 8 demo application proposal: 31 interactive/static components across 6 categories, live previews with keyboard interaction, search filtering, properties panel, help overlay
- **xojo skill updates** (contributed to ~/.claude/skills/xojo/SKILL.md):
  - **Section 8.3: Render Loop Optimization Patterns** — 4 critical patterns for 30fps TUI at 57,600+ alloc/sec: parallel arrays, static shared instances, never-dereference-before-replacement, per-row string building
  - **Section 9: Enhanced Unicode Construction** — improved red flag pattern with why/how/examples for UTF-8 vs code point confusion (fixes bug from commit 02552ff)
  - **Section 10: Overlay Mockup Pattern** — new pattern for blocking prompts in event-loop TUI using state-machine overlays instead of Run()

## [0.7.0] - 2026-03-13

### Added
- **XjCommand**: Shell command execution module with timeout support and result capture
- **XjCommandResult**: Shell output container with exit code, output text, timed-out flag, Lines() helper
- **XjHistory**: Input history class with Previous/Next navigation, duplicate suppression, max size limit
- **PERFORMANCE_EVAL.md**: Comprehensive Big O analysis of all 63 components with optimization recommendations

### Changed
- **Performance optimization** — 26 of 63 components improved across 4 passes:
  - B/B+ pass (7): XjCanvas, XjProgressBar, XjFont, XjTree, XjPie, XjLogger, XjScreen — loop-invariant hoisting, dirty-flag caching, pre-computed data
  - C pass (7): XjStyle, XjOption, XjAskPrompt, XjPasswordPrompt, XjPrompt, XjTextInput, XjYAML — string concat → array+join, RemoveAll, cached lowercase
  - D pass (10): XjANSI, XjSelectPrompt, XjMultiSelectPrompt, XjCompleter, XjMultiLinePrompt, XjTable, XjText, XjYAMLNode, XjUIParser — forward-pass regex, pre-computed lowercase, array-based buffers
  - F pass (2): XjMarkdown (multi-pass → single-pass scanner), XjReader ReadLine (string rebuild → array buffer)
- **GAP_ANALYSIS.md** renamed from gap-analysis.md (uppercase convention)
- **App demo** updated to Polish phase features showcase

## [0.6.0] - 2026-03-13

### Added
- **XjYAMLNode**: YAML parse tree node with key/value/children, typed getters (StringValue, IntValue, BoolValue), ChildrenWithKey for duplicate keys, and Dump for debugging
- **XjYAML**: Indentation-based YAML parser — supports key:value mappings, nested structures, sequences (- prefix), comments (#), and quoted string values
- **XjUIParser**: Declarative UI builder — maps YAML to widget trees, supports box/text/textinput/table/progressbar/spinner, with constraint parsing (auto, 50%, fixed, min-max), border styles (single/double/round/bold/ascii), named colors, and alignment
- **Phase 6 demo**: End-to-end pipeline showing YAML source → parsed tree → widget tree → rendered canvas output
- **All 6 phases complete** — XjTTY-Toolkit is feature-complete per the gap-analysis roadmap

## [0.5.0] - 2026-03-12

### Added
- **XjWhich**: Find executables in system PATH — Which(), WhichAll(), Exists()
- **XjLogger**: Structured colored logger with DEBUG/INFO/WARN/ERROR/FATAL levels, JSON format, timestamps, metadata
- **XjPager**: Built-in content pager with keyboard navigation (SPACE=next page, q=quit, Down=scroll)
- **XjOption**: CLI argument parser with short/long flags, options with defaults, positional arguments, auto-generated help text
- **XjConfig**: Key-value configuration store with file I/O (INI-like format), environment variable overrides, typed getters, merge support
- **XjFont**: ASCII art text rendering using 5×5 block font — supports A-Z, 0-9, punctuation, with optional XjStyle coloring
- **XjPie**: Horizontal bar chart with colored segments and legend — AddSlice/Draw API
- **XjMarkdown**: Terminal markdown renderer — headers, **bold**, *italic*, `code`, lists, code blocks, horizontal rules
- **Phase 5 demo**: Non-interactive demo showcasing all 8 utility modules

### Fixed
- Use `DateTime.Now` instead of `New DateTime` (Xojo constructor requires parameters)
- XjStyle setter methods take no boolean params (`SetBold` not `SetBold(True)`) — break 3+ level chains into temp vars

## [0.4.0] - 2026-03-12

### Added
- **XjSymbols**: Unicode/ASCII glyph module with lazy initialization (check, cross, pointer, radio, question mark, etc.)
- **XjPromptStyle**: Theming class for prompts with configurable prefix, question, answer, cursor, error, and help styles
- **XjValidation**: Input validator class with factory methods — Required, MinLength, MaxLength, Pattern, Custom
- **XjConversion**: Input modifier module — Uppercase, Lowercase, Capitalize, Trim, Number
- **XjInlineRenderer**: Cursor-based inline rendering engine — manages raw mode, cursor-up/erase-line redraws, settled state output
- **XjCompleter**: Autocomplete engine with prefix and substring matching, word list or custom callback
- **XjPrompt**: Facade module — single entry point for all 13 prompt types plus Say/Ok/Warn/Error_ output helpers
- **XjAskPrompt**: Free-form text input with cursor navigation, validation, input modifiers, escape to cancel
- **XjConfirmPrompt**: Yes/No confirmation with configurable default
- **XjPasswordPrompt**: Masked input with optional custom mask character
- **XjSelectPrompt**: Arrow-key list selection with pagination, type-to-filter
- **XjMultiSelectPrompt**: Multi-choice list with space toggle, min/max count enforcement
- **XjEnumSelectPrompt**: Inline numbered choice selection
- **XjExpandPrompt**: Key-mapped choice expansion (y/n/d style)
- **XjMultiLinePrompt**: Multi-line text editor with Ctrl+D to finish
- **XjSliderPrompt**: Numeric slider with arrow keys, configurable step and range
- **XjKeyPressPrompt**: Single keypress capture with optional timeout
- **XjSuggestPrompt**: Text input with autocomplete dropdown
- **XjCollectPrompt**: Multi-step prompt chain collecting key-value answers
- **Phase 4 demo**: Inline prompt demo exercising Ask, Confirm, Password, Select, MultiSelect, EnumSelect, Slider, KeyPress, Expand

### Fixed
- XjInlineRenderer cursor-up off-by-one: `CursorUp(N)` should be `CursorUp(N-1)` since cursor sits ON the last line, not below it

## [0.3.0] - 2026-03-12

### Added
- **XjWidget**: Base widget class owning an XjLayoutNode, with Paint/PaintContent/HandleKey/HandleTick template methods, focus state, child management, and FindByName
- **XjBox**: Container widget with horizontal/vertical alignment, background fill, and semantic factory methods (Info, Warning, Success, Error_)
- **XjText**: Text display widget with word wrapping, left/center/right alignment, and scroll offset
- **XjTextInput**: Single-line interactive input with visual cursor, horizontal scrolling, placeholder text, password mask, label prefix, and Ctrl+A/E/K/U editing shortcuts
- **XjTable**: Table widget with headers, auto/fixed column widths, per-column alignment, alternating row styles, Unicode/ASCII borders, and ellipsis truncation
- **XjProgressBar**: Progress bar with format tokens (:bar :percent :eta :current :total), indeterminate bounce mode, and ETA calculation
- **XjSpinner**: Animated spinner with 12 built-in formats (dots, braille, arc, star, bounce, arrow, clock, moon, bar, blocks), custom frames, success/error completion marks
- **XjTree + XjTreeNode**: Hierarchy display with box-drawing branch characters (├── └──), expand/collapse, per-node styling
- **XjFocusManager**: Tab/Shift-Tab focus cycling across focusable widgets with automatic key event routing to focused widget
- **XjLayoutNode.PaintSelf**: New method to draw border/title without child recursion, enabling widget-controlled paint hierarchy
- **Phase 3 demo**: Fullscreen app showcasing all widgets — tree sidebar, data table, progress bar, spinner, two text inputs with focus cycling, event log

### Fixed
- `Lib` is a Xojo reserved word — renamed to `libNode` in tree demo

## [0.2.0] - 2026-03-12

### Added
- **XjConstraint**: Size constraint class with Fixed, Percent, Auto, and MinMax modes, plus min/max clamping
- **XjLayoutNode**: Flexbox-like layout tree node with row/column direction, padding, margin, borders with titles, and computed absolute coordinates (ContentX/Y/Width/Height)
- **XjLayoutSolver**: Stateless solver module — resolves fixed/percent children first, distributes remaining space to auto children, recurses the tree
- **Phase 2 demo**: Responsive header/sidebar/content/footer layout with colored borders, titles, spinner animation, layout node info display, and event log in content panel
- **Minimum terminal size guard**: Shows "Terminal too small" message when below 60x16 instead of rendering broken UI

### Changed
- XjCanvas.Render now clears screen + homes cursor in one batch before drawing, preventing artifacts from resize or external events
- Demo app updated from Phase 1 single-box to Phase 2 multi-panel layout

## [0.1.0] - 2026-03-12

### Added
- **Foundation libraries**: XjPlatform, XjANSI, XjTerminal, XjColor, XjCursor, XjScreen
- **Input system**: XjKeyEvent (31 key codes + modifiers), XjReader (VT100/xterm parser)
- **Rendering engine**: XjStyle (immutable builder), XjCell, XjCanvas (2D grid with diff rendering, 5 box styles)
- **Event system**: XjEvent (discriminated union for key/mouse/resize/tick/custom), XjEventLoop (delegate-based callbacks, auto raw mode/fullscreen)
- **Phase 1 demo**: Fullscreen TUI with spinner animation, key event display, resize detection, event log
- **Gap analysis**: Full comparison with Ruby TTY-Toolkit, 6-phase roadmap

### Fixed
- Bottom-right corner auto-wrap scroll issue via DECAWM disable/enable in canvas rendering
- Screen artifacts on launch by deferring first render to event loop tick
