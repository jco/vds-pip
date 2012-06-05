# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)

jQuery ->

class Folder
  helper = new Helper
  
  constructor: (@name) ->
    @id = helper.getRandomNumber()
    div = "<div id=folder_#{@id}>"
    img = "<img id='folder_icon_#{@id}' src='#{IMAGE_PATH}/icons/folder.gif' style='' />"
    label = "<span id=folder_label_#{@id}>#{@name}</span>"
    enddiv = "</div>"
    
    @tag = div + img + label + enddiv
    $("#container").append(@tag)
  
window.Folder = Folder # Makes the class global