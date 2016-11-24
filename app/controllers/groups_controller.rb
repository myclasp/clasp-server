class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])

    if @group.is_private
      accessible = @group.is_visible_to(current_user)
      flash[:notice] = "You're not authorised to view this page."
      redirect_to root_path unless accessible
    end

    @markers = []
    
    @calendar_moments = build_calendar_moments(@group,DateTime.now)
    @hourly_moments_start = 1.day.ago.beginning_of_day
    @hourly_moments = build_period_moments(@group, @hourly_moments_start, 24, :hour)
    @week_moments_start = 1.week.ago.beginning_of_week.beginning_of_day
    @week_moments = build_period_moments(@group, @week_moments_start, 7, :day)

    @is_group_member = false
    @is_group_member = @group.users.include?(current_user) if current_user

    for moment in @group.moments
      next unless moment.has_location?

      @markers.push({
        moment: moment,
        latlng: [moment.latitude, moment.longitude],
        state: moment.state,
        is_mine: moment.user.eql?(current_user),
        feature_url: moment_features_url(moment),
        time: moment.timestamp
      })
    end
  end

  def new
    @group = Group.new
    authorize_user
  end

  def create
    params[:group][:preferences] = params[:preferences]
    @group = Group.new(group_params)
    authorize_user

    if @group.save
      flash[:notice] = "Group saved successfully."
      redirect_to edit_group_path(@group)
    else
      flash.now[:error] = "Unable to save group."
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
    authorize_user
  end

  def calendar_moments
    group   = Group.find(params[:id])
    month   = DateTime.strptime(params[:month],"%m-%Y")
    calendar_moments = build_calendar_moments(group,month)
    render  "_month.js.erb", locals: { month: month, group: group, calendar_moments: calendar_moments } 
  end

  def period_moments
    group = Group.find(params[:id])

    start = Time.at(params[:start].to_i)
    points = params[:points].to_i
    interval = params[:interval].to_sym

    period_moments = build_period_moments(group, start, points, interval)
    
    next_start = start + points.send(interval)
    previous_start = start - points.send(interval)

    render json: { start: start.to_i,  previous_start: previous_start.to_i, next_start: next_start.to_i, data: period_moments } 
  end

  def update
    @group = Group.find(params[:id])
    authorize_user
    params[:group][:preferences] = params[:preferences]
    if @group.update_attributes(group_params)
      flash[:notice] = "Group saved successfully."
      redirect_to edit_group_path(@group)
    else
      flash.now[:error] = "There were errors."
      render :edit
    end
  end

  def add_user
    @group = Group.find(params[:id])
    @group.users << current_user
    flash[:notice] = "Joined group successfully."
    redirect_to group_path(@group)
  end

  private

  def authorize_user
    unless current_user and (current_user.is_admin or @group.is_admin?(current_user))
      flash[:notice] = "You're not authorised to view this page."
      redirect_to root_path 
    end
  end

  def group_params
    params.require(:group).permit(:name, :description, :image_url, :is_private, preferences: [:show_map, :is_open_data])
  end

  def build_period_moments(group, start_time, points, interval)
    period_moments = []
    points.times do |point_idx|
      start_range = start_time + point_idx.send(interval)  #e.g. time + 1.send(:hour)
      end_range = start_time + (point_idx+1).send(interval)
      moments = group.moments(from: start_range, to: end_range)

      zeroes = moments.where(state: 0).count
      ones = moments.where(state: 1).count
      ratio = 0.0
      ratio = (ones-zeroes)/(ones+zeroes).to_f unless (ones+zeroes).eql?(0)
      group_point = { zeroes: zeroes, ones: ones, ratio: ratio }

      user_point = {}
      if current_user
        user_zeroes = moments.where({ state: 0, user_id: current_user.id }).count
        user_ones   = moments.where({ state: 1, user_id: current_user.id }).count
        user_ratio  = 0.0
        user_ratio  = (user_ones-user_zeroes)/(user_ones+user_zeroes).to_f unless (user_ones+user_zeroes).eql?(0)
        user_point  = { zeroes: user_zeroes, ones: user_ones, ratio: user_ratio }
      end

      period_moments << ({ group: group_point, user: user_point })
    end
    return period_moments
  end

  def build_calendar_moments(group, month)
    range = month.beginning_of_month..month.end_of_month
    calendar_moments = {}
    range.each do |day|
      moments = group.moments(from: day.beginning_of_day, to: day.end_of_day)
      
      group_zeroes  = moments.where(state: 0).count
      group_ones    = moments.where(state: 1).count
      group_state  = calendar_state(group_zeroes, group_ones)

      if current_user
        user_zeroes = moments.where({ state: 0, user_id: current_user.id }).count
        user_ones   = moments.where({ state: 1, user_id: current_user.id }).count
        user_state  = calendar_state(user_zeroes, user_ones)
      else
        user_state = ""
      end
      
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
