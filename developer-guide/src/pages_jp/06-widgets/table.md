---
title: テーブルウィジェット
description: XjTableは複数列のテーブル表示、ヘッダー、自動折り返し、列幅制御、スタイリングをサポート。
---

# テーブルウィジェット（XjTable）

XjTableは行列形式でデータを表示するウィジェットです。ヘッダー、列幅制御、配置、スタイリング、交互行色などをサポートしています。

## コンストラクタ

```xojo
Sub New()
```

## ヘッダー設定

```xojo
Function SetHeaders(headers() As String) As XjTable
```

テーブルのヘッダー行を設定します。

```xojo
Var table As New XjTable()
Var headers() As String = Array("Name", "Age", "Email")
Call table.SetHeaders(headers)
```

## データ管理

```xojo
Function AddRow(cells() As String) As XjTable
Sub ClearRows()
Function RowCount() As Integer
```

行を追加・クリア・カウントします。

```xojo
Var table As New XjTable()
Call table.AddRow(Array("Alice", "30", "alice@example.com"))
Call table.AddRow(Array("Bob", "25", "bob@example.com"))
Var rowCount As Integer = table.RowCount()  // 2
```

## 列設定

```xojo
Function SetColumnWidth(columnIndex As Integer, width As Integer) As XjTable
Function SetColumnAlign(columnIndex As Integer, align As Integer) As XjTable
```

列の幅と配置（0=左、1=中央、2=右）を制御します。

```xojo
Var table As New XjTable()
Call table.SetColumnWidth(0, 15)   // 名前列：15文字
Call table.SetColumnWidth(1, 5)    // 年齢列：5文字
Call table.SetColumnAlign(1, 1)    // 年齢列：中央配置
```

## ヘッダー・ボーダー

```xojo
Function SetShowHeader(show As Boolean) As XjTable
Function SetShowBorder(show As Boolean) As XjTable
Function SetBorderChars(borderStyle As Integer) As XjTable
```

ヘッダー表示、ボーダー表示、ボーダースタイル（0-4）を制御します。

```xojo
Var table As New XjTable()
Call table.SetShowHeader(True)
Call table.SetShowBorder(True)
Call table.SetBorderChars(0)  // シングルライン
```

## スタイリング

```xojo
Function SetHeaderStyle(style As XjStyle) As XjTable
Function SetCellStyle(style As XjStyle) As XjTable
Function SetAltRowStyle(style As XjStyle) As XjTable
```

ヘッダー、セル、交互行のスタイルを設定します。

```xojo
Var table As New XjTable()
Call table.SetHeaderStyle(XjStyle.Success())     // ヘッダー：緑
Call table.SetCellStyle(XjStyle.Default())       // 通常セル
Call table.SetAltRowStyle(XjStyle.Muted())       // 交互行：グレイ
```

## 実装例

### シンプルなデータテーブル

```xojo
Sub DisplayDataTable()
  Var table As New XjTable()

  // ヘッダー設定
  Var headers() As String = Array("Product", "Price", "Qty")
  Call table.SetHeaders(headers)

  // 列幅設定
  Call table.SetColumnWidth(0, 20)
  Call table.SetColumnWidth(1, 10)
  Call table.SetColumnWidth(2, 5)

  // データ追加
  Call table.AddRow(Array("Apple", "$1.50", "10"))
  Call table.AddRow(Array("Banana", "$0.75", "15"))
  Call table.AddRow(Array("Orange", "$1.25", "8"))

  // スタイル設定
  Call table.SetHeaderStyle(XjStyle.Success())
  Call table.SetAltRowStyle(XjStyle.Muted())
End Sub
```

### アライメント付きテーブル

```xojo
Sub CreateAlignedTable()
  Var table As New XjTable()

  Var headers() As String = Array("Name", "Score", "Grade")
  Call table.SetHeaders(headers)

  // 左配置、中央配置、右配置
  Call table.SetColumnAlign(0, 0)  // Name：左
  Call table.SetColumnAlign(1, 1)  // Score：中央
  Call table.SetColumnAlign(2, 2)  // Grade：右

  Call table.SetColumnWidth(0, 15)
  Call table.SetColumnWidth(1, 8)
  Call table.SetColumnWidth(2, 6)

  Call table.AddRow(Array("Alice", "95", "A"))
  Call table.AddRow(Array("Bob", "87", "B"))
  Call table.AddRow(Array("Charlie", "92", "A"))
End Sub
```

### ボーダースタイル

```xojo
Class TableDemo
  Sub ShowTable()
    Var table As New XjTable()

    // ヘッダー
    Var headers() As String = Array("ID", "Status", "Message")
    Call table.SetHeaders(headers)

    // 列設定
    Call table.SetColumnWidth(0, 4)
    Call table.SetColumnWidth(1, 10)
    Call table.SetColumnWidth(2, 30)

    // ボーダー設定
    Call table.SetShowBorder(True)
    Call table.SetBorderChars(0)  // シングルライン

    // データ
    Call table.AddRow(Array("1", "OK", "Operation successful"))
    Call table.AddRow(Array("2", "ERROR", "Connection failed"))
    Call table.AddRow(Array("3", "WARN", "Memory low"))

    // スタイル
    Call table.SetHeaderStyle(XjStyle.Info())
    Call table.SetCellStyle(XjStyle.Default())
  End Sub
End Class
```

### 動的なテーブル更新

```xojo
Class DataTable
  Private mTable As XjTable

  Sub New()
    mTable = New XjTable()
    Var headers() As String = Array("Timestamp", "Value", "Status")
    Call mTable.SetHeaders(headers)
    Call mTable.SetShowBorder(True)
  End Sub

  Sub AddDataPoint(timestamp As String, value As String, status As String)
    Call mTable.AddRow(Array(timestamp, value, status))
  End Sub

  Sub ClearData()
    Call mTable.ClearRows()
  End Sub

  Function GetTable() As XjTable
    Return mTable
  End Function
End Class

// 使用例
Var dataTable As New DataTable()
dataTable.AddDataPoint("10:00", "42.5", "OK")
dataTable.AddDataPoint("10:01", "41.2", "OK")
dataTable.AddDataPoint("10:02", "39.8", "WARN")
```

### インタラクティブなテーブル

```xojo
Class SelectableTable
  Extends XjTable
  Private mSelectedRow As Integer = 0

  Function HandleKey(key As XjKeyEvent) As Boolean
    If key.IsArrowUp() Then
      mSelectedRow = Max(0, mSelectedRow - 1)
      MarkDirty()
      Return True
    ElseIf key.IsArrowDown() Then
      mSelectedRow = Min(RowCount() - 1, mSelectedRow + 1)
      MarkDirty()
      Return True
    ElseIf key.IsEnter() Then
      // 選択確定
      Return True
    End If
    Return False
  End Function

  Function GetSelectedRow() As Integer
    Return mSelectedRow
  End Function
End Class
```

## フルーエント設定例

```xojo
Var table As New XjTable()
Call table.SetHeaders(Array("Col1", "Col2", "Col3"))
Call table.SetColumnWidth(0, 10)
Call table.SetColumnWidth(1, 15)
Call table.SetColumnWidth(2, 10)
Call table.SetColumnAlign(0, 0)
Call table.SetColumnAlign(1, 1)
Call table.SetColumnAlign(2, 2)
Call table.SetShowHeader(True)
Call table.SetShowBorder(True)
Call table.SetHeaderStyle(XjStyle.Success())
Call table.SetAltRowStyle(XjStyle.Muted())
```

## レスポンシブカラム幅

```xojo
Class ResponsiveTable
  Private mTable As XjTable

  Sub AdjustColumnWidths(availableWidth As Integer)
    Var colCount As Integer = 3  // 例
    Var colWidth As Integer = availableWidth / colCount

    For i As Integer = 0 To colCount - 1
      Call mTable.SetColumnWidth(i, colWidth)
    Wend
  End Sub
End Class
```
