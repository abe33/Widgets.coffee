# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# The `mixins.coffe` file contains the set of mixins that are used
# by widgets.
#
# The file contains the following definitions:
#
# * [HasValueInRange](HasValueInRange)
# * [Spinner](Spinner)
# * [HasFocusProvidedByChild](HasFocusProvidedByChild)
# * [HasChildren](HasChildren)
# * [DropDownPopup](DropDownPopup)

# <a name="HasValueInRange"></a>
## HasValueInRange

# HasValueInRange provides a coherent behavior accross the widgets
# which value can be constrained in a range through the `min`,
# `max` and `step` attributes of their respective targets.
#
# The `HasValueInRange` mixin doesn't provides any setters for the
# `min`, `max` and `step` properties. The class that receive the
# mixin should define them to ensure bounds validity and value
# collision.
HasValueInRange=
  # The constructor hook initialize the shared properties and
  # creates the keyboard bindings for trigger increment and
  # decrement intervals.
  constructorHook:->
    # The `min` property represent the lower bound of the value's range.
    @min = null
    # The `max` property represent the upper bound of the value's range.
    @max = null
    # The `step` property represent the gap between legible values.
    @step = null

    #### Keyboard Controls

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

  #### Events Handlers

  # Using the mouse wheel, the value is either incremented
  # or decremented according to the event's delta.
  mousewheel:( event, delta, deltaX, deltaY )->
    unless @cantInteract()
      if delta > 0 then @increment() else @decrement()
    # `mousewheel` returns `false` to prevent the page to scroll.
    false

# <a name="Spinner"></a>
## Spinner
Spinner=
  #### Dummy Management

  # The dummy for a spinner widget is a span containing :
  #
  # * A `text` input that allow to type a value directly.
  # * A span that act as the decrement button.
  # * A span that act as the increment button.
  createDummy:->
    dummy = $ "<span class='#{ @spinnerDummyClass }'>
        <input type='text' class='value widget-done'></input>
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
    @super "updateStates"

    if @get "readonly" then @focusProvider.attr "readonly", "readonly"
    else @focusProvider.removeAttr "readonly"

    if @get "disabled" then @focusProvider.attr "disabled", "disabled"
    else @focusProvider.removeAttr "disabled"

  #### Events Handlers

  # Changes made to the input lead to an input validation.
  change:( e )-> @validateInput()
  input:( e )->

  # Releasing the mouse over the widget will force the focus on the
  # input. That way, clicking on the increment and decrement button
  # will also give the focus to the widget.
  mouseup:->
    return true if @get "disabled"

    @grabFocus()

    if @dragging
      $(document).unbind "mousemove", @documentMouseMoveDelegate
      $(document).unbind "mouseup",   @documentMouseUpDelegate
      @dragging = false

    true

  # A `Spinner` allow to drag the mouse vertically to change the value.
  mousedown:(e)->
    return true if @cantInteract()

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
      @drag dif
      @pressedY = y

  #### Placeholder Functions

  validateInput:->
  drag:( dif )->

# <a name="HasFocusProvidedByChild"></a>
## HasFocusProvidedByChild

# Allow a widget to handle the focus trough one of its child.
#
# For instance, A widget that should allow the user to input
# a value with the keyboard will contains a `text` input.
# In that case, the widget focus should be provided by the input
# to have only one focusable element (not both the widget and its input)
# and to allow to write in the input as soon as the widget get
# the focus, whatever the means lead the widget to get the focus.
HasFocusProvidedByChild=
  # The constructor hook will register focus related events
  # on the `focusProvider` child. The widget receiving the
  # mixin should ensure that the property is set before
  # the hook call.
  constructorHook:->
    @focusProvider.bind @focusRelatedEvents, (e)=>
      @[e.type].apply this, arguments

  #### Focus Management

  # There's no need for the dummy to be able to receive the focus. So
  # the dummy will never have the `tabindex` attribute set.
  setFocusable:->

  # Grabbing the focus for this widget is giving the focus to its child.
  grabFocus:->
    @focusProvider.focus()

  #### Events Handling

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
    @grabFocus() unless @get "disabled"
    true

# <a name="HasChildren"></a>
## HasChildren

# Allow a widget to have widgets as children.
HasChildren=
  constructorHook:->
    # Children widgets are stored in an array in the
    # `children` property.
    @children = []

  #### Children Management

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
    $("<span class='container'></span>")

  # Focus on the widget is prevented if the focus target
  # is one of its children.
  focus:(e)->
    @super "focus", e if e.target is @dummy[0]


# <a name="DropDownPopup"></a>
## DropDownPopup

# A  `DropDownPopup` widget is a widget which display is triggered
# by and bound to another widget.
DropDownPopup=
  constructorHook:->
    # A drop down popup is hidden at creation.
    @dummy.hide()

    # Using the `Enter` key while editing a color comfirm the edit
    # and close the drop down popup.
    @registerKeyDownCommand keystroke( keys.enter ), @comfirmChangesOnEnter
    # Using the `Escape` ket while editing abort the current edit
    # and close the drop down popup.
    @registerKeyDownCommand keystroke( keys.escape ), @abortChanges

  #### Display Management

  # Handles the *opening* of the popup.
  open:->
    # The drop down popup register itself to catch clicks done
    # outside of it. When it occurs the drop down popup will close
    # itself and call the `comfirmChanges` method.
    $(document).bind "mouseup", @documentDelegate=(e)=>
      @comfirmChanges()

    # The dummy is placed below the widget that requested
    # the drop down popup.
    @dummy.css("left", @caller.dummy.offset().left )
          .css("top",  @caller.dummy.offset().top +
                 @caller.dummy.height() )
          .css("position", "absolute")
          # The dummy is then displayed.
          .show()

    # At the end of the request the drop down popup gets the focus.
    @grabFocus()

  # Hides the dummy of this drop down popup.
  close:->
    @dummy.hide()
    $(document).unbind "mouseup", @documentDelegate

    @caller.grabFocus()

  #### Signals Handlers

  # Receive a signal from a `caller` object that need the drop down popup
  # to appear.
  dialogRequested:( caller )->
    @caller = caller
    @setupDialog caller
    @open()

  #### Events Handlers

  # Prevents the click on the dummy to bubble to the `document` object.
  mouseup:(e)-> e.stopImmediatePropagation()

  #### Placeholder Functions

  # Placeholder functions that you can overrides to implements the concrete
  # comfirmation/cancelation routines of your widget.
  abortChanges:-> @close()
  comfirmChanges:->
  comfirmChangesOnEnter:->
  setupDialog:( caller )->


@Spinner                 = Spinner
@DropDownPopup           = DropDownPopup
@HasChildren             = HasChildren
@HasValueInRange         = HasValueInRange
@HasFocusProvidedByChild = HasFocusProvidedByChild

