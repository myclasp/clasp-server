class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])
    @markers = []
    @calendar_moments = build_calendar_moments(@group,DateTime.now)

    for moment in @group.moments
      next unless moment.has_location?

      @markers.push({
        moment: moment,
        latlng: [moment.latitude, moment.longitude],
        state: moment.state,
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
    calendar_moments = build_calendar_moments(group,month)
    render  "_month.js.erb", locals: { month: month, group: group, calendar_moments: calendar_moments } 
  end

  def update
  end

  private

  def build_calendar_moments(group, month)
    range = month.beginning_of_month..month.end_of_month
    calendar_moments = {}
    range.each do |day|
      moments = group.moments(from: day.beginning_of_day, to: day.end_of_day)
      
      group_zeroes  = moments.where(state: 0).count
      group_ones    = moments.where(state: 1).count
      group_state  = calendar_state(group_zeroes, group_ones)

      user_zeroes = moments.where({ state: 0, user_id: current_user.id }).count
      user_ones   = moments.where({ state: 1, user_id: current_user.id }).count
      user_state = calendar_state(user_zeroes, user_ones)

      calendar_moments.merge!(day.day => { 
        user_state: user_state, group_state: group_state, group_ones: group_ones, group_zeroes: group_zeroes 
      })
    end
    return calendar_moments
  end

  def calendar_state(zeroes, ones)
    return "" if (ones+zeroes).eql?(0)
    return "split" if (ones-zeroes).eql?(0)
    if (ones > zeroes)
      return "up"
    else
      return "down"
    end
    return ""
  end

end
