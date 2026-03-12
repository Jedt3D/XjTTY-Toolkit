# Changelog

All notable changes to XjTTY-Toolkit will be documented in this file.

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
