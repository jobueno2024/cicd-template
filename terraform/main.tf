terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Workload Identity Pool の作成
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool-2"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions"
}

# Workload Identity Provider の作成
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "Workload Identity Provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = format("assertion.repository==\"%s\"", var.github_repository)
}

# サービスアカウントの作成
resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "GitHub Actions Service Account"
  description  = "Service account for GitHub Actions"
}

# Workload Identity User ロールの付与
resource "google_service_account_iam_binding" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [
    format("principalSet://iam.googleapis.com/%s/attribute.repository/%s",
      google_iam_workload_identity_pool.github_pool.name,
      var.github_repository
    )
  ]
}