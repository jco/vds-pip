/* DO NOT MODIFY. This file was compiled Tue, 14 Aug 2012 03:11:10 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/folder.coffee
 */

(function() {
  var Folder;

  jQuery(function() {});

  Folder = (function() {
    var helper;

    helper = new Helper;

    function Folder(name, folder_id) {
      var div, enddiv, handle, img, label;
      this.name = name;
      this.folder_id = folder_id;
      this.id = helper.getRandomNumber();
      div = "<div id=folder_" + this.id + " style='" + (this.getStyleAttributes()) + "'>";
      img = "<img id='folder_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/folder.gif' />";
      label = "<span id=folder_label_" + this.id + ">" + this.name + "</span>";
      handle = "<img id=folder_handle_" + this.id + "_" + this.folder_id + " src='" + IMAGE_PATH + "/icons/circle0.png' width='15' height='15' />";
      enddiv = "</div>";
      this.tag = div + img + label + enddiv;
      $("#container").append(this.tag);
      this.x = 0;
      this.y = 0;
      this.setCoordinates(this.x, this.y);
      this._makeDraggable();
      this._makeHandleDraggable();
      this._makeDroppable();
    }

    Folder.prototype.getStyleAttributes = function() {
      return 'display: inline-block; position: absolute;';
    };

    Folder.prototype.get = function() {
      return "#folder_" + this.id;
    };

    Folder.prototype.getImage = function() {
      return "#folder_icon_" + this.id;
    };

    Folder.prototype.getLabel = function() {
      return "#folder_label_" + this.id;
    };

    Folder.prototype.getHandle = function() {
      return "#folder_handle_" + this.id + "_" + this.folder_id;
    };

    Folder.prototype.setCoordinates = function(x, y) {
      this.x = x;
      this.y = y;
      $(this.get()).css('left', "" + this.x + "px");
      return $(this.get()).css('top', "" + this.y + "px");
    };

    Folder.prototype.updateCoordinates = function() {
      this.x = $(this.get()).css('left').replace('px', '');
      return this.y = $(this.get()).css('top').replace('px', '');
    };

    Folder.prototype._makeDraggable = function() {
      return $(this.get()).draggable({
        containment: "#container",
        handle: this.getImage()
      });
    };

    Folder.prototype._makeHandleDraggable = function() {
      return $(this.getHandle()).draggable({
        containment: "#container",
        handle: this.getHandle(),
        helper: "clone",
        revert: true
      });
    };

    Folder.prototype._makeDroppable = function() {
      return $(this.get()).droppable({
        drop: function() {}
      });
    };

    return Folder;

  })();

  window.Folder = Folder;

}).call(this);
