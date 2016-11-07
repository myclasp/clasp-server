class CreateFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :features do |t|
      t.references :moment, foreign_key: true
      t.text :data
      t.string :name
      t.string :ftype

      t.timestamps
    end
  end
end
