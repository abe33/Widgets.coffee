# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# The `mixins.coffe` file contains the set of mixins that are used
# by widgets.
#
# The file contains the following definitions:
#
# * [ValueInRange](ValueInRange)
# * [FocusProvidedByChild](FocusProvidedByChild)

# <a name="ValueInRange"></a>
#### ValueInRange Mixin
#
# ValueInRange provides a coherent behavior accross the widgets
# which value can be constrained in a range through the `min`,
# `max` and `step` attributes of their respective targets.
#
# The `ValueInRange` mixin doesn't provides any setters for the
# `min`, `max` and `step` properties. The class that receive the
# mixin should define them to ensure bounds validity and value
# collision.
ValueInRange=
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
        if min? and value < min then value = min
        else if max? and value > max then value = max

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
        unless @cantInteract()
            if delta > 0 then @increment() else @decrement()
        # `mousewheel` returns `false` to prevent the page to scroll.
        false

# <a name="FocusProvidedByChild"></a>
#### FocusProvidedByChild Mixin
#
# Allow a widget to handle the focus trough one of its child.
#
# For instance, A widget that should allow the user to input
# a value with the keyboard will contains a `text` input.
# In that case, the widget focus should be provided by the input
# to have only one focusable element (not both the widget and its input)
# and to allow to write in the input as soon as the widget get
# the focus, whatever the means lead the widget to get the focus.
FocusProvidedByChild=
    # The constructor hook will register focus related events
    # on the `focusProvider` child. The widget receiving the
    # mixin should ensure that the property is set before
    # the hook call.
    constructorHook:->
        @focusProvider.bind @focusRelatedEvents, (e)=>
            @[e.type].apply this, arguments

    #### Focus management

    # There's no need for the dummy to be able to receive the focus. So
    # the dummy will never have the `tabindex` attribute set.
    setFocusable:->

    # Grabbing the focus for this widget is giving the focus to its child.
    grabFocus:->
        @focusProvider.focus()

    #### Events handling

    # Since focus related events will be provided by another object,
    # the events that the widget will receive from its dummy is reduced.
    supportedEvents:[
        "mousedown", "mouseup",     "mousemove", "mouseover",
        "mouseout",  "mousewheel",  "click",     "dblclick",
    ].join " "

    # Since keyboard events can only be received from the element
    # that have the focus, the widget will listen the keyboard events
    # from the focus provider and not from the dummy.
    focusRelatedEvents:[
       "focus",     "blur",         "keyup",     "keydown",
       "keypress",  "input",        "change",
    ].join " "

    # Both unregister events from the dummy and from the focus provider.
    unregisterFromDummyEvents:->
        @focusProvider.unbind @focusRelatedEvents
        @super "unregisterFromDummyEvents"

    # Releasing the mouse over the widget gives it the focus.
    mouseup:(e)->
        unless @get "disabled" then @grabFocus()
        true

HasChild=
    constructorHook:->
        # Children widgets are stored in an array in the
        # `children` property.
        @children = []

    #### Children management

    # Use the `add` method to add child to this container.
    add:( child )->
        # Only widgets that are not already a child are allowed.
        if child? and child.isWidget and child not in @children
            @children.push child

            # When a child widget is added to a `container`,
            # its dummy is appended to the container's dummy.
            child.attach @dummy

            # Widgets can acces their parent through the `parent` property.
            child.parent = this

    # Use the `remove` method to remove a child from this container.
    remove:( child )->
        # Only widgets that are already a children of this container
        # can be removed.
        if child? and child in @children
            @children.splice @children.indexOf( child ), 1

            # The child's dummy is then detached from the container's dummy.
            child.detach()


            # The children no longer hold a reference to its previous
            # parent at the end of the call.
            child.parent = null

    # The dummy for a `Container` is a single `span` with
    # a `container` class on it.
    createDummy:->
        $ "<span class='container'></span>"

    focus:(e)->
        if e.target is @dummy[0]
            @super "focus", e


@HasChild             = HasChild
@ValueInRange         = ValueInRange
@FocusProvidedByChild = FocusProvidedByChild

