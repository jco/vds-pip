#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)
#
# This handles the tree drawing (side pane tree and dependency creation tree)

jQuery ->

class TreeDrawer
  P = null # Create a local variable
  constructor: (P_variable) ->
    P = P_variable # P is a huge collection of data from application.js

  # Draws the side pane tree for the project
  # Called in application.js
  # Uses recursiveDrawSidePaneItem() & jquery - this sets up the ul, etc.
  # Params: project - the project to draw for; divName - the id of the div wherein to draw
  drawSidePaneTree: (project, divName) ->
    throw "Can't draw something that isn't a Project" unless project instanceof P.Model.Project
    
    # Assume the place to draw
    pane = document.getElementById(divName)
    return unless pane
    ul = document.createElement("ul")
    pane.appendChild ul
    _recursiveDrawSidePaneItem project, ul
    $(ul).simpleTreeMenu() # jquery function from library
    
    # Set draggable options for dependency creation
    $(".draggable_part").draggable
      helper: "clone",
      revert: true

  _recursiveDrawSidePaneItem = (item, container) ->
    li = document.createElement("li")
    
    # This is a single item in the list - no children included
    span = document.createElement("span")
    
    # Prepare the small arrow icon
    icon = document.createElement("img")
    icon.src = P.iconFor(item)
    icon.width = icon.height = P.SMALL_ICON_SIZE
    
    span.appendChild icon
    
    # Prepare image that will be draggable (for creating dependencies)
    # Temporary: Creating deps b/w folders is DISABLED
    if item.type == 'document'# || item.type == 'folder' # don't make draggable for project
      handle_id = "#{item.type}_handle_blank_#{item.id}" # e.g., "document_handle_blank_2". 
        # item_drawer.js grabs 'document' and '2' from this. ('blank' is a filler so item_drawer's functions can be reused)
    
      handle_html = document.createElement("img")
      handle_html.setAttribute "id", handle_id
      handle_html.setAttribute "class", 'draggable_part'
      handle_html.setAttribute "src", "#{IMAGE_PATH}/icons/circle0.png"
      handle_html.setAttribute "width", '15'
      handle_html.setAttribute "height", '15'
      # handle_html is essentially, this: "<img id=#{handle_id} src='#{IMAGE_PATH}/icons/circle0.png' width='15' height='15' />"
      
      # For some reason, draggable() won't work here (perhaps an order of operations thing), 
      # so I set the draggable functionality at the end of the drawSidePaneTree method.
      
      span.appendChild handle_html
    
    # Get the item name
    name = document.createTextNode(item.name)
    span.appendChild name
    
    li.appendChild span
    
    # Define what happens when you double click an item
    if item instanceof P.Model.Document
      span.addEventListener "dblclick", P.ItemDrawer.documentOverlay(item), false
    if item instanceof P.Model.Project
      span.addEventListener "dblclick", (->
        `location = P.projectPath(item)` # Use JavaScript's location global variable
      ), false
    if item instanceof P.Model.Folder
      span.addEventListener "dblclick", (->
        `location = P.folderPath(item)` # Use JavaScript's location global variable
      ), false
    if item instanceof P.Model.Task
      span.addEventListener "dblclick", (->
        `location = P.taskPath(item)`
      ), false
    
    # Draw nested items
    ul = document.createElement("ul")
    P.COLLECTION_TYPES.forEach (type) ->
      if item[type]
        item[type].forEach (subItem) ->
          _recursiveDrawSidePaneItem subItem, ul

    li.appendChild ul
    container.appendChild li

  # BELOW NOT USED

  # The following 2 methods mimick the 2 above, but have slight changes

  # Draws the dependency creation tree for documents/show views
  # Called in application.js
  # Uses recursiveDrawSidePaneItem() & jquery - this sets up the ul, etc.
  # Params: project - the project to draw for; divName - the class of the div wherein to draw
  # drawDepCreationTree: (project, divName) ->
  #   # alert 'REACHED'
  #   throw "Can't draw something that isn't a Project" unless project instanceof P.Model.Project
  #   
  #   # Assume the place to draw
  #   # pane = document.getElementById(divName)
  #   # return unless pane
  #   # ul = document.createElement("ul")
  #   
  #   # alert 'I am executing!'
  #   
  #   # Loop through the places to draw.. just one?
  #   $("body .#{divName}").each -> # need document.getelement..? 
  #     # alert 'I made it!'
  #     pane = $(this)[0] # Get actual HTML DOM object. http://stackoverflow.com/questions/4069982/document-getelementbyid-vs-jquery
  #     ul = document.createElement("ul")
  #     pane.appendChild ul
  #     _recursiveDrawDepCreationItem project, ul
  #     $(ul).simpleTreeMenu() # jquery function from library
  # 
  # _recursiveDrawDepCreationItem = (item, container) ->
  #   li = document.createElement("li")
  #   li.setAttribute "id", item.type + "_" + item.id # set id to be like 'document_3'
  #   
  #   span = document.createElement("span")
  #   
  #   # Prepare the small arrow icon
  #   icon = document.createElement("img")
  #   icon.src = P.iconFor(item)
  #   icon.width = icon.height = P.SMALL_ICON_SIZE
  #   span.appendChild icon
  #   
  #   # Get the item name
  #   name = document.createTextNode(item.name)
  #   span.appendChild name
  #   li.appendChild span
  # 
  #   # Define what happens when you double click an item
  #   if item instanceof P.Model.Document
  #     span.addEventListener "dblclick", (->
  #       alert "create dep with Document"
  #     ), false
  #   if item instanceof P.Model.Folder
  #     span.addEventListener "dblclick", (->
  #       alert "create dep with Folder"
  #     ), false
  #   
  #   # Draw nested items
  #   ul = document.createElement("ul")
  #   P.COLLECTION_TYPES.forEach (type) ->
  #     if item[type]
  #       item[type].forEach (subItem) ->
  #         _recursiveDrawDepCreationItem subItem, ul
  #         
  #   li.appendChild ul
  #   container.appendChild li

window.TreeDrawer = TreeDrawer # Makes the class global