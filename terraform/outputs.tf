#===============================================================================
# Outputs
#===============================================================================

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.site.id
}

#-------------------------------------------------------------------------------
# S3 Direct (CDN無し)
#-------------------------------------------------------------------------------

output "s3_website_endpoint" {
  description = "S3 website endpoint (CDN無し・HTTP)"
  value       = aws_s3_bucket_website_configuration.site.website_endpoint
}

output "s3_website_url" {
  description = "S3 website URL (CDN無し)"
  value       = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

#-------------------------------------------------------------------------------
# CloudFront (CDN経由)
#-------------------------------------------------------------------------------

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_url" {
  description = "CloudFront URL (CDN経由・HTTPS)"
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

#-------------------------------------------------------------------------------
# デプロイコマンド
#-------------------------------------------------------------------------------

output "deploy_command" {
  description = "Command to deploy Hugo site"
  value       = <<-EOT
    
    # Hugo サイトをビルド
    hugo --gc --minify
    
    # S3 にデプロイ（1つのバケットで両方のURLからアクセス可能）
    aws s3 sync public/ s3://${aws_s3_bucket.site.id} --delete
    
    # CloudFrontのキャッシュをクリア
    aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.site.id} --paths "/*"
    
  EOT
}

#-------------------------------------------------------------------------------
# 比較用サマリー
#-------------------------------------------------------------------------------

output "comparison_summary" {
  description = "Comparison URLs"
  value       = <<-EOT
    
    ╔══════════════════════════════════════════════════════════════════╗
    ║                    アクセス方法の比較                            ║
    ╠══════════════════════════════════════════════════════════════════╣
    ║ 【同じS3バケット】: ${aws_s3_bucket.site.id}
    ╠══════════════════════════════════════════════════════════════════╣
    ║ S3 Direct (CDN無し)                                              ║
    ║   http://${aws_s3_bucket_website_configuration.site.website_endpoint}
    ║   • 直接S3からコンテンツ配信                                     ║
    ║   • HTTPのみ（HTTPSなし）                                        ║
    ║   • キャッシュなし                                               ║
    ╠══════════════════════════════════════════════════════════════════╣
    ║ CloudFront (CDN経由)                                             ║
    ║   https://${aws_cloudfront_distribution.site.domain_name}
    ║   • エッジロケーションからキャッシュ配信                         ║
    ║   • HTTPS対応                                                    ║
    ║   • gzip圧縮有効                                                 ║
    ╚══════════════════════════════════════════════════════════════════╝
    
  EOT
}
