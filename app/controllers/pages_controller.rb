class PagesController < ApplicationController
  def home
    if current_user
      @groups = Group.all
    else
      @groups = Group.where(is_private: false).all
    end
  end
end
