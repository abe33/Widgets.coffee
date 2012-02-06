$( document ).ready ->

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

	opt= 
		cls:Stepper
		className:"Stepper"
		defaultTarget:"<input type='number' min='0' max='100' step='5' value='10'>"
		focusChildSelector:"input"

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

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:equalTo 1

		
	testRangeStepperMixinBehavior opt

	testRangeStepperMixinIntervalsRunning opt

	a =
		key:"up"
		action:"increment"
		valueMatcher:closeTo 15, 1
		initialValueMatcher:equalTo 10

	testRangeStepperMixinKeyboardBehavior opt extends a

	a = 
		key:"down"
		action:"decrement"
		valueMatcher:closeTo 5, 1
		initialValueMatcher:equalTo 10

	testRangeStepperMixinKeyboardBehavior opt extends a

	a = 
		key:"right"
		action:"increment"
		valueMatcher:closeTo 15, 1
		initialValueMatcher:equalTo 10

	testRangeStepperMixinKeyboardBehavior opt extends a 

	a =
		key:"left"
		action:"decrement"
		valueMatcher:closeTo 5, 1
		initialValueMatcher:equalTo 10

	testRangeStepperMixinKeyboardBehavior opt extends a 

	testRangeStepperMixinMouseWheelBehavior opt
	 
	testFocusProvidedByChildMixinBegavior opt

	test "Stepper's input value should be the stepper value", ->

		stepper = new Stepper

		assertThat stepper.dummy.children(".value").val(), equalTo "0"

	test "Stepper's input value should be the stepper value after a change", ->

		stepper = new Stepper
		stepper.set "value", 20

		assertThat stepper.dummy.children(".value").val(), equalTo "20"

	test "When the value change in the stepper's input, the stepper should validate the new value", ->

		stepper = new Stepper

		stepper.dummy.children(".value").val("40")
		stepper.dummy.children(".value").change()

		assertThat stepper.get("value"), strictlyEqualTo 40

	test "When the value in the stepper's input is invalid, the stepper should turn it back to the valid value", ->

		stepper = new Stepper

		stepper.dummy.children(".value").val("abcd")
		stepper.dummy.children(".value").change()

		assertThat stepper.dummy.children(".value").val(), strictlyEqualTo "0"

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
			assertThat stepper.get("value"), closeTo 6, 2

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

	asyncTest "Releasing the mouse outside of the plus button should stop the increment interval", ->

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

	asyncTest "Moving the mouse out of the plus button should stop the increment interval", ->

		stepper = new Stepper

		stepper.dummy.children(".up").mousedown()

		setTimeout ->
			stepper.dummy.children(".up").mouseout()
		, 100

		setTimeout ->
			assertThat stepper.get("value"), closeTo 2, 1 

			start()
		, 200

	asyncTest "Moving the mouse back to the plus button should restart the increment interval", ->

		stepper = new Stepper

		stepper.dummy.children(".up").mousedown()

		setTimeout ->
			stepper.dummy.children(".up").mouseout()
			stepper.dummy.children(".up").mouseover()
		, 100

		setTimeout ->
			assertThat stepper.get("value"), closeTo 4, 2 

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