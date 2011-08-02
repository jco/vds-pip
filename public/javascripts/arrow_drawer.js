var Pip = Pip || {};

Pip.ArrowDrawer = (function() {
    var ArrowDrawer = {};
    var P = Pip;
    
    var arrows = {};
    
    // coordinates are interpreted as distances from the edges of the canvas
    ArrowDrawer.replaceArrows = function(key, coordPairs) {
        clearArrows(key);
        addArrows(key, coordPairs);
    };

    var addArrows = ArrowDrawer.addArrows = function (key, coordPairs) {
        if (!arrows[key])
            arrows[key] = [];
        coordPairs.forEach(function(pair) {
            var arr = drawArrow(pair[0], pair[1]);
            arrows[key].push(arr);
        });
    };

    var clearArrows = ArrowDrawer.clearArrows = function(key) {
        if (arrows[key]) {
            arrows[key].forEach(function(arr) { arr.remove(); });
            arrows[key] = [];
            return true;
        } else {
            return false;
        }
    };
    
    // private

    var drawArrow = function(startCoords, endCoords) {
        return Pip.paper.path(arrowPath(startCoords, endCoords));
    };

    var arrowPath = function(startCoords, endCoords) {
        return arrowMainLineComponent(startCoords, endCoords) + arrowheadComponent(startCoords, endCoords);
    };

    var arrowMainLineComponent = function(startCoords, endCoords) {
        return P.moveTo(startCoords) + P.lineTo(endCoords);
    };

    var arrowheadComponent = function(startCoords, endCoords) {
        var centerCoords = [
            (startCoords[0] + endCoords[0]) * 0.5,
            (startCoords[1] + endCoords[1]) * 0.5
        ];
        var dx = endCoords[0] - startCoords[0];
        var dy = endCoords[1] - startCoords[1];
        var mainLineAngle = Math.atan(dy/dx);
        if (startCoords[0] > endCoords[0])
            mainLineAngle = Math.PI + mainLineAngle;
  
        return arrowheadPath(centerCoords, mainLineAngle);
    };

    var arrowheadPath = function(coords, angle) {
        var len = 9;
        var flare = 20 * Math.PI / 180; // in radians
        var centerCoords = coords;

        var leftDx = len * Math.cos(angle + flare);
        var leftDy = len * Math.sin(angle + flare);
        var leftCoords = [
            centerCoords[0] - leftDx,
            centerCoords[1]- leftDy
        ];

        var rightDx = len * Math.cos(angle - flare);
        var rightDy = len * Math.sin(angle - flare);
        var rightCoords = [
            centerCoords[0] - rightDx,
            centerCoords[1] - rightDy
        ];
  
        return P.moveTo(leftCoords) + P.lineTo(centerCoords) + P.lineTo(rightCoords);
    };

    return ArrowDrawer;
})();

