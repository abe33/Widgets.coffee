(function() {
  var TestProto;

  widgets.define('checked_input', function(element) {
    return element.addEventListener('change', function() {
      return $(element).toggleClass('checked', element.checked);
    });
  });

  widgets.define('bubbling_focus', function(element) {
    var $element, blur;
    blur = function() {
      return $('.focus').removeClass('focus');
    };
    $element = $(element);
    $element.on('blur', function() {
      return blur();
    });
    return $element.on('focus', function() {
      blur();
      return $element.parents().addClass('focus');
    });
  });

  widgets.define('test_proto', {
    mixins: [widgets.Activable]
  }, TestProto = (function() {
    function TestProto(element) {
      this.element = element;
      this.on_activate = (function(_this) {
        return function() {
          return console.log('activated');
        };
      })(this);
      this.on_deactivate = (function(_this) {
        return function() {
          return console.log('deactivated');
        };
      })(this);
    }

    return TestProto;

  })());

}).call(this);

//# sourceMappingURL=widgets.common.js.map
