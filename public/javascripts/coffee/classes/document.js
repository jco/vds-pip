/* DO NOT MODIFY. This file was compiled Thu, 07 Jun 2012 16:26:21 GMT from
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
      return 'display: inline-block';
    };

    Document.prototype.get = function() {
      return "#document_" + this.id;
    };

    Document.prototype.getImage = function() {
      return "#document_icon_" + this.id;
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

    return Document;

  })();

  window.Document = Document;

}).call(this);
