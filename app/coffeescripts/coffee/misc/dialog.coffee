#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)
#
# This handles the dialogs that appear in documents/show

jQuery ->
  # SHOW ACTION STUFF
  # from_dialog = $('<div></div>')
  #     # .load('/dependencies/new') # path to template
  #     .html('some stuff')
  #     .dialog
  #         autoOpen: false,
  #         title: 'hey there!',
  #         width: 600,
  #         height: 400,
  #         modal: true
  # from_dialog.appendTo("#dialog_area")
  
  # Create dependency actions from within documents/show
  from_dialog = $("#from_dialog")
  $("#from_button").click ->
    from_dialog.dialog('open')
  from_dialog.dialog
    autoOpen: false,
    title: "Create 'from' dependency",
    width: 600,
    height: 400,
    modal: true

  $("#me").click ->
    $("#dialog").dialog('open')
  $("#dialog").dialog 
    autoOpen: false