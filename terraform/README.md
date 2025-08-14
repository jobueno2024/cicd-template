# Terraform for GCP Workload Identity Federation with GitHub Actions

## 概要

このTerraformプロジェクトは、GCP Workload Identity FederationをGitHub Actionsと連携させるための設定を行います。
これにより、GitHub ActionsがGoogle Cloudに認証し、サービスアカウントとしてリソースにアクセスできるようになります。

以下のリソースが作成されます。
- Workload Identity Pool
- GitHub Actions用のWorkload Identity Pool Provider
- サービスアカウント
- サービスアカウントとWorkload Identity PoolのIAMバインディング

## 前提条件

- Terraformがインストールされていること
- Google Cloud SDKがインストールされ、認証済みであること
- Google Cloudプロジェクトが存在すること

## 使い方

1.  このリポジトリをクローンします。
2.  以下の内容で`terraform.tfvars`ファイルを作成します。
    ```
    project_id      = "your-gcp-project-id"
    region          = "your-gcp-region"
    github_repository = "your-github-organization/your-github-repository"
    ```
3.  `terraform init`を実行してプロジェクトを初期化します。
4.  `terraform plan`を実行して実行計画を確認します。
5.  `terraform apply`を実行して変更を適用します。

## 入力

| 名前              | 説明                                                    | タイプ   | デフォルト | 必須 |
| ----------------- | ------------------------------------------------------- | ------ | ------- | :--: |
| `project_id`      | GCPプロジェクトのID。                                     | `string` | `null`    | はい |
| `region`          | リソースを作成するGCPリージョン。                         | `string` | `null`    | はい |
| `github_repository` | `owner/repository`形式のGitHubリポジトリ。              | `string` | `null`    | はい |

## 出力

| 名前                       | 説明                               |
| -------------------------- | ---------------------------------- |
| `workload_identity_provider` | Workload Identity Providerのリソース名。 |
| `service_account_email`    | 作成されたサービスアカウントのメールアドレス。 |
