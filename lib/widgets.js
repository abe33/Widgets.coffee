(function() {
  var exports, isCommonJS, widgets;

  widgets = function(name, selector, options, block) {
    var events, handler;
    if (options == null) {
      options = {};
    }
    events = options.on;
    if (typeof events === 'string') {
      events = events.split(/\s+/g);
    }
    handler = function(e) {
      var elements;
      elements = document.querySelectorAll("" + selector + ":not(." + name + "-handled)");
      return Array.prototype.forEach.call(elements, function(element) {
        var res;
        res = widgets[name](element, Object.create(options));
        element.className += " " + name + "-handled";
        return block != null ? block.call(element, element, res) : void 0;
      });
    };
    return events.forEach(function(event) {
      return document.addEventListener(event, handler);
    });
  };

  isCommonJS = typeof module !== "undefined";

  if (isCommonJS) {
    exports = module.exports = widgets;
  } else {
    exports = window.widgets = widgets;
  }

  widgets.version = '0.0.0';

  widgets.define = function(name, block) {
    return widgets[name] = block;
  };

  widgets.deprecated = function(message) {
    var caller, deprecatedMethodCallerFile, deprecatedMethodCallerName, e, parseLine, s, _ref;
    parseLine = function(line) {
      var f, m, o, _ref, _ref1, _ref2, _ref3;
      if (line.indexOf('@') > 0) {
        if (line.indexOf('</') > 0) {
          _ref = /<\/([^@]+)@(.)+$/.exec(line), m = _ref[0], o = _ref[1], f = _ref[2];
        } else {
          _ref1 = /@(.)+$/.exec(line), m = _ref1[0], f = _ref1[1];
        }
      } else {
        if (line.indexOf('(') > 0) {
          _ref2 = /at\s+([^\s]+)\s*\(([^\)])+/.exec(line), m = _ref2[0], o = _ref2[1], f = _ref2[2];
        } else {
          _ref3 = /at\s+([^\s]+)/.exec(line), m = _ref3[0], f = _ref3[1];
        }
      }
      return [o, f];
    };
    e = new Error();
    caller = '';
    if (e.stack != null) {
      s = e.stack.split('\n');
      _ref = parseLine(s[3]), deprecatedMethodCallerName = _ref[0], deprecatedMethodCallerFile = _ref[1];
      caller = deprecatedMethodCallerName ? " (called from " + deprecatedMethodCallerName + " at " + deprecatedMethodCallerFile + ")" : "(called from " + deprecatedMethodCallerFile + ")";
    }
    return console.log("DEPRECATION WARNING: " + message + caller);
  };

}).call(this);

/*
//@ sourceMappingURL=widgets.js.map
*/