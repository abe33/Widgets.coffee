(function() {
  var MockWidget, a, area1, area2, area3, button1, button2, button3, checkbox1, checkbox2, checkbox3, dialog, group, input1, input2, input3, item1, item2, item3, item4, item5, item6, item7, item8, list1, list2, list3, model, opt, picker1, picker2, picker3, radio1, radio2, radio3, s, select1, select2, select3, sinput1, sinput2, sinput3, sinput4, slider1, slider2, slider3, stepper1, stepper2, stepper3, target, testFocusProvidedByChildMixinBegavior, testGenericDateTimeFunctions, testGenericDateWidgetBehaviors, testRangeStepperMixinBehavior, testRangeStepperMixinIntervalsRunning, testRangeStepperMixinKeyboardBehavior, testRangeStepperMixinMouseWheelBehavior,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  testRangeStepperMixinBehavior = function(opt) {
    test("" + opt.className + " value shouldn't be set on a value outside of the range", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("value", opt.valueBelowRange);
      assertThat(widget.get("value"), strictlyEqualTo(widget.get("min")));
      widget.set("value", opt.valueAboveRange);
      return assertThat(widget.get("value"), strictlyEqualTo(widget.get("max")));
    });
    test("" + opt.className + " value should be constrained by step", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("step", opt.setStep);
      widget.set("value", opt.valueNotInStep);
      return assertThat(widget.get("value"), strictlyEqualTo(opt.snappedValue));
    });
    test("" + opt.className + " min property should be snapped on the step", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("step", opt.setStep);
      widget.set("min", opt.valueNotInStep);
      return assertThat(widget.get("min"), strictlyEqualTo(opt.snappedValue));
    });
    test("" + opt.className + " max property should be snapped on the step", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("step", opt.setStep);
      widget.set("max", opt.valueNotInStep);
      return assertThat(widget.get("max"), strictlyEqualTo(opt.snappedValue));
    });
    test("Changing widget's min property should correct the value if it goes out of the range", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("value", opt.minValue);
      widget.set("min", opt.setMinValue);
      return assertThat(widget.get("value"), strictlyEqualTo(widget.get("min")));
    });
    test("Changing widget's max property should correct the value if it goes out of the range", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("value", opt.maxValue);
      widget.set("max", opt.setMaxValue);
      return assertThat(widget.get("value"), strictlyEqualTo(widget.get("max")));
    });
    test("Changing widget's step property should correct the value if it doesn't snap anymore", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("value", opt.valueNotInStep);
      widget.set("step", opt.setStep);
      return assertThat(widget.get("value"), strictlyEqualTo(opt.snappedValue));
    });
    test("Setting a min value greater than the max value shouldn't be allowed", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("min", opt.invalidMinValue);
      return assertThat(widget.get("min"), strictlyEqualTo(opt.minValue));
    });
    test("Setting a max value lower than the min value shouldn't be allowed", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("max", opt.invalidMaxValue);
      return assertThat(widget.get("max"), strictlyEqualTo(opt.maxValue));
    });
    test("" + opt.className + " should allow to increment the value through a function", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.increment();
      return assertThat(widget.get("value"), equalTo(opt.singleIncrementValue));
    });
    test("" + opt.className + " should allow to decrement the value through a function", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.decrement();
      return assertThat(widget.get("value"), equalTo(opt.singleDecrementValue));
    });
    test("" + opt.className + " initial range data should be taken from the target if provided", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      assertThat(widget.get("min"), strictlyEqualTo(opt.minValue));
      assertThat(widget.get("max"), strictlyEqualTo(opt.maxValue));
      return assertThat(widget.get("step"), strictlyEqualTo(opt.stepValue));
    });
    test("Changing the widget data should modify the target", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.set("min", opt.invalidMaxValue);
      widget.set("max", opt.invalidMinValue);
      widget.set("step", opt.setStep);
      assertThat(target.attr("min"), equalTo(opt.invalidMaxValue));
      assertThat(target.attr("max"), equalTo(opt.invalidMinValue));
      return assertThat(target.attr("step"), equalTo(opt.setStep));
    });
    return test("" + opt.className + " initial range data shouldn't be set when the target isn't specified", function() {
      var widget;
      widget = new opt.cls;
      assertThat(widget.get("min"), opt.undefinedMinValueMatcher);
      assertThat(widget.get("max"), opt.undefinedMaxValueMatcher);
      return assertThat(widget.get("step"), opt.undefinedStepValueMatcher);
    });
  };

  testRangeStepperMixinIntervalsRunning = function(opt) {
    asyncTest("" + opt.className + " should provide a way to increment the value on an interval", function() {
      var incrementCalled, incrementCalledCount, incrementCalledCountAtStop, target, widget;
      incrementCalled = false;
      incrementCalledCount = 0;
      incrementCalledCountAtStop = 0;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.increment = function() {
        incrementCalled = true;
        return incrementCalledCount++;
      };
      widget.startIncrement();
      setTimeout(function() {
        assertThat(widget.intervalId !== -1);
        assertThat(incrementCalledCount, greaterThanOrEqualTo(0));
        incrementCalledCountAtStop = incrementCalledCount;
        return widget.endIncrement();
      }, 70);
      return setTimeout(function() {
        assertThat(widget.intervalId === -1);
        assertThat(incrementCalledCount, equalTo(incrementCalledCountAtStop));
        return start();
      }, 300);
    });
    asyncTest("" + opt.className + " should provide a way to decrement the value on an interval", function() {
      var decrementCalled, decrementCalledCount, decrementCalledCountAtStop, target, widget;
      decrementCalled = false;
      decrementCalledCount = 0;
      decrementCalledCountAtStop = 0;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.decrement = function() {
        var incrementdecrementalled;
        incrementdecrementalled = true;
        return decrementCalledCount++;
      };
      widget.startDecrement();
      setTimeout(function() {
        assertThat(widget.intervalId !== -1);
        assertThat(decrementCalledCount, greaterThanOrEqualTo(0));
        decrementCalledCountAtStop = decrementCalledCount;
        return widget.endDecrement();
      }, 70);
      return setTimeout(function() {
        assertThat(widget.intervalId === -1);
        assertThat(decrementCalledCount, equalTo(decrementCalledCountAtStop));
        return start();
      }, 300);
    });
    asyncTest("" + opt.className + " shouldn't start several interval when startIncrement is called many times", function() {
      var incrementCalledCount, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      incrementCalledCount = 0;
      widget.increment = function() {
        return incrementCalledCount++;
      };
      widget.startIncrement();
      widget.startIncrement();
      widget.startIncrement();
      widget.startIncrement();
      return setTimeout(function() {
        assertThat(incrementCalledCount, lowerThanOrEqualTo(2));
        widget.endIncrement();
        return start();
      }, 70);
    });
    return asyncTest("" + opt.className + " shouldn't start several interval when startDecrement is called many times", function() {
      var decrementCalledCount, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      decrementCalledCount = 0;
      widget.decrement = function() {
        return decrementCalledCount++;
      };
      widget.startDecrement();
      widget.startDecrement();
      widget.startDecrement();
      widget.startDecrement();
      return setTimeout(function() {
        assertThat(decrementCalledCount, lowerThanOrEqualTo(2));
        widget.endIncrement();
        return start();
      }, 100);
    });
  };

  testRangeStepperMixinKeyboardBehavior = function(opt) {
    asyncTest("When the " + opt.key + " key is pressed the widget should " + opt.action + " the value", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      widget.grabFocus();
      widget.keydown({
        keyCode: keys[opt.key],
        ctrlKey: false,
        shiftKey: false,
        altKey: false
      });
      return setTimeout(function() {
        assertThat(widget.get("value"), opt.valueMatcher);
        return start();
      }, 70);
    });
    asyncTest("Receiving several keydown of the " + opt.key + " key shouldn't trigger several " + opt.action, function() {
      var e, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      e = {
        keyCode: keys[opt.key],
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
        assertThat(widget.get("value"), opt.valueMatcher);
        return start();
      }, 70);
    });
    asyncTest("When the " + opt.key + " key is released the widget should stop " + opt.action + " the value", function() {
      var e, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      e = {
        keyCode: keys[opt.key],
        ctrlKey: false,
        shiftKey: false,
        altKey: false
      };
      widget.grabFocus();
      widget.keydown(e);
      setTimeout(function() {
        return widget.keyup(e);
      }, 70);
      return setTimeout(function() {
        assertThat(widget.get("value"), opt.valueMatcher);
        return start();
      }, 200);
    });
    asyncTest("Stopping the " + opt.action + " on keyup should allow to start a new one", function() {
      var e, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      e = {
        keyCode: keys[opt.key],
        ctrlKey: false,
        shiftKey: false,
        altKey: false
      };
      widget.grabFocus();
      widget.keydown(e);
      widget.keyup(e);
      widget.keydown(e);
      return setTimeout(function() {
        assertThat(widget.get("value"), opt.valueMatcher);
        return start();
      }, 70);
    });
    asyncTest("Trying to " + opt.action + " a readonly widget shouldn't work", function() {
      var e, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      e = {
        keyCode: keys[opt.key],
        ctrlKey: false,
        shiftKey: false,
        altKey: false
      };
      widget.set("readonly", true);
      widget.grabFocus();
      widget.keydown(e);
      return setTimeout(function() {
        assertThat(widget.get("value"), opt.initialValueMatcher);
        return start();
      }, 100);
    });
    return asyncTest("Trying to " + opt.action + " a disabled widget shouldn't work", function() {
      var e, target, widget;
      target = $(opt.defaultTarget);
      widget = new opt.cls(target[0]);
      e = {
        keyCode: keys[opt.key],
        ctrlKey: false,
        shiftKey: false,
        altKey: false
      };
      widget.set("disabled", true);
      widget.grabFocus();
      widget.keydown(e);
      return setTimeout(function() {
        assertThat(widget.get("value"), opt.initialValueMatcher);
        return start();
      }, 100);
    });
  };

  testRangeStepperMixinMouseWheelBehavior = function(opt) {
    var MockStepper;
    MockStepper = (function(_super) {

      __extends(MockStepper, _super);

      function MockStepper() {
        MockStepper.__super__.constructor.apply(this, arguments);
      }

      MockStepper.prototype.mousewheel = function(e, d) {
        d = 1;
        return MockStepper.__super__.mousewheel.call(this, e, d);
      };

      return MockStepper;

    })(opt.cls);
    test("Using the mousewheel over a widget should change the value according to the step", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new MockStepper(target[0]);
      widget.dummy.mousewheel();
      return assertThat(widget.get("value"), strictlyEqualTo(opt.singleIncrementValue));
    });
    test("Using the mousewheel over a readonly widget shouldn't change the value", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new MockStepper(target[0]);
      widget.set("readonly", true);
      widget.dummy.mousewheel();
      return assertThat(widget.get("value"), strictlyEqualTo(opt.initialValue));
    });
    return test("Using the mousewheel over a disabled widget shouldn't change the value", function() {
      var target, widget;
      target = $(opt.defaultTarget);
      widget = new MockStepper(target[0]);
      widget.set("disabled", true);
      widget.dummy.mousewheel();
      return assertThat(widget.get("value"), strictlyEqualTo(opt.initialValue));
    });
  };

  testFocusProvidedByChildMixinBegavior = function(opt) {
    test("" + opt.className + " shouldn't take focus, instead it should give it to its value input", function() {
      var focusPlacedOnTheInput, widget;
      focusPlacedOnTheInput = false;
      widget = new opt.cls;
      widget.dummy.find(opt.focusChildSelector).focus(function() {
        return focusPlacedOnTheInput = true;
      });
      widget.grabFocus();
      assertThat(focusPlacedOnTheInput);
      assertThat(widget.dummy.attr("tabindex"), nullValue());
      return assertThat(widget.hasFocus);
    });
    test("Clicking on a " + opt.className + " should give him the focus", function() {
      var widget;
      widget = new opt.cls;
      widget.dummy.mouseup();
      return assertThat(widget.hasFocus);
    });
    test("Clicking on a disabled " + opt.className + " shouldn't give him the focus", function() {
      var widget;
      widget = new opt.cls;
      widget.set("disabled", true);
      widget.dummy.mouseup();
      return assertThat(!widget.hasFocus);
    });
    return test("" + opt.className + "'s input should reflect the state of the widget", function() {
      var widget;
      widget = new opt.cls;
      widget.set("readonly", true);
      widget.set("disabled", true);
      assertThat(widget.dummy.find(opt.focusChildSelector).attr("readonly"), notNullValue());
      return assertThat(widget.dummy.find(opt.focusChildSelector).attr("disabled"), notNullValue());
    });
  };

  if (typeof window !== "undefined" && window !== null) {
    window.testRangeStepperMixinBehavior = testRangeStepperMixinBehavior;
    window.testRangeStepperMixinKeyboardBehavior = testRangeStepperMixinKeyboardBehavior;
    window.testRangeStepperMixinMouseWheelBehavior = testRangeStepperMixinMouseWheelBehavior;
    window.testRangeStepperMixinIntervalsRunning = testRangeStepperMixinIntervalsRunning;
    window.testFocusProvidedByChildMixinBegavior = testFocusProvidedByChildMixinBegavior;
  }

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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.targetChange = function(e) {
        return targetChangeCalled = true;
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        createDummyWasCalled = true;
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.set("disabled", true);
    assertThat(widget.dummy.hasClass("disabled"));
    widget.set("readonly", true);
    return assertThat(widget.dummy.hasClass("readonly"));
  });

  test("Widget's states should have the same order whatever the call order is", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    return assertThat(widget.dummy.attr("tabindex"), notNullValue());
  });

  test("Widgets should receive focus related events from its dummy", function() {
    var MockWidget, blurReceived, focusReceived, widget;
    focusReceived = false;
    blurReceived = false;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget();
    widget.dummy.focus();
    return assertThat(widget.hasFocus);
  });

  test("Widgets should be able to know when it lose focus", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget();
    widget.dummy.focus();
    widget.dummy.blur();
    return assertThat(!widget.hasFocus);
  });

  test("Widgets dummy should reflect the focus state in its class attribute", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget();
    widget.dummy.focus();
    return assertThat(widget.dummy.hasClass("focus"));
  });

  test("Widgets dummy should reflect the lost focus state in its class attribute", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget();
    widget.dummy.focus();
    widget.dummy.blur();
    return assertThat(!widget.dummy.hasClass("focus"));
  });

  test("Widgets should preserve the initial class value of the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    return assertThat(widget.dummy.attr("class"), equalTo("foo"));
  });

  test("Widgets should preserve the initial class value of the dummy even with state class", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
    widget = new MockWidget;
    widget.grabFocus();
    return assertThat(focusReceived);
  });

  test("Widgets should be able to release the focus", function() {
    var MockWidget, blurReceived, focusReceived, widget;
    focusReceived = false;
    blurReceived = false;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

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

    })(Widget);
    widget = new MockWidget;
    widget.grabFocus();
    assertThat(focusReceived);
    widget.releaseFocus();
    return assertThat(blurReceived);
  });

  test("Disabled widgets shouldn't allow focus", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.set("disabled", true);
    assertThat(widget.focus(), equalTo(false));
    return assertThat(widget.dummy.attr("tabindex"), nullValue());
  });

  test("Widget's properties getters and setters should be overridable in children classes", function() {
    var MockWidget, setterCalled, widget;
    setterCalled = false;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.set_value = function(property, value) {
        return setterCalled = true;
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.set("value", "foo");
    return assertThat(setterCalled);
  });

  test("Widget's custom properties should be overridable in children classes", function() {
    var MockWidgetA, MockWidgetB, setterCalled, widget;
    setterCalled = false;
    MockWidgetA = (function(_super) {

      __extends(MockWidgetA, _super);

      function MockWidgetA(target) {
        MockWidgetA.__super__.constructor.call(this, target);
        this.createProperty("foo", "bar");
      }

      MockWidgetA.prototype.set_foo = function(property, value) {
        return this.properties[property] = value;
      };

      return MockWidgetA;

    })(Widget);
    MockWidgetB = (function(_super) {

      __extends(MockWidgetB, _super);

      function MockWidgetB() {
        MockWidgetB.__super__.constructor.apply(this, arguments);
      }

      MockWidgetB.prototype.set_foo = function(property, value) {
        setterCalled = true;
        return MockWidgetB.__super__.set_foo.call(this, property, value);
      };

      return MockWidgetB;

    })(MockWidgetA);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.addClasses("bar", "owl");
    assertThat(widget.dummy.attr("class"), contains("bar"));
    return assertThat(widget.dummy.attr("class"), contains("owl"));
  });

  test("Widgets should provides a way to remove a class from its dummy", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo bar owl'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.removeClasses("bar", "owl");
    assertThat(widget.dummy.attr("class"), hamcrest.not(contains("bar")));
    return assertThat(widget.dummy.attr("class"), hamcrest.not(contains("owl")));
  });

  test("Widgets should provide an id property that is mapped to the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo' id='hola'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    assertThat(widget.dummy.attr("id"), equalTo("hola"));
    widget.set("id", "foo");
    return assertThat(widget.dummy.attr("id"), equalTo("foo"));
  });

  test("Setting a null id should remove the attribute from the dummy", function() {
    var MockWidget, widget;
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget;
    widget.set("id", "foo");
    widget.set("id", null);
    return assertThat(widget.dummy.attr("id"), equalTo(void 0));
  });

  test("When a widget's target have an id, the widget's dummy should have an id derived from it", function() {
    var MockWidget, target, widget;
    target = $("<input type='text' id='someid'></input>")[0];
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget(target);
    return assertThat(widget.get("id"), equalTo("someid-widget"));
  });

  test("Widgets should mark their target with a specific class", function() {
    var target, widget;
    target = $("<input type='text'></input>");
    widget = new Widget(target[0]);
    return assertThat(target.hasClass("widget-done"));
  });

  test("Widget's should provide a required property mapped on the input attribute", function() {
    var target, widgetWithTarget, widgetWithoutTarget;
    target = $("<input type='text' required></input>")[0];
    widgetWithTarget = new Widget(target);
    widgetWithoutTarget = new Widget;
    assertThat(widgetWithTarget.get("required"), equalTo(true));
    return assertThat(widgetWithoutTarget.get("required"), equalTo(void 0));
  });

  test("Setting the readonly attribute should update the target", function() {
    var target, widget;
    target = $("<input type='text'></input>")[0];
    widget = new Widget(target);
    widget.set("required", true);
    assertThat(widget.get("required"), equalTo(true));
    assertThat(widget.jTarget.attr("required"), equalTo("required"));
    widget.set("required", false);
    assertThat(widget.get("required"), equalTo(false));
    return assertThat(widget.jTarget.attr("required"), equalTo(void 0));
  });

  test("The required state should be reflected on the dummy's class attribute", function() {
    var MockWidget, target, widget;
    target = $("<input type='text' required></input>")[0];
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<span class='foo'></span>");
      };

      return MockWidget;

    })(Widget);
    widget = new MockWidget(target);
    return assertThat(widget.dummy.hasClass("required"));
  });

  MockWidget = (function(_super) {

    __extends(MockWidget, _super);

    function MockWidget() {
      MockWidget.__super__.constructor.apply(this, arguments);
    }

    MockWidget.prototype.createDummy = function() {
      return $("<span></span>");
    };

    return MockWidget;

  })(Widget);

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
    MockContainer = (function(_super) {

      __extends(MockContainer, _super);

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

    })(Container);
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

  opt = {
    cls: TextInput,
    className: "TextInput",
    focusChildSelector: "input"
  };

  testFocusProvidedByChildMixinBegavior(opt);

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

  test("TextArea should know when its content had changed and the change events isn't triggered already", function() {
    var area;
    area = new TextArea;
    area.dummy.children("textarea").trigger("input");
    return assertThat(area.valueIsObsolete);
  });

  opt = {
    cls: TextArea,
    className: "TextArea",
    focusChildSelector: "textarea"
  };

  testFocusProvidedByChildMixinBegavior(opt);

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
    checkbox.set("required", true);
    checkbox.set("disabled", true);
    checkbox.set("readonly", true);
    assertThat(checkbox.dummy.hasClass("checked"));
    assertThat(checkbox.dummy.hasClass("required"));
    assertThat(checkbox.dummy.hasClass("disabled"));
    return assertThat(checkbox.dummy.hasClass("readonly"));
  });

  test("All dummy's states provided by the parent class should be available as well on CheckBox", function() {
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
    MockCheckBox = (function(_super) {

      __extends(MockCheckBox, _super);

      function MockCheckBox() {
        MockCheckBox.__super__.constructor.apply(this, arguments);
      }

      MockCheckBox.prototype.focus = function(e) {
        return focusReveiced = true;
      };

      return MockCheckBox;

    })(CheckBox);
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
    MockRadio = (function(_super) {

      __extends(MockRadio, _super);

      function MockRadio() {
        MockRadio.__super__.constructor.apply(this, arguments);
      }

      MockRadio.prototype.focus = function(e) {
        return focusReveiced = true;
      };

      return MockRadio;

    })(Radio);
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
    MockRadioGroup = (function(_super) {

      __extends(MockRadioGroup, _super);

      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }

      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };

      return MockRadioGroup;

    })(RadioGroup);
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
    MockRadioGroup = (function(_super) {

      __extends(MockRadioGroup, _super);

      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }

      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };

      return MockRadioGroup;

    })(RadioGroup);
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
    MockRadioGroup = (function(_super) {

      __extends(MockRadioGroup, _super);

      function MockRadioGroup() {
        MockRadioGroup.__super__.constructor.apply(this, arguments);
      }

      MockRadioGroup.prototype.radioCheckedChanged = function(radio, checked) {
        return signalCalled = true;
      };

      return MockRadioGroup;

    })(RadioGroup);
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

  test("NumericWidget should hide their target", function() {
    var widget;
    target = $("<input type='range' value='10' min='0' max='50' step='1'></input>");
    widget = new NumericWidget(target[0]);
    return assertThat(target.attr("style"), contains("display: none"));
  });

  test("Concret numeric widgets class should receive an updateDummy call when value change", function() {
    var MockNumericWidget, updateDummyCalled, widget;
    updateDummyCalled = false;
    MockNumericWidget = (function(_super) {

      __extends(MockNumericWidget, _super);

      function MockNumericWidget() {
        MockNumericWidget.__super__.constructor.apply(this, arguments);
      }

      MockNumericWidget.prototype.updateDummy = function(value, min, max) {
        return updateDummyCalled = true;
      };

      return MockNumericWidget;

    })(NumericWidget);
    widget = new MockNumericWidget;
    widget.set("value", 20);
    return assertThat(updateDummyCalled);
  });

  testRangeStepperMixinBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    initialValue: 10,
    valueBelowRange: -10,
    valueAboveRange: 110,
    minValue: 0,
    setMinValue: 50,
    invalidMinValue: 110,
    maxValue: 100,
    setMaxValue: 5,
    invalidMaxValue: -10,
    stepValue: 5,
    setStep: 3,
    valueNotInStep: 10,
    snappedValue: 9,
    singleIncrementValue: 15,
    singleDecrementValue: 5,
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
  });

  testRangeStepperMixinIntervalsRunning({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>"
  });

  testRangeStepperMixinKeyboardBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    key: "up",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  });

  testRangeStepperMixinKeyboardBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    key: "down",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  });

  testRangeStepperMixinKeyboardBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    key: "right",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  });

  testRangeStepperMixinKeyboardBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    key: "left",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  });

  testRangeStepperMixinMouseWheelBehavior({
    cls: NumericWidget,
    className: "NumericWidget",
    defaultTarget: "<input min='0' max='100' step='5' value='10'>",
    initialValue: 10,
    singleIncrementValue: 15
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

  opt = {
    cls: Slider,
    className: "Slider",
    defaultTarget: "<input type='range' min='0' max='100' step='5' value='10'>",
    initialValue: 10,
    valueBelowRange: -10,
    valueAboveRange: 110,
    minValue: 0,
    setMinValue: 50,
    invalidMinValue: 110,
    maxValue: 100,
    setMaxValue: 5,
    invalidMaxValue: -10,
    stepValue: 5,
    setStep: 3,
    valueNotInStep: 10,
    snappedValue: 9,
    singleIncrementValue: 15,
    singleDecrementValue: 5,
    undefinedMinValueMatcher: equalTo(0),
    undefinedMaxValueMatcher: equalTo(100),
    undefinedStepValueMatcher: equalTo(1)
  };

  testRangeStepperMixinBehavior(opt);

  testRangeStepperMixinIntervalsRunning(opt);

  a = {
    key: "up",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "down",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "right",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "left",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  testRangeStepperMixinMouseWheelBehavior(opt);

  test("Pressing the mouse over the track should change the value, grab the focus and start a knob drag", function() {
    var MockSlider, slider;
    MockSlider = (function(_super) {

      __extends(MockSlider, _super);

      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }

      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };

      return MockSlider;

    })(Slider);
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
    MockSlider = (function(_super) {

      __extends(MockSlider, _super);

      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }

      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };

      return MockSlider;

    })(Slider);
    slider = new MockSlider;
    slider.set("disabled", true);
    slider.dummy.width(100);
    slider.dummy.children(".track").mousedown();
    assertThat(slider.get("value"), equalTo(0));
    return assertThat(!slider.draggingKnob);
  });

  test("Pressing the mouse over a readonly track shouldn't change the value ", function() {
    var MockSlider, slider;
    MockSlider = (function(_super) {

      __extends(MockSlider, _super);

      function MockSlider() {
        MockSlider.__super__.constructor.apply(this, arguments);
      }

      MockSlider.prototype.handleTrackMouseDown = function(e) {
        e.pageX = 10;
        return MockSlider.__super__.handleTrackMouseDown.call(this, e);
      };

      return MockSlider;

    })(Slider);
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

  opt = {
    cls: Stepper,
    className: "Stepper",
    defaultTarget: "<input type='number' min='0' max='100' step='5' value='10'>",
    focusChildSelector: "input",
    initialValue: 10,
    valueBelowRange: -10,
    valueAboveRange: 110,
    minValue: 0,
    setMinValue: 50,
    invalidMinValue: 110,
    maxValue: 100,
    setMaxValue: 5,
    invalidMaxValue: -10,
    stepValue: 5,
    setStep: 3,
    valueNotInStep: 10,
    snappedValue: 9,
    singleIncrementValue: 15,
    singleDecrementValue: 5,
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: equalTo(1)
  };

  testRangeStepperMixinBehavior(opt);

  testRangeStepperMixinIntervalsRunning(opt);

  a = {
    key: "up",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "down",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "right",
    action: "increment",
    valueMatcher: closeTo(15, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  a = {
    key: "left",
    action: "decrement",
    valueMatcher: closeTo(5, 1),
    initialValueMatcher: equalTo(10)
  };

  testRangeStepperMixinKeyboardBehavior(__extends(opt, a));

  testRangeStepperMixinMouseWheelBehavior(opt);

  testFocusProvidedByChildMixinBegavior(opt);

  test("Stepper's input value should be the stepper value", function() {
    var stepper;
    stepper = new Stepper;
    return assertThat(stepper.dummy.children(".value").val(), equalTo("0"));
  });

  test("Stepper's input value should be the stepper value after a change", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 20);
    return assertThat(stepper.dummy.children(".value").val(), equalTo("20"));
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
    return assertThat(stepper.dummy.children(".value").val(), strictlyEqualTo("0"));
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

  asyncTest("Releasing the mouse outside of the minus button should stop the decrement interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.dummy.children(".down").mousedown();
    setTimeout(function() {
      return $(document).mouseup();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      assertThat(!stepper.mousePressed);
      return start();
    }, 200);
  });

  asyncTest("Moving the mouse out of the minus button should stop the decrement interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.dummy.children(".down").mousedown();
    setTimeout(function() {
      return stepper.dummy.children(".down").mouseout();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(8, 1));
      return start();
    }, 200);
  });

  asyncTest("Moving the mouse back to the minus button should restart the decrement interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.set("value", 10);
    stepper.dummy.children(".down").mousedown();
    setTimeout(function() {
      stepper.dummy.children(".down").mouseout();
      return stepper.dummy.children(".down").mouseover();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(6, 2));
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

  asyncTest("Releasing the mouse outside of the plus button should stop the increment interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".up").mousedown();
    setTimeout(function() {
      return $(document).mouseup();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      assertThat(!stepper.mousePressed);
      return start();
    }, 200);
  });

  asyncTest("Moving the mouse out of the plus button should stop the increment interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".up").mousedown();
    setTimeout(function() {
      return stepper.dummy.children(".up").mouseout();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(2, 1));
      return start();
    }, 200);
  });

  asyncTest("Moving the mouse back to the plus button should restart the increment interval", function() {
    var stepper;
    stepper = new Stepper;
    stepper.dummy.children(".up").mousedown();
    setTimeout(function() {
      stepper.dummy.children(".up").mouseout();
      return stepper.dummy.children(".up").mouseover();
    }, 100);
    return setTimeout(function() {
      assertThat(stepper.get("value"), closeTo(4, 2));
      return start();
    }, 200);
  });

  test("Pressing the mouse over the stepper and moving it to the up should increment the value until the mouse is released", function() {
    var MockStepper, stepper;
    MockStepper = (function(_super) {

      __extends(MockStepper, _super);

      function MockStepper() {
        MockStepper.__super__.constructor.apply(this, arguments);
      }

      MockStepper.prototype.mousedown = function(e) {
        e.pageY = 5;
        return MockStepper.__super__.mousedown.call(this, e);
      };

      MockStepper.prototype.mousemove = function(e) {
        e.pageY = 0;
        return MockStepper.__super__.mousemove.call(this, e);
      };

      return MockStepper;

    })(Stepper);
    stepper = new MockStepper;
    stepper.dummy.mousedown();
    $(document).mousemove();
    $(document).mouseup();
    assertThat(stepper.get("value"), closeTo(5, 1));
    return assertThat(!stepper.dragging);
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
    MockFilePicker = (function(_super) {

      __extends(MockFilePicker, _super);

      function MockFilePicker() {
        MockFilePicker.__super__.constructor.apply(this, arguments);
      }

      MockFilePicker.prototype.targetChange = function(e) {
        return targetChangeWasCalled = true;
      };

      return MockFilePicker;

    })(FilePicker);
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

  opt = {
    cls: FilePicker,
    className: "FilePicker",
    focusChildSelector: "input"
  };

  testFocusProvidedByChildMixinBegavior(opt);

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
    MockSingleSelect = (function(_super) {

      __extends(MockSingleSelect, _super);

      function MockSingleSelect() {
        MockSingleSelect.__super__.constructor.apply(this, arguments);
      }

      MockSingleSelect.prototype.documentMouseDown = function(e) {
        e.pageX = 1000;
        e.pageY = 1000;
        return MockSingleSelect.__super__.documentMouseDown.call(this, e);
      };

      return MockSingleSelect;

    })(SingleSelect);
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

  test("Empty SingleSelect should display a default placeholder", function() {
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

  test("SingleSelect with the default model should display the default placeholder", function() {
    var select;
    select = new SingleSelect;
    return assertThat(select.dummy.find(".value").text(), equalTo("Empty"));
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

  module("colorinput tests");

  test("A color input should accept a target input with type color", function() {
    var input;
    target = $("<input type='color'></input>")[0];
    input = new ColorInput(target);
    return assertThat(input.target === target);
  });

  test("A color input should hide its target", function() {
    var input;
    target = $("<input type='color'></input>")[0];
    input = new ColorInput(target);
    return assertThat(input.jTarget.attr("style"), contains("display: none"));
  });

  test("A color input shouldn't accept a target input with a type different than color", function() {
    var errorRaised, input;
    target = $("<input type='text'></input>")[0];
    errorRaised = false;
    try {
      input = new ColorInput(target);
    } catch (e) {
      errorRaised = true;
    }
    return assertThat(errorRaised);
  });

  test("A color input should retreive the color from its target", function() {
    var input;
    target = $("<input type='color' value='#ff0000'></input>")[0];
    input = new ColorInput(target);
    return assertThat(input.get("value"), equalTo("#ff0000"));
  });

  test("A color input should have a default color even without target", function() {
    var input;
    input = new ColorInput;
    return assertThat(input.get("value"), equalTo("#000000"));
  });

  test("A color input should provide a color property that provide a more code friendly color object", function() {
    var color, input;
    input = new ColorInput;
    color = input.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0,
      green: 0,
      blue: 0
    })));
  });

  test("A color input color should reflect the initial value", function() {
    var color, input;
    target = $("<input type='color' value='#abcdef'></input>")[0];
    input = new ColorInput(target);
    color = input.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    })));
  });

  test("A color input should update the value when the color is changed", function() {
    var input;
    input = new ColorInput;
    input.set("color", {
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    });
    return assertThat(input.get("value"), equalTo("#abcdef"));
  });

  test("A color input should preserve the length of the value even with black", function() {
    var input;
    input = new ColorInput;
    input.set("color", {
      red: 0,
      green: 0,
      blue: 0
    });
    return assertThat(input.get("value"), equalTo("#000000"));
  });

  test("A color input should update its color property when the value is changed", function() {
    var color, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    color = input.get("color");
    return assertThat(color, allOf(notNullValue(), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    })));
  });

  test("A color input should prevent invalid values to alter its properties", function() {
    var input;
    target = $("<input type='color' value='#foobar'></input>")[0];
    input = new ColorInput(target);
    input.set("value", "foo");
    input.set("value", "#ghijkl");
    input.set("value", "#abc");
    input.set("value", void 0);
    assertThat(input.get("value"), equalTo("#000000"));
    return assertThat(input.get("color"), hasProperties({
      red: 0,
      green: 0,
      blue: 0
    }));
  });

  test("A color input should prevent invalid color to alter its properties", function() {
    var input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    input.set("color", null);
    input.set("color", {
      red: NaN,
      green: 0,
      blue: 0
    });
    input.set("color", {
      red: 0,
      green: -1,
      blue: 0
    });
    input.set("color", {
      red: 0,
      green: 0,
      blue: "foo"
    });
    input.set("color", {
      red: 0,
      green: 0,
      blue: 300
    });
    assertThat(input.get("value"), equalTo("#abcdef"));
    return assertThat(input.get("color"), hasProperties({
      red: 0xab,
      green: 0xcd,
      blue: 0xef
    }));
  });

  test("A color input should provide a dummy", function() {
    var input;
    input = new ColorInput;
    return assertThat(input.dummy, notNullValue());
  });

  test("The color span of a color input should have its background filled with the widget's value", function() {
    var input;
    target = $("<input type='color' value='#abcdef'></input>")[0];
    input = new ColorInput(target);
    return assertThat(input.dummy.children(".color").attr("style"), contains("background: #abcdef"));
  });

  test("The color span of a color input should have its background filled with the widget's value even after a change", function() {
    var input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    return assertThat(input.dummy.children(".color").attr("style"), contains("background: #abcdef"));
  });

  test("Clicking on a color input should trigger a dialogRequested signal", function() {
    var input, signalCalled, signalSource;
    signalCalled = false;
    signalSource = null;
    input = new ColorInput;
    input.dialogRequested.add(function(widget) {
      signalCalled = true;
      return signalSource = widget;
    });
    input.dummy.click();
    assertThat(signalCalled);
    return assertThat(signalSource === input);
  });

  test("The color child text should be the value hexadecimal code", function() {
    var input;
    input = new ColorInput;
    return assertThat(input.dummy.children(".color").text(), equalTo("#000000"));
  });

  test("The color child text color should be defined according the luminosity of the color", function() {
    var input;
    input = new ColorInput;
    assertThat(input.dummy.children(".color").attr("style"), contains("color: #ffffff"));
    input.set("value", "#ffffff");
    return assertThat(input.dummy.children(".color").attr("style"), contains("color: #000000"));
  });

  test("The ColorWidget's class should have a default listener defined for the dialogRequested signal of its instance", function() {
    return assertThat(ColorInput.defaultListener instanceof ColorPicker);
  });

  test("Disabled ColorInput should trigger the dialogRequested on click", function() {
    var input, signalCalled;
    signalCalled = false;
    input = new ColorInput;
    input.dialogRequested.add(function() {
      return signalCalled = true;
    });
    input.set("disabled", true);
    input.dummy.click();
    return assertThat(!signalCalled);
  });

  test("Readonly ColorInput should trigger the dialogRequested on click", function() {
    var input, signalCalled;
    signalCalled = false;
    input = new ColorInput;
    input.dialogRequested.add(function() {
      return signalCalled = true;
    });
    input.set("readonly", true);
    input.dummy.click();
    return assertThat(!signalCalled);
  });

  test("Pressing Enter should dispatch the dialogRequested signal", function() {
    var input, signalCalled;
    signalCalled = false;
    input = new ColorInput;
    input.dialogRequested.add(function() {
      return signalCalled = true;
    });
    input.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(signalCalled);
  });

  test("Pressing Space should dispatch the dialogRequested signal", function() {
    var input, signalCalled;
    signalCalled = false;
    input = new ColorInput;
    input.dialogRequested.add(function() {
      return signalCalled = true;
    });
    input.keydown({
      keyCode: keys.space,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(signalCalled);
  });

  input1 = new ColorInput;

  input2 = new ColorInput;

  input3 = new ColorInput;

  input1.set("value", "#cbdc1b");

  input2.set("value", "#66ff99");

  input3.set("value", "#6699ff");

  input2.set("readonly", true);

  input3.set("disabled", true);

  $("#qunit-header").before($("<h4>ColorInput</h4>"));

  $("#qunit-header").before(input1.dummy);

  $("#qunit-header").before(input2.dummy);

  $("#qunit-header").before(input3.dummy);

  module("squareinput tests");

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
    MockSquarePicker = (function(_super) {

      __extends(MockSquarePicker, _super);

      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }

      MockSquarePicker.prototype.mousedown = function(e) {
        e.pageX = 45;
        e.pageY = 65;
        return MockSquarePicker.__super__.mousedown.call(this, e);
      };

      return MockSquarePicker;

    })(SquarePicker);
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
    MockSquarePicker = (function(_super) {

      __extends(MockSquarePicker, _super);

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

    })(SquarePicker);
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
    MockSquarePicker = (function(_super) {

      __extends(MockSquarePicker, _super);

      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }

      MockSquarePicker.prototype.mouseup = function(e) {
        e.pageX = 110;
        e.pageY = 110;
        return MockSquarePicker.__super__.mouseup.call(this, e);
      };

      return MockSquarePicker;

    })(SquarePicker);
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
    MockSquarePicker = (function(_super) {

      __extends(MockSquarePicker, _super);

      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }

      MockSquarePicker.prototype.mouseup = function(e) {
        e.pageX = -10;
        e.pageY = -10;
        return MockSquarePicker.__super__.mouseup.call(this, e);
      };

      return MockSquarePicker;

    })(SquarePicker);
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
    MockSquarePicker = (function(_super) {

      __extends(MockSquarePicker, _super);

      function MockSquarePicker() {
        MockSquarePicker.__super__.constructor.apply(this, arguments);
      }

      MockSquarePicker.prototype.mousedown = function(e) {
        return result = MockSquarePicker.__super__.mousedown.call(this, e);
      };

      return MockSquarePicker;

    })(SquarePicker);
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

  sinput1 = new SquarePicker;

  sinput2 = new SquarePicker;

  sinput3 = new SquarePicker;

  sinput4 = new SquarePicker;

  sinput1.set("value", [.2, .5]);

  sinput2.set("value", [0, .6]);

  sinput3.set("value", [.7, .2]);

  sinput4.set("value", [.8, 0]);

  sinput2.lockX();

  sinput2.dummyClass = sinput2.dummyClass + " vertical";

  sinput2.updateStates();

  sinput4.dummyClass = sinput4.dummyClass + " horizontal";

  sinput4.updateStates();

  sinput3.set("readonly", true);

  sinput4.set("disabled", true);

  $("#qunit-header").before($("<h4>SquarePicker</h4>"));

  $("#qunit-header").before(sinput1.dummy);

  $("#qunit-header").before(sinput2.dummy);

  $("#qunit-header").before(sinput3.dummy);

  $("#qunit-header").before(sinput4.dummy);

  module("colorinput tests");

  test("A ColorPicker should be hidden at startup", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });

  test("A ColorPicker should have a listener for the dialogRequested signal that setup the dialog", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    return assertThat(dialog.get("value") === "#abcdef");
  });

  test("A ColorPicker should show itself on a dialog request", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("A ColorPicker should provides a method to convert a rgb color to hsv values", function() {
    var dialog, hsv;
    dialog = new ColorPicker;
    hsv = rgb2hsv(10, 100, 200);
    return assertThat(hsv, array(closeTo(212, 2), closeTo(95, 2), closeTo(78, 2)));
  });

  test("A ColorPicker should provides a method to convert a hsv color to rgb values", function() {
    var dialog, rgb;
    dialog = new ColorPicker;
    rgb = hsv2rgb(212, 95, 78);
    return assertThat(rgb, array(closeTo(10, 2), closeTo(100, 2), closeTo(200, 2)));
  });

  test("A ColorPicker should provides a dummy", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.dummy, notNullValue());
  });

  test("A ColorPicker should provides a TextInput for each channel of the color", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.redInput instanceof TextInput);
    assertThat(dialog.greenInput instanceof TextInput);
    return assertThat(dialog.blueInput instanceof TextInput);
  });

  test("The inputs for the color channels should be limited to three chars", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.redInput.get("maxlength"), equalTo(3));
    assertThat(dialog.greenInput.get("maxlength"), equalTo(3));
    return assertThat(dialog.blueInput.get("maxlength"), equalTo(3));
  });

  test("A ColorPicker should have the channels input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.dummy.children(".red")[0], equalTo(dialog.redInput.dummy[0]));
    assertThat(dialog.dummy.children(".green")[0], equalTo(dialog.greenInput.dummy[0]));
    return assertThat(dialog.dummy.children(".blue")[0], equalTo(dialog.blueInput.dummy[0]));
  });

  test("Setting the value of a ColorPicker should fill the channels input", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    assertThat(dialog.redInput.get("value"), equalTo(0xab));
    assertThat(dialog.greenInput.get("value"), equalTo(0xcd));
    return assertThat(dialog.blueInput.get("value"), equalTo(0xef));
  });

  test("A ColorPicker should provides a TextInput for each channel of the hsv color", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.hueInput instanceof TextInput);
    assertThat(dialog.saturationInput instanceof TextInput);
    return assertThat(dialog.valueInput instanceof TextInput);
  });

  test("The inputs for the hsv channels should be limited to three chars", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.hueInput.get("maxlength"), equalTo(3));
    assertThat(dialog.saturationInput.get("maxlength"), equalTo(3));
    return assertThat(dialog.valueInput.get("maxlength"), equalTo(3));
  });

  test("A ColorPicker should have the channels input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.dummy.children(".hue")[0], equalTo(dialog.hueInput.dummy[0]));
    assertThat(dialog.dummy.children(".saturation")[0], equalTo(dialog.saturationInput.dummy[0]));
    return assertThat(dialog.dummy.children(".value")[0], equalTo(dialog.valueInput.dummy[0]));
  });

  test("Setting the value of a ColorPicker should fill the channels input", function() {
    var dialog, h, v, _ref;
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    _ref = rgb2hsv(0xab, 0xcd, 0xef), h = _ref[0], s = _ref[1], v = _ref[2];
    assertThat(dialog.hueInput.get("value"), equalTo(Math.round(h)));
    assertThat(dialog.saturationInput.get("value"), equalTo(Math.round(s)));
    return assertThat(dialog.valueInput.get("value"), equalTo(Math.round(v)));
  });

  test("A ColorPicker should provides a TextInput for the hexadecimal color", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.hexInput instanceof TextInput);
  });

  test("The hexadecimal input should be limited to 6 chars", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.hexInput.get("maxlength"), equalTo(6));
  });

  test("A ColorPicker should have the hexadecimal input as child of the dummy", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.dummy.children(".hex")[0], equalTo(dialog.hexInput.dummy[0]));
  });

  test("Setting the value of a ColorPicker should fill the hexadecimal input", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    return assertThat(dialog.hexInput.get("value"), equalTo("abcdef"));
  });

  test("Setting the value of the red input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.redInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#ff0000"));
    dialog.redInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#450000"));
  });

  test("Setting an invalid value for the red input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.redInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });

  test("Setting the value of the green input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.greenInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#00ff00"));
    dialog.greenInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#004500"));
  });

  test("Setting an invalid value for the green input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.greenInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });

  test("Setting the value of the blue input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.blueInput.set("value", 0xff);
    assertThat(dialog.get("value"), equalTo("#0000ff"));
    dialog.blueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#000045"));
  });

  test("Setting an invalid value for the blue input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.blueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#000000"));
  });

  test("Setting the value of the hue input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#332929");
    dialog.hueInput.set("value", 100);
    assertThat(dialog.get("value"), equalTo("#2c3329"));
    dialog.hueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#323329"));
  });

  test("Setting an invalid value for the hue input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#332929");
    dialog.hueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#332929"));
  });

  test("Setting the value of the saturation input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.saturationInput.set("value", 50);
    assertThat(dialog.get("value"), equalTo("#2e331a"));
    dialog.saturationInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#2c3310"));
  });

  test("Setting an invalid value for the saturation input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.saturationInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });

  test("Setting the value of the value input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.valueInput.set("value", 50);
    assertThat(dialog.get("value"), equalTo("#7b8067"));
    dialog.valueInput.set("value", "69");
    return assertThat(dialog.get("value"), equalTo("#a9b08d"));
  });

  test("Setting an invalid value for the value input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.valueInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });

  test("Setting the value of the hex input should update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.hexInput.set("value", "abcdef");
    assertThat(dialog.get("value"), equalTo("#abcdef"));
    dialog.hexInput.set("value", "012345");
    return assertThat(dialog.get("value"), equalTo("#012345"));
  });

  test("Setting an invalid value for the hex input shouldn't update the dialog's value", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#313329");
    dialog.hexInput.set("value", "foo");
    return assertThat(dialog.get("value"), equalTo("#313329"));
  });

  test("The ColorPicker should provides two grid inputs", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.squarePicker instanceof SquarePicker);
    return assertThat(dialog.rangePicker instanceof SquarePicker);
  });

  test("A ColorPicker should have a default edit mode for color manipulation through the SquarePickers", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    assertThat(dialog.squarePicker.get("rangeX"), array(0, 100));
    assertThat(dialog.squarePicker.get("rangeY"), array(0, 100));
    assertThat(dialog.rangePicker.get("rangeY"), array(0, 360));
    assertThat(dialog.squarePicker.get("value"), array(closeTo(28, 1), closeTo(100 - 94, 1)));
    return assertThat(dialog.rangePicker.get("value")[1], equalTo(360 - 210));
  });

  test("Clicking outside of the ColorPicker should terminate the modification and set the value on the ColorInput", function() {
    var MockColorPicker, dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    MockColorPicker = (function(_super) {

      __extends(MockColorPicker, _super);

      function MockColorPicker() {
        MockColorPicker.__super__.constructor.apply(this, arguments);
      }

      MockColorPicker.prototype.mouseup = function(e) {
        e.pageX = 1000;
        e.pageY = 1000;
        return MockColorPicker.__super__.mouseup.call(this, e);
      };

      return MockColorPicker;

    })(ColorPicker);
    dialog = new MockColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    $(document).mouseup();
    assertThat(input.get("value"), "#ff0000");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });

  test("Pressing enter on the ColorPicker should terminate the modification and set the value on the ColorInput", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#ff0000");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the red input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.redInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the green input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.greenInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the blue input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.blueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the hue input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.hueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the saturation input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.saturationInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the value input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.valueInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("Pressing enter on the ColorPicker while there was changes made to the hex input shouldn't comfirm the color changes", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.hexInput.input();
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), hamcrest.not(contains("display: none")));
  });

  test("A ColorPicker should be placed next to the colorinput a dialog request", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    assertThat(dialog.dummy.attr("style"), contains("left: 0px"));
    assertThat(dialog.dummy.attr("style"), contains("top: " + input.dummy.height() + "px"));
    return assertThat(dialog.dummy.attr("style"), contains("position: absolute"));
  });

  test("A ColorPicker should provides two more chidren that will be used to present the previous and current color", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    assertThat(dialog.dummy.children(".oldColor").attr("style"), contains("background: #abcdef"));
    return assertThat(dialog.dummy.children(".newColor").attr("style"), contains("background: #ff0000"));
  });

  test("Clicking on the old color should reset the value to the original one", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.dummy.children(".oldColor").click();
    return assertThat(dialog.get("value"), equalTo("#abcdef"));
  });

  test("Pressing escape on the ColorPicker should close the dialog", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.fromHex("ff0000");
    dialog.keydown({
      keyCode: keys.escape,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    assertThat(input.get("value"), "#abcdef");
    return assertThat(dialog.dummy.attr("style"), contains("display: none"));
  });

  test("ColorPicker should take focus on dialogRequested", function() {
    var dialog, input;
    input = new ColorInput;
    input.set("value", "#abcdef");
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    return assertThat(dialog.hasFocus);
  });

  test("ColorPicker should call the dispose method of the previous mode when it's changed", function() {
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
    dialog = new ColorPicker;
    dialog.set("mode", new MockMode);
    dialog.set("mode", new MockMode);
    return assertThat(disposeCalled);
  });

  test("ColorPicker should call the update method when a new set is defined", function() {
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
    dialog = new ColorPicker;
    dialog.set("mode", new MockMode);
    return assertThat(updateCalled);
  });

  test("A ColorPicker should contains a radio group to select the color modes", function() {
    var dialog;
    dialog = new ColorPicker;
    assertThat(dialog.modesGroup instanceof RadioGroup);
    return assertThat(dialog.dummy.find(".radio").length, equalTo(6));
  });

  test("A ColorPicker should provides 6 color edit modes", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.editModes, arrayWithLength(6));
  });

  test("The HSV radio should be checked at start", function() {
    var dialog;
    dialog = new ColorPicker;
    return assertThat(dialog.hueMode.get("checked"));
  });

  test("Checking a mode radio should select the mode for this dialog", function() {
    var dialog;
    dialog = new ColorPicker;
    dialog.valueMode.set("checked", true);
    return assertThat(dialog.get("mode") === dialog.editModes[5]);
  });

  test("Ending the edit should return the focus on the color input", function() {
    var dialog, input;
    input = new ColorInput;
    dialog = new ColorPicker;
    dialog.dialogRequested(input);
    dialog.keydown({
      keyCode: keys.enter,
      ctrlKey: false,
      shiftKey: false,
      altKey: false
    });
    return assertThat(input.hasFocus);
  });

  dialog = new ColorPicker;

  dialog.set("value", "#abcdef");

  dialog.addClasses("dummy");

  $("#qunit-header").before($("<h4>ColorPicker</h4>"));

  $("#qunit-header").before(dialog.dummy);

  module("hsv mode tests");

  test("The HSV mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
  });

  test("The HSV mode should set the background of the color layer of the squareinput according to the color", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    return assertThat(dialog.squarePicker.dummy.find(".hue-color").attr("style"), contains("background: #0080ff"));
  });

  test("When in HSV mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.rangePicker.set("value", [0, 260]);
    return assertThat(dialog.get("value"), equalTo("#c2efab"));
  });

  test("When in HSV mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
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
    MockHSVMode = (function(_super) {

      __extends(MockHSVMode, _super);

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
        if (this.allowSignal) return squareChangedCalled = true;
      };

      MockHSVMode.prototype.rangeChanged = function(widget, value) {
        if (this.allowSignal) return rangeChangedCalled = true;
      };

      return MockHSVMode;

    })(HSVMode);
    dialog = new ColorPicker;
    dialog.set("mode", new MockHSVMode);
    dialog.set("mode", new MockMode);
    dialog.rangePicker.set("value", [0, 0]);
    dialog.squarePicker.set("value", [0, 0]);
    assertThat(disposeCalled);
    assertThat(!squareChangedCalled);
    return assertThat(!rangeChangedCalled);
  });

  module("shv mode tests");

  test("The SHV mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
    dialog.set("mode", new SHVMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });

  test("The SHV mode should alter the opacity of the white plain span according to the color data", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#ff0000");
    dialog.set("mode", new SHVMode);
    assertThat(dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains("opacity: 1"));
  });

  test("When in SHV mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new SHVMode);
    dialog.rangePicker.set("value", [0, 90]);
    return assertThat(dialog.get("value"), equalTo("#d7e3ef"));
  });

  test("When in SHV mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new SHVMode);
    dialog.squarePicker.set("value", [200, 80]);
    assertThat(dialog.get("value"), equalTo("#24332e"));
    module("shv mode tests");
    return test("The SHV mode should creates layer in the squareinputs of its target dialog", function() {
      dialog = new ColorPicker;
      dialog.set("mode", new SHVMode);
      assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(1));
      return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(1));
    });
  });

  module("vhs mode tests");

  test("The VHS mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
    dialog.set("mode", new VHSMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });

  test("The VHS mode should alter the opacity of the black plain span according to the color data", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.set("mode", new VHSMode);
    assertThat(dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains("opacity: 1"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains("opacity: 0"));
  });

  test("When in VHS mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new VHSMode);
    dialog.rangePicker.set("value", [0, 80]);
    return assertThat(dialog.get("value"), equalTo("#242c33"));
  });

  test("When in VHS mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new VHSMode);
    dialog.squarePicker.set("value", [200, 60]);
    return assertThat(dialog.get("value"), equalTo("#8fefcf"));
  });

  module("rgb mode tests");

  test("The RGB mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
    dialog.set("mode", new RGBMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });

  test("The RGB mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.set("mode", new RGBMode);
    assertThat(dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains("opacity: 1"));
  });

  test("When in RGB mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new RGBMode);
    dialog.rangePicker.set("value", [0, 55]);
    return assertThat(dialog.get("value"), equalTo("#c8cdef"));
  });

  test("When in RGB mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new RGBMode);
    dialog.squarePicker.set("value", [100, 205]);
    return assertThat(dialog.get("value"), equalTo("#ab3264"));
  });

  module("grb mode tests");

  test("The GRB mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
    dialog.set("mode", new GRBMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });

  test("The GRB mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.set("mode", new GRBMode);
    assertThat(dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains("opacity: 1"));
  });

  test("When in GRB mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new GRBMode);
    dialog.rangePicker.set("value", [0, 55]);
    return assertThat(dialog.get("value"), equalTo("#abc8ef"));
  });

  test("When in GRB mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new GRBMode);
    dialog.squarePicker.set("value", [100, 205]);
    return assertThat(dialog.get("value"), equalTo("#32cd64"));
  });

  module("bgr mode tests");

  test("The BGR mode should creates layer in the squareinputs of its target dialog", function() {
    dialog = new ColorPicker;
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
    dialog = new ColorPicker;
    dialog.set("mode", new BGRMode);
    dialog.set("mode", new MockMode);
    assertThat(dialog.squarePicker.dummy.children(".layer").length, equalTo(0));
    return assertThat(dialog.rangePicker.dummy.children(".layer").length, equalTo(0));
  });

  test("The BGR mode should alter the opacity of the upper layer according to the color data", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#000000");
    dialog.set("mode", new BGRMode);
    assertThat(dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains("opacity: 0"));
    dialog.set("value", "#ffffff");
    return assertThat(dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains("opacity: 1"));
  });

  test("When in BGR mode, changing the value of the rangePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new BGRMode);
    dialog.rangePicker.set("value", [0, 155]);
    return assertThat(dialog.get("value"), equalTo("#abcd64"));
  });

  test("When in BGR mode, changing the value of the squarePicker should affect the dialog's value", function() {
    dialog = new ColorPicker;
    dialog.set("value", "#abcdef");
    dialog.set("mode", new BGRMode);
    dialog.squarePicker.set("value", [100, 155]);
    return assertThat(dialog.get("value"), equalTo("#6464ef"));
  });

  testGenericDateTimeFunctions = function(opt) {
    test("" + opt.validateFunctionName + " should return true", function() {
      var data, _i, _len, _ref, _results;
      _ref = opt.validData;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        data = _ref[_i];
        _results.push(assertThat(opt.validateFunction(data)));
      }
      return _results;
    });
    test("" + opt.validateFunctionName + " should return false", function() {
      var data, _i, _len, _ref, _results;
      _ref = opt.invalidData;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        data = _ref[_i];
        _results.push(assertThat(!opt.validateFunction(data)));
      }
      return _results;
    });
    test("" + opt.toStringFunctionName + " should return valid " + opt.type + " string", function() {
      var date, string, _i, _len, _ref, _ref2, _results;
      _ref = opt.toStringData;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref2 = _ref[_i], date = _ref2[0], string = _ref2[1];
        _results.push(assertThat(opt.toStringFunction(date), equalTo(string)));
      }
      return _results;
    });
    test("" + opt.fromStringFunctionName + " should return valid dates", function() {
      var date, string, _i, _len, _ref, _ref2, _results;
      _ref = opt.fromStringData;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref2 = _ref[_i], string = _ref2[0], date = _ref2[1];
        _results.push(assertThat(opt.fromStringFunction(string), dateEquals(date)));
      }
      return _results;
    });
    return test("" + opt.type + " chaining conversion should always result to the same value", function() {
      return assertThat(opt.fromStringFunction(opt.toStringFunction(opt.fromStringFunction(opt.reverseData))), dateEquals(opt.fromStringFunction(opt.reverseData)));
    });
  };

  testGenericDateWidgetBehaviors = function(opt) {
    var defaultTarget;
    test("A " + opt.className + " should allow an input with type " + opt.type + " as target", function() {
      var input;
      target = $("<input type='" + opt.type + "'></input>")[0];
      input = new opt.cls(target);
      return assertThat(input.target === target);
    });
    test("A " + opt.className + " shouldn't allow an input with a type different than " + opt.type + " as target", function() {
      var errorRaised, input;
      target = $("<input type='text'></input>")[0];
      errorRaised = false;
      try {
        input = new opt.cls(target);
      } catch (e) {
        errorRaised = true;
      }
      return assertThat(errorRaised);
    });
    test("A " + opt.className + " should allow a date object as first argument", function() {
      var d, input;
      d = opt.defaultDate;
      input = new opt.cls(d);
      return assertThat(input.get("date"), dateEquals(d));
    });
    test("When passing a Date as first argument, the value should match the date", function() {
      var d, input;
      d = opt.defaultDate;
      input = new opt.cls(d);
      return assertThat(input.get("value"), equalTo(opt.defaultValue));
    });
    test("Creating a " + opt.className + " without argument should setup a default Date", function() {
      var d, input;
      d = new Date;
      input = new opt.cls;
      return assertThat(input.get("value"), equalTo(input.dateToValue(input.snapToStep(d))));
    });
    test("A " + opt.className + " should set its date with the value of the target", function() {
      var input;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>")[0];
      input = new opt.cls(target);
      return assertThat(input.get("date"), dateEquals(opt.defaultDate));
    });
    test("Changing the date of a " + opt.className + " should change the value", function() {
      var d, input;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>")[0];
      input = new opt.cls(target);
      d = opt.setDate;
      input.set("date", d);
      return assertThat(input.get("value"), equalTo(opt.setValue));
    });
    test("Changing the value of a " + opt.className + " should change the date", function() {
      var d, input;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>")[0];
      input = new opt.cls(target);
      d = opt.setDate;
      input.set("value", opt.setValue);
      return assertThat(input.get("date"), dateEquals(d));
    });
    test("" + opt.className + " should prevent invalid values to affect it", function() {
      var input, invalidValue, _i, _len, _ref;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>")[0];
      input = new opt.cls(target);
      _ref = opt.invalidValues;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        invalidValue = _ref[_i];
        input.set("value", invalidValue);
      }
      return assertThat(input.get("value"), equalTo(opt.defaultValue));
    });
    test("" + opt.className + " should prevent invalid dates to affect it", function() {
      var input, invalidDate, _i, _len, _ref;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>")[0];
      input = new opt.cls(target);
      _ref = opt.invalidDates;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        invalidDate = _ref[_i];
        input.set("date", invalidDate);
      }
      return assertThat(input.get("value"), equalTo(opt.defaultValue));
    });
    test("" + opt.className + " should prevent invalid values to be set in the target", function() {
      var input;
      target = $("<input type='" + opt.type + "' value='foo' min='foo' max='foo' step='foo'></input>")[0];
      input = new opt.cls(target);
      assertThat(!isNaN(input.get("date").getHours()));
      assertThat(input.get("min"), opt.undefinedMinValueMatcher);
      assertThat(input.get("max"), opt.undefinedMaxValueMatcher);
      return assertThat(input.get("step"), opt.undefinedStepValueMatcher);
    });
    test("Changing the value should change the target value as well", function() {
      var input;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>");
      input = new opt.cls(target[0]);
      input.set("value", opt.setValue);
      return assertThat(target.val(), equalTo(opt.setValue));
    });
    test("Changing the date should change the target value as well", function() {
      var input;
      target = $("<input type='" + opt.type + "' value='" + opt.defaultValue + "'></input>");
      input = new opt.cls(target[0]);
      input.set("date", opt.setDate);
      return assertThat(target.val(), equalTo(opt.setValue));
    });
    test("A " + opt.className + " should provide a dummy", function() {
      return assertThat((new opt.cls).dummy, notNullValue());
    });
    test("A " + opt.className + " dummy should have the type of the input as class", function() {
      return assertThat((new opt.cls(new Date, "" + opt.type)).dummy.hasClass("" + opt.type));
    });
    defaultTarget = "<input type='" + opt.type + "' 							value='" + opt.defaultValue + "' 							min='" + opt.minValue + "' 							max='" + opt.maxValue + "'							step='" + opt.stepValue + "'></input>";
    testRangeStepperMixinBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      initialValue: opt.defaultValue,
      valueBelowRange: opt.valueBelowRange,
      valueAboveRange: opt.valueAboveRange,
      minValue: opt.minValue,
      setMinValue: opt.setValue,
      invalidMinValue: opt.invalidMinValue,
      maxValue: opt.maxValue,
      setMaxValue: opt.setValue,
      invalidMaxValue: opt.invalidMaxValue,
      stepValue: opt.stepValue,
      setStep: opt.setStep,
      valueNotInStep: opt.valueNotInStep,
      snappedValue: opt.snappedValue,
      singleIncrementValue: opt.singleIncrementValue,
      singleDecrementValue: opt.singleDecrementValue,
      undefinedMinValueMatcher: opt.undefinedMinValueMatcher,
      undefinedMaxValueMatcher: opt.undefinedMaxValueMatcher,
      undefinedStepValueMatcher: opt.undefinedStepValueMatcher
    });
    testRangeStepperMixinIntervalsRunning({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget
    });
    testRangeStepperMixinKeyboardBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      key: "up",
      action: "increment",
      valueMatcher: opt.singleIncrementValue,
      initialValueMatcher: equalTo(opt.defaultValue)
    });
    testRangeStepperMixinKeyboardBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      key: "down",
      action: "decrement",
      valueMatcher: opt.singleDecrementValue,
      initialValueMatcher: equalTo(opt.defaultValue)
    });
    testRangeStepperMixinKeyboardBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      key: "right",
      action: "increment",
      valueMatcher: opt.singleIncrementValue,
      initialValueMatcher: equalTo(opt.defaultValue)
    });
    testRangeStepperMixinKeyboardBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      key: "left",
      action: "decrement",
      valueMatcher: opt.singleDecrementValue,
      initialValueMatcher: equalTo(opt.defaultValue)
    });
    testRangeStepperMixinMouseWheelBehavior({
      cls: opt.cls,
      className: opt.className,
      defaultTarget: defaultTarget,
      initialValue: opt.defaultValue,
      singleIncrementValue: opt.singleIncrementValue
    });
    input1 = new opt.cls(new Date, opt.type);
    input2 = new opt.cls(new Date, opt.type);
    input3 = new opt.cls(new Date, opt.type);
    input2.set("readonly", true);
    input3.set("disabled", true);
    $("#qunit-header").before($("<h4>" + opt.className + "</h4>"));
    $("#qunit-header").before(input1.dummy);
    $("#qunit-header").before(input2.dummy);
    return $("#qunit-header").before(input3.dummy);
  };

  module("time utils tests");

  testGenericDateTimeFunctions({
    type: "time",
    validateFunctionName: "isValidTime",
    validateFunction: isValidTime,
    validData: ["10", "10:10", "10:10:15", "10:10:15.765"],
    invalidData: ["", "foo", "100:01:2", "2011-16-10T", "T10:15:75", "::", null],
    toStringFunctionName: "timeToString",
    toStringFunction: timeToString,
    toStringData: [[new Date(1970, 0, 1, 10, 16, 52), "10:16:52"], [new Date(1970, 0, 1, 0, 0, 0), "00:00:00"], [new Date(1970, 0, 1, 10, 16, 52, 756), "10:16:52.756"]],
    fromStringFunctionName: "timeFromString",
    fromStringFunction: timeFromString,
    fromStringData: [["10", new Date(1970, 0, 1, 10)], ["10:16", new Date(1970, 0, 1, 10, 16)], ["00:00:00", new Date(1970, 0, 1, 0, 0, 0)], ["10:16:52", new Date(1970, 0, 1, 10, 16, 52)], ["10:16:52.756", new Date(1970, 0, 1, 10, 16, 52, 756)]],
    reverseData: "10:16:52"
  });

  module("date utils tests");

  testGenericDateTimeFunctions({
    type: "date",
    validateFunctionName: "isValidDate",
    validateFunction: isValidDate,
    validData: ["2011-12-15"],
    invalidData: ["", "foo", "200-12-20", "2000-0-0", "--", null],
    toStringFunctionName: "dateToString",
    toStringFunction: dateToString,
    toStringData: [[new Date(1970, 0, 1), "1970-01-01"], [new Date(2011, 11, 12), "2011-12-12"]],
    fromStringFunctionName: "dateFromString",
    fromStringFunction: dateFromString,
    fromStringData: [["2011-12-12", new Date(2011, 11, 12)], ["1970-01-01", new Date(1970, 0, 1)]],
    reverseData: "2011-12-12"
  });

  module("month utils tests");

  testGenericDateTimeFunctions({
    type: "month",
    validateFunctionName: "isValidMonth",
    validateFunction: isValidMonth,
    validData: ["2011-12"],
    invalidData: ["", "foo", "200-12-20", "2000-0", "--", null],
    toStringFunctionName: "monthToString",
    toStringFunction: monthToString,
    toStringData: [[new Date(1970, 0), "1970-01"], [new Date(2011, 11), "2011-12"]],
    fromStringFunctionName: "monthFromString",
    fromStringFunction: monthFromString,
    fromStringData: [["2011-12", new Date(2011, 11)], ["1970-01", new Date(1970, 0)]],
    reverseData: "2011-12"
  });

  module("week utils tests");

  testGenericDateTimeFunctions({
    type: "week",
    validateFunctionName: "isValidWeek",
    validateFunction: isValidWeek,
    validData: ["2011-W12", "1970-W07"],
    invalidData: ["", "foo", "200-W1", "20-W00", "-W", null],
    toStringFunctionName: "weekToString",
    toStringFunction: weekToString,
    toStringData: [[new Date(2012, 0, 2), "2012-W01"], [new Date(2011, 0, 3), "2011-W01"], [new Date(2011, 7, 25), "2011-W34"], [new Date(2010, 4, 11), "2010-W19"]],
    fromStringFunctionName: "weekFromString",
    fromStringFunction: weekFromString,
    fromStringData: [["2012-W01", new Date(2012, 0, 2)], ["2011-W01", new Date(2011, 0, 3)], ["2011-W34", new Date(2011, 7, 22)], ["2010-W19", new Date(2010, 4, 10)]],
    reverseData: "2011-W12"
  });

  module("datetime utils tests");

  testGenericDateTimeFunctions({
    type: "datetime",
    validateFunctionName: "isValidDateTime",
    validateFunction: isValidDateTime,
    validData: ["2011-10-10T10:45:32+01:00", "2011-10-10T10:45:32-02:00", "2011-10-10T10:45:32.786Z"],
    invalidData: ["", "foo", "2011-10-10", "10:15:75", "2011-16-10T", "T10:15:75", "-W", null],
    toStringFunctionName: "datetimeToString",
    toStringFunction: datetimeToString,
    toStringData: [[new Date(2011, 0, 1, 0, 0, 0), "2011-01-01T00:00:00+01:00"], [new Date(2012, 2, 25, 16, 44, 37), "2012-03-25T16:44:37+02:00"], [new Date(2012, 2, 25, 16, 44, 37, 756), "2012-03-25T16:44:37.756+02:00"]],
    fromStringFunctionName: "datetimeFromString",
    fromStringFunction: datetimeFromString,
    fromStringData: [["2011-01-01T00:00:00+01:00", new Date(2011, 0, 1, 0, 0, 0)], ["2012-03-25T16:44:37+02:00", new Date(2012, 2, 25, 16, 44, 37)], ["2012-03-25T16:44:37.756+02:00", new Date(2012, 2, 25, 16, 44, 37, 756)]],
    reverseData: "2012-03-25T16:44:37+02:00"
  });

  module("datetimelocal utils tests");

  testGenericDateTimeFunctions({
    type: "datetimeLocal",
    validateFunctionName: "isValidDateTimeLocal",
    validateFunction: isValidDateTimeLocal,
    validData: ["2011-10-10T10:45:32", "2011-10-10T10:45:32.786"],
    invalidData: ["", "foo", "2011-10-10", "10:15:75", "2011-16-10T", "T10:15:75", "-W", null],
    toStringFunctionName: "datetimeLocalToString",
    toStringFunction: datetimeLocalToString,
    toStringData: [[new Date(2011, 0, 1, 0, 0, 0), "2011-01-01T00:00:00"], [new Date(2012, 2, 25, 16, 44, 37), "2012-03-25T16:44:37"], [new Date(2012, 2, 25, 16, 44, 37, 756), "2012-03-25T16:44:37.756"]],
    fromStringFunctionName: "datetimeLocalFromString",
    fromStringFunction: datetimeLocalFromString,
    fromStringData: [["2011-01-01T00:00:00", new Date(2011, 0, 1, 0, 0, 0)], ["2012-03-25T16:44:37", new Date(2012, 2, 25, 16, 44, 37)], ["2012-03-25T16:44:37.756", new Date(2012, 2, 25, 16, 44, 37, 756)]],
    reverseData: "2012-03-25T16:44:37"
  });

  module("timeinput tests");

  testGenericDateWidgetBehaviors({
    className: "TimeInput",
    cls: TimeInput,
    type: "time",
    defaultDate: new Date(1970, 0, 1, 11, 56, 0),
    defaultValue: "11:56:00",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "100:00:00", "1:22:2"],
    setDate: new Date(1970, 0, 1, 16, 32, 00),
    setValue: "16:32:00",
    minDate: new Date(1970, 0, 1, 10, 0, 0),
    minValue: "10:00:00",
    valueBelowRange: "05:45:00",
    invalidMinValue: "23:45:00",
    maxDate: new Date(1970, 0, 1, 23, 0, 0),
    maxValue: "23:00:00",
    valueAboveRange: "23:45:00",
    invalidMaxValue: "05:00:00",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "10:10:54",
    snappedValue: "10:00:00",
    singleIncrementValue: "12:00:00",
    singleDecrementValue: "11:00:00",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: equalTo(60)
  });

  test("A TimeInput dummy should contains an input that contains the value", function() {
    var input, text;
    input = new TimeInput(new Date(1970, 0, 1, 16, 32, 17, 565));
    text = input.dummy.find("input");
    assertThat(text.length, equalTo(1));
    assertThat(text.val(), equalTo("16:32"));
    return assertThat(text.hasClass("widget-done"));
  });

  test("The TimeInput dummy's input should be updated on value change", function() {
    var input, text;
    input = new TimeInput(new Date(1970, 0, 1, 16, 32, 17, 565));
    input.set("value", "05:45");
    text = input.dummy.find("input");
    return assertThat(text.val(), equalTo("05:45"));
  });

  module("dateinput tests");

  testGenericDateWidgetBehaviors({
    className: "DateInput",
    cls: DateInput,
    type: "date",
    defaultDate: new Date(1981, 8, 9, 0),
    defaultValue: "1981-09-09",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "122-50-4", "1-1-+6"],
    setDate: new Date(2012, 4, 27, 0),
    setValue: "2012-05-27",
    minDate: new Date(1970, 0, 1, 0),
    minValue: "1970-01-01",
    valueBelowRange: "1960-05-23",
    invalidMinValue: "2013-05-25",
    maxDate: new Date(2012, 11, 29, 0),
    maxValue: "2012-12-29",
    valueAboveRange: "2100-05-21",
    invalidMaxValue: "1960-05-23",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "2012-05-27",
    snappedValue: "2012-05-27",
    singleIncrementValue: "1981-09-09",
    singleDecrementValue: "1981-09-08",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
  });

  module("monthinput tests");

  testGenericDateWidgetBehaviors({
    className: "MonthInput",
    cls: MonthInput,
    type: "month",
    defaultDate: new Date(1981, 8, 1, 0),
    defaultValue: "1981-09",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "122-50", "1-1-+6"],
    setDate: new Date(2012, 4, 1, 0),
    setValue: "2012-05",
    minDate: new Date(1970, 0, 1, 0),
    minValue: "1970-01",
    valueBelowRange: "1960-01",
    invalidMinValue: "2013-01",
    maxDate: new Date(2012, 11, 1, 0),
    maxValue: "2012-12",
    valueAboveRange: "2100-05",
    invalidMaxValue: "1960-01",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "2012-05",
    snappedValue: "2012-05",
    singleIncrementValue: "1981-09",
    singleDecrementValue: "1981-08",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
  });

  module("weekinput tests");

  testGenericDateWidgetBehaviors({
    className: "WeekInput",
    cls: WeekInput,
    type: "week",
    defaultDate: new Date(2012, 0, 2, 0),
    defaultValue: "2012-W01",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "122-50", "1-1-+6"],
    setDate: new Date(2011, 7, 15, 0),
    setValue: "2011-W33",
    minDate: new Date(2011, 0, 24, 0),
    minValue: "2011-W04",
    valueBelowRange: "2011-W01",
    invalidMinValue: "2014-W35",
    maxDate: new Date(2013, 0, 21, 0),
    maxValue: "2013-W04",
    valueAboveRange: "2100-W05",
    invalidMaxValue: "2010-W09",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "2012-W05",
    snappedValue: "2012-W05",
    singleIncrementValue: "2012-W01",
    singleDecrementValue: "2012-W01",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
  });

  module("datetimeinput tests");

  testGenericDateWidgetBehaviors({
    className: "DateTimeInput",
    cls: DateTimeInput,
    type: "datetime",
    defaultDate: new Date(2011, 5, 21, 16, 27, 53),
    defaultValue: "2011-06-21T16:27:53+02:00",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "122-50", "1-1-+6"],
    setDate: new Date(2011, 7, 15, 8, 35, 12),
    setValue: "2011-08-15T08:35:12+02:00",
    minDate: new Date(2011, 0, 1, 0, 0, 0),
    minValue: "2011-01-01T00:00:00+01:00",
    valueBelowRange: "2010-12-31T23:59:59+01:00",
    invalidMinValue: "2013-05-03T23:59:59+01:00",
    maxDate: new Date(2011, 11, 31, 23, 59, 59),
    maxValue: "2011-12-31T23:00:00+01:00",
    valueAboveRange: "2013-05-03T00:00:00+01:00",
    invalidMaxValue: "2010-01-01T00:00:00+01:00",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "2011-08-15T08:35:12+02:00",
    snappedValue: "2011-08-15T08:00:00+02:00",
    singleIncrementValue: "2011-06-21T16:30:00+02:00",
    singleDecrementValue: "2011-06-21T15:30:00+02:00",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
  });

  module("datetimelocalinput tests");

  testGenericDateWidgetBehaviors({
    className: "DateTimeLocalInput",
    cls: DateTimeLocalInput,
    type: "datetime-local",
    defaultDate: new Date(2011, 5, 21, 16, 27, 53),
    defaultValue: "2011-06-21T16:27:53",
    invalidDates: [null, new Date("foo")],
    invalidValues: [null, "foo", "122-50", "1-1-+6"],
    setDate: new Date(2011, 7, 15, 8, 35, 12),
    setValue: "2011-08-15T08:35:12",
    minDate: new Date(2011, 0, 1, 0, 0, 0),
    minValue: "2011-01-01T00:00:00",
    valueBelowRange: "2010-12-31T23:59:59",
    invalidMinValue: "2013-05-16T23:59:59",
    maxDate: new Date(2011, 11, 31, 23, 59, 59),
    maxValue: "2011-12-31T23:00:00",
    valueAboveRange: "2013-05-01T00:00:00",
    invalidMaxValue: "2010-01-07T00:00:00",
    stepValue: 1800,
    setStep: 3600,
    valueNotInStep: "2011-08-15T08:35:12",
    snappedValue: "2011-08-15T08:00:00",
    singleIncrementValue: "2011-06-21T16:30:00",
    singleDecrementValue: "2011-06-21T15:30:00",
    undefinedMinValueMatcher: nullValue(),
    undefinedMaxValueMatcher: nullValue(),
    undefinedStepValueMatcher: nullValue()
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };

      return MockWidget;

    })(Widget);
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
    MockWidget = (function(_super) {

      __extends(MockWidget, _super);

      function MockWidget() {
        MockWidget.__super__.constructor.apply(this, arguments);
      }

      MockWidget.prototype.createDummy = function() {
        return $("<div></div>");
      };

      return MockWidget;

    })(Widget);
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

  test("Input with type color should be replaced by a ColorInput", function() {
    target = $("<p><input type='color'></input></p>");
    target.children().widgets();
    return assertThat(target.children(".colorinput").length, equalTo(1));
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
