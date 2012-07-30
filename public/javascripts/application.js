/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
  
The module pattern is described in brief here alongside other possible module patterns. 
The way it works is by using a "closure" (https://developer.mozilla.org/en/JavaScript/Guide/Closures). 
Here's another good article: http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth.

 */

var Pip = Pip || {};

// P is a pattern in JS so everything is a property of 1 variable, so your variable is consistently separated from others
// slang, key are for 2 other libraries
(function(P, $, slang, key) {
    var Application = {};
    
    // This function is called when all the javascript files have been loaded, to make sure everything we
    // want to exist exists.
    Application.init = function() {
      
        // Add the string methods from the "slang" library directly to all string objects.
        slang.addToPrototype();

        // Setup for the routes module (see routes.js for what this module provides)
        var resources = [
          'task',
          'folder',
          'document',
          ['task', 'document'],
          ['folder', 'document'],
          ['project', 'document']
        ];
        generateHelpers(resources, P); // makes the helpers available under _P_

        // Register xray as a keyboard event
        function startXray() {
          function loadScript(scriptURL) { var scriptElem = document.createElement('SCRIPT'); scriptElem.setAttribute('language', 'JavaScript'); scriptElem.setAttribute('src', scriptURL); document.body.appendChild(scriptElem);}loadScript('http://westciv.com/xray/thexray.js')
        };
        key('ctrl+x', startXray);

        // P.data is raw json data provided by the server. It is used to describe what should be drawn
        // and what the data in the project is.
        //
        // P.data.asdf => asdf is set in a controller or view
        //
        // If it isn't defined, don't draw a canvas.
        if (P.data) {
          
          // Build a lookup table ("index"). This conveniently allows us to find
          // the object we want based on a string. For example, if we know we want a document
          // who's id is 6, but we don't have a reference to the actual object, we can do
          // P.index["document-6"] to get the reference.
          
          if (P.data.project) {
            P.project = new P.Model.Project(P.data.project);
            P.index = {};
            P.Indexer.buildIndex(P.project, P.index);
            P.ProjectDrawer.drawProject(P.project); // draws the side pane
          }

          // set up the container
          if (P.data.containerId) { // containerId is set in view files whenever there's a canvas
            
            // figure out which html element to make the container for the canvas
            P.container = document.getElementById(P.data.containerId);
            
            // Create the canvas
            P.paper = Raphael(P.container, '100%', '500px');//http://jsfiddle.net/6x4bR/
            $("svg").css('position','absolute');
            
            // GLOBAL VARIABLE!!!
            helper = new Helper(); // Defined in app/coffeescripts
            helper.setCanvas(P.paper);
            
            // Attach the listener for creating documents
            P.container.addEventListener('dblclick', documentCreationHandler, false);
          }

          // draw items in this folder
          if (P.data.this_folder) { // if we are in a folder
            P.thisFolder = P.index[P.data.this_folder]; // create an obj reference to this folder
            
            // side note: this_folder is a dom id (e.g. "folder-5")
            // whereas thisFolder is an actualy Model.Folder object
            
            // Draw the contents of the folder
            drawItemsFor(P.thisFolder);
            
          } else { // otherwise, we are just in the project itself
            drawItemsFor(P.project); // how does the project possess the folder
          } // don't do anything for a project

          // draw dependencies
          if (P.data.dependencies)
            P.DependencyDrawer.redrawDependencies(); // all reached for arrow-drawing...
        }
    };

    // Draw all the folders and documents of this container (container is a folder or project)
    var drawItemsFor = function (container) {
      container.folders.concat(container.documents).forEach(P.ItemDrawer.drawItem);
    };

    // This gets called on a dblclick. Responsible for making the "create document" overlay
    var documentCreationHandler = function (ev) {
      // filter for acceptable targets
      // (imo this should just be svg, but the qtwebkit is firing events on the div instead)
      
      if (ev.target != document.getElementsByTagName('svg')[0] &&
          ev.target != P.container)
        return;

      // documents can be created under either a folder or a project directly
      var href; // variable for what URL to load
      if (P.thisFolder)
        href = P.newFolderDocumentPath(P.thisFolder);
      else if (P.project)
        href = P.newProjectDocumentPath(P.project);
      else
        throw "No references to the parent, can't create document without any";

      $.colorbox({ // jQuery plugin that, here, creates an iframe (could be popup, overlay, etc.) in the current window
        href: href,
        iframe: true,
        width: 500,
        height: 500
      });
    };

    P.Application = Application;
})(Pip, jQuery, slang, key);

