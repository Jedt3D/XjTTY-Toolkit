# Changelog

All notable changes to XjTTY-Toolkit will be documented in this file.

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
