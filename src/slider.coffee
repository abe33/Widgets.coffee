# A Slider is a widget that allow to manipulate a numeric
# value within a given range with a sliding knob.
class Slider extends Widget
	constructor:( target )->

		# A `Slider` handles only inputs with the type `range`. 
		if target? and $(target).attr("type") isnt "range"
			throw "Slider target must be an input with a range type" 

		super target

		#### Shared Properties
		#
		# The `min`, `max` and `step` attributes of the range input are handled
		# by the  `Slider` class. Each of them is a number.

		# The `min` property represent the lower bound of the slider's range.
		@createProperty "min",  parseFloat @valueFromAttribute "min",  0
		# The `max` property represent the upper bound of the slider's range.
		@createProperty "max",  parseFloat @valueFromAttribute "max",  100
		# The `step` property represent the gap between legible values.
		@createProperty "step", parseFloat @valueFromAttribute "step", 1
		# The `value` property is a number so the data from the target is parsed before affectation.
		@properties.value = 	parseFloat @valueFromAttribute "value",0

		#### Dragging properties

		# The `draggingKnob` property is a boolean that indicates
		# whether the user is currently dragging the knob or not.
		@draggingKnob = false

		# The position of the mouse is stored during drag operation.
		@lastMouseX = 0 
		@lastMouseY = 0 

		# An optional property that allow the `value` span to be 
		# centered with the knob.
		@valueCenteredOnKnob = false

		#### Keyboard controls

		# Use the `Up` and `Down` arrow on the keyboard to increment
		# or decrement the value by the amount of the `step` property.
		@registerKeyDownCommand keystroke( keys.up ), @startIncrement
		@registerKeyUpCommand keystroke( keys.up ), @endIncrement

		@registerKeyDownCommand keystroke( keys.down ), @startDecrement
		@registerKeyUpCommand keystroke( keys.down ), @endDecrement

		# Keyboard action is performed through an interval.
		@incrementInterval = -1

		if @hasDummy then @updateDummy @get("value"), @get("min"), @get("max")

		@hideTarget()
	
	#### Value manipulation
	
	# Ensure that the passed-in value match all the constraints
	# of this slider.
	#
	# The returned value can be safely affected to the `value` 
	# property.
	cleanValue:( value, min, max, step )->
		if value < min 
			value = min 
		else if value > max 
			value = max
		
		value - ( value % step )
	
	# Increment the value of the amount of the `step` property. 
	increment:->
		@set "value", @get("value") + @get("step")
	
	# Decrement the value of the amount of the `step` property.
	decrement:->
		@set "value", @get("value") - @get("step")
	
	#### Mouse controls
	#
	# The knob child of the slider can be dragged to modify
	# the slider's value. 

	startDrag:(e)->
		# The knob's drag is not allowed for a readonly
		# or a disabled slider.
		unless @get("readonly") or @get("disabled")
			@draggingKnob = true

			# The mouse position is stored when the drag gesture
			# starts. 
			@lastMouseX = e.pageX
			@lastMouseY = e.pageY

			# The slider then register itself to the document's 
			# `mousemove` and `mouseup` events. 
			# It ensure that the slider keeps to receive events
			# even when the mouse is outside of the slider.
			$(document).bind "mouseup", =>
				@endDrag()
			
			$(document).bind "mousemove", (e)=>
				@drag e
	
	# During the drag, the slider converts the data
	# in the mouse event object to drag related data.
	drag:(e)->
		data = @getDragDataFromEvent e

		width     = @dummy.width()
		knob      = @dummy.children ".knob"
		knobWidth = knob.width()

		# The dragging data is then normalized.
		normalizedValue = data.x / ( width - knobWidth )

		# And adjusted to the current range.
		min = @get "min"
		max = @get "max"
		value = Math.round( normalizedValue * ( max - min ) )

		# To finally being added to the `value` property.
		@set "value", @get("value") + value 

		# The current mouse position is then stored for the
		# next drag call.
		@lastMouseX = e.pageX
		@lastMouseY = e.pageY
	
	# When the drag ends the slider unregister from the document's
	# events. 
	endDrag:->
		@draggingKnob = false

		$(document).unbind "mousemove mouseup"
	
	# Mouse events are converted in dragging data by
	# calculating the distance two mouse moves.
	getDragDataFromEvent:(e)->
		x:e.pageX - @lastMouseX
		y:e.pageY - @lastMouseY
	
	#### Events handlers 

	# Using the mouse wheel, the value is either incremented
	# or decremented according to the event's delta.
	mousewheel:( event, delta, deltaX, deltaY )->
		unless @get("readonly") or @get("disabled")
			@set "value", @get("value") + delta * @get "step"
		false
		
	#### Keyboard commands

	# Initiate the increment interval when the `up` key is pressed.
	startIncrement:->
		unless @get("readonly") or @get("disabled")
			if @incrementInterval is -1 then @incrementInterval = setInterval =>
				@increment()
			, 50
			
	# Initiate the decrement interval when the `down` key is pressed.
	startDecrement:->
		unless @get("readonly") or @get("disabled")
			if @incrementInterval is -1 then @incrementInterval = setInterval =>
				@decrement()
			, 50
	
	# Ends the increment interval when the `up` key is released.
	endIncrement:->
		clearInterval @incrementInterval
		@incrementInterval = -1
	
	# Ends the decrement interval when the `down` key is released.
	endDecrement:->
		clearInterval @incrementInterval
		@incrementInterval = -1

	
	#### Dummy management

	# The dummy of the `Slider` widget is a parent `<span>` with
	# a `slider` class and three `<span>` child to represent respectively
	# the slider's `track`, `knob` and `value`.
	createDummy:->
		dummy = $  "<span class='slider'>
						<span class='track'></span>
						<span class='knob'></span>
						<span class='value'></span>
				   	</span>"
		
		# Pressing the mouse button over the knob starts
		# the drag gesture.
		dummy.children(".knob").bind "mousedown", (e)=>
			@startDrag e
			@grabFocus()
			# The default behavior is prevented. Otherwise, 
			# dragging the knob will end up to initiate a copy/paste
			# drag gesture at the browser level.
			e.preventDefault()
		
		dummy
	
	# Updates the dummy according to the slider's data.
	updateDummy:( value, min, max )->

		width     = @dummy.width()
		knob      = @dummy.children ".knob"
		val       = @dummy.children ".value"
		knobWidth = knob.width()
		valWidth  = val.width() 

		# The knob left offset is calculated with the current size
		# of the slider and the current size of the knob. 
		knobPos = ( width - knobWidth ) * ( ( value - min ) / ( max - min ) )
		knob.css "left", knobPos

		# The `value` child text is updated with the current slider's
		# value. 
		val.text value

		# If the `valueCenteredOnKnob` property is `true`, then the
		# `value` child's left offset property is also updated.
		if @valueCenteredOnKnob 
			valPos = ( knobPos + knobWidth / 2 ) - valWidth / 2 
			val.css "left", valPos
		else
			val.css "left", "auto"
		
	#### Properties accessors
	
	# When setting the `value` property, the passed-in
	# new value is first cleaned to fit in the slider's 
	# range.
	set_value:( property, value )->
		min = @get "min"
		max = @get "max"
		step = @get "step"

		value = @cleanValue value, min, max, step

		@updateDummy value, min, max

		super property, value
	
	# The `min` property cannot be greater than the `max` property.
	#
	# The value is adjusted to the `min` bound if it drop below with
	# the new `min` value.
	set_min:( property, value )->
		max = @get "max"
		if value >= max
			@get "min"
		else
			step = @get "step"
			@valueToAttribute property, value
			@set "value", @cleanValue @get( "value"), value, max, step 
			value
	
	# The `min` property cannot be lower than the `min` property.
	#
	# The value is adjusted to the `max` bound if it climb above with
	# the new `max` value.	
	set_max:( property, value )->
		min = @get "min"
		if value <= min
			@get "max"
		else
			step = @get "step"
			@valueToAttribute property, value
			@set "value", @cleanValue @get( "value"), min, value, step 
			value
	
	# Changing the `step` property can alter the `value` property
	# if the current value doesn't snap to the new step grid.
	set_step:( property, value )->
		min = @get "min"
		max = @get "max"
		@valueToAttribute property, value
		@set "value", @cleanValue @get( "value"), min, max, value 
		value
	

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.Slider = Slider
