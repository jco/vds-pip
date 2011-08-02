var Pip = Pip || {};

Pip.initModules = function() {
    _.each(Pip, function(value, key, list) {
        if (value.init)
            value.init();
    });
};
