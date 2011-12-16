module "file picker tests"

test "A FilePicker should allow a target of type file", ->

	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	assertThat picker.target is target

test "A FilePicker shouldn't allow a target of with a type different than file", ->

	target = $("<input type='text'></input>")[0]
	errorRaised = false
	try
		picker = new FilePicker target
	catch e
		errorRaised = true

	assertThat errorRaised

test "A FilePicker should create a target when not provided in the constructor", ->

	picker = new FilePicker 

	assertThat picker.target, notNullValue()

test "The FilePicker's dummy should contains the target as child.", ->

	picker = new FilePicker

	assertThat picker.dummy.children("input").length, equalTo 1

test "The FilePicker's value span should contains a default value when no file was picked", ->
	
	picker = new FilePicker

	assertThat picker.dummy.children(".value").text(), equalTo "Browse"

test "A readonly FilePicker should hide its target", ->
	
	picker = new FilePicker

	picker.set "readonly", true

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "A disabled FilePicker should hide its target", ->
	
	picker = new FilePicker

	picker.set "disabled", true

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "Enabling a FilePicker should show its target", ->
	
	picker = new FilePicker

	picker.set "disabled", true
	picker.set "disabled", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: block;"

test "Allowing writing in a FilePicker should show its target", ->
	
	picker = new FilePicker

	picker.set "readonly", true
	picker.set "readonly", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: block;"

test "Enabling a readonly widget shouldn't show the target", ->
	
	picker = new FilePicker

	picker.set "readonly", true
	picker.set "disabled", true
	picker.set "disabled", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "Enabling writing on a disabled widget shouldn't show the target", ->
	
	picker = new FilePicker

	picker.set "disabled", true
	picker.set "readonly", true
	picker.set "readonly", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"


test "A FilePicker should register to the change event of the target", ->

	targetChangeWasCalled = false

	class MockFilePicker extends FilePicker
		targetChange:(e)->
			targetChangeWasCalled = true

	picker = new MockFilePicker

	picker.jTarget.change()

	assertThat targetChangeWasCalled

test "A FilePicker should be able to set a new text in the value span", ->

	picker = new FilePicker

	picker.setValueLabel "hello"

	assertThat picker.dummy.children(".value").text(), equalTo "hello"

test "A change made to the target that end with an undefined value should empty the dummy's title attribute", ->

	picker = new FilePicker

	picker.setValueLabel "hello"
	picker.jTarget.change()

	assertThat picker.dummy.attr("title"), equalTo ""

test "FilePicker shouldn't take focus, instead it should give it to its target input", ->
	
	focusPlacedOnTheInput = false
	
	picker = new FilePicker

	picker.dummy.children("input").focus ->
		focusPlacedOnTheInput = true
	
	picker.grabFocus()

	assertThat focusPlacedOnTheInput
	assertThat picker.dummy.attr("tabindex"), nullValue()
	assertThat picker.hasFocus

# Some real widget's instance to play with in the test runner.

picker1 = new FilePicker 
picker2 = new FilePicker
picker3 = new FilePicker

picker2.set "readonly", true
picker3.set "disabled", true

$("#qunit-header").before $ "<h4>File Pickers</h4>"
$("#qunit-header").before picker1.dummy
$("#qunit-header").before picker2.dummy
$("#qunit-header").before picker3.dummy
