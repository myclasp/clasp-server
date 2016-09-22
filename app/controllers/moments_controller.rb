class MomentsFormatError < StandardError
  attr_accessor :message
  def initialize(message=nil)
    @message = message
  end
end

class MomentsController < ApplicationController

  rescue_from MomentsFormatError, :with => :rescue_from_moments_format_error

  def create
    moments = nil
    moments = JSON.parse(params[:moments]) unless params[:moments].blank?
    user = User.find_by(uuid: params[:user_id])

    raise MomentsFormatError.new("Needs a user id.") if user.blank?
    raise MomentsFormatError.new("Moments should be a collection.") unless moments.class.eql?(Array)
    
    passed = []
    failed = []
    errors = {}

    moments.each do |moment|
      m = user.moments.create(moment)
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