# Google Cloud Terraform 最小構成

このプロジェクトはGoogle Cloud Platform (GCP) とTerraformを使用した最小構成のインフラストラクチャコードです。

## 構成

- **プロバイダー**: Google Cloud Provider v5.x
- **リソース**: Cloud Storage バケット（例）
- **リージョン**: asia-northeast1（東京）

## セットアップ

1. GCPプロジェクトIDを設定:
   ```bash
   # terraform/terraform.tfvars を編集
   project_id = "your-gcp-project-id"
   ```

2. Terraform初期化:
   ```bash
   cd terraform
   terraform init
   ```

3. プランの確認:
   ```bash
   terraform plan
   ```

4. リソースの作成:
   ```bash
   terraform apply
   ```

## 含まれるリソース

- Cloud Storage バケット（30日後自動削除設定付き）

## ファイル構成

```
terraform/
├── main.tf           # メインのリソース定義
├── versions.tf       # Terraformバージョン制約
├── terraform.tfvars # 変数値設定
└── terraform.tfstate # 状態ファイル（自動生成）
```