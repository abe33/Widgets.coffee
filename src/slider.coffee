# A Slider is a widget that allow to manipulate a numeric
# value within a given range with a sliding knob.
#
# The `Slider` class extends `NumericWidget` and reuse all
# the behavior of the base class.
#
# Here some live instances : 
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var slider1 = new Slider();
# var slider2 = new Slider();
# var slider3 = new Slider();
# 
# slider1.valueCenteredOnKnob = true;
# slider2.valueCenteredOnKnob = true;
# slider3.valueCenteredOnKnob = true;
# 
# slider1.set("value", 12);
# slider2.set("value", 45);
# slider3.set("value", 78);
# 
# slider2.set( "readonly", true );
# slider2.set( "checked", true );
# slider3.set( "disabled", true );
# 
# $("#livedemos").append( slider1.dummy );
# $("#livedemos").append( slider2.dummy );
# $("#livedemos").append( slider3.dummy );
# </script>
class Slider extends NumericWidget
    constructor:( target )->
        super target

        #### Dragging properties

        # The `draggingKnob` property is a boolean that indicates
        # whether the user is currently dragging the knob or not.
        @draggingKnob = false

        # The position of the mouse is stored during drag operation.
        @lastMouseX = 0 
        @lastMouseY = 0 

        # A property that allow the `value` span to be 
        # centered with the knob.
        @valueCenteredOnKnob = true

        if @hasDummy then @updateDummy @get("value"), @get("min"), @get("max")
    
    #### Target management

    # The target for a `Slider` must be an input with the type `range`.
    checkTarget:( target )->
        unless @isInputWithType target, "range"
            throw "Slider target must be an input with a range type" 

    #### Mouse controls
    #
    # The knob child of the slider can be dragged to modify
    # the slider's value. 

    # Initiate a drag gesture.
    startDrag:(e)->
        @draggingKnob = true

        # The mouse position is stored when the drag gesture
        # starts. 
        @lastMouseX = e.pageX
        @lastMouseY = e.pageY

        # The slider then register itself to the document's 
        # `mousemove` and `mouseup` events. 
        # It ensure that the slider keeps to receive events
        # even when the mouse is outside of the slider.
        $(document).bind "mouseup", @documentMouseUpDelegate = (e)=>
            @endDrag()
        
        $(document).bind "mousemove", @documentMouseMoveDelegate = (e)=>
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
        change = Math.round( normalizedValue * ( max - min ) )

        # To finally being added to the `value` property.
        @set "value", @get("value") + change 

        # The current mouse position is then stored for the
        # next drag call.
        @lastMouseX = e.pageX
        @lastMouseY = e.pageY
    
    # When the drag ends the slider unregister from the document's
    # events. 
    endDrag:->
        @draggingKnob = false

        $(document).unbind "mousemove", @documentMouseMoveDelegate
        $(document).unbind "mouseup",   @documentMouseUpDelegate
    
    # Mouse events are converted in dragging data by
    # calculating the distance two mouse moves.
    getDragDataFromEvent:(e)->
        x:e.pageX - @lastMouseX
        y:e.pageY - @lastMouseY
        
    # Pressing the mouse button over the knob start
    # the drag gesture.
    handleKnobMouseDown:(e)->
        # The knob's drag is not allowed for a readonly
        # or a disabled slider.
        unless @cantInteract()
            @startDrag e
            @grabFocus()
            # The default behavior is prevented. Otherwise, 
            # dragging the knob will end up to initiate a copy/paste
            # drag gesture at the browser level.
            e.preventDefault()
    
    # Pressing the mouse button over the track change 
    # the value and start the drag gesture.
    handleTrackMouseDown:(e)->
        unless @cantInteract()
            track = @dummy.children ".track"
            min = @get "min"
            max = @get "max"

            # The new value of the slider is the value in the
            # range corresponding to the position of the mouse
            # relatively to the track.
            x = e.pageX - @dummy.offset().left
            v = x / track.width()

            @set "value", min + max * v

            # Other than the value change, the track behave
            # as the knob do.
            @handleKnobMouseDown e
            
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
            
        # The slider register to the `mousedown` events
        # of its track and its knob.    
        dummy.children(".knob").bind "mousedown", (e)=>
            @handleKnobMouseDown e
        
        dummy.children(".track").bind "mousedown", (e)=>
            @handleTrackMouseDown e

        dummy
    
    # Updates the dummy according to the slider's data.
    updateDummy:( value, min, max, step )->

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
    

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.Slider = Slider
