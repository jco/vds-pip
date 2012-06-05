/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

// Coordinates here are in the 4th quadrant; +x goes right, +y goes down
Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    var helper = new Helper(); // Defined in app/coffeescripts
    helper.test();
    var f = new Folder("my name"); // YAYY it works.
    
    // Draws an item (which can be a folder or a document)
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var m = P.HIGHLIGHT_MARGIN; // first: optional color highlight to indicate status; for convenience
      if (kind(item) == 'document') {
        switch (item.status) {
          case "not_updated":
            // TODO: Create not updated document
            
            // var color = P.paper.rect(item.coords[0] - m, item.coords[1] - m, 34 + (2 * m), 34 + (2 * m));
            // color.attr({"stroke": "none", fill: 'red'});
            // stuff.push(color);
            break;
          case 'being_worked_on':
            // TODO: Created document being worked on
            // var color = P.paper.rect(item.coords[0] - m, item.coords[1] - m, 34 + (2 * m), 34 + (2 * m));
            // color.attr({"stroke": "none", fill: 'yellow'});
            // stuff.push(color);
            break;
        }
      }

      // TODO: Draw the icon associated with the file type
      // var icon        = Pip.paper.image(iconFor(item), item.coords[0], item.coords[1], 34, 34);//34s are width and height of icon
      
      // jquery div img stuff!!
      

      // TODO: Create arrow drawing handle (handle is the white circle w/ arrow from which the user can draw arrows)
      // var handle = Pip.paper.path(dragHandlePath(item)).attr('fill', 'white');
      
      // TODO: Actually assign the event listeners for creating arrows/dependencies
      // LATER
      // assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});

      // TODO: Figure out what a double-click should do based on whether _item_ a folder or document
      if (kind(item) == 'document') {
        // double click opens an overlay
        // icon.dblclick(documentOverlay(item));
      } else {
        // kind == 'folder'
        // icon.dblclick(function (ev) { // look at raphael docs to check for these methods
        //     // redirect
        //     location = P.folderPath(item); // works
        // });
      }

      // TODO: Set id of icon for jQuery access, and modify properties so jQuery's draggable works
      // icon.node.id = "icon_id_"+randomValue();
      
      // TODO: Assign the event listeners responsible for letting the user change the visual position of the item
      // by dragging.
      // $("#"+icon.node.id).draggable({
      //   // stop: function(event, ui) { }
      // });


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
        move = function (dx, dy) { // A: dx is the new x coordinate, dy the new y coordinate - not actually the 'difference/change' of the variables.
            $("body").css('background','yellow'); // not executed in vds
            options.set.translate( dx - this.ox, dy - this.oy ); // "A" is why we subtract!
            this.ox = dx; // updates frequently while moving: this sets the item's coordinates to be the new coords
            this.oy = dy;
        },
        up = function () { // mouseup, 'onend' for raphael doc
            $("body").css('background','green'); // not executed in vds
            // restoring state
            this.attr({opacity: 1});
            // Old: var currentCoords = [this.attr('x'), this.attr('y')]; // issue: coordinates don't end up changing/saving on page reload
            // Attempt 1: var currentCoords = [this.ox, this.oy]; // [this.ox, this.oy] ends up being the change in coordinates, somehow.
            // [this.attr('x'), this.attr('y')] are the original coordinates! so add this and [this.ox, this.oy]
            var currentCoords = [this.ox+this.attr('x'), this.oy+this.attr('y')] // this works last I tried!
            alert('currentCoords after mouseup: '+currentCoords);
            options.dragEndCallback(currentCoords); // currentCoords becomes newCoords in assignItemMovementDragListeners
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

    // Returns a random integer value, used for id generation
    var randomValue = function() {
      return (Math.random() + "").replace(".", ""); // replace the . so there's no decimal, just because id= values shouldn't have decimals
    };
      
    return ItemDrawer;
})(Pip, jQuery);

