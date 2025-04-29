class OmniauthCallbacksController < ApplicationController
  def callback
    # OmniAuthからの認証情報を取得
    auth = request.env['omniauth.auth']

    # 既存の認証情報を検索
    authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)

    if authentication
      # 既存の認証情報があれば、そのユーザーでログイン
      session[:user_id] = authentication.user_id
      update_authentication(authentication, auth)
      redirect_to dashboard_path, notice: "#{auth.provider.capitalize}でログインしました"
    else
      # 認証情報がなければ、ユーザーを検索または作成
      if current_user
        # ログイン済みの場合は、現在のユーザーに認証情報を追加
        create_authentication(current_user, auth)
        redirect_to dashboard_path, notice: "#{auth.provider.capitalize}のアカウントを接続しました"
      else
        # ログインしていない場合は、メールアドレスでユーザーを検索
        user = User.find_by(email: auth.info.email) if auth.info.email

        unless user
          # ユーザーが存在しなければ作成
          user = create_user_from_auth(auth)
        end

        # 認証情報を追加してログイン
        create_authentication(user, auth)
        session[:user_id] = user.id
        redirect_to dashboard_path, notice: "#{auth.provider.capitalize}でログインしました"
      end
    end
  end

  def failure
    redirect_to login_path, alert: "認証に失敗しました: #{params[:message]}"
  end

  private

  def create_user_from_auth(auth)
    # 認証情報からユーザーを作成
    name = auth.info.name || auth.info.nickname
    email = auth.info.email

    User.create!(
      name: name,
      email: email
    )
  end

  def create_authentication(user, auth)
    # トークン情報を保存
    user.authentications.create!(
      provider: auth.provider,
      uid: auth.uid,
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil,
      info: auth.to_hash
    )
  end

  def update_authentication(authentication, auth)
    # トークン情報を更新
    authentication.update(
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil,
      info: auth.to_hash
    )
  end
end