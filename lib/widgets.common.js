(function() {
  widgets.define('checked_input', function(element) {
    return element.addEventListener('change', function() {
      return widgets.toggle_class(element, 'checked', element.checked);
    });
  });

  widgets.define('bubbling_focus', function(element) {
    var blur;
    blur = function() {
      return widgets.remove_class(document.querySelectorAll('.focus'), 'focus');
    };
    element.addEventListener('blur', function() {
      return blur();
    });
    return element.addEventListener('focus', function() {
      blur();
      return widgets.self_and_ancestors(element, function(el) {
        return widgets.add_class(el, 'focus');
      });
    });
  });

}).call(this);

//# sourceMappingURL=widgets.common.js.map
