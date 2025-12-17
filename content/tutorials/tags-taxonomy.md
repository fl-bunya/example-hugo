+++
date = '2025-12-17T11:20:00+09:00'
draft = false
title = 'タグとタクソノミー'
weight = 12
tags = ['タクソノミー', 'Hugo', 'タグ']
+++

記事を分類するためのタグとタクソノミー機能を解説します。

<!--more-->

## タグの追加方法

フロントマターに `tags` を追加するだけ：

```toml
+++
date = '2025-12-15T21:41:56+09:00'
draft = true
title = 'My Second Post'
tags = ['Hugo', 'チュートリアル', 'Web']
+++
```

## カテゴリーも使える

```toml
+++
title = 'My Second Post'
tags = ['Hugo', 'チュートリアル']
categories = ['技術', 'ブログ']
+++
```

## タクソノミー（Taxonomy）とは

タクソノミーは「分類法」という意味で、Hugoではコンテンツを整理・分類するための仕組みです。

### デフォルトのタクソノミー

Hugoには最初から2つのタクソノミーが用意されています：

| タクソノミー | 用途 | 例 |
|-------------|------|-----|
| **tags** | 記事の細かいトピック | `Hugo`, `CSS`, `JavaScript` |
| **categories** | 記事の大分類 | `技術`, `日記`, `レビュー` |

### 自動生成されるページ

| URL | 内容 |
|-----|------|
| `/tags/` | すべてのタグ一覧 |
| `/tags/hugo/` | 「Hugo」タグの記事一覧 |
| `/categories/` | すべてのカテゴリー一覧 |
| `/categories/技術/` | 「技術」カテゴリーの記事一覧 |

## カスタムタクソノミーの作成

`hugo.toml` に設定を追加すると、独自の分類を作成できます：

```toml
[taxonomies]
  tag = "tags"
  category = "categories"
  author = "authors"        # 著者別
  series = "series"         # シリーズ別
```

記事のフロントマターで使用：

```toml
+++
title = "記事タイトル"
authors = ["山田太郎"]
series = ["Hugo入門"]
+++
```

これにより `/authors/山田太郎/` や `/series/hugo入門/` といったページが自動生成されます。

## まとめ

- `tags` と `categories` はデフォルトで使える
- フロントマターに配列で指定
- 一覧ページは自動生成される
- カスタムタクソノミーで独自の分類も可能

