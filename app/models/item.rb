class Item < ActiveRecord::Base
  belongs_to :user
  
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
          @connections["#{item.name}"] << Helpers.connection_user(all_item.user_id)
        end
      end
    end
    @connections
  end
end