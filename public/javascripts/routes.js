/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */

/* sample usage:

var resources = [
  'task',
  'folder',
  'document',
  ['task', 'document'],
  ['folder', 'document']
];

var routesHelper = generateHelpers(resources);

var url = routesHelper.folderDocumentPath({name: "folder 1", id: 1}, {name: "document 6", id: 6});
// => /folders/1/documents/6

*/

(function (_) {
  var module = {};

  var simpleResource = module.simpleResource = function (resource) {
    var resources = plural(resource);

    // index
    this[camel(resources, 'path')] = function () { return path(resources); };

    // show
    this[camel(resource, 'path')] = function (inst) { return path(resources, inst.id); };

    // new
    this[camel('new', resource, 'path')] = function () { return path(resources, 'new'); };

    // edit
    this[camel('edit', resource, 'path')] = function (inst) { return path(resources, inst.id, 'edit'); };
  };

  var nestedResource = module.nestedResource = function (resource) {
    var parent = resource[0], child = resource[1];
    var parents = plural(parent), children = plural(child);

    var pathBase = function (parentInst) { return [parents, parentInst.id, children]; };

    // index
    this[camel(parent, children, 'path')] = function (parentInst) { return path(pathBase(parentInst)); };

    // show
    this[camel(parent, child, 'path')] = function (parentInst, childInst) { return path(pathBase(parentInst), childInst.id); };

    // new
    this[camel('new', parent, child, 'path')] = function (parentInst) { return path(pathBase(parentInst), 'new'); };

    // edit
    this[camel('edit', parent, child, 'path')] = function (parentInst, childInst) { return path(pathBase(parentInst), childInst.id, 'edit'); };
  };

  var flatten = module.flatten = function (array) {
    array.reduce(function (memo, value) {
      if (Array.isArray(value))
        return memo.concat(flatten(value));
      else
        return memo.concat(value);
    }, []);
  };

  var camel = module.camel = function (strs) {
    if (arguments.length > 1)
      strs = Array.prototype.slice.call(arguments);
    return strs.slice(0,1).concat(
      strs.slice(1).map(capitalize));
  };

  var capitalize = module.capitalize = function (str) {
    return [str.charAt(0).toUpperCase()].concat(str.slice(1));
  };

  var plural = module.plural = function (str) {
    if (!_.isString(str))
      throw "Tried to pluralize something that wasn't a string (" + String(str) + ")";
    return str + 's';
  };

  var path = module.path = function (parts) {
    if (arguments.length > 1)
      parts = Array.prototype.slice.call(arguments); // https://developer.mozilla.org/en/JavaScript/Reference/functions_and_function_scope/arguments
    parts = flatten(parts);
    var strParts = parts.map(String);
    return '/' + strParts.map(deleteLeadingSlash).join('/');
  };

  var deleteLeadingSlash = module.deleteLeadingSlash = function (str) {
    return (str.charAt(0) == '/') ? str.slice(1) : str;
  };

  var generateHelpers = module.generateHelpers = function (resources) {
    var helperObj = {};
    resources.forEach(function (resource) {
      if (_.isArray(resource))
        nestedResource.call(helperObj, resource);
      else
        simpleResource.call(helperObj, resource);
    });
  };

  //export
  if (window.generateHelpers)
    console.log("window.generateHelpers name conflict, replacing anyway!");
  window.generateHelpers = generateHelpers;

})(_);
