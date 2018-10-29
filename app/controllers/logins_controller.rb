class LoginsController < ApplicationController
  def new
    @enable_sign_up = ENV['ENABLE_SIGN_UP']
    @hide_sidebar = true
    @user = User.new

    if current_user
      redirect_to users_path
    end
  end

  def create
    user = User.find_by(username: params[:username])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to users_path
    else
      flash[:danger] = 'Invalid username or password'
      redirect_to :back
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
