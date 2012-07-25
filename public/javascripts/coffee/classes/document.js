/* DO NOT MODIFY. This file was compiled Wed, 25 Jul 2012 14:56:19 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/classes/document.coffee
 */

(function() {
  var Document;

  jQuery(function() {});

  Document = (function() {
    var helper;

    helper = new Helper;

    function Document(name) {
      var div, enddiv, img, label;
      this.name = name;
      this.id = helper.getRandomNumber();
      div = "<div id=document_" + this.id + " style='" + (this.getStyleAttributes()) + "'>";
      img = "<img id='document_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/document.png' width='25' height='25' />";
      label = "<span id=document_label_" + this.id + ">" + this.name + "</span>";
      enddiv = "</div>";
      this.tag = div + img + label + enddiv;
      $("#container").append(this.tag);
      this.x = 0;
      this.y = 0;
      this.setCoordinates(this.x, this.y);
      this._makeDraggable();
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

    Document.prototype.setCoordinates = function(x, y) {
      this.x = x;
      this.y = y;
      $(this.get()).css('left', "" + this.x + "px");
      $(this.get()).css('top', "" + this.y + "px");
      return $(this.getLabel()).html("" + this.name + " | (" + this.x + "," + this.y + ")");
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

    return Document;

  })();

  window.Document = Document;

}).call(this);
