# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)

jQuery ->

class Document
  helper = new Helper
  
  # Document is accessible outside this class via $(doc.get()), where doc is an instance of Document
  # Inside this class, use $(@get())
  # More specific ones like $(@getImage()) exist too
  constructor: (@name) ->
    # Prepare basic properties for tag
    @id = helper.getRandomNumber()
    div = "<div id=document_#{@id} style='#{@getStyleAttributes()}'>"
    img = "<img id='document_icon_#{@id}' src='#{IMAGE_PATH}/icons/document.png' width='25' height='25' />"
    label = "<span id=document_label_#{@id}>#{@name}</span>"
    enddiv = "</div>"
    
    @tag = div + img + label + enddiv
    $("#container").append(@tag)
    
    # Set coordinates
    @x = 0; @y = 0
    @setCoordinates(@x, @y)
    
    @_makeDraggable() # Make self draggable

  getStyleAttributes: ->
    return 'display: inline-block'
  
  # Returns the string that jQuery would use to access the surrounding div object, 
  # like '#document_134235'
  get: ->
    return "#document_#{@id}"

  getImage: ->
    return "#document_icon_#{@id}"
  
  setCoordinates: (x,y) ->
    @x = x; @y = y
    $(@get()).css('left', "#{@x}px")
    $(@get()).css('top', "#{@y}px")
  
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

window.Document = Document # Makes the class global