/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};

/**

This module is responsible for making html elements into "edit-in-place" fields
that can submit their responses to the server immediately. Elements flag themselves
as wanting this capability by having the attribute "data-in-place-edit."


 * Assumptions made:
 *
 * - any element that should be edited in place has an attribute of the form
 *
 *     data-in-place-edit="fieldname"
 *
 *   where fieldname is similar to the [name] attribute in a rails generated
 *   <input> element.
 */
(function(P, $) {
    var InPlace = {};

    // Give in-place-editing capabilities to all elements that want it.
    InPlace.init = function () {
      // Find all elements that have data-in-place-edit
      var editables = document.querySelectorAll("[data-in-place-edit]");
      // Process each element.
      _.each(editables, process);
    };

    // "Process" just means to add an event listener...
    var process = function (element) {
      element.addEventListener('change', submitChange, false);
    };

    // ... this is the event listener.
    // Event handler registered on in-place-editing elements.
    var submitChange = function (ev) {
      var data = toData(this);
      console.log('submiting data ', data, '...');
      $.ajax({
        type: 'PUT',
        url: desiredUrl(this),
        data: data,
        dataType: 'json', // tells rails not to serve back html
        success: function () { console.log('...complete.') },
        error: P.error
      });

    };

    // given an element, find the desired url.
    // Search upwards until you find a parent that specifies the id.
    var desiredUrl = function (element) {
      var parentSelector = '.' + resourceType(element);
      var id = P.inverseDomId($(element).parents(parentSelector).attr('id'));
      return '/' + P.plural(resourceType(element)) + '/' + id.toString();
    };

    // e.g. given <element data-i-p-e="document[name]">New contents...</element>,
    // generate {"document[name]": "New contents..."}
    // OR the appropriate params object for a radio button
    //
    // The purpose of this function is to extract the data from the in-place element
    // and arrange it in JSON notation so we can send it to the server as form data.
    var toData = function (element) {
      var data = {};
      data[element.name] = element.value;
      return data;
    };

    var resourceType = function (element) {
      return element.name.split('[')[0];
    };

    P.InPlace = InPlace;
})(Pip, jQuery);
