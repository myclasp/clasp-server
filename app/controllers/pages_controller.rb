class PagesController < ApplicationController
  def home
    if current_user
      @groups = Group.all
    else
      @groups = Group.open.all
    end
  end
end
