+++
date = '2025-12-17T11:00:00+09:00'
draft = false
title = 'Cloudflare Pagesにデプロイする'
weight = 20
tags = ['デプロイ', 'Cloudflare', 'Hugo']
+++

HugoサイトをCloudflare Pagesに無料でデプロイする方法を解説します。

<!--more-->

## Cloudflare Pagesとは

Cloudflare Pagesは、静的サイトのホスティングサービスです。

### 特徴

| 特徴 | 説明 |
|------|------|
| **無料** | 無制限のサイト、リクエスト、帯域幅 |
| **高速** | 世界中のCDNで配信 |
| **自動デプロイ** | GitHubにpushするだけ |
| **プレビュー** | プルリクエストごとにプレビューURL |
| **カスタムドメイン** | 無料SSL付き |

## 事前準備

1. [Cloudflareアカウント](https://dash.cloudflare.com/sign-up)を作成
2. GitHubにHugoサイトのリポジトリを作成
3. `public/` を `.gitignore` に追加済み

## デプロイ手順

### Step 1: Cloudflare Pagesにアクセス

1. [Cloudflare Dashboard](https://dash.cloudflare.com/) にログイン
2. 左メニューから **Workers & Pages** を選択
3. **Create** ボタンをクリック
4. **Pages** タブを選択

### Step 2: GitHubリポジトリを連携

1. **Connect to Git** をクリック
2. **GitHub** を選択
3. Cloudflareアプリの認可を許可
4. デプロイしたいリポジトリを選択
5. **Begin setup** をクリック

### Step 3: ビルド設定

以下の設定を入力します：

| 項目 | 値 |
|------|-----|
| **Project name** | 任意のプロジェクト名 |
| **Production branch** | `main` |
| **Framework preset** | `Hugo` |
| **Build command** | `hugo --gc --minify` |
| **Build output directory** | `public` |

### Step 4: 環境変数を設定

**Environment variables** セクションで以下を追加：

| Variable name | Value |
|---------------|-------|
| `HUGO_VERSION` | `0.152.2` |

> **重要**: Hugo のバージョンを指定しないと古いバージョンが使われ、エラーになることがあります。

### Step 5: デプロイ実行

1. **Save and Deploy** をクリック
2. ビルドログが表示される
3. 数分待つと完了！

### Step 6: サイトにアクセス

デプロイ完了後、以下のURLでアクセスできます：

```
https://プロジェクト名.pages.dev
```

## カスタムドメインの設定

### 独自ドメインを使う

1. Cloudflare Pages のプロジェクトページへ
2. **Custom domains** タブをクリック
3. **Set up a custom domain** をクリック
4. ドメイン名を入力（例: `blog.example.com`）
5. DNS設定を確認して **Activate domain**

### Cloudflare でDNS管理している場合

自動的にDNSレコードが追加されます。

### 他のDNSプロバイダーの場合

表示されるCNAMEレコードを設定：

```
CNAME blog プロジェクト名.pages.dev
```

## 自動デプロイの確認

設定完了後は、GitHubにpushするだけで自動デプロイされます。

```bash
# 記事を追加
hugo new content posts/new-post.md

# 編集後、コミット＆プッシュ
git add .
git commit -m "Add new post"
git push origin main
```

Cloudflare Pagesが自動検知してビルド＆デプロイ！

## プレビューデプロイ

プルリクエストを作成すると、自動的にプレビューURLが生成されます。

```
https://ランダム文字列.プロジェクト名.pages.dev
```

本番にマージする前に確認できて便利！

## ビルドが失敗する場合

### よくある原因と対処

#### 1. Hugoバージョンの問題

環境変数 `HUGO_VERSION` を正しく設定：

```
HUGO_VERSION = 0.152.2
```

#### 2. テーマがない

Git submoduleを使っている場合、Cloudflareは自動で取得します。
ただし、テーマのURLが正しいか確認：

```bash
cat .gitmodules
```

#### 3. ビルドコマンドのエラー

ローカルで同じコマンドを実行して確認：

```bash
hugo --gc --minify
```

## GitHub Pagesとの比較

| 項目 | Cloudflare Pages | GitHub Pages |
|------|-----------------|--------------|
| 料金 | 無料 | 無料 |
| ビルド | 自動 | 自動 |
| CDN | グローバル | 限定的 |
| プレビュー | PR毎に自動 | なし |
| カスタムドメイン | 無料SSL | 無料SSL |
| ビルド時間制限 | 20分 | 10分 |

## まとめ

1. Cloudflare Dashboardでプロジェクト作成
2. GitHubリポジトリを連携
3. ビルド設定（Framework: Hugo）
4. 環境変数に `HUGO_VERSION` を設定
5. **Save and Deploy**

たったこれだけで、pushするたびに自動デプロイされる環境が完成します！

## 次のステップ

- [GitHub Pagesにもデプロイする](/tutorials/deploy-github-pages/)
- カスタムドメインを設定する
- アナリティクスを追加する（Cloudflare Web Analytics）

