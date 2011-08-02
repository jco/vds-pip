var Pip = Pip || {};
(function (P) {

  // The inverse function of rails's dom_id(model_instance).
  // For instance, given 'document_4', returns 4.
  P.inverseDomId = function (str) {
    // assume a correctly formatted string
    return Number(str.split('_')[1]);
  };

  P.plural = function (str) {
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

  P.resourcePath = function (resource, kind) {
    return '/' + P.plural(kind) + '/' + resource.id.toString();
  };

  // mimic rails routing helpers

  var kinds = ['folder', 'document', ['folder', 'document']];
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
