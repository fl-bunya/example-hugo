+++
date = '2025-12-17T10:00:00+09:00'
draft = false
title = '記事を作成する'
weight = 3
tags = ['コンテンツ', 'Hugo']
+++

## 新しい記事を作成

Hugoコマンドを使って記事を作成します：

```bash
hugo new content posts/my-post.md
```

## フロントマター

記事の先頭にはメタデータを記述します：

```toml
+++
date = '2025-12-17T10:00:00+09:00'
draft = true
title = '記事タイトル'
tags = ['タグ1', 'タグ2']
+++
```

## Markdownで本文を書く

フロントマターの下に、Markdown形式で本文を書きます。

- **太字** は `**太字**`
- *斜体* は `*斜体*`
- [リンク](https://example.com) は `[リンク](URL)`

以上で基本的な記事作成は完了です！

