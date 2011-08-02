var Pip = Pip || {};

(function(P, $) {
    var BigMess = {};
    
    BigMess.init = function() {
        // somehow determine whether we should be drawing a canvas
        if (P.data) {
          // build a lookup table for folders and documents
          if (P.data.project) {
            P.index = {};
            buildIndex(P.data.project, P.index);
          }

          // set up the container
          if (P.data.containerId) {
            P.container = document.getElementById(P.data.containerId);
            P.paper = Raphael(P.container ,'100%','100%');//http://jsfiddle.net/6x4bR/
            P.container.addEventListener('dblclick', documentCreationHandler, false);
          }

          // draw items in this folder
          if (P.data.this_folder) {
            P.thisFolder = P.index[P.data.this_folder]
            P.thisFolder.folders.concat(P.thisFolder.documents).forEach(P.ItemDrawer.drawItem);
          }

          // draw dependencies
          if (P.data.dependencies)
            P.DependencyDrawer.redrawDependencies();
        }
    };

    var documentCreationHandler = function (ev) {
      // filter for acceptable targets
      // (imo this should just be svg, but the qtwebkit is firing events on the div instead)
      if (ev.target != document.getElementsByTagName('svg')[0] &&
          ev.target != P.container)
        return;

      $.colorbox({
        href: P.newFolderDocumentPath(P.thisFolder),
        iframe: true,
        width: 500,
        height: 500
      });
    };


    // container is a folder or a project: something that has an array of docs and folders
    var buildIndex = function(container, index) {
        container.folders.forEach(function(folder){
            index['folder_' + folder.id] = folder;
            buildIndex(folder, index);
        });
        container.documents.forEach(function(doc) {
            index['document_' + doc.id] = doc;
        });
    };

    P.BigMess = BigMess;
})(Pip, jQuery);


        
        // this should be removed in production
function startXray() {
function loadScript(scriptURL) { var scriptElem = document.createElement('SCRIPT'); scriptElem.setAttribute('language', 'JavaScript'); scriptElem.setAttribute('src', scriptURL); document.body.appendChild(scriptElem);}loadScript('http://westciv.com/xray/thexray.js')
}

var but = document.createElement('button')
but.innerHTML = "xray";
but.onclick = startXray;
document.body.appendChild(but);
