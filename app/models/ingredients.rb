class Ingredients < ActiveRecord::Base
  has_many :recipe, :through => :recipe_ingredients
  
end
