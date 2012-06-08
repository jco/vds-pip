/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

// Coordinates here are in the 4th quadrant; +x goes right, +y goes down
Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    var helper = new Helper(); // Defined in app/coffeescripts
    helper.setCanvas(P.paper);
    // helper.showCanvas();
    
    // Draws an item (which can be a folder or a document)
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var icon;
      if (kind(item) == 'document') { 
        icon = new Document(item.name);
        switch (item.status) {
          case "not_updated":
            icon.setBorderColor('red');
            break;
          case 'being_worked_on':
            icon.setBorderColor('yellow');
            break;
          case 'up_to_date':
            // no border
            break;
        }
        
        // Set dblclick for document - opens an overlay
        $(icon.getImage()).dblclick(documentOverlay(item));
      } else { // Item is a folder
        // Initialize icon
        icon = new Folder(item.name);
        icon.setCoordinates(item.coords[0], item.coords[1]);
        
        // Set dblclick for folder
        $(icon.getImage()).dblclick(function (ev) { // look at raphael docs to check for these methods
            location = P.folderPath(item); // redirect - this works
        });
        
        // Set draggable's stop event for dependency drawing on the handle - other options in folder.coffee
        $(icon.getHandle()).draggable({
          // nothing needed
        });
      }
      
      // Set draggable's stop event for ajax calls & updating coordinates on the actual icon - other options in folder.coffee / document.coffee
      $(icon.get()).draggable({ // THIS WORKS =D Good example
        stop: function(event, ui) { 
          // Update
          icon.updateCoordinates();
          
          var x = icon.x, y = icon.y;
          
          alert("Here: "+x+"; "+y);
          // part 1: draw dependencies
          // first we have to update the coords of the json item
          setJsonCoords(item, [x, y]);
          Pip.DependencyDrawer.redrawDependencies();

          // part 2: ping server
          console.log('PUT new coordinates of item ', item, [x, y], '...');
          var url = '/' + kind(item) + 's/' + String(item.id); // so you have /documents/2 or /folders/3
          var data = {}; data[kind(item)] = {"x": x, "y": y}; // so data is like { document => {:x => x, :y => y} }
          $.ajax({
            type: 'PUT',
            url: url,
            data: data,
            dataType: 'json',
            complete: function() { console.log('...complete.'); },
            // error: P.error
            // error: function(e, ts, et) { alert(ts) }
          });
        }
      });
      
      $(icon.get()).droppable({
        // TODO - update arrows appropriately
        // helper.drawArrow([100,200],[300,300])
        // Actually assign the event listeners for creating arrows/dependencies
        // assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});
        drop: function(event, ui) {
          alert("ui.draggable: "+$(ui.draggable));
          // I will pass the div if object!
          Pip.DependencyDrawer.createDependency(originItem, droppable);
        }
        // get id of object that dropped
      });
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

    var setJsonCoords = function (item, coords) {
      item.coords = coords;
    };

    // Function for determining whether the given item is a document or folder.
    var kind = P.kind = function (item) {
      return item.documents ? 'folder' : 'document';
    };

    var iconFor = P.iconFor = function (item) {
        return item.icon || '/images/icons/folder.gif';
    };
    
    return ItemDrawer;
})(Pip, jQuery);

