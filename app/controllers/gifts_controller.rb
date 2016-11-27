class GiftsController < ApplicationController
  before_filter :ensure_user_logged_in
  before_filter :ensure_user_exists, only: [:index, :new]
  before_filter :ensure_gift_exists, only: :edit
  before_filter :ensure_correct_user, except: [:index, :update]

  def index
    @user = User.find(params[:user_id])
    @gifts = @user.gifts.order(:name)
  end

  def new
    @user = User.find(params[:user_id])
    @gift = @user.gifts.build
  end

  def create
    @user = User.find(params[:user_id])
    @gift = @user.gifts.build(safe_params)
    if @gift.save
      redirect_to user_gifts_path(@user)
    else
      render 'new'
    end
  end

  def edit
    @gift = Gift.find(params[:id])
    @user = @gift.user
  end

  def update
    @gift = Gift.find(params[:id])
    @user = @gift.user
    if @gift.update(safe_params)
      redirect_to user_gifts_path(@user)
    else
      render 'edit'
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
