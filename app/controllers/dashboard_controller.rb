class DashboardController < ApplicationController
  before_action :require_login

  def index
    @authentications = current_user.authentications
    @posts = current_user.posts.order(created_at: :desc)
  end
end
