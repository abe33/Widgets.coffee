(function() {
  var widgets, __instances__, __widgets__;

  __widgets__ = {};

  __instances__ = {};

  widgets = function(name, selector, options, block) {
    var can_be_handled, events, handled_class, handler, if_condition, instances, max, media_condition, media_handler, min, test_condition, unless_condition;
    if (options == null) {
      options = {};
    }
    if (__widgets__[name] == null) {
      throw new Error("Unable to find widget '" + name + "'");
    }
    events = options.on || 'init';
    if_condition = options["if"];
    unless_condition = options.unless;
    media_condition = options.media;
    delete options.on;
    delete options["if"];
    delete options.unless;
    delete options.media;
    if (typeof events === 'string') {
      events = events.split(/\s+/g);
    }
    instances = __instances__[name] || (__instances__[name] = new widgets.Hash);
    test_condition = function(condition, element) {
      if (typeof condition === 'function') {
        return condition(element);
      } else {
        return !!condition;
      }
    };
    handled_class = "" + name + "-handled";
    can_be_handled = function(element) {
      var res;
      res = element.className.indexOf(handled_class) === -1;
      if (if_condition != null) {
        res && (res = test_condition(if_condition, element));
      }
      if (unless_condition != null) {
        res && (res = !test_condition(unless_condition, element));
      }
      return res;
    };
    if (media_condition != null) {
      if (typeof media_condition === 'object') {
        min = media_condition.min, max = media_condition.max;
        media_condition = function() {
          var res;
          res = true;
          if (min != null) {
            res && (res = window.innerWidth >= min);
          }
          if (max != null) {
            res && (res = window.innerWidth <= max);
          }
          return res;
        };
      }
      media_handler = function(element, widget) {
        var condition_matched;
        if (widget == null) {
          return;
        }
        condition_matched = test_condition(media_condition, element);
        if (condition_matched && !widget.active) {
          return typeof widget.activate === "function" ? widget.activate() : void 0;
        } else if (!condition_matched && widget.active) {
          return typeof widget.deactivate === "function" ? widget.deactivate() : void 0;
        }
      };
      window.addEventListener('resize', function() {
        return instances.each_pair(function(element, widget) {
          return media_handler(element, widget);
        });
      });
    }
    handler = function() {
      var elements;
      elements = document.querySelectorAll(selector);
      return Array.prototype.forEach.call(elements, function(element) {
        var res;
        if (!can_be_handled(element)) {
          return;
        }
        res = __widgets__[name](element, Object.create(options), elements);
        element.className += " " + handled_class;
        instances.set(element, res);
        if (media_condition != null) {
          media_handler(element, res);
        }
        return block != null ? block.call(element, element, res) : void 0;
      });
    };
    return events.forEach(function(event) {
      switch (event) {
        case 'init':
          return handler();
        case 'load':
        case 'resize':
          return window.addEventListener(event, handler);
        default:
          return document.addEventListener(event, handler);
      }
    });
  };

  widgets.define = function(name, block) {
    return __widgets__[name] = block;
  };

  widgets.release = function(name) {
    return __instances__[name].each(function(value) {
      return value != null ? typeof value.dispose === "function" ? value.dispose() : void 0 : void 0;
    });
  };

  widgets.activate = function(name) {
    return __instances__[name].each(function(value) {
      return value != null ? typeof value.activate === "function" ? value.activate() : void 0 : void 0;
    });
  };

  widgets.deactivate = function(name) {
    return __instances__[name].each(function(value) {
      return value != null ? typeof value.deactivate === "function" ? value.deactivate() : void 0 : void 0;
    });
  };

  widgets.deprecated = function(message) {
    var caller, callerFile, callerName, e, parseLine, s, _ref;
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
      _ref = parseLine(s[3]), callerName = _ref[0], callerFile = _ref[1];
      caller = callerName ? " (called from " + callerName + " at " + callerFile + ")" : "(called from " + callerFile + ")";
    }
    return console.log("DEPRECATION WARNING: " + message + caller);
  };

  widgets.version = '0.0.0';

  window.widgets = widgets;

  window.widget = widgets;

  window.$w = widgets;

}).call(this);

/*
//@ sourceMappingURL=widgets.js.map
*/