/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var stuff = [];

      // order is important (z-index)
      // first: optional color highlight to indicate status
      var m = P.HIGHLIGHT_MARGIN; // for convenience
      if (kind(item) == 'document') {
        switch (item.status) {
          case "not_updated":
            var color = P.paper.rect(item.coords[0] - m, item.coords[1] - m, 34 + (2 * m), 34 + (2 * m));
            color.attr({"stroke": "none", fill: 'red'});
            stuff.push(color);
            break;
          case 'being_worked_on':
            var color = P.paper.rect(item.coords[0] - m, item.coords[1] - m, 34 + (2 * m), 34 + (2 * m));
            color.attr({"stroke": "none", fill: 'yellow'});
            stuff.push(color);
            break;
        }
      }

      var icon        = Pip.paper.image(iconFor(item), item.coords[0], item.coords[1], 34, 34);//34s are width and height of icon
      // test problem of 'image'
      var iconLabel   = Pip.paper.text(item.coords[0] + 34 + 5, item.coords[1] + 17, item.name).attr('text-anchor', 'start');
      stuff.push(icon, iconLabel);

      // create arrow drawing handle
      var handle = Pip.paper.path(dragHandlePath(item)).attr('fill', 'white');
      stuff.push(handle);
      assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});

      if (kind(item) == 'document') {
        // double click opens an overlay
        icon.dblclick(documentOverlay(item));
      } else {
        // kind == 'folder'
        icon.dblclick(function (ev) {
            // redirect
            location = P.folderPath(item); // works
        });
        // icon.click(function (ev) {
        //     // alert("clicked"); // 
        //     $('body').css('background', 'pink'); // 
        // });
        // icon.mouseover(function (ev) {
        //     $('body').css('background', 'gray'); // works
        //     // alert("mouseover"); // works for vds
        // });
        // icon.mouseout(function (ev) {
        //     $('body').css('background', 'blue'); // works
        //     // alert("mouseout"); // makes vds crash with stack overflow
        // });
        // icon.mousedown(function (ev) {
        //     $('body').css('background', 'green'); // undetected
        //     // alert("mousedown"); // undetected
        // });
        // icon.mouseup(function (ev) {
        //     $('body').css('background', 'yellow'); // undetected
        //     // alert("mouseup"); // undetected
        // });
        
      }

      var st = Pip.paper.set();
      stuff.forEach(function (thing) {
        thing.toFront();
        st.push(thing);
      });

      // assign listeners - moving folders, etc.
      assignItemMovementDragListeners({set: st, handle: icon, dragEndCallback: function(newCoords) {
        if (!_.isEqual(newCoords, item.coords)) {
          var x = newCoords[0], y = newCoords[1];

          // part 1: draw dependencies
          // first we have to update the coords of the json item
          setJsonCoords(item, [x, y]);
          Pip.DependencyDrawer.redrawDependencies();

          // part 2: ping server
          console.log('PUT new coordinates of item ', item, [x, y], '...');
          var url = '/' + kind(item) + 's/' + String(item.id);
          var data = {}; data[kind(item)] = {"x": x, "y": y};
          $.ajax({
            type: 'PUT',
            url: url,
            data: data,
            dataType: 'json',
            complete: function() { console.log('...complete.'); },
            // error: P.error
            error: function(e, ts, et) { alert(ts) }
          });
        }
      }});

    };

    var documentOverlay = ItemDrawer.documentOverlay = function (doc) {
      return function (ev) {
        $.colorbox({
          href: P.documentPath(doc),
          iframe: true,
          innerWidth: 720,
          height: 500
        });
      };
    };


    var setIconCoords = function (item, coords) {
    };

    var setJsonCoords = function (item, coords) {
      item.coords = coords;
    };

    var setServerCoords = function (item, coords) {
      //
    };

    var kind = P.kind = function (item) {
      return item.documents ? 'folder' : 'document';
    };

    
    var assignItemMovementDragListeners = function (options) {
        // define drag handlers
        // "this" is the icon
        var start = function () { // mousedown
            $("body").css('background','red'); // not executed in vds
            this.ox = 0;
            this.oy = 0;
            this.attr({opacity: .5});
        },
        move = function (dx, dy) {
            $("body").css('background','yellow'); // not executed in vds
            options.set.translate( dx - this.ox, dy - this.oy );
            this.ox = dx;
            this.oy = dy;
        },
        up = function () { // mouseup
            $("body").css('background','green'); // not executed in vds
            // restoring state
            this.attr({opacity: 1});
            var currentCoords = [this.attr('x'), this.attr('y')];
            options.dragEndCallback(currentCoords);
        };
        // assign them:
        // alert("in assignItemMovementDragListeners");
        // $("body").css('background','orange'); // not executed in vds

        if (P.kind == 'folder') {
          this.addEventListener('mousedown', start, false);
          this.addEventListener('mousemove', move, false);
          this.addEventListener('mouseup', up, false);
        }
        
        options.handle.drag(move, start, up); // needed 
    };
    
    var assignArrowDrawingListeners = function (ops) {
       var dragStart = function () {
           // set a 'global' variable indicating we are in a drop
           Pip.someGlobal = {draggingArrow: true, originItem: ops.item};
       },
       dragMove = function (dx, dy) {
            // show temp arrow
            var handleCoords = handlePoint(ops.item);
            var coordPair = [
                // sane way to get coords of ops.handle
                // assume its a circle?
                handleCoords,
                // current point
                [handleCoords[0] + dx, handleCoords[1] + dy]
            ];
           Pip.ArrowDrawer.replaceArrows(ops.item, [coordPair]);
           // alert("hooray level 2"); // WHY IS THIS NOT REACHED ON VDS?
       },
       dragUp = function() {
           Pip.someGlobal = {};
           Pip.ArrowDrawer.clearArrows(ops.item);
       };
       ops.handle.drag(dragMove, dragStart, dragUp);
       ops.dropZone.mouseup(function (ev) {
           if (Pip.someGlobal && Pip.someGlobal.draggingArrow) {
               Pip.DependencyDrawer.createDependency(Pip.someGlobal.originItem, ops.item);
           }
       });

    };

    var dragHandlePath = function(item) {
        var centerPoint = handlePoint(item);
        var point = [ centerPoint[0] + 3, centerPoint[1] ];
        var radius = 5;
        return Pip.Drawing.circlePath(centerPoint[0], centerPoint[1], radius) +
            Pip.moveTo([ centerPoint[0] - 3, centerPoint[1] ]) + Pip.lineTo(point) + 
            Pip.moveTo([ centerPoint[0], centerPoint[1] - 3 ]) + Pip.lineTo(point) +
            Pip.moveTo([ centerPoint[0], centerPoint[1] + 3 ]) + Pip.lineTo(point);
    };

    var handlePoint = function (item) {
        return [ item.coords[0] + 30, item.coords[1] + 17 ];
    };

    var iconFor = P.iconFor = function (item) {
        return item.icon || '/images/icons/folder.gif';
    };

    return ItemDrawer;
})(Pip, jQuery);

