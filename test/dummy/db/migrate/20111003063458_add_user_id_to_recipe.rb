class AddUserIdToRecipe < ActiveRecord::Migration
  def self.up
    add_column :recipes, :user_id, :integer
  end

  def self.down
    remove_column :recipes, :user_id
  end
end
