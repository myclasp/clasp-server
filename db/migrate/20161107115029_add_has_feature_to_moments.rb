class AddHasFeatureToMoments < ActiveRecord::Migration[5.0]
  def change
    add_column :moments, :has_feature, :boolean
  end
end
