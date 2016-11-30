class MomentsFormatError < StandardError
  attr_accessor :message
  def initialize(message=nil)
    @message = message
  end
end

class MomentsController < ApplicationController

  protect_from_forgery :except => [:create, :v1_user_moments]

  rescue_from MomentsFormatError, :with => :rescue_from_moments_format_error

  def index
    authenticate_user!
    @moments = current_user.moments
  end


  def v1_user_moments
    user = User.find_by(uuid: params[:user_id])
    
    query = user.moments
    query = query.from(Time.at(params[:from].to_i)) unless params[:from].to_i.eql?(0) 
    query = query.to(Time.at(params[:to].to_i)) unless params[:to].to_i.eql?(0)

    render json: { success: true, moments: query.all, params: { from: params[:from], to: params[:to] } }
  end

  def v1_group_moments
    group = Group.find(params[:group_id])
    
    query = group.moments
    query = query.from(Time.at(params[:from].to_i)) unless params[:from].to_i.eql?(0) 
    query = query.to(Time.at(params[:to].to_i)) unless params[:to].to_i.eql?(0)

    render json: { success: true, moments: query.all, params: { from: params[:from], to: params[:to] } }
  end

  def create
    moments = params[:moments]
    user = User.find_by(uuid: params[:user_id]) 

    raise MomentsFormatError.new("Needs a user id.") if user.blank?
    raise MomentsFormatError.new("Moments should be a collection.") unless moments.class.eql?(Array)

    passed = []
    failed = []
    errors = {}

    moments.each do |moment|
      moment_attributes = moment.permit([:identifier, :timestamp, :state, :latitude, :longitude, :accuracy])
      m = user.moments.create(moment_attributes)
      raise MomentsFormatError.new("Blank identifier for moment.") if m.identifier.blank?
      
      if m.valid?
        passed << m.identifier
      else
        failed << m.identifier
        errors.merge!({ m.identifier => m.errors.full_messages.join(". ") }) 
      end
    end

    success = failed.blank?
    render json: { success: success, passed: passed, failed: failed, errors: errors }    
  end

  def update
    @moment = Moment.find(params[:id])
    @moment.update_attributes(moment_params)
    @marker = {
      moment: @moment,
      latlng: [@moment.latitude, @moment.longitude],
      state: @moment.state,
      is_mine: @moment.user.eql?(current_user),
      feature_url: moment_features_url(@moment),
      time: @moment.timestamp
    }

    render  "_update.js.erb", locals: { moment: @moment, marker: @marker }
  end

  private

  def moment_params
    params.require(:moment).permit(:description)
  end

  def rescue_from_moments_format_error(e)
    render :status => 400, json: { success: false, message: "Request doesn't meet required format: " + e.message }
  end

end