class MockWidget extends Widget
		createDummy:->
			$ "<span></span>"

module "container tests"

test "A container should have children", ->

	container = new Container

	assertThat container.children, allOf notNullValue(), arrayWithLength 0

test "A container should allow to add children", ->

	container = new Container

	container.add new MockWidget

	assertThat container.children, arrayWithLength 1

test "A container should prevent to add a null child", ->
	
	container = new Container

	container.add null

	assertThat container.children, arrayWithLength 0

test "A container should prevent to add an object which is not a widget", ->

	container = new Container

	container.add {}

	assertThat container.children, arrayWithLength 0

test "A container should allow to add a child that is an instance of a widget subclass", ->

	container = new Container

	container.add new MockWidget

	assertThat container.children, arrayWithLength 1

test "A container should prevent to add the same child twice", ->

	container = new Container
	child = new MockWidget

	container.add child
	container.add child

	assertThat container.children, array child

test "A container should allow to remove a previously added child", ->

	container = new Container
	child = new MockWidget

	container.add child
	container.remove child

	assertThat container.children, arrayWithLength 0

test "A container shouldn't proceed when remove is called with null", ->

	container = new Container
	child = new MockWidget
	
	container.add child
	container.remove null

	assertThat container.children, arrayWithLength 1

test "A container shouldn't proceed when remove is called with an object that isn't a widget", ->
	
	container = new Container
	child = new MockWidget
	
	container.add child
	container.remove {}

	assertThat container.children, arrayWithLength 1

test "A container shouldn't proceed when remove is called with a widget which is not a child", ->

	container = new Container
	child = new MockWidget
	notChild = new MockWidget
	
	container.add child
	container.remove notChild

	assertThat container.children, arrayWithLength 1

test "A container should have a dummy", ->

	container = new Container

	assertThat container.dummy, notNullValue()

test "Adding a widget in a container should add its dummy as a child of the container's one", ->

	container = new Container
	child = new MockWidget
	
	container.add child

	assertThat container.dummy.children().length, equalTo 1
	assertThat container.dummy.children()[0], equalTo child.dummy[0]

test "Removing a widget should remove its dummy from the container's one", ->

	container = new Container
	child = new MockWidget
	
	container.add child	
	container.remove child	

	assertThat container.dummy.children().length, equalTo 0

test "Widgets added as child of a container should be able to access its parent", ->

	container = new Container
	child = new MockWidget

	container.add child

	assertThat child.parent is container

test "Widgets that are no longer a child of a container shouldn't hold a reference to it anymore", ->

	container = new Container
	child = new MockWidget

	container.add child
	container.remove child

	assertThat child.parent is null

test "A container should prevent to take focus when one of its child receive it", ->

	widget = new MockWidget
	container = new Container

	container.add widget

	widget.dummy.focus()

	assertThat not container.hasFocus

test "Keyboard commands that can't be found in children should be bubbled to the parent", ->

	keyDownCommandCalled = false
	keyUpCommandCalled = false

	class MockContainer extends Container
		triggerKeyDownCommand:(e)->
			keyDownCommandCalled = true
		
		triggerKeyUpCommand:(e)->
			keyUpCommandCalled = true

	widget = new MockWidget
	container = new MockContainer

	container.add widget

	event = keyCode:16,	ctrlKey:true, shiftKey:true, altKey:true

	widget.triggerKeyDownCommand event	
	widget.triggerKeyUpCommand event	
	
	assertThat keyDownCommandCalled
	assertThat keyUpCommandCalled
	


