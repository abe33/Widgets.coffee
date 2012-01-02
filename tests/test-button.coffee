module "button tests"

test "Buttons should allow to pass a button input as argument", ->
	target = ( $ "<input type='button'></input>" )[0]

	button = new Button target

	assertThat button.target is target

test "Buttons should allow to pass a submit input as argument", ->
	target = ( $ "<input type='submit'></input>" )[0]

	button = new Button target

	assertThat button.target is target

test "Buttons should allow to pass a reset input as argument", ->
	target = ( $ "<input type='reset'></input>" )[0]

	button = new Button target

	assertThat button.target is target

test "Buttons shouldn't allow any other type of input as argument", ->
	target = ( $ "<input type='text'></input>" )[0]

	errorRaised = false

	try
		button = new Button target
	catch e
		errorRaised = true

	assertThat errorRaised

test "Buttons should also allow an action object as argument", ->

	action = action:->

	button = new Button action
		
	assertThat button.get("action") is action

test "Buttons should accept both a target and an action as arguments", ->

	target = ( $ "<input type='reset'></input>" )[0]
	action = action:->

	button = new Button target, action
		
	assertThat button.target is target
	assertThat button.get("action") is action

test "Buttons content should be provided through the action object", ->

	action = display:"label", action:-> 

	button = new Button action

	assertThat button.dummy.find(".content").text(), equalTo "label"

test "Buttons should trigger the action on a click", ->

	actionTriggered = false
	
	action = action:-> 
		actionTriggered = true
	
	button = new Button action

	button.dummy.click()

	assertThat actionTriggered

test "Buttons should trigger their target click on a click", ->

	clickCalled = false

	target = ( $ "<input type='reset'></input>" )
	target.click ->
		clickCalled = true

	button = new Button target[0]

	button.click()

	assertThat clickCalled

test "Buttons should hide their target at creation", ->

	target = ( $ "<input type='reset'></input>" )

	button = new Button target[0]

	assertThat target.attr("style"), contains "display: none;"

test "Readonly buttons should not trigger the action on a click", ->

	actionTriggered = false
	
	action = action:-> 
		actionTriggered = true
	
	button = new Button action
	button.set "readonly", true

	button.dummy.click()

	assertThat not actionTriggered

test "Disabled buttons should not trigger the action on a click", ->

	actionTriggered = false
	
	action = action:-> 
		actionTriggered = true
	
	button = new Button action
	button.set "disabled", true

	button.dummy.click()

	assertThat not actionTriggered

test "Readonly buttons shouldn't trigger their target click on a click", ->

	clickCalled = false

	target = ( $ "<input type='reset'></input>" )
	target.click ->
		clickCalled = true

	button = new Button target[0]
	button.set "readonly", true

	button.click()

	assertThat not clickCalled

test "Disabled buttons shouldn't trigger their target click on a click", ->

	clickCalled = false

	target = ( $ "<input type='reset'></input>" )
	target.click ->
		clickCalled = true

	button = new Button target[0]
	button.set "disabled", true

	button.click()

	assertThat not clickCalled

test "Buttons should allow to use the space key instead of a click", ->

	actionTriggered = false
	
	action = action:-> 
		actionTriggered = true
	
	button = new Button action

	button.keydown 
		keyCode:keys.space
		ctrlKey:false
		shiftKey:false
		altKey:false

	assertThat actionTriggered

test "Buttons should allow to use the enter key instead of a click", ->

	actionTriggered = false
	
	action = action:-> 
		actionTriggered = true
	
	button = new Button action

	button.keydown 
		keyCode:keys.enter
		ctrlKey:false
		shiftKey:false
		altKey:false

	assertThat actionTriggered

test "Changing the action of a button should update its content", ->

	button = new Button

	button.set "action", display: "label", action:->

	assertThat button.dummy.find(".content").text(), equalTo "label"


button1 = new Button
button2 = new Button
button3 = new Button

button1.set "value", "Button <span class='icon'></span>"
button2.set "value", "Readonly"
button3.set "value", "Disabled"

button2.set "readonly", true
button3.set "disabled", true

$("#qunit-header").before $ "<h4>Button</h4>"
$("#qunit-header").before button1.dummy
$("#qunit-header").before button2.dummy
$("#qunit-header").before button3.dummy

