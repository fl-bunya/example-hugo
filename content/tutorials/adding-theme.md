+++
date = '2025-12-17T09:30:00+09:00'
draft = false
title = 'テーマを追加する'
weight = 2
tags = ['テーマ', 'Hugo']
+++

## テーマの選び方

Hugoには多くの無料テーマがあります。

公式テーマサイト: https://themes.gohugo.io/

## テーマのインストール

Git submoduleを使う方法が一般的です：

```bash
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
```

## 設定ファイルを編集

`hugo.toml` にテーマを指定します：

```toml
theme = 'ananke'
```

これでテーマが適用されます！

