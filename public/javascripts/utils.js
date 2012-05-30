/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};
(function (P) {

  // You can pass this function as the callback of a JSON call, and depending
  // on whether we are in "development mode" (defined in constants.js), this will give
  // helpful error info or simply a warning.
  P.error = function() {
    if (P.DEVELOPMENT) {
      console.log(arguments);
      throw "look";
    }
    else
      alert('Error');
  };

  // JS version of ruby's inspect(), useful for visualizing objects and such
  P.inspect = function (obj) {
    if (_.isObject(obj))
      return "{" + _.map(obj, function (v, k) {
        return P.inspect(k) + ": " + P.inspect(v);
      }).join(", ") + "}";
    else
      return '"' + String(obj) + '"';
  };

  // Convert from an object to a string representing that object
  P.domId = function (item, kind) {
    if (item instanceof P.Model.Base)
      var kind = item.type;
    if (!_.isNumber(item.id))
      throw "Item " + P.inspect(item) + " doesn't have a valid id.";
    return [kind, item.id].join('_');
  }

  // The inverse function of rails's dom_id(model_instance).
  // For instance, given 'document_4', returns 4.
  P.inverseDomId = function (str) {
    // assume a correctly formatted string
    return Number(str.split('_')[1]);
  };

  P.plural = function (str) {
    if (!_.isString(str))
      throw "Tried to pluralize something that wasn't a string (" + String(str) + ")";
    return str + 's';
  }

  P.capitalize = function (str) {
    return [str.charAt(0).toUpperCase(), str.slice(1)].join('');
  };

  P.camelCase = function (strs) {
    return _(strs).map(function (el, i) {
      return (i != 0) ? P.capitalize(el) : el;
    }).join('');
  };

  // like rails, but returns a DOM node instead of an html string
  P.linkTo = function (text, url) {
    var link = document.createElement('a');
    link.href = url;
    link.appendChild(document.createTextNode(text));
    return link;
  };

  P.testEvent = function (ev) {
    console.log('The event fired: ', ev);
  };

})(Pip);
