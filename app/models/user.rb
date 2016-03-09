class User < ActiveRecord::Base
  has_many :item_users
  has_many :items, through: :item_users
  has_secure_password
end