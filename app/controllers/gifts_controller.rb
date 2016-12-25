class GiftsController < ApplicationController
  before_filter :ensure_user_logged_in
  before_filter :ensure_user_exists, only: [:index]
  before_filter :ensure_correct_user, except: [:index]

  def index
    @user = User.find(params[:user_id])
    @gifts = @user.gifts.order(:name)
    if params[:render_new]
      @gift = @user.gifts.build
    elsif params[:render_edit]
      @gift = Gift.find(params[:render_edit])
    end
  end

  def create
    @user = User.find(params[:user_id])
    @gift = @user.gifts.build(safe_params)
    if @gift.save
      redirect_to user_gifts_path(@user)
    else
      render 'index'
    end
  end

  def update
    @gift = Gift.find(params[:id])
    @user = @gift.user
    if @gift.update(safe_params)
      redirect_to user_gifts_path(@user)
    else
      render 'index'
    end
  end

  def destroy
    @gift = Gift.find(params[:id])
    @user = @gift.user
    @gift.destroy
    redirect_to user_gifts_path(@user)
  end

  private

  def safe_params
    params.require(:gift).permit(:name, :description, :url, :price_as_dollars, :purchased, :date_purchased, :purchaser_id)
  end

  def ensure_user_logged_in
    unless current_user
      flash[:danger] = 'You are not logged in'
      redirect_to login_path
    end
  end

  def ensure_correct_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @gift = Gift.find(params[:id])
      @user = @gift.user
    end

    unless current_user?(@user)
      redirect_to users_path
    end
  end

  def ensure_user_exists
    unless User.find(params[:user_id])
      redirect_to users_path
    end
  rescue
    redirect_to users_path
  end

  def ensure_gift_exists
    unless Gift.find(params[:id])
      redirect_to users_path
    end
  rescue
    redirect_to users_path
  end
end
