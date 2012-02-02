# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# The `NumericWidget` class is a base class for number manipulation widget.
# Both the `Slider` and `Stepper` classes extends the `NumericWidget` class.
class NumericWidget extends Widget
    constructor:(target)->

        super target
        
        #### Shared Properties
        #
        # The `min`, `max` and `step` attributes of the range or number inputs are handled
        # by the  `NumericWidget` class. Each of them is a number.

        # The `min` property represent the lower bound of the value's range.
        @createProperty "min",  parseFloat @valueFromAttribute "min",  0
        # The `max` property represent the upper bound of the value's range.
        @createProperty "max",  parseFloat @valueFromAttribute "max",  100
        # The `step` property represent the gap between legible values.
        @createProperty "step", parseFloat @valueFromAttribute "step", 1
        # The `value` property is a number so the data from the target is parsed before affectation.
        @properties.value =     parseFloat @valueFromAttribute "value",0

        # `NumericWidget` provides a way to increment or decrement the value on an interval.
        @incrementInterval = -1

        #### Keyboard controls

        # Use the `Up` or `Left` arrows on the keyboard to increment
        # the value by the amount of the `step` property. 
        @registerKeyDownCommand keystroke( keys.up ), @startIncrement
        @registerKeyUpCommand keystroke( keys.up ), @endIncrement

        @registerKeyDownCommand keystroke( keys.right ), @startIncrement
        @registerKeyUpCommand keystroke( keys.right ), @endIncrement

        # Use the `Down` or `Right` arrows on the keyboard to decrement
        # the value by the amount of the `step` property.
        @registerKeyDownCommand keystroke( keys.down ), @startDecrement
        @registerKeyUpCommand keystroke( keys.down ), @endDecrement

        @registerKeyDownCommand keystroke( keys.left ), @startDecrement
        @registerKeyUpCommand keystroke( keys.left ), @endDecrement

        # Target is hidden if provided.
        @hideTarget()

    #### Value manipulation
    
    # Ensure that the passed-in `value` match all the constraints
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
    
    # Initiate the increment interval.
    startIncrement:->
        unless @cantInteract()
            if @incrementInterval is -1 then @incrementInterval = setInterval =>
                @increment()
            , 50
        # `startIncrement` returns `false` to prevent default behavior when used 
        # as an event callback.
        false
            
    # Initiate the decrement interval.
    startDecrement:->
        unless @cantInteract()
            if @incrementInterval is -1 then @incrementInterval = setInterval =>
                @decrement()
            , 50
        # `startDecrement` returns `false` to prevent default behavior when used 
        # as an event callback.
        false
    
    # Ends the increment interval.
    endIncrement:->
        clearInterval @incrementInterval
        @incrementInterval = -1
    
    # Ends the decrement interval.
    endDecrement:->
        clearInterval @incrementInterval
        @incrementInterval = -1
    
    #### Dummy management

    # Overrides this method to implement your own dummy
    # update routine. 
    #
    # You should only use the data from the arguments, since
    # the `updateDummy` method can be called before the
    # widget's properties change.
    updateDummy:( value, min, max, step )->

    #### Properties accessors
    
    # When setting the `value` property, the passed-in
    # new value is first cleaned to fit in the widget's 
    # range of values.
    set_value:( property, value )->
        min = @get "min"
        max = @get "max"
        step = @get "step"

        value = @cleanValue value, min, max, step

        @updateDummy value, min, max, step

        super property, value
    
    # The `min` property cannot be greater than the `max` property.
    #
    # The value is adjusted to the `min` bound if it drop below with
    # the new `min` value.
    set_min:( property, value )->
        max = @get "max"
        if value >= max
            return @get "min"
        else
            step = @get "step"
            @valueToAttribute property, value
            @set "value", @cleanValue @get( "value"), value, max, step 
            return @properties[ property ] = value
    
    # The `min` property cannot be lower than the `min` property.
    #
    # The value is adjusted to the `max` bound if it climb above with
    # the new `max` value.  
    set_max:( property, value )->
        min = @get "min"
        if value <= min
            return @get "max"
        else
            step = @get "step"
            @valueToAttribute property, value
            @set "value", @cleanValue @get( "value"), min, value, step 
            return @properties[ property ] = value
    
    # Changing the `step` property can alter the `value` property
    # if the current value doesn't snap to the new step grid.
    set_step:( property, value )->
        min = @get "min"
        max = @get "max"
        @valueToAttribute property, value
        @set "value", @cleanValue @get( "value"), min, max, value 
        @properties[ property ] = value
    
    #### Events handlers 

    # Using the mouse wheel, the value is either incremented
    # or decremented according to the event's delta.
    mousewheel:( event, delta, deltaX, deltaY )->
        unless @get("readonly") or @get("disabled")
            @set "value", @get("value") + delta * @get "step"
        false
    

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.NumericWidget = NumericWidget