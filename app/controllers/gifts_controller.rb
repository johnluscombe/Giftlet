class GiftsController < ApplicationController
  before_filter :ensure_user_logged_in
  before_filter :ensure_correct_user, except: [:index, :mark_as_purchased, :mark_as_unpurchased]
  before_filter :ensure_can_mark_as_purchased, only: :mark_as_purchased
  before_filter :ensure_can_mark_as_unpurchased, only: :mark_as_unpurchased

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @gifts = @user.gifts.order(:name)
      if params[:render_new]
        @gift = @user.gifts.build
      elsif params[:render_edit]
        @gift = Gift.find(params[:render_edit])
      end
    else
      user = User.where.not(id: current_user.id).first
      redirect_to user_gifts_path(user)
    end
  end

  def create
    @user = User.find(params[:user_id])
    @gift = @user.gifts.build(safe_params)
    @gift.save
    redirect_to :back
  end

  def update
    @gift = Gift.find(params[:id])
    @user = @gift.user
    @gift.update(safe_params)
    redirect_to user_gifts_path(@user)
  end

  def mark_as_purchased
    @gift = Gift.find(params[:gift_id])
    @user = @gift.user
    @gift.update(purchased: true, purchaser_id: current_user.id)
    redirect_to user_gifts_path(@user)
  end

  def mark_as_unpurchased
    @gift = Gift.find(params[:gift_id])
    @user = @gift.user
    @gift.update(purchased: false, purchaser_id: nil)
    redirect_to user_gifts_path(@user)
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

  def ensure_can_mark_as_purchased
    @gift = Gift.find(params[:gift_id])
    @user = @gift.user

    if @gift.purchased
      redirect_to user_gifts_path(@user)
    end
  end

  def ensure_can_mark_as_unpurchased
    @gift = Gift.find(params[:gift_id])
    @recipient = @gift.user
    @purchaser = User.find(@gift.purchaser_id)

    unless current_user?(@purchaser)
      redirect_to user_gifts_path(@recipient)
    end
  end
end
