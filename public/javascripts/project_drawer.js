/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
 
 /*
 
    Draws the tree/side pane view for the project, NOT the entire canvas
    
    ABANDONED - converted to and modified in tree_drawer.coffee
    */
    

var Pip = Pip || {};

(function(P) {
    var ProjectDrawer = {};

    // Draws the side pane tree for the project
    // Called in application.js
    // Uses recursiveDrawSidePaneItem() & jquery - this sets up the ul, etc.
    // Params: project - the project to draw for; divName - the name of the div wherein to draw
    ProjectDrawer.drawSidePaneTree = function (project, divName) {
      if (! (project instanceof P.Model.Project))
        throw "Can't draw something that isn't a Project";

      // assume the place to draw
      var pane = document.getElementById(divName);
      if (!pane) return;

      var ul = document.createElement('ul');
      pane.appendChild(ul);
      
      recursiveDrawSidePaneItem(project, ul);

      $(ul).simpleTreeMenu(); // jquery function

    };

    var recursiveDrawSidePaneItem = function (item, container) {
        var li = document.createElement('li');

        li.setAttribute("id", item.type+"_"+item.id);
        // .setAttribute("type", "hidden");                     
        // .setAttribute("value", 'ID');
        // .setAttribute("class", "ListItem");
        
        
        var span = document.createElement('span');

        var icon = document.createElement('img');
        icon.src = P.iconFor(item);
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
            item[type].forEach(function (subItem) { recursiveDrawSidePaneItem(subItem, ul); });
        });
        li.appendChild(ul);

        container.appendChild(li);
    };

    // The following 2 methods mimick the 2 above, but just have slight changes
    
    // Draws the dependency creation tree for documents/show views
    // Called in application.js
    // Uses recursiveDrawSidePaneItem() & jquery - this sets up the ul, etc.
    // Params: project - the project to draw for; divName - the name of the div wherein to draw
    ProjectDrawer.drawDepCreationTree = function (project, divName) {
        if (! (project instanceof P.Model.Project))
            throw "Can't draw something that isn't a Project";

        // assume the place to draw
        // $(".#{divName}")
        var pane = document.getElementById(divName); // CHANGE TO CLASS
        if (!pane) return;

        var ul = document.createElement('ul');
        pane.appendChild(ul);

        recursiveDrawDepCreationItem(project, ul);

        $(ul).simpleTreeMenu(); // jquery function
    };
    
    var recursiveDrawDepCreationItem = function (item, container) {
        var li = document.createElement('li');
    
        li.setAttribute("id", item.type+"_"+item.id);
        // .setAttribute("type", "hidden");                     
        // .setAttribute("value", 'ID');
        // .setAttribute("class", "ListItem");
        
        
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
            span.addEventListener('dblclick', function() {
                alert("create dep with Document");
            }, false);
    
        if (item instanceof P.Model.Folder)
            span.addEventListener('dblclick', function() { 
                alert("create dep with Folder");
            }, false);
        
        if (item instanceof P.Model.Task)
            span.addEventListener('dblclick', function() { 
                // location = P.taskPath(item);
                alert("do something with clicking on a task")
            }, false);
    
        var ul = document.createElement('ul')
        P.COLLECTION_TYPES.forEach(function (type) {
          if (item[type])
            item[type].forEach(function (subItem) { recursiveDrawDepCreationItem(subItem, ul); });
        });
        li.appendChild(ul);
    
        container.appendChild(li);
    };


    P.ProjectDrawer = ProjectDrawer;
})(Pip);

