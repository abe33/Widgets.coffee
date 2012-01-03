(function() {
  var AbstractMode, BGRMode, Button, CheckBox, ColorPicker, ColorPickerDialog, Container, FilePicker, GRBMode, HSVMode, KeyStroke, MenuList, MenuModel, MockWidget, NumericWidget, RGBMode, Radio, RadioGroup, SHVMode, SingleSelect, Slider, SquarePicker, Stepper, TextArea, TextInput, VHSMode, Widget, WidgetPlugin, area1, area2, area3, button1, button2, button3, checkbox1, checkbox2, checkbox3, colorObjectFromValue, colorObjectToValue, dialog, group, hex2rgb, hsv2rgb, input1, input2, input3, isSafeChannel, isSafeColor, isSafeHSV, isSafeHue, isSafeNumber, isSafePercentage, isSafeRGB, isSafeValue, item1, item2, item3, item4, item5, item6, item7, item8, keys, keystroke, list1, list2, list3, model, picker1, picker2, picker3, radio1, radio2, radio3, rgb2hex, rgb2hsv, s, select1, select2, select3, slider1, slider2, slider3, spicker1, spicker2, spicker3, spicker4, stepper1, stepper2, stepper3, target;
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
      return __indexOf.call(this.radios, radio) >= 0;
    };
    RadioGroup.prototype.indexOf = function(radio) {
      var r, _i, _len, _ref;
      _ref = this.radios;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        r = _ref[_i];
        if (r === radio) {
          return _i;
        }
      }
      return -1;
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
      this.items = this.filterValidItems(items);
    }
    MenuModel.prototype.add = function() {
      var items;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.items = this.items.concat(this.filterValidItems(items));
      return this.contentChanged.dispatch(this);
    };
    MenuModel.prototype.remove = function() {
      var item, items;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.items = (function() {
        var _i, _len, _ref, _results;
        _ref = this.items;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (__indexOf.call(items, item) < 0) {
            _results.push(item);
          }
        }
        return _results;
      }).call(this);
      return this.contentChanged.dispatch(this);
    };
    MenuModel.prototype.size = function() {
      return this.items.length;
    };
    MenuModel.prototype.filterValidItems = function(items) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        if (this.isValidItem(item)) {
          _results.push(item);
        }
      }
      return _results;
    };
    MenuModel.prototype.isValidItem = function(item) {
      return (item != null) && (item.display != null) && (!(item.action != null) || $.isFunction(item.action)) && (!(item.menu != null) || item.menu instanceof MenuModel);
    };
    return MenuModel;
  })();
  MenuList = (function() {
    __extends(MenuList, Widget);
    function MenuList(model) {
      if (model == null) {
        model = new MenuModel;
      }
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
    MenuList.prototype.select = function(index) {
      var item, li;
      if (this.selectedIndex !== -1) {
        this.getListItemAt(this.selectedIndex).removeClass("selected");
      }
      this.selectedIndex = index < this.get("model").size() ? index : -1;
      if (this.selectedIndex !== -1) {
        li = this.getListItemAt(this.selectedIndex);
        li.addClass("selected");
        item = this.get("model").items[index];
        if (item.menu != null) {
          this.openChildList(item.menu, li);
        } else if (this.isChildListVisible()) {
          this.closeChildList();
        }
      }
      if (!this.hasFocus) {
        return this.grabFocus();
      }
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
    MenuList.prototype.createDummy = function() {
      return $("<ul class='menulist'></ul>");
    };
    MenuList.prototype.buildList = function(model) {
      var item, li, _i, _len, _ref;
      _ref = model.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (item.menu != null) {
          li = $("<li class='menu'>" + item.display + "</li>");
        } else {
          li = $("<li class='menuitem'>" + item.display + "</li>");
        }
        this.dummy.append(li);
      }
      return this.dummy.children().each(__bind(function(i, o) {
        var _item, _li;
        _li = $(o);
        _item = model.items[i];
        _li.mouseup(__bind(function(e) {
          if (!this.cantInteract()) {
            if (_item.action != null) {
              return _item.action();
            }
          }
        }, this));
        return _li.mouseover(__bind(function(e) {
          if (!this.cantInteract()) {
            return this.select(i);
          }
        }, this));
      }, this));
    };
    MenuList.prototype.clearList = function() {
      return this.dummy.children().remove();
    };
    MenuList.prototype.close = function() {
      var _ref;
      this.dummy.blur();
      this.dummy.detach();
      return (_ref = this.childList) != null ? _ref.close() : void 0;
    };
    MenuList.prototype.getListItemAt = function(index) {
      return $(this.dummy.children("li")[index]);
    };
    MenuList.prototype.openChildList = function(model, li) {
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
      top = li.offset().top;
      return this.childList.dummy.attr("style", "left: " + left + "px; top: " + top + "px;");
    };
    MenuList.prototype.closeChildList = function() {
      var _ref;
      if ((_ref = this.childList) != null) {
        _ref.close();
      }
      return this.grabFocus();
    };
    MenuList.prototype.isChildListVisible = function() {
      var _ref;
      return ((_ref = this.childList) != null ? _ref.dummy.parent().length : void 0) === 1;
    };
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
    MenuList.prototype.mousedown = function(e) {
      return e.stopImmediatePropagation();
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
  module("keystroke function tests");
  test("The keystroke function should return an object with the specified keyCode", function() {
    var ks;
    ks = keystroke(10);
    return assertThat(ks.keyCode, equalTo(10));
  });
  test("The keystroke function should return an object with the passed-in keycode and modifier", function() {
    var ks;
    ks = keystroke(0, 7);
    return assertThat(ks.modifiers, equalTo(7));
  });
  test("Modifier's properties should be false when modifiers is 0", function() {
    var ks;
    ks = keystroke(0);
    assertThat(ks, hasProperty("ctrl", strictlyEqualTo(false)));
    assertThat(ks, hasProperty("shift", strictlyEqualTo(false)));
    return assertThat(ks, hasProperty("alt", strictlyEqualTo(false)));
  });
  test("Ctrl property should be true when mofifiers is 1", function() {
    var ks;
    ks = keystroke(0, 1);
    return assertThat(ks.ctrl);
  });
  test("Shift property should be true when mofifiers is 2", function() {
    var ks;
    ks = keystroke(0, 2);
    return assertThat(ks.shift);
  });
  test("Alt property should be true when mofifiers is 4", function() {
    var ks;
    ks = keystroke(0, 4);
    return assertThat(ks.alt);
  });
  test("All modifier's property should be true when mofifiers is 7", function() {
    var ks;
    ks = keystroke(0, 7);
    assertThat(ks.ctrl);
    assertThat(ks.shift);
    return assertThat(ks.alt);
  });
  test("Two calls to keystroke with the same arguments should return the same instance", function() {
    var ks1, ks2;
    ks1 = keystroke(16, 7);
    ks2 = keystroke(16, 7);
    return assertThat(ks1, strictlyEqualTo(ks2));
  });
  test("The keystroke object should be able to match an event object", function() {
    var ks;
    ks = keystroke(16, 7);
    return assertThat(ks.match({
      keyCode: 16,
      ctrlKey: true,
      shiftKey: true,
      altKey: true
    }));
  });
  test("The string representation of a keystroke should be a human readable representation", function() {
    var ks;
    ks = keystroke(keys.a, keys.mod.ctrl + keys.mod.shift);
    return assertThat(ks.toString(), equalTo("Ctrl+Shift+A"));
  });
  module("widgets base tests");
  test("Widgets should have a target node", function() {
    var target, widget;
    target = $("<div></div>")[0];
    widget = new Widget(target);
    return assertThat(widget, hasProperty("target", equalTo(target)));
  });
  test("Widgets constructor should fail with an invalid argument", function() {
    var target, widget, widgetFailed;
    target = $("<div></div>");
    widgetFailed = false;
    try {
      widget = new Widget(target);
    } catch (e) {
      widgetFailed = true;
    }
    return assertThat(widgetFailed);
  });
  test("Widgets can be instanciated without a target", function() {
    var widget;
    widget = new Widget;
    return assertThat(widget, hasProperty("target"));
  });
  test("Widgets with target should reflect the initial target's state", function() {
    var target, widget;
    target = $("<input type='text' value='foo' name='foo' disabled readonly></input>")[0];
    widget = new Widget(target);
    assertThat(widget.get("disabled"), equalTo(true));
    assertThat(widget.get("readonly"), equalTo(true));
    assertThat(widget.get("value"), equalTo("foo"));
    return assertThat(widget.get("name"), equalTo("foo"));
  });
  test("Changes made to the widget should affect its target", function() {
    var target, widget;
    target = $("<input type='text' value='foo' name='foo' disabled readonly></input>")[0];
    widget = new Widget(target);
    widget.set("disabled", false);
    widget.set("readonly", false);
    widget.set("value", "hello");
    widget.set("name", "name");
    assertThat($(target).attr("disabled"), equalTo(void 0));
    assertThat($(target).attr("readonly"), equalTo(void 0));
    assertThat($(target).attr("value"), equalTo("hello"));
    return assertThat($(target).attr("name"), equalTo("name"));
  });
  test("Changes made to a widget's property should dispatch a propertyChanged signal", function() {
    var signalDispatched, signalOrigin, signalProperty, signalValue, widget;
    widget = new Widget;
    signalDispatched = false;
    signalOrigin = null;
    signalProperty = null;
    signalValue = null;
    widget.propertyChanged.addOnce(function(widget, property, value) {
      signalDispatched = true;
      signalOrigin = widget;
      signalProperty = property;
      return signalValue = value;
    });
    widget.set("disabled", false);
    assertThat(signalDispatched);
    assertThat(signalOrigin, equalTo(widget));
    assertThat(signalProperty, equalTo("disabled"));
    return assertThat(signalValue, equalTo(false));
  });
  test("Changes made to the target's value should be catched by the widget", function() {
    var MockWidget, target, targetChangeCalled, widget;
    target = $("<input type='text' value='foo'></input>");
    targetChangeCalled = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.targetChange = function(e) {
        return targetChangeCalled = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget(target[0]);
    target.change();
    return assertThat(targetChangeCalled);
  });
  test("Widget should dispatch a valueChanged signal on a value change", function() {
    var signalDispatched, signalOrigin, signalValue, widget;
    widget = new Widget;
    signalDispatched = false;
    signalOrigin = null;
    signalValue = null;
    widget.valueChanged.addOnce(function(widget, value) {
      signalDispatched = true;
      signalOrigin = widget;
      return signalValue = value;
    });
    widget.set("value", "foo");
    assertThat(signalDispatched);
    assertThat(signalOrigin, equalTo(widget));
    return assertThat(signalValue, equalTo("foo"));
  });
  test("Widgets without target should allow modification of their properties", function() {
    var widget;
    widget = new Widget;
    widget.set("value", "hello");
    widget.set("disabled", true);
    widget.set("readonly", true);
    assertThat(widget.get("value"), equalTo("hello"));
    assertThat(widget.get("disabled"), equalTo(true));
    return assertThat(widget.get("readonly"), equalTo(true));
  });
  test("Widgets should allow creation of custom properties", function() {
    var widget;
    widget = new Widget;
    widget.createProperty("foo", "bar");
    assertThat(widget.get("foo"), equalTo("bar"));
    widget.set("foo", "hello");
    return assertThat(widget.get("foo"), equalTo("hello"));
  });
  test("Widgets should allow to modify several properties with just one call to the set method", function() {
    var widget;
    widget = new Widget;
    widget.set({
      name: "someName",
      disabled: true,
      value: "foo"
    });
    assertThat(widget.get("name"), equalTo("someName"));
    assertThat(widget.get("disabled"), equalTo(true));
    return assertThat(widget.get("value"), equalTo("foo"));
  });
  test("Widgets should allow creation of custom properties with custom accessors", function() {
    var getter, setter, widget;
    widget = new Widget;
    getter = function(property) {
      return this.properties[property];
    };
    setter = function(property, value) {
      return this.properties[property] = value;
    };
    widget.createProperty("foo", "bar", setter, getter);
    assertThat(widget.get("foo"), equalTo("bar"));
    widget.set("foo", "hello");
    return assertThat(widget.get("foo"), equalTo("hello"));
  });
  test("Widget class should allow subclasses to create a dummy in constructor", function() {
    var MockWidget, createDummyWasCalled, widget;
    createDummyWasCalled = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        createDummyWasCalled = true;
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    assertThat(createDummyWasCalled);
    return assertThat(widget.dummy, allOf(notNullValue(), hasProperty("length", equalTo(1))));
  });
  test("Widgets that create dummy should have registered to its mouse events", function() {
    var MockWidget, clickReceived, dblclickReceived, mousedownReceived, mousemoveReceived, mouseoutReceived, mouseoverReceived, mouseupReceived, mousewheelReceived, widget;
    mousedownReceived = false;
    mouseupReceived = false;
    mousemoveReceived = false;
    mouseoverReceived = false;
    mouseoutReceived = false;
    mousewheelReceived = false;
    clickReceived = false;
    dblclickReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return this.dummy = $("<span></span>");
      };
      MockWidget.prototype.mousedown = function() {
        return mousedownReceived = true;
      };
      MockWidget.prototype.mouseup = function() {
        return mouseupReceived = true;
      };
      MockWidget.prototype.mousemove = function() {
        return mousemoveReceived = true;
      };
      MockWidget.prototype.mouseover = function() {
        return mouseoverReceived = true;
      };
      MockWidget.prototype.mouseout = function() {
        return mouseoutReceived = true;
      };
      MockWidget.prototype.mousewheel = function() {
        return mousewheelReceived = true;
      };
      MockWidget.prototype.click = function() {
        return clickReceived = true;
      };
      MockWidget.prototype.dblclick = function() {
        return dblclickReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.dummy.mousedown();
    widget.dummy.mouseup();
    widget.dummy.mousemove();
    widget.dummy.mouseover();
    widget.dummy.mouseout();
    widget.dummy.mousewheel();
    widget.dummy.click();
    widget.dummy.dblclick();
    assertThat(mousedownReceived);
    assertThat(mouseupReceived);
    assertThat(mousemoveReceived);
    assertThat(mouseoverReceived);
    assertThat(mouseoutReceived);
    assertThat(mouseoutReceived);
    assertThat(mousewheelReceived);
    assertThat(clickReceived);
    return assertThat(dblclickReceived);
  });
  test("Widgets that create dummy sould allow to unregister from its mouse events", function() {
    var MockWidget, clickReceived, dblclickReceived, mousedownReceived, mousemoveReceived, mouseoutReceived, mouseoverReceived, mouseupReceived, mousewheelReceived, widget;
    mousedownReceived = false;
    mouseupReceived = false;
    mousemoveReceived = false;
    mouseoverReceived = false;
    mouseoutReceived = false;
    mousewheelReceived = false;
    clickReceived = false;
    dblclickReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockWidget.prototype.mousedown = function() {
        return mousedownReceived = true;
      };
      MockWidget.prototype.mouseup = function() {
        return mouseupReceived = true;
      };
      MockWidget.prototype.mousemove = function() {
        return mousemoveReceived = true;
      };
      MockWidget.prototype.mouseover = function() {
        return mouseoverReceived = true;
      };
      MockWidget.prototype.mouseout = function() {
        return mouseoutReceived = true;
      };
      MockWidget.prototype.mousewheel = function() {
        return mousewheelReceived = true;
      };
      MockWidget.prototype.click = function() {
        return clickReceived = true;
      };
      MockWidget.prototype.dblclick = function() {
        return dblclickReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.unregisterFromDummyEvents();
    widget.dummy.mousedown();
    widget.dummy.mouseup();
    widget.dummy.mousemove();
    widget.dummy.mouseover();
    widget.dummy.mouseout();
    widget.dummy.mousewheel();
    widget.dummy.click();
    widget.dummy.dblclick();
    assertThat(!mousedownReceived);
    assertThat(!mouseupReceived);
    assertThat(!mousemoveReceived);
    assertThat(!mouseoutReceived);
    assertThat(!mouseoverReceived);
    assertThat(!mousewheelReceived);
    assertThat(!clickReceived);
    return assertThat(!dblclickReceived);
  });
  test("Widget's states should be reflected on the dummy class attribute", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("disabled", true);
    assertThat(widget.dummy.hasClass("disabled"));
    widget.set("readonly", true);
    return assertThat(widget.dummy.hasClass("readonly"));
  });
  test("Widget's states should have the same order whatever the call order is", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("disabled", true);
    widget.set("readonly", true);
    assertThat(widget.dummy.attr("class"), equalTo("disabled readonly"));
    widget = new MockWidget;
    widget.set("readonly", true);
    widget.set("disabled", true);
    return assertThat(widget.dummy.attr("class"), equalTo("disabled readonly"));
  });
  test("Widget should dispatch a stateChanged signal when the state is changed", function() {
    var MockWidget, signalDispatched, signalOrigin, signalValue, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    signalDispatched = false;
    signalOrigin = null;
    signalValue = null;
    widget.stateChanged.add(function(widget, state) {
      signalDispatched = true;
      signalOrigin = widget;
      return signalValue = state;
    });
    widget.set("disabled", true);
    assertThat(signalDispatched);
    assertThat(signalOrigin, equalTo(widget));
    return assertThat(signalValue, equalTo("disabled"));
  });
  test("Widget shouldn't dispatch the stateChanged signal when a property that doesn't affect the state is modified", function() {
    var MockWidget, signalDispatched, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    signalDispatched = false;
    widget.stateChanged.add(function(widget, state) {
      return signalDispatched = true;
    });
    widget.set("name", "hello");
    return assertThat(!signalDispatched);
  });
  test("Widget's dummy should allow focus by setting the tabindex attribute", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    return assertThat(widget.dummy.attr("tabindex"), notNullValue());
  });
  test("Widgets should receive focus related events from its dummy", function() {
    var MockWidget, blurReceived, focusReceived, widget;
    focusReceived = false;
    blurReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockWidget.prototype.focus = function(e) {
        return focusReceived = true;
      };
      MockWidget.prototype.blur = function(e) {
        return blurReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.dummy.focus();
    widget.dummy.blur();
    assertThat(focusReceived);
    return assertThat(blurReceived);
  });
  test("Widgets should receive keyboard related events from its dummy", function() {
    var MockWidget, keydownReceived, keypressReceived, keyupReceived, widget;
    keydownReceived = false;
    keyupReceived = false;
    keypressReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockWidget.prototype.keydown = function(e) {
        return keydownReceived = true;
      };
      MockWidget.prototype.keyup = function(e) {
        return keyupReceived = true;
      };
      MockWidget.prototype.keypress = function(e) {
        return keypressReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.dummy.keydown();
    widget.dummy.keypress();
    widget.dummy.keyup();
    assertThat(keydownReceived);
    assertThat(keypressReceived);
    return assertThat(keyupReceived);
  });
  test("Widgets should be able to know when it has focus", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget();
    widget.dummy.focus();
    return assertThat(widget.hasFocus);
  });
  test("Widgets should be able to know when it lose focus", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget();
    widget.dummy.focus();
    widget.dummy.blur();
    return assertThat(!widget.hasFocus);
  });
  test("Widgets dummy should reflect the focus state in its class attribute", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget();
    widget.dummy.focus();
    return assertThat(widget.dummy.hasClass("focus"));
  });
  test("Widgets dummy should reflect the lost focus state in its class attribute", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget();
    widget.dummy.focus();
    widget.dummy.blur();
    return assertThat(!widget.dummy.hasClass("focus"));
  });
  test("Widgets should preserve the initial class value of the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    return assertThat(widget.dummy.attr("class"), equalTo("foo"));
  });
  test("Widgets should preserve the initial class value of the dummy even with state class", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("disabled", true);
    return assertThat(widget.dummy.attr("class"), equalTo("foo disabled"));
  });
  test("Widgets should hide the target when provided", function() {
    var target, widget;
    target = $("<input type='text'></input>");
    widget = new Widget(target[0]);
    widget.hideTarget();
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Widgets shouldn't fail on hide when the target isn't provided", function() {
    var errorRaised, widget;
    widget = new Widget;
    errorRaised = false;
    try {
      widget.hideTarget();
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(!errorRaised);
  });
  test("Widgets should allow to register function for specific keystrokes on keydown", function() {
    var widget;
    widget = new Widget;
    widget.registerKeyDownCommand(keystroke(keys.a, keys.mod.ctrl), function() {});
    return assertThat(widget.hasKeyDownCommand(keystroke(keys.a, keys.mod.ctrl)));
  });
  test("Widgets should trigger the corresponding function with the associated keystroke on keydown", function() {
    var commandCalled, widget;
    widget = new Widget;
    commandCalled = false;
    widget.registerKeyDownCommand(keystroke(keys.a, keys.mod.ctrl), function() {
      return commandCalled = true;
    });
    widget.keydown({
      keyCode: keys.a,
      ctrlKey: true,
      shiftKey: false,
      altKey: false
    });
    return assertThat(commandCalled);
  });
  test("Widgets should allow to register function for specific keystrokes on keyup", function() {
    var widget;
    widget = new Widget;
    widget.registerKeyUpCommand(keystroke(keys.a, keys.mod.ctrl), function() {});
    return assertThat(widget.hasKeyUpCommand(keystroke(keys.a, keys.mod.ctrl)));
  });
  test("Widgets should trigger the corresponding function with the associated keystroke on keyup", function() {
    var commandCalled, widget;
    widget = new Widget;
    commandCalled = false;
    widget.registerKeyUpCommand(keystroke(keys.a, keys.mod.ctrl), function() {
      return commandCalled = true;
    });
    widget.keyup({
      keyCode: keys.a,
      ctrlKey: true,
      shiftKey: false,
      altKey: false
    });
    return assertThat(commandCalled);
  });
  test("Widgets keyup events that doesn't trigger a command shouldn't return false", function() {
    var widget;
    widget = new Widget;
    return assertThat(widget.keyup({
      keyCode: keys.a,
      ctrlKey: true,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Widgets keydown events that doesn't trigger a command shouldn't return false", function() {
    var widget;
    widget = new Widget;
    return assertThat(widget.keydown({
      keyCode: keys.a,
      ctrlKey: true,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Widgets keydown events that trigger a command should return the command return", function() {
    var widget;
    widget = new Widget;
    widget.registerKeyDownCommand(keystroke(keys.a), function() {
      return true;
    });
    return assertThat(widget.keydown({
      keyCode: keys.a,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Widgets keyup events that trigger a command should return the command return", function() {
    var widget;
    widget = new Widget;
    widget.registerKeyUpCommand(keystroke(keys.a), function() {
      return true;
    });
    return assertThat(widget.keyup({
      keyCode: keys.a,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Widgets should pass the event to the keydown commands", function() {
    var event, widget;
    event = null;
    widget = new Widget;
    widget.registerKeyDownCommand(keystroke(keys.a), function(e) {
      return event = e;
    });
    widget.keydown({
      keyCode: keys.a,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(event, notNullValue());
  });
  test("Widgets should pass the event to the keyup commands", function() {
    var event, widget;
    event = null;
    widget = new Widget;
    widget.registerKeyUpCommand(keystroke(keys.a), function(e) {
      return event = e;
    });
    widget.keyup({
      keyCode: keys.a,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(event, notNullValue());
  });
  test("Widgets should provide a way to reset the target input to its original state", function() {
    var target, widget;
    target = $("<input type='text' value='foo'></input>");
    widget = new Widget(target[0]);
    widget.set("value", "hello");
    assertThat(target.attr("value"), equalTo("hello"));
    widget.reset();
    return assertThat(target.attr("value"), equalTo("foo"));
  });
  test("Readonly widgets shouldn't allow to modify its value", function() {
    var widget;
    widget = new Widget;
    widget.set("value", "Hello");
    widget.set("readonly", true);
    widget.set("value", "Goodbye");
    return assertThat(widget.get("value"), equalTo("Hello"));
  });
  test("Widgets should be able to grab focus", function() {
    var MockWidget, focusReceived, widget;
    focusReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      MockWidget.prototype.focus = function(e) {
        return focusReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.grabFocus();
    return assertThat(focusReceived);
  });
  test("Widgets should be able to release the focus", function() {
    var MockWidget, blurReceived, focusReceived, widget;
    focusReceived = false;
    blurReceived = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      MockWidget.prototype.focus = function(e) {
        return focusReceived = true;
      };
      MockWidget.prototype.blur = function(e) {
        return blurReceived = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.grabFocus();
    assertThat(focusReceived);
    widget.releaseFocus();
    return assertThat(blurReceived);
  });
  test("Disabled widgets shouldn't allow focus", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("disabled", true);
    assertThat(widget.focus(), equalTo(false));
    return assertThat(widget.dummy.attr("tabindex"), nullValue());
  });
  test("Widget's properties getters and setters should be overridable in children classes", function() {
    var MockWidget, setterCalled, widget;
    setterCalled = false;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.set_value = function(property, value) {
        return setterCalled = true;
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("value", "foo");
    return assertThat(setterCalled);
  });
  test("Widget's custom properties should be overridable in children classes", function() {
    var MockWidgetA, MockWidgetB, setterCalled, widget;
    setterCalled = false;
    MockWidgetA = (function() {
      __extends(MockWidgetA, Widget);
      function MockWidgetA(target) {
        MockWidgetA.__super__.constructor.call(this, target);
        this.createProperty("foo", "bar");
      }
      MockWidgetA.prototype.set_foo = function(property, value) {
        return value;
      };
      return MockWidgetA;
    })();
    MockWidgetB = (function() {
      __extends(MockWidgetB, MockWidgetA);
      function MockWidgetB() {
        MockWidgetB.__super__.constructor.apply(this, arguments);
      }
      MockWidgetB.prototype.set_foo = function(property, value) {
        setterCalled = true;
        return MockWidgetB.__super__.set_foo.call(this, property, value);
      };
      return MockWidgetB;
    })();
    widget = new MockWidgetB;
    widget.set("foo", "hello");
    assertThat(setterCalled);
    return assertThat(widget.get("foo"), equalTo("hello"));
  });
  test("Widget's value setter shouldn't dispatch a value changed when set is called with the current value", function() {
    var signalCallCount, widget;
    widget = new Widget;
    signalCallCount = 0;
    widget.valueChanged.add(function() {
      return signalCallCount++;
    });
    widget.set("value", "hello");
    widget.set("value", "hello");
    return assertThat(signalCallCount, equalTo(1));
  });
  test("When both target and dummy exist and target as a style attribute, the value should be copied to the dummy", function() {
    var MockWidget, target, widget;
    target = $("<input type='text' style='width: 100px;'></input>")[0];
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget(target);
    return assertThat(widget.dummy.attr("style"), equalTo("width: 100px;"));
  });
  test("Widgets should provide a way to know when the widget don't allow interaction", function() {
    var widget;
    widget = new Widget;
    return assertThat(!widget.cantInteract());
  });
  test("Widgets should provide a way to know when the widget don't allow interaction", function() {
    var widget;
    widget = new Widget;
    widget.set("disabled", true);
    return assertThat(widget.cantInteract());
  });
  test("Widgets should provide a way to know when the widget don't allow interaction", function() {
    var widget;
    widget = new Widget;
    widget.set("readonly", true);
    return assertThat(widget.cantInteract());
  });
  test("Widgets should provides a way to add a class to its dummy", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.addClasses("bar", "owl");
    assertThat(widget.dummy.attr("class"), contains("bar"));
    return assertThat(widget.dummy.attr("class"), contains("owl"));
  });
  test("Widgets should provides a way to remove a class from its dummy", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo bar owl'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.removeClasses("bar", "owl");
    assertThat(widget.dummy.attr("class"), hamcrest.not(contains("bar")));
    return assertThat(widget.dummy.attr("class"), hamcrest.not(contains("owl")));
  });
  test("Widgets should provide an id property that is mapped to the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo' id='hola'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    assertThat(widget.dummy.attr("id"), equalTo("hola"));
    widget.set("id", "foo");
    return assertThat(widget.dummy.attr("id"), equalTo("foo"));
  });
  test("Setting a null id should remove the attribute from the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };
      return MockWidget;
    })();
    widget = new MockWidget;
    widget.set("id", "foo");
    widget.set("id", null);
    return assertThat(widget.dummy.attr("id"), equalTo(void 0));
  });
  test("Widgets should mark their target with a specific class", function() {
    var target, widget;
    target = $("<input type='text'></input>");
    widget = new Widget(target[0]);
    return assertThat(target.hasClass("widget-done"));
  });
  MockWidget = (function() {
    __extends(MockWidget, Widget);
    function MockWidget() {
      MockWidget.__super__.constructor.apply(this, arguments);
    }
    MockWidget.prototype.createDummy = function() {
      return $("<span></span>");
    };
    return MockWidget;
  })();
  module("container tests");
  test("A container should have children", function() {
    var container;
    container = new Container;
    return assertThat(container.children, allOf(notNullValue(), arrayWithLength(0)));
  });
  test("A container should allow to add children", function() {
    var container;
    container = new Container;
    container.add(new MockWidget);
    return assertThat(container.children, arrayWithLength(1));
  });
  test("A container should prevent to add a null child", function() {
    var container;
    container = new Container;
    container.add(null);
    return assertThat(container.children, arrayWithLength(0));
  });
  test("A container should prevent to add an object which is not a widget", function() {
    var container;
    container = new Container;
    container.add({});
    return assertThat(container.children, arrayWithLength(0));
  });
  test("A container should allow to add a child that is an instance of a widget subclass", function() {
    var container;
    container = new Container;
    container.add(new MockWidget);
    return assertThat(container.children, arrayWithLength(1));
  });
  test("A container should prevent to add the same child twice", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.add(child);
    return assertThat(container.children, array(child));
  });
  test("A container should allow to remove a previously added child", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.remove(child);
    return assertThat(container.children, arrayWithLength(0));
  });
  test("A container shouldn't proceed when remove is called with null", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.remove(null);
    return assertThat(container.children, arrayWithLength(1));
  });
  test("A container shouldn't proceed when remove is called with an object that isn't a widget", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.remove({});
    return assertThat(container.children, arrayWithLength(1));
  });
  test("A container shouldn't proceed when remove is called with a widget which is not a child", function() {
    var child, container, notChild;
    container = new Container;
    child = new MockWidget;
    notChild = new MockWidget;
    container.add(child);
    container.remove(notChild);
    return assertThat(container.children, arrayWithLength(1));
  });
  test("A container should have a dummy", function() {
    var container;
    container = new Container;
    return assertThat(container.dummy, notNullValue());
  });
  test("Adding a widget in a container should add its dummy as a child of the container's one", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    assertThat(container.dummy.children().length, equalTo(1));
    return assertThat(container.dummy.children()[0], equalTo(child.dummy[0]));
  });
  test("Removing a widget should remove its dummy from the container's one", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.remove(child);
    return assertThat(container.dummy.children().length, equalTo(0));
  });
  test("Widgets added as child of a container should be able to access its parent", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    return assertThat(child.parent === container);
  });
  test("Widgets that are no longer a child of a container shouldn't hold a reference to it anymore", function() {
    var child, container;
    container = new Container;
    child = new MockWidget;
    container.add(child);
    container.remove(child);
    return assertThat(child.parent === null);
  });
  test("A container should prevent to take focus when one of its child receive it", function() {
    var container, widget;
    widget = new MockWidget;
    container = new Container;
    container.add(widget);
    widget.dummy.focus();
    return assertThat(!container.hasFocus);
  });
  test("Keyboard commands that can't be found in children should be bubbled to the parent", function() {
    var MockContainer, container, event, keyDownCommandCalled, keyUpCommandCalled, widget;
    keyDownCommandCalled = false;
    keyUpCommandCalled = false;
    MockContainer = (function() {
      __extends(MockContainer, Container);
      function MockContainer() {
        MockContainer.__super__.constructor.apply(this, arguments);
      }
      MockContainer.prototype.triggerKeyDownCommand = function(e) {
        return keyDownCommandCalled = true;
      };
      MockContainer.prototype.triggerKeyUpCommand = function(e) {
        return keyUpCommandCalled = true;
      };
      return MockContainer;
    })();
    widget = new MockWidget;
    container = new MockContainer;
    container.add(widget);
    event = {
      keyCode: 16,
      ctrlKey: true,
      shiftKey: true,
      altKey: true
    };
    widget.triggerKeyDownCommand(event);
    widget.triggerKeyUpCommand(event);
    assertThat(keyDownCommandCalled);
    return assertThat(keyUpCommandCalled);
  });
  module("button tests");
  test("Buttons should allow to pass a button input as argument", function() {
    var button, target;
    target = ($("<input type='button'></input>"))[0];
    button = new Button(target);
    return assertThat(button.target === target);
  });
  test("Buttons should allow to pass a submit input as argument", function() {
    var button, target;
    target = ($("<input type='submit'></input>"))[0];
    button = new Button(target);
    return assertThat(button.target === target);
  });
  test("Buttons should allow to pass a reset input as argument", function() {
    var button, target;
    target = ($("<input type='reset'></input>"))[0];
    button = new Button(target);
    return assertThat(button.target === target);
  });
  test("Buttons shouldn't allow any other type of input as argument", function() {
    var button, errorRaised, target;
    target = ($("<input type='text'></input>"))[0];
    errorRaised = false;
    try {
      button = new Button(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("Buttons should also allow an action object as argument", function() {
    var action, button;
    action = {
      action: function() {}
    };
    button = new Button(action);
    return assertThat(button.get("action") === action);
  });
  test("Buttons should accept both a target and an action as arguments", function() {
    var action, button, target;
    target = ($("<input type='reset'></input>"))[0];
    action = {
      action: function() {}
    };
    button = new Button(target, action);
    assertThat(button.target === target);
    return assertThat(button.get("action") === action);
  });
  test("Buttons content should be provided through the action object", function() {
    var action, button;
    action = {
      display: "label",
      action: function() {}
    };
    button = new Button(action);
    return assertThat(button.dummy.find(".content").text(), equalTo("label"));
  });
  test("Buttons should trigger the action on a click", function() {
    var action, actionTriggered, button;
    actionTriggered = false;
    action = {
      action: function() {
        return actionTriggered = true;
      }
    };
    button = new Button(action);
    button.dummy.click();
    return assertThat(actionTriggered);
  });
  test("Buttons should trigger their target click on a click", function() {
    var button, clickCalled, target;
    clickCalled = false;
    target = $("<input type='reset'></input>");
    target.click(function() {
      return clickCalled = true;
    });
    button = new Button(target[0]);
    button.click();
    return assertThat(clickCalled);
  });
  test("Buttons should hide their target at creation", function() {
    var button, target;
    target = $("<input type='reset'></input>");
    button = new Button(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Readonly buttons should not trigger the action on a click", function() {
    var action, actionTriggered, button;
    actionTriggered = false;
    action = {
      action: function() {
        return actionTriggered = true;
      }
    };
    button = new Button(action);
    button.set("readonly", true);
    button.dummy.click();
    return assertThat(!actionTriggered);
  });
  test("Disabled buttons should not trigger the action on a click", function() {
    var action, actionTriggered, button;
    actionTriggered = false;
    action = {
      action: function() {
        return actionTriggered = true;
      }
    };
    button = new Button(action);
    button.set("disabled", true);
    button.dummy.click();
    return assertThat(!actionTriggered);
  });
  test("Readonly buttons shouldn't trigger their target click on a click", function() {
    var button, clickCalled, target;
    clickCalled = false;
    target = $("<input type='reset'></input>");
    target.click(function() {
      return clickCalled = true;
    });
    button = new Button(target[0]);
    button.set("readonly", true);
    button.click();
    return assertThat(!clickCalled);
  });
  test("Disabled buttons shouldn't trigger their target click on a click", function() {
    var button, clickCalled, target;
    clickCalled = false;
    target = $("<input type='reset'></input>");
    target.click(function() {
      return clickCalled = true;
    });
    button = new Button(target[0]);
    button.set("disabled", true);
    button.click();
    return assertThat(!clickCalled);
  });
  test("Buttons should allow to use the space key instead of a click", function() {
    var action, actionTriggered, button;
    actionTriggered = false;
    action = {
      action: function() {
        return actionTriggered = true;
      }
    };
    button = new Button(action);
    button.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(actionTriggered);
  });
  test("Buttons should allow to use the enter key instead of a click", function() {
    var action, actionTriggered, button;
    actionTriggered = false;
    action = {
      action: function() {
        return actionTriggered = true;
      }
    };
    button = new Button(action);
    button.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(actionTriggered);
  });
  test("Changing the action of a button should update its content", function() {
    var button;
    button = new Button;
    button.set("action", {
      display: "label",
      action: function() {}
    });
    return assertThat(button.dummy.find(".content").text(), equalTo("label"));
  });
  button1 = new Button;
  button2 = new Button;
  button3 = new Button;
  button1.set("value", "Button <span class='icon'></span>");
  button2.set("value", "Readonly");
  button3.set("value", "Disabled");
  button2.set("readonly", true);
  button3.set("disabled", true);
  $("#qunit-header").before($("<h4>Button</h4>"));
  $("#qunit-header").before(button1.dummy);
  $("#qunit-header").before(button2.dummy);
  $("#qunit-header").before(button3.dummy);
  module("textinput tests");
  test("TextInput should allow a target of type text", function() {
    var input, target;
    target = $("<input type='text'></input>")[0];
    input = new TextInput(target);
    return assertThat(input.target === target);
  });
  test("TextInput should allow a target of type password", function() {
    var input, target;
    target = $("<input type='password'></input>")[0];
    input = new TextInput(target);
    return assertThat(input.target === target);
  });
  test("A TextInput shouldn't allow a target of with a type different than text or password", function() {
    var errorRaised, input, target;
    target = $("<input type='file'></input>")[0];
    errorRaised = false;
    try {
      input = new TextInput(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("A TextInput should create a target when not provided in the constructor", function() {
    var input;
    input = new TextInput;
    return assertThat(input.target, notNullValue());
  });
  test("A TextInput should have a dummy that contains the target", function() {
    var input;
    input = new TextInput;
    return assertThat(input.dummy.children("input").length, equalTo(1));
  });
  test("A TextInput focus should be placed on the target", function() {
    var focusPlacedOnTheInput, input;
    focusPlacedOnTheInput = false;
    input = new TextInput;
    input.dummy.children("input").focus(function() {
      return focusPlacedOnTheInput = true;
    });
    input.grabFocus();
    assertThat(focusPlacedOnTheInput);
    assertThat(input.dummy.attr("tabindex"), nullValue());
    return assertThat(input.hasFocus);
  });
  test("Changing the value in the target should update the widget", function() {
    var input, signalCalled, signalValue;
    signalCalled = false;
    signalValue = null;
    input = new TextInput;
    input.valueChanged.add(function(w, v) {
      signalCalled = true;
      return signalValue = v;
    });
    input.dummy.children("input").val("hello");
    input.dummy.children("input").change();
    return assertThat(input.get("value"), equalTo("hello"));
  });
  test("Clicking on a textinput should give him the focus", function() {
    var input;
    input = new TextInput;
    input.dummy.mouseup();
    return assertThat(input.hasFocus);
  });
  test("Clicking on a disabled textinput shouldn't give him the focus", function() {
    var input;
    input = new TextInput;
    input.set("disabled", true);
    input.dummy.mouseup();
    return assertThat(!input.hasFocus);
  });
  test("TextInput should support the maxlength attribute of an input text", function() {
    var input, target;
    target = $("<input type='text' maxlength='5'></input>");
    input = new TextInput(target[0]);
    assertThat(input.get("maxlength"), equalTo(5));
    input.set("maxlength", 10);
    assertThat(input.get("maxlength"), equalTo(10));
    assertThat(target.attr("maxlength"), equalTo(10));
    input.set("maxlength", null);
    return assertThat(target.attr("maxlength"), equalTo(void 0));
  });
  test("TextInput should know when its content had changed and the change events isn't triggered already", function() {
    var input;
    input = new TextInput;
    input.dummy.children("input").trigger("input");
    return assertThat(input.valueIsObsolete);
  });
  input1 = new TextInput;
  input2 = new TextInput;
  input3 = new TextInput;
  input1.set("value", "Hello");
  input2.set("value", "Readonly");
  input3.set("value", "Disabled");
  input1.dummyClass = input1.dummyClass + " a";
  input2.dummyClass = input2.dummyClass + " b";
  input3.dummyClass = input3.dummyClass + " c";
  input1.updateStates();
  input2.set("readonly", true);
  input3.set("disabled", true);
  $("#qunit-header").before($("<h4>TextInput</h4>"));
  $("#qunit-header").before(input1.dummy);
  $("#qunit-header").before(input2.dummy);
  $("#qunit-header").before(input3.dummy);
  module("textareas tests");
  test("A TextArea should allow an textarea as target", function() {
    var area, target;
    target = $("<textarea></textarea>")[0];
    area = new TextArea(target);
    return assertThat(area.target === target);
  });
  test("A TextArea shouldn't allow any other node as target", function() {
    var area, errorRaised, target;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      area = new TextArea(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("A TextArea should create its own target if not provided", function() {
    var area;
    area = new TextArea;
    assertThat(area.target, notNullValue());
    return assertThat(area.target.nodeName.toLowerCase(), equalTo("textarea"));
  });
  test("The TextArea target should be added as a child of the dummy", function() {
    var area;
    area = new TextArea;
    return assertThat(area.dummy.find("textarea").length, equalTo(1));
  });
  test("The TextArea focus should be handled by the target", function() {
    var area, focusPlacedOnTheTarget;
    focusPlacedOnTheTarget = false;
    area = new TextArea;
    area.dummy.children("textarea").focus(function() {
      return focusPlacedOnTheTarget = true;
    });
    area.grabFocus();
    assertThat(focusPlacedOnTheTarget);
    assertThat(area.dummy.attr("tabindex"), nullValue());
    return assertThat(area.hasFocus);
  });
  test("Changing the value in the target should update the widget", function() {
    var signalCalled, signalValue, textarea;
    signalCalled = false;
    signalValue = null;
    textarea = new TextArea;
    textarea.valueChanged.add(function(w, v) {
      signalCalled = true;
      return signalValue = v;
    });
    textarea.dummy.children("textarea").val("hello");
    textarea.dummy.children("textarea").change();
    return assertThat(textarea.get("value"), equalTo("hello"));
  });
  test("Clicking on a textarea should give him the focus", function() {
    var textarea;
    textarea = new TextArea;
    textarea.dummy.mouseup();
    return assertThat(textarea.hasFocus);
  });
  test("Clicking on a disabled textarea shouldn't give him the focus", function() {
    var textarea;
    textarea = new TextArea;
    textarea.set("disabled", true);
    textarea.dummy.mouseup();
    return assertThat(!textarea.hasFocus);
  });
  test("TextArea should know when its content had changed and the change events isn't triggered already", function() {
    var area;
    area = new TextArea;
    area.dummy.children("textarea").trigger("input");
    return assertThat(area.valueIsObsolete);
  });
  area1 = new TextArea;
  area2 = new TextArea;
  area3 = new TextArea;
  area1.set("value", "Hello World");
  area2.set("value", "Readonly");
  area3.set("value", "Disabled");
  area2.set("readonly", true);
  area3.set("disabled", true);
  $("#qunit-header").before($("<h4>TextArea</h4>"));
  $("#qunit-header").before(area1.dummy);
  $("#qunit-header").before(area2.dummy);
  $("#qunit-header").before(area3.dummy);
  module("checkbox tests");
  test("CheckBox should allow input with a checkbox type", function() {
    var checkbox, target;
    target = $("<input type='checkbox'></input>")[0];
    checkbox = new CheckBox(target);
    return assertThat(checkbox.target === target);
  });
  test("CheckBox should allow only input with a checkbox type", function() {
    var checkbox, errorRaised, target;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      checkbox = new CheckBox(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("CheckBox should reflect the checked state of the input", function() {
    var checkbox, target;
    target = $("<input type='checkbox' checked></input>")[0];
    checkbox = new CheckBox(target);
    return assertThat(checkbox.get("checked"));
  });
  test("CheckBox should apply change made to the checked property on the target", function() {
    var checkbox, target;
    target = $("<input type='checkbox' checked></input>")[0];
    checkbox = new CheckBox(target);
    checkbox.set("checked", false);
    return assertThat(checkbox.get("checked"), equalTo(false));
  });
  test("CheckBox should be created without a target", function() {
    var checkbox, errorRaised;
    errorRaised = false;
    try {
      checkbox = new CheckBox;
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(!errorRaised);
  });
  test("CheckBox should provide a dummy", function() {
    var checkbox;
    checkbox = new CheckBox;
    return assertThat(checkbox.dummy, notNullValue());
  });
  test("CheckBox should handle the checked property as a state", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("checked", true);
    return assertThat(checkbox.dummy.hasClass("checked"));
  });
  test("CheckBox should hide its target on creation", function() {
    var checkbox, target;
    target = $("<input type='checkbox' checked></input>");
    checkbox = new CheckBox(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Clicking on a CheckBox should toggle its checked state", function() {
    var checkbox;
    checkbox = new CheckBox;
    assertThat(checkbox.get("checked"), equalTo(false));
    checkbox.click();
    assertThat(checkbox.get("checked"), equalTo(true));
    checkbox.click();
    return assertThat(checkbox.get("checked"), equalTo(false));
  });
  test("Clicking on a CheckBox shouldn't toggle its checked state when readonly", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("readonly", true);
    assertThat(checkbox.get("checked"), equalTo(false));
    checkbox.click();
    return assertThat(checkbox.get("checked"), equalTo(false));
  });
  test("Clicking on a CheckBox shouldn't toggle its checked state when disabled", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("disabled", true);
    assertThat(checkbox.get("checked"), equalTo(false));
    checkbox.click();
    return assertThat(checkbox.get("checked"), equalTo(false));
  });
  test("Clicking on a CheckBox should grab the focus", function() {
    var MockCheckBox, checkbox, focusReveiced;
    focusReveiced = false;
    MockCheckBox = (function() {
      __extends(MockCheckBox, CheckBox);
      function MockCheckBox() {
        MockCheckBox.__super__.constructor.apply(this, arguments);
      }
      MockCheckBox.prototype.focus = function(e) {
        return focusReveiced = true;
      };
      return MockCheckBox;
    })();
    checkbox = new MockCheckBox;
    checkbox.click();
    return assertThat(focusReveiced);
  });
  test("Using enter should toggle the checkbox's checked state", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.grabFocus();
    checkbox.keyup({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(checkbox.get("checked"));
  });
  test("Using space should toggle the checkbox's checked state", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.grabFocus();
    checkbox.keyup({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(checkbox.get("checked"));
  });
  test("Using enter shouldn't toggle the checkbox's checked state when readonly", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("readonly", true);
    checkbox.grabFocus();
    checkbox.keyup({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(!checkbox.get("checked"));
  });
  test("Using space shouldn't toggle the checkbox's checked state when readonly", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("readonly", true);
    checkbox.grabFocus();
    checkbox.keyup({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(!checkbox.get("checked"));
  });
  test("CheckBox reset should operate on the checked state", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("checked", true);
    checkbox.reset();
    return assertThat(!checkbox.get("checked"));
  });
  test("CheckBox should modify the value state synchronously with checked", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("checked", true);
    return assertThat(checkbox.get("value"), equalTo(true));
  });
  test("CheckBox should allow to specify a tuple of possible values", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("values", ["on", "off"]);
    assertThat(checkbox.get("value"), equalTo("off"));
    checkbox.set("checked", true);
    return assertThat(checkbox.get("value"), equalTo("on"));
  });
  test("Modifying the checkbox value should modify the checked state", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("value", true);
    return assertThat(checkbox.get("checked"));
  });
  test("Modifying the checkbox value should modify the checked state according to the values property", function() {
    var checkbox;
    checkbox = new CheckBox;
    checkbox.set("values", ["on", "off"]);
    checkbox.set("value", "on");
    return assertThat(checkbox.get("checked"));
  });
  test("CheckBox should dispatch a checkedChanged signal", function() {
    var checkbox, signalCalled, signalOrigin, signalValue;
    checkbox = new CheckBox;
    signalCalled = false;
    signalOrigin = null;
    signalValue = null;
    checkbox.checkedChanged.add(function(widget, checked) {
      signalCalled = true;
      signalOrigin = widget;
      return signalValue = checked;
    });
    checkbox.set("checked", true);
    assertThat(signalCalled);
    assertThat(signalOrigin, equalTo(checkbox));
    return assertThat(signalValue, equalTo(true));
  });
  target = $("<input type='checkbox'></input>");
  checkbox1 = new CheckBox(target[0]);
  checkbox2 = new CheckBox;
  checkbox3 = new CheckBox;
  checkbox1.set("checked", true);
  checkbox2.set("readonly", true);
  checkbox2.set("checked", true);
  checkbox3.set("disabled", true);
  $("#qunit-header").before($("<h4>CheckBox</h4>"));
  $("#qunit-header").before(target);
  $("#qunit-header").before(checkbox1.dummy);
  $("#qunit-header").before(checkbox2.dummy);
  $("#qunit-header").before(checkbox3.dummy);
  module("radio tests");
  test("Radio should allow input with a radio type", function() {
    var radio;
    target = $("<input type='radio'></input>")[0];
    radio = new Radio(target);
    return assertThat(radio.target === target);
  });
  test("Radio should allow only input with a radio type", function() {
    var errorRaised, radio;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      radio = new Radio(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("Radio should reflect the checked state of the input", function() {
    var radio;
    target = $("<input type='radio' checked></input>")[0];
    radio = new Radio(target);
    return assertThat(radio.get("checked"));
  });
  test("Radio should apply change made to the checked property on the target", function() {
    var radio;
    target = $("<input type='radio' checked></input>")[0];
    radio = new Radio(target);
    radio.set("checked", false);
    return assertThat(radio.get("checked"), equalTo(false));
  });
  test("Radio should be created without a target", function() {
    var errorRaised, radio;
    errorRaised = false;
    try {
      radio = new Radio;
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(!errorRaised);
  });
  test("Radio should provide a dummy", function() {
    var radio;
    radio = new Radio;
    return assertThat(radio.dummy, notNullValue());
  });
  test("Radio should handle the checked property as a state", function() {
    var radio;
    radio = new Radio;
    radio.set("checked", true);
    return assertThat(radio.dummy.hasClass("checked"));
  });
  test("Radio should hide its target on creation", function() {
    var radio;
    target = $("<input type='radio' checked></input>");
    radio = new Radio(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Clicking on a Radio should toggle its checked state", function() {
    var radio;
    radio = new Radio;
    assertThat(radio.get("checked"), equalTo(false));
    radio.click();
    return assertThat(radio.get("checked"), equalTo(true));
  });
  test("Clicking on a Radio several time should never toggle checked back to false", function() {
    var radio;
    radio = new Radio;
    assertThat(radio.get("checked"), equalTo(false));
    radio.click();
    assertThat(radio.get("checked"), equalTo(true));
    radio.click();
    return assertThat(radio.get("checked"), equalTo(true));
  });
  test("Clicking on a Radio shouldn't toggle its checked state when readonly", function() {
    var radio;
    radio = new Radio;
    radio.set("readonly", true);
    assertThat(radio.get("checked"), equalTo(false));
    radio.click();
    return assertThat(radio.get("checked"), equalTo(false));
  });
  test("Clicking on a Radio shouldn't toggle its checked state when disabled", function() {
    var radio;
    radio = new Radio;
    radio.set("disabled", true);
    assertThat(radio.get("checked"), equalTo(false));
    radio.click();
    return assertThat(radio.get("checked"), equalTo(false));
  });
  test("Clicking on a Radio should grab the focus", function() {
    var MockRadio, focusReveiced, radio;
    focusReveiced = false;
    MockRadio = (function() {
      __extends(MockRadio, Radio);
      function MockRadio() {
        MockRadio.__super__.constructor.apply(this, arguments);
      }
      MockRadio.prototype.focus = function(e) {
        return focusReveiced = true;
      };
      return MockRadio;
    })();
    radio = new MockRadio;
    radio.click();
    return assertThat(focusReveiced);
  });
  test("Using enter should toggle the radio's checked state", function() {
    var radio;
    radio = new Radio;
    radio.grabFocus();
    radio.keyup({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(radio.get("checked"));
  });
  test("Using space should toggle the radio's checked state", function() {
    var radio;
    radio = new Radio;
    radio.grabFocus();
    radio.keyup({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(radio.get("checked"));
  });
  test("Using enter shouldn't toggle the radio's checked state when readonly", function() {
    var radio;
    radio = new Radio;
    radio.set("readonly", true);
    radio.grabFocus();
    radio.keyup({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(!radio.get("checked"));
  });
  test("Using space shouldn't toggle the radio's checked state when readonly", function() {
    var radio;
    radio = new Radio;
    radio.set("readonly", true);
    radio.grabFocus();
    radio.keyup({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(!radio.get("checked"));
  });
  test("Radio reset should operate on the checked state", function() {
    var radio;
    radio = new Radio;
    radio.set("checked", true);
    radio.reset();
    return assertThat(!radio.get("checked"));
  });
  test("Radio should modify the value state synchronously with checked", function() {
    var radio;
    radio = new Radio;
    radio.set("checked", true);
    return assertThat(radio.get("value"), equalTo(true));
  });
  test("Radio should allow to specify a tuple of possible values", function() {
    var radio;
    radio = new Radio;
    radio.set("values", ["on", "off"]);
    assertThat(radio.get("value"), equalTo("off"));
    radio.set("checked", true);
    return assertThat(radio.get("value"), equalTo("on"));
  });
  test("Modifying the radio value should modify the checked state", function() {
    var radio;
    radio = new Radio;
    radio.set("value", true);
    return assertThat(radio.get("checked"));
  });
  test("Modifying the radio value should modify the checked state according to the values property", function() {
    var radio;
    radio = new Radio;
    radio.set("values", ["on", "off"]);
    radio.set("value", "on");
    return assertThat(radio.get("checked"));
  });
  test("Radio should dispatch a checkedChanged signal", function() {
    var radio, signalCalled, signalOrigin, signalValue;
    radio = new Radio;
    signalCalled = false;
    signalOrigin = null;
    signalValue = null;
    radio.checkedChanged.add(function(widget, checked) {
      signalCalled = true;
      signalOrigin = widget;
      return signalValue = checked;
    });
    radio.set("checked", true);
    assertThat(signalCalled);
    assertThat(signalOrigin, equalTo(radio));
    return assertThat(signalValue, equalTo(true));
  });
  target = $("<input type='radio'></input>");
  radio1 = new Radio(target[0]);
  radio2 = new Radio;
  radio3 = new Radio;
  radio2.set("readonly", true);
  radio2.set("checked", true);
  radio3.set("disabled", true);
  $("#qunit-header").before($("<h4>Radio</h4>"));
  $("#qunit-header").before(target);
  $("#qunit-header").before(radio1.dummy);
  $("#qunit-header").before(radio2.dummy);
  $("#qunit-header").before(radio3.dummy);
  module("radiogroup tests");
  test("A RadioGroup should allow any number of Radio as constructor arguments", function() {
    var group;
    group = new RadioGroup(new Radio, new Radio, new Radio);
    return assertThat(group.radios, arrayWithLength(3));
  });
  test("A RadioGroup should listen to the checkedChanged signal of its radios", function() {
    var MockRadioGroup, group, radio, signalCalled;
    signalCalled = false;
    MockRadioGroup = (function() {
      __extends(MockRadioGroup, RadioGroup);
      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }
      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };
      return MockRadioGroup;
    })();
    radio = new Radio;
    group = new MockRadioGroup(radio);
    radio.set("checked", true);
    return assertThat(signalCalled);
  });
  test("A RadioGroup should allow to add a Radio after its instanciation", function() {
    var group;
    group = new RadioGroup;
    group.add(new Radio);
    return assertThat(group.radios, arrayWithLength(1));
  });
  test("A RadioGroup should listen to a Radio added via the add method", function() {
    var MockRadioGroup, group, radio, signalCalled;
    signalCalled = false;
    MockRadioGroup = (function() {
      __extends(MockRadioGroup, RadioGroup);
      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }
      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };
      return MockRadioGroup;
    })();
    radio = new Radio;
    group = new MockRadioGroup;
    group.add(radio);
    radio.set("checked", true);
    return assertThat(signalCalled);
  });
  test("A RadioGroup should allow to remove a radio", function() {
    var group, radio;
    radio = new Radio;
    group = new RadioGroup(radio);
    group.remove(radio);
    return assertThat(group.radios, arrayWithLength(0));
  });
  test("A RadioGroup shouldn't listen to a Radio that have been removed", function() {
    var MockRadioGroup, group, radio, signalCalled;
    signalCalled = false;
    MockRadioGroup = (function() {
      __extends(MockRadioGroup, RadioGroup);
      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }
      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };
      return MockRadioGroup;
    })();
    radio = new Radio;
    group = new MockRadioGroup(radio);
    group.remove(radio);
    radio.set("checked", true);
    return assertThat(!signalCalled);
  });
  test("A RadioGroup shouldn't allow to add twice the same radio", function() {
    var group, radio;
    radio = new Radio;
    group = new RadioGroup(radio);
    group.add(radio);
    return assertThat(group.radios, arrayWithLength(1));
  });
  test("Adding a checked radio should automatically select it", function() {
    var group, radio;
    radio = new Radio;
    radio.set("checked", true);
    group = new RadioGroup(radio);
    return assertThat(group.selectedRadio, equalTo(radio));
  });
  test("RadioGroup should be able to select a radio in the group", function() {
    var group;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    group = new RadioGroup(radio1, radio2, radio3);
    group.select(radio1);
    return assertThat(group.selectedRadio, radio1);
  });
  test("Given three radios in a group, checking one should uncheck the others", function() {
    var group;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    radio1.set("checked", true);
    group = new RadioGroup(radio1, radio2, radio3);
    group.select(radio3);
    assertThat(!radio1.get("checked"));
    assertThat(!radio2.get("checked"));
    return assertThat(radio3.get("checked"));
  });
  test("Given three radios in a group, clicking on one should uncheck the others", function() {
    var group;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    radio1.set("checked", true);
    group = new RadioGroup(radio1, radio2, radio3);
    radio3.click();
    assertThat(!radio1.get("checked"));
    assertThat(!radio2.get("checked"));
    return assertThat(radio3.get("checked"));
  });
  test("Given three radios in a group, unchecking the selected one should clear the selection", function() {
    var group;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    radio1.set("checked", true);
    group = new RadioGroup(radio1, radio2, radio3);
    radio1.set("checked", false);
    return assertThat(group.selectedRadio, nullValue());
  });
  test("Given three radios in a group, calling select without an argument should clear the selection.", function() {
    var group;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    radio1.set("checked", true);
    group = new RadioGroup(radio1, radio2, radio3);
    group.select();
    return assertThat(group.selectedRadio, nullValue());
  });
  test("Selection change on a radio group should dispatch a selectionChanged signal.", function() {
    var group, signalCalled, signalNewRadio, signalOldRadio, signalSource;
    signalCalled = false;
    signalSource = null;
    signalOldRadio = null;
    signalNewRadio = null;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    group = new RadioGroup(radio1, radio2, radio3);
    group.selectionChanged.add(function(group, oldSel, newSel) {
      signalCalled = true;
      signalSource = group;
      signalOldRadio = oldSel;
      return signalNewRadio = newSel;
    });
    group.select(radio1);
    assertThat(signalCalled);
    assertThat(signalSource === group);
    assertThat(signalOldRadio, nullValue());
    return assertThat(signalNewRadio === radio1);
  });
  test("The selectionChanged signal shouldn't be dispatched when select is called with the current selection", function() {
    var group, signalCallCount;
    signalCallCount = 0;
    radio1 = new Radio;
    radio2 = new Radio;
    radio3 = new Radio;
    group = new RadioGroup(radio1, radio2, radio3);
    group.selectionChanged.add(function() {
      return signalCallCount++;
    });
    group.select(radio1);
    group.select(radio1);
    return assertThat(signalCallCount, equalTo(1));
  });
  radio1 = new Radio;
  radio2 = new Radio;
  radio3 = new Radio;
  radio3.set("checked", true);
  radio3.set("disabled", true);
  group = new RadioGroup(radio1, radio2, radio3);
  $("#qunit-header").before($("<h4>RadioGroup</h4>"));
  $("#qunit-header").before(radio1.dummy);
  $("#qunit-header").before(radio2.dummy);
  $("#qunit-header").before(radio3.dummy);
  module("numeric-widget tests");
  test("NumericWidget should allow input with type number as target", function() {
    var widget;
    target = $("<input type='number'></input>")[0];
    widget = new NumericWidget(target);
    return assertThat(widget.target === target);
  });
  test("NumericWidget should allow input with type range as target", function() {
    var widget;
    target = $("<input type='range'></input>")[0];
    widget = new NumericWidget(target);
    return assertThat(widget.target === target);
  });
  test("NumericWidget initial data should be taken from the target if provided", function() {
    var widget;
    target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")[0];
    widget = new NumericWidget(target);
    assertThat(widget.get("value"), strictlyEqualTo(10));
    assertThat(widget.get("min"), strictlyEqualTo(5));
    assertThat(widget.get("max"), strictlyEqualTo(15));
    return assertThat(widget.get("step"), strictlyEqualTo(1));
  });
  test("Changing the widget data should modify the target", function() {
    var widget;
    target = $("<input type='number' value='10' min='5' max='15' step='1'></input>");
    widget = new NumericWidget(target[0]);
    widget.set("min", 10);
    widget.set("max", 30);
    widget.set("step", 0.5);
    widget.set("value", 20);
    assertThat(target.attr("min"), strictlyEqualTo("10"));
    assertThat(target.attr("max"), strictlyEqualTo("30"));
    assertThat(target.attr("step"), strictlyEqualTo("0.5"));
    return assertThat(target.attr("value"), strictlyEqualTo("20"));
  });
  test("NumericWidget initial data should be set even without a target", function() {
    var widget;
    widget = new NumericWidget;
    assertThat(widget.get("value"), strictlyEqualTo(0));
    assertThat(widget.get("min"), strictlyEqualTo(0));
    assertThat(widget.get("max"), strictlyEqualTo(100));
    return assertThat(widget.get("step"), strictlyEqualTo(1));
  });
  test("NumericWidget value shouldn't be set on a value outside of the range", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", -10);
    assertThat(widget.get("value"), strictlyEqualTo(0));
    widget.set("value", 1000);
    return assertThat(widget.get("value"), strictlyEqualTo(100));
  });
  test("NumericWidget value should be constrained by step", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("step", 3);
    widget.set("value", 10);
    return assertThat(widget.get("value"), strictlyEqualTo(9));
  });
  test("Changing widget's min property should correct the value if it goes out of the range", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("min", 50);
    return assertThat(widget.get("value"), strictlyEqualTo(50));
  });
  test("Changing widget's max property should correct the value if it goes out of the range", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 100);
    widget.set("max", 50);
    return assertThat(widget.get("value"), strictlyEqualTo(50));
  });
  test("Changing widget's step property should correct the value if it doesn't snap anymore", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.set("step", 3);
    return assertThat(widget.get("value"), strictlyEqualTo(9));
  });
  test("Setting a min value greater than the max value shouldn't be allowed", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("min", 100);
    return assertThat(widget.get("min"), strictlyEqualTo(0));
  });
  test("Setting a max value lower than the min value shouldn't be allowed", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("max", 0);
    return assertThat(widget.get("max"), strictlyEqualTo(100));
  });
  test("NumericWidget should hide their target", function() {
    var widget;
    target = $("<input type='range' value='10' min='0' max='50' step='1'></input>");
    widget = new NumericWidget(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Concret numeric widgets class should receive an updateDummy call when value change", function() {
    var MockNumericWidget, updateDummyCalled, widget;
    updateDummyCalled = false;
    MockNumericWidget = (function() {
      __extends(MockNumericWidget, NumericWidget);
      function MockNumericWidget() {
        MockNumericWidget.__super__.constructor.apply(this, arguments);
      }
      MockNumericWidget.prototype.updateDummy = function(value, min, max) {
        return updateDummyCalled = true;
      };
      return MockNumericWidget;
    })();
    widget = new MockNumericWidget;
    widget.set("value", 20);
    return assertThat(updateDummyCalled);
  });
  test("NumericWidget should allow to increment the value through a function", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("step", 5);
    widget.increment();
    return assertThat(widget.get("value"), equalTo(5));
  });
  test("NumericWidget should allow to increment the value through a function", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.set("step", 5);
    widget.decrement();
    return assertThat(widget.get("value"), equalTo(5));
  });
  asyncTest("NumericWidget should provide a way to increment the value on an interval", function() {
    var widget;
    widget = new NumericWidget;
    widget.startIncrement();
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("NumericWidget should be able to stop an increment interval", function() {
    var widget;
    widget = new NumericWidget;
    widget.startIncrement();
    setTimeout(function() {
      return widget.endIncrement();
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 300);
  });
  asyncTest("NumericWidget should provide a way to decrement the value on an interval", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.startDecrement();
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("NumericWidget should be able to stop an decrement interval", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.startDecrement();
    setTimeout(function() {
      return widget.endDecrement();
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 300);
  });
  asyncTest("NumericWidget shouldn't start several interval when startIncrement is called many times", function() {
    var widget;
    widget = new NumericWidget;
    widget.startIncrement();
    widget.startIncrement();
    widget.startIncrement();
    widget.startIncrement();
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("NumericWidget shouldn't start several interval when startDecrement is called many times", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.startDecrement();
    widget.startDecrement();
    widget.startDecrement();
    widget.startDecrement();
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the up key is pressed the widget should increment the value", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    widget.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the up key shouldn't trigger several increment", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the up key is released the widget should stop increment the value", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    setTimeout(function() {
      return widget.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keyup(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the down key should return false to prevent scrolling", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    return assertThat(!widget.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the up key should return false to prevent scrolling", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    return assertThat(!widget.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the down key is pressed the widget should decrement the value", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.grabFocus();
    widget.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the down key shouldn't trigger several decrement", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the down key is released the widget should stop decrement the value", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    setTimeout(function() {
      return widget.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keyup(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("readonly", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("readonly", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("disabled", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("disabled", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is pressed the widget should increment the value", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    widget.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the right key shouldn't trigger several increment", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is released the widget should stop increment the value", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    setTimeout(function() {
      return widget.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keyup(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the left key should return false to prevent scrolling", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    return assertThat(!widget.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the right key should return false to prevent scrolling", function() {
    var widget;
    widget = new NumericWidget;
    widget.grabFocus();
    return assertThat(!widget.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the left key is pressed the widget should decrement the value", function() {
    var widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    widget.grabFocus();
    widget.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the left key shouldn't trigger several decrement", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the left key is released the widget should stop decrement the value", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    setTimeout(function() {
      return widget.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.grabFocus();
    widget.keydown(e);
    widget.keyup(e);
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("readonly", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("readonly", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("disabled", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled widget shouldn't work", function() {
    var e, widget;
    widget = new NumericWidget;
    widget.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    widget.set("disabled", true);
    widget.grabFocus();
    widget.keydown(e);
    return setTimeout(function() {
      assertThat(widget.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  test("Using the mousewheel over a widget should change the value according to the step", function() {
    var MockNumericWidget, widget;
    MockNumericWidget = (function() {
      __extends(MockNumericWidget, NumericWidget);
      function MockNumericWidget() {
        MockNumericWidget.__super__.constructor.apply(this, arguments);
      }
      MockNumericWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockNumericWidget.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockNumericWidget.__super__.mousewheel.call(this, e, d);
      };
      return MockNumericWidget;
    })();
    widget = new MockNumericWidget;
    widget.set("step", 4);
    widget.dummy.mousewheel();
    return assertThat(widget.get("value"), strictlyEqualTo(4));
  });
  test("Using the mousewheel over a readonly widget shouldn't change the value", function() {
    var MockNumericWidget, widget;
    MockNumericWidget = (function() {
      __extends(MockNumericWidget, NumericWidget);
      function MockNumericWidget() {
        MockNumericWidget.__super__.constructor.apply(this, arguments);
      }
      MockNumericWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockNumericWidget.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockNumericWidget.__super__.mousewheel.call(this, e, d);
      };
      return MockNumericWidget;
    })();
    widget = new MockNumericWidget;
    widget.set("readonly", true);
    widget.dummy.mousewheel();
    return assertThat(widget.get("value"), strictlyEqualTo(0));
  });
  test("Using the mousewheel over a disabled widget shouldn't change the value", function() {
    var MockNumericWidget, widget;
    MockNumericWidget = (function() {
      __extends(MockNumericWidget, NumericWidget);
      function MockNumericWidget() {
        MockNumericWidget.__super__.constructor.apply(this, arguments);
      }
      MockNumericWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };
      MockNumericWidget.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockNumericWidget.__super__.mousewheel.call(this, e, d);
      };
      return MockNumericWidget;
    })();
    widget = new MockNumericWidget;
    widget.set("disabled", true);
    widget.dummy.mousewheel();
    return assertThat(widget.get("value"), strictlyEqualTo(0));
  });
  module("sliders tests");
  test("Slider should allow input of type range", function() {
    var slider;
    target = $("<input type='range'></input>")[0];
    slider = new Slider(target);
    return assertThat(slider.target === target);
  });
  test("Slider shouldn't allow input of a type different than range", function() {
    var errorRaised, slider;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      slider = new Slider(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("Slider initial data should be taken from the target if provided", function() {
    var slider;
    target = $("<input type='range' value='10' min='5' max='15' step='1'></input>")[0];
    slider = new Slider(target);
    assertThat(slider.get("value"), strictlyEqualTo(10));
    assertThat(slider.get("min"), strictlyEqualTo(5));
    assertThat(slider.get("max"), strictlyEqualTo(15));
    return assertThat(slider.get("step"), strictlyEqualTo(1));
  });
  test("Changing the slider data should modify the target", function() {
    var slider;
    target = $("<input type='range' value='10' min='5' max='15' step='1'></input>");
    slider = new Slider(target[0]);
    slider.set("min", 10);
    slider.set("max", 30);
    slider.set("step", 0.5);
    slider.set("value", 20);
    assertThat(target.attr("min"), strictlyEqualTo("10"));
    assertThat(target.attr("max"), strictlyEqualTo("30"));
    assertThat(target.attr("step"), strictlyEqualTo("0.5"));
    return assertThat(target.attr("value"), strictlyEqualTo("20"));
  });
  test("Slider initial data should be set even without a target", function() {
    var slider;
    slider = new Slider;
    assertThat(slider.get("value"), strictlyEqualTo(0));
    assertThat(slider.get("min"), strictlyEqualTo(0));
    assertThat(slider.get("max"), strictlyEqualTo(100));
    return assertThat(slider.get("step"), strictlyEqualTo(1));
  });
  test("Slider value shouldn't be set on a value outside of the range", function() {
    var slider;
    slider = new Slider;
    slider.set("value", -10);
    assertThat(slider.get("value"), strictlyEqualTo(0));
    slider.set("value", 1000);
    return assertThat(slider.get("value"), strictlyEqualTo(100));
  });
  test("Slider value should be constrained by step", function() {
    var slider;
    slider = new Slider;
    slider.set("step", 3);
    slider.set("value", 10);
    return assertThat(slider.get("value"), strictlyEqualTo(9));
  });
  test("Changing slider's min property should correct the value if it goes out of the range", function() {
    var slider;
    slider = new Slider;
    slider.set("min", 50);
    return assertThat(slider.get("value"), strictlyEqualTo(50));
  });
  test("Changing slider's max property should correct the value if it goes out of the range", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 100);
    slider.set("max", 50);
    return assertThat(slider.get("value"), strictlyEqualTo(50));
  });
  test("Changing slider's step property should correct the value if it doesn't snap anymore", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 10);
    slider.set("step", 3);
    return assertThat(slider.get("value"), strictlyEqualTo(9));
  });
  test("Setting a min value greater than the max value shouldn't be allowed", function() {
    var slider;
    slider = new Slider;
    slider.set("min", 100);
    return assertThat(slider.get("min"), strictlyEqualTo(0));
  });
  test("Setting a max value lower than the min value shouldn't be allowed", function() {
    var slider;
    slider = new Slider;
    slider.set("max", 0);
    return assertThat(slider.get("max"), strictlyEqualTo(100));
  });
  test("Sliders should have a dummy", function() {
    var slider;
    slider = new Slider;
    return assertThat(slider.dummy, notNullValue());
  });
  test("Sliders's .value child text should be the sliders value", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 15);
    return assertThat(slider.dummy.children(".value").text(), strictlyEqualTo("15"));
  });
  test("Sliders's .value child text should be the sliders value even after instanciation", function() {
    var slider;
    slider = new Slider;
    return assertThat(slider.dummy.children(".value").text(), strictlyEqualTo("0"));
  });
  test("Sliders's .knob child position should be proportionate to the value", function() {
    var slider;
    slider = new Slider;
    slider.dummy.attr("style", "width:100px");
    slider.dummy.children(".knob").attr("style", "width:20px");
    slider.set("value", 25);
    return assertThat(slider.dummy.children(".knob").css("left"), strictlyEqualTo("20px"));
  });
  test("The slider should allow to adjust the value text to the knob", function() {
    var slider;
    slider = new Slider;
    slider.dummy.attr("style", "width:100px");
    slider.dummy.children(".knob").attr("style", "width:20px");
    slider.dummy.children(".value").attr("style", "width:10px");
    slider.set("value", 25);
    return assertThat(slider.dummy.children(".value").css("left"), strictlyEqualTo("25px"));
  });
  test("Sliders should hide their target", function() {
    var slider;
    target = $("<input type='range' value='10' min='0' max='50' step='1'></input>");
    slider = new Slider(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("Pressing the mouse on the knob should init drag", function() {
    var slider;
    slider = new Slider;
    slider.dummy.children(".knob").mousedown();
    return assertThat(slider.draggingKnob);
  });
  test("Releasing the mouse anywhere when a slider is dragging should stop the drag", function() {
    var slider;
    slider = new Slider;
    slider.dummy.children(".knob").mousedown();
    $(document).mouseup();
    return assertThat(!slider.draggingKnob);
  });
  test("Moving the mouse during a drag should call the drag method", function() {
    var MockSlider, dragCalled, slider;
    dragCalled = false;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.drag = function() {
        return dragCalled = true;
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.dummy.children(".knob").mousedown();
    $(document).mousemove();
    return assertThat(dragCalled);
  });
  test("Starting a drag should register the mouse page position", function() {
    var MockSlider, event, slider;
    event = null;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.startDrag = function(e) {
        e.pageX = 40;
        e.pageY = 40;
        MockSlider.__super__.startDrag.call(this, e);
        return event = e;
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    $("#qunit-header").before(slider.dummy);
    slider.dummy.children(".knob").mousedown();
    slider.dummy.remove();
    assertThat(event, notNullValue());
    assertThat(slider.lastMouseX, equalTo(event.pageX));
    return assertThat(slider.lastMouseY, equalTo(event.pageY));
  });
  test("While dragging the knob, a slider should be able to measure the distance since the last callback", function() {
    var MockSlider, dragData, slider;
    dragData = null;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.startDrag = function(e) {
        e.pageX = 40;
        e.pageY = 38;
        return MockSlider.__super__.startDrag.call(this, e);
      };
      MockSlider.prototype.drag = function(e) {
        e.pageX = 50;
        e.pageY = 52;
        dragData = this.getDragDataFromEvent(e);
        return MockSlider.__super__.drag.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.dummy.children(".knob").mousedown();
    $(document).mousemove();
    return assertThat(dragData, allOf(notNullValue(), hasProperty("x", equalTo(10)), hasProperty("y", equalTo(14))));
  });
  test("While dragging the knob, a slider should register the new mouse position at the end of the callback", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.drag = function(e) {
        e.pageX = 50;
        e.pageY = 52;
        return MockSlider.__super__.drag.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.dummy.children(".knob").mousedown();
    $(document).mousemove();
    assertThat(slider.lastMouseX, strictlyEqualTo(50));
    return assertThat(slider.lastMouseY, strictlyEqualTo(52));
  });
  test("While dragging the knob, a slider should update its value according to the move distance", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.startDrag = function(e) {
        e.pageX = 40;
        e.pageY = 38;
        return MockSlider.__super__.startDrag.call(this, e);
      };
      MockSlider.prototype.drag = function(e) {
        e.pageX = 50;
        e.pageY = 52;
        return MockSlider.__super__.drag.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("min", 10);
    slider.set("max", 110);
    slider.dummy.attr("style", "width:100px");
    slider.dummy.children(".knob").attr("style", "width:50px");
    slider.dummy.children(".knob").mousedown();
    $(document).mousemove();
    return assertThat(slider.get("value"), strictlyEqualTo(30));
  });
  test("Sliders should have the focus after starting a drag gesture", function() {
    var slider;
    slider = new Slider;
    slider.dummy.children(".knob").mousedown();
    return assertThat(slider.hasFocus);
  });
  test("Readonly sliders shouldn't allow drag", function() {
    var slider;
    slider = new Slider;
    slider.set("readonly", true);
    slider.dummy.children(".knob").mousedown();
    return assertThat(!slider.draggingKnob);
  });
  test("Disabled sliders shouldn't allow drag", function() {
    var slider;
    slider = new Slider;
    slider.set("disabled", true);
    slider.dummy.children(".knob").mousedown();
    return assertThat(!slider.draggingKnob);
  });
  test("Using the mousewheel over a slider should change the value according to the step", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockSlider.__super__.mousewheel.call(this, e, d);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("step", 4);
    slider.dummy.mousewheel();
    return assertThat(slider.get("value"), strictlyEqualTo(4));
  });
  test("Using the mousewheel over a readonly slider shouldn't change the value", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockSlider.__super__.mousewheel.call(this, e, d);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("readonly", true);
    slider.dummy.mousewheel();
    return assertThat(slider.get("value"), strictlyEqualTo(0));
  });
  test("Using the mousewheel over a disabled slider shouldn't change the value", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockSlider.__super__.mousewheel.call(this, e, d);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("disabled", true);
    slider.dummy.mousewheel();
    return assertThat(slider.get("value"), strictlyEqualTo(0));
  });
  asyncTest("When the up key is pressed the slider should increment the value", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    slider.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the up key shouldn't trigger several increment", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the up key is released the slider should stop increment the value", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    setTimeout(function() {
      return slider.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keyup(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the down key should return false to prevent scrolling", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    return assertThat(!slider.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the up key should return false to prevent scrolling", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    return assertThat(!slider.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the down key is pressed the slider should decrement the value", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 10);
    slider.grabFocus();
    slider.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the down key shouldn't trigger several decrement", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the down key is released the slider should stop decrement the value", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    setTimeout(function() {
      return slider.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keyup(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("readonly", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("readonly", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("disabled", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("disabled", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is pressed the slider should increment the value", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    slider.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the right key shouldn't trigger several increment", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is released the slider should stop increment the value", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    setTimeout(function() {
      return slider.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keyup(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the left key should return false to prevent scrolling", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    return assertThat(!slider.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the right key should return false to prevent scrolling", function() {
    var slider;
    slider = new Slider;
    slider.grabFocus();
    return assertThat(!slider.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the left key is pressed the slider should decrement the value", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 10);
    slider.grabFocus();
    slider.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the left key shouldn't trigger several decrement", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the left key is released the slider should stop decrement the value", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    setTimeout(function() {
      return slider.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.grabFocus();
    slider.keydown(e);
    slider.keyup(e);
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("readonly", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("readonly", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("disabled", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled slider shouldn't work", function() {
    var e, slider;
    slider = new Slider;
    slider.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    slider.set("disabled", true);
    slider.grabFocus();
    slider.keydown(e);
    return setTimeout(function() {
      assertThat(slider.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  test("Pressing the mouse over the track should change the value, grab the focus and start a knob drag", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.dummy.width(100);
    slider.dummy.find(".track").width(100);
    slider.dummy.children(".track").mousedown();
    assertThat(slider.get("value"), equalTo(10));
    assertThat(slider.draggingKnob);
    return assertThat(slider.hasFocus);
  });
  test("Pressing the mouse over a disabled track shouldn't change the value ", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("disabled", true);
    slider.dummy.width(100);
    slider.dummy.children(".track").mousedown();
    assertThat(slider.get("value"), equalTo(0));
    return assertThat(!slider.draggingKnob);
  });
  test("Pressing the mouse over a readonly track shouldn't change the value ", function() {
    var MockSlider, slider;
    MockSlider = (function() {
      __extends(MockSlider, Slider);
      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }
      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };
      return MockSlider;
    })();
    slider = new MockSlider;
    slider.set("readonly", true);
    slider.dummy.width(100);
    slider.dummy.children(".track").mousedown();
    assertThat(slider.get("value"), equalTo(0));
    return assertThat(!slider.draggingKnob);
  });
  test("Stepper should allow to increment the value through a function", function() {
    var slider;
    slider = new Slider;
    slider.set("step", 5);
    slider.increment();
    return assertThat(slider.get("value"), equalTo(5));
  });
  test("Stepper should allow to increment the value through a function", function() {
    var slider;
    slider = new Slider;
    slider.set("value", 10);
    slider.set("step", 5);
    slider.decrement();
    return assertThat(slider.get("value"), equalTo(5));
  });
  $(document).mouseup();
  target = $("<input type='range' value='10' min='0' max='50' step='1'></input>");
  slider1 = new Slider(target[0]);
  slider2 = new Slider;
  slider3 = new Slider;
  slider1.valueCenteredOnKnob = true;
  slider2.valueCenteredOnKnob = true;
  slider3.valueCenteredOnKnob = true;
  slider1.set("value", 12);
  slider2.set("value", 45);
  slider3.set("value", 78);
  slider2.set("readonly", true);
  slider3.set("disabled", true);
  $("#qunit-header").before($("<h4>Sliders</h4>"));
  $("#qunit-header").before(target);
  $("#qunit-header").before(slider1.dummy);
  $("#qunit-header").before(slider2.dummy);
  $("#qunit-header").before(slider3.dummy);
  module("stepper tests");
  test("Stepper should allow input with type number as target", function() {
    var stepper;
    target = $("<input type='number'></input>")[0];
    stepper = new Stepper(target);
    return assertThat(stepper.target === target);
  });
  test("Stepper shouldn't allow input of a type different than range", function() {
    var errorRaised, stepper;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      stepper = new Stepper(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("Stepper initial data should be taken from the target if provided", function() {
    var stepper;
    target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")[0];
    stepper = new Stepper(target);
    assertThat(stepper.get("value"), strictlyEqualTo(10));
    assertThat(stepper.get("min"), strictlyEqualTo(5));
    assertThat(stepper.get("max"), strictlyEqualTo(15));
    return assertThat(stepper.get("step"), strictlyEqualTo(1));
  });
  test("Changing the stepper data should modify the target", function() {
    var stepper;
    target = $("<input type='number' value='10' min='5' max='15' step='1'></input>");
    stepper = new Stepper(target[0]);
    stepper.set("min", 10);
    stepper.set("max", 30);
    stepper.set("step", 0.5);
    stepper.set("value", 20);
    assertThat(target.attr("min"), strictlyEqualTo("10"));
    assertThat(target.attr("max"), strictlyEqualTo("30"));
    assertThat(target.attr("step"), strictlyEqualTo("0.5"));
    return assertThat(target.attr("value"), strictlyEqualTo("20"));
  });
  test("Stepper initial data should be set even without a target", function() {
    var stepper;
    stepper = new Stepper;
    assertThat(stepper.get("value"), strictlyEqualTo(0));
    assertThat(stepper.get("min"), strictlyEqualTo(0));
    assertThat(stepper.get("max"), strictlyEqualTo(100));
    return assertThat(stepper.get("step"), strictlyEqualTo(1));
  });
  test("Stepper value shouldn't be set on a value outside of the range", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", -10);
    assertThat(stepper.get("value"), strictlyEqualTo(0));
    stepper.set("value", 1000);
    return assertThat(stepper.get("value"), strictlyEqualTo(100));
  });
  test("Stepper value should be constrained by step", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("step", 3);
    stepper.set("value", 10);
    return assertThat(stepper.get("value"), strictlyEqualTo(9));
  });
  test("Changing stepper's min property should correct the value if it goes out of the range", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("min", 50);
    return assertThat(stepper.get("value"), strictlyEqualTo(50));
  });
  test("Changing stepper's max property should correct the value if it goes out of the range", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 100);
    stepper.set("max", 50);
    return assertThat(stepper.get("value"), strictlyEqualTo(50));
  });
  test("Changing stepper's step property should correct the value if it doesn't snap anymore", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.set("step", 3);
    return assertThat(stepper.get("value"), strictlyEqualTo(9));
  });
  test("Setting a min value greater than the max value shouldn't be allowed", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("min", 100);
    return assertThat(stepper.get("min"), strictlyEqualTo(0));
  });
  test("Setting a max value lower than the min value shouldn't be allowed", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("max", 0);
    return assertThat(stepper.get("max"), strictlyEqualTo(100));
  });
  test("Stepper should allow to increment the value through a function", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("step", 5);
    stepper.increment();
    return assertThat(stepper.get("value"), equalTo(5));
  });
  test("Stepper should allow to increment the value through a function", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.set("step", 5);
    stepper.decrement();
    return assertThat(stepper.get("value"), equalTo(5));
  });
  asyncTest("When the up key is pressed the stepper should increment the value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    stepper.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the up key shouldn't trigger several increment", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the up key is released the stepper should stop increment the value", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    setTimeout(function() {
      return stepper.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keyup(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the down key should return false to prevent scrolling", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    return assertThat(!stepper.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the up key should return false to prevent scrolling", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    return assertThat(!stepper.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the down key is pressed the stepper should decrement the value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.grabFocus();
    stepper.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the down key shouldn't trigger several decrement", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the down key is released the stepper should stop decrement the value", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    setTimeout(function() {
      return stepper.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keyup(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("readonly", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("readonly", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("disabled", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("disabled", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is pressed the stepper should increment the value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    stepper.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the right key shouldn't trigger several increment", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("When the right key is released the stepper should stop increment the value", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    setTimeout(function() {
      return stepper.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the increment on keyup should allow to start a new one", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keyup(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  test("Pressing the left key should return false to prevent scrolling", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    return assertThat(!stepper.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  test("Pressing the right key should return false to prevent scrolling", function() {
    var stepper;
    stepper = new Stepper;
    stepper.grabFocus();
    return assertThat(!stepper.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    }));
  });
  asyncTest("When the left key is pressed the stepper should decrement the value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.grabFocus();
    stepper.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Receiving several keydown of the left key shouldn't trigger several decrement", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("When the left key is released the stepper should stop decrement the value", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    setTimeout(function() {
      return stepper.keyup(e);
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Stopping the decrement on keyup should allow to start a new one", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.grabFocus();
    stepper.keydown(e);
    stepper.keyup(e);
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a readonly stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("readonly", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a readonly stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("readonly", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to increment a disabled stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    e = {
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("disabled", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(0, 1));
      return start();
    }, 100);
  });
  asyncTest("Trying to decrement a disabled stepper shouldn't work", function() {
    var e, stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    e = {
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    };
    stepper.set("disabled", true);
    stepper.grabFocus();
    stepper.keydown(e);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(10, 1));
      return start();
    }, 100);
  });
  test("Using the mousewheel over a stepper should change the value according to the step", function() {
    var MockStepper, stepper;
    MockStepper = (function() {
      __extends(MockStepper, Stepper);
      function MockStepper() {
        MockStepper.__super__.constructor.apply(this, arguments);
      }
      MockStepper.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockStepper.__super__.mousewheel.call(this, e, d);
      };
      return MockStepper;
    })();
    stepper = new MockStepper;
    stepper.set("step", 4);
    stepper.dummy.mousewheel();
    return assertThat(stepper.get("value"), strictlyEqualTo(4));
  });
  test("Using the mousewheel over a readonly stepper shouldn't change the value", function() {
    var MockStepper, stepper;
    MockStepper = (function() {
      __extends(MockStepper, Stepper);
      function MockStepper() {
        MockStepper.__super__.constructor.apply(this, arguments);
      }
      MockStepper.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockStepper.__super__.mousewheel.call(this, e, d);
      };
      return MockStepper;
    })();
    stepper = new MockStepper;
    stepper.set("readonly", true);
    stepper.dummy.mousewheel();
    return assertThat(stepper.get("value"), strictlyEqualTo(0));
  });
  test("Using the mousewheel over a disabled stepper shouldn't change the value", function() {
    var MockStepper, stepper;
    MockStepper = (function() {
      __extends(MockStepper, Stepper);
      function MockStepper() {
        MockStepper.__super__.constructor.apply(this, arguments);
      }
      MockStepper.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockStepper.__super__.mousewheel.call(this, e, d);
      };
      return MockStepper;
    })();
    stepper = new MockStepper;
    stepper.set("disabled", true);
    stepper.dummy.mousewheel();
    return assertThat(stepper.get("value"), strictlyEqualTo(0));
  });
  test("Stepper shouldn't take focus, instead it should give it to its value input", function() {
    var focusPlacedOnTheInput, stepper;
    focusPlacedOnTheInput = false;
    stepper = new Stepper;
    stepper.dummy.children(".value").focus(function() {
      return focusPlacedOnTheInput = true;
    });
    stepper.grabFocus();
    assertThat(focusPlacedOnTheInput);
    assertThat(stepper.dummy.attr("tabindex"), nullValue());
    return assertThat(stepper.hasFocus);
  });
  test("Clicking on a stepper should give him the focus", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.mouseup();
    return assertThat(stepper.hasFocus);
  });
  test("Stepper's input should reflect the state of the widget", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("readonly", true);
    stepper.set("disabled", true);
    assertThat(stepper.dummy.children(".value").attr("readonly"), notNullValue());
    return assertThat(stepper.dummy.children(".value").attr("disabled"), notNullValue());
  });
  test("Stepper's input value should be the stepper value", function() {
    var stepper;
    stepper = new Stepper;
    return assertThat(stepper.dummy.children(".value").attr("value"), equalTo("0"));
  });
  test("Stepper's input value should be the stepper value after a change", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 20);
    return assertThat(stepper.dummy.children(".value").attr("value"), equalTo("20"));
  });
  test("When the value change in the stepper's input, the stepper should validate the new value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".value").val("40");
    stepper.dummy.children(".value").change();
    return assertThat(stepper.get("value"), strictlyEqualTo(40));
  });
  test("When the value in the stepper's input is invalid, the stepper should turn it back to the valid value", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".value").val("abcd");
    stepper.dummy.children(".value").change();
    return assertThat(stepper.dummy.children(".value").attr("value"), strictlyEqualTo("0"));
  });
  asyncTest("Pressing the mouse on the minus button should start a decrement interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.dummy.children(".down").mousedown();
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 100);
  });
  asyncTest("Releasing the mouse on the minus button should stop the decrement interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.dummy.children(".down").mousedown();
    setTimeout(function() {
      return stepper.dummy.children(".down").mouseup();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });
  asyncTest("Pressing the mouse on the plus button should start a increment interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".up").mousedown();
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 100);
  });
  asyncTest("Releasing the mouse on the plus button should stop the increment interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".up").mousedown();
    setTimeout(function() {
      return stepper.dummy.children(".up").mouseup();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });
  target = $("<input type='number' value='10' min='0' max='50' step='1'></input>");
  stepper1 = new Stepper(target[0]);
  stepper2 = new Stepper;
  stepper3 = new Stepper;
  stepper1.valueCenteredOnKnob = true;
  stepper2.valueCenteredOnKnob = true;
  stepper3.valueCenteredOnKnob = true;
  stepper1.set("value", 12);
  stepper2.set("value", 45);
  stepper3.set("value", 78);
  stepper2.set("readonly", true);
  stepper3.set("disabled", true);
  $("#qunit-header").before($("<h4>Steppers</h4>"));
  $("#qunit-header").before(target);
  $("#qunit-header").before(stepper1.dummy);
  $("#qunit-header").before(stepper2.dummy);
  $("#qunit-header").before(stepper3.dummy);
  module("file picker tests");
  test("A FilePicker should allow a target of type file", function() {
    var picker;
    target = $("<input type='file'></input>")[0];
    picker = new FilePicker(target);
    return assertThat(picker.target === target);
  });
  test("A FilePicker shouldn't allow a target of with a type different than file", function() {
    var errorRaised, picker;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      picker = new FilePicker(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("A FilePicker should create a target when not provided in the constructor", function() {
    var picker;
    picker = new FilePicker;
    return assertThat(picker.target, notNullValue());
  });
  test("The FilePicker's dummy should contains the target as child.", function() {
    var picker;
    picker = new FilePicker;
    return assertThat(picker.dummy.children("input").length, equalTo(1));
  });
  test("The FilePicker's value span should contains a default value when no file was picked", function() {
    var picker;
    picker = new FilePicker;
    return assertThat(picker.dummy.children(".value").text(), equalTo("Browse"));
  });
  test("A readonly FilePicker should hide its target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("readonly", true);
    return assertThat(picker.dummy.children("input").attr("style"), contains("display: none"));
  });
  test("A disabled FilePicker should hide its target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("disabled", true);
    return assertThat(picker.dummy.children("input").attr("style"), contains("display: none"));
  });
  test("Enabling a FilePicker should show its target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("disabled", true);
    picker.set("disabled", false);
    return assertThat(picker.dummy.children("input").attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Allowing writing in a FilePicker should show its target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("readonly", true);
    picker.set("readonly", false);
    return assertThat(picker.dummy.children("input").attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Enabling a readonly widget shouldn't show the target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("readonly", true);
    picker.set("disabled", true);
    picker.set("disabled", false);
    return assertThat(picker.dummy.children("input").attr("style"), contains("display: none"));
  });
  test("Enabling writing on a disabled widget shouldn't show the target", function() {
    var picker;
    picker = new FilePicker;
    picker.set("disabled", true);
    picker.set("readonly", true);
    picker.set("readonly", false);
    return assertThat(picker.dummy.children("input").attr("style"), contains("display: none"));
  });
  test("A FilePicker should register to the change event of the target", function() {
    var MockFilePicker, picker, targetChangeWasCalled;
    targetChangeWasCalled = false;
    MockFilePicker = (function() {
      __extends(MockFilePicker, FilePicker);
      function MockFilePicker() {
        MockFilePicker.__super__.constructor.apply(this, arguments);
      }
      MockFilePicker.prototype.targetChange = function(e) {
        return targetChangeWasCalled = true;
      };
      return MockFilePicker;
    })();
    picker = new MockFilePicker;
    picker.jTarget.change();
    return assertThat(targetChangeWasCalled);
  });
  test("A FilePicker should be able to set a new text in the value span", function() {
    var picker;
    picker = new FilePicker;
    picker.setValueLabel("hello");
    return assertThat(picker.dummy.children(".value").text(), equalTo("hello"));
  });
  test("A change made to the target that end with an undefined value should empty the dummy's title attribute", function() {
    var picker;
    picker = new FilePicker;
    picker.setValueLabel("hello");
    picker.jTarget.change();
    return assertThat(picker.dummy.attr("title"), equalTo(""));
  });
  test("FilePicker shouldn't take focus, instead it should give it to its target input", function() {
    var focusPlacedOnTheInput, picker;
    focusPlacedOnTheInput = false;
    picker = new FilePicker;
    picker.dummy.children("input").focus(function() {
      return focusPlacedOnTheInput = true;
    });
    picker.grabFocus();
    assertThat(focusPlacedOnTheInput);
    assertThat(picker.dummy.attr("tabindex"), nullValue());
    return assertThat(picker.hasFocus);
  });
  picker1 = new FilePicker;
  picker2 = new FilePicker;
  picker3 = new FilePicker;
  picker2.set("readonly", true);
  picker3.set("disabled", true);
  $("#qunit-header").before($("<h4>File Pickers</h4>"));
  $("#qunit-header").before(picker1.dummy);
  $("#qunit-header").before(picker2.dummy);
  $("#qunit-header").before(picker3.dummy);
  module("menu model tests");
  test("MenuModel should contains a list of action items", function() {
    var item1, item2, model;
    item1 = {
      display: "irrelevant"
    };
    item2 = {
      display: "irrelevant"
    };
    model = new MenuModel(item1, item2);
    assertThat(model.size(), equalTo(2));
    assertThat(model.items[0] === item1);
    return assertThat(model.items[1] === item2);
  });
  test("MenuModel should prevent invalid or incomplete actions to be passed in its constructor", function() {
    var item1, item2, item3, item4, model;
    item1 = {
      action: function() {}
    };
    item2 = {
      display: "irrelevant",
      action: "irrelevant"
    };
    item3 = null;
    item4 = "foo";
    model = new MenuModel(item1, item2, item3, item4);
    return assertThat(model.size(), equalTo(0));
  });
  test("MenuModel should allow to add items later", function() {
    var item1, item2, model;
    model = new MenuModel;
    item1 = {
      display: "irrelevant"
    };
    item2 = {
      display: "irrelevant"
    };
    model.add(item1, item2);
    assertThat(model.size(), equalTo(2));
    assertThat(model.items[0] === item1);
    return assertThat(model.items[1] === item2);
  });
  test("MenuModel should prevent invalid or incomplete actions to be added", function() {
    var item1, item2, item3, item4, model;
    item1 = {
      action: function() {}
    };
    item2 = {
      display: "irrelevant",
      action: "irrelevant"
    };
    item3 = null;
    item4 = "foo";
    model = new MenuModel;
    model.add(item1, item2, item3, item4);
    return assertThat(model.size(), equalTo(0));
  });
  test("MenuModel should allow to remove items", function() {
    var item1, item2, item3, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    model.remove(item1, item2);
    assertThat(model.size(), equalTo(1));
    return assertThat(model.items[0] === item3);
  });
  test("When modified, a MenuModel should dispatch a contentChanged signal", function() {
    var item, listener, model, signalCalled;
    model = new MenuModel;
    item = {
      display: "irrelevant"
    };
    signalCalled = false;
    listener = function() {
      return signalCalled = true;
    };
    model.contentChanged.add(listener);
    model.add(item);
    assertThat(signalCalled);
    signalCalled = false;
    model.remove(item);
    return assertThat(signalCalled);
  });
  test("A MenuModel should be able to handle sub models", function() {
    var item1, item2, item3, item4, model;
    item3 = {
      display: "display3"
    };
    item4 = {
      display: "display4"
    };
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      menu: new MenuModel(item3, item4)
    };
    model = new MenuModel(item1, item2);
    assertThat(model.items[1].menu.items, arrayWithLength(2));
    assertThat(model.items[1].menu.items[0] === item3);
    return assertThat(model.items[1].menu.items[1] === item4);
  });
  module("menu list tests");
  test("A MenuList should take a MenuModel as argument", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    return assertThat(list.get("model") === model);
  });
  test("MenuList's dummy should be a list that contains the elements in the model", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    assertThat(list.dummy.children("li").length, equalTo(3));
    assertThat(list.dummy.children("li").first().text(), equalTo("display1"));
    return assertThat(list.dummy.children("li").last().text(), equalTo("display3"));
  });
  test("MenuList should null the selection if the passed-in index is out of bounds", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(5);
    return assertThat(list.selectedIndex, equalTo(-1));
  });
  test("Clicking on a list item should trigger the corresponding action", function() {
    var item1, item2, item3, itemActionTriggered, list, model;
    itemActionTriggered = false;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      action: function() {
        return itemActionTriggered = true;
      }
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    $(list.dummy.children("li")[1]).mouseup();
    return assertThat(itemActionTriggered);
  });
  test("Clicking on a readonly select's list item shouldn't trigger the corresponding action", function() {
    var item1, item2, item3, itemActionTriggered, list, model;
    itemActionTriggered = false;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      action: function() {
        return itemActionTriggered = true;
      }
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.set("readonly", true);
    $(list.dummy.children("li")[1]).mouseup();
    return assertThat(!itemActionTriggered);
  });
  test("Clicking on a disabled select's list item shouldn't trigger the corresponding action", function() {
    var item1, item2, item3, itemActionTriggered, list, model;
    itemActionTriggered = false;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      action: function() {
        return itemActionTriggered = true;
      }
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.set("disabled", true);
    $(list.dummy.children("li")[1]).mouseup();
    return assertThat(!itemActionTriggered);
  });
  test("Changing the model's content should update the list", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    model.remove(model.items[2]);
    assertThat(list.dummy.children("li").length, equalTo(2));
    assertThat(list.dummy.children("li").first().text(), equalTo("display1"));
    return assertThat(list.dummy.children("li").last().text(), equalTo("display2"));
  });
  test("Passing the mouse over a list item should select it", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.dummy.children("li").last().mouseover();
    assertThat(list.selectedIndex, equalTo(2));
    return assertThat(list.dummy.children("li").last().hasClass("selected"));
  });
  test("Passing the mouse over a readonly select's list item shouldn't select it", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.set("readonly", true);
    list.dummy.children("li").last().mouseover();
    return assertThat(list.selectedIndex, equalTo(-1));
  });
  test("Passing the mouse over a disabled select's list item shouldn't select it", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.set("disabled", true);
    list.dummy.children("li").last().mouseover();
    return assertThat(list.selectedIndex, equalTo(-1));
  });
  test("Pressing the up key should move the selection up", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    assertThat(list.selectedIndex, equalTo(0));
    return assertThat(list.dummy.children("li").first().hasClass("selected"));
  });
  test("Pressing the down down should move the selection down", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    assertThat(list.selectedIndex, equalTo(2));
    return assertThat(list.dummy.children("li").last().hasClass("selected"));
  });
  test("Pressing the up key when the selection is at the top should move the selection to the bottom", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(0);
    list.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    assertThat(list.selectedIndex, equalTo(2));
    return assertThat(list.dummy.children("li").last().hasClass("selected"));
  });
  test("Pressing the down key when the selection is at the bottom should move the selection to the top", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(2);
    list.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    assertThat(list.selectedIndex, equalTo(0));
    return assertThat(list.dummy.children("li").first().hasClass("selected"));
  });
  test("Pressing the enter key should trigger the action of the selected item", function() {
    var actionTriggered, item1, item2, item3, list, model;
    actionTriggered = false;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      action: function() {
        return actionTriggered = true;
      }
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(actionTriggered);
  });
  test("Pressing the space key should trigger the action of the selected item", function() {
    var actionTriggered, item1, item2, item3, list, model;
    actionTriggered = false;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      action: function() {
        return actionTriggered = true;
      }
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(actionTriggered);
  });
  test("Pressing the up key should prevent the default behavior", function() {
    var item1, item2, item3, list, model, preventDefaultCalled;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    preventDefaultCalled = false;
    list.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {
        return preventDefaultCalled = true;
      }
    });
    return assertThat(preventDefaultCalled);
  });
  test("Pressing the down key should prevent the default behavior", function() {
    var item1, item2, item3, list, model, preventDefaultCalled;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    preventDefaultCalled = false;
    list.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {
        return preventDefaultCalled = true;
      }
    });
    return assertThat(preventDefaultCalled);
  });
  test("Pressing the up key on a readonly select shouldn't move the selection up", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.set("readonly", true);
    list.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(list.selectedIndex, equalTo(1));
  });
  test("Pressing the down key on a readonly select shouldn't move the selection down", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.set("readonly", true);
    list.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(list.selectedIndex, equalTo(1));
  });
  test("Pressing the up key on a disabled select shouldn't move the selection up", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.set("disabled", true);
    list.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(list.selectedIndex, equalTo(1));
  });
  test("Pressing the down key on a disabled select shouldn't move the selection down", function() {
    var item1, item2, item3, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    item3 = {
      display: "display3"
    };
    model = new MenuModel(item1, item2, item3);
    list = new MenuList(model);
    list.select(1);
    list.set("disabled", true);
    list.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(list.selectedIndex, equalTo(1));
  });
  test("MenuList items that contains a sub model should have a specific class", function() {
    var item1, item2, item3, item4, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      menu: new MenuModel
    };
    item3 = {
      display: "display3"
    };
    item4 = {
      display: "display4"
    };
    item2.menu.add(item3, item4);
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    return assertThat(list.dummy.children("li").last().hasClass("menu"));
  });
  test("Passing the mouse over a MenuList item that contains a submodel should popup a new menulist next to the former", function() {
    var item1, item2, item3, item4, left, list, model, top;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      menu: new MenuModel
    };
    item3 = {
      display: "display3"
    };
    item4 = {
      display: "display4"
    };
    item2.menu.add(item3, item4);
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    left = list.dummy.offset().left + list.dummy.width();
    top = list.dummy.children("li").last().offset().top;
    list.dummy.children("li").last().mouseover();
    assertThat(list.childList.dummy.parent().length, equalTo(1));
    assertThat(list.childList.dummy.attr("style"), contains("left: " + left + "px;"));
    assertThat(list.childList.dummy.attr("style"), contains("top: " + top + "px;"));
    list.dummy.detach();
    return list.childList.dummy.detach();
  });
  test("Passing the mouse over a basic item when a child list is displayed should close the child list", function() {
    var item1, item2, item3, item4, left, list, model, top;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2",
      menu: new MenuModel
    };
    item3 = {
      display: "display3"
    };
    item4 = {
      display: "display4"
    };
    item2.menu.add(item3, item4);
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    left = list.dummy.offset().left + list.dummy.width();
    top = list.dummy.children("li").last().offset().top;
    list.dummy.children("li").last().mouseover();
    list.dummy.children("li").first().mouseover();
    assertThat(list.childList.dummy.parent().length, equalTo(0));
    return list.dummy.detach();
  });
  test("Closing a child list should make it lose the focus", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    list.dummy.children("li").first().mouseover();
    list.childList.grabFocus();
    list.dummy.children("li").last().mouseover();
    assertThat(!list.childList.hasFocus);
    assertThat(list.hasFocus);
    return list.dummy.detach();
  });
  test("Closing a child list should also close the descendant list", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3",
        menu: new MenuModel({
          display: "display4"
        })
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    list.dummy.children("li").first().mouseover();
    list.childList.dummy.children("li").first().mouseover();
    list.dummy.children("li").last().mouseover();
    assertThat(list.childList.childList.dummy.parent().length, equalTo(0));
    return list.dummy.detach();
  });
  test("A childlist should have a reference to its parent", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    list.dummy.children("li").first().mouseover();
    assertThat(list.childList.parentList === list);
    list.dummy.detach();
    return list.childList.dummy.detach();
  });
  test("A menu should stop the propagation of the mousedown event", function() {
    var item1, item2, list, model, stopImmediatePropagationCalled;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    stopImmediatePropagationCalled = false;
    list.mousedown({
      stopImmediatePropagation: function() {
        return stopImmediatePropagationCalled = true;
      }
    });
    return assertThat(stopImmediatePropagationCalled);
  });
  test("Passing the mouse over an item should give the focus to the list", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1"
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    list.dummy.children("li").first().mouseover();
    return assertThat(list.hasFocus);
  });
  test("Coming back from a child list to the original menu item should blur the child list", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    list.dummy.children("li").first().mouseover();
    list.childList.dummy.children("li").first().mouseover();
    list.dummy.children("li").first().mouseover();
    assertThat(!list.childList.hasFocus);
    list.dummy.detach();
    return list.childList.dummy.detach();
  });
  test("Coming back from a child list to a menu item that also have a submenu should change the child List", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2",
      menu: new MenuModel({
        display: "display4"
      })
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    $("body").append(list.dummy);
    list.dummy.children("li").first().mouseover();
    list.childList.dummy.children("li").first().mouseover();
    list.dummy.children("li").last().mouseover();
    assertThat(!list.childList.hasFocus);
    assertThat(list.childList.get("model") === item2.menu);
    list.dummy.detach();
    return list.childList.dummy.detach();
  });
  test("Pressing the right key when the selection is on a sub menu should move the focus to the child list", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    list.dummy.children("li").first().mouseover();
    list.keydown({
      keyCode: keys.right,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(list.childList.hasFocus);
  });
  test("Pressing the left key when the focus is on a child list should return the focus to the parent", function() {
    var item1, item2, list, model;
    item1 = {
      display: "display1",
      menu: new MenuModel({
        display: "display3"
      })
    };
    item2 = {
      display: "display2"
    };
    model = new MenuModel(item1, item2);
    list = new MenuList(model);
    list.dummy.children("li").first().mouseover();
    list.childList.dummy.children("li").first().mouseover();
    list.childList.keydown({
      keyCode: keys.left,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    assertThat(!list.childList.hasFocus);
    return assertThat(list.hasFocus);
  });
  item1 = {
    display: "display1",
    action: function() {
      return console.log("item 1 clicked");
    }
  };
  item2 = {
    display: "display2",
    action: function() {
      return console.log("item 2 clicked");
    }
  };
  item3 = {
    display: "display3",
    menu: new MenuModel
  };
  item4 = {
    display: "display4",
    action: function() {
      return console.log("item 4 clicked");
    }
  };
  item5 = {
    display: "display5",
    action: function() {
      return console.log("item 5 clicked");
    }
  };
  item6 = {
    display: "display6",
    menu: new MenuModel
  };
  item7 = {
    display: "display7",
    action: function() {
      return console.log("item 7 clicked");
    }
  };
  item8 = {
    display: "display8",
    action: function() {
      return console.log("item 8 clicked");
    }
  };
  item3.menu.add(item4, item5, item6);
  item6.menu.add(item7, item8);
  model = new MenuModel(item1, item2, item3);
  list1 = new MenuList(model);
  list2 = new MenuList(model);
  list3 = new MenuList(model);
  list2.set("readonly", true);
  list3.set("disabled", true);
  list1.addClasses("dummy");
  list2.addClasses("dummy");
  list3.addClasses("dummy");
  $("#qunit-header").before($("<h4>MenuList</h4>"));
  $("#qunit-header").before(list1.dummy);
  $("#qunit-header").before(list2.dummy);
  $("#qunit-header").before(list3.dummy);
  module("single select tests");
  test("SingleSelect should accept select node as target", function() {
    var select;
    target = $("<select></select>")[0];
    select = new SingleSelect(target);
    return assertThat(select.target === target);
  });
  test("SingleSelect shouldn't accept anything else that a select as target", function() {
    var errorRaised, select;
    target = $("<input></input>")[0];
    errorRaised = false;
    try {
      select = new SingleSelect(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("SingleSelect shouldn't accept a select with multiple attribute as target", function() {
    var errorRaised, select;
    target = $("<select multiple></select>")[0];
    errorRaised = false;
    try {
      select = new SingleSelect(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("SingleSelect's dummy should display the selected option label", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected value='__BAR__' label='BAR'>bar</option>                 </select>")[0];
    select = new SingleSelect(target);
    assertThat(select.dummy.find(".value").text(), equalTo("BAR"));
    return assertThat(select.get("value"), equalTo("__BAR__"));
  });
  test("SingleSelect's dummy should display the selected option", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected value='BAR'>bar</option>                 </select>")[0];
    select = new SingleSelect(target);
    assertThat(select.dummy.find(".value").text(), equalTo("bar"));
    return assertThat(select.get("value"), equalTo("BAR"));
  });
  test("SingleSelect's selected index should be the index of the child with the selected attribute", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>")[0];
    select = new SingleSelect(target);
    return assertThat(select.selectedPath, array(1));
  });
  test("Setting the value should change the selected index", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected value='BAR'>bar</option>                 </select>")[0];
    select = new SingleSelect(target);
    select.set("value", "foo");
    assertThat(select.selectedPath, array(0));
    assertThat(select.dummy.find(".value").text(), equalTo("foo"));
    select.set("value", "BAR");
    assertThat(select.selectedPath, array(1));
    return assertThat(select.dummy.find(".value").text(), equalTo("bar"));
  });
  test("SingleSelect's target should be hidden at start", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });
  test("SingleSelect should build a MenuModel with the option of the select", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option label='BAR' selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    assertThat(select.model.size(), equalTo(2));
    assertThat(select.model.items[0], hasProperty("display", equalTo("foo")));
    return assertThat(select.model.items[1], hasProperty("display", equalTo("BAR")));
  });
  test("SingleSelect model's items should have an action that select the item", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.items[0].action();
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Changes made to the widget should be reflected on the target", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.items[0].action();
    assertThat(target.children("option[selected]").text(), equalTo("foo"));
    select.model.items[1].action();
    return assertThat(target.children("option[selected]").text(), equalTo("bar"));
  });
  test("Changes made to the model should be reflected on the target (with add)", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.add({
      display: "new item",
      value: "new value"
    });
    return assertThat(target.children("option").length, equalTo(3));
  });
  test("Changes made to the model should preserve the optgroup nodes", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup>                        <option selected>bar</option>                        <option>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.add({
      display: "new item",
      value: "new value"
    });
    assertThat(target.find("optgroup").length, equalTo(1));
    return assertThat(target.find("optgroup").children().length, equalTo(2));
  });
  test("Items added to the model of a select should have their action defined automatically", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.add({
      display: "new item",
      value: "new value"
    });
    select.model.items[2].action();
    return assertThat(target.children("option[selected]").text(), equalTo("new item"));
  });
  test("Changes made to the model should be reflected on the target (with remove)", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.remove(select.model.items[1]);
    return assertThat(target.children("option").length, equalTo(1));
  });
  test("Changes made to the model should preserved the selection", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.add({
      display: "new item",
      value: "new value"
    });
    assertThat(target.children("option[selected]").length, equalTo(1));
    return assertThat(target.children("option[selected]").text(), equalTo("bar"));
  });
  test("Changes made to the model should preserve a valid selection", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.model.remove(select.model.items[1]);
    assertThat(target.children("option[selected]").length, equalTo(1));
    assertThat(target.children("option[selected]").text(), equalTo("foo"));
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("SingleSelect should provide a MenuList instance linked to the model", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    assertThat(select.menuList, notNullValue());
    return assertThat(select.menuList.get("model") === select.model);
  });
  test("Pressing the mouse on a SingleSelect should display its menuList", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    assertThat(select.menuList.dummy.parent().length, equalTo(1));
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("Pressing the mouse on a SingleSelect should select the value in the menuList", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    assertThat(select.menuList.selectedIndex, equalTo(1));
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("Pressing the mouse on a SingleSelect that have its menu list displayed should detach its menuList", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.dummy.mousedown();
    assertThat(select.menuList.dummy.parent().length, equalTo(0));
    return select.dummy.detach();
  });
  test("When displayed, the menulist should be placed below the select", function() {
    var left, select, top;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    top = select.dummy.height() + select.dummy.offset().top;
    left = select.dummy.offset().left;
    select.dummy.mousedown();
    assertThat(select.menuList.dummy.attr("style"), contains("left: " + left + "px"));
    assertThat(select.menuList.dummy.attr("style"), contains("top: " + top + "px"));
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("When displayed, clicking on a list item should hide the menu list", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.menuList.dummy.children().last().mouseup();
    assertThat(select.menuList.dummy.parent().length, equalTo(0));
    return select.dummy.detach();
  });
  test("Pressing the mouse on the select dummy should prevent the default behavior", function() {
    var preventDefaultCalled, select;
    select = new SingleSelect;
    preventDefaultCalled = false;
    select.mousedown({
      preventDefault: function() {
        return preventDefaultCalled = true;
      },
      stopImmediatePropagation: function() {}
    });
    return assertThat(preventDefaultCalled);
  });
  test("Readonly select should prevent the mousedown to open the menu list", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.set("readonly", true);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    assertThat(select.menuList.dummy.parent().length, equalTo(0));
    return select.dummy.detach();
  });
  test("Pressing the mouse on a SingleSelect should give the focus to the menu list", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    assertThat(select.menuList.hasFocus);
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("Pressing the mouse to hide the menu list should give the focus back to the select", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.dummy.mousedown();
    assertThat(!select.menuList.hasFocus);
    assertThat(select.hasFocus);
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("When displayed, clicking on a list item should give the focus back to the select", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.menuList.dummy.children().last().mouseup();
    assertThat(!select.menuList.hasFocus);
    assertThat(select.hasFocus);
    return select.dummy.detach();
  });
  test("A SingleSelect should allow html content in items display", function() {
    var select;
    select = new SingleSelect;
    select.model.add({
      display: "<b>foo</b>",
      value: 'foo'
    });
    select.set("value", "foo");
    return assertThat(select.dummy.find("b").length, equalTo(1));
  });
  test("Pressing the mouse outside of the select and its menu should hide the menu", function() {
    var MockSingleSelect, select;
    MockSingleSelect = (function() {
      __extends(MockSingleSelect, SingleSelect);
      function MockSingleSelect() {
        MockSingleSelect.__super__.constructor.apply(this, arguments);
      }
      MockSingleSelect.prototype.documentMouseDown = function(e) {
        e.pageX = 1000;
        e.pageY = 1000;
        return MockSingleSelect.__super__.documentMouseDown.call(this, e);
      };
      return MockSingleSelect;
    })();
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new MockSingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    $(document).mousedown();
    assertThat(select.menuList.dummy.parent().length, equalTo(0));
    return select.dummy.detach();
  });
  test("Pressing the enter key when the select has the focus should open the menu", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(select.menuList.dummy.parent().length, equalTo(1));
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("Pressing the space key when the select has the focus should open the menu", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(select.menuList.dummy.parent().length, equalTo(1));
    select.dummy.detach();
    return select.menuList.dummy.detach();
  });
  test("Pressing the space key when the select is readonly shouldn't open the menu", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.set("readonly", true);
    $("body").append(select.dummy);
    select.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(select.menuList.dummy.parent().length, equalTo(0));
    return select.dummy.detach();
  });
  test("Pressing the up key should move the selection cursor to the up", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Pressing the down key should move the selection cursor to the down", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <option>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("bar"));
  });
  test("Pressing the down key should move the selection cursor to the start when it is already a the bottom", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Pressing the up key should move the selection cursor to the end when its already at the top", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <option>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("bar"));
  });
  test("Pressing the down key when the select has optgroups should move the selection to the optgroup", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <optgroup>                        <option>bar</option>                        <option>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("bar"));
  });
  test("The selectedPath should be valid even when the selected items is in a optgroup", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup>                        <option selected>bar</option>                        <option>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    return assertThat(select.selectedPath, array(1, 0));
  });
  test("Moving down the selection when the selection is at the end of an optgroup should move the selection outside of the group", function() {
    var select;
    target = $("<select>                    <optgroup>                        <option>bar</option>                        <option selected>rab</option>                    </optgroup>                    <option>foo</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Moving down the selection when the selection is at the end of the last optgroup should move the selection to the top", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup>                        <option>bar</option>                        <option selected>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Moving down the selection when the selection is at the end of the last optgroup should move the selection to the top", function() {
    var select;
    target = $("<select>                    <optgroup>                        <option>foo</option>                    </optgroup>                    <optgroup>                        <option>bar</option>                        <option selected>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Moving up the selection when the selection is at the start of an optgroup should move the selection outside of the group", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup>                        <option selected>bar</option>                        <option>rab</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Moving up the selection when the selection is at the start of an optgroup that is at the top should move the selection bottom", function() {
    var select;
    target = $("<select>                    <optgroup>                        <option selected>bar</option>                        <option>rab</option>                    </optgroup>                    <option>foo</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Moving up the selection when the selection is at the start of an optgroup that is at the top should move the selection bottom", function() {
    var select;
    target = $("<select>                    <optgroup>                        <option selected>bar</option>                        <option>rab</option>                    </optgroup>                    <optgroup>                        <option>foo</option>                    </optgroup>                 </select>");
    select = new SingleSelect(target[0]);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Pressing the down key should prevent the default behavior", function() {
    var preventDefaultCalled, select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    preventDefaultCalled = false;
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {
        return preventDefaultCalled = true;
      }
    });
    return assertThat(preventDefaultCalled);
  });
  test("Pressing the up key should prevent the default behavior", function() {
    var preventDefaultCalled, select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    preventDefaultCalled = false;
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {
        return preventDefaultCalled = true;
      }
    });
    return assertThat(preventDefaultCalled);
  });
  test("Pressing the up key on a readonly select shouldn't move the selection cursor to the up", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <option selected>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.set("readonly", true);
    select.keydown({
      keyCode: keys.up,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("bar"));
  });
  test("Pressing the down key on a readonly select shouldn't move the selection cursor to the down", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <option>bar</option>                 </select>");
    select = new SingleSelect(target[0]);
    select.set("readonly", true);
    select.keydown({
      keyCode: keys.down,
      ctrlKey: false,
      shiftKey: false,
      altKey: false,
      preventDefault: function() {}
    });
    return assertThat(select.get("value"), equalTo("foo"));
  });
  test("Optgroups with a select should be handled as sub menus", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <optgroup label='irrelevant'>                        <option>bar</option>                        <option>rab</option>                    </option>                 </select>");
    select = new SingleSelect(target[0]);
    return assertThat(select.model.items[1].menu, notNullValue());
  });
  test("Clicking on a list item in a child list should also set the value", function() {
    var select;
    target = $("<select>                    <option selected>foo</option>                    <optgroup label='irrelevant'>                        <option>bar</option>                        <option>rab</option>                    </option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.menuList.dummy.children("li").last().mouseover();
    select.menuList.childList.dummy.children("li").last().mouseup();
    assertThat(select.get("value"), equalTo("rab"));
    assertThat(select.dummy.find(".value").text(), equalTo("rab"));
    return select.dummy.detach();
  });
  test("Pressing the mouse outside of the select list but on a child list shouldn't close the dialog before mouseup", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup label='irrelevant'>                        <option>bar</option>                        <option>rab</option>                    </option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.menuList.dummy.children("li").last().mouseover();
    select.menuList.childList.dummy.children("li").last().mousedown();
    assertThat(select.menuList.dummy.parent().length, equalTo(1));
    assertThat(select.menuList.childList.dummy.parent().length, equalTo(1));
    select.dummy.detach();
    select.menuList.dummy.detach();
    return select.menuList.childList.dummy.detach();
  });
  test("Pressing the mouse on a SingleSelect should select the value in the menuList even when there're optgroups", function() {
    var select;
    target = $("<select>                    <option>foo</option>                    <optgroup label='irrelevant'>                        <option>bar</option>                        <option>rab</option>                    </option>                 </select>");
    select = new SingleSelect(target[0]);
    $("body").append(select.dummy);
    select.dummy.mousedown();
    select.menuList.dummy.children("li").last().mouseover();
    select.menuList.childList.dummy.children("li").last().mouseup();
    assertThat(select.selectedPath, array(1, 1));
    select.dummy.mousedown();
    assertThat(select.menuList.selectedIndex, equalTo(1));
    assertThat(select.menuList.childList.selectedIndex, equalTo(1));
    select.dummy.detach();
    select.menuList.dummy.detach();
    return select.menuList.childList.dummy.detach();
  });
  test("The value for a select that only have optgroup and no selected item should be the default value of the select", function() {
    var select;
    target = $("<select>                    <optgroup label='irrelevant'>                        <option>bar</option>                        <option>rab</option>                    </option>                    <optgroup label='irrelevant'>                        <option>foo</option>                        <option>oof</option>                    </option>                 </select>");
    select = new SingleSelect(target[0]);
    assertThat(select.get("value"), equalTo("bar"));
    return assertThat(select.selectedPath, array(0, 0));
  });
  test("Empty SingleSelect should display a default label", function() {
    var select;
    target = $("<select></select>")[0];
    select = new SingleSelect(target);
    return assertThat(select.dummy.find(".value").text(), equalTo("Empty"));
  });
  test("Empty SingleSelect should display a default label", function() {
    var select;
    select = new SingleSelect;
    return assertThat(select.dummy.find(".value").text(), equalTo("Empty"));
  });
  test("Empty SingleSelect should use the title attribute of the target as placeholder for the display", function() {
    var select;
    target = $("<select title='foo'></select>")[0];
    select = new SingleSelect(target);
    return assertThat(select.dummy.find(".value").text(), equalTo("foo"));
  });
  s = "<select>        <option>List Item 1</option>        <option selected>List Item 2</option>        <option>Long List Item 3</option>        <option>Very Long List Item 4</option>        <optgroup label='Group 1'>            <option>List Item 5</option>            <option>List Item 6</option>            <option>Long List Item 7</option>        </optgroup>        <optgroup label='Group 2'>            <option>List Item 8</option>            <option>List Item 9</option>            <option>Long List Item 10</option>        </optgroup>     </select>";
  select1 = new SingleSelect($(s)[0]);
  select2 = new SingleSelect($(s)[0]);
  select3 = new SingleSelect($(s)[0]);
  select2.set("readonly", true);
  select3.set("disabled", true);
  $("#qunit-header").before($("<h4>SingleSelect</h4>"));
  $("#qunit-header").before(select1.dummy);
  $("#qunit-header").before(select2.dummy);
  $("#qunit-header").before(select3.dummy);
  module("colorpicker tests");
  test("A color picker should accept a target input with type color", function() {
    var picker;
    target = $("<input type='color'></input>")[0];
    picker = new ColorPicker(target);
    return assertThat(picker.target === target);
  });
  test("A color picker should hide its target", function() {
    var picker;
    target = $("<input type='color'></input>")[0];
    picker = new ColorPicker(target);
    return assertThat(picker.jTarget.attr("style"), contains("display: none"));
  });
  test("A color picker shouldn't accept a target input with a type different than color", function() {
    var errorRaised, picker;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      picker = new ColorPicker(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("A color picker should retreive the color from its target", function() {
    var picker;
    target = $("<input type='color' value='#ff0000'></input>")[0];
    picker = new ColorPicker(target);
    return assertThat(picker.get("value"), equalTo("#ff0000"));
  });
  test("A color picker should have a default color even without target", function() {
    var picker;
    picker = new ColorPicker;
    return assertThat(picker.get("value"), equalTo("#000000"));
  });
  test("A color picker should provide a color property that provide a more code friendly color object", function() {
    var color, picker;
    picker = new ColorPicker;
    color = picker.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0,
      green: 0,
      blue: 0
    })));
  });
  test("A color picker color should reflect the initial value", function() {
    var color, picker;
    target = $("<input type='color' value='#abcdef'></input>")[0];
    picker = new ColorPicker(target);
    color = picker.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    })));
  });
  test("A color picker should update the value when the color is changed", function() {
    var picker;
    picker = new ColorPicker;
    picker.set("color", {
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    });
    return assertThat(picker.get("value"), equalTo("#abcdef"));
  });
  test("A color picker should preserve the length of the value even with black", function() {
    var picker;
    picker = new ColorPicker;
    picker.set("color", {
      red: 0,
      green: 0,
      blue: 0
    });
    return assertThat(picker.get("value"), equalTo("#000000"));
  });
  test("A color picker should update its color property when the value is changed", function() {
    var color, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    color = picker.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    })));
  });
  test("A color picker should prevent invalid values to alter its properties", function() {
    var picker;
    target = $("<input type='color' value='#foobar'></input>")[0];
    picker = new ColorPicker(target);
    picker.set("value", "foo");
    picker.set("value", "#ghijkl");
    picker.set("value", "#abc");
    picker.set("value", void 0);
    assertThat(picker.get("value"), equalTo("#000000"));
    return assertThat(picker.get("color"), hasProperties({
      red: 0,
      green: 0,
      blue: 0
    }));
  });
  test("A color picker should prevent invalid color to alter its properties", function() {
    var picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    picker.set("color", null);
    picker.set("color", {
      red: NaN,
      green: 0,
      blue: 0
    });
    picker.set("color", {
      red: 0,
      green: -1,
      blue: 0
    });
    picker.set("color", {
      red: 0,
      green: 0,
      blue: "foo"
    });
    picker.set("color", {
      red: 0,
      green: 0,
      blue: 300
    });
    assertThat(picker.get("value"), equalTo("#abcdef"));
    return assertThat(picker.get("color"), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    }));
  });
  test("A color picker should provide a dummy", function() {
    var picker;
    picker = new ColorPicker;
    return assertThat(picker.dummy, notNullValue());
  });
  test("The color span of a color picker should have its background filled with the widget's value", function() {
    var picker;
    target = $("<input type='color' value='#abcdef'></input>")[0];
    picker = new ColorPicker(target);
    return assertThat(picker.dummy.children(".color").attr("style"), contains("background: #abcdef"));
  });
  test("The color span of a color picker should have its background filled with the widget's value even after a change", function() {
    var picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    return assertThat(picker.dummy.children(".color").attr("style"), contains("background: #abcdef"));
  });
  test("Clicking on a color picker should trigger a dialogRequested signal", function() {
    var picker, signalCalled, signalSource;
    signalCalled = false;
    signalSource = null;
    picker = new ColorPicker;
    picker.dialogRequested.add(function(widget) {
      signalCalled = true;
      return signalSource = widget;
    });
    picker.dummy.click();
    assertThat(signalCalled);
    return assertThat(signalSource === picker);
  });
  test("The color child text should be the value hexadecimal code", function() {
    var picker;
    picker = new ColorPicker;
    return assertThat(picker.dummy.children(".color").text(), equalTo("#000000"));
  });
  test("The color child text color should be defined according the luminosity of the color", function() {
    var picker;
    picker = new ColorPicker;
    assertThat(picker.dummy.children(".color").attr("style"), contains("color: #ffffff"));
    picker.set("value", "#ffffff");
    return assertThat(picker.dummy.children(".color").attr("style"), contains("color: #000000"));
  });
  test("The ColorWidget's class should have a default listener defined for the dialogRequested signal of its instance", function() {
    return assertThat(ColorPicker.defaultListener instanceof ColorPickerDialog);
  });
  test("Disabled ColorPicker should trigger the dialogRequested on click", function() {
    var picker, signalCalled;
    signalCalled = false;
    picker = new ColorPicker;
    picker.dialogRequested.add(function() {
      return signalCalled = true;
    });
    picker.set("disabled", true);
    picker.dummy.click();
    return assertThat(!signalCalled);
  });
  test("Readonly ColorPicker should trigger the dialogRequested on click", function() {
    var picker, signalCalled;
    signalCalled = false;
    picker = new ColorPicker;
    picker.dialogRequested.add(function() {
      return signalCalled = true;
    });
    picker.set("readonly", true);
    picker.dummy.click();
    return assertThat(!signalCalled);
  });
  test("Pressing Enter should dispatch the dialogRequested signal", function() {
    var picker, signalCalled;
    signalCalled = false;
    picker = new ColorPicker;
    picker.dialogRequested.add(function() {
      return signalCalled = true;
    });
    picker.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(signalCalled);
  });
  test("Pressing Space should dispatch the dialogRequested signal", function() {
    var picker, signalCalled;
    signalCalled = false;
    picker = new ColorPicker;
    picker.dialogRequested.add(function() {
      return signalCalled = true;
    });
    picker.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(signalCalled);
  });
  picker1 = new ColorPicker;
  picker2 = new ColorPicker;
  picker3 = new ColorPicker;
  picker1.set("value", "#cbdc1b");
  picker2.set("value", "#66ff99");
  picker3.set("value", "#6699ff");
  picker2.set("readonly", true);
  picker3.set("disabled", true);
  $("#qunit-header").before($("<h4>ColorPicker</h4>"));
  $("#qunit-header").before(picker1.dummy);
  $("#qunit-header").before(picker2.dummy);
  $("#qunit-header").before(picker3.dummy);
  module("squarepicker tests");
  test("A SquarePicker should provides two ranges of values for its x and y axis", function() {
    var grid;
    grid = new SquarePicker;
    grid.set({
      rangeX: [0, 100],
      rangeY: [0, 100]
    });
    assertThat(grid.get("rangeX"), array(0, 100));
    return assertThat(grid.get("rangeY"), array(0, 100));
  });
  test("The SquarePicker's value should be a tuple of values in the x and y range", function() {
    var grid;
    grid = new SquarePicker;
    return assertThat(grid.get("value"), array(0, 0));
  });
  test("The SquarePicker should prevent any attempt to set invalid values", function() {
    var grid;
    grid = new SquarePicker;
    grid.set({
      rangeX: [0, 100],
      rangeY: [0, 100]
    });
    grid.set({
      value: [50, 65]
    });
    grid.set({
      value: [120, 0]
    });
    grid.set({
      value: [0, 120]
    });
    grid.set({
      value: [0, "foo"]
    });
    grid.set({
      value: ["foo", 0]
    });
    grid.set({
      value: [null, 0]
    });
    grid.set({
      value: [0, null]
    });
    grid.set({
      value: "foo"
    });
    grid.set({
      value: null
    });
    return assertThat(grid.get("value"), array(50, 65));
  });
  test("Changing the ranges midway should alter the values", function() {
    var grid;
    grid = new SquarePicker;
    grid.set({
      rangeX: [0, 100],
      rangeY: [0, 100]
    });
    grid.set({
      value: [50, 65]
    });
    grid.set({
      rangeX: [0, 10],
      rangeY: [0, 10]
    });
    return assertThat(grid.get("value"), array(10, 10));
  });
  test("A SquarePicker should prevent all attempt to set an invalid range", function() {
    var grid;
    grid = new SquarePicker;
    grid.set({
      rangeX: [0, 100],
      rangeY: [0, 100]
    });
    grid.set({
      rangeX: [100, 0],
      rangeY: [100, 0]
    });
    grid.set({
      rangeX: ["foo", 0],
      rangeY: ["foo", 0]
    });
    grid.set({
      rangeX: [0, "foo"],
      rangeY: [0, "foo"]
    });
    grid.set({
      rangeX: [null, 0],
      rangeY: [null, 0]
    });
    grid.set({
      rangeX: [0, null],
      rangeY: [0, null]
    });
    grid.set({
      rangeX: "foo",
      rangeY: "foo"
    });
    grid.set({
      rangeX: null,
      rangeY: null
    });
    assertThat(grid.get("rangeX"), array(0, 100));
    return assertThat(grid.get("rangeY"), array(0, 100));
  });
  test("SquarePicker should provide a dummy", function() {
    var grid;
    grid = new SquarePicker;
    return assertThat(grid.dummy, notNullValue());
  });
  test("Given a specific size, pressing the mouse inside a grid should change the value according to the x and y ranges", function() {
    var MockSquarePicker, grid;
    MockSquarePicker = (function() {
      __extends(MockSquarePicker, SquarePicker);
      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }
      MockSquarePicker.prototype.mousedown = function(e) {
        e.pageX = 45;
        e.pageY = 65;
        return MockSquarePicker.__super__.mousedown.call(this, e);
      };
      return MockSquarePicker;
    })();
    grid = new MockSquarePicker;
    grid.dummy.attr("style", "width:100px; height:100px");
    grid.set({
      rangeX: [0, 10],
      rangeY: [0, 10]
    });
    grid.dummy.mousedown();
    return assertThat(grid.get("value"), array(4.5, 6.5));
  });
  test("A SquarePicker should allow to drag the mouse to change the value", function() {
    var MockSquarePicker, grid;
    MockSquarePicker = (function() {
      __extends(MockSquarePicker, SquarePicker);
      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }
      MockSquarePicker.prototype.mousedown = function(e) {
        e.pageX = 45;
        e.pageY = 65;
        return MockSquarePicker.__super__.mousedown.call(this, e);
      };
      MockSquarePicker.prototype.mousemove = function(e) {
        e.pageX = 47;
        e.pageY = 67;
        return MockSquarePicker.__super__.mousemove.call(this, e);
      };
      MockSquarePicker.prototype.mouseup = function(e) {
        e.pageX = 49;
        e.pageY = 69;
        return MockSquarePicker.__super__.mouseup.call(this, e);
      };
      return MockSquarePicker;
    })();
    grid = new MockSquarePicker;
    grid.dummy.attr("style", "width:100px; height:100px");
    grid.set({
      rangeX: [0, 10],
      rangeY: [0, 10]
    });
    grid.dummy.mousedown();
    assertThat(grid.get("value"), array(closeTo(4.5, 0.1), closeTo(6.5, 0.1)));
    grid.dummy.mousemove();
    assertThat(grid.get("value"), array(closeTo(4.7, 0.1), closeTo(6.7, 0.1)));
    grid.dummy.mouseup();
    return assertThat(grid.get("value"), array(closeTo(4.9, 0.1), closeTo(6.9, 0.1)));
  });
  test("Dragging the mouse outside of the SquarePicker on the bottom right should set the values on the max", function() {
    var MockSquarePicker, grid;
    MockSquarePicker = (function() {
      __extends(MockSquarePicker, SquarePicker);
      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }
      MockSquarePicker.prototype.mouseup = function(e) {
        e.pageX = 110;
        e.pageY = 110;
        return MockSquarePicker.__super__.mouseup.call(this, e);
      };
      return MockSquarePicker;
    })();
    grid = new MockSquarePicker;
    grid.dummy.attr("style", "width:100px; height:100px");
    grid.set({
      rangeX: [0, 10],
      rangeY: [0, 10]
    });
    grid.dummy.mousedown();
    grid.dummy.mouseup();
    return assertThat(grid.get("value"), array(closeTo(10, 0.1), closeTo(10, 0.1)));
  });
  test("Dragging the mouse outside of the SquarePicker on the top left should set the values on the min", function() {
    var MockSquarePicker, grid;
    MockSquarePicker = (function() {
      __extends(MockSquarePicker, SquarePicker);
      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }
      MockSquarePicker.prototype.mouseup = function(e) {
        e.pageX = -10;
        e.pageY = -10;
        return MockSquarePicker.__super__.mouseup.call(this, e);
      };
      return MockSquarePicker;
    })();
    grid = new MockSquarePicker;
    grid.dummy.attr("style", "width:100px; height:100px");
    grid.set({
      rangeX: [0, 10],
      rangeY: [0, 10]
    });
    grid.dummy.mousedown();
    grid.dummy.mouseup();
    return assertThat(grid.get("value"), array(closeTo(0, 0.1), closeTo(0, 0.1)));
  });
  test("A disabled SquarePicker should prevent dragging to occurs", function() {
    var grid;
    grid = new SquarePicker;
    grid.set("disabled", true);
    grid.dummy.mousedown();
    return assertThat(!grid.dragging);
  });
  test("A readonly SquarePicker should prevent dragging to occurs", function() {
    var grid;
    grid = new SquarePicker;
    grid.set("disabled", true);
    grid.dummy.mousedown();
    return assertThat(!grid.dragging);
  });
  test("Starting a drag should return false", function() {
    var MockSquarePicker, grid, result;
    result = true;
    MockSquarePicker = (function() {
      __extends(MockSquarePicker, SquarePicker);
      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }
      MockSquarePicker.prototype.mousedown = function(e) {
        return result = MockSquarePicker.__super__.mousedown.call(this, e);
      };
      return MockSquarePicker;
    })();
    grid = new MockSquarePicker;
    grid.dummy.mousedown();
    return assertThat(!result);
  });
  test("A SquarePicker should have a cursor that display the selected position", function() {
    var grid;
    grid = new SquarePicker;
    grid.dummy.attr("style", "width:100px; height:100px");
    grid.dummy.children(".cursor").attr("style", "width:10px; height:10px");
    grid.set("value", [0.45, 0.55]);
    assertThat(grid.dummy.children(".cursor").attr("style"), contains("left: 40px"));
    return assertThat(grid.dummy.children(".cursor").attr("style"), contains("top: 50px"));
  });
  test("When dragging, releasing the mouse outside of the widget should stop the drag", function() {
    var grid;
    grid = new SquarePicker;
    grid.dummy.mousedown();
    $(document).mouseup();
    return assertThat(!grid.dragging);
  });
  test("Clicking on a SquarePicker should give the focus to the widget", function() {
    var grid;
    grid = new SquarePicker;
    grid.dummy.mousedown();
    return assertThat(grid.hasFocus);
  });
  test("Clicking on a disabled SquarePicker shouldn't give the focus to the widget", function() {
    var grid;
    grid = new SquarePicker;
    grid.set("disabled", true);
    grid.dummy.mousedown();
    return assertThat(!grid.hasFocus);
  });
  test("A SquarePicker should allow to lock the X axis", function() {
    var grid;
    grid = new SquarePicker;
    grid.lockX();
    grid.set("value", [1, 0]);
    return assertThat(grid.get("value"), array(0, 0));
  });
  test("A SquarePicker should allow to lock the Y axis", function() {
    var grid;
    grid = new SquarePicker;
    grid.lockY();
    grid.set("value", [0, 1]);
    return assertThat(grid.get("value"), array(0, 0));
  });
  test("A SquarePicker should allow to unlock the X axis", function() {
    var grid;
    grid = new SquarePicker;
    grid.lockX();
    grid.unlockX();
    grid.set("value", [1, 0]);
    return assertThat(grid.get("value"), array(1, 0));
  });
  test("A SquarePicker should allow to unlock the Y axis", function() {
    var grid;
    grid = new SquarePicker;
    grid.lockY();
    grid.unlockY();
    grid.set("value", [0, 1]);
    return assertThat(grid.get("value"), array(0, 1));
  });
  spicker1 = new SquarePicker;
  spicker2 = new SquarePicker;
  spicker3 = new SquarePicker;
  spicker4 = new SquarePicker;
  spicker1.set("value", [.2, .5]);
  spicker2.set("value", [0, .6]);
  spicker3.set("value", [.7, .2]);
  spicker4.set("value", [.8, 0]);
  spicker2.lockX();
  spicker2.dummyClass = spicker2.dummyClass + " vertical";
  spicker2.updateStates();
  spicker4.dummyClass = spicker4.dummyClass + " horizontal";
  spicker4.updateStates();
  spicker3.set("readonly", true);
  spicker4.set("disabled", true);
  $("#qunit-header").before($("<h4>SquarePicker</h4>"));
  $("#qunit-header").before(spicker1.dummy);
  $("#qunit-header").before(spicker2.dummy);
  $("#qunit-header").before(spicker3.dummy);
  $("#qunit-header").before(spicker4.dummy);
  module("colorpickerdialog tests");
  test("A ColorPickerDialog should be hidden at startup", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });
  test("A ColorPickerDialog should have a listener for the dialogRequested signal that setup the dialog", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    return assertThat(dialog.get("value") === "#abcdef");
  });
  test("A ColorPickerDialog should show itself on a dialog request", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("A ColorPickerDialog should provides a method to convert a rgb color to hsv values", function() {
    var dialog, hsv;
    dialog = new ColorPickerDialog;
    hsv = rgb2hsv(10, 100, 200);
    return assertThat(hsv, array(closeTo(212, 2), closeTo(95, 2), closeTo(78, 2)));
  });
  test("A ColorPickerDialog should provides a method to convert a hsv color to rgb values", function() {
    var dialog, rgb;
    dialog = new ColorPickerDialog;
    rgb = hsv2rgb(212, 95, 78);
    return assertThat(rgb, array(closeTo(10, 2), closeTo(100, 2), closeTo(200, 2)));
  });
  test("A ColorPickerDialog should provides a dummy", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.dummy, notNullValue());
  });
  test("A ColorPickerDialog should provides a TextInput for each channel of the color", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.redInput instanceof TextInput);
    assertThat(dialog.greenInput instanceof TextInput);
    return assertThat(dialog.blueInput instanceof TextInput);
  });
  test("The inputs for the color channels should be limited to three chars", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.redInput.get("maxlength"), equalTo(3));
    assertThat(dialog.greenInput.get("maxlength"), equalTo(3));
    return assertThat(dialog.blueInput.get("maxlength"), equalTo(3));
  });
  test("A ColorPickerDialog should have the channels input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.dummy.children(".red")[0], equalTo(dialog.redInput.dummy[0]));
    assertThat(dialog.dummy.children(".green")[0], equalTo(dialog.greenInput.dummy[0]));
    return assertThat(dialog.dummy.children(".blue")[0], equalTo(dialog.blueInput.dummy[0]));
  });
  test("Setting the value of a ColorPickerDialog should fill the channels input", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    assertThat(dialog.redInput.get("value"), equalTo(0xab));
    assertThat(dialog.greenInput.get("value"), equalTo(0xcd));
    return assertThat(dialog.blueInput.get("value"), equalTo(0xef));
  });
  test("A ColorPickerDialog should provides a TextInput for each channel of the hsv color", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.hueInput instanceof TextInput);
    assertThat(dialog.saturationInput instanceof TextInput);
    return assertThat(dialog.valueInput instanceof TextInput);
  });
  test("The inputs for the hsv channels should be limited to three chars", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.hueInput.get("maxlength"), equalTo(3));
    assertThat(dialog.saturationInput.get("maxlength"), equalTo(3));
    return assertThat(dialog.valueInput.get("maxlength"), equalTo(3));
  });
  test("A ColorPickerDialog should have the channels input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.dummy.children(".hue")[0], equalTo(dialog.hueInput.dummy[0]));
    assertThat(dialog.dummy.children(".saturation")[0], equalTo(dialog.saturationInput.dummy[0]));
    return assertThat(dialog.dummy.children(".value")[0], equalTo(dialog.valueInput.dummy[0]));
  });
  test("Setting the value of a ColorPickerDialog should fill the channels input", function() {
    var dialog, h, v, _ref;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    _ref = rgb2hsv(0xab, 0xcd, 0xef), h = _ref[0], s = _ref[1], v = _ref[2];
    assertThat(dialog.hueInput.get("value"), equalTo(Math.round(h)));
    assertThat(dialog.saturationInput.get("value"), equalTo(Math.round(s)));
    return assertThat(dialog.valueInput.get("value"), equalTo(Math.round(v)));
  });
  test("A ColorPickerDialog should provides a TextInput for the hexadecimal color", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.hexInput instanceof TextInput);
  });
  test("The hexadecimal input should be limited to 6 chars", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.hexInput.get("maxlength"), equalTo(6));
  });
  test("A ColorPickerDialog should have the hexadecimal input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.dummy.children(".hex")[0], equalTo(dialog.hexInput.dummy[0]));
  });
  test("Setting the value of a ColorPickerDialog should fill the hexadecimal input", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    return assertThat(dialog.hexInput.get("value"), equalTo("abcdef"));
  });
  test("Setting the value of the red input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.redInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#ff0000"));
    dialog.redInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#450000"));
  });
  test("Setting an invalid value for the red input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.redInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });
  test("Setting the value of the green input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.greenInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#00ff00"));
    dialog.greenInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#004500"));
  });
  test("Setting an invalid value for the green input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.greenInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });
  test("Setting the value of the blue input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.blueInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#0000ff"));
    dialog.blueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#000045"));
  });
  test("Setting an invalid value for the blue input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.blueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });
  test("Setting the value of the hue input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#332929");
    dialog.hueInput.set("value", 100);
    assertThat(dialog.get("value"), equalTo("#2c3329"));
    dialog.hueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#323329"));
  });
  test("Setting an invalid value for the hue input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#332929");
    dialog.hueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#332929"));
  });
  test("Setting the value of the saturation input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.saturationInput.set("value", 50);
    assertThat(dialog.get("value"), equalTo("#2e331a"));
    dialog.saturationInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#2c3310"));
  });
  test("Setting an invalid value for the saturation input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.saturationInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });
  test("Setting the value of the value input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.valueInput.set("value", 50);
    assertThat(dialog.get("value"), equalTo("#7b8067"));
    dialog.valueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#a9b08d"));
  });
  test("Setting an invalid value for the value input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.valueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });
  test("Setting the value of the hex input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.hexInput.set("value", "abcdef");
    assertThat(dialog.get("value"), equalTo("#abcdef"));
    dialog.hexInput.set("value", "012345");
    return assertThat(dialog.get("value"), equalTo("#012345"));
  });
  test("Setting an invalid value for the hex input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#313329");
    dialog.hexInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });
  test("The ColorPickerDialog should provides two grid pickers", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.squarePicker instanceof SquarePicker);
    return assertThat(dialog.rangePicker instanceof SquarePicker);
  });
  test("A ColorPickerDialog should have a default edit mode for color manipulation through the SquarePickers", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    assertThat(dialog.squarePicker.get("rangeX"), array(0, 100));
    assertThat(dialog.squarePicker.get("rangeY"), array(0, 100));
    assertThat(dialog.rangePicker.get("rangeY"), array(0, 360));
    assertThat(dialog.squarePicker.get("value"), array(closeTo(28, 1), closeTo(100 - 94, 1)));
    return assertThat(dialog.rangePicker.get("value")[1], equalTo(360 - 210));
  });
  test("Clicking outside of the ColorPickerDialog should terminate the modification and set the value on the ColorPicker", function() {
    var MockColorPickerDialog, dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    MockColorPickerDialog = (function() {
      __extends(MockColorPickerDialog, ColorPickerDialog);
      function MockColorPickerDialog() {
        MockColorPickerDialog.__super__.constructor.apply(this, arguments);
      }
      MockColorPickerDialog.prototype.mouseup = function(e) {
        e.pageX = 1000;
        e.pageY = 1000;
        return MockColorPickerDialog.__super__.mouseup.call(this, e);
      };
      return MockColorPickerDialog;
    })();
    dialog = new MockColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    $(document).mouseup();
    assertThat(picker.get("value"), "#ff0000");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });
  test("Pressing enter on the ColorPickerDialog should terminate the modification and set the value on the ColorPicker", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#ff0000");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the red input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.redInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the green input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.greenInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the blue input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.blueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the hue input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.hueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the saturation input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.saturationInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the value input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.valueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("Pressing enter on the ColorPickerDialog while there was changes made to the hex input shouldn't comfirm the color changes", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.hexInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });
  test("A ColorPickerDialog should be placed next to the colorpicker a dialog request", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    assertThat(dialog.dummy.attr("style"), contains("left: 0px"));
    assertThat(dialog.dummy.attr("style"), contains("top: " + picker.dummy.height() + "px"));
    return assertThat(dialog.dummy.attr("style"), contains("position: absolute"));
  });
  test("A ColorPickerDialog should provides two more chidren that will be used to present the previous and current color", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    assertThat(dialog.dummy.children(".oldColor").attr("style"), contains("background: #abcdef"));
    return assertThat(dialog.dummy.children(".newColor").attr("style"), contains("background: #ff0000"));
  });
  test("Clicking on the old color should reset the value to the original one", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.dummy.children(".oldColor").click();
    return assertThat(dialog.get("value"), equalTo("#abcdef"));
  });
  test("Pressing escape on the ColorPickerDialog should close the dialog", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.fromHex("ff0000");
    dialog.keydown({
      keyCode: keys.escape,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(picker.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });
  test("ColorPickerDialog should take focus on dialogRequested", function() {
    var dialog, picker;
    picker = new ColorPicker;
    picker.set("value", "#abcdef");
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    return assertThat(dialog.hasFocus);
  });
  test("ColorPickerDialog should call the dispose method of the previous mode when it's changed", function() {
    var MockMode, dialog, disposeCalled;
    disposeCalled = false;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {
        return disposeCalled = true;
      };
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new MockMode);
    dialog.set("mode", new MockMode);
    return assertThat(disposeCalled);
  });
  test("ColorPickerDialog should call the update method when a new set is defined", function() {
    var MockMode, dialog, updateCalled;
    updateCalled = false;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {
        return updateCalled = true;
      };
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new MockMode);
    return assertThat(updateCalled);
  });
  test("A ColorPickerDialog should contains a radio group to select the color modes", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    assertThat(dialog.modesGroup instanceof RadioGroup);
    return assertThat(dialog.dummy.find(".radio").length, equalTo(6));
  });
  test("A ColorPickerDialog should provides 6 color edit modes", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.editModes, arrayWithLength(6));
  });
  test("The HSV radio should be checked at start", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    return assertThat(dialog.hueMode.get("checked"));
  });
  test("Checking a mode radio should select the mode for this dialog", function() {
    var dialog;
    dialog = new ColorPickerDialog;
    dialog.valueMode.set("checked", true);
    return assertThat(dialog.get("mode") === dialog.editModes[5]);
  });
  test("Ending the edit should return the focus on the color picker", function() {
    var dialog, picker;
    picker = new ColorPicker;
    dialog = new ColorPickerDialog;
    dialog.dialogRequested(picker);
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(picker.hasFocus);
  });
  dialog = new ColorPickerDialog;
  dialog.set("value", "#abcdef");
  dialog.addClasses("dummy");
  $("#qunit-header").before($("<h4>ColorPickerDialog</h4>"));
  $("#qunit-header").before(dialog.dummy);
  module("hsv mode tests");
  test("The HSV mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("The HSV mode should set the background of the color layer of the squarepicker according to the color", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    return assertThat(dialog.squarePicker.dummy.find(".hue-color").attr("style"), contains("background: #0080ff"));
  });
  test("When in HSV mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.rangePicker.set("value", [0, 260]);
    return assertThat(dialog.get("value"), equalTo("#c2efab"));
  });
  test("When in HSV mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.squarePicker.set("value", [20, 80]);
    return assertThat(dialog.get("value"), equalTo("#292e33"));
  });
  test("Disposing the HSV mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("HSVMode should no longer receive events from the dialog when it was disposed", function() {
    var MockHSVMode, MockMode, disposeCalled, rangeChangedCalled, squareChangedCalled;
    squareChangedCalled = false;
    rangeChangedCalled = false;
    disposeCalled = false;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    MockHSVMode = (function() {
      __extends(MockHSVMode, HSVMode);
      function MockHSVMode() {
        MockHSVMode.__super__.constructor.call(this);
        this.allowSignal = false;
      }
      MockHSVMode.prototype.dispose = function() {
        disposeCalled = true;
        this.allowSignal = true;
        return MockHSVMode.__super__.dispose.call(this);
      };
      MockHSVMode.prototype.squareChanged = function(widget, value) {
        if (this.allowSignal) {
          return squareChangedCalled = true;
        }
      };
      MockHSVMode.prototype.rangeChanged = function(widget, value) {
        if (this.allowSignal) {
          return rangeChangedCalled = true;
        }
      };
      return MockHSVMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new MockHSVMode);
    dialog.set("mode", new MockMode);
    dialog.rangePicker.set("value", [0, 0]);
    dialog.squarePicker.set("value", [0, 0]);
    assertThat(disposeCalled);
    assertThat(!squareChangedCalled);
    return assertThat(!rangeChangedCalled);
  });
  module("shv mode tests");
  test("The SHV mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    dialog.set("mode", new SHVMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("Disposing the SHV mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new SHVMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("The SHV mode should alter the opacity of the white plain span according to the color data", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#ff0000");
    dialog.set("mode", new SHVMode);
    assertThat(dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains("opacity: 1"));
  });
  test("When in SHV mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new SHVMode);
    dialog.rangePicker.set("value", [0, 90]);
    return assertThat(dialog.get("value"), equalTo("#d7e3ef"));
  });
  test("When in SHV mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new SHVMode);
    dialog.squarePicker.set("value", [200, 80]);
    assertThat(dialog.get("value"), equalTo("#24332e"));
    module("shv mode tests");
    return test("The SHV mode should creates layer in the squarepickers of its target dialog", function() {
      dialog = new ColorPickerDialog;
      dialog.set("mode", new SHVMode);
      assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
      return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
    });
  });
  module("vhs mode tests");
  test("The VHS mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    dialog.set("mode", new VHSMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("Disposing the VHS mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new VHSMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("The VHS mode should alter the opacity of the black plain span according to the color data", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.set("mode", new VHSMode);
    assertThat(dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains("opacity: 1"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains("opacity: 0"));
  });
  test("When in VHS mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new VHSMode);
    dialog.rangePicker.set("value", [0, 80]);
    return assertThat(dialog.get("value"), equalTo("#242c33"));
  });
  test("When in VHS mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new VHSMode);
    dialog.squarePicker.set("value", [200, 60]);
    return assertThat(dialog.get("value"), equalTo("#8fefcf"));
  });
  module("rgb mode tests");
  test("The RGB mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    dialog.set("mode", new RGBMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("Disposing the RGB mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new RGBMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("The RGB mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.set("mode", new RGBMode);
    assertThat(dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains("opacity: 1"));
  });
  test("When in RGB mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new RGBMode);
    dialog.rangePicker.set("value", [0, 55]);
    return assertThat(dialog.get("value"), equalTo("#c8cdef"));
  });
  test("When in RGB mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new RGBMode);
    dialog.squarePicker.set("value", [100, 205]);
    return assertThat(dialog.get("value"), equalTo("#ab3264"));
  });
  module("grb mode tests");
  test("The GRB mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    dialog.set("mode", new GRBMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("Disposing the GRB mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new GRBMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("The GRB mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.set("mode", new GRBMode);
    assertThat(dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains("opacity: 1"));
  });
  test("When in GRB mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new GRBMode);
    dialog.rangePicker.set("value", [0, 55]);
    return assertThat(dialog.get("value"), equalTo("#abc8ef"));
  });
  test("When in GRB mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new GRBMode);
    dialog.squarePicker.set("value", [100, 205]);
    return assertThat(dialog.get("value"), equalTo("#32cd64"));
  });
  module("bgr mode tests");
  test("The BGR mode should creates layer in the squarepickers of its target dialog", function() {
    dialog = new ColorPickerDialog;
    dialog.set("mode", new BGRMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });
  test("Disposing the BGR mode should remove the html content placed in the dialog by the mode", function() {
    var MockMode;
    MockMode = (function() {
      function MockMode() {}
      MockMode.prototype.init = function() {};
      MockMode.prototype.update = function() {};
      MockMode.prototype.dispose = function() {};
      return MockMode;
    })();
    dialog = new ColorPickerDialog;
    dialog.set("mode", new BGRMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });
  test("The BGR mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#000000");
    dialog.set("mode", new BGRMode);
    assertThat(dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains("opacity: 1"));
  });
  test("When in BGR mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new BGRMode);
    dialog.rangePicker.set("value", [0, 155]);
    return assertThat(dialog.get("value"), equalTo("#abcd64"));
  });
  test("When in BGR mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPickerDialog;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new BGRMode);
    dialog.squarePicker.set("value", [100, 155]);
    return assertThat(dialog.get("value"), equalTo("#6464ef"));
  });
  module("core tests");
  test("The widget's plugin should be available through the $ object", function() {
    return assertThat($.widgetPlugin, notNullValue());
  });
  test("The widget's plugin should provide a way to register custom widgets handlers", function() {
    var elementMatch, elementProcessor, id, plugin;
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "irrelevant match";
    elementProcessor = function() {};
    plugin.register(id, elementMatch, elementProcessor);
    return assertThat(plugin.isRegistered(id));
  });
  test("When the widget's plugin function is executed, the processor registered with an element in a set should be triggered", function() {
    var elementMatch, elementProcessor, id, plugin, processorCalled, processorScope, processorTarget;
    processorCalled = false;
    processorScope = null;
    processorTarget = null;
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    elementProcessor = function(target) {
      processorCalled = true;
      processorScope = this;
      return processorTarget = target;
    };
    plugin.register(id, elementMatch, elementProcessor);
    target = $("<span>");
    target.widgets();
    assertThat(processorCalled);
    assertThat(processorScope === plugin);
    return assertThat(processorTarget === target[0]);
  });
  test("Widget's plugin processors should also be able to use a function as element match", function() {
    var elementMatch, elementProcessor, id, plugin, processorCalled, processorScope, processorTarget;
    processorCalled = false;
    processorScope = null;
    processorTarget = null;
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = function(o) {
      return o.nodeName.toLowerCase() === "span";
    };
    elementProcessor = function(target) {
      processorCalled = true;
      processorScope = this;
      return processorTarget = target;
    };
    plugin.register(id, elementMatch, elementProcessor);
    target = $("<span>");
    target.widgets();
    assertThat(processorCalled);
    assertThat(processorScope === plugin);
    return assertThat(processorTarget === target[0]);
  });
  test("When a processor returns a widget, the plugin should place it in the element parent", function() {
    var elementMatch, elementProcessor, id, plugin;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };
      return MockWidget;
    })();
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    elementProcessor = function(o) {
      return new MockWidget;
    };
    plugin.register(id, elementMatch, elementProcessor);
    target = $("<p><span></span></p>");
    target.children().widgets();
    return assertThat(target.children("div").length, equalTo(1));
  });
  test("The widget plugin should prevent to register an invalid processor", function() {
    var elementMatch, elementProcessor, errorRaised, id, plugin;
    errorRaised = false;
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    elementProcessor = null;
    try {
      plugin.register(id, elementMatch, elementProcessor);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("The widget plugin should provide a shortcut for widget that doesn't require extra setup", function() {
    var elementMatch, id, plugin;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };
      return MockWidget;
    })();
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    plugin.registerWidgetFor(id, elementMatch, MockWidget);
    target = $("<p><span></span></p>");
    target.children().widgets();
    return assertThat(target.children("div").length, equalTo(1));
  });
  test("The widget plugin should prevent to register an invalid widget", function() {
    var elementMatch, errorRaised, id, plugin;
    errorRaised = false;
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    try {
      plugin.registerWidgetFor(id, elementMatch, null);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });
  test("When processed, an element should be flagged with a specific class", function() {
    var elementMatch, id, plugin;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };
      return MockWidget;
    })();
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    plugin.registerWidgetFor(id, elementMatch, MockWidget);
    target = $("<p><span></span></p>");
    target.children().widgets();
    return assertThat(target.children("span").hasClass("widget-done"));
  });
  test("The plugin process should prevent to process twice an element", function() {
    var elementMatch, id, plugin;
    MockWidget = (function() {
      __extends(MockWidget, Widget);
      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }
      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };
      return MockWidget;
    })();
    plugin = $.widgetPlugin;
    id = "irrelevant id";
    elementMatch = "span";
    plugin.registerWidgetFor(id, elementMatch, MockWidget);
    target = $("<p><span></span></p>");
    target.children().widgets();
    target.children().widgets();
    assertThat(target.children("div").length, equalTo(1));
    return $("body").append(target);
  });
  module("core processors tests");
  test("Input with type text should be replaced by a TextInput", function() {
    target = $("<p><input type='text'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".text").length, equalTo(1));
  });
  test("Input with type password should be replaced by a TextInput", function() {
    target = $("<p><input type='password'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".text").length, equalTo(1));
  });
  test("Input with type button should be replaced by a Button", function() {
    target = $("<p><input type='button'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".button").length, equalTo(1));
  });
  test("Input with type reset should be replaced by a Button", function() {
    target = $("<p><input type='reset'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".button").length, equalTo(1));
  });
  test("Input with type submit should be replaced by a Button", function() {
    target = $("<p><input type='submit'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".button").length, equalTo(1));
  });
  test("Input with type range should be replaced by a Slider", function() {
    target = $("<p><input type='range'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".slider").length, equalTo(1));
  });
  test("Input with type number should be replaced by a Stepper", function() {
    target = $("<p><input type='number'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".stepper").length, equalTo(1));
  });
  test("Input with type checkbox should be replaced by a CheckBox", function() {
    target = $("<p><input type='checkbox'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".checkbox").length, equalTo(1));
  });
  test("Input with type color should be replaced by a ColorPicker", function() {
    target = $("<p><input type='color'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".colorpicker").length, equalTo(1));
  });
  test("Input with type file should be replaced by a FilePicker", function() {
    target = $("<p><input type='file'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".filepicker").length, equalTo(1));
  });
  test("Input with type radio should be replaced by a Radio", function() {
    target = $("<p><input type='radio'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".radio").length, equalTo(1));
  });
  test("Many inputs with type radio and the same name should be handled by a RadioGroup", function() {
    var plugin;
    plugin = $.widgetPlugin;
    target = $("<p>                    <input type='radio' name='foo'></input>                    <input type='radio' name='foo'></input>                </p>");
    target.children().widgets();
    return assertThat(plugin.radiogroups["foo"], allOf(notNullValue(), hasProperty("radios", arrayWithLength(2))));
  });
  test("textarea nodes should be replaced by a TextArea", function() {
    target = $("<p><textarea></textarea></p>");
    target.children().widgets();
    return assertThat(target.children(".textarea").length, equalTo(1));
  });
  test("select nodes should be replaced by a SingleSelect", function() {
    target = $("<p><select></select></p>");
    target.children().widgets();
    return assertThat(target.children(".single-select").length, equalTo(1));
  });
}).call(this);
