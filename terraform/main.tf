# Google Cloud Provider設定

# プロバイダー設定
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 変数定義
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-northeast1-a"
}

# 最小リソース例: Cloud Storage バケット
resource "google_storage_bucket" "example" {
  name     = "${var.project_id}-example-bucket"
  location = var.region

  # バケット設定
  uniform_bucket_level_access = true

  # ライフサイクル設定
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# 出力
output "bucket_name" {
  description = "作成されたバケット名"
  value       = google_storage_bucket.example.name
}

output "bucket_url" {
  description = "バケットURL"
  value       = google_storage_bucket.example.url
}