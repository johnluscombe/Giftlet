class GiftsController < ApplicationController
  include GiftsHelper
  
  before_filter :ensure_user_logged_in

  def index
    @show_sidebar = true
    if current_user.can_view_family_gifts?(@family)
      @gifts = @user.gifts.order(:name)
      if params[:render_new]
        @gift = @user.gifts.build
      elsif params[:render_edit]
        @gift = Gift.find(params[:render_edit])
      end
    else
      redirect_to families_path
    end
  end

  def create
    gift = @user.gifts.build(safe_params)

    if can_edit_user_gifts?(@user)
      gift.save
    end

    redirect_to_user_gifts(@user)
  end

  def update
    user = @gift.user
    
    if can_edit_user_gifts?(user)
      @gift.update(safe_params)
    end
    
    redirect_to_user_gifts(user)
  end

  def mark_as_purchased
    if @gift.purchaser_id.nil?
      @gift.update(purchaser_id: current_user.id)
    end

    redirect_to_user_gifts(@gift.user)
  end

  def mark_as_unpurchased
    purchaser = User.find(@gift.purchaser_id)

    if can_edit_user_gifts?(purchaser)
      @gift.update(purchaser_id: nil)
    end

    redirect_to_user_gifts(@gift.user)
  end

  def destroy
    user = @gift.user

    if can_edit_user_gifts?(user)
      @gift.destroy
    end

    redirect_to_user_gifts(user)
  end

  private

  def safe_params
    params.require(:gift).permit(:name, :description, :url, :price_as_dollars, :purchaser_id)
  end

  def ensure_user_logged_in
    unless current_user
      flash[:danger] = 'You are not logged in'
      redirect_to login_path
    end
  end

  def redirect_to_user_gifts(user)
    if @family
      if user
        redirect_to family_user_gifts_path(@family, user)
      else
        redirect_to family_users_path(@family)
      end
    else
      redirect_to families_path
    end
  end
end
