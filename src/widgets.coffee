# A Widget allow to work with or without a target `<input>` node, and provides
# methods to reflect changes done on the widget onto its target. 
class Widget

	# Pass a `<input>` node to the constructor to define the widget's target.
	# An error is raised if the passed-in node's name is not `input` or if
	# the arguments is not a node.
	constructor:( target )->

		if target? and target.nodeName?.toLowerCase?() isnt "input" 
			throw "Widget's target must be an input node"
		
		#### Widget signals
		
		# The `propertyChanged` signal is dispatched when a call 
		# to the `set` method is performed.
		#
		# *Callback arguments*
		#
		#  * `widget`    : The widget that was modified.
		#  * `property`  : The property that was modified.
		#  * `value`     : The new value for this property.
		@propertyChanged = new Signal
		
		# The `valueChanged` signal is dispatched when the `value`
		# property of the widget is modified.
		#
		# *Callback arguments*
		#
		#  * `widget`    : The widget that was modified.
		#  * `value`     : The new value for this widget.
		@valueChanged 	 = new Signal
		
		# The `stateChanged` signal is dispatched when the state
		# of the widget's dummy is modified.
		#
		# *Callback arguments*
		#
		#  * `widget`    : The widget that was modified.
		#  * `state`     : The new state of the dummy.
		@stateChanged 	 = new Signal

		#### Widget's target related properties.
		
		# The `jTarget` property contains the `jQuery` object
		# for the target. However, if `target` is `null`, 
		# the `jTarget` property will be `null` as well.
		@target    = target
		@hasTarget = target? 
		@jTarget   = if @hasTarget then $ target else null

		#### Shared Properties
		
		# The shared properties represent the properties of the input that 
		# are available from and reflected on the widget. These properties
		# are accessible only through the `get` and `set` method. 
		# For instance, to disable the widget use the following code:
		#
		#     widget.set "disabled", true
		
		# Default properties's values are retreived from the target or set to 
		# `undefined` if there's no target specified.
		@properties = 
			disabled : @booleanFromAttribute "disabled"
			readonly : @booleanFromAttribute "readonly"
			value    : @valueFromAttribute   "value"
			name     : @valueFromAttribute   "name"
		
		# Dummy creation is done in the `createDummy` method.
		@dummy = @createDummy()
		@hasDummy = @dummy?
		@hasFocus = false

		# The `dummyStates` property stores the list of shared properties that
		# should be reflected as a class on the dummy. The order of the states
		# in the list are preserved in the dummy's class attribute.
		@dummyStates = [ "disabled", "readonly" ]

		# Additional setup if a target have been specified
		if @hasTarget

			# Storing the initial value for reset.
			@targetInitialValue = @valueFromAttribute "value"

			# Bind target's change event to handle it internally.
			@jTarget.bind "change", (e)=>
				@targetChange(e)

		# Additional setup if a dummy have been created.
		if @hasDummy

			# Enforce the ability of the dummy to receive focus if enabled.
			@setFocusable not @get "disabled"

			# The original class of the dummy is stored for later use.
			@dummyClass = @dummy.attr "class"
			
			# The style set on the target is copied on the dummy.
			if @hasTarget then @dummy.attr "style", @jTarget.attr "style" 
			
			@registerToDummyEvents()
			@updateStates()
		
		# Other setup
		@keyDownCommands = {}
		@keyUpCommands = {}

	#### Shared Properties accessors
	# 
	# Since changes made on the widget should be reflected 
	# on the target, its necessary to provide an accessor-like
	# mechanism. 
	
	# The `get` and `set` methods provides this mechanism.
	# Custom accessors can be specified for these properties. 
	# Accessors definition can be done in the `createProperty`
	# method below.
	get:( property )->
		if "get_#{property}" of this 
			@[ "get_#{property}" ].call this, property 
		else 
			@properties[ property ]
	
	set:( property, value )->
		if property of @properties
			@properties[ property ] = if "set_#{property}" of this
				@[ "set_#{property}" ].call this, property, value
			else 
				value

			@updateStates()		
			@propertyChanged.dispatch this, property, value
	
	# Creates a new property for this widget, optionally accessors functions
	# can be provided. In any case, the property will be readable and writable.
	#
	# Accessors functions are called with the current widget as scope. 
	#
	# The setter accessor must return the final value for the property, and have
	# to take care of the reflection of the changes on the target. 
	#
	# When creating a new property in a children class, define the accessors 
	# functions as methods in the class body to allow overrides in subclasses.
	createProperty:( property, value=undefined, setter=null, getter=null )->
		@properties[ property ] = value

		if setter? then @[ "set_#{property}" ] = setter
		if getter? then @[ "get_#{property}" ] = getter
				
	# The accessors functions for the widget's properties.
	#
	# Setters accessors are prefixed with `set_` and getters's one with `get_`.
	set_disabled:( property, value )->
		# Disabled widget don't allow to receive focus.
		@setFocusable not value
		@booleanToAttribute property, value
	
	set_readonly:( property, value )->
		@booleanToAttribute property, value

	set_value:( property, value )->
		# Read-only widgets don't allow to modify their values.
		if @get "readonly" 
			@get property
		else 
			if value isnt @get "value"
				@valueToAttribute property, value
				@valueChanged.dispatch this, value
			value
	
	set_name:(property, value)->
		@valueToAttribute property, value
	
	#### Target management

	# Hide the target if provided.
	hideTarget:->
		if @hasTarget
			@jTarget.hide()
	
	# Reset the target as a `<input type='reset'>` could do. 
	reset:->
		@set "value", @targetInitialValue

	# A placeholder for the target's change event.
	targetChange:(e)->
	
	#### Dummy management

	# Returns `true` when the widget is not in a state that allow
	# a change to the value with a user interaction.
	cantInteract:->
		@get("readonly") or @get("disabled")

	# A placeholder for dummy creation. 
	# The method must return the dummy jQuery object.
	createDummy:->
	
	# Updates the state of the dummy according to the current values
	# in the widget's properties. 
	updateStates:->
		if @hasDummy
			oldState = @dummy.attr "class"
			newState = ""
			for state in @dummyStates
				if @get state
					if newState.length > 0
						newState += " "
					
					newState += state
			
			# Original and state classes are concatened 
			# to produce the output dummy class.
			outputState = if @dummyClass? and newState isnt ""
				@dummyClass + " " + newState
			else if @dummyClass?
				@dummyClass
			else 
				newState
			
			if outputState isnt oldState
				@dummy.attr "class", outputState
				@stateChanged.dispatch this, newState
			
	#### Dummy Events Handling 

	# Register this widget to the events of its dummy. 
	registerToDummyEvents:->
		@dummy.bind @supportedEvents, (e)=>
			@[e.type].apply this, arguments 
	
	# Unregister all the events from the dummy.
	unregisterFromDummyEvents:->
		@dummy.unbind @supportedEvents
	
	# The list of the dummy's events supported by the widget. All these events
	# are catched by the methods with the corresponding name in the widget class.
	supportedEvents:"mousedown mouseup mousemove mouseover mouseout mousewheel 
					 click dblclick focus blur keyup keydown keypress"

    # Override these placeholders to implement the concret events
    # handlers of a widget class.
    #
    # **Note:** Be aware that, unfortunately, all browsers doesn't
    # support the `focus` and `blur` events on nodes other than
    # `input`, `textarea`, `select` and `a`. And since keyboard events
    # on DOM objects are only available when the object has the focus
    # you will lose the keyboard events as side effect.
	mousedown:(e)->
		true
	mouseup:(e)->
		true
	mousemove:(e)->
		true
	mouseover:(e)->
		true
	mouseout:(e)->
		true
	mousewheel:(e,d)->
		true
	click:(e)->
		true
	dblclick:(e)->
		true
	# Default behavior is to allow focus only if the widget is enabled.
	focus:(e)->
		@hasFocus = true
		not @get "disabled"
	blur:(e)->
		@hasFocus = false
		true
	# Trigger the command registered with the `keydown` event if any.
	keydown:(e)->
		@triggerKeyDownCommand e
	# Trigger the command registered with the `keyup` event if any.
	keyup:(e)->
		@triggerKeyUpCommand e
	keypress:(e)->
		true	
	
	#### Focus management

	# Set the focusable state of the dummy. It simply toggle the `tabindex` attributes
	# on the dummy to ensure that it cannot receive focus.
	setFocusable:( allowFocus )->
		if @hasDummy
			if allowFocus then @dummy.attr "tabindex", 0 else @dummy.removeAttr "tabindex" 
	
	# Place the focus on this widget.
	grabFocus:->
		if @hasDummy then @dummy.focus()
	
	# Remove the focus from this widget.
	releaseFocus:->
		if @hasDummy then @dummy.blur()
	
	#### Keyboard shortcuts management

	# Register the passed-in function to be triggered
	# when the `keystroke` is matched on `keydown`.
	registerKeyDownCommand:( keystroke, command )->
		@keyDownCommands[ keystroke ] = [ keystroke, command ]
	
	# Register the passed-in function to be triggered
	# when the `keystroke` is matched on `keyup`.
	registerKeyUpCommand:( keystroke, command )->
		@keyUpCommands[ keystroke ] = [ keystroke, command ]
	
	# Returns `yes` if the passed-in keystroke have been associated
	# with a command for this widget's `keydown` event.
	hasKeyDownCommand:( keystroke )->
		keystroke of @keyDownCommands

	# Returns `yes` if the passed-in keystroke have been associated
	# with a command for this widget's `keyup` event.
	hasKeyUpCommand:( keystroke )->
		keystroke of @keyUpCommands
	
	# Takes a keyboard event object and trigger 
	# the corresponding command on a `keydown`.
	triggerKeyDownCommand:( e )->
		for key, [ keystroke, command ] of @keyDownCommands
			if keystroke.match e 
				return command.call this, e
		true

	# Takes a keyboard event object and trigger 
	# the corresponding command on a `keyup`.
	triggerKeyUpCommand:( e )->
		for key, [ keystroke, command ] of @keyUpCommands
			if keystroke.match e 
				return command.call this, e
		true
		
	#### Useful methods to deal with reflection between widget's properties and target's attributes

	# Uses theses methods to retreive or copy data from the target's attributes. 
	valueFromAttribute:( property, defaultValue=undefined )->
		if @hasTarget then @jTarget.attr property else defaultValue
		
	valueToAttribute:( property, value )->
		if @hasTarget then @jTarget.attr property, value 
		value
	
	# The following two methods handle the special case of attributes 
	# for which only presence is meaningful.
	booleanFromAttribute:( property, defaultValue=undefined )->
		if @hasTarget then @jTarget.attr( property ) isnt undefined else defaultValue

	booleanToAttribute:( property,value )->
		if @hasTarget
			if value then @jTarget.attr property, property else @jTarget.removeAttr property
		value

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.Widget = Widget
