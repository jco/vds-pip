var Pip = Pip || {};

/**
 * Assumptions made:
 *
 * - any element that should be edited in place has an attribute of the form
 *
 *     data-in-place-edit="fieldname"
 *
 *   where fieldname is similar to the [name] attribute in a rails generated
 *   <input> element.
 */
(function(P) {
    var InPlace = {};

    InPlace.init = function () {
      // find all elements that have data-in-place-edit
      var editables = document.querySelectorAll("[data-in-place-edit]");
      // process each
      _.each(editables, process);
    };

    var process = function (element) {
      // assume element has text
      element.contentEditable = true;
      element.addEventListener('blur', submitChange, false);

    };

    var submitChange = function (ev) {
      console.log('changing ' + this.getAttribute('data-in-place-edit') + ' to ' + this.innerHTML);
      $.ajax({
        type: 'PUT',
        url: desiredUrl(this),
        data: toData(this),
        complete: function () { console.log('complete') }
      });

    };

    // given an element, find the desired url.
    // Search upwards until you find a parent that specifies the id.
    var desiredUrl = function (element) {
      var parentSelector = '.' + resourceType(element);
      var id = P.inverseDomId($(element).parents(parentSelector).attr('id'));
      return '/' + P.plural(resourceType(element)) + '/' + id.toString();
    };

    var toData = function (element) {
      // e.g. given <element data-i-p-e="document[name]">New contents...</element>,
      // generate {"document[name]": "New contents..."}
      var data = {};
      data[element.getAttribute('data-in-place-edit')] = element.innerHTML;
      return data;
    };

    var resourceType = function (element) {
      return element.getAttribute('data-in-place-edit').split('[')[0];
    };

    P.InPlace = InPlace;
})(Pip);
