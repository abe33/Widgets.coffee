(function() {
  widgets.Activable = (function() {
    function Activable() {}

    Activable.prototype.active = false;

    Activable.prototype.activate = function() {
      this.active = true;
      return typeof this.on_activate === "function" ? this.on_activate() : void 0;
    };

    Activable.prototype.deactivate = function() {
      this.active = false;
      return typeof this.on_deactivate === "function" ? this.on_deactivate() : void 0;
    };

    return Activable;

  })();

  widgets.Disposable = (function() {
    function Disposable() {}

    Disposable.prototype.dispose = function() {
      if (typeof this.on_dispose === "function") {
        this.on_dispose();
      }
      delete this.element;
      return delete this.options;
    };

    return Disposable;

  })();

  widgets.HasElements = (function() {
    function HasElements() {}

    HasElements.has_elements = function(singular, plural) {
      return this[plural] = [];
    };

    return HasElements;

  })();

}).call(this);

//# sourceMappingURL=widgets.mixins.js.map
