# The `NumericWidget` class is a base class for number manipulation widget.
# Both the `Slider` and `Stepper` classes extends the `NumericWidget` class.
class NumericWidget extends Widget

  # Ranges management is provided by the `HasValueInRange` mixin.
  @include HasValueInRange

  constructor: (target) ->

    super target

    #### Shared Properties
    #
    # The `min`, `max` and `step` attributes of the range
    # or number inputs are handled by the  `NumericWidget` class.
    # Each of them is a number.
    min  = parseFloat @valueFromAttribute "min"
    max  = parseFloat @valueFromAttribute "max"
    step = parseFloat @valueFromAttribute "step"

    if isNaN min  then min  = null
    if isNaN max  then max  = null
    if isNaN step then step = null

    # The `min` property represent the lower bound of the value's range.
    @.min   = min
    # The `max` property represent the upper bound of the value's range.
    @.max   = max
    # The `step` property represent the gap between legible values.
    @.step  = step
    # The `value` property is a number so the data from
    # the target is parsed before affectation.
    @.value = parseFloat @valueFromAttribute "value",0

    # Target is hidden if provided.
    @hideTarget()

  #### Value Manipulation

  snapToStep: (value) ->
    step = @get "step"
    if step? then value - (value % step) else value

  # Increment the value of the amount of the `step` property.
  increment: ->
    @set "value", @get("value") + @get("step")

  # Decrement the value of the amount of the `step` property.
  decrement: ->
    @set "value", @get("value") - @get("step")

  #### Dummy Management

  createDummy: ->
    $("<span></span>")

  # Overrides this method to implement your own dummy
  # update routine.
  #
  # You should only use the data from the arguments, since
  # the `updateDummy` method can be called before the
  # widget's properties change.
  updateDummy: (value, min, max, step) ->

  #### Properties Accessors

  # When setting the `value` property, the passed-in
  # new value is first cleaned to fit in the widget's
  # range of values.
  set_value: (property, value) ->
    min = @get "min"
    max = @get "max"
    step = @get "step"
    value = @fitToRange value, min, max
    @updateDummy value, min, max, step

    super property, value

  # The `min` property cannot be greater than the `max` property.
  #
  # The value is adjusted to the `min` bound if it drop below with
  # the new `min` value.
  set_min: (property, value) ->
    max = @get "max"
    if value >= max
      return @get property
    else
      value = @snapToStep value
      @[property] = value
      @valueToAttribute property, value
      @set "value", @fitToRange @get( "value"), value, max
      return value

  # The `min` property cannot be lower than the `min` property.
  #
  # The value is adjusted to the `max` bound if it climb above with
  # the new `max` value.
  set_max: (property, value) ->
    min = @get "min"
    if value <= min
      return @get property
    else
      value = @snapToStep value
      @[property] = value
      @valueToAttribute property, value
      @set "value", @fitToRange @get( "value"), min, value
      return value

  # Changing the `step` property can alter the `value` property
  # if the current value doesn't snap to the new step grid.
  set_step: (property, value) ->
    value = null if isNaN value
    [min, max ] = [ @get "min", @get "max"]
    @valueToAttribute property, value
    @[property] = value
    @set "value", @fitToRange @get( "value"), min, max
    return value

@NumericWidget = NumericWidget
