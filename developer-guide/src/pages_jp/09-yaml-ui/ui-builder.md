---
title: UIビルダー
description: XjUIParserはYAML定義からウィジェットツリーを自動構築。
---

# UIビルダー（XjUIParser）

YAMLでUIレイアウトを定義し、自動的にウィジェットツリーを構築。

## XjUIParser（UIコンパイラ）

```xojo
Function Build(yaml As String) As XjWidget
Function BuildFromFile(filePath As String) As XjWidget
```

YAML定義からウィジェットツリーを生成。

```xojo
Var yaml As String = "type: box" + Xojo.Core.NewLine + _
                     "direction: column" + Xojo.Core.NewLine + _
                     "children:" + Xojo.Core.NewLine + _
                     "  - type: text" + Xojo.Core.NewLine + _
                     "    text: Hello"

Var root As XjWidget = XjUIParser.Build(yaml)
```

## YAML UIスキーマ

### ボックス（コンテナ）

```yaml
type: box
direction: column    # row / column
width: 80           # ピクセル、または%で割合
height: 24
padding: [1, 2, 1, 2]  # [top, right, bottom, left]
margin: [1, 1, 1, 1]
border:
  style: 0          # 0-4
  color: blue
title: My Box
children:
  - ...
```

### テキスト

```yaml
type: text
text: Display text
align: center       # left / center / right
wrap: true
```

### テキスト入力

```yaml
type: input
placeholder: Enter name
label: Name
max_length: 50
```

### テーブル

```yaml
type: table
headers: [Name, Age, Email]
rows:
  - [Alice, 30, alice@example.com]
  - [Bob, 25, bob@example.com]
```

### プログレスバー

```yaml
type: progress
value: 50
total: 100
format: "[{:bar}] {:percent}%"
```

## 実装例

### UIレイアウト定義

```xojo
Function BuildMainUI() As XjWidget
  Var yaml As String = "type: box" + Xojo.Core.NewLine + _
                       "direction: column" + Xojo.Core.NewLine + _
                       "padding: [1, 1, 1, 1]" + Xojo.Core.NewLine + _
                       "children:" + Xojo.Core.NewLine + _
                       "  - type: text" + Xojo.Core.NewLine + _
                       "    text: Welcome" + Xojo.Core.NewLine + _
                       "    align: center" + Xojo.Core.NewLine + _
                       "  - type: input" + Xojo.Core.NewLine + _
                       "    placeholder: Enter name" + Xojo.Core.NewLine + _
                       "  - type: text" + Xojo.Core.NewLine + _
                       "    text: Type something..." + Xojo.Core.NewLine + _
                       "    wrap: true"

  Return XjUIParser.Build(yaml)
End Function
```

### ダッシュボード定義

```yaml
type: box
direction: column
children:
  - type: box
    border:
      style: 0
      color: cyan
    title: Status
    children:
      - type: text
        text: System Running

  - type: box
    border:
      style: 0
      color: green
    title: Metrics
    children:
      - type: text
        text: CPU Usage
      - type: progress
        value: 45
        total: 100

      - type: text
        text: Memory Usage
      - type: progress
        value: 72
        total: 100
```

### フォーム定義

```yaml
type: box
direction: column
padding: [2, 3, 2, 3]
border:
  style: 0
  color: blue
title: User Registration

children:
  - type: text
    text: Name

  - type: input
    placeholder: John Doe
    max_length: 50

  - type: text
    text: Email

  - type: input
    placeholder: user@example.com
    max_length: 100

  - type: text
    text: Password

  - type: input
    placeholder: "●●●●●●●●"
```

### ファイルベース定義

```xojo
Function LoadUIFromFile(filePath As String) As XjWidget
  Return XjUIParser.BuildFromFile(filePath)
End Function

// ui/main.yaml から読み込み
Var root As XjWidget = LoadUIFromFile("/etc/app/ui/main.yaml")
```

## 制約指定

```yaml
type: box
width: 50           # Fixed: 50
height: 80%         # Percent: 80%
width: auto         # Auto
```

## テーマカラー

```yaml
border:
  color: red        # red / green / blue / yellow / cyan / magenta
```

## スタイルプリセット

```yaml
type: box
style: info         # info / success / warning / error
```

## YAML UI の利点

1. **宣言的UI定義** — コード不要でUIを記述
2. **デザイナーフレンドリー** — 非プログラマーが編集可能
3. **保守性** — レイアウト変更が簡単
4. **バージョン管理** — YAML ファイルをgit管理
5. **再利用性** — レイアウト定義を共有

## 完全な例

```yaml
type: box
direction: column
padding: [1, 1, 1, 1]
border:
  style: 0
  color: cyan
title: My Application

children:
  # ヘッダー
  - type: box
    height: 3
    border:
      style: 0
      color: green
    children:
      - type: text
        text: Dashboard
        align: center

  # メインコンテンツ
  - type: box
    direction: row
    padding: [1, 1, 1, 1]
    children:
      # サイドバー
      - type: box
        width: 20
        children:
          - type: text
            text: Menu

      # メインパネル
      - type: box
        width: auto
        children:
          - type: text
            text: Content area
```
