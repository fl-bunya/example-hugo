variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name (used for resource naming)"
  type        = string
  default     = "fl-bunya-example-hugo"
}

variable "domain_name" {
  description = "Custom domain name (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "fl-bunya-example-hugo"
    ManagedBy = "terraform"
  }
}

