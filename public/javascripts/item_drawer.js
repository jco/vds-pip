/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

// Coordinates here are in the 4th quadrant; +x goes right, +y goes down
Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    // Draws an item (which can be a folder or a document)
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen; container is the project or folder we're in
      // if (!_.include(P.current_container.folders, item) && 
      //       !_.include(P.current_container.documents, item) ) // http://documentcloud.github.com/underscore/#include
      //   return; // don't draw items that aren't in the current container
      
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
        icon = new Folder(item.name, item.id); // Folder is defined in coffee/
        icon.setCoordinates(item.coords[0], item.coords[1]);
        
        // Set dblclick for folder
        $(icon.getImage()).dblclick(function (ev) { // look at raphael docs to check for these methods
            location = P.folderPath(item); // redirect - this works. "location" is the common browser object in JS.
        });
        
        // Set draggable's stop event for dependency drawing on the handle - other options in folder.coffee
        $(icon.getHandle()).draggable({
          // nothing needed
        });
      } // end folder-specific stuff
      
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
            // ui.draggable - current draggable element, something like <img id=​"document_handle_018951038690283895_2" src=​"../​images/​icons/​circle0.png" width=​"15" height=​"15" class=​"ui-draggable">​
            fromItem = P.index[getKeyFromDraggable(ui.draggable)] // Main idea: get something like this: fromItem = P.index['document_1']
            toItem = item; // Because "droppable" is saying, "If you drop on _this_ item, take some action"
            Pip.DependencyDrawer.createDependency(fromItem, toItem);
        }
      });
    };

    // Used in dependency drawing to get the key for P.index[ ] so it's like P.index['folder_2']
    // Returns something like 'folder_2' or 'document_1'
    var getKeyFromDraggable = function(draggable) {
        return getItemNameFromDraggable(draggable) + '_' + getIdOfDraggable(draggable)
    }

    // Used to get the fromItem's name ('document' or 'folder') from the draggable
    var getItemNameFromDraggable = function(draggable) {
        // draggable might be <img id=​"document_handle_018951038690283895_2" src=​"../​images/​icons/​circle0.png" width=​"15" height=​"15" class=​"ui-draggable">​
        // the huge random number is just a random number for making the id unique. It's different from tree_drawer's #, which is the actual id.
        return draggable.attr('id').split('_')[0];
    }

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

    // A function that, when called, returns another function that pops up the correct overlay
    // Used in drawItem()
    var documentOverlay = ItemDrawer.documentOverlay = function (doc) {
        return function (ev) {
            // 1. Colorbox method
            $.colorbox({
                href: P.documentPath(doc), // returns e.g. /documents/27; this brings us to the documents#show action
                iframe: true,
                innerWidth: 720,
                height: 500,
                onComplete: function(){
                    // Whatever runs in here happens too early, before the first popup's html is ready
                    // Or maybe everything here can't access stuff in href passed above.
                    // Maybe just use separate drag in original interface?
                    // alert("In onComplete");
                    // treeDrawer.drawDepCreationTree(P.project, 'dependency_creation_tree');
                    // var value = $("#document_name").html();
                    // alert("value: "+value);
                }
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