+++
date = '2025-12-17T11:30:00+09:00'
draft = false
title = '画像の扱い方とリサイズ'
weight = 13
tags = ['画像', 'Hugo', 'リサイズ']
+++

Hugoでの画像の配置方法と、自動リサイズ機能について解説します。

<!--more-->

## 画像の配置場所

画像処理を使うには、画像を以下のいずれかに配置します：

| 場所 | 用途 | 画像処理 |
|------|------|---------|
| `assets/` | グローバルに使う画像 | ✅ 可能 |
| `content/posts/記事名/` | 記事専用の画像（ページバンドル） | ✅ 可能 |
| `static/` | そのまま使う画像 | ❌ 不可 |

※ `static/` に置いた画像は処理されず、そのままコピーされます

## ページバンドルでの画像管理

記事と画像を同じフォルダに配置：

```
content/posts/
  my-article/
    index.md      ← 記事本文
    hero.jpg      ← この記事専用の画像
    photo1.png
```

## Markdownでの画像表示

### 基本的な記法

```markdown
![代替テキスト](hero.jpg)
```

### figureショートコード（キャプション付き）

```markdown
{{</* figure src="hero.jpg" title="タイトル" caption="キャプション" */>}}
```

## 画像処理（テンプレート内）

テンプレートでは強力な画像処理が使えます：

```go-html-template
{{ $image := .Resources.Get "hero.jpg" }}

{{/* リサイズ（幅600px、高さは自動） */}}
{{ $resized := $image.Resize "600x" }}

{{/* リサイズ（幅600px、高さ400px） */}}
{{ $resized := $image.Resize "600x400" }}

{{/* フィット（最大600x400に収める） */}}
{{ $fitted := $image.Fit "600x400" }}

{{/* フィル（600x400で切り抜き） */}}
{{ $filled := $image.Fill "600x400" }}

<img src="{{ $resized.RelPermalink }}" 
     width="{{ $resized.Width }}" 
     height="{{ $resized.Height }}">
```

## 主な処理メソッド

| メソッド | 説明 |
|----------|------|
| `.Resize "幅x高さ"` | 指定サイズにリサイズ |
| `.Fit "幅x高さ"` | アスペクト比を保持して収める |
| `.Fill "幅x高さ"` | 指定サイズで切り抜き |
| `.Crop "幅x高さ"` | 特定の位置で切り抜き |
| `.Filter` | ぼかし、明るさ調整など |

## 処理後の画像はどこに？

処理された画像は `resources/_gen/images/` に自動的にキャッシュされます。次回以降は再処理されないため、高速です。

## まとめ

- 画像処理を使うなら `assets/` またはページバンドル
- `static/` は処理なしでそのままコピー
- テンプレートで Resize/Fit/Fill などが使える
- キャッシュで2回目以降は高速

