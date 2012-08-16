# A `Stepper` is a widget that allow the manipulation of
# a number through a text input and two buttons to increment
# or decrement the value.

class Stepper extends NumericWidget
  # Here some live instances :
  #
  #= require stepper

  @include HasFocusProvidedByChild, Spinner

  spinnerDummyClass: "stepper"

  constructor: (target) ->
    super target

    @set "step", 1 unless @get("step")?

    @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

  #### Target Management

  # The target for a `Stepper` must be an input with the type `number`.
  checkTarget: (target) ->
    unless @isInputWithType target, "number"
      throw new Error """Stepper target must be an input
                         with a number type"""

  #### Dummy Management

  # The value of the widget is displayed within its input.
  updateDummy: (value, min, max, step) ->
    @focusProvider.val value

  # When the value of the input is changed, the new value go through
  # the validation function.
  validateInput: ->
    # The input's value is parsed to a float.
    value = parseFloat @focusProvider.attr("value")

    # And if the resulting value is a number, it's affected
    # to this widget's value.
    unless isNaN value
      @set "value", value
    else
      @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

  drag: (dif) -> @set "value", @get("value") + dif * @get("step")

@Stepper = Stepper
