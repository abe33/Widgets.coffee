module "sliders tests"

test "Slider should allow input of type range", ->

	target = $("<input type='range'></input>")[0]
	slider = new Slider target

	assertThat slider.target is target

test "Slider shouldn't allow input of a type different than range", ->

	target = $("<input type='text'></input>")[0]
	errorRaised = false
	try
		slider = new Slider target
	catch e
		errorRaised = true
	
	assertThat errorRaised

test "Slider initial data should be taken from the target if provided", ->

	target = $("<input type='range' value='10' min='5' max='15' step='1'></input>")[0]
	slider = new Slider target

	assertThat slider.get("value"), strictlyEqualTo 10
	assertThat slider.get("min"),   strictlyEqualTo 5
	assertThat slider.get("max"),   strictlyEqualTo 15
	assertThat slider.get("step"),  strictlyEqualTo 1

test "Changing the slider data should modify the target", ->
	
	target = $("<input type='range' value='10' min='5' max='15' step='1'></input>")
	slider = new Slider target[0]

	slider.set "min", 10
	slider.set "max", 30
	slider.set "step", 0.5
	slider.set "value", 20

	assertThat target.attr("min"), strictlyEqualTo "10"
	assertThat target.attr("max"), strictlyEqualTo "30"
	assertThat target.attr("step"), strictlyEqualTo "0.5"
	assertThat target.attr("value"), strictlyEqualTo "20"

test "Slider initial data should be set even without a target", ->

	slider = new Slider
	
	assertThat slider.get("value"), strictlyEqualTo 0
	assertThat slider.get("min"),   strictlyEqualTo 0
	assertThat slider.get("max"),   strictlyEqualTo 100
	assertThat slider.get("step"),  strictlyEqualTo 1

test "Slider value shouldn't be set on a value outside of the range", ->

	slider = new Slider

	slider.set "value", -10

	assertThat slider.get("value"), strictlyEqualTo 0 

	slider.set "value", 1000

	assertThat slider.get("value"), strictlyEqualTo 100 

test "Slider value should be constrained by step", ->

	slider = new Slider
	slider.set "step", 3

	slider.set "value", 10

	assertThat slider.get("value"), strictlyEqualTo 9

test "Changing slider's min property should correct the value if it goes out of the range", ->

	slider = new Slider

	slider.set "min", 50

	assertThat slider.get("value"), strictlyEqualTo 50

test "Changing slider's max property should correct the value if it goes out of the range", ->

	slider = new Slider

	slider.set "value", 100
	slider.set "max", 50

	assertThat slider.get("value"), strictlyEqualTo 50

test "Changing slider's step property should correct the value if it doesn't snap anymore", ->

	slider = new Slider

	slider.set "value", 10
	slider.set "step", 3

	assertThat slider.get("value"), strictlyEqualTo 9

test "Setting a min value greater than the max value shouldn't be allowed", ->

	slider = new Slider

	slider.set "min", 100

	assertThat slider.get("min"), strictlyEqualTo 0

test "Setting a max value lower than the min value shouldn't be allowed", ->

	slider = new Slider

	slider.set "max", 0

	assertThat slider.get("max"), strictlyEqualTo 100

test "Sliders should have a dummy", ->

	slider = new Slider

	assertThat slider.dummy, notNullValue()

test "Sliders's .value child text should be the sliders value", ->

	slider = new Slider

	slider.set "value", 15

	assertThat slider.dummy.children(".value").text(), strictlyEqualTo "15"

test "Sliders's .value child text should be the sliders value even after instanciation", ->

	slider = new Slider

	assertThat slider.dummy.children(".value").text(), strictlyEqualTo "0"

test "Sliders's .knob child position should be proportionate to the value", ->

	slider = new Slider

	slider.dummy.attr "style", "width:100px"
	slider.dummy.children(".knob").attr "style", "width:20px"

	slider.set "value", 25

	assertThat slider.dummy.children(".knob").css("left"), strictlyEqualTo "20px"

test "The slider should allow to adjust the value text to the knob", ->

	slider = new Slider

	slider.dummy.attr "style", "width:100px"
	slider.dummy.children(".knob").attr "style", "width:20px"
	slider.dummy.children(".value").attr "style", "width:10px"

	slider.set "value", 25
	assertThat slider.dummy.children(".value").css("left"), strictlyEqualTo "25px"

test "Sliders should hide their target", ->
	target = $("<input type='range' value='10' min='0' max='50' step='1'></input>")
	slider = new Slider target[0]

	assertThat target.attr("style"), contains "display: none"

test "Pressing the mouse on the knob should init drag", ->

	slider = new Slider

	slider.dummy.children(".knob").mousedown()

	assertThat slider.draggingKnob

test "Releasing the mouse anywhere when a slider is dragging should stop the drag", ->

	slider = new Slider

	slider.dummy.children(".knob").mousedown()

	$(document).mouseup()

	assertThat not slider.draggingKnob

test "Moving the mouse during a drag should call the drag method", ->

	dragCalled = false

	class MockSlider extends Slider
		drag:->
			dragCalled = true
	
	slider = new MockSlider

	slider.dummy.children(".knob").mousedown()
	$(document).mousemove()

	assertThat dragCalled

test "Starting a drag should register the mouse page position", ->
	event = null

	class MockSlider extends Slider
		startDrag:(e)->
			e.pageX = 40
			e.pageY = 40
			super e
			event = e
	
	slider = new MockSlider

	$("#qunit-header").before slider.dummy
	
	slider.dummy.children(".knob").mousedown()

	slider.dummy.remove()

	assertThat event, notNullValue()
	assertThat slider.lastMouseX, equalTo event.pageX
	assertThat slider.lastMouseY, equalTo event.pageY

test "While dragging the knob, a slider should be able to measure the distance since the last callback", ->
	dragData = null

	class MockSlider extends Slider
		startDrag:(e)->
			e.pageX = 40
			e.pageY = 38
			super e
		drag:(e)->
			e.pageX = 50
			e.pageY = 52

			dragData = @getDragDataFromEvent e
			super e
		
	slider = new MockSlider
	slider.dummy.children(".knob").mousedown()
	$(document).mousemove()

	assertThat dragData, allOf notNullValue(), hasProperty("x", equalTo 10 ), hasProperty("y", equalTo 14)

test "While dragging the knob, a slider should register the new mouse position at the end of the callback", ->

	class MockSlider extends Slider
		drag:(e)->
			e.pageX = 50
			e.pageY = 52
			super e
	
	slider = new MockSlider
	slider.dummy.children(".knob").mousedown()
	$(document).mousemove()
	
	assertThat slider.lastMouseX, strictlyEqualTo 50
	assertThat slider.lastMouseY, strictlyEqualTo 52

test "While dragging the knob, a slider should update its value according to the move distance", ->

	class MockSlider extends Slider
		startDrag:(e)->
			e.pageX = 40
			e.pageY = 38
			super e
		drag:(e)->
			e.pageX = 50
			e.pageY = 52
			super e
	
	slider = new MockSlider

	slider.set "min", 10
	slider.set "max", 110

	slider.dummy.attr "style", "width:100px"
	slider.dummy.children(".knob").attr "style", "width:50px"
	
	slider.dummy.children(".knob").mousedown()
	$(document).mousemove()

	assertThat slider.get("value"), strictlyEqualTo 30

test "Sliders should have the focus after starting a drag gesture", ->

	slider = new Slider

	slider.dummy.children(".knob").mousedown()

	assertThat slider.hasFocus

test "Readonly sliders shouldn't allow drag", ->

	slider = new Slider

	slider.set "readonly", true

	slider.dummy.children(".knob").mousedown()

	assertThat not slider.draggingKnob

test "Disabled sliders shouldn't allow drag", ->

	slider = new Slider

	slider.set "disabled", true

	slider.dummy.children(".knob").mousedown()

	assertThat not slider.draggingKnob

test "Using the mousewheel over a slider should change the value according to the step", ->
	 
	class MockSlider extends Slider
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	slider = new MockSlider
	slider.set "step", 4
	slider.dummy.mousewheel()

	assertThat slider.get("value"), strictlyEqualTo 4

test "Using the mousewheel over a readonly slider shouldn't change the value", ->
	 
	class MockSlider extends Slider
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	slider = new MockSlider
	slider.set "readonly", true
	slider.dummy.mousewheel()

	assertThat slider.get("value"), strictlyEqualTo 0

test "Using the mousewheel over a disabled slider shouldn't change the value", ->
	 
	class MockSlider extends Slider
		mousewheel:( e, d )->
			d = 1 
			super e, d
	
	slider = new MockSlider
	slider.set "disabled", true
	slider.dummy.mousewheel()

	assertThat slider.get("value"), strictlyEqualTo 0

asyncTest "When the up key is pressed the slider should increment the value", ->

	slider = new Slider

	slider.grabFocus()
	slider.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the up key shouldn't trigger several increment", ->

	slider = new Slider
	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	
	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the up key is released the slider should stop increment the value", ->

	slider = new Slider

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		slider.keyup e
	, 100

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	slider = new Slider

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.grabFocus()
	slider.keydown e
	slider.keyup e

	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the down key should return false to prevent scrolling", ->
	slider = new Slider

	slider.grabFocus()
	assertThat not slider.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the up key should return false to prevent scrolling", ->
	slider = new Slider

	slider.grabFocus()
	assertThat not slider.keydown
		keyCode:keys.up
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the down key is pressed the slider should decrement the value", ->

	slider = new Slider
	slider.set "value", 10

	slider.grabFocus()
	slider.keydown
		keyCode:keys.down
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the down key shouldn't trigger several decrement", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	
	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the down key is released the slider should stop decrement the value", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		slider.keyup e
	, 100

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keyup e

	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly slider shouldn't work", ->

	slider = new Slider

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "readonly", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly slider shouldn't work", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "readonly", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled slider shouldn't work", ->

	slider = new Slider

	e = {
		keyCode:keys.up,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "disabled", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled slider shouldn't work", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.down,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "disabled", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 10, 1

		start()
	, 100


asyncTest "When the right key is pressed the slider should increment the value", ->

	slider = new Slider

	slider.grabFocus()
	slider.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "Receiving several keydown of the right key shouldn't trigger several increment", ->

	slider = new Slider
	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	
	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

asyncTest "When the right key is released the slider should stop increment the value", ->

	slider = new Slider

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		slider.keyup e
	, 100

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 200

asyncTest "Stopping the increment on keyup should allow to start a new one", ->

	slider = new Slider

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.grabFocus()
	slider.keydown e
	slider.keyup e

	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 2, 1

		start()
	, 100

test "Pressing the left key should return false to prevent scrolling", ->
	slider = new Slider

	slider.grabFocus()
	assertThat not slider.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Pressing the right key should return false to prevent scrolling", ->
	slider = new Slider

	slider.grabFocus()
	assertThat not slider.keydown
		keyCode:keys.right
		ctrlKey:false
		shiftKey:false
		altKey:false	


asyncTest "When the left key is pressed the slider should decrement the value", ->

	slider = new Slider
	slider.set "value", 10

	slider.grabFocus()
	slider.keydown
		keyCode:keys.left
		ctrlKey:false
		shiftKey:false
		altKey:false

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Receiving several keydown of the left key shouldn't trigger several decrement", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	slider.keydown e
	
	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "When the left key is released the slider should stop decrement the value", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		slider.keyup e
	, 100

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 200

asyncTest "Stopping the decrement on keyup should allow to start a new one", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}

	slider.grabFocus()
	slider.keydown e
	slider.keyup e

	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 8, 1

		start()
	, 100

asyncTest "Trying to increment a readonly slider shouldn't work", ->

	slider = new Slider

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "readonly", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a readonly slider shouldn't work", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "readonly", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 10, 1

		start()
	, 100

asyncTest "Trying to increment a disabled slider shouldn't work", ->

	slider = new Slider

	e = {
		keyCode:keys.right,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "disabled", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 0, 1

		start()
	, 100

asyncTest "Trying to decrement a disabled slider shouldn't work", ->

	slider = new Slider
	slider.set "value", 10

	e = {
		keyCode:keys.left,
		ctrlKey:false,
		shiftKey:false,
		altKey:false
	}
	slider.set "disabled", true

	slider.grabFocus()
	slider.keydown e

	setTimeout ->
		assertThat slider.get("value"), closeTo 10, 1

		start()
	, 100

test "Pressing the mouse over the track should change the value, grab the focus and start a knob drag", ->

	class MockSlider extends Slider
		handleTrackMouseDown:(e)->
			e.pageX = 10
			super e

	slider = new MockSlider

	slider.dummy.width 100
	
	# Both Chrome and Opera failed on this test because the 
	# track child's width return 0. 
	#
	# We ensure that the track have a valid width to let the
	# test proceed well. 
	slider.dummy.find(".track").width 100

	slider.dummy.children(".track").mousedown()
	
	assertThat slider.get("value"), equalTo 10
	assertThat slider.draggingKnob
	assertThat slider.hasFocus

test "Pressing the mouse over a disabled track shouldn't change the value ", ->

	class MockSlider extends Slider
		handleTrackMouseDown:(e)->
			e.pageX = 10

			super e

	slider = new MockSlider
	slider.set "disabled", true
	slider.dummy.width 100

	slider.dummy.children(".track").mousedown()
	
	assertThat slider.get("value"), equalTo 0
	assertThat not slider.draggingKnob

test "Pressing the mouse over a readonly track shouldn't change the value ", ->

	class MockSlider extends Slider
		handleTrackMouseDown:(e)->
			e.pageX = 10
			super e

	slider = new MockSlider
	slider.set "readonly", true
	slider.dummy.width 100

	slider.dummy.children(".track").mousedown()
	
	assertThat slider.get("value"), equalTo 0
	assertThat not slider.draggingKnob

test "Stepper should allow to increment the value through a function", ->

	slider = new Slider
	slider.set "step", 5

	slider.increment()

	assertThat slider.get("value"), equalTo 5

test "Stepper should allow to increment the value through a function", ->

	slider = new Slider
	slider.set "value", 10
	slider.set "step", 5

	slider.decrement()

	assertThat slider.get("value"), equalTo 5

# Clear all the drag that haven't been terminated in tests.
$(document).mouseup()

# Some real instances to play with in the test runner.
target = $("<input type='range' value='10' min='0' max='50' step='1'></input>")
slider1 = new Slider target[0]
slider2 = new Slider
slider3 = new Slider

slider1.valueCenteredOnKnob = true
slider2.valueCenteredOnKnob = true
slider3.valueCenteredOnKnob = true

slider1.set "value", 12
slider2.set "value", 45
slider3.set "value", 78

slider2.set "readonly", true
slider3.set "disabled", true

$("#qunit-header").before $ "<h4>Sliders</h4>"
$("#qunit-header").before target
$("#qunit-header").before slider1.dummy
$("#qunit-header").before slider2.dummy
$("#qunit-header").before slider3.dummy



		
	





