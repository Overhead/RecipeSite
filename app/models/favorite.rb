class Favorite < ActiveRecord::Base
  has_many :user_favorites, :dependent => :destroy
  has_many :users, :through => :user_favorites
  
  def self.create_favorite_recipe(params, current_user) 
    newFav = Favorite.create(:source_id => params[:id], :name => params[:recipe_name])
    favorite_recipe(newFav, current_user)   
  end

  def self.favorite_recipe(favorite, current_user)
    if UserFavorite.where("favorite_id = ? AND user_id = ?", favorite.id, current_user.id).blank?
      UserFavorite.create(:user_id => current_user.id, :favorite_id => favorite.id)
    end
  end

  def self.un_favorite_recipe(favorite, current_user)
    userfav = UserFavorite.where("favorite_id = ? AND user_id = ?", favorite.id, current_user.id)
    UserFavorite.destroy(userfav)
  end

  def self.check_if_favorite(recipe_id, current_user)
    favorite = Favorite.find_by_source_id(recipe_id)
    if favorite
      if UserFavorite.where("favorite_id = ? AND user_id = ?", favorite.id, current_user.id).blank?   
        return false
      else
        return true
      end
    else
      return false
    end
  end
  
  
end
