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

variable "github_repo_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
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

output "workload_identity_provider" {
  description = "Workload Identity Provider (GitHub Secretsで使用)"
  value       = google_iam_workload_identity_pool_provider.main.name
}

output "service_account_email" {
  description = "Service Account Email (GitHub Secretsで使用)"
  value       = google_service_account.main.email
}

locals {
  project_id        = var.project_id
  github_repo_owner = var.github_repo_owner
  github_repo_name  = var.github_repo_name
}

resource "google_iam_workload_identity_pool" "main" {
  workload_identity_pool_id = "github"
  display_name              = "GitHub"
  description               = "GitHub Actions 用 Workload Identity Pool"
  disabled                  = false
  project                   = local.project_id
}

resource "google_iam_workload_identity_pool_provider" "main" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub"
  description                        = "GitHub Actions 用 Workload Identity Poolプロバイダ"
  disabled                           = false
  attribute_condition                = "assertion.repository_owner == \"${local.github_repo_owner}\""
  attribute_mapping = {
    "google.subject" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  project = local.project_id
}

resource "google_service_account_iam_member" "workload_identity_sa_iam" {
  service_account_id = google_service_account.main.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/subject/${local.github_repo_owner}/${local.github_repo_name}"
}

resource "google_service_account" "main" {
  account_id   = "github-test"
  display_name = "github-test"
  description  = "GitHub Actions 動作確認用"
  project      = local.project_id
}

# サービスアカウントに必要な権限を付与
resource "google_project_iam_member" "storage_admin" {
  project = local.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.main.email}"
}

resource "google_project_iam_member" "compute_viewer" {
  project = local.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.main.email}"
}