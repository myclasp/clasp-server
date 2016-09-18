class MomentsController < ApplicationController

  def create
    moments = nil
    moments = JSON.parse(params[:moments]) unless params[:moments].blank?

    results = []
    moments.each { |m| results << Moment.create(m).valid? } unless moments.blank?
    
    success = !(results.include?(false))
    render json: { success: success, results: results }
  end

end
