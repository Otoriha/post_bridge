class GithubClient
    attr_reader :authentication

    def initialize(authentication)
      @authentication = authentication
    end

    def client
      @client ||= Octokit::Client.new(
        access_token: authentication.access_token,
        auto_paginate: true
      )
    end

    # リポジトリの一覧を取得
    def repositories
      client.repositories
    end

    # 特定のリポジトリにファイルを作成または更新
    def create_or_update_file(repo, path, content, message, branch = nil)
      options = {}
      options[:branch] = branch if branch.present?

      # 既存のファイルがあるか確認
      begin
        file = client.contents(repo, path: path)
        sha = file.sha

        # ファイルが存在する場合は更新
        client.update_contents(
          repo,
          path,
          message,
          sha,
          content,
          options
        )
      rescue Octokit::NotFound
        # ファイルが存在しない場合は新規作成
        client.create_contents(
          repo,
          path,
          message,
          content,
          options
        )
      end
    end

    # GistにファイルをPOST
    def create_gist(files, description, public = false)
      client.create_gist(
        files: files,
        description: description,
        public: public
      )
    end

    # Issueを作成
    def create_issue(repo, title, body)
      client.create_issue(repo, title, body)
    end

    # README.mdにマークダウンコンテンツを投稿/更新（一般的なユースケース）
    def update_readme(repo, content, message = "Update README", branch = "main")
      create_or_update_file(repo, "README.md", content, message, branch)
    end

    # ユーザー情報の取得
    def user
      client.user
    end

    # 認証ユーザーのメールアドレス一覧を取得
    def emails
      client.emails
    end

    # 特定のリポジトリのPull Requestを取得
    def pull_requests(repo, state = "open")
      client.pull_requests(repo, state: state)
    end

    # エラーハンドリングを含めた安全な実行
    def safely_execute
      begin
        yield
      rescue Octokit::Unauthorized
        # アクセストークンが無効または期限切れ
        { error: "GitHub認証エラー: アクセストークンが無効または期限切れです" }
      rescue Octokit::NotFound => e
        # リソースが見つからない
        { error: "GitHub 404エラー: #{e.message}" }
      rescue Octokit::Error => e
        # その他のOckokitエラー
        { error: "GitHubエラー: #{e.message}" }
      rescue StandardError => e
        # その他の一般的なエラー
        { error: "エラーが発生しました: #{e.message}" }
      end
    end
end
