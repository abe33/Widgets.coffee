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
# <script type='text/javascript'
#         src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
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
# stepper1.attach("#livedemos");
# stepper2.attach("#livedemos");
# stepper3.attach("#livedemos");
# </script>
class Stepper extends NumericWidget

    @mixins FocusProvidedByChild

    constructor:(target)->
        super target

        unless @get("step")? then @set "step", 1

        @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

    #### Target management

    # The target for a `Stepper` must be an input with the type `number`.
    checkTarget:( target )->
        unless @isInputWithType target, "number"
            throw new Error """Stepper target must be an input
                               with a number type"""

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

        @focusProvider = dummy.children("input")
        down = dummy.children(".down")
        up = dummy.children(".up")

        # Pressing on the buttons starts an increment or decrement
        # interval according to the pressed button.
        buttonsMousedown = (e)=>
            e.stopImmediatePropagation()

            @mousePressed = true

            # The function that start and end the interval
            # are stored locally according to the pressed button.
            switch e.target
                when down[0]
                    startFunction = @startDecrement
                    endFunction   = @endDecrement
                when up[0]
                    startFunction = @startIncrement
                    endFunction   = @endIncrement

            # Initiate the interval.
            startFunction.call this
            # And register a callback to stop the interval on `mouseup`.
            $(document).bind "mouseup", @documentDelegate = (e)=>
                @mousePressed = false
                endFunction.call this
                $(document).unbind "mouseup", @documentDelegate

        down.bind "mousedown", buttonsMousedown
        up.bind "mousedown", buttonsMousedown

        # When the mouse go out of the button while
        # an interval is runnung, the interval is stopped.
        down.bind "mouseout", =>
            if @incrementInterval isnt -1 then @endDecrement()
        up.bind "mouseout", =>
            if @incrementInterval isnt -1 then @endIncrement()

        # Until the mouse came back over the button.
        down.bind "mouseover", =>
            if @mousePressed then @startDecrement()
        up.bind "mouseover", =>
            if @mousePressed then @startIncrement()

        dummy

    # The states of the widget is reflected on the widget's input.
    updateStates:->
        super()

        if @get "readonly" then @focusProvider.attr "readonly", "readonly"
        else @focusProvider.removeAttr "readonly"

        if @get "disabled" then @focusProvider.attr "disabled", "disabled"
        else @focusProvider.removeAttr "disabled"

    # The value of the widget is displayed within its input.
    updateDummy:( value, min, max, step )->
        @focusProvider.val value

    # When the value of the input is changed, the new value go through
    # the validation function.
    validateInput:->
        # The input's value is parsed to a float.
        value = parseFloat @focusProvider.attr("value")

        # And if the resulting value is a number, it's affected
        # to this widget's value.
        unless isNaN value
            @set "value", value
        else
            @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

    #### Events Handlers

    # Changes made to the input lead to an input validation.
    change:( e )-> @validateInput()

    # Releasing the mouse over the widget will force the focus on the
    # input. That way, clicking on the increment and decrement button
    # will also give the focus to the widget.
    mouseup:->
        if @get "disabled" then return true

        @grabFocus()

        if @dragging
            $(document).unbind "mousemove", @documentMouseMoveDelegate
            $(document).unbind "mouseup",   @documentMouseUpDelegate
            @dragging = false

        true

    # The `Stepper` allow to drag the mouse vertically to change the value.
    mousedown:(e)->
        if @cantInteract() then return true

        @dragging = true
        @pressedY = e.pageY

        $(document).bind "mousemove",
                         @documentMouseMoveDelegate =(e)=> @mousemove e
        $(document).bind "mouseup",
                         @documentMouseUpDelegate   =(e)=> @mouseup e

    # The value is changed on the basis that a move of 1 pixel
    # change the value of the amount of `step`.
    mousemove:(e)->
        if @dragging
            y = e.pageY
            dif = @pressedY - y
            @set "value", @get("value") + dif * @get("step")
            @pressedY = y


@Stepper = Stepper
