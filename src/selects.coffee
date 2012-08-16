# This file contains the widget classes that handle the `select` node
# either with or without the `multiple` attribute.
#
# The following definitions are present in this file.
#
#  * [AbstractSelect](#AbstractSelect)
#  * [SingleSelect](#SingleSelect)
#  * [MultiSelect](#MultiSelect)


# <a name='AbstractSelect'></a>
## AbstractSelect

# The `AbstractSelect` provides the basic functionalities to deal
# with `select` nodes.
class AbstractSelect extends Widget

  # Model and options handling are provided by the corresponding mixins.
  @include HasMenuModel, HasOptions

  # An `AbstractSelect` accept either a `select` node or a `MenuModel`
  # as contructor argument.
  constructor: (targetOrModel) ->
    # Stores the maximum visible elements in the `MenuList` as defined
    # by the `size` attributes of `select` nodes.
    @size = null

    # When a `MenuModel` is provided in the constructor, the `AbstractSelect`
    # is initialized without a target.
    if targetOrModel instanceof MenuModel
      super()
      @model = targetOrModel
    else
      super targetOrModel

      # When a target is provided, the model for the `AbstractSelect` object
      # is builded from the data of the target.
      if @hasTarget
        @model = @modelFromOptions new MenuModel, @jTarget.children()
        @size = parseInt @valueFromAttribute "size"
      else
        # Otherwise the `AbstractSelect` is initialized with a new
        # model and a `null` selection path.
        @model = new MenuModel

    # Changes made to the model are listened by the `AbstractSelect`.
    @model.contentChanged.add @modelChanged, this
    @ensureModelCompletion()

  # The setter defined by the `HasMenuModel` is stored to be used in
  # the overriden setter.
  _set_model = @::set_model

  # When the model of this widget change, the `ensureModelCompletion`
  # method is called to validates and complete items if needed.
  set_model: (property, value) ->
    _set_model.call this, property, value
    @ensureModelCompletion()
    value

  # This function make sure that items contained in a `MenuModel` match
  # the criteria for being used by the widget.
  ensureModelCompletion: (model=@model) ->
    for item in model.items
      # Models are processed recursively.
      if item.menu? then @ensureModelCompletion item.menu
      else
        # Items must have an `action` property that is provided
        # by the `buildActionFor` placeholder.
        item.action = @buildActionFor item unless item.action?
        # In case the item wasn't provided with a `value` property,
        # the `value` property is then set with the content of the
        # `display` property.
        item.value = item.display unless item.value?

  #### Placeholder Functions

  # Override this placeholder to provides an action for each each items
  # in a `MenuModel`.
  buildActionFor: (item) ->

  # Override this placeholder to implements the update of `option` nodes
  # according to the current widget selection.
  updateOptionSelection: ->

  #### Slots

  # Overrides of the placeholder from `HasMenuModel`.
  modelChanged: ->
    # We make sure that the items in the models are complete.
    @ensureModelCompletion()

    # If a target is defined, the target's content is rebuilded
    # from the model.
    if @hasTarget
      @clearOptions()
      @optionsFromModel()

    # The fresh options are selected according
    # to the current widget selection.
    @updateOptionSelection()


# <a name='SingleSelect'></a>
## SingleSelect

# `SingleSelect` handles `select` nodes that don't have their `multiple`
# attribute set. `SingleSelect` behave as a drop down menu with the
# possibility to have nested submenus.
class SingleSelect extends AbstractSelect
  # Here some live instances:
  #
  #= require single-selects

  # Selection and `MenuList` management are provided
  # by the corresponding mixins.
  @include HasSingleSelection, HasPopupMenuList

  # A `SingleSelect` accept either a `select` node or a `MenuModel`
  # as contructor argument.
  constructor: (targetOrModel) ->
    super targetOrModel

    # And the value is searched in the target structure to
    # find the current selection path.
    #
    # The selection path is an array of indices of the nodes
    # that lead to the value.
    @selectedPath = @findValue @get("value") if @hasTarget

    # The rest of the setup is then realized.
    @buildMenu()
    @hideTarget()
    @updateDummy()

    #### Keyboard Commands

    # Pressing the `enter` or `space` keys when the widget has
    # the focus will open up the menu list and place the focus
    # on it to allow the keyboard navigation to follow in the
    # menu list.
    @registerKeyDownCommand keystroke(keys.enter), @openMenu
    @registerKeyDownCommand keystroke(keys.space), @openMenu

  #### Target Management

  # Only `select` nodes that doesn't have the `multiple` flag set
  # are allowed as target for a `SingleSelect`.
  checkTarget: (target) ->
    if not @isTag(target, "select") or $(target).attr("multiple")?
      throw new Error "A SingleSelect only allow select nodes as target"

  #### Model Management
  buildActionFor: (item) -> => @set "value", item.value

  #### Dummy Management

  # The dummy for a `SingleSelect` is a span with the class `single-select`
  # and an internal span with the class `value`.
  createDummy: ->
    $ "<span class='single-select'>
         <span class='value'></span>
       </span>"

  # The dummy's `value` span will receive the content of the
  # `display` property of the current selected item.
  updateDummy: ->
    # Assuming the selection path is valid.
    unless @selectedPath is null
      display = @getItemAt(@selectedPath)?.display
    else
      # Otherwise the display will either be the `title` attribute
      # of the target, if defined, or the string `Empty`.
      if @hasTarget and @jTarget.attr("title")
        display = @jTarget.attr("title")
      else
        display = "Empty"

    # After removing the old value, the `display` value is passed
    # as the content for the new `value` span. That's imply that
    # the display for an item could contains any valid HTML code.
    @dummy.find(".value").remove()
    @dummy.append $("<span class='value'>#{display}</span>")

  #### Menu Management

  displayMenuSelection: ->
    # When opening the `MenuList`, the selection path is highlighted.
    # If the selection is contained in a sub-model, the sub-menus will
    # be opened as well.
    unless @selectedPath is null
      list = @menuList
      for step in @selectedPath
        list.select step
        list = list.childList if list.childList

  adjustMenu: ->
    # The `MenuList` is displayed right below the widget
    # on screen.
    left = @dummy.offset().left
    top = @dummy.offset().top + @dummy.height()
    @menuList.dummy.attr "style", "left: #{left}px; top: #{top}px;"

  #### Properties Accessors

  # The only legible values for a `SingleSelect`
  # are those are stored in its model.
  set_value: (property, value) ->
    # In case the new value can't be found in the model, the
    # widget's value will remain unchanged.
    oldValue = @get "value"
    newValue = null
    # The path to the value is searched in the model.
    newPath = @findValue value

    # If the path is not null, then the value is legible,
    # and the selection path is updated.
    if newPath isnt null
      @selectedPath = newPath
      newValue = value

    # The target is updated if set.
    @updateOptionSelection() if @hasTarget

    @updateDummy()

    # Setting the value automatically close the
    # `MenuList` of this instance.
    @closeMenu() if @isMenuVisible()

    # Returns the new value if legible, otherwise the
    # function returns the original value.
    if newValue? isnt null then @[property] = newValue
    else oldValue

  # Changes the model of this `SingleSelect`. When it occurs, the
  # select's `MenuList` instance's model is also changed.
  set_model: (property, value) ->
    value = super
    @set "value", @model?.items[0]?.value
    @menuList.set "model", value
    value

  #### Signal Listeners

  # Catch all changes made to the model.
  modelChanged: (model) ->
    super
    # In the case the previous value can't be found anymore
    # in the model, the selection is reset to the first selectable
    # item in the model.
    unless @getItemAt(@selectedPath)?
      @selectedPath = @findNext [0]
      @["value"] = @getItemAt(@selectedPath).value

    @updateOptionSelection()

  #### Event Listeners

  # Pressing the mouse over a `SingleSelect` open or close the
  # `MenuList` of the instance according to its current state.
  mousedown: (e) ->
    unless @cantInteract()
      # Prevent the default behavior on the `SingleSelect`
      # `mousedown` event to allow the `menuList` to trigger
      # a `mouseup` event in the movement.
      e.preventDefault()

      # Prevent the document to catch the `mousedown` event
      # when the mouse is pressed over the `SingleSelect`.
      e.stopImmediatePropagation()

      if @isMenuVisible() then @closeMenu()
      else @openMenu()

# <a name='MultiSelect'></a>
## MultiSelect

#
class MultiSelect extends AbstractSelect
  # Here some live instances:
  #
  #= require multi-selects

  @include HasMultiSelection, HasPopupMenuList

  constructor: (targetOrModel) ->
    super targetOrModel

    if @hasTarget
      @selectedPaths = (@findValue value for value in @findSelectedOptions())

    @ensureModelCompletion()
    @buildMenu()
    @updateDummy()
    @hideTarget()


  checkTarget: (target) ->
    unless @isTag(target, "select") and $(target).attr("multiple")?
      throw new Error "A MultiSelect only allow multiple
                       select nodes as target"

  # Returns an array containing the path to the various `option` nodes
  # that have their `selected` attributes set.
  findSelectedOptions: ->
    values = []
    @jTarget.find("option").each (i,o) =>
      values.push @getOptionValue $(o) if $(o).attr("selected")?
    values


  #### Dummy Management

  # The dummy for a `SingleSelect` is a span with the class `single-select`
  # and an internal span with the class `value`.
  createDummy: ->
    dummy = $ "<span class='multi-select'>
                 <span class='add'></span>
                 <span class='value'></span>
               </span>"

    dummy.find(".add").bind "mouseup", (e) => @openMenu()
    dummy

  # The dummy's `value` span will receive the content of the
  # `display` property of the current selected item.
  updateDummy: ->
    @dummy.find(".option").unbind("mouseup").remove()

    value = @dummy.find ".value"
    for path in @selectedPaths
      item = @getItemAt path
      option = $("<span class='option'>#{item.display}</span>")
      option.bind "mouseup", (e) =>
        return if @cantInteract()
        @removeFromSelection @selectedPaths[$(e.currentTarget).index()]
      value.append option

  removeFromSelection: (path) ->
    delete @getItemAt(path).hidden
    @menuList.modelChanged @model

    @selectedPaths = (p for p in @selectedPaths when not @samePath p, path)
    @updateDummy()
    @updateOptionSelection()

  addToSelection: (path) ->
    @getItemAt(path).hidden = true
    @menuList.modelChanged @model

    @selectedPaths.push path
    @sortPaths()
    @updateDummy()
    @updateOptionSelection()

  sortPaths: ->
    @selectedPaths.sort (a,b) ->
      a = a.join "-"
      b = b.join "-"

      if a > b then 1 else if a < b then -1 else 0

  ensureModelCompletion: (model=@model) ->
    super
    delete item.hidden for item in model.items

    if model is @model
      @getItemAt(p).hidden = true for p in @selectedPaths

  buildActionFor: (item) -> =>
      @addToSelection @findValue item.value
      @closeMenu()

  adjustMenu: ->
    # The `MenuList` is displayed right below the widget
    # on screen.
    addButton = @dummy.find ".add"
    left = addButton.offset().left
    top = addButton.offset().top + addButton.height()
    @menuList.dummy.attr "style", "left: #{left}px; top: #{top}px;"

  #### Properties Accessors
  get_value: (property) ->
    if @selectedPaths? then @getItemAt(p).value for p in @selectedPaths else []

  set_value: (property, value) ->
    @selectedPaths = (@findValue v for v in value)
    @sortPaths()

    @updateDummy()
    @updateOptionSelection()

  set_model: (property, value) ->
    value = super
    @selectedPaths = []
    @menuList.set "model", value
    value

@SingleSelect = SingleSelect
@MultiSelect  = MultiSelect
