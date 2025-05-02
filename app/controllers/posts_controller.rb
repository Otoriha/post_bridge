class PostsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:edit, :update]

  def new
    @post = current_user.posts.build
    @post_templates = current_user.post_templates
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.status = params[:publish_button].present? ? "published" : "draft"

    if @post.save
      # 公開する場合は連携サービスへの投稿処理を行う
      if @post.published?
        create_post_deliveries
        redirect_to dashboard_path, notice: '投稿が公開されました'
      else
        redirect_to dashboard_path, notice: '下書きが保存されました'
      end
    else
      @post_templates = current_user.post_templates
      render :new
    end
  end

  def edit
    @post_templates = current_user.post_templates
  end

  def update
    if @post.update(post_params)
      # 連携先へ投稿処理（更新時にも投稿したい場合）
      if params[:publish] && @post.status == "published"
        create_post_deliveries
      end

      redirect_to dashboard_path, notice: '投稿が更新されました'
    else
      @post_templates = current_user.post_templates
      render :edit
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :is_favorite, :post_template_id)
  end

  def create_post_deliveries
    # 選択された連携サービスに投稿する処理
    selected_auth_ids = params[:authentication_ids] || []
    selected_auth_ids.each do |auth_id|
      authentication = current_user.authentications.find_by(id: auth_id)
      next unless authentication

      @post.post_deliveries.create!(
        authentication: authentication,
        status: "pending"
      )
    end

    # ここでバックグラウンドジョブを呼び出すなど
    # PostDeliveryWorker.perform_async(@post.id)
  end
end