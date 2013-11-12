class Recipe < ActiveRecord::Base
  has_many :ingredients, :through => :recipe_ingredients
  has_many :user, :through => :user_recipe_history
  has_many :user, :through => :user_recipe_favourite
end
