$1

特定の機能やコードの詳細な動作を調査し、処理フローとデータの流れを報告します。

注意：このコマンドは既存コードの動作を理解するためのものです。
新しい機能の設計や実装計画を立てるものではありません。

## 目的

- 特定の処理がどのように実装されているかを明らかにする
- データがどの経路で永続化され、どのように取得・表示されるかを追跡する
- 関連するコンポーネントとその役割を整理する
- 調査結果を他のメンバーが理解できる形で記録する

## 出力物

このコマンドでは、以下の3つのカテゴリで出力を行います：

- **返答**: 作業完了の報告や調査結果の要約など、フロー型の出力（会話として返す）
- **成果物**: ドキュメントや整理結果など、ストック型の出力（後から参照できる形で返す）
  - 成果物の保存先について指示がある場合は、指定された箇所に書き込む
  - 指示がない場合は、通常のレスポンスとして返答の後に続けて出力する
- **作業**: システムへの変更や実行など、副作用を伴う作業

本コマンドの出力：

**返答**: 調査完了を報告する

**成果物**: 処理フローとデータの流れの調査結果をレスポンスとして出力する

**作業**: なし

## 入力で確認すること

- 調査対象の機能や処理（具体的な操作や画面、APIエンドポイント等）
- 調査の目的（なぜ調査するのか）
- 既存のドキュメントや関連する調査結果
- 調査に必要な環境（開発環境、ステージング環境等）
- 情報が不足している場合は、着手前に質問を箇条書きする

## 手順

### 1. 調査対象の特定

- 具体的に何を調査するのかを明確にする
- エントリーポイント（ユーザー操作、APIコール、バッチ処理等）を特定する
- 調査のゴール（どこまで追うか）を決める

### 2. エントリーポイントの確認

- トリガーとなる操作やイベントを特定
- 最初に実行されるコード（コントローラー、ハンドラー等）を見つける
- 入力データの形式を確認

### 3. 処理フローの追跡

スタックフレーム風に処理を追跡：
- 各関数/メソッド呼び出しを番号付きリストで記述
- ネストで呼び出し階層を表現
- 各ステップで以下を記録：
  - クラス/メソッド名とファイルパス
  - 主要な処理内容
  - データの変換や状態変化
  - 外部サービスやDBへのアクセス

### 4. 関連コンポーネントの整理

- 処理に関わるすべてのファイルをリストアップ
- データベーステーブル、外部API、設定ファイル等を列挙
- 各コンポーネントの役割を簡潔に説明

### 5. データ構造の記録

- 入力データの形式
- 中間データの変換
- 永続化されるデータ
- 出力/表示されるデータ

### 6. 重要な発見の記録

- 想定と異なる挙動
- 複雑な処理や分かりにくいロジック
- パフォーマンス上の懸念
- セキュリティやエラーハンドリングに関する注意点
- 改善の余地がある箇所

## 出力例

```
## 調査内容

xxx管理画面でyyの画像を更新したとき、それがどの経路で永続化されどの経路で画面上に出ているのか

## エントリーポイント

- トリガー：管理画面の「画像を変更」ボタンクリック後、ファイル選択してアップロード
- 初期リクエスト：POST /api/admin/users/:id/profile_image
- 入力データ：FormData { image: File, user_id: "123" }

## 処理フロー

- Admin::UsersController#update_profile_image (`app/controllers/admin/users_controller.rb:67`)
   - パラメータを受け取る: `{ image: <file>, user_id: 123 }`
   - 認可チェック（管理者権限）
   - UserImageService.update (`app/services/user_image_service.rb:15`)
     - 画像ファイルのバリデーション（形式、サイズ）
     - ImageProcessor.resize (`app/lib/image_processor.rb:23`)
       - 元画像を3サイズにリサイズ（large: 800x800, medium: 400x400, small: 100x100）
       - 一時ファイルに保存: `/tmp/resized_*.jpg`
     - S3Uploader.upload_multiple (`app/uploaders/s3_uploader.rb:45`)
       - S3バケット `app-images-prod` に3ファイルをアップロード
       - キー: `users/123/profile/{large,medium,small}_20251208.jpg`
       - 返却: `{ large: "https://...", medium: "https://...", small: "https://..." }`
     - User.update (`app/models/user.rb:134`)
       - データベース更新: `users.profile_image_urls` (JSONB型)
       - 値: `{ large: "https://...", medium: "https://...", small: "https://..." }`
       - 古い画像URLは `users.previous_profile_image_urls` に保存（ロールバック用）
       - ImageCleanupJob.perform_later (`app/jobs/image_cleanup_job.rb:12`)
         - 非同期で古い画像を削除（Sidekiq経由）
   - レスポンス返却: `{ success: true, image_urls: {...} }`

## 表示経路

1. 管理画面でユーザー情報取得: GET /api/admin/users/:id
2. Admin::UsersController#show (`app/controllers/admin/users_controller.rb:23`)
   - 3. User#profile_image_url (medium) (`app/models/user.rb:89`)
     - `profile_image_urls["medium"]` を返却
     - CloudFront経由のURL: `https://cdn.example.com/users/123/profile/medium_20251208.jpg`
3. フロントエンド（React）で表示: UserProfileImage コンポーネント (`frontend/src/components/UserProfileImage.tsx:45`)
   - <img src={imageUrl} /> でレンダリング

## 関連コンポーネント

ソースコード：
- `app/controllers/admin/users_controller.rb` - 画像更新のエントリーポイント
- `app/services/user_image_service.rb` - 画像更新のビジネスロジック
- `app/lib/image_processor.rb` - 画像リサイズ処理
- `app/uploaders/s3_uploader.rb` - S3アップロード処理
- `app/models/user.rb` - ユーザーモデル
- `app/jobs/image_cleanup_job.rb` - 古い画像の削除ジョブ
- `frontend/src/components/UserProfileImage.tsx` - 画像表示コンポーネント

データベース：
- `users` テーブル
  - `profile_image_urls` (JSONB): 現在の画像URL
  - `previous_profile_image_urls` (JSONB): 直前の画像URL

外部サービス：
- AWS S3 バケット: `app-images-prod`
- CloudFront ディストリビューション: `cdn.example.com`

設定ファイル：
- `config/storage.yml` - S3設定
- `config/sidekiq.yml` - バックグラウンドジョブ設定

## 重要な発見

- 画像は3サイズ同時に作成され、S3に保存される
- CloudFront経由で配信されるため、キャッシュの考慮が必要
- 古い画像は非同期で削除されるため、即座には消えない（Sidekiqキューの状態に依存）
- ロールバック用に直前の画像URLが保持されている
- 画像アップロード中にエラーが発生した場合、トランザクションでロールバックされる
- ファイルサイズ制限: 5MB（`UserImageService` でバリデーション）

## 参考情報

- AWS S3 ドキュメント: https://docs.aws.amazon.com/s3/
- ImageProcessor gem ドキュメント: https://github.com/...
- 関連する過去の調査: tmp/investigations/user_image_upload_2024.md
```

## チェックポイント

- [ ] 調査対象とその目的が明確に記載されているか
- [ ] エントリーポイントが特定されているか
- [ ] 処理フローがスタックフレーム風に記述されているか
- [ ] 各ステップにファイルパスと行番号が含まれているか
- [ ] データの変換や状態変化が明示されているか
- [ ] 関連コンポーネントが漏れなくリストアップされているか
- [ ] 重要な発見や注意点が記載されているか
- [ ] 他のメンバーが読んで理解できる内容か
