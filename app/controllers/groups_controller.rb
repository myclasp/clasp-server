class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])
    @markers = []

    for moment in @group.moments
      next unless moment.has_location?

      popup = "latitude: " + moment.latitude.to_s  +
        ", longitude: "  + moment.longitude.to_s +
        ", identifier: " + moment.identifier.to_s+
        ", state: " +      moment.state.to_s  +
        ", timestamp: " +  moment.timestamp.to_s 
      
      @markers.push({
        latlng: [moment.latitude, moment.longitude],
        popup: popup
      })
    end

  end

end
