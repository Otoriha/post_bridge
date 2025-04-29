Rails.application.config.middleware.use OmniAuth::Builder do
    # GitHub
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'user,repo'

    # Twitter
    provider :twitter2, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET'],
      redirect_uri: ENV['TWITTER_REDIRECT_URI'],
      scope: "tweet.read users.read tweet.write"
  end

  # 認証失敗時の処理
  OmniAuth.config.on_failure = Proc.new do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
