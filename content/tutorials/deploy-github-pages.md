+++
date = '2025-12-17T11:00:00+09:00'
draft = false
title = 'GitHub Pagesにデプロイする'
weight = 21
tags = ['デプロイ', 'GitHub', 'Hugo']
+++

HugoサイトをGitHub Pagesに自動デプロイする方法を解説します。

<!--more-->

## GitHub Pagesとは

GitHub Pagesは、GitHubリポジトリから直接静的サイトをホスティングできる無料サービスです。

### 特徴

| 特徴 | 説明 |
|------|------|
| **無料** | パブリックリポジトリは無料 |
| **GitHub Actions連携** | pushで自動デプロイ |
| **カスタムドメイン** | 無料SSL付き |
| **バージョン管理** | Gitで履歴管理 |

## 2種類のサイトタイプ

| タイプ | リポジトリ名 | URL |
|--------|-------------|-----|
| **ユーザーサイト** | `username.github.io` | `https://username.github.io/` |
| **プロジェクトサイト** | 任意の名前 | `https://username.github.io/repo-name/` |

## 事前準備

1. GitHubアカウント
2. Hugoサイトのリポジトリ
3. `public/` を `.gitignore` に追加

### .gitignore の設定

```gitignore
# Hugo生成物
public/
resources/_gen/
.hugo_build.lock
```

## デプロイ手順

### Step 1: GitHub Actions ワークフローを作成

`.github/workflows/hugo.yml` を作成：

```yaml
name: Deploy Hugo site to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.152.2
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb

      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5

      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: Asia/Tokyo
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Step 2: GitHub Pages を有効化

1. GitHubリポジトリの **Settings** へ
2. 左メニューから **Pages** を選択
3. **Source** で **GitHub Actions** を選択
4. **Save** をクリック

### Step 3: プッシュしてデプロイ

```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
```

### Step 4: デプロイを確認

1. **Actions** タブでワークフローの実行を確認
2. 完了後、**Settings → Pages** でURLを確認

## プロジェクトサイトの注意点

### URL構造

プロジェクトサイト（`username.github.io/repo-name/`）では、サイトがサブディレクトリにデプロイされます。

### リンクの書き方

**❌ 絶対パス（動かない）**

```markdown
[リンク](/tutorials/)
→ https://username.github.io/tutorials/  ← 間違い！
```

**✅ ref ショートコード（推奨）**

```markdown
[リンク]({{</* ref "tutorials" */>}})
→ https://username.github.io/repo-name/tutorials/  ← 正しい！
```

GitHub Actions の `--baseURL` オプションが自動的にURLを調整しますが、コンテンツ内のリンクは `{{</* ref */>}}` を使う必要があります。

## カスタムドメインの設定

### Step 1: ドメインを追加

1. **Settings → Pages → Custom domain**
2. ドメインを入力（例: `blog.example.com`）
3. **Save** をクリック

### Step 2: DNS設定

DNSプロバイダーで以下を設定：

**サブドメインの場合（推奨）**

```
CNAME blog username.github.io
```

**Apexドメインの場合**

```
A @ 185.199.108.153
A @ 185.199.109.153
A @ 185.199.110.153
A @ 185.199.111.153
```

### Step 3: HTTPS を有効化

DNS設定が反映されたら、**Enforce HTTPS** にチェック。

## トラブルシューティング

### エラー: "Get Pages site failed"

GitHub Pages が有効になっていません。

**解決:** Settings → Pages → Source で **GitHub Actions** を選択

### エラー: "REF_NOT_FOUND"

`{{</* ref */>}}` で指定したページが存在しません。

**解決:** ページ名を確認するか、ページを作成

### リンクが間違ったURLになる

`baseURL` の問題です。

**解決:** 
- コンテンツ内のリンクは `{{</* ref */>}}` を使う
- GitHub Actions の `--baseURL` オプションを確認

## Cloudflare Pages との比較

| 項目 | GitHub Pages | Cloudflare Pages |
|------|--------------|------------------|
| URL | `username.github.io/repo/` | `project.pages.dev/` |
| ルート配置 | ユーザーサイトのみ | 常にルート |
| プレビュー | なし | PR毎に自動 |
| CDN | 限定的 | グローバル |
| ビルド時間 | 10分 | 20分 |

## まとめ

1. `.github/workflows/hugo.yml` を作成
2. Settings → Pages で **GitHub Actions** を選択
3. `git push` で自動デプロイ！

プロジェクトサイトでは `{{</* ref */>}}` ショートコードを使ってリンクを書くことを忘れずに！

## 関連記事

- [Cloudflare Pagesにデプロイする]({{< ref "deploy-cloudflare" >}})
- [Hugoでハマりやすいポイント]({{< ref "troubleshooting" >}})

