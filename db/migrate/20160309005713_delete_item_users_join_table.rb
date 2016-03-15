class DeleteItemUsersJoinTable < ActiveRecord::Migration
  def change
    drop_table(:item_users)
  end
end
