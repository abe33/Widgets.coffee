# The `mixins.coffe` file contains the set of mixins that are used
# by widgets.
#
# The file contains the following definitions:
#
# * [DropDownPopup](DropDownPopup)
# * [HasChildren](HasChildren)
# * [HasFocusProvidedByChild](HasFocusProvidedByChild)
# * [HasMenuModel](HasMenuModel)
# * [HasMultiSelection](HasMultiSelection)
# * [HasOptions](HasOptions)
# * [HasPopupMenuList](HasPopupMenuList)
# * [HasSingleSelection](HasSingleSelection)
# * [HasValueInRange](HasValueInRange)
# * [Spinner](Spinner)

# <a name ="HasValueInRange"></a>
## HasValueInRange

# HasValueInRange provides a coherent behavior accross the widgets
# which value can be constrained in a range through the `min`,
# `max` and `step` attributes of their respective targets.
#
# The `HasValueInRange` mixin doesn't provides any setters for the
# `min`, `max` and `step` properties. The class that receive the
# mixin should define them to ensure bounds validity and value
# collision.
HasValueInRange =
  # The constructor hook initialize the shared properties and
  # creates the keyboard bindings for trigger increment and
  # decrement intervals.
  constructorHook: ->
    # The `min` property represent the lower bound of the value's range.
    @min = null
    # The `max` property represent the upper bound of the value's range.
    @max = null
    # The `step` property represent the gap between legible values.
    @step = null

    #### Keyboard Controls

    # Use the `Up` or `Left` arrows on the keyboard to increment
    # the value by the amount of the `step` property.
    @registerKeyDownCommand keystroke(keys.up), @startIncrement
    @registerKeyUpCommand   keystroke(keys.up), @endIncrement

    @registerKeyDownCommand keystroke(keys.right), @startIncrement
    @registerKeyUpCommand   keystroke(keys.right), @endIncrement

    # Use the `Down` or `Right` arrows on the keyboard to decrement
    # the value by the amount of the `step` property.
    @registerKeyDownCommand keystroke(keys.down), @startDecrement
    @registerKeyUpCommand   keystroke(keys.down), @endDecrement

    @registerKeyDownCommand keystroke(keys.left), @startDecrement
    @registerKeyUpCommand   keystroke(keys.left), @endDecrement

  # Ensure that the passed-in `value` match all the constraints
  # defined on the target of the current widget.
  #
  # The returned value should be safely affected to the `value`
  # property.
  fitToRange: (value, min, max) ->
    if min? and value < min then value = min
    else if max? and value > max then value = max

    @snapToStep value

  # Override this method to implement the concrete snapping.
  snapToStep: (value) -> value

  #### Intervals Management

  # Stores the interval id. When not running, `intervalId`
  # is always `-1`.
  intervalId: -1

  # Increment the value of the amount of the `step` property.
  # Override the method in the class that receive the mixin.
  increment: ->

  # Decrement the value of the amount of the `step` property.
  # Override the method in the class that receive the mixin.
  decrement: ->

  # Initiate the increment interval if interaction are allowed
  # on the widget.
  startIncrement: ->
    unless @cantInteract()
      if @intervalId is -1 then @intervalId = setInterval =>
        @increment()
      , 50
    # `startIncrement` returns `false` to prevent default behavior
    # when used as an event callback.
    false

  # Initiate the decrement interval if interaction are allowed
  # on the widget.
  startDecrement: ->
    unless @cantInteract()
      if @intervalId is -1 then @intervalId = setInterval =>
        @decrement()
      , 50
    # `startDecrement` returns `false` to prevent default behavior
    # when used as an event callback.
    false

  # Ends the increment interval.
  endIncrement: ->
    clearInterval @intervalId
    @intervalId = -1

  # Ends the decrement interval.
  endDecrement: ->
    clearInterval @intervalId
    @intervalId = -1

  #### Events Handlers

  # Using the mouse wheel, the value is either incremented
  # or decremented according to the event's delta.
  mousewheel: (event, delta, deltaX, deltaY) ->
    unless @cantInteract()
      if delta > 0 then @increment() else @decrement()
    # `mousewheel` returns `false` to prevent the page to scroll.
    false

# <a name ="Spinner"></a>
## Spinner

# A `Spinner` is a widget that contains a text input and two buttons
# to manipulate a value in a range. A `Spinner` also provides basic
# behaviors such value manipulation through keyboard and mouse drag.
Spinner =
  #### Dummy Management

  # The dummy for a `Spinner` widget is a span containing :
  #
  #  * A `text` input that allow to type a value directly.
  #  * A span that act as the decrement button.
  #  * A span that act as the increment button.
  createDummy: ->
    dummy = $ "<span class='#{ @spinnerDummyClass }'>
                <input type='text' class='value widget-done'></input>
                <span class='down'></span>
                <span class='up'></span>
               </span>"

    # The `Spinner` can, and should, be used with
    # the `HasFocusProvidedByChild` mixin.
    @focusProvider = dummy.children("input")

    # Caching queries for later uses.
    down = dummy.children(".down")
    up = dummy.children(".up")

    # Pressing on the buttons starts an increment or decrement
    # interval according to the pressed button.
    buttonsMousedown = (e) =>
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
      $(document).bind "mouseup", @documentDelegate = (e) =>
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
  updateStates: ->
    @super "updateStates"

    if @get "readonly" then @focusProvider.attr "readonly", "readonly"
    else @focusProvider.removeAttr "readonly"

    if @get "disabled" then @focusProvider.attr "disabled", "disabled"
    else @focusProvider.removeAttr "disabled"

  #### Events Handlers

  # Changes made to the input lead to an input validation.
  change: (e) -> @validateInput()
  input: (e) ->

  # Releasing the mouse over the widget will force the focus on the
  # input. That way, clicking on the increment and decrement button
  # will also give the focus to the widget.
  mouseup: ->
    return true if @get "disabled"

    @grabFocus()

    if @dragging
      $(document).unbind "mousemove", @documentMouseMoveDelegate
      $(document).unbind "mouseup",   @documentMouseUpDelegate
      @dragging = false

    true

  # A `Spinner` allow to drag the mouse vertically to change the value.
  mousedown: (e) ->
    return true if @cantInteract()

    @dragging = true
    @pressedY = e.pageY

    $(document).bind "mousemove",
             @documentMouseMoveDelegate = (e) => @mousemove e
    $(document).bind "mouseup",
             @documentMouseUpDelegate   = (e) => @mouseup e

  # The value is changed on the basis that a move of 1 pixel
  # change the value of the amount of `step`.
  mousemove: (e) ->
    if @dragging
      y = e.pageY
      dif = @pressedY - y
      @drag dif
      @pressedY = y

  #### Placeholder Functions

  validateInput: ->
  drag: (dif) ->

# <a name ="HasFocusProvidedByChild"></a>
## HasFocusProvidedByChild

# Allow a widget to handle the focus trough one of its child.
#
# For instance, A widget that should allow the user to input
# a value with the keyboard will contains a `text` input.
# In that case, the widget focus should be provided by the input
# to have only one focusable element (not both the widget and its input)
# and to allow to write in the input as soon as the widget get
# the focus, whatever the means lead the widget to get the focus.
HasFocusProvidedByChild =
  # The constructor hook will register focus related events
  # on the `focusProvider` child. The widget receiving the
  # mixin should ensure that the property is set before
  # the hook call.
  constructorHook: ->
    @focusProvider.bind @focusRelatedEvents, (e) =>
      @[e.type].apply this, arguments

  #### Focus Management

  # There's no need for the dummy to be able to receive the focus. So
  # the dummy will never have the `tabindex` attribute set.
  setFocusable: ->

  # Grabbing the focus for this widget is giving the focus to its child.
  grabFocus: ->
    @focusProvider.focus()

  #### Events Handling

  # Since focus related events will be provided by another object,
  # the events that the widget will receive from its dummy is reduced.
  supportedEvents: [
    "mousedown", "mouseup",     "mousemove", "mouseover",
    "mouseout",  "mousewheel",  "click",     "dblclick",
  ].join " "

  # Since keyboard events can only be received from the element
  # that have the focus, the widget will listen the keyboard events
  # from the focus provider and not from the dummy.
  focusRelatedEvents: [
    "focus",     "blur",         "keyup",     "keydown",
    "keypress",  "input",        "change",
  ].join " "

  # Both unregister events from the dummy and from the focus provider.
  unregisterFromDummyEvents: ->
    @focusProvider.unbind @focusRelatedEvents
    @super "unregisterFromDummyEvents"

  # Releasing the mouse over the widget gives it the focus.
  mouseup: (e) ->
    @grabFocus() unless @get "disabled"
    true

# <a name ="HasChildren"></a>
## HasChildren

# Allow a widget to have widgets as children.
HasChildren =
  constructorHook: ->
    # Children widgets are stored in an array in the
    # `children` property.
    @children = []

  #### Children Management

  # Use the `add` method to add child to this container.
  add: (child) ->
    # Only widgets that are not already a child are allowed.
    if child? and child.isWidget and child not in @children
      @children.push child

      # When a child widget is added to a `container`,
      # its dummy is appended to the container's dummy.
      child.attach @dummy

      # Widgets can acces their parent through the `parent` property.
      child.parent = this

  # Use the `remove` method to remove a child from this container.
  remove: (child) ->
    # Only widgets that are already a children of this container
    # can be removed.
    if child? and child in @children
      @children.splice @children.indexOf(child), 1

      # The child's dummy is then detached from the container's dummy.
      child.detach()


      # The children no longer hold a reference to its previous
      # parent at the end of the call.
      child.parent = null

  # Focus on the widget is prevented if the focus target
  # is one of its children.
  focus: (e) ->
    @super "focus", e if e.target is @dummy[0]

# <a name ="DropDownPopup"></a>
## DropDownPopup

# A  `DropDownPopup` widget is a widget which display is triggered
# by and bound to another widget.
DropDownPopup =
  constructorHook: ->
    # A drop down popup is hidden at creation.
    @dummy.hide()

    # Using the `Enter` key while editing a color comfirm the edit
    # and close the drop down popup.
    @registerKeyDownCommand keystroke(keys.enter), @comfirmChangesOnEnter
    # Using the `Escape` ket while editing abort the current edit
    # and close the drop down popup.
    @registerKeyDownCommand keystroke(keys.escape), @abortChanges

  #### Display Management

  # Handles the *opening* of the popup.
  open: ->
    # The drop down popup register itself to catch clicks done
    # outside of it. When it occurs the drop down popup will close
    # itself and call the `comfirmChanges` method.
    $(document).bind "mouseup", @documentDelegate = (e) =>
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
  close: ->
    @dummy.hide()
    $(document).unbind "mouseup", @documentDelegate

    @caller.grabFocus()

  #### Signals Handlers

  # Receive a signal from a `caller` object that need the drop down popup
  # to appear.
  dialogRequested: (caller) ->
    @caller = caller
    @setupDialog caller
    @open()

  #### Events Handlers

  # Prevents the click on the dummy to bubble to the `document` object.
  mouseup: (e) -> e.stopImmediatePropagation()

  #### Placeholder Functions

  # Placeholder functions that you can overrides to implements the concrete
  # comfirmation/cancelation routines of your widget.
  abortChanges: -> @close()
  comfirmChanges: ->
  comfirmChangesOnEnter: ->
  setupDialog: (caller) ->

# <a name="HasMenuModel"></a>
## HasMenuModel

# The `HasMenuModel` mixin provides a widget with the ability of owning
# a `MenuModel`.
HasMenuModel =

  # Returns the path to the specified value.
  #
  # The `model` argument is optionnal and allow
  # to use the `findValue` method recursively.
  findValue: (value, model = @model) ->
    # If the value is `null` or if it's an empty string
    # the function returns `null`.
    return null if not value? or value is ""

    # The search result for the pass are stored in an array.
    passResults = null
    for item in model.items
      # If an item's value of the current value is the searched
      # value, the index of this item in the current model is
      # set as the pass result.
      if item.value is value
        passResults = [_i]
        break
      # If the item is a sub-model, a sub-pass is processed.
      else if item.menu?
        subPassResults = @findValue value, item.menu
        # If the sub-pass returns a result, the sub-model
        # index is added to the pass result with the result
        # of the sub-pass.
        if subPassResults?
          passResults = [_i].concat subPassResults
          break

    passResults

  # Returns the item at `path` in the model.
  # If the `path` argument is `null` or if the
  # path lead to a dead end, the function returns
  # `null`.
  getItemAt: (path) ->
    return unless path?

    model = @model
    item = null
    for step in path
      item = model.items[step]
      return null unless item?

      model = item.menu if item?.menu?

    item

  # Returns the last model that contains the item at `path`.
  # If the `path` argument is `null` or if the path lead
  # to a dead end, the function returns `null`.
  getModelAt: (path) ->
    return if path is null

    model = @model
    item = null
    for step in path
      item = model.items[step]
      return null unless item?

      model = item.menu if item?.menu?

    model

  #### Properties Accessors

  # Changes the model of this widget.
  set_model: (property, value) ->
    @model?.contentChanged.remove @modelChanged, this
    @model = value
    @model?.contentChanged.add @modelChanged, this
    value

  #### Placeholder Function

  # Called whenever the model changed.
  modelChanged: ->


# <a name="HasOptions"></a>
## HasOptions

# A mixin that handles `option` node within a select and manage a `MenuModel`
# builded with these options.
HasOptions =

  #### Model Management

  # The `modelFromOptions` automatically construct a `MenuModel`
  # corresponding to the current target.
  #
  # The `optgroup` nodes are handled as sub-models when `option`
  # nodes are actually the models's items.
  #
  # By contrast with the native select widget, the nested
  # options groups are preserved in the data structure. Each
  # `optgroup` will appear as a submenu in a `MenuList` and
  # will open a new `MenuList` with the data of the `optgroup`.
  modelFromOptions: (model, node) ->
    node.each (i, o) =>
      option = $(o)
      if o.nodeName.toLowerCase() is "optgroup"
        # Sub-models are represented by an object that
        # have a `menu` property that contains a `MenuModel`
        # instance.
        model.add
          display: @getOptionLabel option
          # Nodes traversing is done recursively.
          menu: @modelFromOptions new MenuModel, option.children()
      else
        # Model's items are represented by an object that
        # have both a `value` and an `action` property.
        value = @getOptionValue(option)
        model.add
          display: @getOptionLabel option
          value: value

    model

  #### Options Management

  # Removes all the `option` nodes in the target.
  clearOptions: ->
    @jTarget.children().remove()

  # Build the content of the target based on the current model's data.
  optionsFromModel: (model = @model, target = @jTarget) ->

    for act in model.items
      if act.menu?
        group = $("<optgroup label='#{act.display}'></optgroup>")
        target.append group
        @optionsFromModel act.menu, group
      else
        act.action = ( => @set "value", act.value) unless act.action?
        target.append $("<option value='#{act.value}'>#{act.display}</option>")
  # Returns the label to use for a given `option` or `optgroup` node.
  # If provided the `label` attribute will have the priority. If not
  # the node content will be used instead.
  getOptionLabel: (option) ->
    return null unless option?
    if option.attr "label" then option.attr "label" else option.text()

  # Returns the value to use for a given `option` node.
  # If provided the `value` attribute will have the priority. If not
  # the node content will be used instead.
  getOptionValue: (option) ->
    return null unless option?
    if option.attr "value" then option.attr "value" else option.text()

  # Returns the `option` or `optgroup` node at the specified `path`.
  # If the `path` argument is `null` or if the path lead to a dead end
  # the function returns `null`
  getOptionAt: (path) ->
    return null if path is null

    option = null
    if @hasTarget
      children = @jTarget.children()
      for step in path
        option = children[step]
        children = $(option).children() if option?.nodeName

    if option? then $(option) else null

# <a name="HasPopupMenuList"></a>
## HasPopupMenuList

# A mixin that allow a widget to own a `MenuList` that displays
# the content of the widget's `MenuModel`.
#
# The `HasPopupMenuList` should be used in combination with the `HasMenuModel`
# mixin.
HasPopupMenuList =
  # Creates a `MenuList` instance for this widget.
  # The same model is shared between the widget and
  # its `MenuList`.
  buildMenu: ->
    @menuList = new MenuList @model

  # Opens the `MenuList` for this instance.
  openMenu: ->
    unless @cantInteract()
      # Pressing the mouse on the document when the `MenuList` is
      # opened will close the menu.
      $(document).bind "mousedown", @documentDelegate = (e) =>
        @documentMouseDown e

      @adjustMenu()
      # The `MenuList` dummy is appended directly on the document body.
      @menuList.attach "body"
      # The focus is then placed on the `MenuList`.
      @menuList.grabFocus()
      @displayMenuSelection()

  # Closes the `MenuList` for this instance.
  closeMenu: ->
    @menuList.close()
    # When the `MenuList` is closed, the widget
    # recover the focus.
    @grabFocus()

    $(document).unbind "mousedown", @documentDelegate

  # Returns `true` is the `MenuList` is currently present in the DOM.
  isMenuVisible: ->
    @menuList.dummy.parent().length is 1

  #### Placeholder Functions

  # Overrides the `displayMenuSelection` method to implements
  # the changes on the `MenuList` that should occurs according
  # to the selection.
  displayMenuSelection: ->

  # Overrides the `adjustMenu` method to implement the positionning
  # of the `MenuList` when opened by this widget.
  adjustMenu: ->

  #### Events Handlers

  # Pressing the mouse over the document will close the menu.
  #
  # There's no need to test the position of the mouse since
  # both the widget and its `MenuList` stop the propagation
  # of the event and prevents the document to catch it.
  documentMouseDown: (e) -> @closeMenu()

# <a name="HasSingleSelection"></a>
## HasSingleSelection

# The `HasSingleSelection` provides a widget with the ability
# to select an item within a `MenuModel`.
#
# The `HasSingleSelection` mixin should be used in combination
# with the `HasMenuModel` and the `HasOptions` mixins.
HasSingleSelection =

  constructorHook: ->
    # The path to the selected item is stored in an array
    # containing the index of each elements in the path.
    @selectedPath = null

    # Pressing the `up` or `down` keys when the widget has the
    # focus will move the selection up or down accordingly.
    #
    # When moving the selection with the keyboard, the data
    # structure appear to be flatten. The selection cursor
    # automatically enters or leaves group to find the next
    # value.
    @registerKeyDownCommand keystroke(keys.up),    @moveSelectionUp
    @registerKeyDownCommand keystroke(keys.down),  @moveSelectionDown

  # Updates the state of the target accordingly with
  # the current selection of the widget.
  updateOptionSelection: () ->
    @getOptionAt(@selectedPath)?.attr "selected", "selected"

  # Finds the next selectionable item in the model.
  #
  # When the next item is a sub-model, the search continue
  # in the sub-model. In the same way, when there's no longer
  # an item in the current sub-model, the search continue one
  # level higher after the sub-model.
  #
  # If there's no longer any element after the current path,
  # the search restart from the top.
  findNext: (path) ->
    model = @getModelAt path
    step = path.length - 1
    newPath = path.concat()
    newPath[step]++

    nextItem = @getItemAt newPath

    while not nextItem? or nextItem.menu?
      if nextItem?
        if nextItem.menu?
          newPath.push 0
          step++
      else if step > 0
        step--
        newPath.pop()
        newPath[step]++
        nextItem = @getItemAt newPath
      else
        newPath = [0]

      nextItem = @getItemAt newPath

    newPath

  # Finds the previous selectionable item in the model.
  #
  # When the previous item is a sub-model, the search continue
  # in the sub-model. In the same way, when there's no longer
  # an item in the current sub-model, the search continue one
  # level higher before the sub-model.
  #
  # If there's no longer any element before the current path,
  # the search restart from the bottom.
  findPrevious: (path) ->
    model = @getModelAt path
    step = path.length - 1
    newPath = path.concat()
    newPath[step]--

    previousItem = @getItemAt newPath

    while not previousItem? or previousItem.menu?
      if previousItem?
        if previousItem.menu?
          newPath.push 0
          step++
          newPath[step] = @getModelAt(newPath).size() - 1
      else if step > 0
        step--
        newPath.pop()
        newPath[step]--
        previousItem = @getItemAt newPath
      else
        newPath = [@model.items.length - 1]

      previousItem = @getItemAt newPath

    newPath

  # Moves the selection cursor to the up.
  moveSelectionUp: (e) ->
    e.preventDefault()

    unless @cantInteract()
      @selectedPath = @findPrevious @selectedPath

      @set "value", @getOptionValue @getOptionAt @selectedPath

  # Moves the selection cursor to the down.
  moveSelectionDown: (e) ->
    e.preventDefault()

    unless @cantInteract()
      @selectedPath = @findNext @selectedPath

      @set "value", @getOptionValue @getOptionAt @selectedPath

# <a name="HasMultiSelection"></a>
## HasMultiSelection

# The `HasMultiSelection` provides a widget with the ability
# to select many items within a `MenuModel`.
#
# The `HasMultiSelection` mixin should be used in combination
# with the `HasMenuModel` and the `HasOptions` mixins.
HasMultiSelection =
  constructorHook: ->
    # The selected paths are stored in an array of path.
    @selectedPaths = []

  # Updates the state of the target accordingly with
  # the current selection of the widget.
  updateOptionSelection: ->
    if @hasTarget
      @jTarget.find("option").removeAttr "selected"
      @getOptionAt(p)?.attr("selected", "selected") for p in @selectedPaths

  # Compares two path.
  samePath: (a, b) ->
    return false for v,i in a when v isnt b[i]
    true


@DropDownPopup           = DropDownPopup
@HasChildren             = HasChildren
@HasFocusProvidedByChild = HasFocusProvidedByChild
@HasMenuModel            = HasMenuModel
@HasMultiSelection       = HasMultiSelection
@HasOptions              = HasOptions
@HasPopupMenuList        = HasPopupMenuList
@HasSingleSelection      = HasSingleSelection
@HasValueInRange         = HasValueInRange
@Spinner                 = Spinner
