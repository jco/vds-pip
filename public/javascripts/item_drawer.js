/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    // Draws an item (which can be a folder or a document) on the canvas.
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var stuff = []; // holds items of things to be drawn; handles order ('layer')

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

      // draws the icon associated with the file type
      // raphael object
      var icon        = Pip.paper.image(iconFor(item), item.coords[0], item.coords[1], 34, 34);//34s are width and height of icon
      // test problem of 'image'
      var iconLabel   = Pip.paper.text(item.coords[0] + 34 + 5, item.coords[1] + 17, item.name).attr('text-anchor', 'start');
      stuff.push(icon, iconLabel);

      // create arrow drawing handle (handle is the white circle w/ arrow from which the user can draw arrows)
      var handle = Pip.paper.path(dragHandlePath(item)).attr('fill', 'white');
      stuff.push(handle);
      
      // Actually assign the event listeners for creating arrows/dependencies
      assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});

      // Figure out what a double-click should do based on whether _item_ a folder or document
      if (kind(item) == 'document') {
        // double click opens an overlay
        icon.dblclick(documentOverlay(item));
      } else {
        // kind == 'folder'
        icon.dblclick(function (ev) { // look at raphael docs to check for these methods
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

      // Reorder the elements of _stuff[]_ such that the last thing in the array is at the front.
      var st = Pip.paper.set(); // Pip.paper is raphaeljs's own data structure; set returns an empty set
      stuff.forEach(function (thing) {
        thing.toFront();
        st.push(thing);
      });

      // Assign the event listeners responsible for letting the user change the visual position of the item
      // by dragging.
      item.draggable({
        // stop: function(event, ui) { }
      });
      
      // assignItemMovementDragListeners({set: st, handle: icon, dragEndCallback: function(newCoords) {
      //   if (!_.isEqual(newCoords, item.coords)) { // can't do this: if ([4,5] == [4,5])
      //     var x = newCoords[0], y = newCoords[1];
      // 
      //     // part 1: draw dependencies
      //     // first we have to update the coords of the json item
      //     setJsonCoords(item, [x, y]);
      //     Pip.DependencyDrawer.redrawDependencies();
      // 
      //     // part 2: ping server
      //     console.log('PUT new coordinates of item ', item, [x, y], '...');
      //     var url = '/' + kind(item) + 's/' + String(item.id);
      //     var data = {}; data[kind(item)] = {"x": x, "y": y};
      //     $.ajax({
      //       type: 'PUT',
      //       url: url,
      //       data: data,
      //       dataType: 'json',
      //       complete: function() { console.log('...complete.'); },
      //       // error: P.error
      //       error: function(e, ts, et) { alert(ts) }
      //     });
      //   }
      // }});

    };

    // A function that, when called, returns another function that pops up the correct overlay.
    // Used in drawItem().
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

    // Function for determining whether the given item is a document or folder.
    var kind = P.kind = function (item) {
      return item.documents ? 'folder' : 'document';
    };

    // Assign the event listeners responsible for letting the user change the visual position of the item
    // by dragging.
    // _options_ should look like {set: st, handle: icon, dragEndCallback: function(newCoords) { ... } }
    //    Where _set_ is all the components that represent the item. We want to drag these all at once.
    //      ... _handle_ is the area the user clicks to initiate the drag; in this case, the icon.
    //      ... _dragEndCallback_ is a function that's called when the user lifts the mouse. The coordinates
    //                            where the user did that are supplied as a argument.
    var assignItemMovementDragListeners = function (options) {
        // define drag handlers
        // "this" is the icon
        // raphael calls these functions, 
        // raphael example:
        // Element.drag(onmove, onstart, onend, [mcontext], [scontext], [econtext])
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
        up = function () { // mouseup, 'onend' for raphael doc
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
        
        // Assign the listeners
        options.handle.drag(move, start, up); // needed 
    };
    
    // Assign event listeners to the various components of an item (doc or folder) such that
    // when the user clicks and drags from the drag handle to another icon, an arrow/dependency is created.
    var assignArrowDrawingListeners = function (ops) {
      
      // First, create the three events that will fire as part of the dragging process
      // (http://raphaeljs.com/reference.html#Element.drag)
      
      // dragStart() fires when the drag is initiated
      // dragMove() fires every time the listener is dragged (I think continuously?)
      // dragUp() fires when the mouse is lifted after a drag, signaling the end
      
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
       
       // This line actually assigns the listeners
       ops.handle.drag(dragMove, dragStart, dragUp); // handles the drag and making the arrow appear
       
       // This is a fourth event listener, placed on the "dropZone" (i.e. the destination of the drag).
       // It is responsible for figuring out whether we were dragging in the first place, and if it
       // thinks everything is legit, it creates the dependency on the server.
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

