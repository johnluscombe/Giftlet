class UsersController < ApplicationController
  before_filter :ensure_user_logged_in, except: [:new, :create]
  before_filter :ensure_user_not_logged_in, only: [:new, :create]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(safe_params)
    if @user.save
      redirect_to login_path
    else
      render 'new'
    end
  end

  def edit_basic_information
  end

  def edit_password
  end

  def update_basic_information
    if current_user.update(safe_params)
      redirect_to edit_basic_information_path
    else
      render 'edit_basic_information'
    end
  end

  def update_password
    check_passwords(BCrypt::Password.new(current_user.password_digest), params[:old_password])
    if current_user.update(safe_params)
      redirect_to edit_password_path
    else
      render 'edit_password'
    end
  end

  private

  def safe_params
    params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
  end

  def ensure_user_logged_in
    unless current_user
      flash[:danger] = 'You are not logged in'
      redirect_to login_path
    end
  end

  def ensure_user_not_logged_in
    if current_user
      redirect_to users_path
    end
  end

  def check_passwords(password_one, password_two)
    unless password_one == password_two
      flash[:danger] = 'Old password is incorrect'
      render 'edit_password'
    end
  end
end