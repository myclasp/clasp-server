class AddIsPrivateToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :is_private, :boolean, default:false
  end
end
