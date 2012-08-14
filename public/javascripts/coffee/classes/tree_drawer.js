/* DO NOT MODIFY. This file was compiled Tue, 14 Aug 2012 14:23:32 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/tree_drawer.coffee
 */

(function() {
  var TreeDrawer;

  jQuery(function() {});

  TreeDrawer = (function() {
    var P, _recursiveDrawSidePaneItem;

    P = null;

    function TreeDrawer(P_variable) {
      P = P_variable;
    }

    TreeDrawer.prototype.drawSidePaneTree = function(project, divName) {
      var pane, ul;
      if (!(project instanceof P.Model.Project)) {
        throw "Can't draw something that isn't a Project";
      }
      pane = document.getElementById(divName);
      if (!pane) {
        return;
      }
      ul = document.createElement("ul");
      pane.appendChild(ul);
      _recursiveDrawSidePaneItem(project, ul);
      $(ul).simpleTreeMenu();
      return $(".draggable_part").draggable({
        helper: "clone",
        revert: true
      });
    };

    _recursiveDrawSidePaneItem = function(item, container) {
      var handle_html, handle_id, icon, li, name, span, ul;
      li = document.createElement("li");
      span = document.createElement("span");
      icon = document.createElement("img");
      icon.src = P.iconFor(item);
      icon.width = icon.height = P.SMALL_ICON_SIZE;
      span.appendChild(icon);
      if (item.type === 'document') {
        handle_id = "" + item.type + "_handle_blank_" + item.id;
        handle_html = document.createElement("img");
        handle_html.setAttribute("id", handle_id);
        handle_html.setAttribute("class", 'draggable_part');
        handle_html.setAttribute("src", "" + IMAGE_PATH + "/icons/circle0.png");
        handle_html.setAttribute("width", '15');
        handle_html.setAttribute("height", '15');
        span.appendChild(handle_html);
      }
      name = document.createTextNode(item.name);
      span.appendChild(name);
      li.appendChild(span);
      if (item instanceof P.Model.Document) {
        span.addEventListener("dblclick", P.ItemDrawer.documentOverlay(item), false);
      }
      if (item instanceof P.Model.Project) {
        span.addEventListener("dblclick", (function() {
          return location = P.projectPath(item);
        }), false);
      }
      if (item instanceof P.Model.Folder) {
        span.addEventListener("dblclick", (function() {
          return location = P.folderPath(item);
        }), false);
      }
      if (item instanceof P.Model.Task) {
        span.addEventListener("dblclick", (function() {
          return location = P.taskPath(item);
        }), false);
      }
      ul = document.createElement("ul");
      P.COLLECTION_TYPES.forEach(function(type) {
        if (item[type]) {
          return item[type].forEach(function(subItem) {
            return _recursiveDrawSidePaneItem(subItem, ul);
          });
        }
      });
      li.appendChild(ul);
      return container.appendChild(li);
    };

    return TreeDrawer;

  })();

  window.TreeDrawer = TreeDrawer;

}).call(this);
