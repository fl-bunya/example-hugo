+++
date = '2025-12-17T11:40:00+09:00'
draft = false
title = '記事の並び順を制御する'
weight = 14
tags = ['ソート', 'Hugo', '設定']
+++

記事一覧の並び順を制御する方法を解説します。

<!--more-->

## デフォルトの並び順

Hugoは以下の優先順位でソートします：

1. **Weight**（小さい順）- フロントマターで指定可
2. **Date**（新しい順）
3. **LinkTitle / Title**（アルファベット順）
4. **ファイルパス**（アルファベット順）

つまり、**デフォルトでは新しい記事が上**に表示されます。

## 日付での並び順

記事のフロントマターで `date` を設定：

```toml
+++
date = '2025-12-15T21:41:56+09:00'
title = 'My Post'
+++
```

| 記事 | date | 表示順 |
|------|------|--------|
| 記事A | 2025-12-17 | 1番目（最新） |
| 記事B | 2025-12-15 | 2番目 |
| 記事C | 2025-12-10 | 3番目（最古） |

## Weight で特定の記事を上に固定

`weight` を使うと、日付に関係なく記事を固定できます：

```toml
+++
date = '2025-12-10T10:00:00+09:00'
title = '重要なお知らせ'
weight = 1
+++
```

- `weight` が小さい記事が上に表示
- `weight` が同じなら `date` で並ぶ
- `weight` を指定しない記事は最後

## テンプレートでのソート指定

テンプレート内では様々なソートが可能です：

```go-html-template
{{/* 新しい順（デフォルト） */}}
{{ range .Pages.ByDate.Reverse }}

{{/* 古い順 */}}
{{ range .Pages.ByDate }}

{{/* タイトル順 */}}
{{ range .Pages.ByTitle }}

{{/* weight順 */}}
{{ range .Pages.ByWeight }}

{{/* 更新日順 */}}
{{ range .Pages.ByLastmod.Reverse }}
```

## よくある使い方

### ブログ記事

日付の新しい順（デフォルト）でOK

### チュートリアル・ドキュメント

`weight` で順番を明示的に指定：

```toml
# getting-started.md
weight = 1

# installation.md  
weight = 2

# configuration.md
weight = 3
```

### お知らせを常にトップに

重要な記事だけ `weight` を設定：

```toml
weight = 1  # この記事は常にトップ
```

## まとめ

- デフォルトは `date` の新しい順
- 固定したい記事は `weight` を指定
- テンプレートで柔軟にソート可能

