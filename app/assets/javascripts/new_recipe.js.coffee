global = this

last = (list) ->
  list[list.length-1]

get_ingredient_template = ->
  $("#ingredient_template").html()

this.listenToNewRecipe = ->
  $recipe_ingredients_list = $("#recipe_ingredients_list")
  
  $("#ingredients_list").on "click", "tr", (ev) ->
    console.log('clicked tr')
    # what got clicked
    $this = $(this)
    template_data = {
      client_id: Date.now(),
      ingredient_id: $this.attr('data-ingredient-id'),
      ingredient_title: $this.attr('data-ingredient-title')
    }
    # get, update and append new row
    row = global.get_new_element(get_ingredient_template(), template_data)
    console.log('new row:', row)
    $recipe_ingredients_list.append(row)


$(document).ready(this.listenToNewRecipe)