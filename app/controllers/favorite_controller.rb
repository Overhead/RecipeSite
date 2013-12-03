class FavoriteController < ApplicationController
  def index
    if current_user
      @favorites = UserFavorite.where("user_id = ?",current_user.id)
    else
      require_login
    end
  end

  def fav_recipe
    @favorite = Favorite.find_by_source_id(params[:id])
    if @favorite.blank?
      Favorite.create_favorite_recipe(params, current_user)
    else
      Favorite.favorite_recipe(@favorite, current_user)
    end
    
    respond_to do |format|
      format.js
    end
  end

  def unfav_recipe
    @favorite = Favorite.find_by_source_id(params[:id])
    if UserFavorite.where("favorite_id = ? AND user_id = ?", @favorite.id, current_user.id).blank?
      respond_with({:error => "This recipe is no favorite"}, :status => 400)
    else
      Favorite.un_favorite_recipe(@favorite, current_user)
    end
    respond_to do |format|
      format.js
    end
  end
end
