class CreateMoments < ActiveRecord::Migration[5.0]
  def change
    create_table :moments do |t|
      t.integer :identifier 
      t.integer :state
      t.timestamp :timestamp
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
