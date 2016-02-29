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
  
end