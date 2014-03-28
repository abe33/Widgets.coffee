(function() {
  widgets.self_and_ancestors = function(element, block) {
    block.call(this, element);
    return widgets.ancestors(element, block);
  };

  widgets.ancestors = function(element, block) {
    var parent;
    parent = element.parentNode;
    if ((parent != null) && parent !== element) {
      block.call(this, parent);
      return $w.ancestors(parent, block);
    }
  };

  widget.find_ancestor = function(element, selector) {
    var ancestor, _i, _len, _ref;
    _ref = widgets.all_ancestors(element);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      ancestor = _ref[_i];
      if (typeof ancestor.matchesSelector === "function" ? ancestor.matchesSelector(selector) : void 0) {
        return ancestor;
      }
    }
  };

  widgets.all_ancestors = function(element) {
    var results;
    results = [];
    widgets.ancestors(element, function(ancestor) {
      return results.push(ancestor);
    });
    return results;
  };

  widgets.as_node_list = function(node) {
    if (node == null) {
      return [];
    }
    if (node.length != null) {
      return node;
    } else {
      return [node];
    }
  };

  widgets.has_class = function(nl, cls) {
    nl = widgets.as_node_list(nl);
    return Array.prototype.every.call(nl, function(n) {
      return RegExp("(\\s|^)" + cls + "(\\s|$)").test(n.className);
    });
  };

  widgets.add_class = function(nl, cls) {
    nl = widgets.as_node_list(nl);
    return Array.prototype.forEach.call(nl, function(node) {
      if (!widgets.has_class(node, cls)) {
        return node.className += " " + cls;
      }
    });
  };

  widgets.remove_class = function(nl, cls) {
    nl = widgets.as_node_list(nl);
    return Array.prototype.forEach.call(nl, function(node) {
      return node.className = node.className.replace(RegExp("\\b" + cls + "\\b", "g"), '');
    });
  };

  widgets.toggle_class = function(nl, cls, b) {
    nl = widgets.as_node_list(nl);
    return Array.prototype.forEach.call(nl, function(node) {
      var has_class;
      has_class = b != null ? !b : widgets.has_class(node, cls);
      if (has_class) {
        return widgets.remove_class(node, cls);
      } else {
        return widgets.add_class(node, cls);
      }
    });
  };

  widgets.escape_html = function(str) {
    return str.replace(/</g, '&lt;').replace(/>/g, '&gt;');
  };

  widgets.strip_html = function(str) {
    var n;
    n = document.createElement('span');
    n.innerHTML = str;
    return n.textContent;
  };

  widgets.tag = function(name, attrs) {
    var attr, flatten_object, node, value;
    if (attrs == null) {
      attrs = {};
    }
    flatten_object = function(object) {
      var new_object, recursion;
      new_object = {};
      recursion = function(object, new_object, prefix) {
        var k, v, _results;
        if (prefix == null) {
          prefix = '';
        }
        _results = [];
        for (k in object) {
          v = object[k];
          k = k.replace(/_/g, '-');
          if (typeof v === 'object') {
            _results.push(recursion(v, new_object, prefix + k + '-'));
          } else {
            _results.push(new_object[prefix + k] = v);
          }
        }
        return _results;
      };
      recursion(object, new_object);
      return new_object;
    };
    node = document.createElement(name);
    attrs = flatten_object(attrs);
    if (attrs.id != null) {
      node.id = attrs.id;
      delete attrs.id;
    }
    if (attrs["class"] != null) {
      node.className = attrs["class"];
      delete attrs["class"];
    }
    for (attr in attrs) {
      value = attrs[attr];
      node.setAttribute(attr, value);
    }
    return node;
  };

  widgets.tag_html = function(name, attrs) {
    return widgets.tag(name, attrs).outerHTML;
  };

  widgets.content_tag = function(name, content, attrs) {
    var node, res, _ref, _ref1;
    if (content == null) {
      content = '';
    }
    if (attrs == null) {
      attrs = {};
    }
    if (typeof attrs === 'function') {
      _ref = [content, attrs], attrs = _ref[0], content = _ref[1];
    }
    if (typeof content === 'object') {
      _ref1 = [content, ''], attrs = _ref1[0], content = _ref1[1];
    }
    node = widgets.tag(name, attrs);
    node.innerHTML = typeof content === 'function' ? (res = content.call(node), (res != null ? res.outerHTML : void 0) || String(res)) : String(content);
    return node;
  };

  widgets.content_tag_html = function(name, content, attrs) {
    return widgets.content_tag(name, content, attrs).outerHTML;
  };

  widgets.icon = function(name, options) {
    if (options == null) {
      options = {};
    }
    if (options['class']) {
      options['class'] += ' ' + widgets.icon_class(name);
    } else {
      options['class'] = widgets.icon_class(name);
    }
    return widgets.content_tag('i', '', options);
  };

  widgets.icon_class = function(name) {
    return "fa fa-" + name;
  };

  widgets.icon_html = function(name, options) {
    return widgets.icon(name, options).outerHTML;
  };

}).call(this);

//# sourceMappingURL=widgets.utils.js.map
