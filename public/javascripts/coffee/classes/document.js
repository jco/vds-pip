/* DO NOT MODIFY. This file was compiled Fri, 27 Jul 2012 13:52:56 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/document.coffee
 */

(function() {
  var Document;

  jQuery(function() {});

  Document = (function() {
    var helper;

    helper = new Helper;

    function Document(name, document_id) {
      var div, enddiv, handle, img, label;
      this.name = name;
      this.document_id = document_id;
      this.id = helper.getRandomNumber();
      div = "<div id=document_" + this.id + " style='" + (this.getStyleAttributes()) + "'>";
      img = "<img id='document_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/document.png' width='25' height='25' />";
      label = "<span id=document_label_" + this.id + ">" + this.name + "</span>";
      handle = "<img id=document_handle_" + this.id + "_" + this.document_id + " src='" + IMAGE_PATH + "/icons/circle0.png' width='15' height='15' />";
      enddiv = "</div>";
      this.tag = div + handle + img + label + enddiv;
      $("#container").append(this.tag);
      this.x = 0;
      this.y = 0;
      this.setCoordinates(this.x, this.y);
      this._makeDraggable();
      this._makeHandleDraggable();
      this._makeDroppable();
    }

    Document.prototype.getStyleAttributes = function() {
      return 'display: inline-block; position: absolute;';
    };

    Document.prototype.get = function() {
      return "#document_" + this.id;
    };

    Document.prototype.getImage = function() {
      return "#document_icon_" + this.id;
    };

    Document.prototype.getLabel = function() {
      return "#document_label_" + this.id;
    };

    Document.prototype.getHandle = function() {
      return "#document_handle_" + this.id + "_" + this.document_id;
    };

    Document.prototype.setCoordinates = function(x, y) {
      this.x = x;
      this.y = y;
      $(this.get()).css('left', "" + this.x + "px");
      return $(this.get()).css('top', "" + this.y + "px");
    };

    Document.prototype.setBorderColor = function(color) {
      return $(this.get()).css('border', "1px solid " + color);
    };

    Document.prototype.updateCoordinates = function() {
      this.x = $(this.get()).css('left').replace('px', '');
      return this.y = $(this.get()).css('top').replace('px', '');
    };

    Document.prototype._makeDraggable = function() {
      return $(this.get()).draggable({
        containment: "#container",
        handle: this.get()
      });
    };

    Document.prototype._makeHandleDraggable = function() {
      return $(this.getHandle()).draggable({
        containment: "#container",
        handle: this.getHandle(),
        helper: "clone",
        revert: true
      });
    };

    Document.prototype._makeDroppable = function() {
      return $(this.get()).droppable({
        drop: function() {}
      });
    };

    return Document;

  })();

  window.Document = Document;

}).call(this);
