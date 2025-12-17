+++
date = '2025-12-17T11:05:00+09:00'
draft = false
title = 'Hugoでハマりやすいポイントと解決法'
weight = 17
tags = ['トラブルシューティング', 'Hugo', '設定']
+++

Hugoでサイトを構築する際にハマりやすいポイントと、その解決法をまとめました。

<!--more-->

## 1. 記事が表示されない！

### 症状

- 記事ファイルを作成したのに一覧に表示されない
- 特定の記事だけ表示されない

### 原因と解決法

#### 原因1: `draft = true` になっている

```toml
+++
draft = true  # ← これが原因
+++
```

**解決法:**
- `draft = false` に変更する
- または `hugo server -D` で起動（下書きも表示）

#### 原因2: 記事の日付が未来になっている

```toml
+++
date = '2025-12-20T10:00:00+09:00'  # ← 未来の日付
+++
```

Hugoはデフォルトで**未来の日付の記事を公開しません**。

**解決法:**

`hugo.toml` に追加：

```toml
buildFuture = true
```

または、記事の日付を過去に変更する。

## 2. ページネーションが表示されない！

### 症状

- セクションページに記事は表示されるが、ページ送りのリンクがない
- `page/2/` などが生成されない

### 原因と解決法

#### 原因1: ページネーションUIがない

テーマに `pagination.html` パーシャルがない場合があります。

**解決法:**

`layouts/partials/pagination.html` を作成：

```html
{{ $paginator := .Paginator }}
{{ if gt $paginator.TotalPages 1 }}
<nav class="flex justify-center mt4 mb4">
  <ul class="list flex items-center pa0 ma0">
    {{ if $paginator.HasPrev }}
      <li class="mh2">
        <a href="{{ $paginator.Prev.URL }}">« 前へ</a>
      </li>
    {{ end }}
    
    {{ range $paginator.Pagers }}
      <li class="mh1">
        {{ if eq . $paginator }}
          <span>{{ .PageNumber }}</span>
        {{ else }}
          <a href="{{ .URL }}">{{ .PageNumber }}</a>
        {{ end }}
      </li>
    {{ end }}
    
    {{ if $paginator.HasNext }}
      <li class="mh2">
        <a href="{{ $paginator.Next.URL }}">次へ »</a>
      </li>
    {{ end }}
  </ul>
</nav>
{{ end }}
```

#### 原因2: pagerSizeの設定

Hugo v0.128.0以降は設定名が変わりました。

```toml
# 旧（非推奨）
paginate = 10

# 新
[pagination]
  pagerSize = 10
```

## 3. トップページに意図しない記事が表示される

### 症状

- トップページに全セクションの記事が混ざって表示される
- 表示したいセクションの記事だけ表示されない

### 原因と解決法

Anankeテーマの場合、`mainSections` パラメータで制御します。

```toml
[params]
  mainSections = ['posts']  # postsセクションのみ表示
```

複数セクションを表示する場合：

```toml
[params]
  mainSections = ['posts', 'news']
```

## 4. 画像が404になる

### 症状

- ページバンドル内の画像が表示されない
- 相対パスで指定した画像が見つからない

### 原因と解決法

#### 原因1: パスの指定方法

ページバンドル（`index.md` と同じフォルダ）の画像は、絶対パスで指定が確実：

```markdown
# 相対パス（動作しないことがある）
![画像](hero.jpg)

# 絶対パス（確実）
![画像](/posts/my-post/hero.jpg)
```

#### 原因2: figureショートコードを使う

```markdown
{{</* figure src="hero.jpg" alt="画像の説明" */>}}
```

## 5. 変更が反映されない

### 症状

- ファイルを変更したのにブラウザに反映されない
- 設定を変えたのに動作が変わらない

### 原因と解決法

#### 原因1: Fast Renderモードのキャッシュ

```bash
# 完全リビルドで起動
hugo server --disableFastRender
```

#### 原因2: publicフォルダのキャッシュ

```bash
rm -rf public/
hugo server -D
```

#### 原因3: ブラウザキャッシュ

```bash
hugo server --noHTTPCache
```

## 6. 設定のまとめ

開発中に便利な `hugo.toml` 設定：

```toml
baseURL = 'https://example.org/'
languageCode = 'ja'
title = 'My Site'
theme = 'ananke'

# 未来の日付の記事も公開
buildFuture = true

# 要約の長さ
summaryLength = 30

[pagination]
  pagerSize = 10

[params]
  mainSections = ['posts']
```

開発サーバー起動コマンド：

```bash
hugo server -D --disableFastRender
```

## まとめ

| 問題 | よくある原因 | 解決法 |
|------|-------------|--------|
| 記事が表示されない | `draft = true` | `-D` オプションか `false` に |
| 記事が表示されない | 未来の日付 | `buildFuture = true` |
| ページネーションなし | パーシャルがない | `pagination.html` を作成 |
| 変更が反映されない | キャッシュ | `--disableFastRender` |

困ったときはまずこれらをチェックしてみてください！

