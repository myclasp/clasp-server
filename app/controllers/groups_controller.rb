class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])
    @markers = []

    for moment in @group.moments
      next unless moment.has_location?

      popup = "latitude: " + moment.latitude.to_s +
        ", longitude: "  + moment.longitude.to_s +
        " identifier: " + moment.identifier.to_s+
        " state: " +      moment.state.to_s  +
        " timestamp: " +  moment.timestamp.to_s

      @markers.push({
        latlng: [moment.latitude, moment.longitude],
        state: moment.state,
        popup: popup.html_safe, 
        is_mine: moment.user.eql?(current_user)
      })
    end

  end

  def edit
    @group = Group.find(params[:id])
  end

  def calendar_moments
    group   = Group.find(params[:id])
    month   = DateTime.strptime(params[:month],"%m-%Y")
    render  "_month.js.erb", locals: { month: month, group: group } 
  end

  def update
  end

end
