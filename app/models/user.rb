class User < ActiveRecord::Base
  has_many :items
  has_secure_password
  
  def sort_items_by_rank_list
    self.items.sort_by{|item|-item.rank_list}
  end
  
  def user_item_name_array
    self.items.collect{|item|item[:name]}
  end
  
end