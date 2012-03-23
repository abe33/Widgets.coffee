class CheckBox extends Widget
  # Use the `CheckBox` widget to handle `checkbox` type input.
  #
  #= require checkbox

  # Defines the types that is allowed for a checkbox's `target`.
  #
  # `CheckBox` and its descendants are dedicated to work with
  # a unique type of inputs. This property allow to define the
  # type of allowed inputs for the class.
  targetType:"checkbox"

  constructor:(target)->
    super target

    #### Checkbox Signals

    # The `checkedChanged` signal is dispatched when the `checked`
    # property of the widget is modified.
    #
    # *Callback arguments*
    #
    #  * `widget`    : The widget that was modified.
    #  * `checked`   : The new value for this widget's checked property.
    @checkedChanged = new Signal

    #### Shared Properties

    # The `values` property stores a tuple of two values that will be used
    # to fill the `value` property according to the current state.
    #
    # For instance :
    #
    #     checkbox = new CheckBox
    #     checkbox.set "values", ["on", "off"]
    #     console.log checkbox.get "value"
    #
    # Will output `off`.
    @values = [true, false]

    # The `checked` property reflect the `checked` attribute of the target.
    @checked = @booleanFromAttribute("checked", false)

    # The initial `checked` value is saved for a possible reset.
    @targetInitialChecked = @get "checked"

    # The `checked` property is mapped to a state on the dummy.
    @dummyStates = ["checked", "disabled", "readonly", "required"]

    #### Keyboard Controls

    # Use the `enter` or `space` key to toggle the
    #  checkbox with the keyboard.
    @registerKeyUpCommand keystroke(keys.enter), @actionToggle
    @registerKeyUpCommand keystroke(keys.space), @actionToggle

    @updateStates()
    @hideTarget()

  #### Target Management

  # The target for a `CheckBox` must be an `input` with a type `checkbox`.
  checkTarget:(target)->
    unless @isInputWithType target, "checkbox"
      throw new Error """CheckBox target must be an input
                 with a checkbox type"""

  #### Properties Accessors

  # Setting the `checked` property also affect the `value` property.
  set_checked:(property, value)->
    @[property] = value
    @updateValue value, @get("values")
    @booleanToAttribute property, value
    @checkedChanged.dispatch this, value

  # Overrides the default behavior for the `value` setter.
  # Changing the `value` also modify the `checked` attribute
  # unless the setter was called internally.
  set_value:(property, value)->
    @set "checked", value is @get("values")[0] unless @valueSetProgrammatically
    super property, value

  # The `value` property is automatically updated when the `values`
  # change.
  set_values:(property, value)->
    @updateValue @get("checked"), value
    @[property] = value

  #### Dummy Management

  # The dummy for the checkbox is just a `<span>` element
  # with a `checkbox` class.
  createDummy:->
    $("<span class='checkbox'></span>")

  #### Checked State Management

  # Toggle the state of the checkbox.
  toggle:->
    @set "checked", not @get "checked"

  # Use to toggle the state on a user action, with care
  # to the state of the widget.
  actionToggle:->
    @toggle() unless @get("readonly") or @get("disabled")

  # The `reset` function operate on both the `value`
  # and the `checked` state of the widget.
  reset:->
    super()
    @set "checked", @targetInitialChecked

  # Update the `value` property according to the passed-in
  # `checked` state and `values`.
  updateValue:(checked, values)->
    @valueSetProgrammatically = true
    @set "value", if checked then values[0] else values[1]
    @valueSetProgrammatically = false

  #### Dummy Events Handlers

  # Toggle the checkbox on a user click.
  click:(e)->
    @actionToggle()

    # Grabing the focus on a click is only allowed
    # when the widget is not disabled.
    @grabFocus() unless @get "disabled"

@CheckBox = CheckBox
