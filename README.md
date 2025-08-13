# CI/CD Template for Google Cloud

このリポジトリは、GitHub Actionsを使用してGoogle Cloudへの自動デプロイを行うための最小構成テンプレートです。

## セットアップ手順

1. Google Cloud Projectの設定
   - Google Cloudコンソールで新しいプロジェクトを作成
   - Cloud Run APIを有効化
   - サービスアカウントの作成と鍵のダウンロード

2. GitHub Secretsの設定
   以下の2つのシークレットを設定する必要があります：
   - `GCP_PROJECT_ID`: Google CloudのプロジェクトID
   - `GCP_SA_KEY`: サービスアカウントのJSONキーの内容

3. アプリケーションのデプロイ
   - mainブランチにプッシュすると自動的にデプロイが開始されます
   - デプロイの進行状況はGitHubのActionsタブで確認できます

## 設定項目

`deploy-to-gcp.yml`で以下の項目を必要に応じて変更してください：

- `service`: デプロイするCloud Runサービスの名前
- `region`: デプロイするリージョン（デフォルト: asia-northeast1）