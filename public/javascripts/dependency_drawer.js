/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
 
/*
  Module responsible for both creating the actual dependencies on the server, and for
  calling the methods of the ArrowDrawer module to represent these dependencies for the user.

*/
var Pip = Pip || {};

(function(P) {
    var DependencyDrawer = P.DependencyDrawer = {};
        
    // Redraws (or draws for the first time) all the dependencies as arrows. Redrawing is necessary
    // after the coordinates of an item change, so that an arrow is not left pointing to nothing.
    // This method DOES NOT get an updated list of dependencies from the server; it does not talk to
    // the server at all. It just uses the initial list provided by P.data.
    var redrawDependencies = DependencyDrawer.redrawDependencies = function () {
        P.ArrowDrawer.clearArrows('global');
        P.data.dependencies.forEach(drawDependency);
    };

    // Creates a new dependency between two object references to items. This both updates
    // the server via an ajax call, and draws the new arrow locally. maybe 3rd argument for PATH, default null and just within folder
    DependencyDrawer.createDependency = function (upstream_item, downstream_item) { // upstream=from, downstream=to
      console.log('create dep from ', upstream_item, 'to', downstream_item);
      $.ajax({
        type: 'POST',
        url: '/dependencies',
        data: {
          "dependency": {
            "upstream_item_id": upstream_item.id, // what is id? does this differentiate b/w folder and document id.. 
            "upstream_item_type": upstream_item.type.capitalize(),
            "downstream_item_id": downstream_item.id,
            "downstream_item_type": downstream_item.type.capitalize()
          }
        },
        complete: function () {
          console.log('server responded');
          // preemptively draw arrow
          P.data.dependencies.push([P.domId(upstream_item), P.domId(downstream_item)]);
          redrawDependencies();
          // actually query for newly created dependencies
          //reloadDependencies();
        }
      });
      alert("Dependency created");
    };

    // Ask the server for an up-to-date list of dependencies that are contained within this folder.
    // This method apparently assumes we can't be in project; we must be in a folder.
    var reloadDependencies = function() {
      $.ajax({
        type: 'GET',
        url: '/folders/' + P.thisFolder.id + '/dependencies',
        success: function(data, textStatus, jqXHR) {
          console.log('fetched new dependency data');
          // data should be a new array of deps
          P.data.dependencies = data;
          DependencyDrawer.redrawDependencies();
        }
      });
    };

    // Draw a dependency as an arrow on the canvas. _dep_ looks like ["document-4", "document-111"]
    var drawDependency = function(dep) {
        var upstreamItem = P.index[dep[0]];
        var downstreamItem = P.index[dep[1]];
        // only draw items for items immediately within that project or folder
        if (bothItemsExistInCurrentContainer(upstreamItem, downstreamItem))
            P.ArrowDrawer.addArrows('global', [[arrowEndpoint(upstreamItem), arrowEndpoint(downstreamItem)]]);
        
    };
    
    var bothItemsExistInCurrentContainer = function(upstreamItem, downstreamItem) {
        // The _ allows easy include? testing. http://documentcloud.github.com/underscore/#include
        var upstreamItemIncluded = _.include(P.current_container.folders, upstreamItem) || _.include(P.current_container.documents, upstreamItem)
        var downstreamItemIncluded = _.include(P.current_container.folders, downstreamItem) || _.include(P.current_container.documents, downstreamItem)
        return upstreamItemIncluded && downstreamItemIncluded
    };
    
    var arrowEndpoint = function(item) {
        // This parsing is needed when an item is dragged. For some reason, the coords become strings, but we want numbers.
        item.coords[0] = parseInt(item.coords[0])
        item.coords[1] = parseInt(item.coords[1])
        
        return [ item.coords[0] + 17, item.coords[1] + 17 ];
    };

})(Pip);

