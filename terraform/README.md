# Hugo Site AWS Hosting with Terraform

HugoサイトをAWSにデプロイするためのTerraform設定です。

## 構成

**1つのS3バケット**を使用して、2つの方法でアクセス可能：

| 方式 | URL | 特徴 |
|------|-----|------|
| S3 Direct | `http://<bucket>.s3-website-<region>.amazonaws.com` | CDN無し、HTTP |
| CloudFront | `https://<dist>.cloudfront.net` | CDN経由、HTTPS |

```
┌─────────────────┐     ┌─────────────┐
│  S3 Direct      │────▶│             │
│  (HTTP)         │     │  S3 Bucket  │
└─────────────────┘     │  (Public)   │
                        │             │
┌─────────────────┐     │             │
│  CloudFront     │────▶│             │
│  (HTTPS + CDN)  │     └─────────────┘
└─────────────────┘
```

## 作成されるリソース

- S3バケット（パブリックアクセス有効）
- S3静的ウェブサイトホスティング
- CloudFront Distribution

## 使い方

### 1. AWS認証情報の設定

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="ap-northeast-1"
```

または `~/.aws/credentials` を設定。

### 2. Terraform初期化

```bash
cd terraform
terraform init
```

### 3. 設定の確認（プレビュー）

```bash
terraform plan
```

### 4. リソース作成

```bash
terraform apply
```

### 5. Hugoサイトのデプロイ

```bash
# プロジェクトルートに戻る
cd ..

# Hugoビルド
hugo --gc --minify

# S3 にデプロイ
aws s3 sync public/ s3://$(terraform -chdir=terraform output -raw bucket_name) --delete

# CloudFrontキャッシュをクリア
aws cloudfront create-invalidation \
  --distribution-id $(terraform -chdir=terraform output -raw cloudfront_distribution_id) \
  --paths "/*"
```

## 変数のカスタマイズ

`terraform.tfvars` を作成：

```hcl
aws_region   = "ap-northeast-1"
project_name = "my-hugo-site"

tags = {
  Project     = "my-hugo-site"
  Environment = "production"
  ManagedBy   = "terraform"
}
```

## 出力値

| 出力名 | 説明 |
|--------|------|
| `bucket_name` | S3バケット名 |
| `s3_website_url` | S3 Direct のURL（CDN無し） |
| `cloudfront_url` | CloudFront のURL（CDN経由） |
| `deploy_command` | デプロイコマンドの例 |
| `comparison_summary` | 比較サマリー |

## 比較

| 項目 | S3 Direct | CloudFront |
|------|-----------|------------|
| プロトコル | HTTP のみ | HTTPS |
| キャッシュ | なし | エッジキャッシュ |
| 配信速度 | 単一リージョン | グローバルCDN |
| コスト | 低い | やや高い |
| 圧縮 | なし | gzip有効 |

## リソース削除

```bash
terraform destroy
```

## 注意事項

- S3バケットは**インターネットに公開**されます（テスト用）
- CloudFrontのデプロイには15-20分かかることがあります
- カスタムドメインを使用する場合は、ACM証明書とRoute 53の設定が追加で必要です
