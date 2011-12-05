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

test "A FilePicker shouldn't allow to be created without a target", ->

	errorRaised = false
	try
		picker = new FilePicker 
	catch e
		errorRaised = true

	assertThat errorRaised

test "The FilePicker's dummy should contains the target as child.", ->

	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	assertThat picker.dummy.children("input").length, equalTo 1

test "The FilePicker's value span should containsa default value when no file was picked", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	assertThat picker.dummy.children(".value").text(), equalTo "Browse"

test "A readonly FilePicker should hide its target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "readonly", true

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "A disabled FilePicker should hide its target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "disabled", true

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "Enabling a FilePicker should show its target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "disabled", true
	picker.set "disabled", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: block;"

test "Allowing writing in a FilePicker should show its target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "readonly", true
	picker.set "readonly", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: block;"

test "Enabling a readonly widget shouldn't show the target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "readonly", true
	picker.set "disabled", true
	picker.set "disabled", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"

test "Enabling writing on a disabled widget shouldn't show the target", ->
	
	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.set "disabled", true
	picker.set "readonly", true
	picker.set "readonly", false

	assertThat picker.dummy.children("input").attr("style"), equalTo "display: none;"


test "A FilePicker should register to the change event of the target", ->

	targetChangeWasCalled = false

	class MockFilePicker extends FilePicker
		targetChange:(e)->
			targetChangeWasCalled = true

	target = $("<input type='file'></input>")
	picker = new MockFilePicker target[0]

	target.change()

	assertThat targetChangeWasCalled

test "A FilePicker should be able to set a new text in the value span", ->

	target = $("<input type='file'></input>")[0]
	picker = new FilePicker target

	picker.setValueLabel "hello"

	assertThat picker.dummy.children(".value").text(), equalTo "hello"

test "A change made to the target that end with an undefined value should empty the dummy's title attribute", ->

	target = $("<input type='file'></input>")
	picker = new FilePicker target[0]

	picker.setValueLabel "hello"
	target.change()

	assertThat picker.dummy.attr("title"), equalTo ""


# Some real widget's instance to play with in the test runner.

picker1 = new FilePicker $("<input type='file'></input>")[0]
picker2 = new FilePicker $("<input type='file'></input>")[0]
picker3 = new FilePicker $("<input type='file'></input>")[0]

picker2.set "readonly", true
picker3.set "disabled", true

$("#qunit-header").before $ "<h4>File Pickers</h4>"
$("#qunit-header").before picker1.dummy
$("#qunit-header").before picker2.dummy
$("#qunit-header").before picker3.dummy
