/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
 
 /* The sole purpose of this module is to take a Project object, which has information
    about everything in it, and generate a lookup table or index
    
  */
  
var Pip = Pip || {};

Pip.Indexer = (function(P) {
    var Indexer = {};

    // container is any model with collections
    Indexer.buildIndex = function(container, index) {
      P.COLLECTION_TYPES_SINGULAR.forEach(function (kind) {
        var plural_kind = P.plural(kind);
        if (container[plural_kind]) {
          container[plural_kind].forEach(function (item) {
            index[P.domId(item)] = item;
            // recursive for any collections
            Indexer.buildIndex(item, index);
          });
        }
      });
    };

    return Indexer;
})(Pip);

