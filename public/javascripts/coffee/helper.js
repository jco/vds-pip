/* DO NOT MODIFY. This file was compiled Wed, 06 Jun 2012 15:47:40 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/helper.coffee
 */

(function() {
  var Helper;

  jQuery(function() {});

  Helper = (function() {
    var canvas;

    function Helper() {}

    canvas = null;

    Helper.prototype.setCanvas = function(c) {
      return canvas = c;
    };

    Helper.prototype.getView = function() {
      try {
        if (gon.view === gon.global.PROJECTS_SHOW || gon.view === gon.global.FOLDERS_SHOW) {
          return gon.view;
        } else {
          return gon.global.OTHER_VIEW;
        }
      } catch (error) {
        return alert("Problem: " + error);
      }
    };

    Helper.prototype.getRandomNumber = function() {
      return (Math.random() + '').replace('.', '');
    };

    Helper.prototype.drawArrow = function(startCoords, endCoords) {
      alert("that thing: " + (this._arrowPath(startCoords, endCoords)));
      return canvas.path(this._arrowPath(startCoords, endCoords));
    };

    Helper.prototype._arrowPath = function(startCoords, endCoords) {
      return this._arrowMainLineComponent(startCoords, endCoords) + this._arrowheadComponent(startCoords, endCoords);
    };

    Helper.prototype._arrowMainLineComponent = function(startCoords, endCoords) {
      return Drawing.moveTo(startCoords) + Drawing.lineTo(endCoords);
    };

    Helper.prototype._arrowheadComponent = function(startCoords, endCoords) {
      var centerCoords, dx, dy, mainLineAngle;
      centerCoords = [(startCoords[0] + endCoords[0]) * 0.5, (startCoords[1] + endCoords[1]) * 0.5];
      dx = endCoords[0] - startCoords[0];
      dy = endCoords[1] - startCoords[1];
      mainLineAngle = Math.atan(dy / dx);
      if (startCoords[0] > endCoords[0]) {
        mainLineAngle = Math.PI + mainLineAngle;
      }
      return this._arrowheadPath(centerCoords, mainLineAngle);
    };

    Helper.prototype._arrowheadPath = function(coords, angle) {
      var centerCoords, flare, leftCoords, leftDx, leftDy, len, rightCoords, rightDx, rightDy;
      len = 9;
      flare = 20 * Math.PI / 180;
      centerCoords = coords;
      leftDx = len * Math.cos(angle + flare);
      leftDy = len * Math.sin(angle + flare);
      leftCoords = [centerCoords[0] - leftDx, centerCoords[1] - leftDy];
      rightDx = len * Math.cos(angle - flare);
      rightDy = len * Math.sin(angle - flare);
      rightCoords = [centerCoords[0] - rightDx, centerCoords[1] - rightDy];
      return Drawing.moveTo(leftCoords) + Drawing.lineTo(centerCoords) + Drawing.lineTo(rightCoords);
    };

    return Helper;

  })();

  window.Helper = Helper;

}).call(this);
