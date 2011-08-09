var Pip = Pip || {};

Pip.ItemDrawer = (function(P) {
    var ItemDrawer = {};

    ItemDrawer.drawItem = function(item) {
        // draw everything and wrap it in a set
        var st          = Pip.paper.set(),
            icon        = Pip.paper.image(iconFor(item), item.coords[0], item.coords[1], 34, 34),
            iconLabel   = Pip.paper.text(item.coords[0] + 34 + 5, item.coords[1] + 17, item.name).attr('text-anchor', 'start');
        st.push(icon, iconLabel);

        // create arrow drawing handle
        var handle = Pip.paper.path(dragHandlePath(item)).attr('fill', 'white');
        st.push(handle);
        assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});

        if (kind(item) == 'document') {
          // double click opens an overlay
          icon.dblclick(documentOverlay(item));

        }
        else {
          // kind == 'folder'
          icon.dblclick(function (ev) {
            // redirect
            location = P.folderPath(item);
          });
        }



        // assign listeners
        assignItemMovementDragListeners({set: st, handle: icon, dragEndCallback: function(newCoords) {
          if (!_.isEqual(newCoords, item.coords)) {
            var x = newCoords[0], y = newCoords[1];

            // part 1: draw dependencies
            // first we have to update the coords of the json item
            setJsonCoords(item, [x, y]);
            Pip.DependencyDrawer.redrawDependencies();

            // part 2: ping server
              console.log('PUT new coords of item ', item, [x, y], '...');
              var url = '/' + kind(item) + 's/' + String(item.id);
              var data = {}; data[kind(item)] = {"x": x, "y": y};
              jQuery.ajax({
                type: 'PUT',
                url: url,
                data: data,
                complete: function() { console.log('Server responded'); }
              });
          }
        }});

    };

    var documentOverlay = ItemDrawer.documentOverlay = function (doc) {
      return function (ev) {
        $.colorbox({
          href: P.documentPath(doc),
          iframe: true,
          width: 500,
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
        var start = function () {
            this.ox = 0;
            this.oy = 0;
            this.attr({opacity: .5});
        },
        move = function (dx, dy) {
            options.set.translate( dx - this.ox, dy - this.oy );
            this.ox = dx;
            this.oy = dy;
        },
        up = function () {
            // restoring state
            this.attr({opacity: 1});
            var currentCoords = [this.attr('x'), this.attr('y')];
            options.dragEndCallback(currentCoords);
        };
        // assign them:
        options.handle.drag(move, start, up)
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
})(Pip);

