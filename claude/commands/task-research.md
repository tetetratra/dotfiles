$1

これから導入・実装する技術や概念について、前提知識・関連知識を収集・整理します。

注意：このコマンドは新しく導入する技術の理解を深めるためのものです。
既存コードの動作理解にはinvestigation、flow-traceを使用してください。

## 出力物

このコマンドでは、以下の3つのカテゴリで出力を行います：

- **返答**: 作業完了の報告や調査結果の要約など、フロー型の出力（会話として返す）
- **成果物**: ドキュメントや整理結果など、ストック型の出力（後から参照できる形で返す）
  - 成果物の保存先について指示がある場合は、指定された箇所に書き込む
  - 指示がない場合は、通常のレスポンスとして返答の後に続けて出力する
- **作業**: システムへの変更や実行など、副作用を伴う作業

本コマンドの出力：

**返答**: 調査完了を報告する

**成果物**: 技術・概念の調査結果をネストリスト形式でレスポンスとして出力する

**作業**: なし

## 目的

- これから導入する技術について「それは何か」「なぜ使うのか」「どう使うのか」を理解する
- 専門用語や前提知識を先回りして解説する
- 因果関係を明確にし、「なぜそれが必要か」の根拠を示す
- 実装着手可能なレベルまで疑問を解消する

## 入力で確認すること

- 対象タスクの内容（何を導入・実装するのか）
- 既に分かっている情報・既知の技術
- 調査の深さ（どこまで掘り下げるか）
- 情報が不足している場合は、着手前に質問を箇条書きする

## 手順

### 大方針

1. **連想ツリーを広げる**: タスクから疑問を列挙
2. **答えを調査・整理する**: 各疑問に答え、因果関係を明確にする
3. **再帰**: 答えから新たな疑問が生まれたら、1に戻る
4. **終了判定**: 実装着手可能なレベルまで掘り下げたら整理して出力

### 「連想ツリーを広げる」の具体的方法

1. **技術キーワードの抽出**
   - タスク文から技術・ツール・概念を抽出
   - 例: "dependabot-bundler-conservative" → "dependabot", "bundler", "conservative", "GitHub Actions"

2. **各キーワードについて疑問を生成**
   - **What**: それは何か？
   - **Why**: なぜ使うのか？なぜ必要か？
   - **How**: どう使うのか？どう導入するのか？

3. **Howから派生する疑問を生成**
   - 手順の中で出てくる専門用語
   - 前提条件（権限、トークン、設定など）
   - ファイル・ディレクトリの場所

4. **具体的な疑問形式にする**
   - ❌ 抽象的: "トークンとは？"
   - ⭐ 具体的: "なぜトークンが必要？" "どうやって作る？" "どの権限が必要？"

### 「答えを調査・整理する」の具体的方法

1. **情報源の優先順位**
   - 公式ドキュメント（最優先）
   - 社内リポジトリの事例（Grep/Glob）
   - 信頼できる技術記事・ブログ（WebSearch）
   - GitHub公式リポジトリのexample

2. **答えの記載方法**
   - 簡潔に（2〜3文）
   - 詳細は公式ドキュメントへリンク
   - コード例があれば短く引用

3. **因果関係を明確にする（重要）**
   - 「〜が必要」と述べる場合、必ず「なぜ必要か」の根拠を示す
   - 因果の連鎖を追える形で記述する
   - 例:
     ```
     ❌ 悪い例: PRを自動作成するためにGITHUB_TOKENが必要

     ⭐ 良い例:
     - dependabotはPRを自動作成する
     - PRの作成はGitHub APIを呼び出す操作
     - GitHub APIは認証が必要（不正アクセス防止のため）
     - 認証にはトークンが使われる
     - よって、API経由でPRを作成するにはトークンが必要
     ```

4. **新たな疑問の抽出**
   - 答えの中で登場した専門用語
   - 「〜が必要」という記述 → 「なぜ必要？」「どうやって準備？」
   - これらを疑問ツリーに追加して次のサイクルへ

### 終了条件

以下のいずれかを満たしたら終了：
- 実装に着手できるレベルまで疑問が解消された
- 3〜5階層程度まで掘り下げた
- すべての疑問に根拠のある答えが得られた

## 具体的な調査プロセスの例

**タスク**: 「dependabot-bundler-conservativeをGitHub Actionsで導入したい」

### 第1サイクル: 初期の疑問を広げる

#### 連想ツリーを広げる（第1階層）
- dependabot-bundler-conservativeとは？
- GitHub Actionsとは？
- どう導入するのか？

#### 答えを調査・整理する
1. **dependabot-bundler-conservativeとは？**
   - WebSearch調査 → 単一のツールではなく、以下の組み合わせを指す概念
     - Dependabot: GitHubの依存関係自動更新ツール
     - bundlerの`--conservative`フラグ: 最小限の依存関係のみ更新するオプション
   - **重要な発見**: 公式Dependabotには`--conservative`オプションを使う設定が存在しない
   - 実現方法: カスタムGitHub Actionsワークフローで`bundle update --conservative`を実行
   - **新たな疑問**: bundler --conservativeの具体的な動作は？なぜ必要なのか？カスタムワークフローの具体的な作り方は？

2. **GitHub Actionsとは？**
   - 既知と判断 → GitHubのCI/CDプラットフォーム
   - **新たな疑問**: なし

3. **どう導入するのか？**
   - 公式ドキュメント調査 → カスタムワークフローファイルを作成
   - **新たな疑問**: どこに作る？どんな内容を書く？

### 第2サイクル: 新たな疑問を広げる

#### 連想ツリーを広げる（第2階層）
- bundler --conservativeとは？なぜ必要？
- ワークフローファイルの具体的な内容は？
- GITHUB_TOKENとは？なぜ必要？
- GITHUB_TOKENの設定方法は？
- 必要な権限は？

#### 答えを調査・整理する
1. **bundler --conservativeとは？なぜ必要？**
   - Bundler 1.14で導入されたフラグ
   - `bundle update --conservative GEM_NAME`の形式で使用
   - 指定したgemのみを更新し、共有依存関係の更新を防ぐ
   - なぜ必要？
     - セキュリティ脆弱性対応などで特定のgemのみ更新したい場合に有用
     - 意図しない大規模な依存関係更新を防ぐため
     - リスクを最小化し、小さなステップで更新を進められるため
   - **新たな疑問**: なし

2. **ワークフローファイルの具体的な内容は？**
   - 場所: `.github/workflows/`配下にYAMLファイルを作成
   - 基本構成:
     - トリガー設定（schedule、workflow_dispatchなど）
     - permissions設定
     - Ruby環境のセットアップ
     - `bundle update --conservative`の実行
     - PR作成
   - **新たな疑問**: PR作成にはどのActionを使うのか？

3. **GITHUB_TOKENとは？なぜ必要？**
   - GitHub Actionsワークフロー内で自動生成される認証トークン
   - `${{ secrets.GITHUB_TOKEN }}`で参照
   - なぜ必要？（因果関係を明確にする）:
     - カスタムワークフローはPRを自動作成する
     - PRの作成はGitHub APIを呼び出す操作
     - GitHub APIは認証が必要
       - 理由: 不正アクセスを防止するため
       - 理由: 誰が操作を行っているかを識別するため
     - 認証にはトークンが使われる
     - よって、API経由でPRを作成するにはGITHUB_TOKENが必要
   - **新たな疑問**: なし

4. **GITHUB_TOKENの設定方法は？**
   - 自動生成されるため手動作成は不要
   - ワークフローファイルで`${{ secrets.GITHUB_TOKEN }}`と記述するだけ
   - 権限設定は`permissions`キーで制御
   - **新たな疑問**: なし

5. **必要な権限は？**
   - `contents: write`
   - `pull-requests: write`
   - **新たな疑問**: なぜこれらの権限が必要なのか？

### 第3サイクル: さらに掘り下げる

#### 連想ツリーを広げる（第3階層）
- PR作成にはどのActionを使うのか？
- contents: writeとは？なぜ必要？
- pull-requests: writeとは？なぜ必要？

#### 答えを調査・整理する
1. **PR作成にはどのActionを使うのか？**
   - `peter-evans/create-pull-request`が広く使われている
   - 代替: `gh` CLI（GitHub公式コマンドラインツール）も使用可能
   - 機能:
     - 変更を新しいブランチにコミット
     - PRを自動作成または更新
     - PRのタイトル、本文、ラベル、レビュアーを設定可能
   - **新たな疑問**: なし

2. **contents: writeとは？なぜ必要？**
   - リポジトリの内容に対する書き込み権限
   - ファイルの作成、更新、削除が可能になる
   - なぜ必要？（因果関係を明確にする）:
     - `bundle update --conservative`は`Gemfile.lock`を更新する
     - `Gemfile.lock`の更新はリポジトリ内のファイルの変更
     - GitHub APIでリポジトリ内のファイルを変更するには`contents: write`権限が必要
     - よって、依存関係ファイルを更新してコミットするために`contents: write`が必要
   - **新たな疑問**: なし

3. **pull-requests: writeとは？なぜ必要？**
   - PRの作成、更新、削除ができる権限
   - PRへのコメント追加、レビュアー指定なども可能
   - なぜ必要？（因果関係を明確にする）:
     - ワークフローはPRを作成する
     - PRの作成はGitHub APIの`/pulls`エンドポイントを呼び出す操作
     - GitHub APIでPRを作成・更新するには`pull-requests: write`権限が必要
     - よって、自動的にPRを作成するために`pull-requests: write`が必要
   - **新たな疑問**: リポジトリ設定で追加の設定は必要か？

### 第4サイクル: 実装の具体的手順

#### 連想ツリーを広げる（第4階層）
- リポジトリ設定で追加の設定は必要か？
- 実際のワークフローファイルの完全な例は？

#### 答えを調査・整理する
1. **リポジトリ設定で追加の設定は必要か？**
   - リポジトリ設定で「Allow GitHub Actions to create and approve pull requests」を有効にする必要がある
   - デフォルトでは、新しいリポジトリではこの設定が無効になっている
   - 場所: Settings > Actions > General > Workflow permissions
   - なぜ必要？:
     - セキュリティのため、デフォルトではActionsによるPR作成が制限されている
     - 明示的に許可することで、自動化されたPR作成が可能になる
   - **新たな疑問**: なし

2. **実際のワークフローファイルの完全な例は？**
   - 収集した情報を統合した完全なYAML例を作成
   - **新たな疑問**: なし

### 終了判定
✅ すべての疑問に因果関係を持った答えが得られた
✅ 実装に必要な情報が揃った
✅ 4階層まで掘り下げた
→ 整理して出力

## 成果物例

```
## 前提知識・関連知識

- dependabot-bundler-conservativeとは？
  - 単一のツールではない
  - 以下の組み合わせを指す概念
    - Dependabot：GitHubの依存関係自動更新ツール
    - bundlerの`--conservative`フラグ：最小限の依存関係のみ更新するオプション
  - 重要な発見：公式Dependabotには`--conservative`オプションを使う設定が存在しない（参考：https://github.com/dependabot/dependabot-core/issues/5926）
  - 実現方法：カスタムGitHub Actionsワークフローで`bundle update --conservative`を実行

  - bundler --conservativeとは？
    - Bundler 1.14で導入されたフラグ（参考：https://depfu.com/blog/2017/04/25/bundlers-new-update-options）
    - `bundle update --conservative GEM_NAME`の形式で使用
    - 指定したgemのみを更新し、共有依存関係の更新を防ぐ
    - なぜ必要？
      - セキュリティ脆弱性対応などで特定のgemのみ更新したい場合に有用
      - 意図しない大規模な依存関係更新を防ぐため
      - リスクを最小化し、小さなステップで更新を進められるため

- GitHub Actionsでの導入方法
  - ワークフローファイルを作成
    - どこに作る？
      - `.github/workflows/`配下にYAMLファイルを作成
    - どんな内容を書く？
      - トリガー設定（schedule、workflow_dispatchなど）
      - permissions設定
      - ジョブ定義
        - Ruby環境のセットアップ
        - `bundle update --conservative`の実行
        - PR作成

  - GITHUB_TOKENが必要（参考：https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication）
    - なぜ必要？
      - カスタムワークフローはPRを自動作成する
      - PRの作成はGitHub APIを呼び出す操作
      - GitHub APIは認証が必要
        - 理由：不正アクセスを防止するため
        - 理由：誰が操作を行っているかを識別するため
      - 認証にはトークンが使われる
      - よって、API経由でPRを作成するにはGITHUB_TOKENが必要

    - どうやって設定する？
      - 自動生成されるため手動作成は不要
      - ワークフローファイルで`${{ secrets.GITHUB_TOKEN }}`と記述するだけ

    - 必要な権限は？
      - `contents: write`
        - なぜ必要？
          - `bundle update --conservative`は`Gemfile.lock`を更新する
          - `Gemfile.lock`の更新はリポジトリ内のファイルの変更
          - GitHub APIでリポジトリ内のファイルを変更するには`contents: write`権限が必要
          - よって、依存関係ファイルを更新してコミットするために必要

      - `pull-requests: write`
        - なぜ必要？
          - ワークフローはPRを作成する
          - PRの作成はGitHub APIの`/pulls`エンドポイントを呼び出す操作
          - GitHub APIでPRを作成・更新するには`pull-requests: write`権限が必要
          - よって、自動的にPRを作成するために必要

  - PR作成方法
    - `peter-evans/create-pull-request` Actionを使用
      - 変更を新しいブランチにコミット
      - PRを自動作成または更新
      - PRのタイトル、本文、ラベル、レビュアーを設定可能
    - 代替：`gh` CLI（GitHub公式コマンドラインツール）も使用可能

  - リポジトリ設定
    - 「Allow GitHub Actions to create and approve pull requests」を有効化
    - 場所：Settings > Actions > General > Workflow permissions
    - なぜ必要？
      - セキュリティのため、デフォルトではActionsによるPR作成が制限されている
      - 明示的に許可することで、自動化されたPR作成が可能になる

- ワークフローファイルの完全な例
  ```yaml
  name: Conservative Bundle Update
  on:
    schedule:
      - cron: '0 0 * * 0'  # 毎週日曜日
    workflow_dispatch:  # 手動実行も可能

  permissions:
    contents: write
    pull-requests: write

  jobs:
    bundle-update:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4

        - uses: ruby/setup-ruby@v1
          with:
            ruby-version: '3.2'
            bundler-cache: false

        - name: Run conservative bundle update
          run: bundle update --conservative

        - name: Create Pull Request
          uses: peter-evans/create-pull-request@v5
          with:
            token: ${{ secrets.GITHUB_TOKEN }}
            commit-message: 'Update gems conservatively'
            title: 'Conservative bundle update'
            body: |
              This PR updates gems using the `--conservative` flag.
              Only necessary dependencies are updated.
            branch: bundle-update-conservative
  ```

## 参考情報
- 公式ドキュメント：
  - Bundler update options: https://depfu.com/blog/2017/04/25/bundlers-new-update-options
  - GitHub Actions permissions: https://docs.github.com/en/actions/how-tos/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token
  - Automatic token authentication: https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication
- Dependabotの制限に関するissue: https://github.com/dependabot/dependabot-core/issues/5926
- peter-evans/create-pull-request: https://github.com/peter-evans/create-pull-request
```

## チェックポイント

全体：
- [ ] タスクから技術キーワードを正しく抽出できているか
- [ ] すべての疑問に答えが得られているか
- [ ] 実装着手可能なレベルまで掘り下げたか
- [ ] ネストリスト形式で出力されているか

因果関係：
- [ ] 「〜が必要」に対して「なぜ必要か」の根拠が示されているか
- [ ] 因果の連鎖が追える形になっているか
- [ ] 専門用語に対する説明があるか

情報源：
- [ ] 公式ドキュメントへのリンクが含まれているか
- [ ] 社内の参考事例が検索されているか
- [ ] 信頼できる情報源から調査しているか

返答：
- [ ] 調査完了を報告しているか
- [ ] 成果物として調査結果をレスポンスとして出力しているか
