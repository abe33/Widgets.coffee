
class Slider extends Widget
	constructor:( target )->
		if target? and $(target).attr("type") isnt "range"
			throw "Slider target must be an input with a range type" 

		super target

		@valueCenteredOnKnob = false

		@createProperty "min",  @valueFromAttribute "min",  0
		@createProperty "max",  @valueFromAttribute "max",  100
		@createProperty "step", @valueFromAttribute "step", 1
		@properties.value = 	@valueFromAttribute "value",0
	
	#### Properties accessors
	
	set_value:( property, value )->
		min = @get "min"
		max = @get "max"
		step = @get "step"

		value = @cleanValue value, min, max, step

		@updateDummy value, min, max

		super property, value
	
	set_min:( property, value )->
		max = @get "max"
		if value >= max
			@get "min"
		else
			step = @get "step"
			@valueToAttribute property, value
			@set "value", @cleanValue @get( "value"), value, max, step 
			value
		
	set_max:( property, value )->
		min = @get "min"
		if value <= min
			@get "max"
		else
			step = @get "step"
			@valueToAttribute property, value
			@set "value", @cleanValue @get( "value"), min, value, step 
			value
	
	set_step:( property, value )->
		min = @get "min"
		max = @get "max"
		@valueToAttribute property, value
		@set "value", @cleanValue @get( "value"), min, max, value 
		value
	
	#### Value manipulation
	
	cleanValue:( value, min, max, step )->
		if value < min 
			value = min 
		else if value > max 
			value = max
		
		value - ( value % step )
	
	#### Dummy management

	createDummy:->
		$  "<span class='slider'>
				<span class='track'></span>
				<span class='knob'></span>
				<span class='value'></span>
		   	</span>"
	
	updateDummy:( value, min, max )->

		width     = @dummy.width()
		knob      = @dummy.children ".knob"
		val       = @dummy.children ".value"
		knobWidth = knob.width()
		valWidth  = val.width() 

		knobPos = ( width - knobWidth ) * ( ( value - min ) / ( max - min ) )
		knob.css "left", knobPos

		val.text value

		if @valueCenteredOnKnob 
			valPos = ( knobPos + knobWidth / 2 ) - valWidth / 2 
			val.css "left", valPos
		else
			val.css "left", "auto"


# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.Slider = Slider
