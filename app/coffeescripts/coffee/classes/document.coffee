#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)

jQuery ->

class Document
  helper = new Helper
  
  # Document is accessible outside this class via $(doc.get()), where doc is an instance of Document
  # Inside this class, use $(@get()) to access self (since there's no instance of document)
  # More specific ones like $(@getImage()) exist too
  constructor: (@name, @document_id) ->
    # Prepare basic properties for tag
    @id = helper.getRandomNumber() # random number to help identify the DOM element
    div = "<div id=document_#{@id} style='#{@getStyleAttributes()}'>"
    img = "<img id='document_icon_#{@id}' src='#{IMAGE_PATH}/icons/document.png' width='25' height='25' />"
    label = "<span id=document_label_#{@id}>#{@name}</span>"
    handle = "<img id=document_handle_#{@id}_#{@document_id} src='#{IMAGE_PATH}/icons/circle0.png' width='15' height='15' />"
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
  
  # Returns the string that jQuery would use to access the surrounding div object, 
  # like '#document_134235'
  get: ->
    return "#document_#{@id}"

  getImage: ->
    return "#document_icon_#{@id}"
  
  getLabel: ->
    return "#document_label_#{@id}"
  
  getHandle: ->
    return "#document_handle_#{@id}_#{@document_id}" # document_id is here for access from outside in ui.draggable
    
  setCoordinates: (x,y) ->
    @x = x; @y = y
    $(@get()).css('left', "#{@x}px")
    $(@get()).css('top', "#{@y}px")
    # $(@getLabel()).html("#{@name} | (#{@x},#{@y})") # if you want to see coordinates
  
  setBorderColor: (color) ->
    $(@get()).css('border',"1px solid #{color}")

  # Updates @x and @y based on actual coordinates
  updateCoordinates: ->
    @x = $(@get()).css('left').replace('px','')
    @y = $(@get()).css('top').replace('px','')

  _makeDraggable: ->
    $(@get()).draggable
      containment: "#container",
      handle: @get(),
      # other options specified in file that creates the instance, item_drawer

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

window.Document = Document # Makes the class global