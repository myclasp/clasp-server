class MomentsFormatError < StandardError
  attr_accessor :message
  def initialize(message=nil)
    @message = message
  end
end

class MomentsController < ApplicationController

  protect_from_forgery :except => [:create]

  rescue_from MomentsFormatError, :with => :rescue_from_moments_format_error

  def index
    authenticate_user!
    @moments = current_user.moments
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
      moment_attributes = moment.permit([:identifier, :timestamp, :state, :latitude, :longitude])
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

  private

  def rescue_from_moments_format_error(e)
    render :status => 400, json: { success: false, message: "Request doesn't meet required format: " + e.message }
  end

end