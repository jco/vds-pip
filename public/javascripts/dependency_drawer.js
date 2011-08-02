var Pip = Pip || {};

Pip.DependencyDrawer = (function() {
    var DependencyDrawer = {}
        
    var redrawDependencies = DependencyDrawer.redrawDependencies = function () {
        Pip.ArrowDrawer.clearArrows('global');
        Pip.data.dependencies.forEach(drawDependency);
    };

    DependencyDrawer.createDependency = function (upstream_document, downstream_document) {
      $.ajax({
        type: 'POST',
        url: '/dependencies',
        data: {"dependency": {"upstream_document_id": upstream_document.id, "downstream_document_id": downstream_document.id}},
        complete: function () {
          // pre emptively draw arrow
          Pip.data.dependencies.push(['document_' + upstream_document.id, 'document_' + downstream_document.id]);
          redrawDependencies();
          // actually query for newly created dependencies
          reloadDependencies();
        }
      });
    };

    var reloadDependencies = function() {
      $.ajax({
        type: 'GET',
        url: '/folders/' + Pip.thisFolder.id + '/dependencies',
        success: function(data, textStatus, jqXHR) {
          console.log('fetched new dependency data');
          // data should be a new array of deps
          Pip.data.dependencies = data;
          DependencyDrawer.redrawDependencies();
        }
      });
    };

    var drawDependency = function(dep) {
      var upstreamItem = Pip.index[dep[0]];
      var downstreamItem = Pip.index[dep[1]];
      Pip.ArrowDrawer.addArrows('global', [[arrowEndpoint(upstreamItem), arrowEndpoint(downstreamItem)]]);
    };
    
    var arrowEndpoint = function(item) {
      return [ item.coords[0] + 17, item.coords[1] + 17 ];
    };

    return DependencyDrawer;
})();

