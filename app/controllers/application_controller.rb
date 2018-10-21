class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include LoginsHelper

  before_filter :get_users

  def get_users
    if current_user
      @selected_user = User.find_by_id(params[:user_id])
      @sidebar_users = User.where.not(id: current_user.id)
    else
      @sidebar_users = []
    end
  end
end
