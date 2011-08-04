var Pip = Pip || {};

(function(P) {
    var ProjectDrawer = {};

    ProjectDrawer.init = function () {
      this.drawProject();
    }

    // Draws a tree/pane type view for the project
    ProjectDrawer.drawProject = function () {
      // assume the place to draw
      var pane = document.getElementById('pane');
      if (!pane) return;

      var ul = document.createElement('ul');
      pane.appendChild(ul);
      
      P.data.project.folders.forEach(function (folder) {
        recursiveDrawItem(folder, ul);
      });

      $(ul).simpleTreeMenu();

    };

    var recursiveDrawItem = function (item, container) {
        var li = document.createElement('li');

        var span = document.createElement('span');

        var icon = document.createElement('img');
        icon.src = P.iconFor(item);
        icon.width = icon.height = P.SMALL_ICON_SIZE;
        span.appendChild(icon);

        var name = document.createTextNode(item.name);
        span.appendChild(name);

        li.appendChild(span);

        if (P.kind(item) == 'document') {
          // double-clicking opens the document
          span.addEventListener('click', P.ItemDrawer.documentOverlay(item), false);
        }

        if (item.folders && (item.folders.length > 0 || item.documents.length > 0)) {
          var ul = document.createElement('ul')
          item.folders.forEach(function (folder) { recursiveDrawItem(folder, ul) });
          item.documents.forEach(function (doc) { recursiveDrawItem(doc, ul) });
          li.appendChild(ul);
        }
        container.appendChild(li);
    };


    P.ProjectDrawer = ProjectDrawer;
})(Pip);

