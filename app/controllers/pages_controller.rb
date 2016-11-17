class PagesController < ApplicationController
  def home
    if current_user
      @groups = current_user.groups.all
      @groups = @groups + Group.open.all
      @groups.uniq!
    else
      @groups = Group.open.all
    end
  end
end
