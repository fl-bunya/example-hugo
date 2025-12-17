#===============================================================================
# S3 Bucket (Public + CloudFront 共用)
#===============================================================================

resource "aws_s3_bucket" "site" {
  bucket = local.bucket_name

  tags = merge(var.tags, {
    Name = var.project_name
  })
}

# パブリックアクセスブロックを無効化（テスト用）
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 静的ウェブサイトホスティングを有効化
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# バケットポリシー（パブリック読み取り許可）
# CloudFrontはパブリックバケットに直接アクセス
resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  depends_on = [aws_s3_bucket_public_access_block.site]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.site.arn}/*"
      }
    ]
  })
}

# CORS設定
resource "aws_s3_bucket_cors_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

#===============================================================================
# CloudFront Distribution
#===============================================================================

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "${var.project_name} Hugo Site"
  price_class         = "PriceClass_200" # アジア、欧州、北米

  # パブリックバケットのウェブサイトエンドポイントをオリジンに指定
  origin {
    # S3ウェブサイトエンドポイントを使用（OAC不要）
    domain_name = aws_s3_bucket_website_configuration.site.website_endpoint
    origin_id   = "S3-Website-${aws_s3_bucket.site.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # S3ウェブサイトはHTTPのみ
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website-${aws_s3_bucket.site.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  # 404エラーの処理
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-cloudfront"
  })
}

