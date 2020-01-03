class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include LoginsHelper

  before_filter :get_objs_from_params, :get_users

  def get_objs_from_params
    @family = Family.find_by_id(params[:family_id])
    @user = User.find_by_id(params[:user_id])
    @gift = Gift.find_by_id(params[:gift_id])
  end

  def get_users
    @sidebar_users = []
    if current_user and @family
      @sidebar_users = @family.users.where.not(id: current_user.id)
    end
  end
end
