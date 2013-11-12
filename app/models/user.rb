class User < ActiveRecord::Base
  has_many :recipe, :through => :user_recipe_history
  has_many :recipe, :through => :user_recipe_favourite
end
