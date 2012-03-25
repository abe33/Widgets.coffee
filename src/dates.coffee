# The `dates.coffee` file contains all the widgets that handles date and time
# related inputs.
#
#  * [AbstractDateInputWidget](#AbstractDateInputWidget)
#  * [OpenCalendar](#OpenCalendar)
#  * [HasDateAndTime](#HasDateAndTime)
#
# The supported dates and time modes and their corresponding widgets are :
#
#  * [TimeInput](#TimeInput)
#  * [DateInput](#DateInput)
#  * [MonthInput](#MonthInput)
#  * [WeekInput](#WeekInput)
#  * [DateTimeInput](#DateTimeInput)
#  * [DateTimeLocalInput](#DateTimeLocalInput)

#### Abstract
#
# Validation and conversion functions for each mode are available
# as top level functions to allow them to be tested and then
# used in tests to validates widgets outputs.

# <a name ='AbstractDateInputWidget'></a>
## AbstractDateInputWidget

# All widgets that implements support for one of the html
# date and time inputs extends the `AbstractDateInputWidget` class.
#
# The date widgets provides an additional `date` property,
# accessible through a property accessor, that allow to manipulate
# the widget's value using  a `Date` instance.
class AbstractDateInputWidget extends Widget
  # Date and time widgets can operate in a range. Their prototype is then
  # decorated with the `HasValueInRange` mixin.
  @mixins HasValueInRange

  # Concretes classes must defines these properties before calling
  # the super constructor. The three functions handles the validation
  # and the conversion of value in `Date` objects when the `supportedType`
  # property define the value of the `type` attribute that a target must
  # have to be a valid target for the concrete widget.
  valueToDate  : (value) -> new Date
  dateToValue  : (date) -> ""
  isValidValue : (value) -> false
  supportedType: ""

  # The target can be either an `input` node with one of the date
  # types or a `Date` object.
  #
  # The constructor supports an additional `defaultStep` argument
  # that will be used if the `step` property is not a number
  # before the validation of the value.
  constructor: (target, defaultStep = null) ->
    min  = null
    max  = null
    step = NaN

    # When the target is a date, we don't need to do much
    # operation.
    if target instanceof Date
      super()
      date = target
    # On the other hand, when the target is an input,
    # the datas contained in the node will be used to
    # setup the widget.
    else
      super target
      if @hasTarget
        date  = @dateFromAttribute  "value", new Date
        min   = @valueFromAttribute "min"
        max   = @valueFromAttribute "max"
        step  = parseInt @valueFromAttribute "step"

        # If invalid values are passed in the `min`
        # or `max` attribute, that attribute is set
        # to `null` and this extremity of the range
        # will not be used.
        unless @isValidValue min then min = null
        unless @isValidValue max then max = null
      else
        date  = new Date

    # Step is step before any other operation. As `min`
    # `max` and `value` must respect that step.
    @step  = if isNaN step then defaultStep else step

    # If a valid `min` bounds is defined, the value is snapped
    # according to the `step` property before being its affectation.
    if min?
      minDate = @snapToStep @valueToDate min
      @min = @dateToValue minDate
    # If a valid `max` bounds is defined, the value is snapped
    # according to the `step` property before being its affectation.
    if max?
      maxDate = @snapToStep @valueToDate max
      @max = @dateToValue maxDate

    # The value of the widget is then adjusted itself to the step
    # and range defined previously.
    @date  = @fitToRange date, minDate, maxDate
    @value = @dateToValue date

    # To avoid infinite loops and unnecessary conversion, locks
    # are defined for the `date` and `value` setters.
    @dateSetProgrammatically = false
    @valueSetProgrammatically = false

    @updateDummy()
    @hideTarget()

  #### Target Management

  # Target must be an input with a type equal to the widget `supportedType`.
  checkTarget: (target) ->
    unless @isInputWithType target, @supportedType
      throw new Error """TimeInput target must be an input
                 with a #{ @supportedType } type"""

  # Gets a `Date` object from the value of a target's attribute.
  # If the target's value doesn't validate the `defaultValue`
  # is returned instead.
  dateFromAttribute: (attr, defaultValue = null) ->
    value = @valueFromAttribute attr
    if @isValidValue value then @valueToDate value else defaultValue

  #### Value Management

  # Overrides of the `HasValueInRange` mixin method to support date value.
  snapToStep: (value) ->
    # A `Date` is rounded using its primitive value.
    ms = value.getTime()
    step = @get "step"

    if step?
      value.setTime ms - (ms % ( step * Date.MILLISECONDS_IN_SECOND ))

    value

  # Overrides of the `HasValueInRange` mixin method to support date value.
  increment: () ->
    d    = @get "date"
    step = @get "step"
    ms   = d.valueOf()
    d.setTime ms + step * Date.MILLISECONDS_IN_SECOND
    @set "date", d

  # Overrides of the `HasValueInRange` mixin method to support date value.
  decrement: () ->
    d    = @get "date"
    step = @get "step"
    ms   = d.valueOf()
    d.setTime ms - step * Date.MILLISECONDS_IN_SECOND
    @set "date", d

  #### Dummy Management

  # The base dummy for date widgets is a span with a `datetime`
  # class completed with the type of the widget.
  createDummy: ->
    $("<span class='dateinput #{ @supportedType }'></span>")

  # Placeholder for the dummy update.
  updateDummy: ->

  #### Properties Accessors

  # Sets the value of the widget with a `Date` instance.
  # Only valid dates are allowed. Invalid dates are easily
  # identifiable as all their getters will return `NaN`.
  set_date: (property, value) ->
    return @get "date" if not value? or isNaN value.date()

    min = @get "min"
    max = @get "max"
    # The `min` and `max` properties being stored as string,
    # they are converted to a date before being used.
    min = @valueToDate min if min?
    max = @valueToDate max if max?

    # The passed-in value is then adjusted to the widget's range.
    @[property] = @fitToRange value, min, max

    # The lock prevent a call to the `date` setter to call
    # back the `value` setter when `date` was called within
    # the `value` setter.
    unless @dateSetProgrammatically
      @valueSetProgrammatically = true
      @set "value", @dateToValue @[property]
      @valueSetProgrammatically = false

    # The dummy is updated before returning the final value.
    @updateDummy()
    @[property]

  # Sets the value of the widget. Only valid values are allowed,
  # they are validated with the `isValidValue` function defined
  # for the widget.
  set_value: (property, value) ->
    return @get property unless @isValidValue value

    # The lock prevent a call to the `value` setter to call
    # back the `date` setter when `value` was called within
    # the `date` setter.
    unless @valueSetProgrammatically
      @dateSetProgrammatically = true
      @set "date", @valueToDate value
      @dateSetProgrammatically = false

    super property, @dateToValue @get "date"

    # The dummy is updated before returning the final value.
    @updateDummy()
    @[property]

  ##### Range Accessors

  # Sets the `min` property of the widget.
  #
  # The `min` property is constrained by the same rules as the
  # widget's value. Meaning that it should returns true when
  # passed in `isValidValue` and then it will be snapped to the
  # widget's step.
  set_min: (property, value) ->
    return @get property unless @isValidValue value

    # The `min` property can't be greater that the `max` property.
    return @get property if value > @get "max"

    @[property] = @dateToValue @snapToStep @valueToDate value
    @valueToAttribute property, value
    # When affected, the current `date` of the widget is
    # adjusted to the new range by calling the `date` setter.
    @set "date", @get "date"
    value

  # Sets the `max` property of the widget.
  #
  # The `max` property is constrained by the same rules as the
  # widget's value. Meaning that it should returns true when
  # passed in `isValidValue` and then it will be snapped to the
  # widget's step.
  set_max: (property, value) ->
    return @get property unless @isValidValue value

    # The `max` property can't be greater that the `min` property.
    return @get property if value < @get "min"

    @[property] = @dateToValue @snapToStep @valueToDate value
    # When affected, the current `date` of the widget is
    # adjusted to the new range by calling the `date` setter.
    @valueToAttribute property, value
    @set "date", @get "date"
    value

  # Sets the `step` property of the widget.
  set_step: (property, value) ->

    # A `null` or `NaN` step will disable the value snapping.
    # `NaN` value end up to `null`.
    value = null if isNaN value
    @[property] = value
    @valueToAttribute property, value

    # When affected, the current `date` of the widget is
    # adjusted to the new step by calling the `date` setter.
    @set "date", @get "date"
    value

# <a name ='OpenCalendar'></a>
## OpenCalendar

# This mixin provides the basic behavior for date widgets
# that need to open a `Calendar` to edit their value.
OpenCalendar =
  # `OpenCalendar` objects provide a `dialogRequested`
  # signal that is automatically binded to an instance
  # of `Calendar` attached to the class.
  constructorHook: ->
    @dialogRequested = new Signal
    @dialogRequested.add @constructor.calendar.dialogRequested,
               @constructor.calendar

  # Creates the dummy that will contains the widget's value in
  # a `span` with the class `value`.
  createDummy: ->
    dummy = @super "createDummy"
    dummy.append "<span class='value'>#{ @get "value" }</span>"
    dummy

  # Updates the `span` that contains the value.
  updateDummy: ->
    @dummy.find(".value").text @get "value"

  #### Events Listeners

  # Clicking on the widget will trigger the `dialogRequested` signal
  # unless it can't interact.
  # The propagation of the event is stopped to prevent the document
  # to catch the event and closing the dialog instantly.
  mouseup: (e) ->
    unless @cantInteract()
      e.stopImmediatePropagation()
      @dialogRequested.dispatch this


# <a name ='HasDateAndTime'></a>
## HasDateAndTime

# This mixin provides the composition of a `DateInput` and a `TimeInput`
# as child of the widget. Each component of the widget value is handled
# by these components.
HasDateAndTime =
  # Two children are created at creation. The first is a `DateInput`
  # that will allow to edit and display the date part of a `datetime`
  # or `datetime-local` input. The second child is a `TimeInput` which
  # will handle the time edition.
  constructorHook: ->
    @add @dateInput = new DateInput
    @add @timeInput = new TimeInput

    # The widget listen to both children `valueChanged` signal.
    @dateInput.valueChanged.add @dateChanged, this
    @timeInput.valueChanged.add @timeChanged, this

  # The update of the widget's dummy consist in updating its two
  # children's value.
  updateDummy: ->
    @super "updateDummy"

    # The update of this widgets value by its children is prevented
    # by a lock before affecting the values.
    @datetimeSetProgramatically = true
    @dateInput.set "date", @get("date").clone()
    @timeInput.set "date", @get("date").clone()
    @datetimeSetProgramatically = false

  #### Slots

  # Receive the `valueChanged` signal of the `DateInput` child.
  dateChanged: (widget) ->
    # The function returns instantly if the widget is locked.
    return if @datetimeSetProgramatically

    v = widget.get "date"
    d = @get "date"
    # Only the date part of the current widget's `date` is updated.
    d.year(v.year() ).month( v.month() ).date( v.date())

    @set "date", d
  # Receive the `valueChanged` signal of the `TimeInput` child.
  timeChanged: (widget) ->
    # The function returns instantly if the widget is locked.
    return if @datetimeSetProgramatically

    v = widget.get "date"
    d = @get "date"
    # Only the time part of the current widget's `date` is updated.
    d.hours(v.hours() ).minutes( v.minutes() ).seconds( v.seconds())

    @set "date", d


# <a name ='TimeInput'></a>
## TimeInput

# The `TimeInput` handles the form input of type `time`.
class TimeInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require timeinput

  # The `TimeWidget` is displayed as a spinner
  # with a text input that allow to input directly
  # a time. In that case the focus is provided
  # by the text input.
  @mixins HasFocusProvidedByChild, Spinner

  spinnerDummyClass: "dateinput time"

  # Setup the concrete function for validation and conversion
  # of the `AbstractDateInputWidget` class.
  constructor: (target) ->
    @supportedType = "time"
    @valueToDate   = Date.timeFromString
    @dateToValue   = Date.timeToString
    @isValidValue  = Date.isValidTime

    # The default `step` for a time input is one minute.
    super target, 60

  #### Dummy Management

  # The displayed value for a `TimeInput` is the time in the
  # format `hh:mm`, neither the seconds nor the milliseconds
  # are displayed.
  updateDummy: ->
    @dummy.find("input").val @get("value").split(":")[0..1].join(":")

  #### Events Handlers

  # Catch changes made to the text input content, validates it, and
  # affect it as the new value if validated.
  change: (e) ->
    value = @focusProvider.val()
    if @isValidValue value then @set "value", value else @updateDummy()

  # The value is changed on the basis that a move of 1 pixel change the value
  # of the amount of `step`.
  drag: (dif) ->
    ms = @get("date").valueOf()
    step = @get "step"

    @set "date", new Date ms + dif * step * Date.MILLISECONDS_IN_SECOND

# <a name ='DateInput'></a>
## DateInput

# The `DateInput` handles the form input of type `date`.
class DateInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require dateinput

  # Clicking on a `DateInput` open a `Calendar` object
  # in `date` mode.
  @mixins OpenCalendar

  # The `Calendar` instance for the `DateInput` class.
  @calendar = new Calendar
  $(document).ready -> DateInput.calendar.attach "body"

  # Setup the concrete function for validation and conversion
  # of the `AbstractDateInputWidget` class.
  constructor: (target) ->
    @supportedType = "date"
    @valueToDate   = Date.dateFromString
    @dateToValue   = Date.dateToString
    @isValidValue  = Date.isValidDate

    super target

# <a name ='MonthInput'></a>
## MonthInput

# The `MonthInput` handles the form input of type `month`.
class MonthInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require monthinput

  # Clicking on a `MonthInput` open a `Calendar` object
  # in `month` mode.
  @mixins OpenCalendar

  # The `Calendar` instance for the `MonthInput` class.
  @calendar = new Calendar null, "month"
  $(document).ready -> MonthInput.calendar.attach "body"

  # Setup the concrete function for validation and conversion
  # of the `AbstractDateInputWidget` class.
  constructor: (target) ->
    @supportedType = "month"
    @valueToDate   = Date.monthFromString
    @dateToValue   = Date.monthToString
    @isValidValue  = Date.isValidMonth

    super target

# <a name ='WeekInput'></a>
## WeekInput

# The `WeekInput` handles the form input of type `week`.
class WeekInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require weekinput

  # Clicking on a `WeekInput` open a `Calendar` object
  # in `week` mode.
  @mixins OpenCalendar

  # The `Calendar` instance for the `WeekInput` class.
  @calendar = new Calendar null, "week"
  $(document).ready -> WeekInput.calendar.attach "body"

  # Setup the concrete function for validation and conversion
  # of the `AbstractDateInputWidget` class.
  constructor: (target) ->
    @supportedType = "week"
    @valueToDate   = Date.weekFromString
    @dateToValue   = Date.weekToString
    @isValidValue  = Date.isValidWeek

    super target

# <a name ='DateTimeInput'></a>
## DateTimeInput

# The `DateTimeInput` handles the form input of type `date`.
class DateTimeInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require datetimeinput

  @mixins HasChildren, HasDateAndTime

  constructor: (target = new Date) ->
    @supportedType = "datetime"
    @valueToDate   = Date.datetimeFromString
    @dateToValue   = Date.datetimeToString
    @isValidValue  = Date.isValidDateTime

    super target

# <a name ='DateTimeLocalInput'></a>
## DateTimeLocalInput

# The `DateTimeLocalInput` handles the form input of type `date`.
class DateTimeLocalInput extends AbstractDateInputWidget
  # Here some live instances :
  #
  #= require datetimelocalinput

  @mixins HasChildren, HasDateAndTime

  constructor: (target) ->
    @supportedType = "datetime-local"
    @valueToDate   = Date.datetimeLocalFromString
    @dateToValue   = Date.datetimeLocalToString
    @isValidValue  = Date.isValidDateTimeLocal

    super target

@TimeInput = TimeInput
@DateInput = DateInput
@MonthInput = MonthInput
@WeekInput = WeekInput
@DateTimeInput = DateTimeInput
@DateTimeLocalInput = DateTimeLocalInput
