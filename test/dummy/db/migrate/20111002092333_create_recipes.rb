class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    
    Recipe.create(:name => 'Make cake', :description => 'go to shop')
  end

  def self.down
    drop_table :recipes
  end
end
