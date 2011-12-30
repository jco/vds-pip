/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
var Pip = Pip || {};
(function (P) {

  P.error = function() {
    if (P.DEVELOPMENT) {
      console.log(arguments);
      throw "look";
    }
    else
      alert('Error');
  };

  P.inspect = function (obj) {
    if (_.isObject(obj))
      return "{" + _.map(obj, function (v, k) {
        return P.inspect(k) + ": " + P.inspect(v);
      }).join(", ") + "}";
    else
      return '"' + String(obj) + '"';
  };

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

  // mimic rails routing helpers

  var kinds = [
    'task',
    'folder',
    'document',
    ['task', 'document'],
    ['folder', 'document']
  ];
  var helperName;

  var refactoredSimpleResource = function (kind) {
    // index (plural)
    helperName = P.plural(kind) + 'Path';
    P[helperName] = function () { return '/' + P.plural(kind); };

    // show (singular)
    helperName = kind + 'Path';
    P[helperName] = function (resource) { return '/' + P.plural(kind) + '/' + resource.id.toString(); };

    // new
    helperName = 'new' + P.capitalize(kind) + 'Path';
    P[helperName] = function () { return '/' + P.plural(kind) + '/new'; };

    // edit
    helperName = P.camelCase(['edit', kind, 'path']);
    P[helperName] = function (resource) { return P.path([P.plural(kind), resource.id.toString(), 'edit']); };
  };

  var refactoredNestedResource = function (kind) {
    // assume the simple resource for par has already been defined
    var par = kind[0], child = kind[1];

    var prefix = function (parResource) { return P.path([P.plural(par), parResource.id, P.plural(child)]); };

    // index (plural)
    helperName = P.camelCase([par, P.plural(child), 'Path']);
    P[helperName] = function (parResource) { return prefix(parResource); };

    // show (singular)
    helperName = P.camelCase([par, child, 'path']);
    P[helperName] = function (parResource, childResource) { return P.path([prefix(parResource), childResource.id]); };

    // new
    helperName = P.camelCase(['new', par, child, 'path']);
    P[helperName] = function (parResource) { return P.path([prefix(parResource), 'new']); };

    // edit
    helperName = P.camelCase(['edit', par, child, 'path']);
    P[helperName] = function (parResource, childResource) { return P.path([prefix(parResource), childResource.id, 'edit']); };
  };

  P.path = function (parts) {
    var strParts = _(parts).map(String);
    return '/' + _(strParts).map(deleteLeadingSlash).join('/');
  };

  var deleteLeadingSlash = function (str) {
    return (str.charAt(0) == '/') ? str.slice(1) : str;
  };

  kinds.forEach(function (kind) {
    if (_.isArray(kind))
      refactoredNestedResource(kind);
    else
      refactoredSimpleResource(kind);
  });

})(Pip);
