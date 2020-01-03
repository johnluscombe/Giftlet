class UsersController < ApplicationController
  before_filter :ensure_user_logged_in, except: :create
  before_filter :ensure_user_not_logged_in, only: :create

  def index
    if current_user.can_view_family_gifts?(@family)
      @show_sidebar = true
      @show_mobile_sidebar = true
    else
      redirect_to families_path
    end
  end

  def create
    user = User.new(safe_params)

    if ENV['ENABLE_SIGN_UP']
      if user.save
        flash[:success] = 'Account created'
      else
        display_error(user)
      end
    else
      flash[:danger] = 'Creating accounts has been disabled. Please contact your administrator.'
    end

    redirect_to login_path
  end

  def update_basic_information
    user = User.find(current_user.id)

    if user.update(safe_params)
      flash[:success] = 'Profile updated'
    else
      display_error(user)
    end

    redirect_to :back
  end

  def update_password
    user = User.find(current_user.id)

    old_password_correct = check_passwords(BCrypt::Password.new(user.password_digest), params[:old_password])
    if old_password_correct
      if user.update(safe_params)
        flash[:success] = 'Password updated'
      else
        display_error(user)
      end

      redirect_to :back
    else
      flash[:danger] = 'Old password was incorrect'
      redirect_to :back
    end
  end

  def clear_purchased_gifts
    user = User.find(params[:user_id])

    if current_user.can_clear_purchased_for?(user)
      user.gifts.where.not(purchaser_id: nil).destroy_all
    end

    redirect_to :back
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
      redirect_to families_path
    end
  end

  def check_passwords(password_one, password_two)
    if password_one != password_two
      flash[:danger] = 'Old password is incorrect'
      false
    else
      true
    end
  end

  def display_error(object)
    if object.errors.any?
      error_message = ''

      object.errors.full_messages.each do |message|
        error_message += message + "\n"
      end

      flash[:danger] = error_message
    end
  end
end