(function() {
  var AbstractMode, BGRMode, Button, CheckBox, ColorPicker, ColorPickerDialog, Container, FilePicker, GRBMode, HSVMode, KeyStroke, MenuList, MenuModel, NumericWidget, RGBMode, Radio, RadioGroup, SHVMode, SingleSelect, Slider, SquarePicker, Stepper, TextArea, TextInput, VHSMode, Widget, WidgetPlugin, colorObjectFromValue, colorObjectToValue, hex2rgb, hsv2rgb, isSafeChannel, isSafeColor, isSafeHSV, isSafeHue, isSafeNumber, isSafePercentage, isSafeRGB, isSafeValue, keys, keystroke, rgb2hex, rgb2hsv;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __slice = Array.prototype.slice, __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  keystroke = function(keyCode, modifiers) {
    if (("" + keyCode + "-" + modifiers) in KeyStroke.instances) {
      return KeyStroke.instances["" + keyCode + "-" + modifiers];
    } else {
      return KeyStroke.instances["" + keyCode + "-" + modifiers] = new KeyStroke(keyCode, modifiers);
    }
  };
  KeyStroke = (function() {
    KeyStroke.instances = {};
    function KeyStroke(keyCode, modifiers) {
      this.keyCode = keyCode;
      this.modifiers = modifiers;
      this.ctrl = (modifiers & 0x01) === 1;
      this.shift = ((modifiers >> 1) & 0x01) === 1;
      this.alt = ((modifiers >> 2) & 0x01) === 1;
    }
    KeyStroke.prototype.match = function(e) {
      return e.keyCode === this.keyCode && e.ctrlKey === this.ctrl && e.shiftKey === this.shift && e.altKey === this.alt;
    };
    KeyStroke.prototype.toString = function() {
      var a, k, v;
      a = [];
      if (this.ctrl) {
        a.push("Ctrl");
      }
      if (this.shift) {
        a.push("Shift");
      }
      if (this.alt) {
        a.push("Alt");
      }
      for (k in keys) {
        v = keys[k];
        if (this.keyCode === v) {
          a.push(k.toUpperCase());
          break;
        }
      }
      return a.join("+");
    };
    return KeyStroke;
  })();
  keys = {
    mod: {
      ctrl: 1,
      shift: 2,
      alt: 4
    },
    backspace: 8,
    tab: 9,
    enter: 13,
    shift: 16,
    ctrl: 17,
    alt: 18,
    pause: 19,
    caps_lock: 20,
    escape: 27,
    space: 32,
    page_up: 33,
    page_down: 34,
    end: 35,
    home: 36,
    left: 37,
    up: 38,
    right: 39,
    down: 40,
    insert: 45,
    decimal: 46,
    key_0: 48,
    key_1: 49,
    key_2: 50,
    key_3: 51,
    key_4: 52,
    key_5: 53,
    key_6: 54,
    key_7: 55,
    key_8: 56,
    key_9: 57,
    a: 65,
    b: 66,
    c: 67,
    d: 68,
    e: 69,
    f: 70,
    g: 71,
    h: 72,
    i: 73,
    j: 74,
    k: 75,
    l: 76,
    m: 77,
    n: 78,
    o: 79,
    p: 80,
    q: 81,
    r: 82,
    s: 83,
    t: 84,
    u: 85,
    v: 86,
    w: 87,
    x: 88,
    y: 89,
    z: 90,
    left_window_key: 91,
    right_window_key: 92,
    select: 93,
    numpad_0: 96,
    numpad_1: 97,
    numpad_2: 98,
    numpad_3: 99,
    numpad_4: 100,
    numpad_5: 101,
    numpad_6: 102,
    numpad_7: 103,
    numpad_8: 104,
    numpad_9: 105,
    multiply: 106,
    add: 107,
    subtract: 109,
    decimal_point: 110,
    divide: 111,
    f1: 112,
    f2: 113,
    f3: 114,
    f4: 115,
    f5: 116,
    f6: 117,
    f7: 118,
    f8: 119,
    f9: 120,
    f10: 121,
    f11: 122,
    f12: 123,
    num_lock: 144,
    scroll_lock: 145,
    semi_colon: 186,
    equal_sign: 187,
    comma: 188,
    dash: 189,
    period: 190,
    forward_slash: 191,
    grave_accent: 192,
    open_bracket: 219,
    back_slash: 220,
    close_bracket: 221,
    single_quote: 222
  };
  if (typeof window !== "undefined" && window !== null) {
    window.keystroke = keystroke;
    window.keys = keys;
  }
  Widget = (function() {
    function Widget(target) {
      if (target != null) {
        this.checkTarget(target);
      }
      this.propertyChanged = new Signal;
      this.valueChanged = new Signal;
      this.stateChanged = new Signal;
      this.target = target;
      this.hasTarget = target != null;
      this.jTarget = this.hasTarget ? $(target) : null;
      this.properties = {
        disabled: this.booleanFromAttribute("disabled"),
        readonly: this.booleanFromAttribute("readonly"),
        value: this.valueFromAttribute("value"),
        name: this.valueFromAttribute("name"),
        id: null
      };
      this.dummy = this.createDummy();
      this.hasDummy = this.dummy != null;
      this.hasFocus = false;
      if (this.hasTarget) {
        this.targetInitialValue = this.get("value");
        this.jTarget.bind("change", __bind(function(e) {
          return this.targetChange(e);
        }, this));
        this.jTarget.addClass("widget-done");
      }
      if (this.hasDummy) {
        this.dummyStates = ["disabled", "readonly"];
        this.setFocusable(!this.get("disabled"));
        this.dummyClass = this.dummy.attr("class");
        if (this.hasTarget) {
          this.dummy.attr("style", this.jTarget.attr("style"));
        }
        this.registerToDummyEvents();
        this.updateStates();
      }
      this.isWidget = true;
      this.parent = null;
      this.keyDownCommands = {};
      this.keyUpCommands = {};
    }
    Widget.prototype.get = function(property) {
      if (("get_" + property) in this) {
        return this["get_" + property].call(this, property);
      } else {
        return this.properties[property];
      }
    };
    Widget.prototype.set = function(propertyOrObject, value) {
      var k, v, _results;
      if (value == null) {
        value = null;
      }
      if (typeof propertyOrObject === "object") {
        _results = [];
        for (k in propertyOrObject) {
          v = propertyOrObject[k];
          _results.push(this.handlePropertyChange(k, v));
        }
        return _results;
      } else {
        return this.handlePropertyChange(propertyOrObject, value);
      }
    };
    Widget.prototype.handlePropertyChange = function(property, value) {
      if (property in this.properties) {
        this.properties[property] = ("set_" + property) in this ? this["set_" + property].call(this, property, value) : value;
      }
      this.updateStates();
      return this.propertyChanged.dispatch(this, property, value);
    };
    Widget.prototype.createProperty = function(property, value, setter, getter) {
      if (value == null) {
        value = void 0;
      }
      if (setter == null) {
        setter = null;
      }
      if (getter == null) {
        getter = null;
      }
      this.properties[property] = value;
      if (setter != null) {
        this["set_" + property] = setter;
      }
      if (getter != null) {
        return this["get_" + property] = getter;
      }
    };
    Widget.prototype.set_disabled = function(property, value) {
      this.setFocusable(!value);
      return this.booleanToAttribute(property, value);
    };
    Widget.prototype.set_readonly = function(property, value) {
      return this.booleanToAttribute(property, value);
    };
    Widget.prototype.set_value = function(property, value) {
      if (this.get("readonly")) {
        return this.get(property);
      } else {
        if (value !== this.get("value")) {
          this.valueToAttribute(property, value);
          this.valueChanged.dispatch(this, value);
        }
        return value;
      }
    };
    Widget.prototype.set_name = function(property, value) {
      return this.valueToAttribute(property, value);
    };
    Widget.prototype.set_id = function(property, value) {
      if (value != null) {
        this.dummy.attr("id", value);
      } else {
        this.dummy.removeAttr("id");
      }
      return value;
    };
    Widget.prototype.checkTarget = function(target) {
      if (!this.isElement(target)) {
        throw "Widget's target should be a node";
      }
    };
    Widget.prototype.isElement = function(o) {
      if (typeof HTMLElement === "object") {
        return o instanceof HTMLElement;
      } else {
        return typeof o === "object" && o.nodeType === 1 && typeof o.nodeName === "string";
      }
    };
    Widget.prototype.isTag = function(o, tag) {
      var _ref;
      return this.isElement(o) && (o != null ? (_ref = o.nodeName) != null ? _ref.toLowerCase() : void 0 : void 0) === tag;
    };
    Widget.prototype.isInputWithType = function() {
      var o, types, _ref;
      o = arguments[0], types = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.isTag(o, "input") && (_ref = $(o).attr("type"), __indexOf.call(types, _ref) >= 0);
    };
    Widget.prototype.hideTarget = function() {
      if (this.hasTarget) {
        return this.jTarget.hide();
      }
    };
    Widget.prototype.reset = function() {
      return this.set("value", this.targetInitialValue);
    };
    Widget.prototype.targetChange = function(e) {};
    Widget.prototype.cantInteract = function() {
      return this.get("readonly") || this.get("disabled");
    };
    Widget.prototype.createDummy = function() {};
    Widget.prototype.updateStates = function() {
      var newState, oldState, outputState, state, _i, _len, _ref;
      if (this.hasDummy) {
        oldState = this.dummy.attr("class");
        newState = "";
        _ref = this.dummyStates;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          state = _ref[_i];
          if (this.get(state)) {
            if (newState.length > 0) {
              newState += " ";
            }
            newState += state;
          }
        }
        if (this.hasFocus) {
          newState = "focus " + newState;
        }
        outputState = (this.dummyClass != null) && newState !== "" ? this.dummyClass + " " + newState : this.dummyClass != null ? this.dummyClass : newState;
        if (outputState !== oldState) {
          this.dummy.attr("class", outputState);
          return this.stateChanged.dispatch(this, newState);
        }
      }
    };
    Widget.prototype.addClasses = function() {
      var cl, classes, dummyClasses, _i, _len;
      classes = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      dummyClasses = this.dummyClass.split(" ");
      for (_i = 0, _len = classes.length; _i < _len; _i++) {
        cl = classes[_i];
        if (__indexOf.call(dummyClasses, cl) < 0) {
          dummyClasses.push(cl);
        }
      }
      this.dummyClass = dummyClasses.join(" ");
      return this.updateStates();
    };
    Widget.prototype.removeClasses = function() {
      var cl, classes, dummyClasses, output, _i, _len;
      classes = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      dummyClasses = this.dummyClass.split(" ");
      output = [];
      for (_i = 0, _len = dummyClasses.length; _i < _len; _i++) {
        cl = dummyClasses[_i];
        if (__indexOf.call(classes, cl) < 0) {
          output.push(cl);
        }
      }
      this.dummyClass = output.join(" ");
      return this.updateStates();
    };
    Widget.prototype.registerToDummyEvents = function() {
      return this.dummy.bind(this.supportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
    };
    Widget.prototype.unregisterFromDummyEvents = function() {
      return this.dummy.unbind(this.supportedEvents);
    };
    Widget.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick focus blur keyup keydown keypress";
    Widget.prototype.mousedown = function(e) {
      return true;
    };
    Widget.prototype.mouseup = function(e) {
      return true;
    };
    Widget.prototype.mousemove = function(e) {
      return true;
    };
    Widget.prototype.mouseover = function(e) {
      return true;
    };
    Widget.prototype.mouseout = function(e) {
      return true;
    };
    Widget.prototype.mousewheel = function(e, d) {
      return true;
    };
    Widget.prototype.click = function(e) {
      return true;
    };
    Widget.prototype.dblclick = function(e) {
      return true;
    };
    Widget.prototype.focus = function(e) {
      this.hasFocus = true;
      this.updateStates();
      return !this.get("disabled");
    };
    Widget.prototype.blur = function(e) {
      this.hasFocus = false;
      this.updateStates();
      return true;
    };
    Widget.prototype.keydown = function(e) {
      return this.triggerKeyDownCommand(e);
    };
    Widget.prototype.keyup = function(e) {
      return this.triggerKeyUpCommand(e);
    };
    Widget.prototype.keypress = function(e) {
      return true;
    };
    Widget.prototype.setFocusable = function(allowFocus) {
      if (this.hasDummy) {
        if (allowFocus) {
          return this.dummy.attr("tabindex", 0);
        } else {
          return this.dummy.removeAttr("tabindex");
        }
      }
    };
    Widget.prototype.grabFocus = function() {
      if (this.hasDummy) {
        return this.dummy.focus();
      }
    };
    Widget.prototype.releaseFocus = function() {
      if (this.hasDummy) {
        return this.dummy.blur();
      }
    };
    Widget.prototype.registerKeyDownCommand = function(ks, command) {
      return this.keyDownCommands[ks] = [ks, command];
    };
    Widget.prototype.registerKeyUpCommand = function(ks, command) {
      return this.keyUpCommands[ks] = [ks, command];
    };
    Widget.prototype.hasKeyDownCommand = function(ks) {
      return ks in this.keyDownCommands;
    };
    Widget.prototype.hasKeyUpCommand = function(ks) {
      return ks in this.keyUpCommands;
    };
    Widget.prototype.triggerKeyDownCommand = function(e) {
      var command, key, ks, _ref, _ref2;
      _ref = this.keyDownCommands;
      for (key in _ref) {
        _ref2 = _ref[key], ks = _ref2[0], command = _ref2[1];
        if (ks.match(e)) {
          return command.call(this, e);
        }
      }
      if (this.parent != null) {
        this.parent.triggerKeyDownCommand(e);
      }
      return true;
    };
    Widget.prototype.triggerKeyUpCommand = function(e) {
      var command, key, ks, _ref, _ref2;
      _ref = this.keyUpCommands;
      for (key in _ref) {
        _ref2 = _ref[key], ks = _ref2[0], command = _ref2[1];
        if (ks.match(e)) {
          return command.call(this, e);
        }
      }
      if (this.parent != null) {
        this.parent.triggerKeyUpCommand(e);
      }
      return true;
    };
    Widget.prototype.valueFromAttribute = function(property, defaultValue) {
      if (defaultValue == null) {
        defaultValue = void 0;
      }
      if (this.hasTarget) {
        return this.jTarget.attr(property);
      } else {
        return defaultValue;
      }
    };
    Widget.prototype.valueToAttribute = function(property, value) {
      if (this.hasTarget) {
        this.jTarget.attr(property, value);
      }
      return value;
    };
    Widget.prototype.booleanFromAttribute = function(property, defaultValue) {
      if (defaultValue == null) {
        defaultValue = void 0;
      }
      if (this.hasTarget) {
        return this.jTarget.attr(property) !== void 0;
      } else {
        return defaultValue;
      }
    };
    Widget.prototype.booleanToAttribute = function(property, value) {
      if (this.hasTarget) {
        if (value) {
          this.jTarget.attr(property, property);
        } else {
          this.jTarget.removeAttr(property);
        }
      }
      return value;
    };
    return Widget;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Widget = Widget;
  }
  Container = (function() {
    __extends(Container, Widget);
    function Container(target) {
      Container.__super__.constructor.call(this, target);
      this.children = [];
    }
    Container.prototype.add = function(child) {
      if ((child != null) && child.isWidget && __indexOf.call(this.children, child) < 0) {
        this.children.push(child);
        this.dummy.append(child.dummy);
        return child.parent = this;
      }
    };
    Container.prototype.remove = function(child) {
      if ((child != null) && __indexOf.call(this.children, child) >= 0) {
        this.children.splice(this.children.indexOf(child), 1);
        child.dummy.detach();
        return child.parent = null;
      }
    };
    Container.prototype.createDummy = function() {
      return $("<span class='container'></span>");
    };
    Container.prototype.focus = function(e) {
      if (e.target === this.dummy[0]) {
        return Container.__super__.focus.call(this, e);
      }
    };
    return Container;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Container = Container;
  }
  Button = (function() {
    __extends(Button, Widget);
    function Button() {
      var action, arg, args, target;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      switch (args.length) {
        case 1:
          arg = args[0];
          if (typeof arg.action === "function") {
            action = arg;
          } else {
            target = arg;
          }
          break;
        case 2:
          target = args[0], action = args[1];
      }
      Button.__super__.constructor.call(this, target);
      this.createProperty("action", action);
      this.updateContent();
      this.hideTarget();
      this.registerKeyDownCommand(keystroke(keys.space), this.click);
      this.registerKeyDownCommand(keystroke(keys.enter), this.click);
    }
    Button.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "button", "reset", "submit")) {
        throw "Buttons only support input with a type in button, reset or submit as target";
      }
    };
    Button.prototype.createDummy = function() {
      return $("<span class='button'></span>");
    };
    Button.prototype.updateContent = function() {
      var action, value;
      this.dummy.find(".content").remove();
      action = this.get("action");
      value = this.get("value");
      if ((action != null) && (action.display != null)) {
        return this.dummy.append($("<span class='content'>" + action.display + "</span>"));
      } else {
        return this.dummy.append($("<span class='content'>" + value + "</span>"));
      }
    };
    Button.prototype.handlePropertyChange = function(property, value) {
      Button.__super__.handlePropertyChange.call(this, property, value);
      if (property === "value" || property === "action") {
        return this.updateContent();
      }
    };
    Button.prototype.click = function(e) {
      var action;
      if (this.cantInteract()) {
        return;
      }
      action = this.get("action");
      if (action != null) {
        action.action();
      }
      if (this.hasTarget) {
        return this.jTarget.click();
      }
    };
    return Button;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Button = Button;
  }
  TextInput = (function() {
    __extends(TextInput, Widget);
    function TextInput(target) {
      if (target == null) {
        target = $("<input type='text'></input>")[0];
      }
      TextInput.__super__.constructor.call(this, target);
      this.createProperty("maxlength", this.valueFromAttribute("maxlength"));
      this.valueIsObsolete = false;
    }
    TextInput.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "text", "password")) {
        throw "TextInput must have an input text as target";
      }
    };
    TextInput.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='text'></span>");
      dummy.append(this.jTarget);
      return dummy;
    };
    TextInput.prototype.set_maxlength = function(property, value) {
      if (value != null) {
        this.jTarget.attr("maxlength", value);
      } else {
        this.jTarget.removeAttr("maxlength");
      }
      return value;
    };
    TextInput.prototype.inputSupportedEvents = "focus blur keyup keydown keypress input change";
    TextInput.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick";
    TextInput.prototype.registerToDummyEvents = function() {
      this.jTarget.bind(this.inputSupportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
      return TextInput.__super__.registerToDummyEvents.call(this);
    };
    TextInput.prototype.unregisterFromDummyEvents = function() {
      this.jTarget.unbind(this.inputSupportedEvents);
      return TextInput.__super__.unregisterFromDummyEvents.call(this);
    };
    TextInput.prototype.input = function(e) {
      return this.valueIsObsolete = true;
    };
    TextInput.prototype.change = function(e) {
      this.set("value", this.valueFromAttribute("value"));
      this.valueIsObsolete = false;
      return false;
    };
    TextInput.prototype.mouseup = function() {
      if (!this.get("disabled")) {
        this.grabFocus();
      }
      return true;
    };
    TextInput.prototype.setFocusable = function() {};
    TextInput.prototype.grabFocus = function() {
      return this.jTarget.focus();
    };
    return TextInput;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.TextInput = TextInput;
  }
  TextArea = (function() {
    __extends(TextArea, Widget);
    function TextArea(target) {
      if (target == null) {
        target = $("<textarea></textarea")[0];
      }
      TextArea.__super__.constructor.call(this, target);
      this.valueIsObsolete = false;
    }
    TextArea.prototype.checkTarget = function(target) {
      if (!this.isTag(target, "textarea")) {
        throw "TextArea only allow textarea nodes as target";
      }
    };
    TextArea.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='textarea'></span>");
      dummy.append(this.target);
      return dummy;
    };
    TextArea.prototype.targetSupportedEvents = "focus blur keyup keydown keypress input change";
    TextArea.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick";
    TextArea.prototype.registerToDummyEvents = function() {
      this.jTarget.bind(this.targetSupportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
      return TextArea.__super__.registerToDummyEvents.call(this);
    };
    TextArea.prototype.unregisterFromDummyEvents = function() {
      this.jTarget.unbind(this.targetSupportedEvents);
      return TextArea.__super__.unregisterFromDummyEvents.call(this);
    };
    TextArea.prototype.input = function(e) {
      return this.valueIsObsolete = true;
    };
    TextArea.prototype.change = function(e) {
      this.set("value", this.jTarget.val());
      this.valueIsObsolete = false;
      return true;
    };
    TextArea.prototype.mouseup = function() {
      if (!this.get("disabled")) {
        this.grabFocus();
      }
      return true;
    };
    TextArea.prototype.setFocusable = function() {};
    TextArea.prototype.grabFocus = function() {
      return this.jTarget.focus();
    };
    return TextArea;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.TextArea = TextArea;
  }
  CheckBox = (function() {
    __extends(CheckBox, Widget);
    CheckBox.prototype.targetType = "checkbox";
    function CheckBox(target) {
      CheckBox.__super__.constructor.call(this, target);
      this.checkedChanged = new Signal;
      this.createProperty("values", [true, false]);
      this.createProperty("checked", this.booleanFromAttribute("checked", false));
      this.targetInitialChecked = this.get("checked");
      this.dummyStates = ["checked", "disabled", "readonly"];
      this.registerKeyUpCommand(keystroke(keys.enter), this.actionToggle);
      this.registerKeyUpCommand(keystroke(keys.space), this.actionToggle);
      this.updateStates();
      this.hideTarget();
    }
    CheckBox.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "checkbox")) {
        throw "CheckBox target must be an input with a checkbox type";
      }
    };
    CheckBox.prototype.set_checked = function(property, value) {
      this.updateValue(value, this.get("values"));
      this.booleanToAttribute(property, value);
      this.checkedChanged.dispatch(this, value);
      return value;
    };
    CheckBox.prototype.set_value = function(property, value) {
      if (!this.valueSetProgrammatically) {
        this.set("checked", value === this.get("values")[0]);
      }
      return CheckBox.__super__.set_value.call(this, property, value);
    };
    CheckBox.prototype.set_values = function(property, value) {
      this.updateValue(this.get("checked"), value);
      return value;
    };
    CheckBox.prototype.createDummy = function() {
      return $("<span class='checkbox'></span>");
    };
    CheckBox.prototype.toggle = function() {
      return this.set("checked", !this.get("checked"));
    };
    CheckBox.prototype.actionToggle = function() {
      if (!(this.get("readonly") || this.get("disabled"))) {
        return this.toggle();
      }
    };
    CheckBox.prototype.reset = function() {
      CheckBox.__super__.reset.call(this);
      return this.set("checked", this.targetInitialChecked);
    };
    CheckBox.prototype.updateValue = function(checked, values) {
      this.valueSetProgrammatically = true;
      this.set("value", checked ? values[0] : values[1]);
      return this.valueSetProgrammatically = false;
    };
    CheckBox.prototype.click = function(e) {
      this.actionToggle();
      if (!this.get("disabled")) {
        return this.grabFocus();
      }
    };
    return CheckBox;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.CheckBox = CheckBox;
  }
  Radio = (function() {
    __extends(Radio, CheckBox);
    function Radio() {
      Radio.__super__.constructor.apply(this, arguments);
    }
    Radio.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "radio")) {
        throw "Radio target must be an input with a radio type";
      }
    };
    Radio.prototype.createDummy = function() {
      return $("<span class='radio'></span>");
    };
    Radio.prototype.toggle = function() {
      if (!this.get("checked")) {
        return Radio.__super__.toggle.call(this);
      }
    };
    return Radio;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Radio = Radio;
  }
  RadioGroup = (function() {
    function RadioGroup() {
      var radio, radios, _i, _len;
      radios = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.selectionChanged = new Signal;
      this.radios = [];
      for (_i = 0, _len = radios.length; _i < _len; _i++) {
        radio = radios[_i];
        this.add(radio);
      }
    }
    RadioGroup.prototype.add = function(radio) {
      if (!this.contains(radio)) {
        this.radios.push(radio);
        radio.checkedChanged.add(this.radioCheckedChanged, this);
        if (radio.get("checked")) {
          return this.selectedRadio = radio;
        }
      }
    };
    RadioGroup.prototype.remove = function(radio) {
      if (this.contains(radio)) {
        this.radios.splice(this.indexOf(radio), 1);
        return radio.checkedChanged.remove(this.radioCheckedChanged, this);
      }
    };
    RadioGroup.prototype.contains = function(radio) {
      return this.indexOf(radio) !== -1;
    };
    RadioGroup.prototype.indexOf = function(radio) {
      return this.radios.indexOf(radio);
    };
    RadioGroup.prototype.checkedSetProgrammatically = false;
    RadioGroup.prototype.select = function(radio) {
      var oldSelectedRadio;
      if (radio !== this.selectedRadio) {
        this.checkedSetProgrammatically = true;
        oldSelectedRadio = this.selectedRadio;
        if (this.selectedRadio != null) {
          this.selectedRadio.set("checked", false);
        }
        this.selectedRadio = radio;
        if (this.selectedRadio != null) {
          if (!this.selectedRadio.get("checked")) {
            this.selectedRadio.set("checked", true);
          }
        }
        this.checkedSetProgrammatically = false;
        return this.selectionChanged.dispatch(this, oldSelectedRadio, this.selectedRadio);
      }
    };
    RadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
      if (!this.checkedSetProgrammatically) {
        if (checked) {
          return this.select(radio);
        } else if (radio === this.selectedRadio) {
          return this.selectedRadio = null;
        }
      }
    };
    return RadioGroup;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.RadioGroup = RadioGroup;
  }
  NumericWidget = (function() {
    __extends(NumericWidget, Widget);
    function NumericWidget(target) {
      NumericWidget.__super__.constructor.call(this, target);
      this.createProperty("min", parseFloat(this.valueFromAttribute("min", 0)));
      this.createProperty("max", parseFloat(this.valueFromAttribute("max", 100)));
      this.createProperty("step", parseFloat(this.valueFromAttribute("step", 1)));
      this.properties.value = parseFloat(this.valueFromAttribute("value", 0));
      this.incrementInterval = -1;
      this.registerKeyDownCommand(keystroke(keys.up), this.startIncrement);
      this.registerKeyUpCommand(keystroke(keys.up), this.endIncrement);
      this.registerKeyDownCommand(keystroke(keys.right), this.startIncrement);
      this.registerKeyUpCommand(keystroke(keys.right), this.endIncrement);
      this.registerKeyDownCommand(keystroke(keys.down), this.startDecrement);
      this.registerKeyUpCommand(keystroke(keys.down), this.endDecrement);
      this.registerKeyDownCommand(keystroke(keys.left), this.startDecrement);
      this.registerKeyUpCommand(keystroke(keys.left), this.endDecrement);
      this.hideTarget();
    }
    NumericWidget.prototype.cleanValue = function(value, min, max, step) {
      if (value < min) {
        value = min;
      } else if (value > max) {
        value = max;
      }
      return value - (value % step);
    };
    NumericWidget.prototype.increment = function() {
      return this.set("value", this.get("value") + this.get("step"));
    };
    NumericWidget.prototype.decrement = function() {
      return this.set("value", this.get("value") - this.get("step"));
    };
    NumericWidget.prototype.startIncrement = function() {
      if (!this.cantInteract()) {
        if (this.incrementInterval === -1) {
          this.incrementInterval = setInterval(__bind(function() {
            return this.increment();
          }, this), 50);
        }
      }
      return false;
    };
    NumericWidget.prototype.startDecrement = function() {
      if (!this.cantInteract()) {
        if (this.incrementInterval === -1) {
          this.incrementInterval = setInterval(__bind(function() {
            return this.decrement();
          }, this), 50);
        }
      }
      return false;
    };
    NumericWidget.prototype.endIncrement = function() {
      clearInterval(this.incrementInterval);
      return this.incrementInterval = -1;
    };
    NumericWidget.prototype.endDecrement = function() {
      clearInterval(this.incrementInterval);
      return this.incrementInterval = -1;
    };
    NumericWidget.prototype.updateDummy = function(value, min, max, step) {};
    NumericWidget.prototype.set_value = function(property, value) {
      var max, min, step;
      min = this.get("min");
      max = this.get("max");
      step = this.get("step");
      value = this.cleanValue(value, min, max, step);
      this.updateDummy(value, min, max, step);
      return NumericWidget.__super__.set_value.call(this, property, value);
    };
    NumericWidget.prototype.mousewheel = function(event, delta, deltaX, deltaY) {
      if (!(this.get("readonly") || this.get("disabled"))) {
        this.set("value", this.get("value") + delta * this.get("step"));
      }
      return false;
    };
    NumericWidget.prototype.set_min = function(property, value) {
      var max, step;
      max = this.get("max");
      if (value >= max) {
        return this.get("min");
      } else {
        step = this.get("step");
        this.valueToAttribute(property, value);
        this.set("value", this.cleanValue(this.get("value"), value, max, step));
        return value;
      }
    };
    NumericWidget.prototype.set_max = function(property, value) {
      var min, step;
      min = this.get("min");
      if (value <= min) {
        return this.get("max");
      } else {
        step = this.get("step");
        this.valueToAttribute(property, value);
        this.set("value", this.cleanValue(this.get("value"), min, value, step));
        return value;
      }
    };
    NumericWidget.prototype.set_step = function(property, value) {
      var max, min;
      min = this.get("min");
      max = this.get("max");
      this.valueToAttribute(property, value);
      this.set("value", this.cleanValue(this.get("value"), min, max, value));
      return value;
    };
    return NumericWidget;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.NumericWidget = NumericWidget;
  }
  Slider = (function() {
    __extends(Slider, NumericWidget);
    function Slider(target) {
      Slider.__super__.constructor.call(this, target);
      this.draggingKnob = false;
      this.lastMouseX = 0;
      this.lastMouseY = 0;
      this.valueCenteredOnKnob = true;
      if (this.hasDummy) {
        this.updateDummy(this.get("value"), this.get("min"), this.get("max"));
      }
    }
    Slider.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "range")) {
        throw "Slider target must be an input with a range type";
      }
    };
    Slider.prototype.startDrag = function(e) {
      this.draggingKnob = true;
      this.lastMouseX = e.pageX;
      this.lastMouseY = e.pageY;
      $(document).bind("mouseup", this.documentMouseUpDelegate = __bind(function(e) {
        return this.endDrag();
      }, this));
      return $(document).bind("mousemove", this.documentMouseMoveDelegate = __bind(function(e) {
        return this.drag(e);
      }, this));
    };
    Slider.prototype.drag = function(e) {
      var change, data, knob, knobWidth, max, min, normalizedValue, width;
      data = this.getDragDataFromEvent(e);
      width = this.dummy.width();
      knob = this.dummy.children(".knob");
      knobWidth = knob.width();
      normalizedValue = data.x / (width - knobWidth);
      min = this.get("min");
      max = this.get("max");
      change = Math.round(normalizedValue * (max - min));
      this.set("value", this.get("value") + change);
      this.lastMouseX = e.pageX;
      return this.lastMouseY = e.pageY;
    };
    Slider.prototype.endDrag = function() {
      this.draggingKnob = false;
      $(document).unbind("mousemove", this.documentMouseMoveDelegate);
      return $(document).unbind("mouseup", this.documentMouseUpDelegate);
    };
    Slider.prototype.getDragDataFromEvent = function(e) {
      return {
        x: e.pageX - this.lastMouseX,
        y: e.pageY - this.lastMouseY
      };
    };
    Slider.prototype.handleKnobMouseDown = function(e) {
      if (!this.cantInteract()) {
        this.startDrag(e);
        this.grabFocus();
        return e.preventDefault();
      }
    };
    Slider.prototype.handleTrackMouseDown = function(e) {
      var max, min, track, v, x;
      if (!this.cantInteract()) {
        track = this.dummy.children(".track");
        min = this.get("min");
        max = this.get("max");
        x = e.pageX - this.dummy.offset().left;
        v = x / track.width();
        this.set("value", min + max * v);
        return this.handleKnobMouseDown(e);
      }
    };
    Slider.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='slider'>                        <span class='track'></span>                        <span class='knob'></span>                        <span class='value'></span>                    </span>");
      dummy.children(".knob").bind("mousedown", __bind(function(e) {
        return this.handleKnobMouseDown(e);
      }, this));
      dummy.children(".track").bind("mousedown", __bind(function(e) {
        return this.handleTrackMouseDown(e);
      }, this));
      return dummy;
    };
    Slider.prototype.updateDummy = function(value, min, max, step) {
      var knob, knobPos, knobWidth, val, valPos, valWidth, width;
      width = this.dummy.width();
      knob = this.dummy.children(".knob");
      val = this.dummy.children(".value");
      knobWidth = knob.width();
      valWidth = val.width();
      knobPos = (width - knobWidth) * ((value - min) / (max - min));
      knob.css("left", knobPos);
      val.text(value);
      if (this.valueCenteredOnKnob) {
        valPos = (knobPos + knobWidth / 2) - valWidth / 2;
        return val.css("left", valPos);
      } else {
        return val.css("left", "auto");
      }
    };
    return Slider;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Slider = Slider;
  }
  Stepper = (function() {
    __extends(Stepper, NumericWidget);
    function Stepper(target) {
      Stepper.__super__.constructor.call(this, target);
      this.updateDummy(this.get("value"), this.get("min"), this.get("max"), this.get("step"));
    }
    Stepper.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "number")) {
        throw "Stepper target must be an input with a number type";
      }
    };
    Stepper.prototype.createDummy = function() {
      var down, dummy, input, up;
      dummy = $("<span class='stepper'>				<input type='text' class='value'></input>				<span class='down'></span>				<span class='up'></span>		   </span>");
      input = dummy.children("input");
      down = dummy.children(".down");
      up = dummy.children(".up");
      input.bind("change", __bind(function() {
        return this.validateInput();
      }, this));
      down.bind("mousedown", __bind(function() {
        return this.startDecrement();
      }, this));
      down.bind("mouseup", __bind(function() {
        return this.endDecrement();
      }, this));
      up.bind("mousedown", __bind(function() {
        return this.startIncrement();
      }, this));
      up.bind("mouseup", __bind(function() {
        return this.endIncrement();
      }, this));
      return dummy;
    };
    Stepper.prototype.updateStates = function() {
      var input;
      Stepper.__super__.updateStates.call(this);
      input = this.dummy.children(".value");
      if (this.get("readonly")) {
        input.attr("readonly", "readonly");
      } else {
        input.removeAttr("readonly");
      }
      if (this.get("disabled")) {
        return input.attr("disabled", "disabled");
      } else {
        return input.removeAttr("disabled");
      }
    };
    Stepper.prototype.updateDummy = function(value, min, max, step) {
      var input;
      input = this.dummy.children(".value");
      return input.attr("value", value);
    };
    Stepper.prototype.inputSupportedEvents = "focus blur keyup keydown keypress";
    Stepper.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick";
    Stepper.prototype.registerToDummyEvents = function() {
      this.dummy.children(".value").bind(this.inputSupportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
      return Stepper.__super__.registerToDummyEvents.call(this);
    };
    Stepper.prototype.unregisterFromDummyEvents = function() {
      this.dummy.children(".value").unbind(this.inputSupportedEvents);
      return Stepper.__super__.unregisterFromDummyEvents.call(this);
    };
    Stepper.prototype.validateInput = function() {
      var value;
      value = parseFloat(this.dummy.children("input").attr("value"));
      if (!isNaN(value)) {
        return this.set("value", value);
      } else {
        return this.updateDummy(this.get("value"), this.get("min"), this.get("max"), this.get("step"));
      }
    };
    Stepper.prototype.setFocusable = function() {};
    Stepper.prototype.grabFocus = function() {
      return this.dummy.children(".value").focus();
    };
    Stepper.prototype.mouseup = function() {
      this.grabFocus();
      return true;
    };
    return Stepper;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Stepper = Stepper;
  }
  FilePicker = (function() {
    __extends(FilePicker, Widget);
    function FilePicker(target) {
      if (target == null) {
        target = $("<input type='file'></input>")[0];
      }
      FilePicker.__super__.constructor.call(this, target);
      if (this.cantInteract()) {
        this.hideTarget();
      }
      this.jTarget.bind("change", __bind(function(e) {
        return this.targetChange(e);
      }, this));
    }
    FilePicker.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "file")) {
        throw "FilePicker must have an input file as target";
      }
    };
    FilePicker.prototype.showTarget = function() {
      if (this.hasTarget) {
        return this.jTarget.show();
      }
    };
    FilePicker.prototype.targetChange = function(e) {
      this.setValueLabel(this.jTarget.val() != null ? this.jTarget.val() : "Browse");
      return this.dummy.attr("title", this.jTarget.val());
    };
    FilePicker.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='filepicker'>                    <span class='icon'></span>                    <span class='value'>Browse</span>                 </span>");
      dummy.append(this.jTarget);
      return dummy;
    };
    FilePicker.prototype.setValueLabel = function(label) {
      return this.dummy.children(".value").text(label);
    };
    FilePicker.prototype.set_disabled = function(property, value) {
      if (value) {
        this.hideTarget();
      } else if (!this.get("readonly")) {
        this.showTarget();
      }
      return FilePicker.__super__.set_disabled.call(this, property, value);
    };
    FilePicker.prototype.set_readonly = function(property, value) {
      if (value) {
        this.hideTarget();
      } else if (!this.get("disabled")) {
        this.showTarget();
      }
      return FilePicker.__super__.set_readonly.call(this, property, value);
    };
    FilePicker.prototype.inputSupportedEvents = "focus blur keyup keydown keypress";
    FilePicker.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick";
    FilePicker.prototype.registerToDummyEvents = function() {
      this.jTarget.bind(this.inputSupportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
      return FilePicker.__super__.registerToDummyEvents.call(this);
    };
    FilePicker.prototype.unregisterFromDummyEvents = function() {
      this.jTarget.unbind(this.inputSupportedEvents);
      return FilePicker.__super__.unregisterFromDummyEvents.call(this);
    };
    FilePicker.prototype.setFocusable = function() {};
    FilePicker.prototype.grabFocus = function() {
      return this.jTarget.focus();
    };
    return FilePicker;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.FilePicker = FilePicker;
  }
  MenuModel = (function() {
    function MenuModel() {
      var items;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.contentChanged = new Signal;
      this.items = this.filterValidActions(items);
    }
    MenuModel.prototype.add = function() {
      var items;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.items = this.items.concat(this.filterValidActions(items));
      return this.contentChanged.dispatch(this);
    };
    MenuModel.prototype.remove = function() {
      var action, items;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.items = (function() {
        var _i, _len, _ref, _results;
        _ref = this.items;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          action = _ref[_i];
          if (__indexOf.call(items, action) < 0) {
            _results.push(action);
          }
        }
        return _results;
      }).call(this);
      return this.contentChanged.dispatch(this);
    };
    MenuModel.prototype.size = function() {
      return this.items.length;
    };
    MenuModel.prototype.filterValidActions = function(items) {
      var action, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        action = items[_i];
        if (this.isValidAction(action)) {
          _results.push(action);
        }
      }
      return _results;
    };
    MenuModel.prototype.isValidAction = function(action) {
      return (action != null) && (action.display != null) && (!(action.action != null) || $.isFunction(action.action));
    };
    return MenuModel;
  })();
  MenuList = (function() {
    __extends(MenuList, Widget);
    function MenuList(model) {
      MenuList.__super__.constructor.call(this);
      this.selectedIndex = -1;
      this.createProperty("model");
      this.set("model", model);
      this.parentList = null;
      this.childList = null;
      this.registerKeyDownCommand(keystroke(keys.enter), this.triggerAction);
      this.registerKeyDownCommand(keystroke(keys.space), this.triggerAction);
      this.registerKeyDownCommand(keystroke(keys.up), this.moveSelectionUp);
      this.registerKeyDownCommand(keystroke(keys.down), this.moveSelectionDown);
      this.registerKeyDownCommand(keystroke(keys.right), this.moveSelectionRight);
      this.registerKeyDownCommand(keystroke(keys.left), this.moveSelectionLeft);
    }
    MenuList.prototype.set_model = function(property, value) {
      var _ref;
      this.clearList();
      if ((_ref = this.properties[property]) != null) {
        _ref.contentChanged.remove(this.modelChanged, this);
      }
      if (value != null) {
        value.contentChanged.add(this.modelChanged, this);
      }
      this.buildList(value);
      return value;
    };
    MenuList.prototype.close = function() {
      var _ref;
      this.dummy.blur();
      this.dummy.detach();
      return (_ref = this.childList) != null ? _ref.close() : void 0;
    };
    MenuList.prototype.select = function(index) {
      var act, item;
      if (this.selectedIndex !== -1) {
        this.getItemAt(this.selectedIndex).removeClass("selected");
      }
      this.selectedIndex = index;
      if (this.selectedIndex !== -1) {
        item = this.getItemAt(this.selectedIndex);
        item.addClass("selected");
        act = this.get("model").items[index];
        if (act.menu != null) {
          this.openChildList(act.menu, item);
        } else if (this.isChildListVisible()) {
          this.closeChildList();
        }
      }
      if (!this.hasFocus) {
        return this.grabFocus();
      }
    };
    MenuList.prototype.createDummy = function() {
      return $("<ul class='menulist'></ul>");
    };
    MenuList.prototype.clearList = function() {
      return this.dummy.children().remove();
    };
    MenuList.prototype.buildList = function(model) {
      var act, item, _i, _len, _ref;
      _ref = model.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        act = _ref[_i];
        if (act.menu != null) {
          item = $("<li class='menu'>" + act.display + "</li>");
        } else {
          item = $("<li class='menuitem'>" + act.display + "</li>");
        }
        this.dummy.append(item);
      }
      return this.dummy.children().each(__bind(function(i, o) {
        var a;
        item = $(o);
        a = model.items[i];
        item.mouseup(__bind(function(e) {
          if (!this.cantInteract()) {
            if (a.action != null) {
              return a.action();
            }
          }
        }, this));
        return item.mouseover(__bind(function(e) {
          if (!this.cantInteract()) {
            return this.select(i);
          }
        }, this));
      }, this));
    };
    MenuList.prototype.isChildListVisible = function() {
      var _ref;
      return ((_ref = this.childList) != null ? _ref.dummy.parent().length : void 0) === 1;
    };
    MenuList.prototype.closeChildList = function() {
      var _ref;
      if ((_ref = this.childList) != null) {
        _ref.close();
      }
      return this.grabFocus();
    };
    MenuList.prototype.mousedown = function(e) {
      return e.stopImmediatePropagation();
    };
    MenuList.prototype.openChildList = function(model, item) {
      var left, top;
      if (this.childList == null) {
        this.childList = new MenuList(new MenuModel);
        this.childList.parentList = this;
      }
      if (this.childList.hasFocus) {
        this.childList.dummy.blur();
      }
      if (!this.isChildListVisible()) {
        this.dummy.after(this.childList.dummy);
      }
      if (this.childList.get("model") !== model) {
        this.childList.set("model", model);
      }
      left = this.dummy.offset().left + this.dummy.width();
      top = item.offset().top;
      return this.childList.dummy.attr("style", "left: " + left + "px; top: " + top + "px;");
    };
    MenuList.prototype.triggerAction = function() {
      var item;
      if (this.selectedIndex !== -1) {
        item = this.get("model").items[this.selectedIndex];
        if (item.action != null) {
          return item.action();
        }
      }
    };
    MenuList.prototype.getItemAt = function(index) {
      return $(this.dummy.children("li")[index]);
    };
    MenuList.prototype.modelChanged = function(model) {
      this.clearList();
      return this.buildList(model);
    };
    MenuList.prototype.moveSelectionUp = function(e) {
      var newIndex;
      e.preventDefault();
      if (!this.cantInteract()) {
        newIndex = this.selectedIndex - 1;
        if (newIndex < 0) {
          newIndex = this.get("model").size() - 1;
        }
        return this.select(newIndex);
      }
    };
    MenuList.prototype.moveSelectionDown = function(e) {
      var newIndex;
      e.preventDefault();
      if (!this.cantInteract()) {
        newIndex = this.selectedIndex + 1;
        if (newIndex >= this.get("model").size()) {
          newIndex = 0;
        }
        return this.select(newIndex);
      }
    };
    MenuList.prototype.moveSelectionRight = function(e) {
      e.preventDefault();
      if (!this.cantInteract()) {
        if (this.isChildListVisible) {
          return this.childList.grabFocus();
        }
      }
    };
    MenuList.prototype.moveSelectionLeft = function(e) {
      var _ref;
      e.preventDefault();
      if (!this.cantInteract()) {
        this.dummy.blur();
        return (_ref = this.parentList) != null ? _ref.grabFocus() : void 0;
      }
    };
    return MenuList;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.MenuModel = MenuModel;
    window.MenuList = MenuList;
  }
  SingleSelect = (function() {
    __extends(SingleSelect, Widget);
    function SingleSelect(target) {
      SingleSelect.__super__.constructor.call(this, target);
      if (this.hasTarget) {
        this.model = this.buildModel(new MenuModel, this.jTarget.children());
        this.selectedPath = this.findValue(this.get("value"));
      } else {
        this.model = new MenuModel;
        this.selectedPath = null;
      }
      this.model.contentChanged.add(this.modelChanged, this);
      this.buildMenu();
      this.hideTarget();
      this.updateDummy();
      this.registerKeyDownCommand(keystroke(keys.enter), this.openMenu);
      this.registerKeyDownCommand(keystroke(keys.space), this.openMenu);
      this.registerKeyDownCommand(keystroke(keys.up), this.moveSelectionUp);
      this.registerKeyDownCommand(keystroke(keys.down), this.moveSelectionDown);
    }
    SingleSelect.prototype.checkTarget = function(target) {
      if (!this.isTag(target, "select") || ($(target).attr("multiple") != null)) {
        throw "A SingleSelect only allow select nodes as target";
      }
    };
    SingleSelect.prototype.clearOptions = function() {
      return this.jTarget.children().remove();
    };
    SingleSelect.prototype.buildOptions = function(model, target) {
      var act, group, _i, _len, _ref, _results;
      if (model == null) {
        model = this.model;
      }
      if (target == null) {
        target = this.jTarget;
      }
      _ref = model.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        act = _ref[_i];
        _results.push(act.menu != null ? (group = $("<optgroup label='" + act.display + "'></optgroup>"), target.append(group), this.buildOptions(act.menu, group)) : (act.action == null ? act.action = __bind(function() {
          return this.set("value", act.value);
        }, this) : void 0, target.append($("<option value='" + act.value + "'>" + act.display + "</option>"))));
      }
      return _results;
    };
    SingleSelect.prototype.updateOptionSelection = function() {
      var _ref;
      return (_ref = this.getOptionAt(this.selectedPath)) != null ? _ref.attr("selected", "selected") : void 0;
    };
    SingleSelect.prototype.getOptionLabel = function(option) {
      if (option == null) {
        return null;
      }
      if (option.attr("label")) {
        return option.attr("label");
      } else {
        return option.text();
      }
    };
    SingleSelect.prototype.getOptionValue = function(option) {
      if (option == null) {
        return null;
      }
      if (option.attr("value")) {
        return option.attr("value");
      } else {
        return option.text();
      }
    };
    SingleSelect.prototype.getOptionAt = function(path) {
      var children, option, step, _i, _len;
      if (path === null) {
        return null;
      }
      option = null;
      if (this.hasTarget) {
        children = this.jTarget.children();
        for (_i = 0, _len = path.length; _i < _len; _i++) {
          step = path[_i];
          option = children[step];
          if (option != null ? option.nodeName : void 0) {
            children = $(option).children();
          }
        }
      }
      if (option != null) {
        return $(option);
      } else {
        return null;
      }
    };
    SingleSelect.prototype.createDummy = function() {
      return $("<span class='single-select'>               <span class='value'></span>           </span>");
    };
    SingleSelect.prototype.updateDummy = function() {
      var display, _ref;
      if (this.selectedPath !== null) {
        display = (_ref = this.getItemAt(this.selectedPath)) != null ? _ref.display : void 0;
      } else {
        display = this.hasTarget && this.jTarget.attr("title") ? this.jTarget.attr("title") : "Empty";
      }
      this.dummy.find(".value").remove();
      return this.dummy.append($("<span class='value'>" + display + "</span>"));
    };
    SingleSelect.prototype.buildModel = function(model, node) {
      node.each(__bind(function(i, o) {
        var option, value;
        option = $(o);
        if (o.nodeName.toLowerCase() === "optgroup") {
          return model.add({
            display: this.getOptionLabel(option),
            menu: this.buildModel(new MenuModel, option.children())
          });
        } else {
          value = this.getOptionValue(option);
          return model.add({
            display: this.getOptionLabel(option),
            value: value,
            action: __bind(function() {
              return this.set("value", value);
            }, this)
          });
        }
      }, this));
      return model;
    };
    SingleSelect.prototype.getItemAt = function(path) {
      var item, model, step, _i, _len;
      if (path === null) {
        return null;
      }
      model = this.model;
      item = null;
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        step = path[_i];
        item = model.items[step];
        if (item == null) {
          return null;
        }
        if ((item != null ? item.menu : void 0) != null) {
          model = item.menu;
        }
      }
      return item;
    };
    SingleSelect.prototype.findValue = function(value, model) {
      var item, passResults, subPassResults, _i, _len, _ref;
      if (model == null) {
        model = this.model;
      }
      if (!(value != null) || value === "") {
        return null;
      }
      passResults = null;
      _ref = model.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (item.value === value) {
          passResults = [_i];
          break;
        } else if (item.menu != null) {
          subPassResults = this.findValue(value, item.menu);
          if (subPassResults != null) {
            passResults = [_i].concat(subPassResults);
            break;
          }
        }
      }
      return passResults;
    };
    SingleSelect.prototype.getModelAt = function(path) {
      var item, model, step, _i, _len;
      if (path === null) {
        return null;
      }
      model = this.model;
      item = null;
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        step = path[_i];
        item = model.items[step];
        if (item == null) {
          return null;
        }
        if ((item != null ? item.menu : void 0) != null) {
          model = item.menu;
        }
      }
      return model;
    };
    SingleSelect.prototype.buildMenu = function() {
      return this.menuList = new MenuList(this.model);
    };
    SingleSelect.prototype.openMenu = function() {
      var left, list, step, top, _i, _len, _ref, _results;
      if (!this.cantInteract()) {
        ($(document)).bind("mousedown", this.documentDelegate = __bind(function(e) {
          return this.documentMouseDown(e);
        }, this));
        this.dummy.after(this.menuList.dummy);
        left = this.dummy.offset().left;
        top = this.dummy.offset().top + this.dummy.height();
        this.menuList.dummy.attr("style", "left: " + left + "px; top: " + top + "px;");
        this.menuList.grabFocus();
        if (this.selectedPath !== null) {
          list = this.menuList;
          _ref = this.selectedPath;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            step = _ref[_i];
            list.select(step);
            _results.push(list.childList ? list = list.childList : void 0);
          }
          return _results;
        }
      }
    };
    SingleSelect.prototype.closeMenu = function() {
      this.menuList.close();
      this.grabFocus();
      return $(document).unbind("mousedown", this.documentDelegate);
    };
    SingleSelect.prototype.isMenuVisible = function() {
      return this.menuList.dummy.parent().length === 1;
    };
    SingleSelect.prototype.moveSelectionUp = function(e) {
      e.preventDefault();
      if (!this.cantInteract()) {
        this.selectedPath = this.findPrevious(this.selectedPath);
        return this.set("value", this.getOptionValue(this.getOptionAt(this.selectedPath)));
      }
    };
    SingleSelect.prototype.moveSelectionDown = function(e) {
      e.preventDefault();
      if (!this.cantInteract()) {
        this.selectedPath = this.findNext(this.selectedPath);
        return this.set("value", this.getOptionValue(this.getOptionAt(this.selectedPath)));
      }
    };
    SingleSelect.prototype.findNext = function(path) {
      var model, newPath, nextItem, step;
      model = this.getModelAt(path);
      step = path.length - 1;
      newPath = path.concat();
      newPath[step]++;
      nextItem = this.getItemAt(newPath);
      while (!(nextItem != null) || (nextItem.menu != null)) {
        if (nextItem != null) {
          if (nextItem.menu != null) {
            newPath.push(0);
            step++;
          }
        } else if (step > 0) {
          step--;
          newPath.pop();
          newPath[step]++;
          nextItem = this.getItemAt(newPath);
        } else {
          newPath = [0];
        }
        nextItem = this.getItemAt(newPath);
      }
      return newPath;
    };
    SingleSelect.prototype.findPrevious = function(path) {
      var model, newPath, nextItem, step;
      model = this.getModelAt(path);
      step = path.length - 1;
      newPath = path.concat();
      newPath[step]--;
      nextItem = this.getItemAt(newPath);
      while (!(nextItem != null) || (nextItem.menu != null)) {
        if (nextItem != null) {
          if (nextItem.menu != null) {
            newPath.push(0);
            step++;
            newPath[step] = this.getModelAt(newPath).size() - 1;
          }
        } else if (step > 0) {
          step--;
          newPath.pop();
          newPath[step]--;
          nextItem = this.getItemAt(newPath);
        } else {
          newPath = [this.model.items.length - 1];
        }
        nextItem = this.getItemAt(newPath);
      }
      return newPath;
    };
    SingleSelect.prototype.set_value = function(property, value) {
      var newPath, newValue, oldValue;
      oldValue = this.get("value");
      newValue = null;
      newPath = this.findValue(value);
      if (newPath !== null) {
        this.selectedPath = newPath;
        newValue = value;
      }
      if (this.hasTarget) {
        this.updateOptionSelection();
      }
      this.updateDummy();
      if (this.isMenuVisible()) {
        this.closeMenu();
      }
      if ((newValue != null) !== null) {
        return newValue;
      } else {
        return oldValue;
      }
    };
    SingleSelect.prototype.modelChanged = function(model) {
      if (this.getItemAt(this.selectedPath) == null) {
        this.selectedPath = this.findNext([0]);
        this.properties["value"] = this.getItemAt(this.selectedPath).value;
      }
      if (this.hasTarget) {
        this.clearOptions();
        this.buildOptions();
        return this.updateOptionSelection();
      }
    };
    SingleSelect.prototype.mousedown = function(e) {
      if (!this.cantInteract()) {
        e.preventDefault();
        e.stopImmediatePropagation();
        if (this.isMenuVisible()) {
          return this.closeMenu();
        } else {
          return this.openMenu();
        }
      }
    };
    SingleSelect.prototype.documentMouseDown = function(e) {
      return this.closeMenu();
    };
    return SingleSelect;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.SingleSelect = SingleSelect;
  }
  rgb2hex = function(r, g, b) {
    var rnd, value;
    rnd = Math.round;
    value = ((rnd(r) << 16) + (rnd(g) << 8) + rnd(b)).toString(16);
    while (value.length < 6) {
      value = "0" + value;
    }
    return value;
  };
  hex2rgb = function(hex) {
    var b, color, g, r, rgb;
    rgb = hex.substr(1);
    color = parseInt(rgb, 16);
    r = (color >> 16) & 0xff;
    g = (color >> 8) & 0xff;
    b = color & 0xff;
    return [r, g, b];
  };
  hsv2rgb = function(h, s, v) {
    var b, g, r, rnd, var_1, var_2, var_3, var_h, var_i;
    h = h / 360;
    s = s / 100;
    v = v / 100;
    rnd = Math.round;
    if (s === 0) {
      return [rnd(v * 255, rnd(v * 255, rnd(v * 255)))];
    } else {
      var_h = h * 6;
      var_i = Math.floor(var_h);
      var_1 = v * (1 - s);
      var_2 = v * (1 - s * (var_h - var_i));
      var_3 = v * (1 - s * (1 - (var_h - var_i)));
      switch (var_i) {
        case 0:
          r = v;
          g = var_3;
          b = var_1;
          break;
        case 1:
          r = var_2;
          g = v;
          b = var_1;
          break;
        case 2:
          r = var_1;
          g = v;
          b = var_3;
          break;
        case 3:
          r = var_1;
          g = var_2;
          b = v;
          break;
        case 4:
          r = var_3;
          g = var_1;
          b = v;
          break;
        default:
          r = v;
          g = var_1;
          b = var_2;
      }
      return [r * 255, g * 255, b * 255];
    }
  };
  rgb2hsv = function(r, g, b) {
    var del_B, del_G, del_R, delta, h, maxVal, minVal, rnd, s, v;
    r = r / 255;
    g = g / 255;
    b = b / 255;
    rnd = Math.round;
    minVal = Math.min(r, g, b);
    maxVal = Math.max(r, g, b);
    delta = maxVal - minVal;
    v = maxVal;
    if (delta === 0) {
      h = 0;
      s = 0;
    } else {
      s = delta / maxVal;
      del_R = (((maxVal - r) / 6) + (delta / 2)) / delta;
      del_G = (((maxVal - g) / 6) + (delta / 2)) / delta;
      del_B = (((maxVal - b) / 6) + (delta / 2)) / delta;
      if (r === maxVal) {
        h = del_B - del_G;
      } else if (g === maxVal) {
        h = (1 / 3) + del_R - del_B;
      } else if (b === maxVal) {
        h = (2 / 3) + del_G - del_R;
      }
      if (h < 0) {
        h += 1;
      }
      if (h > 1) {
        h -= 1;
      }
    }
    return [h * 360, s * 100, v * 100];
  };
  colorObjectFromValue = function(value) {
    var b, g, r, _ref;
    _ref = hex2rgb(value), r = _ref[0], g = _ref[1], b = _ref[2];
    return {
      red: r,
      green: g,
      blue: b
    };
  };
  colorObjectToValue = function(rgb) {
    return rgb2hex(rgb.red, rgb.green, rgb.blue);
  };
  isSafeValue = function(value) {
    var re;
    re = /^\#[0-9a-fA-F]{6}$/;
    return re.test(value);
  };
  isSafeNumber = function(value) {
    return (value != null) && !isNaN(value);
  };
  isSafeHue = function(value) {
    return (isSafeNumber(value)) && (0 <= value && value <= 360);
  };
  isSafePercentage = function(value) {
    return (isSafeNumber(value)) && (0 <= value && value <= 100);
  };
  isSafeChannel = function(value) {
    return (isSafeNumber(value)) && (0 <= value && value <= 255);
  };
  isSafeColor = function(value) {
    return (value != null) && (isSafeChannel(value.red)) && (isSafeChannel(value.green)) && (isSafeChannel(value.blue));
  };
  isSafeRGB = function(r, g, b) {
    return (isSafeChannel(r)) && (isSafeChannel(g)) && (isSafeChannel(b));
  };
  isSafeHSV = function(h, s, v) {
    return (isSafeHue(h)) && (isSafePercentage(s)) && (isSafePercentage(v));
  };
  ColorPicker = (function() {
    __extends(ColorPicker, Widget);
    function ColorPicker(target) {
      var value;
      ColorPicker.__super__.constructor.call(this, target);
      this.dialogRequested = new Signal;
      value = this.valueFromAttribute("value");
      if (!isSafeValue(value)) {
        value = "#000000";
      }
      this.properties["value"] = value;
      this.createProperty("color", colorObjectFromValue(value));
      this.dialogRequested.add(ColorPicker.defaultListener.dialogRequested, ColorPicker.defaultListener);
      this.updateDummy(value);
      this.hideTarget();
      this.registerKeyDownCommand(keystroke(keys.space), this.click);
      this.registerKeyDownCommand(keystroke(keys.enter), this.click);
    }
    ColorPicker.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "color")) {
        throw "ColorPicker's target should be a color input";
      }
    };
    ColorPicker.prototype.createDummy = function() {
      return $("<span class='colorpicker'>               <span class='color'></span>           </span>");
    };
    ColorPicker.prototype.updateDummy = function(value) {
      var b, colorPreview, g, h, r, s, textColor, v, _ref, _ref2;
      if (this.hasDummy) {
        colorPreview = this.dummy.children(".color");
        _ref = this.get("color"), r = _ref.red, g = _ref.green, b = _ref.blue;
        _ref2 = rgb2hsv(r, g, b), h = _ref2[0], s = _ref2[1], v = _ref2[2];
        textColor = v >= 50 ? "#000000" : "#ffffff";
        colorPreview.text(value);
        return colorPreview.attr("style", "background: " + value + "; color: " + textColor + ";");
      }
    };
    ColorPicker.prototype.set_color = function(property, value) {
      var rgb;
      if (!isSafeColor(value)) {
        return this.get("color");
      }
      rgb = colorObjectToValue(value);
      this.set("value", "#" + rgb);
      return this.properties["color"] = value;
    };
    ColorPicker.prototype.set_value = function(property, value) {
      if (!isSafeValue(value)) {
        return this.get("value");
      }
      this.properties["color"] = colorObjectFromValue(value);
      this.updateDummy(value);
      return ColorPicker.__super__.set_value.call(this, property, value);
    };
    ColorPicker.prototype.click = function(e) {
      if (!this.cantInteract()) {
        return this.dialogRequested.dispatch(this);
      }
    };
    return ColorPicker;
  })();
  SquarePicker = (function() {
    __extends(SquarePicker, Widget);
    function SquarePicker() {
      SquarePicker.__super__.constructor.call(this);
      this.createProperty("rangeX", [0, 1]);
      this.createProperty("rangeY", [0, 1]);
      this.set("value", [0, 0]);
      this.dragging = false;
      this.xLocked = false;
      this.yLocked = false;
    }
    SquarePicker.prototype.lockX = function() {
      return this.xLocked = true;
    };
    SquarePicker.prototype.unlockX = function() {
      return this.xLocked = false;
    };
    SquarePicker.prototype.lockY = function() {
      return this.yLocked = true;
    };
    SquarePicker.prototype.unlockY = function() {
      return this.yLocked = false;
    };
    SquarePicker.prototype.createDummy = function() {
      return $("<span class='gridpicker'>               <span class='cursor'></span>           </span>");
    };
    SquarePicker.prototype.updateDummy = function(x, y) {
      var ch, cursor, cw, h, left, rx, ry, top, w, xmax, xmin, ymax, ymin, _ref, _ref2;
      cursor = this.dummy.children(".cursor");
      w = this.dummy.width();
      h = this.dummy.height();
      cw = cursor.width();
      ch = cursor.height();
      _ref = this.get("rangeX"), xmin = _ref[0], xmax = _ref[1];
      _ref2 = this.get("rangeY"), ymin = _ref2[0], ymax = _ref2[1];
      rx = (x - xmin) / (xmax - xmin);
      ry = (y - ymin) / (ymax - ymin);
      left = Math.floor(rx * w - (cw / 2));
      top = Math.floor(ry * h - (ch / 2));
      cursor.css("left", "" + left + "px");
      return cursor.css("top", "" + top + "px");
    };
    SquarePicker.prototype.set_rangeX = function(property, value) {
      if (!this.isValidRange(value)) {
        return this.get(property);
      }
      return value;
    };
    SquarePicker.prototype.set_rangeY = function(property, value) {
      if (!this.isValidRange(value)) {
        return this.get(property);
      }
      return value;
    };
    SquarePicker.prototype.set_value = function(property, value) {
      var v, x, y;
      if (!((value != null) && typeof value === "object" && value.length === 2 && this.isValid(value[0], "rangeX") && this.isValid(value[1], "rangeY"))) {
        return this.get("value");
      }
      v = this.get("value");
      x = value[0], y = value[1];
      if (this.xLocked) {
        x = v[0];
      }
      if (this.yLocked) {
        y = v[1];
      }
      this.updateDummy(x, y);
      return SquarePicker.__super__.set_value.call(this, property, [x, y]);
    };
    SquarePicker.prototype.handlePropertyChange = function(property, value) {
      var max, min, x, y, _ref, _ref2;
      SquarePicker.__super__.handlePropertyChange.call(this, property, value);
      if (property === "rangeX" || property === "rangeY") {
        _ref = this.get("value"), x = _ref[0], y = _ref[1];
        _ref2 = this.get(property), min = _ref2[0], max = _ref2[1];
        switch (property) {
          case "rangeX":
            if (x > max) {
              x = max;
            } else if (x < min) {
              x = min;
            }
            break;
          case "rangeY":
            if (y > max) {
              y = max;
            } else if (y < min) {
              y = min;
            }
        }
        return this.set("value", [x, y]);
      }
    };
    SquarePicker.prototype.isValid = function(value, range) {
      var max, min, _ref;
      _ref = this.get(range), min = _ref[0], max = _ref[1];
      return (value != null) && !isNaN(value) && (min <= value && value <= max);
    };
    SquarePicker.prototype.isValidRange = function(value) {
      var max, min;
      if (value == null) {
        return false;
      }
      min = value[0], max = value[1];
      return (min != null) && (max != null) && !isNaN(min) && !isNaN(max) && min < max;
    };
    SquarePicker.prototype.mousedown = function(e) {
      if (!this.cantInteract()) {
        this.dragging = true;
        this.drag(e);
        $(document).bind("mouseup", this.documentMouseUpDelegate = __bind(function(e) {
          return this.mouseup(e);
        }, this));
        $(document).bind("mousemove", this.documentMouseMoveDelegate = __bind(function(e) {
          return this.mousemove(e);
        }, this));
      }
      if (!this.get("disabled")) {
        this.grabFocus();
      }
      return false;
    };
    SquarePicker.prototype.mousemove = function(e) {
      if (this.dragging) {
        return this.drag(e);
      }
    };
    SquarePicker.prototype.mouseup = function(e) {
      if (this.dragging) {
        this.drag(e);
        this.dragging = false;
        $(document).unbind("mouseup", this.documentMouseUpDelegate);
        return $(document).unbind("mousemove", this.documentMouseMoveDelegate);
      }
    };
    SquarePicker.prototype.drag = function(e) {
      var h, vx, vy, w, x, xmax, xmin, y, ymax, ymin, _ref, _ref2;
      w = this.dummy.width();
      h = this.dummy.height();
      x = e.pageX - this.dummy.offset().left;
      y = e.pageY - this.dummy.offset().top;
      if (x < 0) {
        x = 0;
      }
      if (x > w) {
        x = w;
      }
      if (y < 0) {
        y = 0;
      }
      if (y > h) {
        y = h;
      }
      _ref = this.get("rangeX"), xmin = _ref[0], xmax = _ref[1];
      _ref2 = this.get("rangeY"), ymin = _ref2[0], ymax = _ref2[1];
      vx = xmin + (x / w) * xmax;
      vy = ymin + (y / h) * ymax;
      return this.set("value", [vx, vy]);
    };
    return SquarePicker;
  })();
  ColorPickerDialog = (function() {
    __extends(ColorPickerDialog, Container);
    function ColorPickerDialog() {
      ColorPickerDialog.__super__.constructor.call(this);
      this.model = {
        r: 0,
        g: 0,
        b: 0,
        h: 0,
        s: 0,
        v: 0
      };
      this.inputValueSetProgrammatically = false;
      this.createProperty("mode");
      this.editModes = [new RGBMode, new GRBMode, new BGRMode, new HSVMode, new SHVMode, new VHSMode];
      this.modesGroup = new RadioGroup;
      this.modesGroup.selectionChanged.add(this.modeChanged, this);
      this.createDummyChildren();
      this.set("mode", this.editModes[3]);
      this.dummy.hide();
      this.registerKeyDownCommand(keystroke(keys.enter), this.comfirmChangesOnEnter);
      this.registerKeyDownCommand(keystroke(keys.escape), this.abortChanges);
    }
    ColorPickerDialog.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='colorpickerdialog'>                      <span class='newColor'></span>                      <span class='oldColor'></span>                   </span>");
      dummy.children(".oldColor").click(__bind(function() {
        return this.set("value", this.originalValue);
      }, this));
      return dummy;
    };
    ColorPickerDialog.prototype.createDummyChildren = function() {
      this.add(this.redInput = this.createInput("red", 3));
      this.add(this.redMode = this.createRadio("red"));
      this.add(this.greenInput = this.createInput("green", 3));
      this.add(this.greenMode = this.createRadio("green"));
      this.add(this.blueInput = this.createInput("blue", 3));
      this.add(this.blueMode = this.createRadio("blue"));
      this.add(this.hueInput = this.createInput("hue", 3));
      this.add(this.hueMode = this.createRadio("hue", true));
      this.add(this.saturationInput = this.createInput("saturation", 3));
      this.add(this.saturationMode = this.createRadio("saturation"));
      this.add(this.valueInput = this.createInput("value", 3));
      this.add(this.valueMode = this.createRadio("value"));
      this.add(this.hexInput = this.createInput("hex", 6));
      this.add(this.squarePicker = new SquarePicker);
      this.add(this.rangePicker = new SquarePicker);
      this.rangePicker.lockX();
      return this.rangePicker.addClasses("vertical");
    };
    ColorPickerDialog.prototype.createInput = function(cls, maxlength) {
      var input;
      input = new TextInput;
      input.addClasses(cls);
      input.set("maxlength", maxlength);
      input.valueChanged.add(__bind(function(w, v) {
        this.inputValueChanged(w, v, cls);
        return true;
      }, this));
      return input;
    };
    ColorPickerDialog.prototype.createRadio = function(cls, checked) {
      var radio;
      if (checked == null) {
        checked = false;
      }
      radio = new Radio;
      radio.addClasses(cls);
      radio.set("checked", checked);
      this.modesGroup.add(radio);
      return radio;
    };
    ColorPickerDialog.prototype.invalidate = function() {
      this.update();
      return setTimeout(__bind(function() {
        return this.update();
      }, this), 10);
    };
    ColorPickerDialog.prototype.update = function() {
      var b, g, h, r, rnd, s, v, value, _ref;
      rnd = Math.round;
      _ref = this.model, r = _ref.r, g = _ref.g, b = _ref.b, h = _ref.h, s = _ref.s, v = _ref.v;
      value = rgb2hex(r, g, b);
      this.properties["value"] = "#" + value;
      this.inputValueSetProgrammatically = true;
      this.get("mode").update(this.model);
      this.updateInput(this.redInput, rnd(r));
      this.updateInput(this.greenInput, rnd(g));
      this.updateInput(this.blueInput, rnd(b));
      this.updateInput(this.hueInput, rnd(h));
      this.updateInput(this.saturationInput, rnd(s));
      this.updateInput(this.valueInput, rnd(v));
      this.updateInput(this.hexInput, value);
      this.inputValueSetProgrammatically = false;
      return this.dummy.children(".newColor").attr("style", "background: #" + value + ";");
    };
    ColorPickerDialog.prototype.updateInput = function(input, value) {
      return input.set("value", value);
    };
    ColorPickerDialog.prototype.comfirmChangesOnEnter = function() {
      if (!(this.redInput.valueIsObsolete || this.greenInput.valueIsObsolete || this.blueInput.valueIsObsolete || this.hueInput.valueIsObsolete || this.saturationInput.valueIsObsolete || this.valueInput.valueIsObsolete || this.hexInput.valueIsObsolete)) {
        return this.comfirmChanges();
      }
    };
    ColorPickerDialog.prototype.comfirmChanges = function() {
      this.currentTarget.set("value", this.get("value"));
      return this.close();
    };
    ColorPickerDialog.prototype.abortChanges = function() {
      return this.close();
    };
    ColorPickerDialog.prototype.close = function() {
      this.dummy.hide();
      ($(document)).unbind("mouseup", this.documentDelegate);
      return this.currentTarget.grabFocus();
    };
    ColorPickerDialog.prototype.set_mode = function(property, value) {
      var oldMode;
      oldMode = this.properties[property];
      if (oldMode != null) {
        oldMode.dispose();
      }
      if (value != null) {
        value.init(this);
        value.update(this.model);
      }
      return value;
    };
    ColorPickerDialog.prototype.set_value = function(property, value) {
      value = ColorPickerDialog.__super__.set_value.call(this, property, value);
      this.fromHex(value);
      return value;
    };
    ColorPickerDialog.prototype.fromHex = function(hex) {
      var b, g, r, v, _ref;
      v = hex.indexOf("#") === -1 ? "#" + hex : hex;
      if (isSafeValue(v)) {
        _ref = colorObjectFromValue(v), r = _ref.red, g = _ref.green, b = _ref.blue;
        return this.fromRGB(r, g, b);
      }
    };
    ColorPickerDialog.prototype.fromRGB = function(r, g, b) {
      var h, s, v, _ref;
      r = parseFloat(r);
      g = parseFloat(g);
      b = parseFloat(b);
      if (isSafeRGB(r, g, b)) {
        _ref = rgb2hsv(r, g, b), h = _ref[0], s = _ref[1], v = _ref[2];
        this.model = {
          r: r,
          g: g,
          b: b,
          h: h,
          s: s,
          v: v
        };
      }
      return this.invalidate();
    };
    ColorPickerDialog.prototype.fromHSV = function(h, s, v) {
      var b, g, r, _ref;
      h = parseFloat(h);
      s = parseFloat(s);
      v = parseFloat(v);
      if (isSafeHSV(h, s, v)) {
        _ref = hsv2rgb(h, s, v), r = _ref[0], g = _ref[1], b = _ref[2];
        this.model = {
          r: r,
          g: g,
          b: b,
          h: h,
          s: s,
          v: v
        };
      }
      return this.invalidate();
    };
    ColorPickerDialog.prototype.modeChanged = function(widget, oldSel, newSel) {
      switch (newSel) {
        case this.redMode:
          return this.set("mode", this.editModes[0]);
        case this.greenMode:
          return this.set("mode", this.editModes[1]);
        case this.blueMode:
          return this.set("mode", this.editModes[2]);
        case this.hueMode:
          return this.set("mode", this.editModes[3]);
        case this.saturationMode:
          return this.set("mode", this.editModes[4]);
        case this.valueMode:
          return this.set("mode", this.editModes[5]);
      }
    };
    ColorPickerDialog.prototype.inputValueChanged = function(widget, value, component) {
      var b, g, h, r, s, v, _ref;
      if (!this.inputValueSetProgrammatically) {
        _ref = this.model, r = _ref.r, g = _ref.g, b = _ref.b, h = _ref.h, s = _ref.s, v = _ref.v;
        switch (component) {
          case "red":
            return this.fromRGB(value, g, b);
          case "green":
            return this.fromRGB(r, value, b);
          case "blue":
            return this.fromRGB(r, g, value);
          case "hue":
            return this.fromHSV(value, s, v);
          case "saturation":
            return this.fromHSV(h, value, v);
          case "value":
            return this.fromHSV(h, s, value);
          case "hex":
            return this.fromHex(value);
        }
      }
    };
    ColorPickerDialog.prototype.dialogRequested = function(colorpicker) {
      var value;
      this.currentTarget = colorpicker;
      this.originalValue = value = this.currentTarget.get("value");
      this.set("value", value);
      ($(document)).bind("mouseup", this.documentDelegate = __bind(function(e) {
        return this.mouseup(e);
      }, this));
      this.dummy.css("left", this.currentTarget.dummy.offset().left).css("top", this.currentTarget.dummy.offset().top + this.currentTarget.dummy.height()).css("position", "absolute").show().children(".oldColor").attr("style", "background: " + value + ";");
      return this.grabFocus();
    };
    ColorPickerDialog.prototype.mouseup = function(e) {
      var h, w, x, y;
      w = this.dummy.width();
      h = this.dummy.height();
      x = e.pageX - this.dummy.offset().left;
      y = e.pageY - this.dummy.offset().top;
      if (!((0 <= x && x <= w) && (0 <= y && y <= h))) {
        return this.comfirmChanges();
      }
    };
    return ColorPickerDialog;
  })();
  AbstractMode = (function() {
    function AbstractMode() {}
    AbstractMode.prototype.init = function(dialog) {
      this.dialog = dialog;
      return this.valuesSetProgrammatically = false;
    };
    AbstractMode.prototype.dispose = function() {
      this.dialog.rangePicker.valueChanged.remove(this.rangeChanged, this);
      this.dialog.squarePicker.valueChanged.remove(this.squareChanged, this);
      this.dialog.rangePicker.dummy.children(".layer").remove();
      return this.dialog.squarePicker.dummy.children(".layer").remove();
    };
    AbstractMode.prototype.initPickers = function(a, b, c, r, s) {
      this.dialog.squarePicker.set({
        rangeX: a,
        rangeY: b
      });
      this.dialog.rangePicker.set({
        rangeY: c
      });
      this.dialog.rangePicker.valueChanged.add(this.rangeChanged, this);
      this.dialog.squarePicker.valueChanged.add(this.squareChanged, this);
      this.dialog.rangePicker.dummy.prepend($(r));
      return this.dialog.squarePicker.dummy.prepend($(s));
    };
    return AbstractMode;
  })();
  HSVMode = (function() {
    __extends(HSVMode, AbstractMode);
    function HSVMode() {
      HSVMode.__super__.constructor.apply(this, arguments);
    }
    HSVMode.prototype.init = function(dialog) {
      HSVMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 100], [0, 100], [0, 360], "<span class='layer hue-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer hue-color'></span>                        <span class='layer white-horizontal-ramp'></span>                        <span class='layer black-vertical-ramp'></span>                     </span>");
    };
    HSVMode.prototype.update = function(model) {
      var b, g, h, r, s, v, value, _ref;
      if (model != null) {
        h = model.h, s = model.s, v = model.v;
        _ref = hsv2rgb(h, 100, 100), r = _ref[0], g = _ref[1], b = _ref[2];
        this.valuesSetProgrammatically = true;
        this.dialog.squarePicker.set("value", [s, 100 - v]);
        this.dialog.rangePicker.set("value", [0, 360 - h]);
        value = rgb2hex(r, g, b);
        this.dialog.squarePicker.dummy.find(".hue-color").attr("style", "background: #" + value + ";");
        return this.valuesSetProgrammatically = false;
      }
    };
    HSVMode.prototype.updateDialog = function(h, s, v) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromHSV(360 - h, s, 100 - v);
      return this.valuesSetProgrammatically = false;
    };
    HSVMode.prototype.squareChanged = function(widget, value) {
      var h, s, v;
      if (!this.valuesSetProgrammatically) {
        s = value[0], v = value[1];
        h = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(h, s, v);
      }
    };
    HSVMode.prototype.rangeChanged = function(widget, value) {
      var h, s, v, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), s = _ref[0], v = _ref[1];
        h = value[1];
        return this.updateDialog(h, s, v);
      }
    };
    return HSVMode;
  })();
  SHVMode = (function() {
    __extends(SHVMode, AbstractMode);
    function SHVMode() {
      SHVMode.__super__.constructor.apply(this, arguments);
    }
    SHVMode.prototype.init = function(dialog) {
      SHVMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 360], [0, 100], [1, 100], "<span class='layer black-white-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer hue-horizontal-ramp'></span>                        <span class='layer white-plain'></span>                        <span class='layer black-vertical-ramp'></span>                      </span>");
    };
    SHVMode.prototype.update = function(model) {
      var h, opacity, s, v;
      h = model.h, s = model.s, v = model.v;
      opacity = 1 - (s / 100);
      this.valuesSetProgrammatically = true;
      this.dialog.squarePicker.set("value", [360 - h, 100 - v]);
      this.dialog.rangePicker.set("value", [0, 100 - s]);
      this.valuesSetProgrammatically = false;
      return this.dialog.squarePicker.dummy.find(".white-plain").attr("style", "opacity: " + opacity + ";");
    };
    SHVMode.prototype.updateDialog = function(h, s, v) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromHSV(360 - h, 100 - s, 100 - v);
      return this.valuesSetProgrammatically = false;
    };
    SHVMode.prototype.squareChanged = function(widget, value) {
      var h, s, v;
      if (!this.valuesSetProgrammatically) {
        h = value[0], v = value[1];
        s = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(h, s, v);
      }
    };
    SHVMode.prototype.rangeChanged = function(widget, value) {
      var h, s, v, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), h = _ref[0], v = _ref[1];
        s = value[1];
        return this.updateDialog(h, s, v);
      }
    };
    return SHVMode;
  })();
  VHSMode = (function() {
    __extends(VHSMode, AbstractMode);
    function VHSMode() {
      VHSMode.__super__.constructor.apply(this, arguments);
    }
    VHSMode.prototype.init = function(dialog) {
      VHSMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 360], [0, 100], [1, 100], "<span class='layer black-white-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer hue-horizontal-ramp'></span>                        <span class='layer white-vertical-ramp'></span>                        <span class='layer black-plain'></span>                      </span>");
    };
    VHSMode.prototype.update = function(model) {
      var h, opacity, s, v;
      h = model.h, s = model.s, v = model.v;
      opacity = 1 - (v / 100);
      this.valuesSetProgrammatically = true;
      this.dialog.squarePicker.set("value", [360 - h, 100 - s]);
      this.dialog.rangePicker.set("value", [0, 100 - v]);
      this.valuesSetProgrammatically = false;
      return this.dialog.squarePicker.dummy.find(".black-plain").attr("style", "opacity: " + opacity + ";");
    };
    VHSMode.prototype.updateDialog = function(h, s, v) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromHSV(360 - h, 100 - s, 100 - v);
      return this.valuesSetProgrammatically = false;
    };
    VHSMode.prototype.squareChanged = function(widget, value) {
      var h, s, v;
      if (!this.valuesSetProgrammatically) {
        h = value[0], s = value[1];
        v = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(h, s, v);
      }
    };
    VHSMode.prototype.rangeChanged = function(widget, value) {
      var h, s, v, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), h = _ref[0], s = _ref[1];
        v = value[1];
        return this.updateDialog(h, s, v);
      }
    };
    return VHSMode;
  })();
  RGBMode = (function() {
    __extends(RGBMode, AbstractMode);
    function RGBMode() {
      RGBMode.__super__.constructor.apply(this, arguments);
    }
    RGBMode.prototype.init = function(dialog) {
      RGBMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 255], [0, 255], [0, 255], "<span class='layer black-red-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer rgb-bottom'></span>                        <span class='layer rgb-up'></span>                      </span>");
    };
    RGBMode.prototype.update = function(model) {
      var b, g, opacity, r;
      r = model.r, g = model.g, b = model.b;
      opacity = r / 255;
      this.valuesSetProgrammatically = true;
      this.dialog.squarePicker.set("value", [b, 255 - g]);
      this.dialog.rangePicker.set("value", [0, 255 - r]);
      this.valuesSetProgrammatically = false;
      return this.dialog.squarePicker.dummy.find(".rgb-up").attr("style", "opacity: " + opacity + ";");
    };
    RGBMode.prototype.updateDialog = function(r, g, b) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromRGB(255 - r, 255 - g, b);
      return this.valuesSetProgrammatically = false;
    };
    RGBMode.prototype.squareChanged = function(widget, value) {
      var b, g, r;
      if (!this.valuesSetProgrammatically) {
        b = value[0], g = value[1];
        r = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(r, g, b);
      }
    };
    RGBMode.prototype.rangeChanged = function(widget, value) {
      var b, g, r, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), b = _ref[0], g = _ref[1];
        r = value[1];
        return this.updateDialog(r, g, b);
      }
    };
    return RGBMode;
  })();
  GRBMode = (function() {
    __extends(GRBMode, AbstractMode);
    function GRBMode() {
      GRBMode.__super__.constructor.apply(this, arguments);
    }
    GRBMode.prototype.init = function(dialog) {
      GRBMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 255], [0, 255], [0, 255], "<span class='layer black-green-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer grb-bottom'></span>                        <span class='layer grb-up'></span>                      </span>");
    };
    GRBMode.prototype.update = function(model) {
      var b, g, opacity, r;
      r = model.r, g = model.g, b = model.b;
      opacity = g / 255;
      this.valuesSetProgrammatically = true;
      this.dialog.squarePicker.set("value", [b, 255 - r]);
      this.dialog.rangePicker.set("value", [0, 255 - g]);
      this.valuesSetProgrammatically = false;
      return this.dialog.squarePicker.dummy.find(".grb-up").attr("style", "opacity: " + opacity + ";");
    };
    GRBMode.prototype.updateDialog = function(r, g, b) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromRGB(255 - r, 255 - g, b);
      return this.valuesSetProgrammatically = false;
    };
    GRBMode.prototype.squareChanged = function(widget, value) {
      var b, g, r;
      if (!this.valuesSetProgrammatically) {
        b = value[0], r = value[1];
        g = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(r, g, b);
      }
    };
    GRBMode.prototype.rangeChanged = function(widget, value) {
      var b, g, r, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), b = _ref[0], r = _ref[1];
        g = value[1];
        return this.updateDialog(r, g, b);
      }
    };
    return GRBMode;
  })();
  BGRMode = (function() {
    __extends(BGRMode, AbstractMode);
    function BGRMode() {
      BGRMode.__super__.constructor.apply(this, arguments);
    }
    BGRMode.prototype.init = function(dialog) {
      BGRMode.__super__.init.call(this, dialog);
      return this.initPickers([0, 255], [0, 255], [0, 255], "<span class='layer black-blue-vertical-ramp'></span>", "<span class='layer'>                        <span class='layer bgr-bottom'></span>                        <span class='layer bgr-up'></span>                      </span>");
    };
    BGRMode.prototype.update = function(model) {
      var b, g, opacity, r;
      r = model.r, g = model.g, b = model.b;
      opacity = b / 255;
      this.valuesSetProgrammatically = true;
      this.dialog.squarePicker.set("value", [g, 255 - r]);
      this.dialog.rangePicker.set("value", [0, 255 - b]);
      this.valuesSetProgrammatically = false;
      return this.dialog.squarePicker.dummy.find(".bgr-up").attr("style", "opacity: " + opacity + ";");
    };
    BGRMode.prototype.updateDialog = function(r, g, b) {
      this.valuesSetProgrammatically = true;
      this.dialog.fromRGB(255 - r, g, 255 - b);
      return this.valuesSetProgrammatically = false;
    };
    BGRMode.prototype.squareChanged = function(widget, value) {
      var b, g, r;
      if (!this.valuesSetProgrammatically) {
        g = value[0], r = value[1];
        b = this.dialog.rangePicker.get("value")[1];
        return this.updateDialog(r, g, b);
      }
    };
    BGRMode.prototype.rangeChanged = function(widget, value) {
      var b, g, r, _ref;
      if (!this.valuesSetProgrammatically) {
        _ref = this.dialog.squarePicker.get("value"), g = _ref[0], r = _ref[1];
        b = value[1];
        return this.updateDialog(r, g, b);
      }
    };
    return BGRMode;
  })();
  ColorPicker.defaultListener = new ColorPickerDialog;
  $(document).ready(function() {
    return $("body").append(ColorPicker.defaultListener.dummy);
  });
  if (typeof window !== "undefined" && window !== null) {
    window.rgb2hsv = rgb2hsv;
    window.hsv2rgb = hsv2rgb;
    window.ColorPicker = ColorPicker;
    window.SquarePicker = SquarePicker;
    window.ColorPickerDialog = ColorPickerDialog;
    window.HSVMode = HSVMode;
    window.SHVMode = SHVMode;
    window.VHSMode = VHSMode;
    window.RGBMode = RGBMode;
    window.GRBMode = GRBMode;
    window.BGRMode = BGRMode;
  }
  $.fn.extend({
    widgets: function() {
      return $.widgetPlugin.process($(this));
    }
  });
  WidgetPlugin = (function() {
    function WidgetPlugin() {
      this.processors = {};
    }
    WidgetPlugin.prototype.register = function(id, match, processor) {
      if (processor == null) {
        throw "The processor function can't be null in register";
      }
      return this.processors[id] = [match, processor];
    };
    WidgetPlugin.prototype.registerWidgetFor = function(id, match, widget) {
      if (widget == null) {
        throw "The widget class can't be null in registerWidgetFor";
      }
      return this.register(id, match, function(target) {
        return new widget(target);
      });
    };
    WidgetPlugin.prototype.isRegistered = function(id) {
      return id in this.processors;
    };
    WidgetPlugin.prototype.process = function(queryset) {
      return queryset.each(__bind(function(i, o) {
        var elementMatched, id, match, next, parent, processor, target, widget, _ref, _ref2, _results;
        target = $(o);
        if (target.hasClass("widget-done")) {
          return;
        }
        next = target.next();
        parent = target.parent();
        _ref = this.processors;
        _results = [];
        for (id in _ref) {
          _ref2 = _ref[id], match = _ref2[0], processor = _ref2[1];
          elementMatched = $.isFunction(match) ? match.call(this, o) : o.nodeName.toLowerCase() === match;
          if (elementMatched) {
            widget = processor.call(this, o);
            if (widget != null) {
              if (next.length > 0) {
                next.before(widget.dummy);
              } else {
                parent.append(widget.dummy);
              }
            }
            break;
          }
        }
        return _results;
      }, this));
    };
    WidgetPlugin.prototype.isElement = function(o) {
      if (typeof HTMLElement === "object") {
        return o instanceof HTMLElement;
      } else {
        return typeof o === "object" && o.nodeType === 1 && typeof o.nodeName === "string";
      }
    };
    WidgetPlugin.prototype.isTag = function(o, tag) {
      var _ref;
      return this.isElement(o) && (o != null ? (_ref = o.nodeName) != null ? _ref.toLowerCase() : void 0 : void 0) === tag;
    };
    WidgetPlugin.prototype.isInputWithType = function() {
      var o, types, _ref;
      o = arguments[0], types = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.isTag(o, "input") && (_ref = $(o).attr("type"), __indexOf.call(types, _ref) >= 0);
    };
    WidgetPlugin.prototype.inputWithType = function() {
      var types;
      types = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return function(o) {
        return this.isInputWithType.apply(this, [o].concat(types));
      };
    };
    return WidgetPlugin;
  })();
  $.widgetPlugin = new WidgetPlugin;
  $.widgetPlugin.registerWidgetFor("textarea", "textarea", TextArea);
  $.widgetPlugin.registerWidgetFor("select", "select", SingleSelect);
  $.widgetPlugin.registerWidgetFor("textinput", $.widgetPlugin.inputWithType("text", "password"), TextInput);
  $.widgetPlugin.registerWidgetFor("button", $.widgetPlugin.inputWithType("button", "reset", "submit"), Button);
  $.widgetPlugin.registerWidgetFor("range", $.widgetPlugin.inputWithType("range"), Slider);
  $.widgetPlugin.registerWidgetFor("number", $.widgetPlugin.inputWithType("number"), Stepper);
  $.widgetPlugin.registerWidgetFor("checkbox", $.widgetPlugin.inputWithType("checkbox"), CheckBox);
  $.widgetPlugin.registerWidgetFor("color", $.widgetPlugin.inputWithType("color"), ColorPicker);
  $.widgetPlugin.registerWidgetFor("file", $.widgetPlugin.inputWithType("file"), FilePicker);
  $.widgetPlugin.register("radio", $.widgetPlugin.inputWithType("radio"), function(o) {
    var group, groups, name, widget;
    widget = new Radio(o);
    name = widget.get("name");
    if (name != null) {
      if ($.widgetPlugin.radiogroups == null) {
        $.widgetPlugin.radiogroups = {};
      }
      groups = $.widgetPlugin.radiogroups;
      if (groups[name] == null) {
        groups[name] = new RadioGroup;
      }
      group = groups[name];
      group.add(widget);
    }
    return widget;
  });
}).call(this);
