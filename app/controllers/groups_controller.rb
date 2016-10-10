class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])
    @markers = []

    for moment in @group.moments
      next unless moment.has_location?
      @markers.push({
        :latlng => [moment.latitude, moment.longitude],
        :popup => "Hello!"
      })
    end

  end

end
