/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
 
 /*
 
 Emulate active record models, kind of. Provides an object oriented structure
 for the kind of objects pip deals with (e.g. Project, Folder, Document, etc.)
 Allows things like myFolder.id #=> 4
 or myDocument.type #=> "document"
 
 */
 
var Pip = Pip || {};

(function (P) {
  
  var Model = P.Model = {};

  // Given a bunch of json data, which is just the javascript equivalent of the rails object, generate 
  // the object we want (Folder, Document, whatever). This is essentially a way of getting rails-like
  // objects in javascript-land.
  Model.Base = function (json) {
    if (json) {
      // Rules: if it is a recognized collection type, initialize an array of models
      // otherwise, it is a simple property that should be added
      var that = this;
      Object.keys(json).forEach(function (k) {
        // if k is a collection type
        if (P.COLLECTION_TYPES.indexOf(k) != -1) {
          // setup those models
          var modelName = k.singular().capitalize();
          that[k] = json[k].map(function (subJson) { return new Model[modelName](subJson) });
        } else {
          that[k] = json[k];
        }
      });
    }
  };
  Model.Base.prototype.save = function () { console.log("I don't actually save anything, you know."); }

  Model.Project = function(json) { Model.Base.call(this, json); };
  Model.Project.prototype = new Model.Base();
  Model.Project.prototype.type = 'project';

  Model.Stage = function(json) { Model.Base.call(this, json); };
  Model.Stage.prototype = new Model.Base();
  Model.Stage.prototype.type = 'stage';

  Model.Factor = function(json) { Model.Base.call(this, json); };
  Model.Factor.prototype = new Model.Base();
  Model.Factor.prototype.type = 'factor';

  Model.Task = function(json) { Model.Base.call(this, json); };
  Model.Task.prototype = new Model.Base();
  Model.Task.prototype.type = 'task';

  Model.Folder = function(json) { Model.Base.call(this, json); };
  Model.Folder.prototype = new Model.Base();
  Model.Folder.prototype.type = 'folder';

  Model.Document = function(json) { Model.Base.call(this, json); };
  Model.Document.prototype = new Model.Base();
  Model.Document.prototype.type = 'document';

})(Pip);
