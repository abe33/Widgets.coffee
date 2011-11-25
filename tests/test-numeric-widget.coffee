module "numeric-widget tests"

test "NumericWidget should allow input with type number as target", ->

	target = $("<input type='number'></input>")[0]
	widget = new NumericWidget target

	assertThat widget.target is target

test "NumericWidget should allow input with type range as target", ->

	target = $("<input type='range'></input>")[0]
	widget = new NumericWidget target

	assertThat widget.target is target

test "NumericWidget initial data should be taken from the target if provided", ->

	target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")[0]
	widget = new NumericWidget target

	assertThat widget.get("value"), strictlyEqualTo 10
	assertThat widget.get("min"),   strictlyEqualTo 5
	assertThat widget.get("max"),   strictlyEqualTo 15
	assertThat widget.get("step"),  strictlyEqualTo 1

test "Changing the widget data should modify the target", ->
	
	target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")
	widget = new NumericWidget target[0]

	widget.set "min", 10
	widget.set "max", 30
	widget.set "step", 0.5
	widget.set "value", 20

	assertThat target.attr("min"), strictlyEqualTo "10"
	assertThat target.attr("max"), strictlyEqualTo "30"
	assertThat target.attr("step"), strictlyEqualTo "0.5"
	assertThat target.attr("value"), strictlyEqualTo "20"

test "NumericWidget initial data should be set even without a target", ->

	widget = new NumericWidget
	
	assertThat widget.get("value"), strictlyEqualTo 0
	assertThat widget.get("min"),   strictlyEqualTo 0
	assertThat widget.get("max"),   strictlyEqualTo 100
	assertThat widget.get("step"),  strictlyEqualTo 1

test "NumericWidget value shouldn't be set on a value outside of the range", ->

	widget = new NumericWidget

	widget.set "value", -10

	assertThat widget.get("value"), strictlyEqualTo 0 

	widget.set "value", 1000

	assertThat widget.get("value"), strictlyEqualTo 100 

test "NumericWidget value should be constrained by step", ->

	widget = new NumericWidget
	widget.set "step", 3

	widget.set "value", 10

	assertThat widget.get("value"), strictlyEqualTo 9

test "Changing widget's min property should correct the value if it goes out of the range", ->

	widget = new NumericWidget

	widget.set "min", 50

	assertThat widget.get("value"), strictlyEqualTo 50

test "Changing widget's max property should correct the value if it goes out of the range", ->

	widget = new NumericWidget

	widget.set "value", 100
	widget.set "max", 50

	assertThat widget.get("value"), strictlyEqualTo 50

test "Changing widget's step property should correct the value if it doesn't snap anymore", ->

	widget = new NumericWidget

	widget.set "value", 10
	widget.set "step", 3

	assertThat widget.get("value"), strictlyEqualTo 9

test "Setting a min value greater than the max value shouldn't be allowed", ->

	widget = new NumericWidget

	widget.set "min", 100

	assertThat widget.get("min"), strictlyEqualTo 0

test "Setting a max value lower than the min value shouldn't be allowed", ->

	widget = new NumericWidget

	widget.set "max", 0

	assertThat widget.get("max"), strictlyEqualTo 100

test "NumericWidget should hide their target", ->

	target = $("<input type='range' value='10' min='0' max='50' step='1'></input>")
	widget = new NumericWidget target[0]

	assertThat target.attr("style"), equalTo "display: none;"

test "Concret numeric widgets class should receive an updateDummy call when value change", ->

	updateDummyCalled = false

	class MockNumericWidget extends NumericWidget
		updateDummy:(value, min, max)->
			updateDummyCalled = true
	
	widget = new MockNumericWidget
	widget.set "value", 20
	
	assertThat updateDummyCalled

test "NumericWidget should allow to increment the value through a function", ->

	widget = new NumericWidget
	widget.set "step", 5

	widget.increment()

	assertThat widget.get("value"), equalTo 5

test "NumericWidget should allow to increment the value through a function", ->

	widget = new NumericWidget
	widget.set "value", 10
	widget.set "step", 5

	widget.decrement()

	assertThat widget.get("value"), equalTo 5

asyncTest "NumericWidget should provide a way to increment the value on an interval", ->

	widget = new NumericWidget

	widget.startIncrement()

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "NumericWidget should be able to stop an increment interval", ->

	widget = new NumericWidget

	widget.startIncrement()

	setTimeout ->
		widget.endIncrement()
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 300

asyncTest "NumericWidget should provide a way to decrement the value on an interval", ->

	widget = new NumericWidget
	widget.set "value", 10

	widget.startDecrement()

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "NumericWidget should be able to stop an decrement interval", ->

	widget = new NumericWidget
	widget.set "value", 10
	widget.startDecrement()

	setTimeout ->
		widget.endDecrement()
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 300

asyncTest "NumericWidget shouldn't start several interval when startIncrement is called many times", ->

	widget = new NumericWidget

	widget.startIncrement()
	widget.startIncrement()
	widget.startIncrement()
	widget.startIncrement()

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "NumericWidget shouldn't start several interval when startDecrement is called many times", ->

	widget = new NumericWidget
	widget.set "value", 10

	widget.startDecrement()
	widget.startDecrement()
	widget.startDecrement()
	widget.startDecrement()

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the up key is pressed the widget should increment the value", ->

	widget = new NumericWidget

	widget.grabFocus()
	widget.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the up key shouldn't trigger several increment", ->

	widget = new NumericWidget
	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	
	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the up key is released the widget should stop increment the value", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		widget.keyup e
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.grabFocus()
	widget.keydown e
	widget.keyup e

	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the down key should return false to prevent scrolling", ->
	widget = new NumericWidget

	widget.grabFocus()
	assertThat not widget.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the up key should return false to prevent scrolling", ->
	widget = new NumericWidget

	widget.grabFocus()
	assertThat not widget.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the down key is pressed the widget should decrement the value", ->

	widget = new NumericWidget
	widget.set "value", 10

	widget.grabFocus()
	widget.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the down key shouldn't trigger several decrement", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	
	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the down key is released the widget should stop decrement the value", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		widget.keyup e
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keyup e

	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly widget shouldn't work", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "readonly", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly widget shouldn't work", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "readonly", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled widget shouldn't work", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "disabled", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled widget shouldn't work", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "disabled", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "When the right key is pressed the widget should increment the value", ->

	widget = new NumericWidget

	widget.grabFocus()
	widget.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the right key shouldn't trigger several increment", ->

	widget = new NumericWidget
	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	
	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the right key is released the widget should stop increment the value", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		widget.keyup e
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.grabFocus()
	widget.keydown e
	widget.keyup e

	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the left key should return false to prevent scrolling", ->
	widget = new NumericWidget

	widget.grabFocus()
	assertThat not widget.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the right key should return false to prevent scrolling", ->
	widget = new NumericWidget

	widget.grabFocus()
	assertThat not widget.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the left key is pressed the widget should decrement the value", ->

	widget = new NumericWidget
	widget.set "value", 10

	widget.grabFocus()
	widget.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the left key shouldn't trigger several decrement", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	widget.keydown e
	
	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the left key is released the widget should stop decrement the value", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		widget.keyup e
	, 100

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	widget.grabFocus()
	widget.keydown e
	widget.keyup e

	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly widget shouldn't work", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "readonly", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly widget shouldn't work", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "readonly", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled widget shouldn't work", ->

	widget = new NumericWidget

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "disabled", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled widget shouldn't work", ->

	widget = new NumericWidget
	widget.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	widget.set "disabled", true

	widget.grabFocus()
	widget.keydown e

	setTimeout ->
		assertThat widget.get("value"), closeTo 10, 1

		start()
	, 100

test "Using the mousewheel over a widget should change the value according to the step", ->
	 
	class MockNumericWidget extends NumericWidget
		createDummy:->
			$ "<span></span>"
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	widget = new MockNumericWidget
	widget.set "step", 4
	widget.dummy.mousewheel()

	assertThat widget.get("value"), strictlyEqualTo 4

test "Using the mousewheel over a readonly widget shouldn't change the value", ->
	 
	class MockNumericWidget extends NumericWidget
		createDummy:->
			$ "<span></span>"
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	widget = new MockNumericWidget
	widget.set "readonly", true
	widget.dummy.mousewheel()

	assertThat widget.get("value"), strictlyEqualTo 0

test "Using the mousewheel over a disabled widget shouldn't change the value", ->
	 
	class MockNumericWidget extends NumericWidget
		createDummy:->
			$ "<span></span>"
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	widget = new MockNumericWidget
	widget.set "disabled", true
	widget.dummy.mousewheel()

	assertThat widget.get("value"), strictlyEqualTo 0