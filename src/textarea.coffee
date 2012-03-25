# The `TextArea` widget wrap the target within a `span` in order to
# allow custom styling.
class TextArea extends Widget
  # Here some live instances :
  #
  #= require textarea

  @mixins HasFocusProvidedByChild

  constructor: (target) ->

    # The `target` is mandatory in the `TextArea` constructor so a default
    # target is created when nothing is passed to the constructor.
    target = $("<textarea></textarea")[0] unless target?

    super target

    @valueIsObsolete = false

  #### Target Management

  # The target for a `TextArea` must be a `textarea` node.
  checkTarget: (target) ->
    unless @isTag target, "textarea"
      throw new Error "TextArea only allow textarea nodes as target"

  #### Dummy Management

  # The dummy for a `TextArea` is a `span` with a `textarea` class on it.
  createDummy: ->
    dummy = $("<span class='textarea'></span>")
    dummy.append @target
    @focusProvider = @jTarget
    dummy

  #### Events Handling

  # When the user types some text in the target, the widget's
  # value is marked as obsolete.
  input: (e) ->
    @valueIsObsolete = true

  # When the `change` event occurs, the content of the
  # target is saved as the new widget's value and the obsolete
  # flag is set to `false`.
  #
  # The flag is unset after the value's affectation, and since
  # a `valueChanged` signal is dispatched, the `valueIsObsolete`
  # property allow a listener to know if the change done to the
  # widget was done by a user input.
  change: (e) ->
    @set "value", @jTarget.val()
    @valueIsObsolete = false
    true

@TextArea = TextArea
