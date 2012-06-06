/* DO NOT MODIFY. This file was compiled Wed, 06 Jun 2012 17:22:33 GMT from
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
      div = "<div id=document_" + this.id + ">";
      img = "<img id='document_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/document.png' style='' />";
      label = "<span id=document_label_" + this.id + ">" + this.name + "</span>";
      enddiv = "</div>";
      this.tag = div + img + label + enddiv;
      $("#container").append(this.tag);
      this.x = 0;
      this.y = 0;
      this.setCoordinates(this.x, this.y);
    }

    Document.prototype.getStyleAttributes = function() {
      return 'position: relative;';
    };

    Document.prototype.get = function() {
      return "#document_" + this.id;
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

    return Document;

  })();

  window.Document = Document;

}).call(this);
