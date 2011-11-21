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

	assertThat slider.get("value"), equalTo 10
	assertThat slider.get("min"),   equalTo 5
	assertThat slider.get("max"),   equalTo 15
	assertThat slider.get("step"),  equalTo 1

test "Changing the slider data should modify the target", ->
	
	target = $("<input type='range' value='10' min='5' max='15' step='1'></input>")
	slider = new Slider target[0]

	slider.set "min", 10
	slider.set "max", 30
	slider.set "step", 0.5
	slider.set "value", 20

	assertThat target.attr("min"), equalTo 10
	assertThat target.attr("max"), equalTo 30
	assertThat target.attr("step"), equalTo 0.5
	assertThat target.attr("value"), equalTo 20

test "Slider initial data should be set even without a target", ->

	slider = new Slider
	
	assertThat slider.get("value"), equalTo 0
	assertThat slider.get("min"),   equalTo 0
	assertThat slider.get("max"),   equalTo 100
	assertThat slider.get("step"),  equalTo 1

test "Slider value shouldn't be set on a value outside of the range", ->

	slider = new Slider

	slider.set "value", -10

	assertThat slider.get("value"), equalTo 0 

	slider.set "value", 1000

	assertThat slider.get("value"), equalTo 100 

test "Slider value should be constrained by step", ->

	slider = new Slider
	slider.set "step", 3

	slider.set "value", 10

	assertThat slider.get("value"), equalTo 9

test "Changing slider's min property should correct the value if it goes out of the range", ->

	slider = new Slider

	slider.set "min", 50

	assertThat slider.get("value"), equalTo 50

test "Changing slider's max property should correct the value if it goes out of the range", ->

	slider = new Slider

	slider.set "value", 100
	slider.set "max", 50

	assertThat slider.get("value"), equalTo 50

test "Changing slider's step property should correct the value if it doesn't snap anymore", ->

	slider = new Slider

	slider.set "value", 10
	slider.set "step", 3

	assertThat slider.get("value"), equalTo 9

test "Setting a min value greater than the max value shouldn't be allowed", ->

	slider = new Slider

	slider.set "min", 100

	assertThat slider.get("min"), equalTo 0

test "Setting a max value lower than the min value shouldn't be allowed", ->

	slider = new Slider

	slider.set "max", 0

	assertThat slider.get("max"), equalTo 100

test "Sliders should have a dummy", ->

	slider = new Slider

	assertThat slider.dummy, notNullValue()

test "Sliders's .value child text should be the sliders value", ->

	slider = new Slider

	slider.set "value", 15

	assertThat slider.dummy.children(".value").text(), equalTo "15"

test "Sliders's .knob child position should be proportionate to the value", ->

	slider = new Slider

	slider.dummy.attr "style", "width:100px;"
	slider.dummy.children(".knob").attr "style", "width:20px;"

	slider.set "value", 25

	assertThat slider.dummy.children(".knob").css("left"), equalTo "20px"

test "Optionally the slider should allow to adjust the value text to the knob", ->

	slider = new Slider

	slider.dummy.attr "style", "width:100px;"
	slider.dummy.children(".knob").attr "style", "width:20px;"
	slider.dummy.children(".value").attr "style", "width:10px;"

	slider.valueCenteredOnKnob = true

	slider.set "value", 25
	assertThat slider.dummy.children(".value").css("left"), equalTo "25px"




