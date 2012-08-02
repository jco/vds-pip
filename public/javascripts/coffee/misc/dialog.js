/* DO NOT MODIFY. This file was compiled Wed, 01 Aug 2012 17:08:48 GMT from
 * /Users/daze/Documents/Workspace/Rails/vds-pip/app/coffeescripts/coffee/misc/dialog.coffee
 */

(function() {

  jQuery(function() {
    var from_dialog;
    from_dialog = $("#from_dialog");
    $("#from_button").click(function() {
      return from_dialog.dialog('open');
    });
    from_dialog.dialog({
      autoOpen: false,
      title: "Create 'from' dependency",
      width: 600,
      height: 400,
      modal: true
    });
    $("#me").click(function() {
      return $("#dialog").dialog('open');
    });
    return $("#dialog").dialog({
      autoOpen: false
    });
  });

}).call(this);
