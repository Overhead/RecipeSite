# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Dont reload the page
convert = (unit, amount) ->
  
  # ex: 'cups' => 'cup'
  normalize = (word) ->
    word = word.trim().toLowerCase()
    word = word.slice(0, -1)  if word[word.length - 1] is "s"
    word

  unitNames =
    # Volume
    cup: (amount) ->
      unit: "dl"
      amount: amount * 2.36

    dl: (amount) ->
      unit: "cups"
      amount: amount / 2.36

    gallon: (amount) ->
      unit: "liter"
      amount: amount * 3.78

    liter: (amount) ->
      unit: "gallons"
      amount: amount / 3.78

    l: (amount) ->
      unit: "gallons"
      amount: amount / 3.78

    quart: (amount) ->
      unit: "liter"
      amount: amount * 0.946

    pint: (amount) ->
      unit: "liter"
      amount: amount * 0.56

    
    # Weight
    pound: (amount) ->
      unit: "kg"
      amount: amount * 0.45

    kg: (amount) ->
      unit: "pound"
      amount: amount / 0.45

    ounce: (amount) ->
      unit: "grams"
      amount: amount * 28.34

    grams: (amount) ->
      unit: "ounce"
      amount: amount / 28.34

  unitNames[normalize(unit)] amount

# ex: '1 3/4' => 1.75
toDecimal = (string) ->
  whiteSpace = /\s+/
  fractions = string.trim().split(whiteSpace)
  decimals = fractions.map((fracStr) ->
    parts = undefined
    number = undefined
    
    # List of fraction parts
    parts = fracStr.split("/")
    
    # Default to only using the first part
    number = parseFloat(parts[0])
    
    # If there are 2 parts, use both
    number = number / parseFloat(parts[1])  if parts.length is 2
    number
  )
  decimals.reduce ((a, b) ->
    a + b
  ), 0

listen = ->
  link = $("#translate")
  link.on "click", (event) ->
    event.preventDefault()
    $(".lang-us").each ->
      line = $(this)
      # Elements
      amount = line.find(".amount")
      unit = line.find(".unit")
      # Convert
      converted = convert(unit.text(), toDecimal(amount.text()))
      # Update el text
      amount.text converted.amount
      unit.text converted.unit

$(document).ready(listen)
