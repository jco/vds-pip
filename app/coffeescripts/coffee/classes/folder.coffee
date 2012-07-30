#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)

jQuery ->

class Folder
  helper = new Helper
  
  # Folder is accessible outside this class via $(f.get()), where f is an instance of Folder
  # Inside this class, use $(@get())
  # More specific ones like $(@getImage()) exist too
  constructor: (@name) ->
    # Prepare basic properties for tag
    @id = helper.getRandomNumber()
    div = "<div id=folder_#{@id} style='#{@getStyleAttributes()}'>"
    img = "<img id='folder_icon_#{@id}' src='#{IMAGE_PATH}/icons/folder.gif' />"
    label = "<span id=folder_label_#{@id}>#{@name}</span>"
    handle = "<img id=folder_handle_#{@id} src='#{IMAGE_PATH}/icons/circle0.png' width='15' height='15' />"
    enddiv = "</div>"
    
    @tag = div + handle + img + label + enddiv
    $("#container").append(@tag)
    
    # Set coordinates
    @x = 0; @y = 0
    @setCoordinates(@x, @y)
    
    @_makeDraggable() # Make self draggable
    @_makeHandleDraggable() # Make the handle draggable, allowing for dependency drawing
    @_makeDroppable() # Make self droppable so detection of when to draw dependencies exists
  
  getStyleAttributes: ->
    return 'display: inline-block; position: absolute;'
    # return 'position: relative;' # position automatically relative by jQuery draggable, which uses 'left' and 'top' like you planned
  
  # Returns the string that jQuery would use to access the surrounding div object, 
  # like '#folder_134235'
  get: ->
    return "#folder_#{@id}"
  
  getImage: ->
    return "#folder_icon_#{@id}"
  
  getLabel: ->
    return "#folder_label_#{@id}"
      
  getHandle: ->
    return "#folder_handle_#{@id}"
  
  # Sets @x and @y to passed in variables and sets the location
  # to the proper spot
  setCoordinates: (x,y) ->
    @x = x; @y = y
    $(@get()).css('left', "#{@x}px")
    $(@get()).css('top', "#{@y}px")
    # $(@getLabel()).html("#{@name} | (#{@x},#{@y})") # if you want to see coordinates
  
  # Updates @x and @y based on actual coordinates
  updateCoordinates: ->
    @x = $(@get()).css('left').replace('px','')
    @y = $(@get()).css('top').replace('px','')
      
  _makeDraggable: ->
    $(@get()).draggable
      containment: "#container",
      handle: @getImage()
      # other options like stop specified in file that creates the instance, item_drawer
  
  _makeHandleDraggable: ->
    $(@getHandle()).draggable
      containment: "#container",
      handle: @getHandle(),
      helper: "clone",
      revert: true
      # other options like stop specified in file that creates the instance, item_drawer
  
  _makeDroppable: ->
    $(@get()).droppable
      drop: ->
        # $(this).css('border','1px solid red') # works

window.Folder = Folder # Makes the class global