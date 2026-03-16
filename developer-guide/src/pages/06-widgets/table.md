---
title: Table Widget
description: XjTable displays tabular data with headers, configurable column widths, alignment, and styling.
---

# Table Widget

The **XjTable** widget displays data in a table format with configurable headers, column widths, alignment, borders, and row styling.

## Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `SetHeaders(headers)` | String() | — | Set column headers |
| `AddRow(values)` | String() | — | Add data row |
| `ClearRows()` | — | — | Remove all data rows |
| `RowCount()` | — | Integer | Get number of data rows |
| `SetColumnWidth(col, width)` | Integer col, Integer width | — | Set fixed column width |
| `SetColumnAlign(col, align)` | Integer col, Integer align | — | Set column alignment |
| `SetShowHeader(show)` | Boolean | — | Show/hide header row |
| `SetShowBorder(show)` | Boolean | — | Show/hide borders |
| `SetBorderChars(style)` | Integer (0-4) | — | Set border style |
| `SetHeaderStyle(style)` | XjStyle | — | Set header row style |
| `SetCellStyle(row, col, style)` | Integer row, col; XjStyle | — | Set specific cell style |
| `SetAltRowStyle(style)` | XjStyle | — | Set alternating row style |

## Alignment Constants

| Constant | Value |
|----------|-------|
| `ALIGN_LEFT` | 0 |
| `ALIGN_CENTER` | 1 |
| `ALIGN_RIGHT` | 2 |

## Examples

### Basic table

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("Name", "Age", "City"))
Call table.AddRow(Array("Alice", "28", "NYC"))
Call table.AddRow(Array("Bob", "35", "LA"))
Call table.AddRow(Array("Charlie", "42", "Chicago"))
```

### Table with borders and styling

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("ID", "Status", "Progress"))
Call table.SetBorderChars(XjCanvas.BORDER_SINGLE)
Call table.SetShowBorder(True)
Call table.SetShowHeader(True)

Call table.SetHeaderStyle(XjStyle.Success())
Call table.SetAltRowStyle(XjStyle.Muted())

Call table.AddRow(Array("1", "Running", "50%"))
Call table.AddRow(Array("2", "Pending", "0%"))
```

### Fixed column widths

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("Cmd", "Description"))
Call table.SetColumnWidth(0, 10)  // First column: 10 chars
Call table.SetColumnWidth(1, 30)  // Second column: 30 chars
```

### Column alignment

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("Name", "Count", "Ratio"))
Call table.SetColumnAlign(0, XjTable.ALIGN_LEFT)
Call table.SetColumnAlign(1, XjTable.ALIGN_CENTER)
Call table.SetColumnAlign(2, XjTable.ALIGN_RIGHT)
```

### Cell-level styling

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("Task", "Result"))
Call table.AddRow(Array("Build", "SUCCESS"))
Call table.AddRow(Array("Test", "FAILED"))

// Style specific cell
Call table.SetCellStyle(1, 1, XjStyle.Danger())  // Second row, second column
```

### Dynamic table building

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("File", "Size"))

Var files As String() = Array("file1.txt", "file2.xojo", "file3.md")
For Each file As String In files
  Var size As String = GetFileSize(file)
  Call table.AddRow(Array(file, size))
Next
```

## Design notes

**Auto width**: By default, columns auto-size to fit content. SetColumnWidth() overrides this for specific columns.

**Truncation**: Long cell content is truncated with ellipsis (...) if it exceeds column width.

**Header row**: SetShowHeader(False) hides the header row but doesn't remove headers (can be re-shown).

**Alternating rows**: SetAltRowStyle() applies style to every other row for readability.

**Cell styling**: Individual cells can be styled independently of row/column styles.

**Border styles**: Use BORDER_SINGLE (0), BORDER_DOUBLE (1), BORDER_ROUND (2), BORDER_BOLD (3), BORDER_ASCII (4).

!!! note
    Tables are static display widgets. For interactive row selection, build custom widgets using XjBox and XjText with focus/key handling.
