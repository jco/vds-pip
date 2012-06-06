/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

// Coordinates here are in the 4th quadrant; +x goes right, +y goes down
Pip.ItemDrawer = (function(P, $) {
    var ItemDrawer = {};

    var helper = new Helper(); // Defined in app/coffeescripts
    
    // Draws an item (which can be a folder or a document)
    ItemDrawer.drawItem = function(item) { // for each item (e.g., folder) on screen
      var icon;
      if (kind(item) == 'document') { 
        // This area is unclear! What are documents? ..includes links based on kind(item) == 'document' below
        switch (item.status) {
          case "not_updated":
            // TODO: Create not updated document
            icon = new Document("some document name");
            icon.setBorderColor('red');
            break;
          case 'being_worked_on':
            // TODO: Created document being worked on
            icon = new Document("some other document name");
            icon.setBorderColor('yellow');
            break;
        }
        // TODO: document dblclick
        // double click opens an overlay
        // icon.dblclick(documentOverlay(item));
      } else { // Item is a folder
        // Initialize icon
        icon = new Folder(item.name);
        icon.setCoordinates(item.coords[0], item.coords[1]);
        
        // Set dblclick
        $(icon.getImage()).dblclick(function (ev) { // look at raphael docs to check for these methods
            location = P.folderPath(item); // redirect - this works
        });
        
        // Set draggable for dependency drawing - other options specified in the appropriate class
        $(icon.getHandle()).draggable({
          stop: function(event, ui) { 
            alert('yay'); 
            assignArrowDrawingListeners({handle: icon.getHandle(), dropZone: icon, item: item});
          }
        });
      }
      
      // TODO: Actually assign the event listeners for creating arrows/dependencies
      // assignArrowDrawingListeners({handle: handle, dropZone: icon, item: item});
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

    // only here... not used
    var setJsonCoords = function (item, coords) {
      item.coords = coords;
    };

    // Function for determining whether the given item is a document or folder.
    var kind = P.kind = function (item) {
      return item.documents ? 'folder' : 'document';
    };

    // Assign event listeners to the various components of an item (doc or folder) such that
    // when the user clicks and drags from the drag handle to another icon, an arrow/dependency is created.
    var assignArrowDrawingListeners = function (ops) {
       
       // This is an event listener placed on the "dropZone" (i.e. the destination of the drag).
       // It is responsible for figuring out whether we were dragging in the first place, and if it
       // thinks everything is legit, it creates the dependency on the server.
       // ops.dropZone.mouseup(function (ev) {
       //   alert('reached');
       //     if (Pip.someGlobal && Pip.someGlobal.draggingArrow) {
       //         Pip.DependencyDrawer.createDependency(Pip.someGlobal.originItem, ops.item);
       //     }
       // });

    };

    var iconFor = P.iconFor = function (item) {
        return item.icon || '/images/icons/folder.gif';
    };
    
    return ItemDrawer;
})(Pip, jQuery);

