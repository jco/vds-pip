#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)
# Helper methods used by other classes

jQuery ->

class Helper
  canvas = null # just a local variable for the class (essentially, a private variable)
  
  setCanvas: (c) ->
    canvas = c
  
  showCanvas: ->
    alert canvas
  # Returns the view; possibilities set in application_controller
  # Post: returns 'other', 'projects/show', or 'folders/show'
  getView: ->
    try
      if gon.view == gon.global.PROJECTS_SHOW or gon.view == gon.global.FOLDERS_SHOW
        return gon.view
      else
        return gon.global.OTHER_VIEW
    catch error
      alert "Problem: #{error}"

  # Useful for random id generation (which allows identification) in classes like Folder
  getRandomNumber: ->
    return (Math.random() + '').replace('.','') # removes the '.'
  
  # -- Raphael-dependent draw line functions --
  
  # Draws a single arrow given by a pair of coordinates
  # e.g. drawArrow([2,3], [4,5]) draws a small arrow
  drawArrow: (startCoords, endCoords) ->
    canvas.path @_arrowPath(startCoords, endCoords)
  
  # PRIVATE METHODS BELOW
  
  _arrowPath: (startCoords, endCoords) ->
    @_arrowMainLineComponent(startCoords, endCoords) + @_arrowheadComponent(startCoords, endCoords)
  
  # The main line, without the tiny arrow thing (>)
  _arrowMainLineComponent: (startCoords, endCoords) ->
    # P.moveTo... P.lineTo...
    Drawing.moveTo(startCoords) + Drawing.lineTo(endCoords)
  
  # The arrow head, the >, which is placed in the center of the line
  _arrowheadComponent: (startCoords, endCoords) ->
    centerCoords = [ (startCoords[0] + endCoords[0]) * 0.5, (startCoords[1] + endCoords[1]) * 0.5 ]
    dx = endCoords[0] - startCoords[0]
    dy = endCoords[1] - startCoords[1]
    mainLineAngle = Math.atan(dy / dx)
    mainLineAngle = Math.PI + mainLineAngle if startCoords[0] > endCoords[0]
    @_arrowheadPath centerCoords, mainLineAngle
  
  # The path that draws the tiny arrowhead
  _arrowheadPath: (coords, angle) ->
    len = 9
    flare = 20 * Math.PI / 180
    centerCoords = coords
    leftDx = len * Math.cos(angle + flare)
    leftDy = len * Math.sin(angle + flare)
    leftCoords = [ centerCoords[0] - leftDx, centerCoords[1] - leftDy ]
    rightDx = len * Math.cos(angle - flare)
    rightDy = len * Math.sin(angle - flare)
    rightCoords = [ centerCoords[0] - rightDx, centerCoords[1] - rightDy ]
    # P.moveTo(leftCoords) + P.lineTo(centerCoords) + P.lineTo(rightCoords)
    Drawing.moveTo(leftCoords) + Drawing.lineTo(centerCoords) + Drawing.lineTo(rightCoords)

window.Helper = Helper # Makes the class global