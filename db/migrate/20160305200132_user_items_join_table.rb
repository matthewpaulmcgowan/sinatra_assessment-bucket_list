class UserItemsJoinTable < ActiveRecord::Migration
  def change
    create_table :item_users do |t|
      t.integer :user_id
      t.integer :item_id
    end
  end
end
