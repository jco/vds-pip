/* DO NOT MODIFY. This file was compiled Tue, 24 Jul 2012 14:26:00 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/private/arrow_drawer.coffee
 */

(function() {
  var Pip;

  Pip = Pip || {};

  Pip.ArrowDrawer = (function() {
    var ArrowDrawer, P, addArrows, arrowMainLineComponent, arrowPath, arrowheadComponent, arrowheadPath, arrows, clearArrows, drawArrow;
    ArrowDrawer = {};
    P = Pip;
    arrows = {};
    ArrowDrawer.replaceArrows = function(key, coordPairs) {
      clearArrows(key);
      return addArrows(key, coordPairs);
    };
    addArrows = ArrowDrawer.addArrows = function(key, coordPairs) {
      if (!arrows[key]) {
        arrows[key] = [];
      }
      return coordPairs.forEach(function(pair) {
        var arr;
        arr = drawArrow(pair[0], pair[1]);
        return arrows[key].push(arr);
      });
    };
    clearArrows = ArrowDrawer.clearArrows = function(key) {
      if (arrows[key]) {
        arrows[key].forEach(function(arr) {
          return arr.remove();
        });
        arrows[key] = [];
        return true;
      } else {
        return false;
      }
    };
    drawArrow = function(startCoords, endCoords) {
      return Pip.paper.path(arrowPath(startCoords, endCoords));
    };
    arrowPath = function(startCoords, endCoords) {
      return arrowMainLineComponent(startCoords, endCoords) + arrowheadComponent(startCoords, endCoords);
    };
    arrowMainLineComponent = function(startCoords, endCoords) {
      return P.moveTo(startCoords) + P.lineTo(endCoords);
    };
    arrowheadComponent = function(startCoords, endCoords) {
      var centerCoords, dx, dy, mainLineAngle;
      centerCoords = [(startCoords[0] + endCoords[0]) * 0.5, (startCoords[1] + endCoords[1]) * 0.5];
      dx = endCoords[0] - startCoords[0];
      dy = endCoords[1] - startCoords[1];
      mainLineAngle = Math.atan(dy / dx);
      if (startCoords[0] > endCoords[0]) {
        mainLineAngle = Math.PI + mainLineAngle;
      }
      return arrowheadPath(centerCoords, mainLineAngle);
    };
    arrowheadPath = function(coords, angle) {
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
      return P.moveTo(leftCoords) + P.lineTo(centerCoords) + P.lineTo(rightCoords);
    };
    return ArrowDrawer;
  })();

}).call(this);
