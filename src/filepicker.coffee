# The `FilePicker` widget is a special case, since the `file` input behavior
# cannot be emulate through javascript the real target is used as the trigger
# for the widget's action.
#
# In that regards the testability of the widget cannot be guaranted concerning
# the behavior of the target. Click emulation through javascript
# on a `file` input is generally considered as opening a popup and then
# prevented by the browser.
class FilePicker extends Widget
  # Here some live instances :
  #
  #= require filepicker

  @include HasFocusProvidedByChild

  constructor: (target) ->

    # The `target` is mandatory in the `FilePicker` constructor
    # so a default target is created when nothing is passed
    # to the constructor.
    target = $("<input type='file'></input>")[0] unless target?

    super target

    # The target is hidden when the widget is either readonly or disabled.
    @hideTarget() if @cantInteract()

  #### Target Management

  # The target for a `FilePicker` must be an input with the type `file`.
  checkTarget: (target) ->
    unless @isInputWithType target, "file"
      throw new Error "FilePicker must have an input file as target"

  # Display the target if defined.
  showTarget: ->
    @jTarget.show() if @hasTarget

  # When the target changed the `value`'s text is then replaced with
  # the new value.
  change: (e) ->
    @setValueLabel if @jTarget.val()? then @jTarget.val() else "Browse"
    @dummy.attr "title", @jTarget.val()

  #### Dummy Management

  # The dummy for a `FilePicker` is a `span` with a `filepicker` class on it.
  createDummy: ->
    # It contains two `span` children for an icon and the value display.
    dummy = $ "<span class='filepicker'>
                <span class='icon'></span>
                <span class='value'>Browse</span>
               </span>"
    # The widget's target is part of the dummy, at the top.
    # Generally the target's opacity should be set to `0`
    # in a stylesheet. And its position should be absolute
    # within the widget in order to cover the whole widget
    # and allow the click to take effect.
    dummy.append @jTarget
    @focusProvider = @jTarget

    dummy

  # This method allow to test the change of the `value`'s text.
  setValueLabel: (label) ->
    @dummy.children(".value").text label

  #### Properties Accessors

  # Disabling a `FilePicker` hides the target, in the contrary
  # enabling the widget will display the target again.
  set_disabled: (property, value) ->
    if value then @hideTarget()
    else unless @get("readonly") then @showTarget()

    super property, value

  # When a widget allow writing in it, the target is visible, otherwise the
  # target is hidden.
  set_readonly: (property, value) ->
    if value then @hideTarget()
    else unless @get("disabled") then @showTarget()

    super property, value


@FilePicker = FilePicker
