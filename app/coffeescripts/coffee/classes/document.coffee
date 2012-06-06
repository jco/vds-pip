# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)

jQuery ->

class Document
  helper = new Helper
  
  # Document is accessible outside this class via $(doc.get()), where doc is the instance of Document
  # Inside this class, use $(@get())
  # More specific ones like $(@getImage()) exist too
  constructor: (@name) ->
    # Prepare basic properties for tag
    @id = helper.getRandomNumber()
    div = "<div id=document_#{@id}>"
    img = "<img id='document_icon_#{@id}' src='#{IMAGE_PATH}/icons/document.png' style='' />"
    label = "<span id=document_label_#{@id}>#{@name}</span>"
    enddiv = "</div>"
    
    @tag = div + img + label + enddiv
    $("#container").append(@tag)
    
    # Set coordinates
    @x = 0; @y = 0
    @setCoordinates(@x, @y)

  getStyleAttributes: ->
    return 'position: relative;'
  
  # Returns the string that jQuery would use to access the Document DOM surrounding divobject, 
  # like '#document_134235'
  get: ->
    return "#document_#{@id}"
  
  setCoordinates: (x,y) ->
    @x = x; @y = y
    $(@get()).css('left', "#{@x}px")
    $(@get()).css('top', "#{@y}px")
  
  setBorderColor: (color) ->
    $(@get()).css('border',"1px solid #{color}")


window.Document = Document # Makes the class global