class Item < ActiveRecord::Base
  belongs_to :user
  
  def self.unique_non_user_items(user)
    @unique_items = Item.all.map{|item|item[:name]}.uniq  #populates an array of unique names of Items created by all users
    @items_not_created_by_user = @unique_items.collect do |item_name|
      if !user.items.collect{|user_item|user_item[:name]}.include?(item_name) #iterates through and collects only item names created by all other users
        item_name
      end
    end.compact! #removes nil values
    @items = @items_not_created_by_user.collect{|item_name|Item.find_by(name: item_name)} #repuopulates the array to have the entire item instance, and not just name 
  end
  
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

  def self.make_item_connections(user)
    @connections = {}
    user.items.each do |item| 
      self.all.each do |all_item|
        if item.slug == all_item.slug && all_item.user_id != user.id
          if !@connections["#{item.name}"] 
            @connections["#{item.name}"] = []
          end
          @connections["#{item.name}"] << User.find_by(id: all_item.user_id)
        end
      end
    end
    @connections
  end
end