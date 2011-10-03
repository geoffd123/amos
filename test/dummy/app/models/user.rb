class User < ActiveRecord::Base
  has_many :recipes
  validates_presence_of :email
end
