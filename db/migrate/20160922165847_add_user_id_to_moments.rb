class AddUserIdToMoments < ActiveRecord::Migration[5.0]
  def change
    add_reference :moments, :user, foreign_key: true
  end
end
