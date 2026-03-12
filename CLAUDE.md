# XjTTY-Toolkit

A Terminal UI (TUI) toolkit for Xojo, inspired by Ruby TTY-Toolkit, Python Prompt Toolkit, and Rust IOCraft.

## Project Structure

- `XjTTYToolkit.xojo_project` — Console app project file
- `App.xojo_code` — Demo app (currently Phase 2 layout engine demo)
- `XjTTYLib/` — Library folder containing all toolkit modules/classes

### Library Components (XjTTYLib)

| File | Type | Purpose |
|------|------|---------|
| XjPlatform | Module | Platform detection (macOS/Linux/Windows) |
| XjANSI | Module | ANSI escape code builders (CSI, SGR, colors, cursor, screen, mouse, auto-wrap) |
| XjTerminal | Module | Raw mode, terminal size, byte reading, non-blocking input (termios/Win32) |
| XjColor | Module | Convenience color functions (Red, Green, RGB, gradients, semantic colors) |
| XjCursor | Module | Cursor movement and visibility control |
| XjScreen | Module | Screen clearing, scrolling, fullscreen, drawing primitives |
| XjKeyEvent | Class | Key event with 31 key codes + modifier flags |
| XjReader | Class | VT100/xterm escape sequence parser, keyboard input polling |
| XjStyle | Class | Immutable style builder (FG/BG/bold/italic/underline/inverse) |
| XjCell | Class | Single character + style (canvas cell) |
| XjCanvas | Class | 2D grid rendering with diff updates, box drawing (5 styles) |
| XjEvent | Class | Discriminated union for key/mouse/resize/tick/custom events |
| XjEventLoop | Class | Main app loop with delegate callbacks, auto raw mode/fullscreen |
| XjConstraint | Class | Size constraint (Fixed/Percent/Auto) with min/max clamping |
| XjLayoutNode | Class | Flexbox-like layout tree node with border, title, padding, margin |
| XjLayoutSolver | Module | Stateless solver: resolves layout tree to absolute coordinates |

## Development Phases

See `gap-analysis.md` for full roadmap. Phases:
1. Event System & App Loop (DONE)
2. Layout Engine (DONE)
3. Widget System
4. Prompt System (13 types)
5. Utility Modules
6. YAML UI Definition

## Xojo Gotchas

- **No `New ClassName().Method()` chaining** — use temp variable: `Var b As New XjStyle` then `b.SetFG(...)`
- **`:` is Pair operator** — never use as statement separator
- **`Do While...Loop` invalid** — use `While...Wend`
- **Module constants** — always `Type = Double`
- **No backslash escaping** — use `Chr()` for special chars
- **Bottom-right corner scroll** — disable auto-wrap (`ESC[?7l`) before rendering canvas
- **`Call` required for fluent returns** — when calling fluent methods for side-effects only, must use `Call obj.Method()` or assign to temp var
- **Full render prevents artifacts** — clear screen + home cursor in one Write() call before rendering; diff render is optional optimization

## Build & Analyze

Use xojo-run skill: `xojo.sh analyze XjTTYToolkit.xojo_project`

## Workflow

Every phase: implement -> analyze with xojo-run -> fix errors -> user tests -> user says "it pass" -> run `/sccs` to summarize, update docs, and commit.
