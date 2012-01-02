module "widgets base tests"

test "Widgets should have a target node", ->
	
	target = $("<div></div>")[0]
	widget = new Widget target 

	assertThat widget, hasProperty "target", equalTo target

test "Widgets constructor should fail with an invalid argument", ->
	
	target = $("<div></div>")
	widgetFailed = false

	try
		widget = new Widget target
	catch e
		widgetFailed = true
	
	assertThat widgetFailed

test "Widgets can be instanciated without a target", ->

	widget = new Widget

	assertThat widget, hasProperty "target"

test "Widgets with target should reflect the initial target's state", ->

	target = $("<input type='text' value='foo' name='foo' disabled readonly></input>")[0]
	widget = new Widget target 

	assertThat widget.get("disabled"), equalTo true
	assertThat widget.get("readonly"), equalTo true
	assertThat widget.get("value"),    equalTo "foo"
	assertThat widget.get("name"),     equalTo "foo"

test "Changes made to the widget should affect its target", ->

	target = $("<input type='text' value='foo' name='foo' disabled readonly></input>")[0]
	widget = new Widget target 

	widget.set "disabled", false
	widget.set "readonly", false
	widget.set "value",    "hello"
	widget.set "name",     "name"

	assertThat $(target).attr("disabled"), equalTo undefined
	assertThat $(target).attr("readonly"), equalTo undefined
	assertThat $(target).attr("value"),    equalTo "hello"
	assertThat $(target).attr("name"),     equalTo "name"

test "Changes made to a widget's property should dispatch a propertyChanged signal", ->

	widget           = new Widget 
	signalDispatched = false
	signalOrigin     = null
	signalProperty   = null
	signalValue      = null

	widget.propertyChanged.addOnce ( widget, property, value )->
		signalDispatched = true
		signalOrigin     = widget
		signalProperty   = property
		signalValue      = value

	widget.set "disabled", false

	assertThat signalDispatched
	assertThat signalOrigin,   equalTo widget
	assertThat signalProperty, equalTo "disabled"
	assertThat signalValue,    equalTo false

test "Changes made to the target's value should be catched by the widget", ->

	target = $("<input type='text' value='foo'></input>")
	targetChangeCalled = false
	
	class MockWidget extends Widget
		targetChange:(e)->
			targetChangeCalled = true
	
	widget = new MockWidget target[0]

	target.change()

	assertThat targetChangeCalled

test "Widget should dispatch a valueChanged signal on a value change", ->

	widget           = new Widget
	signalDispatched = false
	signalOrigin     = null
	signalValue      = null

	widget.valueChanged.addOnce ( widget, value )->
		signalDispatched = true
		signalOrigin     = widget
		signalValue      = value
	
	widget.set "value", "foo"
	
	assertThat signalDispatched
	assertThat signalOrigin,   equalTo widget
	assertThat signalValue,    equalTo "foo"

test "Widgets without target should allow modification of their properties", ->

	widget = new Widget 

	widget.set "value",    "hello"
	widget.set "disabled", true
	widget.set "readonly", true

	assertThat widget.get("value"),    equalTo "hello"
	assertThat widget.get("disabled"), equalTo true
	assertThat widget.get("readonly"), equalTo true

test "Widgets should allow creation of custom properties", ->

	widget = new Widget

	widget.createProperty "foo", "bar"

	assertThat widget.get( "foo" ), equalTo "bar"

	widget.set "foo", "hello"

	assertThat widget.get( "foo" ), equalTo "hello"

test "Widgets should allow to modify several properties with just one call to the set method", ->

	widget = new Widget
	widget.set 
		name:"someName"
		disabled:true
		value:"foo"
	
	assertThat widget.get("name"), equalTo "someName"
	assertThat widget.get("disabled"), equalTo true
	assertThat widget.get("value"), equalTo "foo"

test "Widgets should allow creation of custom properties with custom accessors", ->

	widget = new Widget

	getter = (property)->
		@properties[property]

	setter = (property, value)->
		@properties[property] = value

	widget.createProperty "foo", "bar", setter, getter

	assertThat widget.get( "foo" ), equalTo "bar"

	widget.set "foo", "hello"

	assertThat widget.get( "foo" ), equalTo "hello"

test "Widget class should allow subclasses to create a dummy in constructor", ->
	
	createDummyWasCalled = false

	class MockWidget extends Widget
		createDummy:->
			createDummyWasCalled = true
			$ "<span></span>"
	
	widget = new MockWidget

	assertThat createDummyWasCalled
	assertThat widget.dummy, allOf notNullValue(), hasProperty "length", equalTo 1

test "Widgets that create dummy should have registered to its mouse events", ->
	
	mousedownReceived = false
	mouseupReceived = false
	mousemoveReceived = false
	mouseoverReceived = false
	mouseoutReceived = false
	mousewheelReceived = false
	clickReceived = false
	dblclickReceived = false

	class MockWidget extends Widget
		createDummy:->
			@dummy = $ "<span></span>"
		mousedown:->
			mousedownReceived = true
		mouseup:->
			mouseupReceived = true
		mousemove:->
			mousemoveReceived = true
		mouseover:->
			mouseoverReceived = true
		mouseout:->
			mouseoutReceived = true
		mousewheel:->
			mousewheelReceived = true
		click:->
			clickReceived = true
		dblclick:->
			dblclickReceived = true
		
	widget = new MockWidget

	widget.dummy.mousedown()
	widget.dummy.mouseup()
	widget.dummy.mousemove()
	widget.dummy.mouseover()
	widget.dummy.mouseout()
	widget.dummy.mousewheel()
	widget.dummy.click()
	widget.dummy.dblclick()

	assertThat mousedownReceived
	assertThat mouseupReceived
	assertThat mousemoveReceived
	assertThat mouseoverReceived
	assertThat mouseoutReceived
	assertThat mouseoutReceived
	assertThat mousewheelReceived
	assertThat clickReceived
	assertThat dblclickReceived

test "Widgets that create dummy sould allow to unregister from its mouse events", ->

	mousedownReceived = false
	mouseupReceived = false
	mousemoveReceived = false
	mouseoverReceived = false
	mouseoutReceived = false
	mousewheelReceived = false
	clickReceived = false
	dblclickReceived = false

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		mousedown:->
			mousedownReceived = true
		mouseup:->
			mouseupReceived = true
		mousemove:->
			mousemoveReceived = true
		mouseover:->
			mouseoverReceived = true
		mouseout:->
			mouseoutReceived = true
		mousewheel:->
			mousewheelReceived = true
		click:->
			clickReceived = true
		dblclick:->
			dblclickReceived = true
	
	widget = new MockWidget

	widget.unregisterFromDummyEvents()

	widget.dummy.mousedown()
	widget.dummy.mouseup()
	widget.dummy.mousemove()
	widget.dummy.mouseover()
	widget.dummy.mouseout()
	widget.dummy.mousewheel()
	widget.dummy.click()
	widget.dummy.dblclick()

	assertThat not mousedownReceived
	assertThat not mouseupReceived
	assertThat not mousemoveReceived
	assertThat not mouseoutReceived
	assertThat not mouseoverReceived
	assertThat not mousewheelReceived
	assertThat not clickReceived
	assertThat not dblclickReceived

test "Widget's states should be reflected on the dummy class attribute", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"

	widget = new MockWidget

	widget.set "disabled", true

	assertThat widget.dummy.hasClass "disabled"

	widget.set "readonly", true
	
	assertThat widget.dummy.hasClass "readonly"

test "Widget's states should have the same order whatever the call order is", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"

	widget = new MockWidget

	widget.set "disabled", true
	widget.set "readonly", true

	assertThat widget.dummy.attr("class"), equalTo "disabled readonly"

	widget = new MockWidget

	widget.set "readonly", true
	widget.set "disabled", true
	
	assertThat widget.dummy.attr("class"), equalTo "disabled readonly"

test "Widget should dispatch a stateChanged signal when the state is changed", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		
	widget 			 = new MockWidget
	signalDispatched = false
	signalOrigin	 = null
	signalValue		 = null

	widget.stateChanged.add ( widget, state )->
		signalDispatched = true
		signalOrigin 	 = widget
		signalValue  	 = state
	
	widget.set "disabled", true

	assertThat signalDispatched
	assertThat signalOrigin, equalTo widget
	assertThat signalValue,  equalTo "disabled"

test "Widget shouldn't dispatch the stateChanged signal when a property that doesn't affect the state is modified", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		
	widget 			 = new MockWidget
	signalDispatched = false

	widget.stateChanged.add ( widget, state )->
		signalDispatched = true
	
	widget.set "name", "hello"

	assertThat not signalDispatched

test "Widget's dummy should allow focus by setting the tabindex attribute", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		
	widget = new MockWidget

	assertThat widget.dummy.attr("tabindex"), notNullValue()

test "Widgets should receive focus related events from its dummy", ->

	focusReceived = false
	blurReceived = false

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		focus:(e)->
			focusReceived = true
		blur:(e)->
			blurReceived = true
	
		
	widget = new MockWidget

	widget.dummy.focus()
	widget.dummy.blur()

	assertThat focusReceived
	assertThat blurReceived

test "Widgets should receive keyboard related events from its dummy", ->

	keydownReceived = false
	keyupReceived = false
	keypressReceived = false

	class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"
		keydown:(e)->
			keydownReceived = true
		keyup:(e)->
			keyupReceived = true
		keypress:(e)->
			keypressReceived = true
	
	widget = new MockWidget

	widget.dummy.keydown()
	widget.dummy.keypress()
	widget.dummy.keyup()

	assertThat keydownReceived
	assertThat keypressReceived
	assertThat keyupReceived

test "Widgets should be able to know when it has focus", ->
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget()

	widget.dummy.focus()

	assertThat widget.hasFocus

test "Widgets should be able to know when it lose focus", ->
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget()

	widget.dummy.focus()
	widget.dummy.blur()

	assertThat not widget.hasFocus

test "Widgets dummy should reflect the focus state in its class attribute", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget()

	widget.dummy.focus()

	assertThat widget.dummy.hasClass "focus"

test "Widgets dummy should reflect the lost focus state in its class attribute", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget()

	widget.dummy.focus()
	widget.dummy.blur()

	assertThat not widget.dummy.hasClass "focus"


test "Widgets should preserve the initial class value of the dummy", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget

	assertThat widget.dummy.attr("class"), equalTo "foo"

test "Widgets should preserve the initial class value of the dummy even with state class", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget
	widget.set "disabled", true

	assertThat widget.dummy.attr("class"), equalTo "foo disabled"

test "Widgets should hide the target when provided", ->

	target = $("<input type='text'></input>")

	widget = new Widget target[0]

	widget.hideTarget()
	
	assertThat target.attr( "style" ), contains "display: none"

test "Widgets shouldn't fail on hide when the target isn't provided", ->

	widget = new Widget
	errorRaised = false

	try
		widget.hideTarget()
	catch e
		errorRaised = true
	
	assertThat not errorRaised

test "Widgets should allow to register function for specific keystrokes on keydown", ->
	
	
	widget = new Widget
	
	widget.registerKeyDownCommand keystroke( keys.a, keys.mod.ctrl ), ->

	assertThat widget.hasKeyDownCommand keystroke keys.a, keys.mod.ctrl

test "Widgets should trigger the corresponding function with the associated keystroke on keydown", ->

	widget 		  = new Widget
	commandCalled = false

	widget.registerKeyDownCommand keystroke( keys.a, keys.mod.ctrl ), ->
		commandCalled = true
		
	widget.keydown 
		keyCode:keys.a
		ctrlKey:true
		shiftKey:false
		altKey:false
	
	assertThat commandCalled

test "Widgets should allow to register function for specific keystrokes on keyup", ->
	
	widget = new Widget
	
	widget.registerKeyUpCommand keystroke( keys.a, keys.mod.ctrl ), ->

	assertThat widget.hasKeyUpCommand keystroke keys.a, keys.mod.ctrl

test "Widgets should trigger the corresponding function with the associated keystroke on keyup", ->

	widget 		  = new Widget
	commandCalled = false

	widget.registerKeyUpCommand keystroke( keys.a, keys.mod.ctrl ), ->
		commandCalled = true
	
	widget.keyup 
		keyCode:keys.a
		ctrlKey:true
		shiftKey:false
		altKey:false
	
	assertThat commandCalled

test "Widgets keyup events that doesn't trigger a command shouldn't return false", ->

	widget = new Widget

	assertThat widget.keyup 
		keyCode:keys.a
		ctrlKey:true
		shiftKey:false
		altKey:false

test "Widgets keydown events that doesn't trigger a command shouldn't return false", ->

	widget = new Widget

	assertThat widget.keydown 
		keyCode:keys.a
		ctrlKey:true
		shiftKey:false
		altKey:false
	
test "Widgets keydown events that trigger a command should return the command return",->
	
	widget = new Widget

	widget.registerKeyDownCommand keystroke( keys.a ), ->
		true
	
	assertThat widget.keydown 
		keyCode:keys.a
		ctrlKey:false
		shiftKey:false
		altKey:false

test "Widgets keyup events that trigger a command should return the command return",->
	
	widget = new Widget

	widget.registerKeyUpCommand keystroke( keys.a ), ->
		true
	
	assertThat widget.keyup 
		keyCode:keys.a
		ctrlKey:false
		shiftKey:false
		altKey:false
	
test "Widgets should pass the event to the keydown commands", ->

	event = null
	widget = new Widget

	widget.registerKeyDownCommand keystroke( keys.a ), (e)->
		event = e
	
	widget.keydown 
		keyCode:keys.a
		ctrlKey:false
		shiftKey:false
		altKey:false
	
	assertThat event, notNullValue()

test "Widgets should pass the event to the keyup commands", ->

	event = null
	widget = new Widget

	widget.registerKeyUpCommand keystroke( keys.a ), (e)->
		event = e
	
	widget.keyup 
		keyCode:keys.a
		ctrlKey:false
		shiftKey:false
		altKey:false
	
	assertThat event, notNullValue()

test "Widgets should provide a way to reset the target input to its original state", ->
	
	target = $("<input type='text' value='foo'></input>")

	widget = new Widget target[0]
	widget.set "value", "hello"

	assertThat target.attr("value"), equalTo "hello"

	widget.reset()

	assertThat target.attr("value"), equalTo "foo"

test "Readonly widgets shouldn't allow to modify its value", ->

	widget = new Widget 
	widget.set "value", "Hello"
	widget.set "readonly", true

	widget.set "value", "Goodbye"

	assertThat widget.get("value"), equalTo "Hello"

test "Widgets should be able to grab focus", ->
	
	focusReceived = false

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
		focus:(e)->
			focusReceived = true

	widget = new MockWidget

	widget.grabFocus()

	assertThat focusReceived

test "Widgets should be able to release the focus", ->
	focusReceived = false
	blurReceived = false

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
		focus:(e)->
			focusReceived = true
		blur:(e)->
			blurReceived = true
	
	widget = new MockWidget

	widget.grabFocus()

	assertThat focusReceived

	widget.releaseFocus()

	assertThat blurReceived

test "Disabled widgets shouldn't allow focus", ->
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"

	widget = new MockWidget
	widget.set "disabled", true

	assertThat widget.focus(), equalTo false
	assertThat widget.dummy.attr("tabindex"), nullValue()

test "Widget's properties getters and setters should be overridable in children classes", ->
	setterCalled = false

	class MockWidget extends Widget
		set_value:( property, value )->
			setterCalled = true
		
	widget = new MockWidget
	widget.set "value", "foo"

	assertThat setterCalled

test "Widget's custom properties should be overridable in children classes", ->
	setterCalled = false

	class MockWidgetA extends Widget
		constructor:(target)->
			super target
			@createProperty "foo", "bar"
		
		set_foo:( property, value )->
			value

	class MockWidgetB extends MockWidgetA
		set_foo:( property, value )->
			setterCalled = true
			super property, value
		
	widget = new MockWidgetB
	widget.set "foo", "hello"

	assertThat setterCalled
	assertThat widget.get("foo"), equalTo "hello"

test "Widget's value setter shouldn't dispatch a value changed when set is called with the current value", ->

	widget = new Widget
	signalCallCount = 0

	widget.valueChanged.add ->
		signalCallCount++

	widget.set "value", "hello"
	widget.set "value", "hello"
	
	assertThat signalCallCount, equalTo 1

test "When both target and dummy exist and target as a style attribute, the value should be copied to the dummy", ->
	
	target = $("<input type='text' style='width: 100px;'></input>")[0]
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget target

	assertThat widget.dummy.attr("style"), equalTo "width: 100px;" 

test "Widgets should provide a way to know when the widget don't allow interaction", ->

	widget = new Widget

	assertThat not widget.cantInteract()

test "Widgets should provide a way to know when the widget don't allow interaction", ->

	widget = new Widget
	widget.set "disabled", true

	assertThat widget.cantInteract()

test "Widgets should provide a way to know when the widget don't allow interaction", ->

	widget = new Widget
	widget.set "readonly", true

	assertThat widget.cantInteract()

test "Widgets should provides a way to add a class to its dummy", ->
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget

	widget.addClasses "bar", "owl"

	assertThat widget.dummy.attr("class"), contains "bar"
	assertThat widget.dummy.attr("class"), contains "owl"

test "Widgets should provides a way to remove a class from its dummy", ->
	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo bar owl'></span>"
	
	widget = new MockWidget

	widget.removeClasses "bar", "owl"

	assertThat widget.dummy.attr("class"), hamcrest.not contains "bar"
	assertThat widget.dummy.attr("class"), hamcrest.not contains "owl"

test "Widgets should provide an id property that is mapped to the dummy", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo' id='hola'></span>"
	
	widget = new MockWidget

	assertThat widget.dummy.attr("id"), equalTo "hola"

	widget.set "id", "foo"

	assertThat widget.dummy.attr("id"), equalTo "foo"

test "Setting a null id should remove the attribute from the dummy", ->

	class MockWidget extends Widget
		createDummy:->
			$ "<span class='foo'></span>"
	
	widget = new MockWidget

	widget.set "id", "foo"
	widget.set "id", null

	assertThat widget.dummy.attr("id"), equalTo undefined
test "Widgets should mark their target with a specific class", ->

	target = $("<input type='text'></input>")
	widget = new Widget target[0]

	assertThat target.hasClass "widget-done"






	


