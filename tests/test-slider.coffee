$( document ).ready ->

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

	opt= 
		cls:Slider
		className:"Slider"
		defaultTarget:"<input type='range' min='0' max='100' step='5' value='10'>"

		initialValue:10
		valueBelowRange:-10
		valueAboveRange:110
		
		minValue:0
		setMinValue:50
		invalidMinValue:110

		maxValue:100
		setMaxValue:5
		invalidMaxValue:-10

		stepValue:5
		setStep:3
		valueNotInStep:10
		snappedValue:9

		singleIncrementValue:15
		singleDecrementValue:5

		undefinedMinValueMatcher:equalTo 0
		undefinedMaxValueMatcher:equalTo 100
		undefinedStepValueMatcher:equalTo 1
		
	testValueInRangeMixinBehavior opt

	testValueInRangeMixinIntervalsRunning opt

	a =
		key:"up"
		action:"increment"
		valueMatcher:closeTo 15, 1
		initialValueMatcher:equalTo 10

	testValueInRangeMixinKeyboardBehavior opt extends a

	a = 
		key:"down"
		action:"decrement"
		valueMatcher:closeTo 5, 1
		initialValueMatcher:equalTo 10

	testValueInRangeMixinKeyboardBehavior opt extends a

	a = 
		key:"right"
		action:"increment"
		valueMatcher:closeTo 15, 1
		initialValueMatcher:equalTo 10

	testValueInRangeMixinKeyboardBehavior opt extends a 

	a =
		key:"left"
		action:"decrement"
		valueMatcher:closeTo 5, 1
		initialValueMatcher:equalTo 10

	testValueInRangeMixinKeyboardBehavior opt extends a 

	testValueInRangeMixinMouseWheelBehavior opt

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
	slider1.before "#qunit-header"
	slider2.before "#qunit-header"
	slider3.before "#qunit-header"
