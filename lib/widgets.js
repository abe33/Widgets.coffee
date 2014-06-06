(function() {
  var widgets, __instances__, __widgets__;

  __widgets__ = {};

  __instances__ = {};

  widgets = function(name, selector, options, block) {
    var can_be_handled, events, handled_class, handler, if_condition, instances, max, media_condition, media_handler, min, test_condition, unless_condition, _ref;
    if (options == null) {
      options = {};
    }
    if (__widgets__[name] == null) {
      throw new Error("Unable to find widget '" + name + "'");
    }
    events = (_ref = options.on) != null ? _ref : 'init';
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
        return !!condition(element);
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
            res = res && window.innerWidth >= min;
          }
          if (max != null) {
            res = res && window.innerWidth <= max;
          }
          return res;
        };
        media_handler = function(name) {
          var condition_matched;
          if (name == null) {
            return;
          }
          condition_matched = test_condition(media_condition);
          if (condition_matched) {
            return widgets.activate(name);
          } else {
            return widgets.deactivate(name);
          }
        };
        $(window).on('resize', function() {
          return media_handler(name);
        });
      }
    }
    handler = function() {
      var $elements;
      $elements = $(selector);
      Array.prototype.forEach.call($elements, function(element) {
        var res;
        if (!can_be_handled(element)) {
          return;
        }
        res = __widgets__[name](element, Object.create(options), $elements);
        $(element).addClass(handled_class);
        instances.set(element, res);
        $(document).trigger("" + name + ":handled", element, res, options);
        return block != null ? block.call(element, element, res, options) : void 0;
      });
      if (media_condition != null) {
        return media_handler(name);
      } else {
        return widgets.activate(name);
      }
    };
    return events.forEach(function(event) {
      switch (event) {
        case 'init':
          return handler();
        case 'load':
        case 'resize':
          return $(window).on(event, handler);
        default:
          return $(document).on(event, handler);
      }
    });
  };

  widgets.define = function(name, options, block) {
    var factory, has_mixins, has_proto, _ref;
    if (options == null) {
      options = {};
    }
    if (block == null) {
      block = function() {};
    }
    if (typeof options === 'function') {
      _ref = [options, {}], block = _ref[0], options = _ref[1];
    }
    has_proto = options.proto != null;
    has_mixins = options.mixins != null;
    if (has_proto || has_mixins) {
      if (has_proto) {
        block.prototype = options.proto;
      }
      if (has_mixins) {
        options.mixins.forEach(function(mixin) {
          return block.include(mixin);
        });
      }
      factory = function(element) {
        return new block(element);
      };
      return __widgets__[name] = factory;
    } else {
      return __widgets__[name] = block;
    }
  };

  widgets.$define = function(name, base_options, block) {
    var _ref;
    if (base_options == null) {
      base_options = {};
    }
    if (typeof base_options === 'function') {
      _ref = [{}, base_options], base_options = _ref[0], block = _ref[1];
    }
    return __widgets__[name] = function(element, options) {
      var $element, k, res, v;
      if (options == null) {
        options = {};
      }
      for (k in base_options) {
        v = base_options[k];
        if (options[k] == null) {
          options[k] = v;
        }
      }
      $element = $(element);
      res = typeof $element[name] === "function" ? $element[name](options) : void 0;
      return block != null ? block.call($element, element, res, options) : void 0;
    };
  };

  widgets.release = function(name) {
    return __instances__[name].each(function(value) {
      return value != null ? typeof value.dispose === "function" ? value.dispose() : void 0 : void 0;
    });
  };

  widgets.activate = function(name) {
    return __instances__[name].each(function(value) {
      if (value == null) {
        return;
      }
      if (!value.active) {
        return typeof value.activate === "function" ? value.activate() : void 0;
      }
    });
  };

  widgets.deactivate = function(name) {
    return __instances__[name].each(function(value) {
      if (value == null) {
        return;
      }
      if ((value.active == null) || value.active) {
        return typeof value.deactivate === "function" ? value.deactivate() : void 0;
      }
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

  widgets.version = '0.0.1';

  window.widgets = widgets;

  window.widget = widgets;

  window.$w = widgets;

  widgets.Hash = (function() {
    function Hash() {
      this.clear();
    }

    Hash.prototype.clear = function() {
      this.keys = [];
      return this.values = [];
    };

    Hash.prototype.set = function(key, value) {
      var index;
      if (this.has_key(key)) {
        index = this.keys.indexOf(key);
        this.keys[index] = key;
        return this.values[index] = value;
      } else {
        this.keys.push(key);
        return this.values.push(value);
      }
    };

    Hash.prototype.get = function(key) {
      return this.values[this.keys.indexOf(key)];
    };

    Hash.prototype.get_key = function(value) {
      return this.keys[this.values.indexOf(value)];
    };

    Hash.prototype.has_key = function(key) {
      return this.keys.indexOf(key) > 0;
    };

    Hash.prototype.unset = function(key) {
      var index;
      index = this.keys.indexOf(key);
      this.keys.splice(index, 1);
      return this.values.splice(index, 1);
    };

    Hash.prototype.each = function(block) {
      return this.values.forEach(block);
    };

    Hash.prototype.each_key = function(block) {
      return this.keys.forEach(block);
    };

    Hash.prototype.each_pair = function(block) {
      return this.keys.forEach((function(_this) {
        return function(key) {
          return typeof block === "function" ? block(key, _this.get(key)) : void 0;
        };
      })(this));
    };

    return Hash;

  })();

}).call(this);

//# sourceMappingURL=widgets.js.map
