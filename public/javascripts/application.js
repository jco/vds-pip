/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

(function(P, $, slang, key) {
    var Application = {};
    
    Application.init = function() {

        // Add the string methods from the "slang" library directly to all string objects.
        slang.addToPrototype();

        // Setup for the routes module.
        var resources = [
          'task',
          'folder',
          'document',
          ['task', 'document'],
          ['folder', 'document'],
          ['project', 'document']
        ];
        generateHelpers(resources, P);

        // Register xray as a keyboard event
        function startXray() {
          function loadScript(scriptURL) { var scriptElem = document.createElement('SCRIPT'); scriptElem.setAttribute('language', 'JavaScript'); scriptElem.setAttribute('src', scriptURL); document.body.appendChild(scriptElem);}loadScript('http://westciv.com/xray/thexray.js')
        };
        key('ctrl+x', startXray);

        // somehow determine whether we should be drawing a canvas
        if (P.data) {
          // build a lookup table
          if (P.data.project) {
            P.project = new P.Model.Project(P.data.project);
            P.index = {};
            P.Indexer.buildIndex(P.project, P.index);
            P.ProjectDrawer.drawProject(P.project);
          }

          // set up the container
          if (P.data.containerId) {
            P.container = document.getElementById(P.data.containerId);
            P.paper = Raphael(P.container, '100%', '500px');//http://jsfiddle.net/6x4bR/
            P.container.addEventListener('dblclick', documentCreationHandler, false);
          }

          // draw items in this folder
          if (P.data.this_folder) {
            P.thisFolder = P.index[P.data.this_folder];
            drawItemsFor(P.thisFolder);
          } else {
            drawItemsFor(P.project);
          } // don't do anything for a project

          // draw dependencies
          if (P.data.dependencies)
            P.DependencyDrawer.redrawDependencies();
        }
    };

    var drawItemsFor = function (container) {
      container.folders.concat(container.documents).forEach(P.ItemDrawer.drawItem);
    };

    var documentCreationHandler = function (ev) {
      // filter for acceptable targets
      // (imo this should just be svg, but the qtwebkit is firing events on the div instead)
      if (ev.target != document.getElementsByTagName('svg')[0] &&
          ev.target != P.container)
        return;

      // documents can be created under either a folder or a project directly
      var href;
      if (P.thisFolder)
        href = P.newFolderDocumentPath(P.thisFolder);
      else if (P.project)
        href = P.newProjectDocumentPath(P.project);
      else
        throw "No references to the parent, can't create document without any";

      $.colorbox({
        href: href,
        iframe: true,
        width: 500,
        height: 500
      });
    };

    P.Application = Application;
})(Pip, jQuery, slang, key);
