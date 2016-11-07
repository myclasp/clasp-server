class FeaturesController < ApplicationController

  def create
    @moment = Moment.find(params[:moment_id])

    if params[:commit].downcase.eql?("yes")
      data = JSON.parse(feature_params[:data])
      @feature = Feature.new(data: data, moment_id: @moment.id)

      if @feature.save
        render json: { success: true }
      else
        render json: { success: false, errors: @feature.errors.messages }
      end
    else
      @moment.update_attribute(:has_feature, true)
      render json: { success: true }
    end
  end

  private

  def feature_params
    params.require(:feature).permit(:data)
  end

end
