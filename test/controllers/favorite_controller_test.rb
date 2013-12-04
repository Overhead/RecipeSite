require 'test_helper'

class FavoriteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get fav_recipe" do
    get :fav_recipe
    assert_response :success
  end

  test "should get unfav_recipe" do
    get :unfav_recipe
    assert_response :success
  end

end
