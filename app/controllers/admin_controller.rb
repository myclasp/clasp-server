class AdminController < ApplicationController
  def index
    authorize_user
  end

  private

  def authorize_user
    unless current_user and current_user.is_admin 
      flash[:notice] = "You're not authorised to view this page."
      redirect_to root_path 
    end
  end
end
