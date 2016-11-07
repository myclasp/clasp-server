class FeaturesController < ApplicationController

  def create
    @moment = Moment.find(params[:moment_id])
    data = JSON.parse(feature_params[:data])
    Rails.logger.info "\n \n #{data.inspect}"
    @feature = Feature.new(data: data, moment_id: @moment.id)

    if @feature.save
      render json: { success: true }
    else
      render json: { success: false, errors: @feature.errors.messages }
    end
  end

  private

  def feature_params
    params.require(:feature).permit(:data)
  end

end
