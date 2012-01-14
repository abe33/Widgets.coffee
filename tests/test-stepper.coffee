module "stepper tests"

test "Stepper should allow input with type number as target", ->

	target = $("<input type='number'></input>")[0]
	stepper = new Stepper target

	assertThat stepper.target is target

test "Stepper shouldn't allow input of a type different than range", ->

	target = $("<input type='text'></input>")[0]
	errorRaised = false
	try
		stepper = new Stepper target
	catch e
		errorRaised = true
	
	assertThat errorRaised

test "Stepper initial data should be taken from the target if provided", ->

	target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")[0]
	stepper = new Stepper target

	assertThat stepper.get("value"), strictlyEqualTo 10
	assertThat stepper.get("min"),   strictlyEqualTo 5
	assertThat stepper.get("max"),   strictlyEqualTo 15
	assertThat stepper.get("step"),  strictlyEqualTo 1

test "Changing the stepper data should modify the target", ->
	
	target = $("<input type='number' value='10' min='5' max='15' step='1'></input>")
	stepper = new Stepper target[0]

	stepper.set "min", 10
	stepper.set "max", 30
	stepper.set "step", 0.5
	stepper.set "value", 20

	assertThat target.attr("min"), strictlyEqualTo "10"
	assertThat target.attr("max"), strictlyEqualTo "30"
	assertThat target.attr("step"), strictlyEqualTo "0.5"
	assertThat target.attr("value"), strictlyEqualTo "20"

test "Stepper initial data should be set even without a target", ->

	stepper = new Stepper
	
	assertThat stepper.get("value"), strictlyEqualTo 0
	assertThat stepper.get("min"),   strictlyEqualTo 0
	assertThat stepper.get("max"),   strictlyEqualTo 100
	assertThat stepper.get("step"),  strictlyEqualTo 1

test "Stepper value shouldn't be set on a value outside of the range", ->

	stepper = new Stepper

	stepper.set "value", -10

	assertThat stepper.get("value"), strictlyEqualTo 0 

	stepper.set "value", 1000

	assertThat stepper.get("value"), strictlyEqualTo 100 

test "Stepper value should be constrained by step", ->

	stepper = new Stepper
	stepper.set "step", 3

	stepper.set "value", 10

	assertThat stepper.get("value"), strictlyEqualTo 9

test "Changing stepper's min property should correct the value if it goes out of the range", ->

	stepper = new Stepper

	stepper.set "min", 50

	assertThat stepper.get("value"), strictlyEqualTo 50

test "Changing stepper's max property should correct the value if it goes out of the range", ->

	stepper = new Stepper

	stepper.set "value", 100
	stepper.set "max", 50

	assertThat stepper.get("value"), strictlyEqualTo 50

test "Changing stepper's step property should correct the value if it doesn't snap anymore", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.set "step", 3

	assertThat stepper.get("value"), strictlyEqualTo 9

test "Setting a min value greater than the max value shouldn't be allowed", ->

	stepper = new Stepper

	stepper.set "min", 100

	assertThat stepper.get("min"), strictlyEqualTo 0

test "Setting a max value lower than the min value shouldn't be allowed", ->

	stepper = new Stepper

	stepper.set "max", 0

	assertThat stepper.get("max"), strictlyEqualTo 100

test "Stepper should allow to increment the value through a function", ->

	stepper = new Stepper
	stepper.set "step", 5

	stepper.increment()

	assertThat stepper.get("value"), equalTo 5

test "Stepper should allow to increment the value through a function", ->

	stepper = new Stepper
	stepper.set "value", 10
	stepper.set "step", 5

	stepper.decrement()

	assertThat stepper.get("value"), equalTo 5


asyncTest "When the up key is pressed the stepper should increment the value", ->

	stepper = new Stepper

	stepper.grabFocus()
	stepper.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the up key shouldn't trigger several increment", ->

	stepper = new Stepper
	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	
	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the up key is released the stepper should stop increment the value", ->

	stepper = new Stepper

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		stepper.keyup e
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	stepper = new Stepper

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.grabFocus()
	stepper.keydown e
	stepper.keyup e

	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the down key should return false to prevent scrolling", ->
	stepper = new Stepper

	stepper.grabFocus()
	assertThat not stepper.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the up key should return false to prevent scrolling", ->
	stepper = new Stepper

	stepper.grabFocus()
	assertThat not stepper.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the down key is pressed the stepper should decrement the value", ->

	stepper = new Stepper
	stepper.set "value", 10

	stepper.grabFocus()
	stepper.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the down key shouldn't trigger several decrement", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	
	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the down key is released the stepper should stop decrement the value", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		stepper.keyup e
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keyup e

	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly stepper shouldn't work", ->

	stepper = new Stepper

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "readonly", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly stepper shouldn't work", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "readonly", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled stepper shouldn't work", ->

	stepper = new Stepper

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "disabled", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled stepper shouldn't work", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "disabled", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "When the right key is pressed the stepper should increment the value", ->

	stepper = new Stepper

	stepper.grabFocus()
	stepper.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the right key shouldn't trigger several increment", ->

	stepper = new Stepper
	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	
	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the right key is released the stepper should stop increment the value", ->

	stepper = new Stepper

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		stepper.keyup e
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	stepper = new Stepper

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.grabFocus()
	stepper.keydown e
	stepper.keyup e

	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the left key should return false to prevent scrolling", ->
	stepper = new Stepper

	stepper.grabFocus()
	assertThat not stepper.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the right key should return false to prevent scrolling", ->
	stepper = new Stepper

	stepper.grabFocus()
	assertThat not stepper.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the left key is pressed the stepper should decrement the value", ->

	stepper = new Stepper
	stepper.set "value", 10

	stepper.grabFocus()
	stepper.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the left key shouldn't trigger several decrement", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	stepper.keydown e
	
	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the left key is released the stepper should stop decrement the value", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		stepper.keyup e
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	stepper.grabFocus()
	stepper.keydown e
	stepper.keyup e

	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly stepper shouldn't work", ->

	stepper = new Stepper

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "readonly", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly stepper shouldn't work", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "readonly", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled stepper shouldn't work", ->

	stepper = new Stepper

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "disabled", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled stepper shouldn't work", ->

	stepper = new Stepper
	stepper.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	stepper.set "disabled", true

	stepper.grabFocus()
	stepper.keydown e

	setTimeout ->
		assertThat stepper.get("value"), closeTo 10, 1

		start()
	, 100

test "Using the mousewheel over a stepper should change the value according to the step", ->
	 
	class MockStepper extends Stepper
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	stepper = new MockStepper
	stepper.set "step", 4
	stepper.dummy.mousewheel()

	assertThat stepper.get("value"), strictlyEqualTo 4

test "Using the mousewheel over a readonly stepper shouldn't change the value", ->
	 
	class MockStepper extends Stepper
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	stepper = new MockStepper
	stepper.set "readonly", true
	stepper.dummy.mousewheel()

	assertThat stepper.get("value"), strictlyEqualTo 0

test "Using the mousewheel over a disabled stepper shouldn't change the value", ->
	 
	class MockStepper extends Stepper
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	stepper = new MockStepper
	stepper.set "disabled", true
	stepper.dummy.mousewheel()

	assertThat stepper.get("value"), strictlyEqualTo 0

test "Stepper shouldn't take focus, instead it should give it to its value input", ->
	
	focusPlacedOnTheInput = false
	
	stepper = new Stepper
	stepper.dummy.children(".value").focus ->
		focusPlacedOnTheInput = true
	
	stepper.grabFocus()

	assertThat focusPlacedOnTheInput
	assertThat stepper.dummy.attr("tabindex"), nullValue()
	assertThat stepper.hasFocus

test "Clicking on a stepper should give him the focus", ->

	stepper = new Stepper

	stepper.dummy.mouseup()

	assertThat stepper.hasFocus

test "Stepper's input should reflect the state of the widget", ->

	stepper = new Stepper

	stepper.set "readonly", true
	stepper.set "disabled", true

	assertThat stepper.dummy.children(".value").attr("readonly"), notNullValue()
	assertThat stepper.dummy.children(".value").attr("disabled"), notNullValue()

test "Stepper's input value should be the stepper value", ->

	stepper = new Stepper

	assertThat stepper.dummy.children(".value").attr("value"), equalTo "0"

test "Stepper's input value should be the stepper value after a change", ->

	stepper = new Stepper
	stepper.set "value", 20

	assertThat stepper.dummy.children(".value").attr("value"), equalTo "20"

test "When the value change in the stepper's input, the stepper should validate the new value", ->

	stepper = new Stepper

	stepper.dummy.children(".value").val("40")
	stepper.dummy.children(".value").change()

	assertThat stepper.get("value"), strictlyEqualTo 40

test "When the value in the stepper's input is invalid, the stepper should turn it back to the valid value", ->

	stepper = new Stepper

	stepper.dummy.children(".value").val("abcd")
	stepper.dummy.children(".value").change()

	assertThat stepper.dummy.children(".value").attr("value"), strictlyEqualTo "0"

asyncTest "Pressing the mouse on the minus button should start a decrement interval", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.dummy.children(".down").mousedown()

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1 

		start()
	, 100

asyncTest "Releasing the mouse on the minus button should stop the decrement interval", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.dummy.children(".down").mousedown()

	setTimeout ->
		stepper.dummy.children(".down").mouseup()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1 

		start()
	, 200

asyncTest "Releasing the mouse outside of the minus button should stop the decrement interval", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.dummy.children(".down").mousedown()

	setTimeout ->
		$( document ).mouseup()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1 
		assertThat not stepper.mousePressed

		start()
	, 200

asyncTest "Moving the mouse out of the minus button should stop the decrement interval", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.dummy.children(".down").mousedown()

	setTimeout ->
		stepper.dummy.children(".down").mouseout()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 8, 1 

		start()
	, 200

asyncTest "Moving the mouse back to the minus button should restart the decrement interval", ->

	stepper = new Stepper

	stepper.set "value", 10
	stepper.dummy.children(".down").mousedown()

	setTimeout ->
		stepper.dummy.children(".down").mouseout()
		stepper.dummy.children(".down").mouseover()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 6, 1 

		start()
	, 200

asyncTest "Pressing the mouse on the plus button should start a increment interval", ->

	stepper = new Stepper

	stepper.dummy.children(".up").mousedown()

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1 

		start()
	, 100

asyncTest "Releasing the mouse on the plus button should stop the increment interval", ->

	stepper = new Stepper

	stepper.dummy.children(".up").mousedown()

	setTimeout ->
		stepper.dummy.children(".up").mouseup()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1 

		start()
	, 200

asyncTest "Releasing the mouse outside of the minus button should stop the decrement interval", ->

	stepper = new Stepper

	stepper.dummy.children(".up").mousedown()

	setTimeout ->
		$( document ).mouseup()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1 
		assertThat not stepper.mousePressed

		start()
	, 200

asyncTest "Moving the mouse out of the minus button should stop the decrement interval", ->

	stepper = new Stepper

	stepper.dummy.children(".up").mousedown()

	setTimeout ->
		stepper.dummy.children(".up").mouseout()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 2, 1 

		start()
	, 200

asyncTest "Moving the mouse back to the minus button should restart the decrement interval", ->

	stepper = new Stepper

	stepper.dummy.children(".up").mousedown()

	setTimeout ->
		stepper.dummy.children(".up").mouseout()
		stepper.dummy.children(".up").mouseover()
	, 100

	setTimeout ->
		assertThat stepper.get("value"), closeTo 4, 1 

		start()
	, 200

test "Pressing the mouse over the stepper and moving it to the up should increment the value until the mouse is released", ->

	class MockStepper extends Stepper
		mousedown:(e)->
			e.pageY = 5
			super e

		mousemove:(e)->
			e.pageY = 0
			super e

	stepper = new MockStepper

	stepper.dummy.mousedown()
	$(document).mousemove()
	$(document).mouseup()

	assertThat stepper.get("value"), closeTo 5, 1 
	assertThat not stepper.dragging


# Some real instances to play with in the runner.
target = $("<input type='number' value='10' min='0' max='50' step='1'></input>")
stepper1 = new Stepper target[0]
stepper2 = new Stepper
stepper3 = new Stepper

stepper1.valueCenteredOnKnob = true
stepper2.valueCenteredOnKnob = true
stepper3.valueCenteredOnKnob = true

stepper1.set "value", 12
stepper2.set "value", 45
stepper3.set "value", 78

stepper2.set "readonly", true
stepper3.set "disabled", true

$("#qunit-header").before $ "<h4>Steppers</h4>"
$("#qunit-header").before target
$("#qunit-header").before stepper1.dummy
$("#qunit-header").before stepper2.dummy
$("#qunit-header").before stepper3.dummy