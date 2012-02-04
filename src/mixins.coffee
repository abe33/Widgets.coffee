# <link rel="stylesheet" href="../css/styles.css" media="screen">
# 
# The `mixins.coffe` file contains the set of mixins that are used
# by widgets.
#
# The file contains the following definitions: 
#
# * [RangeStepper](RangeStepper)

# <a name="RangeStepper"></a>
#### RangeStepper Mixin 
#
# RangeStepper provides a coherent behavior accross the widgets
# whose value can operate in range through the `min`, `max` and
# `step` attributes of their respective targets.
#
# The `RangeStepper` mixins doesn't provides any setters for the
# `min`, `max` and `step` properties. The class that receive the
# mixin should define them to ensure bounds validity and value 
# collision. 
RangeStepper=
    # The constructor hook initialize the shared properties and 
    # creates the keyboard bindings for trigger increment and
    # decrement intervals.
    constructorHook:->
        # The `min` property represent the lower bound of the value's range.
        @createProperty "min"
        # The `max` property represent the upper bound of the value's range.
        @createProperty "max"
        # The `step` property represent the gap between legible values.
        @createProperty "step"

        #### Keyboard controls

        # Use the `Up` or `Left` arrows on the keyboard to increment
        # the value by the amount of the `step` property. 
        @registerKeyDownCommand keystroke( keys.up ), @startIncrement
        @registerKeyUpCommand   keystroke( keys.up ), @endIncrement 

        @registerKeyDownCommand keystroke( keys.right ), @startIncrement
        @registerKeyUpCommand   keystroke( keys.right ), @endIncrement

        # Use the `Down` or `Right` arrows on the keyboard to decrement
        # the value by the amount of the `step` property.
        @registerKeyDownCommand keystroke( keys.down ), @startDecrement
        @registerKeyUpCommand   keystroke( keys.down ), @endDecrement

        @registerKeyDownCommand keystroke( keys.left ), @startDecrement
        @registerKeyUpCommand   keystroke( keys.left ), @endDecrement
    
    # Ensure that the passed-in `value` match all the constraints
    # defined on the target of the current widget.
    #
    # The returned value should be safely affected to the `value` 
    # property.
    fitToRange:( value, min, max )->
        if value < min then value = min 
        else if value > max then value = max
        
        @snapToStep value
    
    # Override this method to implement the concrete snapping.
    snapToStep:( value )-> value
      
    #### Intervals Management  

    # Stores the interval id. When not running, `intervalId`
    # is always `-1`.
    intervalId:-1

    # Increment the value of the amount of the `step` property.
    # Override the method in the class that receive the mixin. 
    increment:->
    
    # Decrement the value of the amount of the `step` property.
    # Override the method in the class that receive the mixin. 
    decrement:->
    
    # Initiate the increment interval if interaction are allowed
    # on the widget.
    startIncrement:->
        unless @cantInteract()
            if @intervalId is -1 then @intervalId = setInterval =>
                @increment()
            , 50
        # `startIncrement` returns `false` to prevent default behavior
        # when used as an event callback.
        false
            
    # Initiate the decrement interval if interaction are allowed
    # on the widget.
    startDecrement:->
        unless @cantInteract()
            if @intervalId is -1 then @intervalId = setInterval =>
                @decrement()
            , 50
        # `startDecrement` returns `false` to prevent default behavior 
        # when used as an event callback.
        false
    
    # Ends the increment interval.
    endIncrement:->
        clearInterval @intervalId
        @intervalId = -1
    
    # Ends the decrement interval.
    endDecrement:->
        clearInterval @intervalId
        @intervalId = -1
        
    #### Events handlers 

    # Using the mouse wheel, the value is either incremented
    # or decremented according to the event's delta.
    mousewheel:( event, delta, deltaX, deltaY )->
        unless @get("readonly") or @get("disabled")
            if delta > 0 then @increment() else @decrement()
        false

if window?
    window.RangeStepper = RangeStepper

