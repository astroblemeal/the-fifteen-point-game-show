class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :set_current_user
  helper_method :current_user
  before_action -> { authorize_admin if admin_path? }

  private

  def authorize_admin
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end

  def admin_path?
    request.path.start_with?("/admin")
  end

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def current_user
    @current_user
  end
end
