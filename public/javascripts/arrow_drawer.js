/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

Pip.ArrowDrawer = (function() {
    var ArrowDrawer = {};
    var P = Pip;
    
    // A hash for labeling groups of arrows. You might have one label for one arrow, and
    // another label for 10 arrows. The purpose is to keep track of the meaning of different
    // arrows and to be able to erase a group of them when you want to.
    var arrows = {};
    
    // Accessible outside this 'module'
    
    // For a given key/label, get rid of all the current arrows and replace them
    // with a new set of arrows defined by _coordPairs_. Leave other arrows intact.
    // (Coordinates are interpreted as distances from the edges of the canvas)
    ArrowDrawer.replaceArrows = function(key, coordPairs) {
        clearArrows(key);
        addArrows(key, coordPairs);
    };

    // Draw a bunch of arrows and associate them with the given key/label.
    var addArrows = ArrowDrawer.addArrows = function (key, coordPairs) {
        if (!arrows[key])
            arrows[key] = [];
        coordPairs.forEach(function(pair) {
            var arr = helper.drawArrow(pair[0], pair[1]);
            arrows[key].push(arr);
        });
    };

    // Erase all the arrows associated with the given key/label.
    var clearArrows = ArrowDrawer.clearArrows = function(key) {
        if (arrows[key]) {
            arrows[key].forEach(function(arr) { arr.remove(); });
            arrows[key] = [];
            return true;
        } else {
            return false;
        }
    };
    
    // METHODS BELOW ARE NOW IN HELPER.COFFEE
    // private

    // // Draws a single arrow given by a pair of coordinates
    // // e.g. drawArrow([2,3], [4,5]) draws a small arrow
    // var drawArrow = function(startCoords, endCoords) {
    //     return Pip.paper.path(arrowPath(startCoords, endCoords));
    // };
    // 
    // var arrowPath = function(startCoords, endCoords) {
    //     return arrowMainLineComponent(startCoords, endCoords) + arrowheadComponent(startCoords, endCoords);
    // };
    // 
    // var arrowMainLineComponent = function(startCoords, endCoords) {
    //     return P.moveTo(startCoords) + P.lineTo(endCoords);
    // };
    // 
    // var arrowheadComponent = function(startCoords, endCoords) {
    //     var centerCoords = [
    //         (startCoords[0] + endCoords[0]) * 0.5,
    //         (startCoords[1] + endCoords[1]) * 0.5
    //     ];
    //     var dx = endCoords[0] - startCoords[0];
    //     var dy = endCoords[1] - startCoords[1];
    //     var mainLineAngle = Math.atan(dy/dx);
    //     if (startCoords[0] > endCoords[0])
    //         mainLineAngle = Math.PI + mainLineAngle;
    //   
    //     return arrowheadPath(centerCoords, mainLineAngle);
    // };
    // 
    // var arrowheadPath = function(coords, angle) {
    //     var len = 9;
    //     var flare = 20 * Math.PI / 180; // in radians
    //     var centerCoords = coords;
    // 
    //     var leftDx = len * Math.cos(angle + flare);
    //     var leftDy = len * Math.sin(angle + flare);
    //     var leftCoords = [
    //         centerCoords[0] - leftDx,
    //         centerCoords[1]- leftDy
    //     ];
    // 
    //     var rightDx = len * Math.cos(angle - flare);
    //     var rightDy = len * Math.sin(angle - flare);
    //     var rightCoords = [
    //         centerCoords[0] - rightDx,
    //         centerCoords[1] - rightDy
    //     ];
    //   
    //     return P.moveTo(leftCoords) + P.lineTo(centerCoords) + P.lineTo(rightCoords);
    // };

    return ArrowDrawer;
})();

