/* DO NOT MODIFY. This file was compiled Tue, 05 Jun 2012 18:43:43 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/folder.coffee
 */

(function() {
  var Folder;

  jQuery(function() {});

  Folder = (function() {
    var helper;

    helper = new Helper;

    function Folder(name) {
      var div, enddiv, img, label;
      this.name = name;
      this.id = helper.getRandomNumber();
      div = "<div id=folder_" + this.id + ">";
      img = "<img id='folder_icon_" + this.id + "' src='" + IMAGE_PATH + "/icons/folder.gif' style='' />";
      label = "<span id=folder_label_" + this.id + ">" + this.name + "</span>";
      enddiv = "</div>";
      this.tag = div + img + label + enddiv;
      $("#container").append(this.tag);
    }

    return Folder;

  })();

  window.Folder = Folder;

}).call(this);
