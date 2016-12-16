class UsersController < ApplicationController
  before_filter :ensure_user_logged_in, except: [:new, :create]
  before_filter :ensure_user_not_logged_in, only: [:new, :create]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def new
    ensure_passcode_exists
    @user = User.new
  end

  def create
    @user = User.new(safe_params)
    if check_site_passcode(params[:site_passcode])
      if @user.save
        flash[:success] = 'Account successfully created'
        redirect_to login_path
      else
        render 'new'
      end
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
      flash.now[:danger] = 'There was an error saving'
      render 'edit_basic_information'
    end
  end

  def update_password
    old_password_correct = check_passwords(BCrypt::Password.new(current_user.password_digest), params[:old_password])
    if current_user.update(safe_params) and old_password_correct
      redirect_to users_path
    else
      if old_password_correct
        flash.now[:danger] = 'New password does not match confirmation'
      end
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
    if password_one != password_two
      flash.now[:danger] = 'Old password is incorrect'
      false
    else
      true
    end
  end

  def check_site_passcode(passcode)
    if passcode != ENV['SITE_PASSCODE']
      flash.now[:danger] = 'Invalid site passcode'
      render 'new'
      false
    else
      true
    end
  end

  def ensure_passcode_exists
    if ENV['SITE_PASSCODE'].blank?
      flash[:danger] = 'Site passcode not configured, please contact your administrator'
      redirect_to :back
    end
  end
end