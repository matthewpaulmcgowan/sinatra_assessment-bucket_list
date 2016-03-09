class Item < ActiveRecord::Base
  has_many :item_users
  has_many :users, through: :item_users
  
  def slug
    @slug = name.downcase.gsub(/\W+/,"-")
  end
     
  def self.find_by_slug(slug)
    Item.all.find do |instance|
      if !instance.name.nil?
        instance.slug == slug
      end
    end
  end
  
  def self.connection_user(id)
    User.find(id)
  end
  
  def self.make_item_connections(user)
    @connections = {}
    user.items.each do |item| 
      self.all.each do |all_item|
        if item.slug == all_item.slug && all_item.user_id != user.id
          if !@connections["#{item.name}"] 
            @connections["#{item.name}"] = []
          end
          @connections["#{item.name}"] << Item.connection_user(all_item.user_id)
        end
      end
    end
    @connections
  end
end