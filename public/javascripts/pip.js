/*
 * Authors: Jeff Cox, David Zhang
 * Copyright Syracuse University
 */
 
/* This little module exists to make sure that if other modules have
an init() function, that function will be called after the page is loaded.
*/

var Pip = Pip || {};

Pip.initModules = function() {
    _.each(Pip, function(value, key, list) {
        if (value.init)
            value.init();
    });
};
