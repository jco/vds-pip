var Pip = Pip || {};

(function(P, $) {
    var Application = {};
    
    Application.init = function() {
        // somehow determine whether we should be drawing a canvas
        if (P.data) {
          // build a lookup table
          if (P.data.project) {
            P.project = new P.Model.Project(P.data.project);
            P.index = {};
            buildIndex(P.project, P.index);
          }

          // set up the container
          if (P.data.containerId) {
            P.container = document.getElementById(P.data.containerId);
            P.paper = Raphael(P.container ,'100%','500px');//http://jsfiddle.net/6x4bR/
            P.container.addEventListener('dblclick', documentCreationHandler, false);
          }

          // draw items in this folder
          if (P.data.this_folder) {
            P.thisFolder = P.index[P.data.this_folder];
            drawItemsFor(P.thisFolder);
          } else if (P.data.this_task) {
            P.thisTask = P.index[P.data.this_task];
            drawItemsFor(P.thisTask);
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

      // documents can be created under either a folder or a task directly
      var href;
      if (P.thisFolder)
        href = P.newFolderDocumentPath(P.thisFolder);
      else if (P.thisTask)
        href = P.newTaskDocumentPath(P.thisTask);
      else
        throw "No references to the parent, can't create document without any";

      $.colorbox({
        href: href,
        iframe: true,
        width: 500,
        height: 500
      });
    };


    // container is anything with collections
    var buildIndex = function(container, index) {
      P.COLLECTION_TYPES_SINGULAR.forEach(function (kind) {
        var plural_kind = P.plural(kind);
        if (container[plural_kind]) {
          container[plural_kind].forEach(function (item) {
            index[P.domId(item)] = item;
            // recursive for any collections
            buildIndex(item, index);
          });
        }
      });
    };

    P.Application = Application;
})(Pip, jQuery);


        
        // this should be removed in production
function startXray() {
function loadScript(scriptURL) { var scriptElem = document.createElement('SCRIPT'); scriptElem.setAttribute('language', 'JavaScript'); scriptElem.setAttribute('src', scriptURL); document.body.appendChild(scriptElem);}loadScript('http://westciv.com/xray/thexray.js')
}

var but = document.createElement('button')
but.innerHTML = "xray";
but.onclick = startXray;
document.body.appendChild(but);
