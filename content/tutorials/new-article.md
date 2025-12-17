+++
date = '2025-12-17T11:00:00+09:00'
draft = false
title = '新しい記事を追加する'
weight = 10
tags = ['コンテンツ', 'Hugo', '入門']
+++

Hugoで新しい記事を追加する方法を解説します。

<!--more-->

## 方法1: `hugo new` コマンドを使う（推奨）

`quickstart` ディレクトリで以下のコマンドを実行します：

```bash
hugo new content posts/記事名.md
```

例えば、`my-second-post.md` という記事を作成する場合：

```bash
hugo new content posts/my-second-post.md
```

これにより、`archetypes/default.md` のテンプレートを元に、日付やタイトルが自動設定された新しい記事が作成されます。

## 方法2: 手動でファイルを作成する

`content/posts/` フォルダに直接 `.md` ファイルを作成することもできます。

ファイルの先頭には以下のようなフロントマター（メタデータ）が必要です：

```toml
+++
date = '2025-12-15T10:00:00+09:00'
draft = true
title = 'My Second Post'
+++

ここに記事の本文を書きます。
```

## 重要なポイント

### draft（下書き）について

- `draft = true` は下書き状態です
- 公開するには `draft = false` に変更
- または、サーバー起動時に `-D` オプションを付ける（`hugo server -D`）

### ファイル名とURL

ファイル名はURLの一部になります：

| ファイル名 | URL |
|-----------|-----|
| `my-second-post.md` | `/posts/my-second-post/` |
| `hello-world.md` | `/posts/hello-world/` |

## まとめ

- コマンド派 → `hugo new content posts/記事名.md`
- 手動派 → `content/posts/` に `.md` ファイルを作成
- 下書きを忘れずに `false` にして公開！

