# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/     
$(".ingredients-link").each ->
  $this = $(this)
  $this.popover
    html: true
    trigger: "hover"
    placement: "right"
    content: $this.find(".ingredients-well").html()