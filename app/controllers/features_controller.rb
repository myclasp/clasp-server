class FeaturesController < ApplicationController

  def create
    @moment = Moment.find(params[:moment_id])

    if params[:commit].downcase.eql?("yes")
      data = JSON.parse(feature_params[:data])
      @feature = Feature.new(data: data, moment_id: @moment.id)
      @feature.save
      @moment.update_attribute(:has_feature, true)
    else
      @moment.update_attribute(:has_feature, false)
    end

    render  "_show_feature.js.erb", locals: { moment: @moment }
  end

  def show
    @moment = Moment.find(params[:moment_id])
    render "_show_feature.js.erb", locals: { moment: @moment }
  end

  private

  def feature_params
    params.require(:feature).permit(:data)
  end

end
