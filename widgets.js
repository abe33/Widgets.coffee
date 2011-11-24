(function() {
  var CheckBox, KeyStroke, Radio, RadioGroup, Slider, Widget, keys, keystroke;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __slice = Array.prototype.slice;
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
      var _ref;
      if ((target != null) && ((_ref = target.nodeName) != null ? typeof _ref.toLowerCase === "function" ? _ref.toLowerCase() : void 0 : void 0) !== "input") {
        throw "Widget's target must be an input node";
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
        name: this.valueFromAttribute("name")
      };
      this.dummy = this.createDummy();
      this.hasDummy = this.dummy != null;
      this.hasFocus = false;
      this.dummyStates = ["disabled", "readonly"];
      if (this.hasTarget) {
        this.targetInitialValue = this.valueFromAttribute("value");
        this.jTarget.bind("change", __bind(function(e) {
          return this.targetChange(e);
        }, this));
      }
      if (this.hasDummy) {
        this.setFocusable(!this.get("disabled"));
        this.dummyClass = this.dummy.attr("class");
        if (this.hasTarget) {
          this.dummy.attr("style", this.jTarget.attr("style"));
        }
        this.registerToDummyEvents();
        this.updateStates();
      }
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
    Widget.prototype.set = function(property, value) {
      if (property in this.properties) {
        this.properties[property] = ("set_" + property) in this ? this["set_" + property].call(this, property, value) : value;
        this.updateStates();
        return this.propertyChanged.dispatch(this, property, value);
      }
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
    Widget.prototype.hideTarget = function() {
      if (this.hasTarget) {
        return this.jTarget.hide();
      }
    };
    Widget.prototype.reset = function() {
      return this.set("value", this.targetInitialValue);
    };
    Widget.prototype.targetChange = function(e) {};
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
        outputState = (this.dummyClass != null) && newState !== "" ? this.dummyClass + " " + newState : this.dummyClass != null ? this.dummyClass : newState;
        if (outputState !== oldState) {
          this.dummy.attr("class", outputState);
          return this.stateChanged.dispatch(this, newState);
        }
      }
    };
    Widget.prototype.registerToDummyEvents = function() {
      return this.dummy.bind(this.supportedEvents, __bind(function(e) {
        return this[e.type].apply(this, arguments);
      }, this));
    };
    Widget.prototype.unregisterFromDummyEvents = function() {
      return this.dummy.unbind(this.supportedEvents);
    };
    Widget.prototype.supportedEvents = "mousedown mouseup mousemove mouseover mouseout mousewheel 					 click dblclick focus blur keyup keydown keypress";
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
      return !this.get("disabled");
    };
    Widget.prototype.blur = function(e) {
      this.hasFocus = false;
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
    Widget.prototype.registerKeyDownCommand = function(keystroke, command) {
      return this.keyDownCommands[keystroke] = [keystroke, command];
    };
    Widget.prototype.registerKeyUpCommand = function(keystroke, command) {
      return this.keyUpCommands[keystroke] = [keystroke, command];
    };
    Widget.prototype.hasKeyDownCommand = function(keystroke) {
      return keystroke in this.keyDownCommands;
    };
    Widget.prototype.hasKeyUpCommand = function(keystroke) {
      return keystroke in this.keyUpCommands;
    };
    Widget.prototype.triggerKeyDownCommand = function(e) {
      var command, key, _ref, _ref2;
      _ref = this.keyDownCommands;
      for (key in _ref) {
        _ref2 = _ref[key], keystroke = _ref2[0], command = _ref2[1];
        if (keystroke.match(e)) {
          return command.call(this, e);
        }
      }
      return true;
    };
    Widget.prototype.triggerKeyUpCommand = function(e) {
      var command, key, _ref, _ref2;
      _ref = this.keyUpCommands;
      for (key in _ref) {
        _ref2 = _ref[key], keystroke = _ref2[0], command = _ref2[1];
        if (keystroke.match(e)) {
          return command.call(this, e);
        }
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
  CheckBox = (function() {
    __extends(CheckBox, Widget);
    CheckBox.prototype.targetType = "checkbox";
    function CheckBox(target) {
      if ((target != null) && $(target).attr("type") !== this.targetType) {
        throw "CheckBox target must be an input with a checkbox type";
      }
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
    Radio.prototype.targetType = "radio";
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
  Slider = (function() {
    __extends(Slider, Widget);
    function Slider(target) {
      if ((target != null) && $(target).attr("type") !== "range") {
        throw "Slider target must be an input with a range type";
      }
      Slider.__super__.constructor.call(this, target);
      this.createProperty("min", parseFloat(this.valueFromAttribute("min", 0)));
      this.createProperty("max", parseFloat(this.valueFromAttribute("max", 100)));
      this.createProperty("step", parseFloat(this.valueFromAttribute("step", 1)));
      this.properties.value = parseFloat(this.valueFromAttribute("value", 0));
      this.draggingKnob = false;
      this.lastMouseX = 0;
      this.lastMouseY = 0;
      this.valueCenteredOnKnob = false;
      this.registerKeyDownCommand(keystroke(keys.up), this.startIncrement);
      this.registerKeyUpCommand(keystroke(keys.up), this.endIncrement);
      this.registerKeyDownCommand(keystroke(keys.down), this.startDecrement);
      this.registerKeyUpCommand(keystroke(keys.down), this.endDecrement);
      this.incrementInterval = -1;
      if (this.hasDummy) {
        this.updateDummy(this.get("value"), this.get("min"), this.get("max"));
      }
      this.hideTarget();
    }
    Slider.prototype.cantInteract = function() {
      return this.get("readonly") || this.get("disabled");
    };
    Slider.prototype.cleanValue = function(value, min, max, step) {
      if (value < min) {
        value = min;
      } else if (value > max) {
        value = max;
      }
      return value - (value % step);
    };
    Slider.prototype.increment = function() {
      return this.set("value", this.get("value") + this.get("step"));
    };
    Slider.prototype.decrement = function() {
      return this.set("value", this.get("value") - this.get("step"));
    };
    Slider.prototype.startDrag = function(e) {
      this.draggingKnob = true;
      this.lastMouseX = e.pageX;
      this.lastMouseY = e.pageY;
      $(document).bind("mouseup", __bind(function() {
        return this.endDrag();
      }, this));
      return $(document).bind("mousemove", __bind(function(e) {
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
      return $(document).unbind("mousemove mouseup");
    };
    Slider.prototype.getDragDataFromEvent = function(e) {
      return {
        x: e.pageX - this.lastMouseX,
        y: e.pageY - this.lastMouseY
      };
    };
    Slider.prototype.mousewheel = function(event, delta, deltaX, deltaY) {
      if (!(this.get("readonly") || this.get("disabled"))) {
        this.set("value", this.get("value") + delta * this.get("step"));
      }
      return false;
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
    Slider.prototype.startIncrement = function() {
      if (!this.cantInteract()) {
        if (this.incrementInterval === -1) {
          this.incrementInterval = setInterval(__bind(function() {
            return this.increment();
          }, this), 50);
        }
      }
      return false;
    };
    Slider.prototype.startDecrement = function() {
      if (!this.cantInteract()) {
        if (this.incrementInterval === -1) {
          this.incrementInterval = setInterval(__bind(function() {
            return this.decrement();
          }, this), 50);
        }
      }
      return false;
    };
    Slider.prototype.endIncrement = function() {
      clearInterval(this.incrementInterval);
      return this.incrementInterval = -1;
    };
    Slider.prototype.endDecrement = function() {
      clearInterval(this.incrementInterval);
      return this.incrementInterval = -1;
    };
    Slider.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='slider'>						<span class='track'></span>						<span class='knob'></span>						<span class='value'></span>				   	</span>");
      dummy.children(".knob").bind("mousedown", __bind(function(e) {
        return this.handleKnobMouseDown(e);
      }, this));
      dummy.children(".track").bind("mousedown", __bind(function(e) {
        return this.handleTrackMouseDown(e);
      }, this));
      return dummy;
    };
    Slider.prototype.updateDummy = function(value, min, max) {
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
    Slider.prototype.set_value = function(property, value) {
      var max, min, step;
      min = this.get("min");
      max = this.get("max");
      step = this.get("step");
      value = this.cleanValue(value, min, max, step);
      this.updateDummy(value, min, max);
      return Slider.__super__.set_value.call(this, property, value);
    };
    Slider.prototype.set_min = function(property, value) {
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
    Slider.prototype.set_max = function(property, value) {
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
    Slider.prototype.set_step = function(property, value) {
      var max, min;
      min = this.get("min");
      max = this.get("max");
      this.valueToAttribute(property, value);
      this.set("value", this.cleanValue(this.get("value"), min, max, value));
      return value;
    };
    return Slider;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.Slider = Slider;
  }
}).call(this);
