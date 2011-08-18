var Pip = Pip || {};

(function(P) {
    var ProjectDrawer = {};

    // Draws a tree/pane type view for the project
    ProjectDrawer.drawProject = function (project) {
      if (! (project instanceof P.Model.Project))
        throw "Can't draw something that isn't a Project";

      // assume the place to draw
      var pane = document.getElementById('pane');
      if (!pane) return;

      var ul = document.createElement('ul');
      pane.appendChild(ul);
      
      recursiveDrawItem(project, ul);

      $(ul).simpleTreeMenu();

    };

    var recursiveDrawItem = function (item, container) {
        var li = document.createElement('li');

        var span = document.createElement('span');

        var icon = document.createElement('img');
        icon.src = P.iconFor(item); //TODO:
        icon.width = icon.height = P.SMALL_ICON_SIZE;
        span.appendChild(icon);

        var name = document.createTextNode(item.name);
        span.appendChild(name);

        li.appendChild(span);

        // following the link does what, if not burrowing deeper?
        if (item instanceof P.Model.Document)
          span.addEventListener('dblclick', P.ItemDrawer.documentOverlay(item), false);

        if (item instanceof P.Model.Folder)
          span.addEventListener('dblclick', function() { location = P.folderPath(item); }, false);

        if (item instanceof P.Model.Task)
          span.addEventListener('dblclick', function() { location = P.taskPath(item); }, false);

        var ul = document.createElement('ul')
        P.COLLECTION_TYPES.forEach(function (type) {
          if (item[type])
            item[type].forEach(function (subItem) { recursiveDrawItem(subItem, ul); });
        });
        li.appendChild(ul);

        container.appendChild(li);
    };


    P.ProjectDrawer = ProjectDrawer;
})(Pip);

