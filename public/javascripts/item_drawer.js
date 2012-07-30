/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

// Coordinates here are in the 4th quadrant; +x goes right, +y goes down
Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    // Draws an item (which can be a folder or a document)
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var icon;
      if (kind(item) == 'document') {
        icon = new Document(item.name, item.id); // Document is defined in coffee/
        icon.setCoordinates(item.coords[0], item.coords[1]);
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
        icon = new Folder(item.name); // Folder is defined in coffee/
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
      
      // Set draggable's stop event for ajax calls for _updating coordinates on the actual icon_ - other options in folder.coffee / document.coffee
      $(icon.get()).draggable({ // THIS WORKS =D Good example
        stop: function(event, ui) { 
          // Update
          icon.updateCoordinates();
          
          var x = icon.x, y = icon.y;
          
          // alert("Here: "+x+"; "+y);
          // part 1: draw dependencies
          // first we have to update the coords of the json item
          setJsonCoords(item, [x, y]);
          Pip.DependencyDrawer.redrawDependencies();

          // part 2: ping server
          console.log('PUT new coordinates of item ', item, [x, y], '...'+item.location_id);
          var url = '/locations/' + String(item.location_id)
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
      
      // Set droppable / DEPENDENCY drawing
      $(icon.get()).droppable({
        // Actually assigns the event listeners for creating arrows/dependencies
        // assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});
        drop: function(event, ui) {            
            // ui.draggable - current draggable element
            fromItem = P.index['document_'+getIdOfDraggable(ui.draggable)] // fromItem = P.index['document_1'] // This works! This is the main idea.
            toItem = item; // Because "droppable" is saying, "If you drop on _this_ item, take some action"
            Pip.DependencyDrawer.createDependency(fromItem, toItem);
        }
      });
    };

    // A function that, when called, returns another function that pops up the correct overlay.
    // Used in drawItem().
    var documentOverlay = ItemDrawer.documentOverlay = function (doc) {
        return function (ev) {
            $.colorbox({
                onComplete: function() {
                    // Set click action so the create-dependency-from-tree box appears
                    $("#from_button").click(function() { // WHY ISN'T THIS WORKING?
                        alert("anything!");
                        $("#pane").toggle();
                    });
                    
                    // // Set dblclick for document - opens an overlay
                    // $(icon.getImage()).dblclick(documentOverlay(item));
                },
                href: P.documentPath(doc), // this brings us to the documents#show action
                iframe: true,
                innerWidth: 720,
                height: 500
            });
        };
    };

    // A function that, when called, returns another function that pops up an overlay
    // for creating a dependency from a tree menu
    // Used in documentOverlay
    // var createDepFromTreeOverlay = ItemDrawer.createDepFromTreeOverlay = function (item) {
    //     return function (ev) {
    //         $.colorbox({
    //             iframe: true,
    //             innerWidth: 500,
    //             height: 400,
    //             onComplete: function() {
    //                 
    //             }
    //         });
    //     };
    // };

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
    
    // Used to get the fromItem's id from the draggable
    var getIdOfDraggable = function(draggable) {
        return draggable.attr('id').split('_')[3];
        // Explanation (from console):
        // ui.draggable (which is draggable here)
        // => <img id=​"document_handle_018951038690283895_2" src=​"../​images/​icons/​circle0.png" width=​"15" height=​"15" class=​"ui-draggable">​
        // ui.draggable.attr('id')
        // => "document_handle_018951038690283895_2"
        // ui.draggable.attr('id').split('_')
        // => ["document", "handle", "018951038690283895", "2"]
    }
    
    return ItemDrawer;
})(Pip, jQuery);