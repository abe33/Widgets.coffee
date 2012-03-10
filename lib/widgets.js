(function() {
  var AbstractDateInputWidget, AbstractMode, BGRMode, BUILDS, BuildUnit, Button, Calendar, CheckBox, ColorInput, ColorPicker, Container, DateInput, DateTimeInput, DateTimeLocalInput, FilePicker, FocusProvidedByChild, GRBMode, HSVMode, HasChild, HasValueInRange, IsDialog, KeyStroke, MenuList, MenuModel, Module, MonthInput, NumericWidget, OpenCalendar, RGBMode, Radio, RadioGroup, SHVMode, SingleSelect, Slider, SquarePicker, Stepper, TableBuilder, TextArea, TextInput, TimeInput, VHSMode, WeekInput, Widget, WidgetPlugin, colorObjectFromValue, colorObjectToValue, fill, hex2rgb, hsv2rgb, i, isValidChannel, isValidColor, isValidHSV, isValidHue, isValidNumber, isValidPercentage, isValidRGB, isValidValue, j, keys, keystroke, radioProcessor, rgb2hex, rgb2hsv, safeInt,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = Array.prototype.slice,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Date.MILLISECONDS_IN_SECOND = 1000;

  Date.MILLISECONDS_IN_MINUTE = Date.MILLISECONDS_IN_SECOND * 60;

  Date.MILLISECONDS_IN_HOUR = Date.MILLISECONDS_IN_MINUTE * 60;

  Date.MILLISECONDS_IN_DAY = Date.MILLISECONDS_IN_HOUR * 24;

  Date.MILLISECONDS_IN_WEEK = Date.MILLISECONDS_IN_DAY * 7;

  Date.prototype.clone = function() {
    return new Date(this.valueOf());
  };

  Date.prototype.year = function(year) {
    if (year != null) {
      this.setFullYear(year);
      return this;
    } else {
      return this.getFullYear();
    }
  };

  Date.prototype.month = function(month) {
    if (month != null) {
      this.setMonth(month);
      return this;
    } else {
      return this.getMonth();
    }
  };

  Date.prototype.date = function(date) {
    if (date != null) {
      this.setDate(date);
      return this;
    } else {
      return this.getDate();
    }
  };

  Date.prototype.hours = function(hours) {
    if (hours != null) {
      this.setHours(hours);
      return this;
    } else {
      return this.getHours();
    }
  };

  Date.prototype.minutes = function(minutes) {
    if (minutes != null) {
      this.setMinutes(minutes);
      return this;
    } else {
      return this.getMinutes();
    }
  };

  Date.prototype.seconds = function(seconds) {
    if (seconds != null) {
      this.setSeconds(seconds);
      return this;
    } else {
      return this.getSeconds();
    }
  };

  Date.prototype.milliseconds = function(milliseconds) {
    if (milliseconds != null) {
      this.setMilliseconds(milliseconds);
      return this;
    } else {
      return this.getMilliseconds();
    }
  };

  Date.prototype.week = function(dowOffset) {
    var dif, start, timeOffset, week;
    if (dowOffset == null) dowOffset = 0;
    start = Date.findFirstWeekFirstDay(this.getFullYear(), dowOffset);
    timeOffset = (this.getTimezoneOffset() + 60) * Date.MILLISECONDS_IN_MINUTE;
    dif = this - start - timeOffset;
    week = Math.floor((dif / Date.MILLISECONDS_IN_WEEK) + 1);
    return week || this.firstDateOfMonth().incrementDate(-1).week();
  };

  Date.prototype.firstDateOfMonth = function() {
    return this.clone().date(1);
  };

  Date.prototype.lastDateOfMonth = function() {
    return this.clone().date(1).incrementMonth(1).incrementDate(-1);
  };

  Date.prototype.monthLength = function() {
    return this.lastDateOfMonth().date();
  };

  Date.findFirstWeekFirstDay = function(year, dowOffset) {
    var d, day;
    if (dowOffset == null) dowOffset = 0;
    d = new Date(year, 0, 1, 0, 0, 0, 0);
    day = d.getDay() + dowOffset * -1;
    if (day === 0) day = 7;
    if (day > 4) {
      return new Date(year, 0, 9 - day, 0);
    } else {
      return new Date(year, 0, 2 - day, 0);
    }
  };

  Date.prototype.incrementDate = function(amount) {
    return this.date(this.date() + amount);
  };

  Date.prototype.incrementMonth = function(amount) {
    return this.month(this.month() + amount);
  };

  Date.prototype.incrementYear = function(amount) {
    return this.year(this.year() + amount);
  };

  Date.prototype.equals = function(date, milliseconds) {
    if (milliseconds == null) milliseconds = false;
    return this.dateEquals(date) && this.timeEquals(date, milliseconds);
  };

  Date.prototype.dateEquals = function(date) {
    return this.year() === date.year() && this.month() === date.month() && this.date() === date.date();
  };

  Date.prototype.timeEquals = function(date, milliseconds) {
    if (milliseconds == null) milliseconds = false;
    return this.hours() === date.hours() && this.minutes() === date.minutes() && this.seconds() === date.seconds() && (milliseconds ? this.milliseconds() === date.milliseconds() : true);
  };

  Date.prototype.isToday = function() {
    return this.dateEquals(new Date);
  };

  Date.isValidTime = function(value) {
    if (value == null) return false;
    return /^[\d]{2}(:[\d]{2}(:[\d]{2}(\.[\d]{1,4})?)?)?$/.test(value);
  };

  Date.timeFromString = function(string) {
    var d, hours, min, ms, sec, time, _ref, _ref2;
    _ref = string.split(":"), hours = _ref[0], min = _ref[1], sec = _ref[2];
    _ref2 = sec != null ? sec.split(".") : [0, 0], sec = _ref2[0], ms = _ref2[1];
    time = safeInt(hours - 1) * Date.MILLISECONDS_IN_HOUR + safeInt(min) * Date.MILLISECONDS_IN_MINUTE + safeInt(sec) * Date.MILLISECONDS_IN_SECOND + safeInt(ms);
    d = new Date(time);
    return d;
  };

  Date.timeToString = function(date) {
    var h, m, ms, s, time;
    h = date.hours();
    m = date.minutes();
    s = date.seconds();
    ms = date.milliseconds();
    time = "" + (fill(h)) + ":" + (fill(m)) + ":" + (fill(s));
    if (ms !== 0) time += "." + ms;
    return time;
  };

  Date.isValidDate = function(value) {
    if (value == null) return false;
    return /^[\d]{4}-[\d]{2}-[\d]{2}$/.test(value);
  };

  Date.dateFromString = function(string) {
    var d;
    d = new Date(string);
    d.setHours(0);
    return d;
  };

  Date.dateToString = function(date) {
    return ["" + (fill(date.year(), 4)), "" + (fill(date.month() + 1)), "" + (fill(date.date()))].join("-");
  };

  Date.isValidMonth = function(value) {
    if (value == null) return false;
    return /^[\d]{4}-[\d]{2}$/.test(value);
  };

  Date.monthFromString = function(string) {
    var d;
    d = new Date(string);
    d.setHours(0);
    return d;
  };

  Date.monthToString = function(date) {
    return "" + (fill(date.year(), 4)) + "-" + (fill(date.month() + 1));
  };

  Date.isValidWeek = function(value) {
    if (value == null) return false;
    return /^[\d]{4}-W[\d]{2}$/.test(value);
  };

  Date.weekFromString = function(string) {
    var s, week, year, _ref;
    _ref = (function() {
      var _i, _len, _ref, _results;
      _ref = string.split("-W");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        _results.push(parseInt(s));
      }
      return _results;
    })(), year = _ref[0], week = _ref[1];
    return Date.getWeekDate(year, week);
  };

  Date.weekToString = function(date) {
    return "" + (fill(date.year(), 4)) + "-W" + (fill(date.week()));
  };

  Date.getWeekDate = function(year, week) {
    var date, start;
    start = Date.findFirstWeekFirstDay(year);
    date = new Date(start.valueOf() + Date.MILLISECONDS_IN_WEEK * (week - 1));
    date.setHours(0);
    date.setMinutes(0);
    date.setSeconds(0);
    date.setMilliseconds(0);
    return date;
  };

  Date.isValidDateTime = function(value) {
    if (value == null) return false;
    return /^[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}(\.[\d]{1,4})?(Z|(\+|\-)+[\d]{2}:[\d]{2})$/.test(value);
  };

  Date.datetimeFromString = function(string) {
    return new Date(string);
  };

  Date.datetimeToString = function(date) {
    var hours, minutes, offset, sign;
    offset = date.getTimezoneOffset();
    sign = "-";
    if (offset < 0) {
      sign = "+";
      offset *= -1;
    }
    minutes = offset % 60;
    hours = (offset - minutes) / 60;
    return ["" + (Date.dateToString(date)) + "T", "" + (Date.timeToString(date)), "" + sign + (fill(hours)) + ":" + (fill(minutes))].join("");
  };

  Date.dateTimeLocalRE = function() {
    return /^([\d]{4})-([\d]{2})-([\d]{2})T([\d]{2}):([\d]{2}):([\d]{2})(\.[\d]{1,3})?$/;
  };

  Date.isValidDateTimeLocal = function(value) {
    if (value == null) return false;
    return Date.dateTimeLocalRE().test(value);
  };

  Date.datetimeLocalFromString = function(string) {
    var day, hours, match, milliseconds, minutes, month, pI, seconds, year, _ref;
    _ref = Date.dateTimeLocalRE().exec(string), match = _ref[0], year = _ref[1], month = _ref[2], day = _ref[3], hours = _ref[4], minutes = _ref[5], seconds = _ref[6], milliseconds = _ref[7];
    pI = parseInt;
    return new Date(pI(year, 10), pI(month, 10) - 1, pI(day, 10), pI(hours, 10), pI(minutes, 10), pI(seconds, 10), milliseconds != null ? pI(milliseconds.replace(".", ""), 10) : 0);
  };

  Date.datetimeLocalToString = function(date) {
    return "" + (Date.dateToString(date)) + "T" + (Date.timeToString(date));
  };

  safeInt = function(value) {
    var n;
    n = parseInt(value);
    if (!isNaN(n)) {
      return n;
    } else {
      return 0;
    }
  };

  fill = function(s, l) {
    if (l == null) l = 2;
    s = String(s);
    while (s.length < l) {
      s = "0" + s;
    }
    return s;
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
      if (this.ctrl) a.push("Ctrl");
      if (this.shift) a.push("Shift");
      if (this.alt) a.push("Alt");
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

  this.keystroke = keystroke;

  this.keys = keys;

  HasValueInRange = {
    constructorHook: function() {
      this.min = null;
      this.max = null;
      this.step = null;
      this.registerKeyDownCommand(keystroke(keys.up), this.startIncrement);
      this.registerKeyUpCommand(keystroke(keys.up), this.endIncrement);
      this.registerKeyDownCommand(keystroke(keys.right), this.startIncrement);
      this.registerKeyUpCommand(keystroke(keys.right), this.endIncrement);
      this.registerKeyDownCommand(keystroke(keys.down), this.startDecrement);
      this.registerKeyUpCommand(keystroke(keys.down), this.endDecrement);
      this.registerKeyDownCommand(keystroke(keys.left), this.startDecrement);
      return this.registerKeyUpCommand(keystroke(keys.left), this.endDecrement);
    },
    fitToRange: function(value, min, max) {
      if ((min != null) && value < min) {
        value = min;
      } else if ((max != null) && value > max) {
        value = max;
      }
      return this.snapToStep(value);
    },
    snapToStep: function(value) {
      return value;
    },
    intervalId: -1,
    increment: function() {},
    decrement: function() {},
    startIncrement: function() {
      var _this = this;
      if (!this.cantInteract()) {
        if (this.intervalId === -1) {
          this.intervalId = setInterval(function() {
            return _this.increment();
          }, 50);
        }
      }
      return false;
    },
    startDecrement: function() {
      var _this = this;
      if (!this.cantInteract()) {
        if (this.intervalId === -1) {
          this.intervalId = setInterval(function() {
            return _this.decrement();
          }, 50);
        }
      }
      return false;
    },
    endIncrement: function() {
      clearInterval(this.intervalId);
      return this.intervalId = -1;
    },
    endDecrement: function() {
      clearInterval(this.intervalId);
      return this.intervalId = -1;
    },
    mousewheel: function(event, delta, deltaX, deltaY) {
      if (!this.cantInteract()) {
        if (delta > 0) {
          this.increment();
        } else {
          this.decrement();
        }
      }
      return false;
    }
  };

  FocusProvidedByChild = {
    constructorHook: function() {
      var _this = this;
      return this.focusProvider.bind(this.focusRelatedEvents, function(e) {
        return _this[e.type].apply(_this, arguments);
      });
    },
    setFocusable: function() {},
    grabFocus: function() {
      return this.focusProvider.focus();
    },
    supportedEvents: ["mousedown", "mouseup", "mousemove", "mouseover", "mouseout", "mousewheel", "click", "dblclick"].join(" "),
    focusRelatedEvents: ["focus", "blur", "keyup", "keydown", "keypress", "input", "change"].join(" "),
    unregisterFromDummyEvents: function() {
      this.focusProvider.unbind(this.focusRelatedEvents);
      return this["super"]("unregisterFromDummyEvents");
    },
    mouseup: function(e) {
      if (!this.get("disabled")) this.grabFocus();
      return true;
    }
  };

  HasChild = {
    constructorHook: function() {
      return this.children = [];
    },
    add: function(child) {
      if ((child != null) && child.isWidget && __indexOf.call(this.children, child) < 0) {
        this.children.push(child);
        child.attach(this.dummy);
        return child.parent = this;
      }
    },
    remove: function(child) {
      if ((child != null) && __indexOf.call(this.children, child) >= 0) {
        this.children.splice(this.children.indexOf(child), 1);
        child.detach();
        return child.parent = null;
      }
    },
    createDummy: function() {
      return $("<span class='container'></span>");
    },
    focus: function(e) {
      if (e.target === this.dummy[0]) return this["super"]("focus", e);
    }
  };

  IsDialog = {
    constructorHook: function() {
      this.dummy.hide();
      this.registerKeyDownCommand(keystroke(keys.enter), this.comfirmChangesOnEnter);
      return this.registerKeyDownCommand(keystroke(keys.escape), this.abortChanges);
    },
    dialogRequested: function(caller) {
      this.caller = caller;
      this.setupDialog(caller);
      return this.open();
    },
    open: function() {
      var _this = this;
      $(document).bind("mouseup", this.documentDelegate = function(e) {
        return _this.comfirmChanges();
      });
      this.dummy.css("left", this.caller.dummy.offset().left).css("top", this.caller.dummy.offset().top + this.caller.dummy.height()).css("position", "absolute").show();
      return this.grabFocus();
    },
    close: function() {
      this.dummy.hide();
      $(document).unbind("mouseup", this.documentDelegate);
      return this.caller.grabFocus();
    },
    mouseup: function(e) {
      return e.stopImmediatePropagation();
    },
    abortChanges: function() {
      return this.close();
    },
    comfirmChanges: function() {},
    comfirmChangesOnEnter: function() {},
    setupDialog: function(caller) {}
  };

  this.IsDialog = IsDialog;

  this.HasChild = HasChild;

  this.HasValueInRange = HasValueInRange;

  this.FocusProvidedByChild = FocusProvidedByChild;

  Module = (function() {

    Module.mixins = function() {
      var hook, key, mixin, mixins, value, _i, _len;
      mixins = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.prototype.__superOf__ = this.copy(this.prototype.__superOf__);
      for (_i = 0, _len = mixins.length; _i < _len; _i++) {
        mixin = mixins[_i];
        for (key in mixin) {
          value = mixin[key];
          if (!(key !== "constructorHook")) continue;
          this.prototype[key] = value;
          if (value instanceof Function) {
            this.prototype.__superOf__[key] = this.__super__;
          }
        }
        if (mixin.constructorHook != null) {
          hook = mixin.constructorHook;
          this.prototype.__constructorHooks__ = this.prototype.__constructorHooks__.concat(hook);
        }
      }
      return this;
    };

    Module.copy = function(o) {
      var i, r, _i, _len;
      r = {};
      if (o != null) {
        for (_i = 0, _len = o.length; _i < _len; _i++) {
          i = o[_i];
          r[i] = o[i];
        }
      }
      return r;
    };

    Module.prototype.__constructorHooks__ = [];

    Module.prototype.__superOf__ = {};

    Module.prototype.preventConstructorHooksInModule = false;

    function Module() {
      if (!this.preventConstructorHooksInModule) this.triggerConstructorHooks();
    }

    Module.prototype.triggerConstructorHooks = function() {
      var hook, _i, _len, _ref, _results;
      _ref = this.__constructorHooks__;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hook = _ref[_i];
        _results.push(hook.call(this));
      }
      return _results;
    };

    Module.prototype["super"] = function() {
      var args, method, _ref, _ref2;
      method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return (_ref = this.__superOf__[method]) != null ? (_ref2 = _ref[method]) != null ? _ref2.apply(this, args) : void 0 : void 0;
    };

    return Module;

  })();

  this.Module = Module;

  Widget = (function(_super) {

    __extends(Widget, _super);

    function Widget(target) {
      var classes, id,
        _this = this;
      if (target != null) this.checkTarget(target);
      this.propertyChanged = new Signal;
      this.valueChanged = new Signal;
      this.stateChanged = new Signal;
      this.attached = new Signal;
      this.detached = new Signal;
      this.target = target;
      this.hasTarget = target != null;
      this.jTarget = this.hasTarget ? $(target) : null;
      if (this.disabled == null) {
        this.disabled = this.booleanFromAttribute("disabled");
      }
      if (this.readonly == null) {
        this.readonly = this.booleanFromAttribute("readonly");
      }
      if (this.required == null) {
        this.required = this.booleanFromAttribute("required");
      }
      if (this.value == null) this.value = this.valueFromAttribute("value");
      if (this.name == null) this.name = this.valueFromAttribute("name");
      if (this.id == null) this.id = null;
      this.dummy = this.createDummy();
      this.hasDummy = this.dummy != null;
      this.hasFocus = false;
      this.isWidget = true;
      this.parent = null;
      this.keyDownCommands = {};
      this.keyUpCommands = {};
      if (this.hasTarget) {
        this.targetInitialValue = this.get("value");
        this.jTarget.bind("change", function(e) {
          return _this.targetChange(e);
        });
        this.jTarget.addClass("widget-done");
      }
      if (this.hasDummy) {
        this.dummyStates = ["disabled", "readonly", "required"];
        this.setFocusable(!this.get("disabled"));
        this.dummyClass = this.dummy.attr("class");
        if (this.hasTarget) {
          this.dummy.attr("style", this.jTarget.attr("style"));
          classes = this.jTarget.attr("class");
          if (classes != null) this.addClasses.apply(this, classes.split(/\s+/g));
          id = this.jTarget.attr("id");
          if ((id != null) && id !== "") this.set("id", "" + id + "-widget");
        }
        this.registerToDummyEvents();
        this.updateStates();
      }
      Widget.__super__.constructor.call(this);
    }

    Widget.prototype.get = function(property) {
      if (("get_" + property) in this) {
        return this["get_" + property].call(this, property);
      } else {
        return this[property];
      }
    };

    Widget.prototype.set = function(propertyOrObject, value) {
      var k, v, _results;
      if (value == null) value = null;
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
      if (("set_" + property) in this) {
        this["set_" + property].call(this, property, value);
      } else {
        this[property] = value;
      }
      this.updateStates();
      return this.propertyChanged.dispatch(this, property, value);
    };

    Widget.prototype.createProperty = function(property, value, setter, getter) {
      if (value == null) value = void 0;
      if (setter == null) setter = null;
      if (getter == null) getter = null;
      this[property] = value;
      if (setter != null) this["set_" + property] = setter;
      if (getter != null) return this["get_" + property] = getter;
    };

    Widget.prototype.get_disabled = function(property) {
      var res;
      res = this[property];
      if (this.parent != null) res = res || this.parent.get(property);
      return res;
    };

    Widget.prototype.set_disabled = function(property, value) {
      this[property] = this.booleanToAttribute(property, value);
      return this.setFocusable(!value);
    };

    Widget.prototype.get_readonly = function(property) {
      var res;
      res = this[property];
      if (this.parent != null) res = res || this.parent.get(property);
      return res;
    };

    Widget.prototype.set_readonly = function(property, value) {
      return this[property] = this.booleanToAttribute(property, value);
    };

    Widget.prototype.set_required = function(property, value) {
      return this[property] = this.booleanToAttribute(property, value);
    };

    Widget.prototype.set_value = function(property, value) {
      if (this.get("readonly")) {
        return this.get(property);
      } else {
        if (value !== this.get(property)) {
          this[property] = value;
          this.valueToAttribute(property, value);
          return this.valueChanged.dispatch(this, value);
        }
      }
    };

    Widget.prototype.set_name = function(property, value) {
      return this[property] = this.valueToAttribute(property, value);
    };

    Widget.prototype.set_id = function(property, value) {
      var _ref, _ref2;
      if (value != null) {
        if ((_ref = this.dummy) != null) _ref.attr("id", value);
      } else {
        if ((_ref2 = this.dummy) != null) _ref2.removeAttr("id");
      }
      return this[property] = value;
    };

    Widget.prototype.checkTarget = function(target) {
      if (!this.isElement(target)) {
        throw new Error("Widget's target should be a node");
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
      if (this.hasTarget) return this.jTarget.hide();
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
            if (newState.length > 0) newState += " ";
            newState += state;
          }
        }
        if (this.hasFocus) newState = "focus " + newState;
        outputState = (this.dummyClass != null) && newState !== "" ? this.dummyClass + " " + newState : this.dummyClass != null ? this.dummyClass : newState;
        if (outputState !== oldState) {
          this.dummy.attr("class", outputState);
          return this.stateChanged.dispatch(this, newState);
        }
      }
    };

    Widget.prototype.addClasses = function() {
      var cl, classes, dummyClasses, _i, _len, _ref;
      classes = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      dummyClasses = ((_ref = this.dummyClass) != null ? _ref.split(" ") : void 0) || [];
      for (_i = 0, _len = classes.length; _i < _len; _i++) {
        cl = classes[_i];
        if (__indexOf.call(dummyClasses, cl) < 0) dummyClasses.push(cl);
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
        if (__indexOf.call(classes, cl) < 0) output.push(cl);
      }
      this.dummyClass = output.join(" ");
      return this.updateStates();
    };

    Widget.prototype.attach = function(target) {
      return this.handleDOMInsertion(target, "append");
    };

    Widget.prototype.before = function(target) {
      return this.handleDOMInsertion(target, "before");
    };

    Widget.prototype.after = function(target) {
      return this.handleDOMInsertion(target, "after");
    };

    Widget.prototype.handleDOMInsertion = function(target, action) {
      if (target != null) {
        if (typeof target === "string") target = $(target);
        target[action](this.dummy);
        return this.attached.dispatch(this);
      }
    };

    Widget.prototype.detach = function() {
      this.dummy.detach();
      return this.detached.dispatch(this);
    };

    Widget.prototype.registerToDummyEvents = function() {
      var _this = this;
      return this.dummy.bind(this.supportedEvents, function(e) {
        return _this[e.type].apply(_this, arguments);
      });
    };

    Widget.prototype.unregisterFromDummyEvents = function() {
      return this.dummy.unbind(this.supportedEvents);
    };

    Widget.prototype.supportedEvents = ["mousedown", "mouseup", "mousemove", "mouseover", "mouseout", "mousewheel", "click", "dblclick", "focus", "blur", "keyup", "keydown", "keypress"].join(" ");

    Widget.prototype.mousedown = function() {
      return true;
    };

    Widget.prototype.mouseup = function() {
      return true;
    };

    Widget.prototype.mousemove = function() {
      return true;
    };

    Widget.prototype.mouseover = function() {
      return true;
    };

    Widget.prototype.mouseout = function() {
      return true;
    };

    Widget.prototype.mousewheel = function() {
      return true;
    };

    Widget.prototype.click = function() {
      return true;
    };

    Widget.prototype.dblclick = function() {
      return true;
    };

    Widget.prototype.focus = function(e) {
      if (!this.get("disabled")) this.hasFocus = true;
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
      if (this.hasDummy) return this.dummy.focus();
    };

    Widget.prototype.releaseFocus = function() {
      if (this.hasDummy) return this.dummy.blur();
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
        if (ks.match(e)) return command.call(this, e);
      }
      if (this.parent != null) this.parent.triggerKeyDownCommand(e);
      return true;
    };

    Widget.prototype.triggerKeyUpCommand = function(e) {
      var command, key, ks, _ref, _ref2;
      _ref = this.keyUpCommands;
      for (key in _ref) {
        _ref2 = _ref[key], ks = _ref2[0], command = _ref2[1];
        if (ks.match(e)) return command.call(this, e);
      }
      if (this.parent != null) this.parent.triggerKeyUpCommand(e);
      return true;
    };

    Widget.prototype.valueFromAttribute = function(property, defaultValue) {
      if (defaultValue == null) defaultValue = void 0;
      if (this.hasTarget) {
        return this.jTarget.attr(property);
      } else {
        return defaultValue;
      }
    };

    Widget.prototype.valueToAttribute = function(property, value) {
      if (this.hasTarget) this.jTarget.attr(property, value);
      return value;
    };

    Widget.prototype.booleanFromAttribute = function(property, defaultValue) {
      if (defaultValue == null) defaultValue = void 0;
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

    Widget.prototype.toString = function() {
      return this.stringify();
    };

    Widget.prototype.stringify = function() {
      var a, args, d, details, _i, _len;
      details = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      args = "";
      a = [];
      if (this.get("id") != null) a.push("id=\"" + (this.get("id")) + "\"");
      for (_i = 0, _len = details.length; _i < _len; _i++) {
        d = details[_i];
        if (this.get(d) != null) a.push("" + d + "=\"" + (this.get(d)) + "\"");
      }
      if (a.length > 0) args = "(" + (a.join(", ")) + ")";
      return "[object " + this.constructor.name + args + "]";
    };

    return Widget;

  })(Module);

  this.Widget = Widget;

  Container = (function(_super) {

    __extends(Container, _super);

    function Container() {
      Container.__super__.constructor.apply(this, arguments);
    }

    Container.mixins(HasChild);

    Container.prototype.createDummy = function() {
      return $("<span class='container'></span>");
    };

    return Container;

  })(Widget);

  this.Container = Container;

  Button = (function(_super) {

    __extends(Button, _super);

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
      this.action = action;
      this.updateContent();
      this.hideTarget();
      this.registerKeyDownCommand(keystroke(keys.space), this.click);
      this.registerKeyDownCommand(keystroke(keys.enter), this.click);
    }

    Button.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "button", "reset", "submit")) {
        throw new Error("Buttons only support input with a type in button,\nreset or submit as target");
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
      if (this.cantInteract()) return;
      action = this.get("action");
      if (action != null) action.action();
      if (this.hasTarget) return this.jTarget.click();
    };

    return Button;

  })(Widget);

  this.Button = Button;

  TextInput = (function(_super) {

    __extends(TextInput, _super);

    TextInput.mixins(FocusProvidedByChild);

    function TextInput(target) {
      if (target == null) target = $("<input type='text'></input>")[0];
      TextInput.__super__.constructor.call(this, target);
      this.maxlength = this.valueFromAttribute("maxlength");
      this.valueIsObsolete = false;
    }

    TextInput.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "text", "password")) {
        throw new Error("TextInput must have an input text as target");
      }
    };

    TextInput.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='text'></span>");
      dummy.append(this.jTarget);
      this.focusProvider = this.jTarget;
      return dummy;
    };

    TextInput.prototype.set_maxlength = function(property, value) {
      if (value != null) {
        this.jTarget.attr("maxlength", value);
      } else {
        this.jTarget.removeAttr("maxlength");
      }
      return this[property] = value;
    };

    TextInput.prototype.input = function(e) {
      return this.valueIsObsolete = true;
    };

    TextInput.prototype.change = function(e) {
      this.set("value", this.valueFromAttribute("value"));
      this.valueIsObsolete = false;
      return false;
    };

    return TextInput;

  })(Widget);

  this.TextInput = TextInput;

  TextArea = (function(_super) {

    __extends(TextArea, _super);

    TextArea.mixins(FocusProvidedByChild);

    function TextArea(target) {
      if (target == null) target = $("<textarea></textarea")[0];
      TextArea.__super__.constructor.call(this, target);
      this.valueIsObsolete = false;
    }

    TextArea.prototype.checkTarget = function(target) {
      if (!this.isTag(target, "textarea")) {
        throw new Error("TextArea only allow textarea nodes as target");
      }
    };

    TextArea.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='textarea'></span>");
      dummy.append(this.target);
      this.focusProvider = this.jTarget;
      return dummy;
    };

    TextArea.prototype.input = function(e) {
      return this.valueIsObsolete = true;
    };

    TextArea.prototype.change = function(e) {
      this.set("value", this.jTarget.val());
      this.valueIsObsolete = false;
      return true;
    };

    return TextArea;

  })(Widget);

  this.TextArea = TextArea;

  CheckBox = (function(_super) {

    __extends(CheckBox, _super);

    CheckBox.prototype.targetType = "checkbox";

    function CheckBox(target) {
      CheckBox.__super__.constructor.call(this, target);
      this.checkedChanged = new Signal;
      this.values = [true, false];
      this.checked = this.booleanFromAttribute("checked", false);
      this.targetInitialChecked = this.get("checked");
      this.dummyStates = ["checked", "disabled", "readonly", "required"];
      this.registerKeyUpCommand(keystroke(keys.enter), this.actionToggle);
      this.registerKeyUpCommand(keystroke(keys.space), this.actionToggle);
      this.updateStates();
      this.hideTarget();
    }

    CheckBox.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "checkbox")) {
        throw new Error("CheckBox target must be an input\nwith a checkbox type");
      }
    };

    CheckBox.prototype.set_checked = function(property, value) {
      this[property] = value;
      this.updateValue(value, this.get("values"));
      this.booleanToAttribute(property, value);
      return this.checkedChanged.dispatch(this, value);
    };

    CheckBox.prototype.set_value = function(property, value) {
      if (!this.valueSetProgrammatically) {
        this.set("checked", value === this.get("values")[0]);
      }
      return CheckBox.__super__.set_value.call(this, property, value);
    };

    CheckBox.prototype.set_values = function(property, value) {
      this.updateValue(this.get("checked"), value);
      return this[property] = value;
    };

    CheckBox.prototype.createDummy = function() {
      return $("<span class='checkbox'></span>");
    };

    CheckBox.prototype.toggle = function() {
      return this.set("checked", !this.get("checked"));
    };

    CheckBox.prototype.actionToggle = function() {
      if (!(this.get("readonly") || this.get("disabled"))) return this.toggle();
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
      if (!this.get("disabled")) return this.grabFocus();
    };

    return CheckBox;

  })(Widget);

  this.CheckBox = CheckBox;

  Radio = (function(_super) {

    __extends(Radio, _super);

    function Radio() {
      Radio.__super__.constructor.apply(this, arguments);
    }

    Radio.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "radio")) {
        throw new Error("Radio target must be an input with a radio type");
      }
    };

    Radio.prototype.createDummy = function() {
      return $("<span class='radio'></span>");
    };

    Radio.prototype.toggle = function() {
      if (!this.get("checked")) return Radio.__super__.toggle.call(this);
    };

    return Radio;

  })(CheckBox);

  this.Radio = Radio;

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
        if (radio.get("checked")) return this.selectedRadio = radio;
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
        if (r === radio) return _i;
      }
      return -1;
    };

    RadioGroup.prototype.checkedSetProgrammatically = false;

    RadioGroup.prototype.select = function(radio) {
      var oldSelectedRadio;
      if (radio !== this.selectedRadio) {
        this.checkedSetProgrammatically = true;
        oldSelectedRadio = this.selectedRadio;
        if (this.selectedRadio != null) this.selectedRadio.set("checked", false);
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

  this.RadioGroup = RadioGroup;

  NumericWidget = (function(_super) {

    __extends(NumericWidget, _super);

    NumericWidget.mixins(HasValueInRange);

    function NumericWidget(target) {
      var max, min, step;
      NumericWidget.__super__.constructor.call(this, target);
      min = parseFloat(this.valueFromAttribute("min"));
      max = parseFloat(this.valueFromAttribute("max"));
      step = parseFloat(this.valueFromAttribute("step"));
      if (isNaN(min)) min = null;
      if (isNaN(max)) max = null;
      if (isNaN(step)) step = null;
      this.min = min;
      this.max = max;
      this.step = step;
      this.value = parseFloat(this.valueFromAttribute("value", 0));
      this.hideTarget();
    }

    NumericWidget.prototype.snapToStep = function(value) {
      var step;
      step = this.get("step");
      if (step != null) {
        return value - (value % step);
      } else {
        return value;
      }
    };

    NumericWidget.prototype.increment = function() {
      return this.set("value", this.get("value") + this.get("step"));
    };

    NumericWidget.prototype.decrement = function() {
      return this.set("value", this.get("value") - this.get("step"));
    };

    NumericWidget.prototype.createDummy = function() {
      return $("<span></span>");
    };

    NumericWidget.prototype.updateDummy = function(value, min, max, step) {};

    NumericWidget.prototype.set_value = function(property, value) {
      var max, min, step;
      min = this.get("min");
      max = this.get("max");
      step = this.get("step");
      value = this.fitToRange(value, min, max);
      this.updateDummy(value, min, max, step);
      return NumericWidget.__super__.set_value.call(this, property, value);
    };

    NumericWidget.prototype.set_min = function(property, value) {
      var max;
      max = this.get("max");
      if (value >= max) {
        return this.get(property);
      } else {
        value = this.snapToStep(value);
        this[property] = value;
        this.valueToAttribute(property, value);
        this.set("value", this.fitToRange(this.get("value"), value, max));
        return value;
      }
    };

    NumericWidget.prototype.set_max = function(property, value) {
      var min;
      min = this.get("min");
      if (value <= min) {
        return this.get(property);
      } else {
        value = this.snapToStep(value);
        this[property] = value;
        this.valueToAttribute(property, value);
        this.set("value", this.fitToRange(this.get("value"), min, value));
        return value;
      }
    };

    NumericWidget.prototype.set_step = function(property, value) {
      var max, min;
      if (isNaN(value)) value = null;
      min = this.get("min");
      max = this.get("max");
      this.valueToAttribute(property, value);
      this[property] = value;
      this.set("value", this.fitToRange(this.get("value"), min, max));
      return value;
    };

    return NumericWidget;

  })(Widget);

  this.NumericWidget = NumericWidget;

  Slider = (function(_super) {

    __extends(Slider, _super);

    function Slider(target) {
      var _this = this;
      Slider.__super__.constructor.call(this, target);
      this.draggingKnob = false;
      this.lastMouseX = 0;
      this.lastMouseY = 0;
      this.valueCenteredOnKnob = true;
      if (this.get("step") == null) this.step = 1;
      if (this.get("min") == null) this.min = 0;
      if (this.get("max") == null) this.max = 100;
      this.set("value", this.get("value"));
      this.attached.add(function() {
        return _this.updateDummy(_this.get("value"), _this.get("min"), _this.get("max"), _this.get("step"));
      }, this);
    }

    Slider.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "range")) {
        throw new Error("Slider target must be an input with a range type");
      }
    };

    Slider.prototype.startDrag = function(e) {
      var _this = this;
      this.draggingKnob = true;
      this.lastMouseX = e.pageX;
      this.lastMouseY = e.pageY;
      $(document).bind("mouseup", this.documentMouseUpDelegate = function(e) {
        return _this.endDrag();
      });
      return $(document).bind("mousemove", this.documentMouseMoveDelegate = function(e) {
        return _this.drag(e);
      });
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
      var dummy,
        _this = this;
      dummy = $("<span class='slider'>                        <span class='track'></span>                        <span class='knob'></span>                        <span class='value'></span>                    </span>");
      dummy.children(".knob").bind("mousedown", function(e) {
        return _this.handleKnobMouseDown(e);
      });
      dummy.children(".track").bind("mousedown", function(e) {
        return _this.handleTrackMouseDown(e);
      });
      return dummy;
    };

    Slider.prototype.updateDummy = function(value, min, max, step) {
      var knob, knobPos, knobWidth, val, valPos, valWidth, width;
      width = this.dummy.width();
      knob = this.dummy.children(".knob");
      val = this.dummy.children(".value");
      valWidth = val.width();
      knobWidth = knob.width();
      knobWidth += parseInt(knob.css("margin-left"));
      knobWidth += parseInt(knob.css("margin-right"));
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

  })(NumericWidget);

  this.Slider = Slider;

  Stepper = (function(_super) {

    __extends(Stepper, _super);

    Stepper.mixins(FocusProvidedByChild);

    function Stepper(target) {
      Stepper.__super__.constructor.call(this, target);
      if (this.get("step") == null) this.set("step", 1);
      this.updateDummy(this.get("value"), this.get("min"), this.get("max"), this.get("step"));
    }

    Stepper.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "number")) {
        throw new Error("Stepper target must be an input\nwith a number type");
      }
    };

    Stepper.prototype.createDummy = function() {
      var buttonsMousedown, down, dummy, up,
        _this = this;
      dummy = $("<span class='stepper'>                <input type='text' class='value'></input>                <span class='down'></span>                <span class='up'></span>           </span>");
      this.focusProvider = dummy.children("input");
      down = dummy.children(".down");
      up = dummy.children(".up");
      buttonsMousedown = function(e) {
        var endFunction, startFunction;
        e.stopImmediatePropagation();
        _this.mousePressed = true;
        switch (e.target) {
          case down[0]:
            startFunction = _this.startDecrement;
            endFunction = _this.endDecrement;
            break;
          case up[0]:
            startFunction = _this.startIncrement;
            endFunction = _this.endIncrement;
        }
        startFunction.call(_this);
        return $(document).bind("mouseup", _this.documentDelegate = function(e) {
          _this.mousePressed = false;
          endFunction.call(_this);
          return $(document).unbind("mouseup", _this.documentDelegate);
        });
      };
      down.bind("mousedown", buttonsMousedown);
      up.bind("mousedown", buttonsMousedown);
      down.bind("mouseout", function() {
        if (_this.incrementInterval !== -1) return _this.endDecrement();
      });
      up.bind("mouseout", function() {
        if (_this.incrementInterval !== -1) return _this.endIncrement();
      });
      down.bind("mouseover", function() {
        if (_this.mousePressed) return _this.startDecrement();
      });
      up.bind("mouseover", function() {
        if (_this.mousePressed) return _this.startIncrement();
      });
      return dummy;
    };

    Stepper.prototype.updateStates = function() {
      Stepper.__super__.updateStates.call(this);
      if (this.get("readonly")) {
        this.focusProvider.attr("readonly", "readonly");
      } else {
        this.focusProvider.removeAttr("readonly");
      }
      if (this.get("disabled")) {
        return this.focusProvider.attr("disabled", "disabled");
      } else {
        return this.focusProvider.removeAttr("disabled");
      }
    };

    Stepper.prototype.updateDummy = function(value, min, max, step) {
      return this.focusProvider.val(value);
    };

    Stepper.prototype.validateInput = function() {
      var value;
      value = parseFloat(this.focusProvider.attr("value"));
      if (!isNaN(value)) {
        return this.set("value", value);
      } else {
        return this.updateDummy(this.get("value"), this.get("min"), this.get("max"), this.get("step"));
      }
    };

    Stepper.prototype.change = function(e) {
      return this.validateInput();
    };

    Stepper.prototype.mouseup = function() {
      if (this.get("disabled")) return true;
      this.grabFocus();
      if (this.dragging) {
        $(document).unbind("mousemove", this.documentMouseMoveDelegate);
        $(document).unbind("mouseup", this.documentMouseUpDelegate);
        this.dragging = false;
      }
      return true;
    };

    Stepper.prototype.mousedown = function(e) {
      var _this = this;
      if (this.cantInteract()) return true;
      this.dragging = true;
      this.pressedY = e.pageY;
      $(document).bind("mousemove", this.documentMouseMoveDelegate = function(e) {
        return _this.mousemove(e);
      });
      return $(document).bind("mouseup", this.documentMouseUpDelegate = function(e) {
        return _this.mouseup(e);
      });
    };

    Stepper.prototype.mousemove = function(e) {
      var dif, y;
      if (this.dragging) {
        y = e.pageY;
        dif = this.pressedY - y;
        this.set("value", this.get("value") + dif * this.get("step"));
        return this.pressedY = y;
      }
    };

    return Stepper;

  })(NumericWidget);

  this.Stepper = Stepper;

  FilePicker = (function(_super) {

    __extends(FilePicker, _super);

    FilePicker.mixins(FocusProvidedByChild);

    function FilePicker(target) {
      if (target == null) target = $("<input type='file'></input>")[0];
      FilePicker.__super__.constructor.call(this, target);
      if (this.cantInteract()) this.hideTarget();
    }

    FilePicker.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "file")) {
        throw new Error("FilePicker must have an input file as target");
      }
    };

    FilePicker.prototype.showTarget = function() {
      if (this.hasTarget) return this.jTarget.show();
    };

    FilePicker.prototype.change = function(e) {
      this.setValueLabel(this.jTarget.val() != null ? this.jTarget.val() : "Browse");
      return this.dummy.attr("title", this.jTarget.val());
    };

    FilePicker.prototype.createDummy = function() {
      var dummy;
      dummy = $("<span class='filepicker'>                    <span class='icon'></span>                    <span class='value'>Browse</span>                 </span>");
      dummy.append(this.jTarget);
      this.focusProvider = this.jTarget;
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

    return FilePicker;

  })(Widget);

  this.FilePicker = FilePicker;

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
          if (__indexOf.call(items, item) < 0) _results.push(item);
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
        if (this.isValidItem(item)) _results.push(item);
      }
      return _results;
    };

    MenuModel.prototype.isValidItem = function(item) {
      return (item != null) && (item.display != null) && (!(item.action != null) || $.isFunction(item.action)) && (!(item.menu != null) || item.menu instanceof MenuModel);
    };

    return MenuModel;

  })();

  MenuList = (function(_super) {

    __extends(MenuList, _super);

    function MenuList(model) {
      if (model == null) model = new MenuModel;
      MenuList.__super__.constructor.call(this);
      this.cropChanged = new Signal;
      this.selectedIndex = -1;
      this.model = null;
      this.set("model", model);
      this.parentList = null;
      this.childList = null;
      this.registerKeyDownCommand(keystroke(keys.enter), this.triggerAction);
      this.registerKeyDownCommand(keystroke(keys.space), this.triggerAction);
      this.registerKeyDownCommand(keystroke(keys.up), this.moveSelectionUp);
      this.registerKeyDownCommand(keystroke(keys.down), this.moveSelectionDown);
      this.registerKeyDownCommand(keystroke(keys.right), this.moveSelectionRight);
      this.registerKeyDownCommand(keystroke(keys.left), this.moveSelectionLeft);
      this.attached.add(this.updateSize, this);
      this.detached.add(this.updateSize, this);
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
      if (!this.hasFocus) return this.grabFocus();
    };

    MenuList.prototype.triggerAction = function() {
      var item;
      if (this.selectedIndex !== -1) {
        item = this.get("model").items[this.selectedIndex];
        if (item.action != null) return item.action();
      }
    };

    MenuList.prototype.createDummy = function() {
      return $("<ul class='menulist'></ul>");
    };

    MenuList.prototype.updateSize = function() {
      var itemHeight, maxSize, size, _ref;
      itemHeight = (_ref = this.dummy.children().first()[0]) != null ? _ref.offsetHeight : void 0;
      size = this.get("model").size();
      maxSize = this.get("size");
      if ((maxSize != null) && (itemHeight != null) && maxSize > 0 && size > maxSize) {
        this.dummy.height(itemHeight * maxSize);
        if (!this.dummy.hasClass("cropped")) {
          this.addClasses("cropped");
          return this.cropChanged.dispatch(this, true);
        }
      } else {
        this.dummy.css("height", "");
        if (this.dummy.hasClass("cropped")) {
          this.removeClasses("cropped");
          return this.cropChanged.dispatch(this, false);
        }
      }
    };

    MenuList.prototype.buildList = function(model) {
      var item, li, _i, _len, _ref,
        _this = this;
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
      return this.dummy.children().each(function(i, o) {
        var _item, _li;
        _li = $(o);
        _item = model.items[i];
        _li.mouseup(function(e) {
          if (!(_this.cantInteract() && (_item.action != null))) {
            return _item.action();
          }
        });
        return _li.mouseover(function(e) {
          if (!_this.cantInteract()) return _this.select(i);
        });
      });
    };

    MenuList.prototype.clearList = function() {
      return this.dummy.children().remove();
    };

    MenuList.prototype.close = function() {
      var _ref;
      this.dummy.blur();
      this.detach();
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
      if (this.childList.hasFocus) this.childList.dummy.blur();
      if (!this.isChildListVisible()) this.dummy.after(this.childList.dummy);
      if (this.childList.get("model") !== model) {
        this.childList.set("model", model);
      }
      left = this.dummy.offset().left + this.dummy.width();
      top = li.offset().top;
      return this.childList.dummy.attr("style", "left: " + left + "px; top: " + top + "px;");
    };

    MenuList.prototype.closeChildList = function() {
      var _ref;
      if ((_ref = this.childList) != null) _ref.close();
      return this.grabFocus();
    };

    MenuList.prototype.isChildListVisible = function() {
      var _ref;
      return ((_ref = this.childList) != null ? _ref.dummy.parent().length : void 0) === 1;
    };

    MenuList.prototype.set_model = function(property, value) {
      var _ref;
      this.clearList();
      if ((_ref = this[property]) != null) {
        _ref.contentChanged.remove(this.modelChanged, this);
      }
      if (value != null) value.contentChanged.add(this.modelChanged, this);
      this.buildList(value);
      return this[property] = value;
    };

    MenuList.prototype.set_size = function(property, value) {
      this[property] = value;
      this.updateSize();
      return value;
    };

    MenuList.prototype.mousedown = function(e) {
      return e.stopImmediatePropagation();
    };

    MenuList.prototype.modelChanged = function(model) {
      this.clearList();
      this.buildList(model);
      return this.updateSize();
    };

    MenuList.prototype.moveSelectionUp = function(e) {
      var newIndex;
      e.preventDefault();
      if (!this.cantInteract()) {
        newIndex = this.selectedIndex - 1;
        if (newIndex < 0) newIndex = this.get("model").size() - 1;
        return this.select(newIndex);
      }
    };

    MenuList.prototype.moveSelectionDown = function(e) {
      var newIndex;
      e.preventDefault();
      if (!this.cantInteract()) {
        newIndex = this.selectedIndex + 1;
        if (newIndex >= this.get("model").size()) newIndex = 0;
        return this.select(newIndex);
      }
    };

    MenuList.prototype.moveSelectionRight = function(e) {
      e.preventDefault();
      if (!this.cantInteract()) {
        if (this.isChildListVisible) return this.childList.grabFocus();
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

  })(Widget);

  this.MenuModel = MenuModel;

  this.MenuList = MenuList;

  SingleSelect = (function(_super) {

    __extends(SingleSelect, _super);

    function SingleSelect(target) {
      var size;
      SingleSelect.__super__.constructor.call(this, target);
      this.size = null;
      if (this.hasTarget) {
        size = parseInt(this.valueFromAttribute("size"));
        if (!isNaN(size)) this.size = size;
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
        throw new Error("A SingleSelect only allow select nodes as target");
      }
    };

    SingleSelect.prototype.buildModel = function(model, node) {
      var _this = this;
      node.each(function(i, o) {
        var option, value;
        option = $(o);
        if (o.nodeName.toLowerCase() === "optgroup") {
          return model.add({
            display: _this.getOptionLabel(option),
            menu: _this.buildModel(new MenuModel, option.children())
          });
        } else {
          value = _this.getOptionValue(option);
          return model.add({
            display: _this.getOptionLabel(option),
            value: value,
            action: function() {
              return _this.set("value", value);
            }
          });
        }
      });
      return model;
    };

    SingleSelect.prototype.getItemAt = function(path) {
      var item, model, step, _i, _len;
      if (path === null) return null;
      model = this.model;
      item = null;
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        step = path[_i];
        item = model.items[step];
        if (item == null) return null;
        if ((item != null ? item.menu : void 0) != null) model = item.menu;
      }
      return item;
    };

    SingleSelect.prototype.findValue = function(value, model) {
      var item, passResults, subPassResults, _i, _len, _ref;
      if (model == null) model = this.model;
      if (!(value != null) || value === "") return null;
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
      if (path === null) return null;
      model = this.model;
      item = null;
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        step = path[_i];
        item = model.items[step];
        if (item == null) return null;
        if ((item != null ? item.menu : void 0) != null) model = item.menu;
      }
      return model;
    };

    SingleSelect.prototype.clearOptions = function() {
      return this.jTarget.children().remove();
    };

    SingleSelect.prototype.buildOptions = function(model, target) {
      var act, group, _i, _len, _ref, _results,
        _this = this;
      if (model == null) model = this.model;
      if (target == null) target = this.jTarget;
      _ref = model.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        act = _ref[_i];
        if (act.menu != null) {
          group = $("<optgroup label='" + act.display + "'></optgroup>");
          target.append(group);
          _results.push(this.buildOptions(act.menu, group));
        } else {
          if (act.action == null) {
            act.action = function() {
              return _this.set("value", act.value);
            };
          }
          _results.push(target.append($("<option value='" + act.value + "'>" + act.display + "</option>")));
        }
      }
      return _results;
    };

    SingleSelect.prototype.updateOptionSelection = function() {
      var _ref;
      return (_ref = this.getOptionAt(this.selectedPath)) != null ? _ref.attr("selected", "selected") : void 0;
    };

    SingleSelect.prototype.getOptionLabel = function(option) {
      if (option == null) return null;
      if (option.attr("label")) {
        return option.attr("label");
      } else {
        return option.text();
      }
    };

    SingleSelect.prototype.getOptionValue = function(option) {
      if (option == null) return null;
      if (option.attr("value")) {
        return option.attr("value");
      } else {
        return option.text();
      }
    };

    SingleSelect.prototype.getOptionAt = function(path) {
      var children, option, step, _i, _len;
      if (path === null) return null;
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
      var model, newPath, previousItem, step;
      model = this.getModelAt(path);
      step = path.length - 1;
      newPath = path.concat();
      newPath[step]--;
      previousItem = this.getItemAt(newPath);
      while (!(previousItem != null) || (previousItem.menu != null)) {
        if (previousItem != null) {
          if (previousItem.menu != null) {
            newPath.push(0);
            step++;
            newPath[step] = this.getModelAt(newPath).size() - 1;
          }
        } else if (step > 0) {
          step--;
          newPath.pop();
          newPath[step]--;
          previousItem = this.getItemAt(newPath);
        } else {
          newPath = [this.model.items.length - 1];
        }
        previousItem = this.getItemAt(newPath);
      }
      return newPath;
    };

    SingleSelect.prototype.createDummy = function() {
      return $("<span class='single-select'>               <span class='value'></span>           </span>");
    };

    SingleSelect.prototype.updateDummy = function() {
      var display, _ref;
      if (this.selectedPath !== null) {
        display = (_ref = this.getItemAt(this.selectedPath)) != null ? _ref.display : void 0;
      } else {
        if (this.hasTarget && this.jTarget.attr("title")) {
          display = this.jTarget.attr("title");
        } else {
          display = "Empty";
        }
      }
      this.dummy.find(".value").remove();
      return this.dummy.append($("<span class='value'>" + display + "</span>"));
    };

    SingleSelect.prototype.buildMenu = function() {
      return this.menuList = new MenuList(this.model);
    };

    SingleSelect.prototype.openMenu = function() {
      var left, list, step, top, _i, _len, _ref, _results,
        _this = this;
      if (!this.cantInteract()) {
        ($(document)).bind("mousedown", this.documentDelegate = function(e) {
          return _this.documentMouseDown(e);
        });
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
            if (list.childList) {
              _results.push(list = list.childList);
            } else {
              _results.push(void 0);
            }
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

    SingleSelect.prototype.set_value = function(property, value) {
      var newPath, newValue, oldValue;
      oldValue = this.get("value");
      newValue = null;
      newPath = this.findValue(value);
      if (newPath !== null) {
        this.selectedPath = newPath;
        newValue = value;
      }
      if (this.hasTarget) this.updateOptionSelection();
      this.updateDummy();
      if (this.isMenuVisible()) this.closeMenu();
      if ((newValue != null) !== null) {
        return this[property] = newValue;
      } else {
        return oldValue;
      }
    };

    SingleSelect.prototype.modelChanged = function(model) {
      if (this.getItemAt(this.selectedPath) == null) {
        this.selectedPath = this.findNext([0]);
        this["value"] = this.getItemAt(this.selectedPath).value;
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

  })(Widget);

  this.SingleSelect = SingleSelect;

  Calendar = (function(_super) {

    __extends(Calendar, _super);

    Calendar.mixins(IsDialog);

    Calendar.DAYS = ["M", "T", "W", "T", "F", "S", "S"];

    Calendar.MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    function Calendar(value, mode) {
      this.value = value != null ? value : new Date();
      this.mode = mode != null ? mode : "date";
      Calendar.__super__.constructor.call(this);
      this.display(this.value);
    }

    Calendar.prototype.display = function(date) {
      this.month = date.firstDateOfMonth();
      return this.updateDummy();
    };

    Calendar.prototype.createDummy = function() {
      var dummy,
        _this = this;
      dummy = $("<span class='calendar'>                     <h3></h3>                     <a class='prev-year'>Previous Year</a>                     <a class='prev-month'>Previous Month</a>                     <a class='next-month'>Next Month</a>                     <a class='next-year'>Next Year</a>                     <table></table>                     <a class='today'>Today</a>                   </span>");
      dummy.find("a.today").click(function(e) {
        if (!_this.cantInteract()) return _this.display(new Date);
      });
      dummy.find("a.prev-year").click(function(e) {
        if (!_this.cantInteract()) {
          return _this.display(_this.month.incrementYear(-1));
        }
      });
      dummy.find("a.prev-month").click(function(e) {
        if (!_this.cantInteract()) {
          return _this.display(_this.month.incrementMonth(-1));
        }
      });
      dummy.find("a.next-month").click(function(e) {
        if (!_this.cantInteract()) {
          return _this.display(_this.month.incrementMonth(1));
        }
      });
      dummy.find("a.next-year").click(function(e) {
        if (!_this.cantInteract()) {
          return _this.display(_this.month.incrementYear(1));
        }
      });
      return dummy;
    };

    Calendar.prototype.updateDummy = function() {
      var date, h3, monthStartDay,
        _this = this;
      this.updateCells(this.month);
      monthStartDay = this.month.getDay() - 1;
      if (monthStartDay === -1) monthStartDay = 6;
      date = this.month.clone().incrementDate(-monthStartDay);
      this.dummy.find("td").each(function(i, o) {
        var td;
        td = $(o);
        td.text(date.date());
        td.attr("name", Date.dateToString(date));
        if (td.index() === 1) td.parent().find("th").text(date.week());
        _this.toggleState(td, date);
        return date.incrementDate(1);
      });
      h3 = this.dummy.find("h3");
      return h3.text("" + Calendar.MONTHS[this.month.month()] + " " + (this.month.year()));
    };

    Calendar.prototype.updateCells = function(value) {
      var cell, day, header, line, table, x, y, _i, _len, _ref, _ref2, _results,
        _this = this;
      table = this.dummy.find("table");
      table.find("td").unbind("mouseup", this.cellDelegate);
      table.children().remove();
      header = $("<tr><th></th></tr>");
      _ref = Calendar.DAYS;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        header.append("<th>" + day + "</th>");
      }
      table.append(header);
      _results = [];
      for (y = 0, _ref2 = this.linesNeeded(value); 0 <= _ref2 ? y <= _ref2 : y >= _ref2; 0 <= _ref2 ? y++ : y--) {
        line = $("<tr><th class='week'></th></tr>");
        for (x = 0; x <= 6; x++) {
          cell = $("<td></td>");
          cell.bind("mouseup", this.cellDelegate = function(e) {
            return _this.cellSelected(e);
          });
          line.append(cell);
        }
        _results.push(table.append(line));
      }
      return _results;
    };

    Calendar.prototype.linesNeeded = function(value) {
      var day, days;
      day = value.firstDateOfMonth().getDay();
      if (day === 0) day = 7;
      days = value.monthLength() + day;
      return Math.ceil(days / 7) - 1;
    };

    Calendar.prototype.cellSelected = function(e) {
      if (!this.cantInteract()) {
        e.stopImmediatePropagation();
        this.set("value", Date.dateFromString($(e.target).attr("name")));
        if (this.caller != null) return this.comfirmChanges();
      }
    };

    Calendar.prototype.toggleState = function(td, date) {
      var sameDate, sameMonth, sameWeek, sameYear, value;
      value = this.get("value");
      sameDate = date.date() === value.date();
      sameWeek = date.week() === value.week();
      sameMonth = date.month() === value.month();
      sameYear = date.year() === value.year();
      switch (this.get("mode")) {
        case "date":
          if (sameDate && sameMonth && sameYear) td.addClass("selected");
          break;
        case "month":
          if (sameMonth && sameYear) td.addClass("selected");
          break;
        case "week":
          if (sameWeek && sameYear) td.addClass("selected");
      }
      if (date.month() !== this.month.month()) td.addClass("blurred");
      if (date.isToday()) return td.addClass("today");
    };

    Calendar.prototype.set_value = function(property, value) {
      Calendar.__super__.set_value.call(this, property, value);
      this.display(value);
      return value;
    };

    Calendar.prototype.set_mode = function(property, value) {
      if (value !== "date" && value !== "month" && value !== "week") {
        return this.get("mode");
      }
      this[property] = value;
      this.updateDummy();
      return value;
    };

    Calendar.prototype.setupDialog = function(caller) {
      return this.set("value", this.originalValue = caller.get("date"));
    };

    Calendar.prototype.comfirmChanges = function() {
      this.caller.set("date", this.get("value"));
      return this.close();
    };

    Calendar.prototype.comfirmChangesOnEnter = function() {
      return this.comfirmChanges();
    };

    return Calendar;

  })(Widget);

  this.Calendar = Calendar;

  AbstractDateInputWidget = (function(_super) {

    __extends(AbstractDateInputWidget, _super);

    AbstractDateInputWidget.mixins(HasValueInRange);

    AbstractDateInputWidget.prototype.valueToDate = function(value) {
      return new Date;
    };

    AbstractDateInputWidget.prototype.dateToValue = function(date) {
      return "";
    };

    AbstractDateInputWidget.prototype.isValidValue = function(value) {
      return false;
    };

    AbstractDateInputWidget.prototype.supportedType = "";

    function AbstractDateInputWidget(target, defaultStep) {
      var date, max, maxDate, min, minDate, step;
      if (defaultStep == null) defaultStep = null;
      min = null;
      max = null;
      step = NaN;
      if (target instanceof Date) {
        AbstractDateInputWidget.__super__.constructor.call(this);
        date = target;
      } else {
        AbstractDateInputWidget.__super__.constructor.call(this, target);
        if (this.hasTarget) {
          date = this.dateFromAttribute("value", new Date);
          min = this.valueFromAttribute("min");
          max = this.valueFromAttribute("max");
          step = parseInt(this.valueFromAttribute("step"));
          if (!this.isValidValue(min)) min = null;
          if (!this.isValidValue(max)) max = null;
        } else {
          date = new Date;
        }
      }
      this.step = isNaN(step) ? defaultStep : step;
      if (min != null) {
        minDate = this.snapToStep(this.valueToDate(min));
        this.min = this.dateToValue(minDate);
      }
      if (max != null) {
        maxDate = this.snapToStep(this.valueToDate(max));
        this.max = this.dateToValue(maxDate);
      }
      this.date = this.fitToRange(date, minDate, maxDate);
      this.value = this.dateToValue(date);
      this.dateSetProgrammatically = false;
      this.valueSetProgrammatically = false;
      this.updateDummy();
      this.hideTarget();
    }

    AbstractDateInputWidget.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, this.supportedType)) {
        throw new Error("TimeInput target must be an input\nwith a " + this.supportedType + " type");
      }
    };

    AbstractDateInputWidget.prototype.dateFromAttribute = function(attr, defaultValue) {
      var value;
      if (defaultValue == null) defaultValue = null;
      value = this.valueFromAttribute(attr);
      if (this.isValidValue(value)) {
        return this.valueToDate(value);
      } else {
        return defaultValue;
      }
    };

    AbstractDateInputWidget.prototype.snapToStep = function(value) {
      var ms, step;
      ms = value.getTime();
      step = this.get("step");
      if (step != null) {
        value.setTime(ms - (ms % (step * Date.MILLISECONDS_IN_SECOND)));
      }
      return value;
    };

    AbstractDateInputWidget.prototype.increment = function() {
      var d, ms, step;
      d = this.get("date");
      step = this.get("step");
      ms = d.valueOf();
      d.setTime(ms + step * Date.MILLISECONDS_IN_SECOND);
      return this.set("date", d);
    };

    AbstractDateInputWidget.prototype.decrement = function() {
      var d, ms, step;
      d = this.get("date");
      step = this.get("step");
      ms = d.valueOf();
      d.setTime(ms - step * Date.MILLISECONDS_IN_SECOND);
      return this.set("date", d);
    };

    AbstractDateInputWidget.prototype.createDummy = function() {
      return $("<span class='dateinput " + this.supportedType + "'></span>");
    };

    AbstractDateInputWidget.prototype.updateDummy = function() {};

    AbstractDateInputWidget.prototype.set_date = function(property, value) {
      var max, min;
      if (!(value != null) || isNaN(value.date())) return this.get("date");
      min = this.get("min");
      max = this.get("max");
      if (min != null) min = this.valueToDate(min);
      if (max != null) max = this.valueToDate(max);
      this[property] = this.fitToRange(value, min, max);
      if (!this.dateSetProgrammatically) {
        this.valueSetProgrammatically = true;
        this.set("value", this.dateToValue(this[property]));
        this.valueSetProgrammatically = false;
      }
      this.updateDummy();
      return this[property];
    };

    AbstractDateInputWidget.prototype.set_value = function(property, value) {
      if (!this.isValidValue(value)) return this.get(property);
      if (!this.valueSetProgrammatically) {
        this.dateSetProgrammatically = true;
        this.set("date", this.valueToDate(value));
        this.dateSetProgrammatically = false;
      }
      AbstractDateInputWidget.__super__.set_value.call(this, property, this.dateToValue(this.get("date")));
      this.updateDummy();
      return this[property];
    };

    AbstractDateInputWidget.prototype.set_min = function(property, value) {
      if (!this.isValidValue(value)) return this.get(property);
      if (value > this.get("max")) return this.get(property);
      this[property] = this.dateToValue(this.snapToStep(this.valueToDate(value)));
      this.valueToAttribute(property, value);
      this.set("date", this.get("date"));
      return value;
    };

    AbstractDateInputWidget.prototype.set_max = function(property, value) {
      if (!this.isValidValue(value)) return this.get(property);
      if (value < this.get("min")) return this.get(property);
      this[property] = this.dateToValue(this.snapToStep(this.valueToDate(value)));
      this.valueToAttribute(property, value);
      this.set("date", this.get("date"));
      return value;
    };

    AbstractDateInputWidget.prototype.set_step = function(property, value) {
      if (isNaN(value)) value = null;
      this[property] = value;
      this.valueToAttribute(property, value);
      this.set("date", this.get("date"));
      return value;
    };

    return AbstractDateInputWidget;

  })(Widget);

  OpenCalendar = {
    constructorHook: function() {
      this.dialogRequested = new Signal;
      return this.dialogRequested.add(this.constructor.calendar.dialogRequested, this.constructor.calendar);
    },
    mouseup: function(e) {
      if (!this.cantInteract()) {
        e.stopImmediatePropagation();
        return this.dialogRequested.dispatch(this);
      }
    }
  };

  TimeInput = (function(_super) {

    __extends(TimeInput, _super);

    TimeInput.mixins(FocusProvidedByChild);

    function TimeInput(target) {
      this.supportedType = "time";
      this.valueToDate = Date.timeFromString;
      this.dateToValue = Date.timeToString;
      this.isValidValue = Date.isValidTime;
      TimeInput.__super__.constructor.call(this, target, 60);
    }

    TimeInput.prototype.createDummy = function() {
      var buttonsMousedown, down, dummy, up,
        _this = this;
      dummy = TimeInput.__super__.createDummy.call(this);
      dummy.append($("<input type='text' class='value widget-done'></input>\n<span class='down'></span>\n<span class='up'></span>"));
      this.focusProvider = dummy.find("input");
      down = dummy.find(".down");
      up = dummy.find(".up");
      buttonsMousedown = function(e) {
        var endFunction, startFunction;
        e.stopImmediatePropagation();
        _this.mousePressed = true;
        switch (e.target) {
          case down[0]:
            startFunction = _this.startDecrement;
            endFunction = _this.endDecrement;
            break;
          case up[0]:
            startFunction = _this.startIncrement;
            endFunction = _this.endIncrement;
        }
        startFunction.call(_this);
        return $(document).bind("mouseup", _this.documentDelegate = function(e) {
          _this.mousePressed = false;
          endFunction.call(_this);
          return $(document).unbind("mouseup", _this.documentDelegate);
        });
      };
      down.bind("mousedown", buttonsMousedown);
      up.bind("mousedown", buttonsMousedown);
      down.bind("mouseout", function() {
        if (_this.incrementInterval !== -1) return _this.endDecrement();
      });
      up.bind("mouseout", function() {
        if (_this.incrementInterval !== -1) return _this.endIncrement();
      });
      down.bind("mouseover", function() {
        if (_this.mousePressed) return _this.startDecrement();
      });
      up.bind("mouseover", function() {
        if (_this.mousePressed) return _this.startIncrement();
      });
      return dummy;
    };

    TimeInput.prototype.updateDummy = function() {
      return this.dummy.find("input").val(this.get("value").split(":").slice(0, 2).join(":"));
    };

    TimeInput.prototype.updateStates = function() {
      TimeInput.__super__.updateStates.call(this);
      if (this.get("readonly")) {
        this.focusProvider.attr("readonly", "readonly");
      } else {
        this.focusProvider.removeAttr("readonly");
      }
      if (this.get("disabled")) {
        return this.focusProvider.attr("disabled", "disabled");
      } else {
        return this.focusProvider.removeAttr("disabled");
      }
    };

    TimeInput.prototype.change = function(e) {
      var value;
      value = this.focusProvider.val();
      if (this.isValidValue(value)) {
        return this.set("value", value);
      } else {
        return this.updateDummy();
      }
    };

    TimeInput.prototype.input = function(e) {};

    TimeInput.prototype.mouseup = function() {
      if (this.get("disabled")) return true;
      this.grabFocus();
      if (this.dragging) {
        $(document).unbind("mousemove", this.documentMouseMoveDelegate);
        $(document).unbind("mouseup", this.documentMouseUpDelegate);
        this.dragging = false;
      }
      return true;
    };

    TimeInput.prototype.mousedown = function(e) {
      var _this = this;
      if (this.cantInteract()) return true;
      this.dragging = true;
      this.pressedY = e.pageY;
      $(document).bind("mousemove", this.documentMouseMoveDelegate = function(e) {
        return _this.mousemove(e);
      });
      return $(document).bind("mouseup", this.documentMouseUpDelegate = function(e) {
        return _this.mouseup(e);
      });
    };

    TimeInput.prototype.mousemove = function(e) {
      var dif, ms, step, y;
      if (this.dragging) {
        y = e.pageY;
        dif = this.pressedY - y;
        ms = this.get("date").valueOf();
        step = this.get("step");
        this.set("date", new Date(ms + dif * step * Date.MILLISECONDS_IN_SECOND));
        return this.pressedY = y;
      }
    };

    return TimeInput;

  })(AbstractDateInputWidget);

  DateInput = (function(_super) {

    __extends(DateInput, _super);

    DateInput.mixins(OpenCalendar);

    DateInput.calendar = new Calendar;

    $(document).ready(function() {
      return DateInput.calendar.attach("body");
    });

    function DateInput(target) {
      this.supportedType = "date";
      this.valueToDate = Date.dateFromString;
      this.dateToValue = Date.dateToString;
      this.isValidValue = Date.isValidDate;
      DateInput.__super__.constructor.call(this, target);
    }

    DateInput.prototype.createDummy = function() {
      var dummy;
      dummy = DateInput.__super__.createDummy.call(this);
      dummy.append("<span class='value'>" + (this.get("value")) + "</span>");
      return dummy;
    };

    DateInput.prototype.updateDummy = function() {
      return this.dummy.find(".value").text(this.get("value"));
    };

    return DateInput;

  })(AbstractDateInputWidget);

  MonthInput = (function(_super) {

    __extends(MonthInput, _super);

    MonthInput.mixins(OpenCalendar);

    MonthInput.calendar = new Calendar(null, "month");

    $(document).ready(function() {
      return MonthInput.calendar.attach("body");
    });

    function MonthInput(target) {
      this.supportedType = "month";
      this.valueToDate = Date.monthFromString;
      this.dateToValue = Date.monthToString;
      this.isValidValue = Date.isValidMonth;
      MonthInput.__super__.constructor.call(this, target);
    }

    MonthInput.prototype.createDummy = function() {
      var dummy;
      dummy = MonthInput.__super__.createDummy.call(this);
      dummy.append("<span class='value'>" + (this.get("value")) + "</span>");
      return dummy;
    };

    MonthInput.prototype.updateDummy = function() {
      return this.dummy.find(".value").text(this.get("value"));
    };

    return MonthInput;

  })(AbstractDateInputWidget);

  WeekInput = (function(_super) {

    __extends(WeekInput, _super);

    WeekInput.mixins(OpenCalendar);

    WeekInput.calendar = new Calendar(null, "week");

    $(document).ready(function() {
      return WeekInput.calendar.attach("body");
    });

    function WeekInput(target) {
      this.supportedType = "week";
      this.valueToDate = Date.weekFromString;
      this.dateToValue = Date.weekToString;
      this.isValidValue = Date.isValidWeek;
      WeekInput.__super__.constructor.call(this, target);
    }

    WeekInput.prototype.createDummy = function() {
      var dummy;
      dummy = WeekInput.__super__.createDummy.call(this);
      dummy.append("<span class='value'>" + (this.get("value")) + "</span>");
      return dummy;
    };

    WeekInput.prototype.updateDummy = function() {
      return this.dummy.find(".value").text(this.get("value"));
    };

    return WeekInput;

  })(AbstractDateInputWidget);

  DateTimeInput = (function(_super) {

    __extends(DateTimeInput, _super);

    function DateTimeInput(target) {
      this.supportedType = "datetime";
      this.valueToDate = Date.datetimeFromString;
      this.dateToValue = Date.datetimeToString;
      this.isValidValue = Date.isValidDateTime;
      DateTimeInput.__super__.constructor.call(this, target);
    }

    return DateTimeInput;

  })(AbstractDateInputWidget);

  DateTimeLocalInput = (function(_super) {

    __extends(DateTimeLocalInput, _super);

    function DateTimeLocalInput(target) {
      this.supportedType = "datetime-local";
      this.valueToDate = Date.datetimeLocalFromString;
      this.dateToValue = Date.datetimeLocalToString;
      this.isValidValue = Date.isValidDateTimeLocal;
      DateTimeLocalInput.__super__.constructor.call(this, target);
    }

    return DateTimeLocalInput;

  })(AbstractDateInputWidget);

  this.TimeInput = TimeInput;

  this.DateInput = DateInput;

  this.MonthInput = MonthInput;

  this.WeekInput = WeekInput;

  this.DateTimeInput = DateTimeInput;

  this.DateTimeLocalInput = DateTimeLocalInput;

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

  rgb2hsv = function(r, g, b) {
    var delta, deltaB, deltaG, deltaR, h, maxVal, minVal, rnd, s, v;
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
      s = delta / v;
      deltaR = (((v - r) / 6) + (delta / 2)) / delta;
      deltaG = (((v - g) / 6) + (delta / 2)) / delta;
      deltaB = (((v - b) / 6) + (delta / 2)) / delta;
      if (r === v) {
        h = deltaB - deltaG;
      } else if (g === v) {
        h = (1 / 3) + deltaR - deltaB;
      } else if (b === v) {
        h = (2 / 3) + deltaG - deltaR;
      }
      if (h < 0) h += 1;
      if (h > 1) h -= 1;
    }
    return [h * 360, s * 100, v * 100];
  };

  hsv2rgb = function(h, s, v) {
    var b, comp1, comp2, comp3, dominant, g, r, rnd, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
    h = h / 60;
    s = s / 100;
    v = v / 100;
    rnd = Math.round;
    if (s === 0) {
      return [rnd(v * 255, rnd(v * 255, rnd(v * 255)))];
    } else {
      dominant = Math.floor(h);
      comp1 = v * (1 - s);
      comp2 = v * (1 - s * (h - dominant));
      comp3 = v * (1 - s * (1 - (h - dominant)));
      switch (dominant) {
        case 0:
          _ref = [v, comp3, comp1], r = _ref[0], g = _ref[1], b = _ref[2];
          break;
        case 1:
          _ref2 = [comp2, v, comp1], r = _ref2[0], g = _ref2[1], b = _ref2[2];
          break;
        case 2:
          _ref3 = [comp1, v, comp3], r = _ref3[0], g = _ref3[1], b = _ref3[2];
          break;
        case 3:
          _ref4 = [comp1, comp2, v], r = _ref4[0], g = _ref4[1], b = _ref4[2];
          break;
        case 4:
          _ref5 = [comp3, comp1, v], r = _ref5[0], g = _ref5[1], b = _ref5[2];
          break;
        default:
          _ref6 = [v, comp1, comp2], r = _ref6[0], g = _ref6[1], b = _ref6[2];
      }
      return [r * 255, g * 255, b * 255];
    }
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

  isValidValue = function(value) {
    var re;
    re = /^\#[0-9a-fA-F]{6}$/;
    return re.test(value);
  };

  isValidNumber = function(value) {
    return (value != null) && !isNaN(value);
  };

  isValidHue = function(value) {
    return (isValidNumber(value)) && (0 <= value && value <= 360);
  };

  isValidPercentage = function(value) {
    return (isValidNumber(value)) && (0 <= value && value <= 100);
  };

  isValidChannel = function(value) {
    return (isValidNumber(value)) && (0 <= value && value <= 255);
  };

  isValidColor = function(value) {
    return (value != null) && (isValidChannel(value.red)) && (isValidChannel(value.green)) && (isValidChannel(value.blue));
  };

  isValidRGB = function(r, g, b) {
    return (isValidChannel(r)) && (isValidChannel(g)) && (isValidChannel(b));
  };

  isValidHSV = function(h, s, v) {
    return (isValidHue(h)) && (isValidPercentage(s)) && (isValidPercentage(v));
  };

  ColorInput = (function(_super) {

    __extends(ColorInput, _super);

    function ColorInput(target) {
      var value;
      ColorInput.__super__.constructor.call(this, target);
      this.dialogRequested = new Signal;
      value = this.valueFromAttribute("value");
      if (!isValidValue(value)) value = "#000000";
      this["value"] = value;
      this.color = colorObjectFromValue(value);
      this.dialogRequested.add(ColorInput.defaultListener.dialogRequested, ColorInput.defaultListener);
      this.updateDummy(value);
      this.hideTarget();
      this.registerKeyDownCommand(keystroke(keys.space), this.click);
      this.registerKeyDownCommand(keystroke(keys.enter), this.click);
    }

    ColorInput.prototype.checkTarget = function(target) {
      if (!this.isInputWithType(target, "color")) {
        throw new Error("ColorInput's target should be a color input");
      }
    };

    ColorInput.prototype.createDummy = function() {
      return $("<span class='colorinput'>               <span class='color'></span>           </span>");
    };

    ColorInput.prototype.updateDummy = function(value) {
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

    ColorInput.prototype.set_color = function(property, value) {
      var rgb;
      if (!isValidColor(value)) return this.get("color");
      rgb = colorObjectToValue(value);
      this.set("value", "#" + rgb);
      return this[property] = value;
    };

    ColorInput.prototype.set_value = function(property, value) {
      if (!isValidValue(value)) return this.get("value");
      this["color"] = colorObjectFromValue(value);
      this.updateDummy(value);
      return ColorInput.__super__.set_value.call(this, property, value);
    };

    ColorInput.prototype.click = function(e) {
      if (!this.cantInteract()) return this.dialogRequested.dispatch(this);
    };

    return ColorInput;

  })(Widget);

  SquarePicker = (function(_super) {

    __extends(SquarePicker, _super);

    function SquarePicker() {
      SquarePicker.__super__.constructor.call(this);
      this.rangeX = [0, 1];
      this.rangeY = [0, 1];
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
      if (!this.isValidRange(value)) return this.get(property);
      return this[property] = value;
    };

    SquarePicker.prototype.set_rangeY = function(property, value) {
      if (!this.isValidRange(value)) return this.get(property);
      return this[property] = value;
    };

    SquarePicker.prototype.set_value = function(property, value) {
      var v, x, y;
      if (!((value != null) && typeof value === "object" && value.length === 2 && this.isValid(value[0], "rangeX") && this.isValid(value[1], "rangeY"))) {
        return this.get("value");
      }
      v = this.get("value");
      x = value[0], y = value[1];
      if (this.xLocked) x = v[0];
      if (this.yLocked) y = v[1];
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
      if (value == null) return false;
      min = value[0], max = value[1];
      return (min != null) && (max != null) && !isNaN(min) && !isNaN(max) && min < max;
    };

    SquarePicker.prototype.mousedown = function(e) {
      var _this = this;
      if (!this.cantInteract()) {
        this.dragging = true;
        this.drag(e);
        $(document).bind("mouseup", this.documentMouseUpDelegate = function(e) {
          return _this.mouseup(e);
        });
        $(document).bind("mousemove", this.documentMouseMoveDelegate = function(e) {
          return _this.mousemove(e);
        });
      }
      if (!this.get("disabled")) this.grabFocus();
      return false;
    };

    SquarePicker.prototype.mousemove = function(e) {
      if (this.dragging) return this.drag(e);
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
      if (x < 0) x = 0;
      if (x > w) x = w;
      if (y < 0) y = 0;
      if (y > h) y = h;
      _ref = this.get("rangeX"), xmin = _ref[0], xmax = _ref[1];
      _ref2 = this.get("rangeY"), ymin = _ref2[0], ymax = _ref2[1];
      vx = xmin + (x / w) * xmax;
      vy = ymin + (y / h) * ymax;
      return this.set("value", [vx, vy]);
    };

    return SquarePicker;

  })(Widget);

  ColorPicker = (function(_super) {

    __extends(ColorPicker, _super);

    ColorPicker.mixins(HasChild, IsDialog);

    function ColorPicker() {
      ColorPicker.__super__.constructor.call(this);
      this.model = {
        r: 0,
        g: 0,
        b: 0,
        h: 0,
        s: 0,
        v: 0
      };
      this.inputValueSetProgrammatically = false;
      this.mode = null;
      this.editModes = [new RGBMode, new GRBMode, new BGRMode, new HSVMode, new SHVMode, new VHSMode];
      this.modesGroup = new RadioGroup;
      this.modesGroup.selectionChanged.add(this.modeChanged, this);
      this.createDummyChildren();
      this.set("mode", this.editModes[3]);
    }

    ColorPicker.prototype.createDummy = function() {
      var dummy,
        _this = this;
      dummy = $("<span class='colorpicker'>                      <span class='newColor'></span>                      <span class='oldColor'></span>                   </span>");
      dummy.children(".oldColor").click(function() {
        return _this.set("value", _this.originalValue);
      });
      return dummy;
    };

    ColorPicker.prototype.createDummyChildren = function() {
      this.add(this.redInput = this.newInput("red", 3));
      this.add(this.redMode = this.newRadio("red"));
      this.add(this.greenInput = this.newInput("green", 3));
      this.add(this.greenMode = this.newRadio("green"));
      this.add(this.blueInput = this.newInput("blue", 3));
      this.add(this.blueMode = this.newRadio("blue"));
      this.add(this.hueInput = this.newInput("hue", 3));
      this.add(this.hueMode = this.newRadio("hue", true));
      this.add(this.saturationInput = this.newInput("saturation", 3));
      this.add(this.saturationMode = this.newRadio("saturation"));
      this.add(this.valueInput = this.newInput("value", 3));
      this.add(this.valueMode = this.newRadio("value"));
      this.add(this.hexInput = this.newInput("hex", 6));
      this.add(this.squarePicker = new SquarePicker);
      this.add(this.rangePicker = new SquarePicker);
      this.rangePicker.lockX();
      return this.rangePicker.addClasses("vertical");
    };

    ColorPicker.prototype.newInput = function(cls, maxlength) {
      var input,
        _this = this;
      input = new TextInput;
      input.addClasses(cls);
      input.set("maxlength", maxlength);
      input.valueChanged.add(function(w, v) {
        _this.inputValueChanged(w, v, cls);
        return true;
      });
      return input;
    };

    ColorPicker.prototype.newRadio = function(cls, checked) {
      var radio;
      if (checked == null) checked = false;
      radio = new Radio;
      radio.addClasses(cls);
      radio.set("checked", checked);
      this.modesGroup.add(radio);
      return radio;
    };

    ColorPicker.prototype.invalidate = function() {
      var _this = this;
      this.update();
      return setTimeout(function() {
        return _this.update();
      }, 10);
    };

    ColorPicker.prototype.update = function() {
      var b, g, h, r, rnd, s, v, value, _ref;
      rnd = Math.round;
      _ref = this.model, r = _ref.r, g = _ref.g, b = _ref.b, h = _ref.h, s = _ref.s, v = _ref.v;
      value = rgb2hex(r, g, b);
      this["value"] = "#" + value;
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

    ColorPicker.prototype.updateInput = function(input, value) {
      return input.set("value", value);
    };

    ColorPicker.prototype.setupDialog = function(colorinput) {
      var value;
      this.originalValue = value = this.caller.get("value");
      this.set("value", value);
      return this.dummy.children(".oldColor").attr("style", "background: " + value + ";");
    };

    ColorPicker.prototype.comfirmChangesOnEnter = function() {
      if (!(this.redInput.valueIsObsolete || this.greenInput.valueIsObsolete || this.blueInput.valueIsObsolete || this.hueInput.valueIsObsolete || this.saturationInput.valueIsObsolete || this.valueInput.valueIsObsolete || this.hexInput.valueIsObsolete)) {
        return this.comfirmChanges();
      }
    };

    ColorPicker.prototype.comfirmChanges = function() {
      this.caller.set("value", this.get("value"));
      return this.close();
    };

    ColorPicker.prototype.set_mode = function(property, value) {
      var oldMode;
      oldMode = this[property];
      if (oldMode != null) oldMode.dispose();
      if (value != null) {
        value.init(this);
        value.update(this.model);
      }
      return this[property] = value;
    };

    ColorPicker.prototype.set_value = function(property, value) {
      if (!isValidValue(value)) return this.get("value");
      this.fromHex(value);
      return ColorPicker.__super__.set_value.call(this, property, value);
    };

    ColorPicker.prototype.fromHex = function(hex) {
      var b, g, r, v, _ref;
      v = hex.indexOf("#") === -1 ? "#" + hex : hex;
      if (isValidValue(v)) {
        _ref = colorObjectFromValue(v), r = _ref.red, g = _ref.green, b = _ref.blue;
        return this.fromRGB(r, g, b);
      }
    };

    ColorPicker.prototype.fromRGB = function(r, g, b) {
      var h, s, v, _ref;
      r = parseFloat(r);
      g = parseFloat(g);
      b = parseFloat(b);
      if (isValidRGB(r, g, b)) {
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

    ColorPicker.prototype.fromHSV = function(h, s, v) {
      var b, g, r, _ref;
      h = parseFloat(h);
      s = parseFloat(s);
      v = parseFloat(v);
      if (isValidHSV(h, s, v)) {
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

    ColorPicker.prototype.modeChanged = function(widget, oldSel, newSel) {
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

    ColorPicker.prototype.inputValueChanged = function(widget, value, component) {
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

    return ColorPicker;

  })(Widget);

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

  HSVMode = (function(_super) {

    __extends(HSVMode, _super);

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

  })(AbstractMode);

  SHVMode = (function(_super) {

    __extends(SHVMode, _super);

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

  })(AbstractMode);

  VHSMode = (function(_super) {

    __extends(VHSMode, _super);

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

  })(AbstractMode);

  RGBMode = (function(_super) {

    __extends(RGBMode, _super);

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

  })(AbstractMode);

  GRBMode = (function(_super) {

    __extends(GRBMode, _super);

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

  })(AbstractMode);

  BGRMode = (function(_super) {

    __extends(BGRMode, _super);

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

  })(AbstractMode);

  ColorInput.defaultListener = new ColorPicker;

  $(document).ready(function() {
    return ColorInput.defaultListener.attach("body");
  });

  this.rgb2hsv = rgb2hsv;

  this.hsv2rgb = hsv2rgb;

  this.ColorInput = ColorInput;

  this.SquarePicker = SquarePicker;

  this.ColorPicker = ColorPicker;

  this.HSVMode = HSVMode;

  this.SHVMode = SHVMode;

  this.VHSMode = VHSMode;

  this.RGBMode = RGBMode;

  this.GRBMode = GRBMode;

  this.BGRMode = BGRMode;

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
        throw new Error("The processor function can't be null in register");
      }
      return this.processors[id] = [match, processor];
    };

    WidgetPlugin.prototype.registerWidgetFor = function(id, match, widget) {
      if (widget == null) {
        throw new Error("The widget class can't be null                             in registerWidgetFor");
      }
      return this.register(id, match, function(target) {
        return new widget(target);
      });
    };

    WidgetPlugin.prototype.isRegistered = function(id) {
      return id in this.processors;
    };

    WidgetPlugin.prototype.process = function(queryset) {
      var _this = this;
      return queryset.each(function(i, o) {
        var elementMatched, id, match, next, parent, processor, target, widget, _ref, _ref2, _results;
        target = $(o);
        if (target.hasClass("widget-done")) return;
        next = target.next();
        parent = target.parent();
        _ref = _this.processors;
        _results = [];
        for (id in _ref) {
          _ref2 = _ref[id], match = _ref2[0], processor = _ref2[1];
          elementMatched = $.isFunction(match) ? match.call(_this, o) : o.nodeName.toLowerCase() === match;
          if (elementMatched) {
            widget = processor.call(_this, o);
            if (widget != null) {
              if (next.length > 0) {
                widget.before(next);
              } else {
                widget.attach(parent);
              }
            }
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
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

  $.widgetPlugin.registerWidgetFor("color", $.widgetPlugin.inputWithType("color"), ColorInput);

  $.widgetPlugin.registerWidgetFor("file", $.widgetPlugin.inputWithType("file"), FilePicker);

  $.widgetPlugin.registerWidgetFor("time", $.widgetPlugin.inputWithType("time"), TimeInput);

  $.widgetPlugin.registerWidgetFor("date", $.widgetPlugin.inputWithType("date"), DateInput);

  $.widgetPlugin.registerWidgetFor("month", $.widgetPlugin.inputWithType("month"), MonthInput);

  $.widgetPlugin.registerWidgetFor("week", $.widgetPlugin.inputWithType("week"), WeekInput);

  $.widgetPlugin.registerWidgetFor("datetime", $.widgetPlugin.inputWithType("datetime"), DateTimeInput);

  $.widgetPlugin.registerWidgetFor("datetime-local", $.widgetPlugin.inputWithType("datetime-local"), DateTimeLocalInput);

  radioProcessor = function(o) {
    var group, groups, name, widget;
    widget = new Radio(o);
    name = widget.get("name");
    if (name != null) {
      if ($.widgetPlugin.radiogroups == null) $.widgetPlugin.radiogroups = {};
      groups = $.widgetPlugin.radiogroups;
      if (groups[name] == null) groups[name] = new RadioGroup;
      group = groups[name];
      group.add(widget);
    }
    return widget;
  };

  $.widgetPlugin.register("radio", $.widgetPlugin.inputWithType("radio"), radioProcessor);

  TableBuilder = (function() {

    function TableBuilder(options) {
      this.options = options;
    }

    TableBuilder.prototype.build = function() {
      var col, cols, colspan, context, hasColumnHeaders, hasRowHeaders, k, row, rows, table, td, th, tr, unit, v, widget, _base, _i, _j, _k, _l, _len, _len2, _len3, _m, _ref, _ref2, _ref3, _results, _results2;
      cols = (function() {
        _results = [];
        for (var _i = 0, _ref = this.options.cols - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      rows = (function() {
        _results2 = [];
        for (var _j = 0, _ref2 = this.options.rows - 1; 0 <= _ref2 ? _j <= _ref2 : _j >= _ref2; 0 <= _ref2 ? _j++ : _j--){ _results2.push(_j); }
        return _results2;
      }).apply(this);
      hasColumnHeaders = this.options.columnHeaders != null;
      hasRowHeaders = this.options.rowHeaders != null;
      table = $("<table></table>");
      if (this.options.tableClass != null) table.addClass(this.options.tableClass);
      if (this.options.title != null) {
        colspan = this.options.cols;
        if (hasRowHeaders) colspan += 1;
        table.append($("<tr><th colspan='" + colspan + "'                                    class='table-header'>                                " + this.options.title + "                            </th></tr>"));
      }
      if (hasColumnHeaders) {
        tr = $("<tr></tr>");
        table.append(tr);
        if (hasRowHeaders) tr.append("<td></td>");
        context = {
          builder: this,
          table: table,
          tr: tr
        };
        for (_k = 0, _len = cols.length; _k < _len; _k++) {
          col = cols[_k];
          th = $("<th class='column-header'></th>");
          tr.append(th);
          context.col = col;
          context.th = th;
          th.text(this.options.columnHeaders(context));
        }
      }
      for (_l = 0, _len2 = rows.length; _l < _len2; _l++) {
        row = rows[_l];
        tr = $("<tr></tr>");
        table.append(tr);
        context = {
          builder: this,
          table: table,
          tr: tr,
          row: row
        };
        if (hasRowHeaders) {
          th = $("<th class='row-header'></th>");
          tr.append(th);
          context.th = th;
          th.text(this.options.rowHeaders(context));
        }
        for (_m = 0, _len3 = cols.length; _m < _len3; _m++) {
          col = cols[_m];
          td = $("<td></td>");
          tr.append(td);
          if (this.options.cls != null) {
            unit = new BuildUnit({
              cls: this.options.cls,
              args: this.options.args
            });
            widget = unit.build();
            widget.attach(td);
            context.widget = widget;
          }
          _ref3 = {
            td: td,
            col: col
          };
          for (k in _ref3) {
            v = _ref3[k];
            context[k] = v;
          }
          if (typeof (_base = this.options).cells === "function") {
            _base.cells(context);
          }
        }
      }
      return table;
    };

    return TableBuilder;

  })();

  BuildUnit = (function() {

    function BuildUnit(options) {
      this.options = options;
    }

    BuildUnit.prototype.build = function() {
      var k, o, _base;
      o = this.construct(this.options.cls, this.options.args);
      if (o.set instanceof Function) {
        o.set(this.options.set);
      } else {
        for (k in this.options.set) {
          o[k] = this.options.set[k];
        }
      }
      if (typeof (_base = this.options).callback === "function") _base.callback(o);
      return o;
    };

    BuildUnit.prototype.construct = function(klass, args) {
      var f;
      f = BUILDS[args != null ? args.length : 0];
      return f(klass, args);
    };

    return BuildUnit;

  })();

  BUILDS = (function() {
    var _results;
    _results = [];
    for (i = 0; i <= 24; i++) {
      _results.push(new Function("return new arguments[0](" + (((function() {
        var _results2;
        _results2 = [];
        for (j = 0; 0 <= i ? j <= i : j >= i; 0 <= i ? j++ : j--) {
          if (j !== 0) _results2.push("arguments[1][" + (j - 1) + "]");
        }
        return _results2;
      })()).join(",")) + ");"));
    }
    return _results;
  })();

  this.BuildUnit = BuildUnit;

  this.TableBuilder = TableBuilder;

}).call(this);
