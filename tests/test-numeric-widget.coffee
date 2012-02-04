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

test "NumericWidget should hide their target", ->

	target = $("<input type='range' value='10' min='0' max='50' step='1'></input>")
	widget = new NumericWidget target[0]

	assertThat target.attr("style"), contains "display: none"

test "Concret numeric widgets class should receive an updateDummy call when value change", ->

	updateDummyCalled = false

	class MockNumericWidget extends NumericWidget
		updateDummy:(value, min, max)->
			updateDummyCalled = true
	
	widget = new MockNumericWidget
	widget.set "value", 20
	
	assertThat updateDummyCalled

testRangeStepperMixinBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"

	initialValue:10
	valueBelowRange:-10
	valueAboveRange:110
	
	minValue:0
	setMinValue:50
	invalidMinValue:110

	maxValue:100
	setMaxValue:5
	invalidMaxValue:-10

	setStep:3
	valueNotInStep:10
	snappedValue:9

	singleIncrementValue:15
	singleDecrementValue:5

testRangeStepperMixinIntervalsRunning
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"

testRangeStepperMixinKeyboardBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"
	key:"up"
	action:"increment"
	valueMatcher:closeTo 15, 1
	initialValueMatcher:equalTo 10

testRangeStepperMixinKeyboardBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"
	key:"down"
	action:"decrement"
	valueMatcher:closeTo 5, 1
	initialValueMatcher:equalTo 10

testRangeStepperMixinKeyboardBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"
	key:"right"
	action:"increment"
	valueMatcher:closeTo 15, 1
	initialValueMatcher:equalTo 10

testRangeStepperMixinKeyboardBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"
	key:"left"
	action:"decrement"
	valueMatcher:closeTo 5, 1
	initialValueMatcher:equalTo 10

testRangeStepperMixinMouseWheelBehavior
	cls:NumericWidget
	className:"NumericWidget"
	defaultTarget:"<input min='0' max='100' step='5' value='10'>"
	initialValue:10
	setValue:15
	
	

