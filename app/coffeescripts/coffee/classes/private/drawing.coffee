#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

# Methods to help with drawing: SVG notation abstracted. All methods return an SVG "path"
# (a.k.a. instructions to draw on the canvas) as a string.
# Depends on raphael

# Used only within helper.coffee
# This file lets us do Drawing.lineTo([20,30]) and other helpful things.

# This code was from taking Jeff's drawing.js file (code commented out below) and converted to coffeescript via http://js2coffee.org/

class Drawing
  Drawing.circlePath = (x, y, r) ->
    moveTo([ x - r, y ]) + arc([ r, r ], 0, [ 0, 1 ], [ r, -r ]) + arc([ r, r ], 0, [ 1, 1 ], [ -r, r ])

  arc = Drawing.arc = (radii, x_axis_rotation, flags, dest) ->
    rx = radii[0]
    ry = radii[1]
    large_arc_flag = flags[0]
    sweep_flag = flags[1]
    x = dest[0]
    y = dest[1]
    "a" + [ rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y ].join(" ")

  m = Drawing.m = (coords) ->
    "m" + coords.join(" ")

  moveTo = Drawing.moveTo = (coords) ->
    "M" + coords[0] + " " + coords[1]

  Drawing.lineTo = (coords) ->
    "L" + coords[0] + " " + coords[1]
    
window.Drawing = Drawing # Makes the class global

# Pip.Drawing = (function() {
#     var Drawing = {};
# 
#     Drawing.circlePath = function (x, y, r) {
#         return moveTo( [x - r, y] ) + arc([r, r], 0, [0, 1], [r, -r]) +
#                                       arc([r, r], 0, [1, 1], [-r, r]);
#     };
# 
#     var arc = Drawing.arc = function (radii, x_axis_rotation, flags, dest) {
#         var rx = radii[0];
#         var ry = radii[1];
#         var large_arc_flag = flags[0];
#         var sweep_flag = flags[1];
#         var x = dest[0];
#         var y = dest[1];
#         return 'a' + [rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y].join(' ');
#     };
#     var m = Drawing.m = function (coords) {
#         return 'm' + coords.join(' ');
#     };
#     var moveTo = Drawing.moveTo = function(coords) {
#         return 'M' + coords[0] + ' ' + coords[1];
#     };
# 
#     Drawing.lineTo = function(coords) {
#         return 'L' + coords[0] + ' ' + coords[1];
#     };
#     
#     return Drawing;
# })();
# 
# // and for convenience
# Pip.moveTo = Pip.Drawing.moveTo;
# Pip.lineTo = Pip.Drawing.lineTo;