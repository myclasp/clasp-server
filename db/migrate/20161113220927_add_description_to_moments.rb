class AddDescriptionToMoments < ActiveRecord::Migration[5.0]
  def change
    add_column :moments, :description, :string
  end
end
