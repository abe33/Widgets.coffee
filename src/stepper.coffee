# A `Stepper` is a widget that allow the manipulation of
# a number through a text input and two buttons to increment
# or decrement the value.
#
# Here some live instances : 
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../widgets.js'></script>
#
# <script type='text/javascript'>
# var stepper1 = new Stepper();
# var stepper2 = new Stepper();
# var stepper3 = new Stepper();
# 
# stepper2.set( "readonly", true );
# stepper2.set( "checked", true );
# stepper3.set( "disabled", true );
# 
# $("#livedemos").append( stepper1.dummy );
# $("#livedemos").append( stepper2.dummy );
# $("#livedemos").append( stepper3.dummy );
# </script>
class Stepper extends NumericWidget
	constructor:(target)->
		# A stepper only allow a target of type `number`.
		if target? and $(target).attr("type") isnt "number"
			throw "Stepper target must be an input with a number type" 

		super target

		@updateDummy @get("value"), @get("min"), @get("max"), @get("step")
	
	#### Dummy management

	# The dummy for a stepper widget is a span containing :
	# 
	# * A `text` input that allow to type a value directly.
	# * A span that act as the decrement button.
	# * A span that act as the increment button.
	createDummy:->
		dummy = $ "<span class='stepper'>
				<input type='text' class='value'></input>
				<span class='down'></span>
				<span class='up'></span>
		   </span>"
		
		input = dummy.children("input")
		down = dummy.children(".down")
		up = dummy.children(".up")
		
		# Changing the value of the widget's input trigger
		# the input validation function. 
		input.bind "change", =>
			@validateInput()
		
		# Pressing on the buttons start an increment or decrement
		# interval according to the pressed button.
		down.bind "mousedown", =>
			@startDecrement()
		down.bind "mouseup", =>
			@endDecrement()
		
		up.bind "mousedown", =>
			@startIncrement()
		up.bind "mouseup", =>
			@endIncrement()

		dummy
	
	# The states of the widget is reflected on the widget's input.
	updateStates:->
		super()
		input = @dummy.children(".value")
		if @get "readonly" then input.attr "readonly", "readonly" else input.removeAttr "readonly"
		if @get "disabled" then input.attr "disabled", "disabled" else input.removeAttr "disabled"
	
	# The value of the widget is displayed within its input.
	updateDummy:( value, min, max, step )->
		input = @dummy.children(".value")
		input.attr "value", value

	#### Events handling
	#
	# The stepper widget is a special case, as it don't receive 
	# focus directly of its dummy.
	# Instead, whenever the focus is given to the widget, 
	# its the widget's input that will receive it.
	
	# In the same way, keyboard inputs are handled from the input
	# and not from the dummy.
	inputSupportedEvents:"focus blur keyup keydown keypress"

	supportedEvents:"mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick"

	# In this regards, the events registrations methods are overridden.
	registerToDummyEvents:->
		@dummy.children(".value").bind @inputSupportedEvents, (e)=>
			@[e.type].apply this, arguments 
		super()
	
	unregisterFromDummyEvents:->
		@dummy.children(".value").unbind @inputSupportedEvents
		super()
	
	# When the value of the input is changed, the new value go through
	# the validation function.
	validateInput:->
		# The input's value is parsed to a float.
		value = parseFloat @dummy.children("input").attr("value")

		# And if the resulting value is a number, it's affected
		# to this widget's value.
		unless isNaN value
			@set "value", value
		else
			@updateDummy @get("value"), @get("min"), @get("max"), @get("step")
	
	#### Focus management

	# There's no need for the dummy to be able to receive the focus. So
	# a `Stepper` dummy will never have the `tabindex` attribute set.
	setFocusable:->

	# Grabbing the focus for this widget is giving the focus to its input.
	grabFocus:->
		@dummy.children(".value").focus()
	
	# Releasing the mouse over the widget will force the focus on the 
	# input. That way, clicking on the increment and decrement button
	# will also give the focus to the widget.
	mouseup:->
		@grabFocus()	
		true

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.Stepper = Stepper