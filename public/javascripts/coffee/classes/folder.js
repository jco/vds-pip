/* DO NOT MODIFY. This file was compiled Wed, 06 Jun 2012 17:58:59 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/folder.coffee
 */

(function() {
  var Folder;

  jQuery(function() {});

  Folder = (function() {
    var helper, _updateDBCoords;

    helper = new Helper;

    function Folder(name) {
      var div, enddiv, handle, img, label;
      this.name = name;
      this.id = helper.getRandomNumber();
      div = "<div id=folder_" + this.id + " style='" + (this.getStyleAttributes()) + "'>";
      img = "<img id='folder_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/folder.gif' />";
      label = "<span id=folder_label_" + this.id + ">" + this.name + "</span>";
      handle = "<img id=folder_handle_" + this.id + " src='" + IMAGE_PATH + "/icons/circle0.png' width='15' height='15'/>";
      enddiv = "</div>";
      this.tag = div + handle + img + label + enddiv;
      $("#container").append(this.tag);
      this.x = 0;
      this.y = 0;
      this.setCoordinates(this.x, this.y);
      this._makeDraggable();
      this._makeHandleDraggable();
    }

    Folder.prototype.getStyleAttributes = function() {
      return 'position: relative;';
    };

    Folder.prototype.get = function() {
      return "#folder_" + this.id;
    };

    Folder.prototype.getImage = function() {
      return "#folder_icon_" + this.id;
    };

    Folder.prototype.getHandle = function() {
      return "#folder_handle_" + this.id;
    };

    Folder.prototype.setCoordinates = function(x, y) {
      this.x = x;
      this.y = y;
      $(this.get()).css('left', "" + this.x + "px");
      return $(this.get()).css('top', "" + this.y + "px");
    };

    Folder.prototype._makeHandleDraggable = function() {
      return $(this.getHandle()).draggable({
        containment: "#container",
        handle: this.getHandle(),
        helper: "clone",
        revert: true
      });
    };

    Folder.prototype._makeDraggable = function() {
      return $(this.get()).draggable({
        containment: "#container",
        handle: this.getImage(),
        stop: function() {
          return _updateDBCoords();
        }
      });
    };

    _updateDBCoords = function() {};

    return Folder;

  })();

  window.Folder = Folder;

}).call(this);
