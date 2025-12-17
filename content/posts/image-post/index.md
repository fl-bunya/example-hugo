+++
date = '2025-12-17T10:00:00+09:00'
draft = false
title = '画像を使った記事のサンプル'
tags = ['Hugo', '画像', 'チュートリアル']
categories = ['サンプル']
+++

この記事では、Hugoで画像を扱う方法を紹介します。

<!--more-->

## ページバンドルとは

この記事は「ページバンドル」形式で作成されています。記事と画像が同じフォルダに格納されています：

```
content/posts/image-post/
  ├── index.md    ← この記事
  └── hero.jpg    ← 画像ファイル
```

## 画像の表示方法

### 方法1: Markdownの標準記法

![Hugoのサンプル画像](/posts/image-post/hero.jpg)

### 方法2: HTMLを直接書く

<img src="hero.jpg" alt="Hugoのサンプル画像" style="max-width: 100%; height: auto;">

### 方法3: figureショートコード（キャプション付き）

{{< figure src="hero.jpg" title="Hugoのデフォルトヒーロー画像" caption="ページバンドル内の画像を表示しています" >}}

## まとめ

ページバンドルを使うと：

- 記事と関連ファイルを一緒に管理できる
- 相対パスで画像を参照できる
- Hugo の画像処理機能（リサイズ等）が使える

ぜひ活用してみてください！

