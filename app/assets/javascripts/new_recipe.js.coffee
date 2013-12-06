global = this

$.ajax({
  url: 'http://localhost:3000/ingredient.json',
})
.done (data) ->
  global.ingredients = data
.fail ->
  global.ingredients = []
  console.log('ajax request for ingredients.json failed')

last = (list) ->
  list[list.length-1]

get_ingredient_template = ->
  $("#ingredient_template").html()

this.listenToNewRecipe = ->

  # Click on item in the list to add it
  $recipe_ingredients_list = $("#recipe_ingredients_list")
  $("#ingredients_list").on "click", "tr", (ev) ->
    $ingredient_title.val('')

    # what got clicked
    $this = $(this)
    template_data = {
      client_id: Date.now(),
      ingredient_id: $this.attr('data-ingredient-id'),
      ingredient_title: $this.attr('data-ingredient-title')
    }
    # get, update and append new row
    template = get_ingredient_template()
    console.log template, template_data
    row = global.get_new_element(template, template_data)
    $recipe_ingredients_list.prepend(row)




  # Type in an ingredient
  $ingredient_title = $('#ingredient_title')
  $ingredient_amount = $('#ingredient_amount')
  $ingredient_unit = $('#ingredient_unit')
  $recipe_ingredients_list_popover = $('#recipe_ingredients_list_popover')

  $ingredient_title.on 'keyup', (ev) ->
    $('.ingredient_row').each (row) ->
      $(this).addClass 'hidden'

    search_string = ev.target.value
    console.log search_string

    found = global.ingredients.filter (ingr) -> 
      ingr.title.toLowerCase().substr(0,search_string.length) == search_string

    counter = 10
    found.forEach (ingr) ->
      if (counter--)
        $('#ingredient_' + ingr.id).removeClass('hidden')

  $ingredient_title.on 'focusout', ->
    setTimeout ->
      $recipe_ingredients_list_popover.addClass 'hidden'
    , 100

  $ingredient_title.on 'focusin', ->
    $recipe_ingredients_list_popover.removeClass 'hidden'

$(document).ready(this.listenToNewRecipe)