class FamiliesController < ApplicationController
  def index
    if current_user.is_site_admin
      @families = Family.all.order(:name)
    else
      @families = current_user.families.order(:name)
    end
  end
end
