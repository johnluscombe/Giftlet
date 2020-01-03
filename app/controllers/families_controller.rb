class FamiliesController < ApplicationController
  def index
    if current_user.is_site_admin
      @families = Family.all
    else
      @families = current_user.families
    end
  end
end
