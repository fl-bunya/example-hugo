+++
date = '2025-12-18T12:04:00+09:00'
draft = false
title = '4. Hugoで実際に作る'
description = 'コマンド4つでサイトを作るデモ'
tags = ['Hugo', 'SSG', 'LT']
weight = 4
+++

**時間: 2分**

---

## 最小構成（コマンド4つ）

```bash
# 1. サイト作成
hugo new site mysite
cd mysite

# 2. テーマ追加
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
echo "theme = 'ananke'" >> hugo.toml

# 3. 記事作成
hugo new posts/hello.md

# 4. ビルド
hugo --gc --minify
```

---

## 生成物

```
public/
├── index.html
├── posts/
│   └── hello/
│       └── index.html
├── css/
└── js/
```

---

## ポイント

- **Markdown** で書くだけ
- テーマで見た目は自由に変えられる
- `public/` フォルダをどこかに置けば公開完了

---

## これをどこに置く？

→ **次のセクションで比較！**

---

**次へ**: [デプロイ先比較【メイン】]({{< ref "05-cdn-comparison" >}})

