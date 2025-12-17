#!/bin/bash
set -e

# プロジェクトルートに移動
cd "$(dirname "$0")/.."

# 色付き出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Hugo Build ===${NC}"
hugo --gc --minify

# Terraform出力から値を取得
BUCKET_NAME=$(terraform -chdir=terraform output -raw bucket_name 2>/dev/null)
CF_DIST_ID=$(terraform -chdir=terraform output -raw cloudfront_distribution_id 2>/dev/null)

if [ -z "$BUCKET_NAME" ]; then
  echo "Error: bucket_name not found. Run 'terraform apply' first."
  exit 1
fi

echo -e "${YELLOW}=== S3 Sync ===${NC}"
echo "Bucket: $BUCKET_NAME"
aws s3 sync public/ "s3://${BUCKET_NAME}" --delete

echo -e "${GREEN}✓ S3 deploy complete${NC}"

# CloudFrontキャッシュクリア（デフォルトで実行、--no-cacheでスキップ）
if [ -n "$CF_DIST_ID" ] && [ "$1" != "--no-cache" ]; then
  echo -e "${YELLOW}=== CloudFront Invalidation ===${NC}"
  aws cloudfront create-invalidation \
    --distribution-id "$CF_DIST_ID" \
    --paths "/*"
  echo -e "${GREEN}✓ CloudFront cache invalidated${NC}"
fi

echo ""
echo -e "${GREEN}=== Done ===${NC}"
terraform -chdir=terraform output s3_website_url 2>/dev/null || true
terraform -chdir=terraform output cloudfront_url 2>/dev/null || true

