# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.profile_edit_on = () -> 
  $("#user_first_name").attr "disabled", false
  $("#user_last_name").attr "disabled", false
  $("#user_gender").attr "disabled", false
  $("#profile_save_button").removeClass "hidden"
  $("#profile_edit_button").addClass "hidden"
  $("#profile_reset_button").removeClass "hidden"
  
this.profile_edit_off = () ->
  $("#user_first_name").attr "disabled", true
  $("#user_last_name").attr "disabled", true
  $("#user_gender").attr "disabled", true
  $("#profile_save_button").addClass "hidden"
  $("#profile_edit_button").removeClass "hidden"
  $("#profile_reset_button").addClass "hidden"

listen = ->
  $("#profile_edit_button").click profile_edit_on
  $("#profile_reset_button").click profile_edit_off

$(document).ready(listen)