class CreateItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name 
      t.string :location 
      t.integer :user_id
      t.integer :rank_list 
      t.integer :completed 
    end
  end
end
