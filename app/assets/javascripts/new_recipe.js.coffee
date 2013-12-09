global = this

last = (list) ->
  list[list.length-1]

get_ingredient_template = ->
  $("#ingredient_template").html()


this.get_ingredient_list = ->
  global.ingredients = []
  $('#ingredients_list tr').each ->
    $this = $(this)
    data = {
      id: $this.attr('data-ingredient-id'),
      title: $this.attr('data-ingredient-title'),
      description: $this.attr('data-ingredient-description')
    }
    console.log(data)
    global.ingredients.push(data)

  $('#show-create-ingredient').on 'click', (ev) ->
    console.log('clicked')
    ev.stopPropagation()
    ev.preventDefault()
    show_create_ingredient()

  show_create_ingredient = ->
    $('#title').val($('#ingredient_title').val())
    $('#create-ingredient').removeClass('hidden')


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

    if found.length > 0
      counter = 10
      found.forEach (ingr) ->
        if (counter--)
          $('#ingredient_' + ingr.id).removeClass('hidden')
    else



  $ingredient_title.on 'focusout', ->
    setTimeout ->
      $recipe_ingredients_list_popover.addClass 'hidden'
    , 100

  $ingredient_title.on 'focusin', ->
    $recipe_ingredients_list_popover.removeClass 'hidden'

$(document).ready ->
  global.get_ingredient_list()
  global.listenToNewRecipe()