/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

(function(P) {
    var DependencyDrawer = P.DependencyDrawer = {};
        
    // does not fetch new deps from server
    var redrawDependencies = DependencyDrawer.redrawDependencies = function () {
        P.ArrowDrawer.clearArrows('global');
        P.data.dependencies.forEach(drawDependency);
    };

    DependencyDrawer.createDependency = function (upstream_item, downstream_item) {
      console.log('create dep from ', upstream_item, 'to', downstream_item);
      $.ajax({
        type: 'POST',
        url: '/dependencies',
        data: {
          "dependency": {
            "upstream_item_id": upstream_item.id,
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
    };

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

    var drawDependency = function(dep) {
      var upstreamItem = P.index[dep[0]];
      var downstreamItem = P.index[dep[1]];
      P.ArrowDrawer.addArrows('global', [[arrowEndpoint(upstreamItem), arrowEndpoint(downstreamItem)]]);
    };
    
    var arrowEndpoint = function(item) {
      return [ item.coords[0] + 17, item.coords[1] + 17 ];
    };

})(Pip);

