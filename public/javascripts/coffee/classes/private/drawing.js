/* DO NOT MODIFY. This file was compiled Fri, 08 Jun 2012 15:02:25 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/private/drawing.coffee
 */

(function() {
  var Drawing;

  Drawing = (function() {
    var arc, m, moveTo;

    function Drawing() {}

    Drawing.circlePath = function(x, y, r) {
      return moveTo([x - r, y]) + arc([r, r], 0, [0, 1], [r, -r]) + arc([r, r], 0, [1, 1], [-r, r]);
    };

    arc = Drawing.arc = function(radii, x_axis_rotation, flags, dest) {
      var large_arc_flag, rx, ry, sweep_flag, x, y;
      rx = radii[0];
      ry = radii[1];
      large_arc_flag = flags[0];
      sweep_flag = flags[1];
      x = dest[0];
      y = dest[1];
      return "a" + [rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y].join(" ");
    };

    m = Drawing.m = function(coords) {
      return "m" + coords.join(" ");
    };

    moveTo = Drawing.moveTo = function(coords) {
      return "M" + coords[0] + " " + coords[1];
    };

    Drawing.lineTo = function(coords) {
      return "L" + coords[0] + " " + coords[1];
    };

    return Drawing;

  })();

  window.Drawing = Drawing;

}).call(this);
