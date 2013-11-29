# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131126083933) do

  create_table "cuisines", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_cuisines", force: true do |t|
    t.integer  "recipe_id"
    t.integer  "cuisine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipe_cuisines", ["cuisine_id"], name: "index_recipe_cuisines_on_cuisine_id"
  add_index "recipe_cuisines", ["recipe_id"], name: "index_recipe_cuisines_on_recipe_id"

  create_table "recipe_ingredients", force: true do |t|
    t.float    "amount"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
  end

  add_index "recipe_ingredients", ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
  add_index "recipe_ingredients", ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"

  create_table "recipes", force: true do |t|
    t.string   "recipeName"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
    t.integer  "totalTimeInSeconds"
    t.integer  "users_id"
  end

  add_index "recipes", ["users_id"], name: "index_recipes_on_users_id"

  create_table "user_recipe_favourites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "user_recipe_favourites", ["recipe_id"], name: "index_user_recipe_favourites_on_recipe_id"
  add_index "user_recipe_favourites", ["user_id"], name: "index_user_recipe_favourites_on_user_id"

  create_table "user_recipe_histories", force: true do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "user_recipe_histories", ["recipe_id"], name: "index_user_recipe_histories_on_recipe_id"
  add_index "user_recipe_histories", ["user_id"], name: "index_user_recipe_histories_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "given_name"
    t.string   "family_name"
    t.string   "link"
    t.string   "picture"
    t.string   "gender"
    t.string   "locale"
  end

  add_index "users", ["uid"], name: "index_users_on_uid"

end
