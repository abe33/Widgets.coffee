# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript'
#         src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>

# The `dates.coffee` file contains all the widgets that handles date and time
# related inputs.
#
# The supported dates and time modes and their corresponding widgets are :
#
# * [time](#time)                   :[TimeInput](#TimeInput)
# * [date](#date)                   :[DateInput](#DateInput)
# * [month](#month)                 :[MonthInput](#MonthInput)
# * [week](#week)                   :[WeekInput](#WeekInput)
# * [datetime](#datetime)           :[DateTimeInput](#DateTimeInput)
# * [datetime-local](#datetime-loca):[DateTimeLocalInput](#DateTimeLocalInput)

#### Utilities

# A group of *"constants"* for basic time and dates computations.
MILLISECONDS_IN_SECOND = 1000
MILLISECONDS_IN_MINUTE = MILLISECONDS_IN_SECOND * 60
MILLISECONDS_IN_HOUR   = MILLISECONDS_IN_MINUTE * 60
MILLISECONDS_IN_DAY    = MILLISECONDS_IN_HOUR * 24
MILLISECONDS_IN_WEEK   = MILLISECONDS_IN_DAY * 7

# Cast the `value` into an integer.
# In case the passed-in `value` cannot be casted in an
# integer, the function return the value of `0`
safeInt=( value )->
    n = parseInt value
    unless isNaN n then n else 0

# Fills the string `s` with `0` until its length is
# equal to the length `l`.
fill=( s, l = 2 )->
    s = String s
    s = "0#{s}" while s.length < l
    s

#### Abstract
#
# Validation and conversion functions for each mode are available
# as top level functions to allow them to be tested and then
# used in tests to validates widgets outputs.

#### AbstractDateInputWidget

# All widgets that implements support for one of the html
# date and time inputs extends the `AbstractDateInputWidget` class.
#
# The date widgets provides an additional `date` property,
# accessible through a property accessor, that allow to manipulate
# the widget's value using a `Date` instance.
class AbstractDateInputWidget extends Widget
    # Date and time widgets can operate in a range. Their prototype is then
    # decorated with the `ValueInRange` mixin.
    @mixins ValueInRange

    # Concretes classes must defines these properties before calling
    # the super constructor. The three functions handles the validation
    # and the conversion of value in `Date` objects when the `supportedType`
    # property define the value of the `type` attribute that a target must
    # have to be a valid target for the concrete widget.
    valueToDate  :( value )-> new Date
    dateToValue  :( date )-> ""
    isValidValue :( value )-> false
    supportedType:""

    # The target can be either an `input` node with one of the date
    # types or a `Date` object.
    #
    # The constructor supports an additional `defaultStep` argument
    # that will be used if the `step` property is not a number
    # before the validation of the value.
    constructor:( target, defaultStep = null )->
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
        @properties.step  = if isNaN step then defaultStep else step

        # If a valid `min` bounds is defined, the value is snapped
        # according to the `step` property before being its affectation.
        if min?
            minDate = @snapToStep @valueToDate min
            @properties.min = @dateToValue minDate
        # If a valid `max` bounds is defined, the value is snapped
        # according to the `step` property before being its affectation.
        if max?
            maxDate = @snapToStep @valueToDate max
            @properties.max = @dateToValue maxDate

        # The value of the widget is then adjusted itself to the step
        # and range defined previously.
        @properties.date  = @fitToRange date, minDate, maxDate
        @properties.value = @dateToValue date

        # To avoid infinite loops and unnecessary conversion, locks
        # are defined for the `date` and `value` setters.
        @dateSetProgrammatically = false
        @valueSetProgrammatically = false

        @updateDummy()
        @hideTarget()

    #### Target Management

    # Target must be an input with a type equal to the widget `supportedType`.
    checkTarget:( target )->
        unless @isInputWithType target, @supportedType
            throw new Error """TimeInput target must be an input
                               with a #{ @supportedType } type"""

    # Gets a `Date` object from the value of a target's attribute.
    # If the target's value doesn't validate the `defaultValue`
    # is returned instead.
    dateFromAttribute:( attr, defaultValue = null )->
        value = @valueFromAttribute attr
        if @isValidValue value then @valueToDate value else defaultValue

    #### Value Management

    # Overrides of the `ValueInRange` mixin method to support date value.
    snapToStep:( value )->
        # A `Date` is rounded using its primitive value.
        ms = value.getTime()
        step = @get "step"
        if step?
            value.setTime ms - ( ms % ( step * MILLISECONDS_IN_SECOND ) )

        value

    # Overrides of the `ValueInRange` mixin method to support date value.
    increment:()->
        d    = @get "date"
        step = @get "step"
        ms   = d.valueOf()
        d.setTime ms + step * MILLISECONDS_IN_SECOND
        @set "date", d

    # Overrides of the `ValueInRange` mixin method to support date value.
    decrement:()->
        d    = @get "date"
        step = @get "step"
        ms   = d.valueOf()
        d.setTime ms - step * MILLISECONDS_IN_SECOND
        @set "date", d

    #### Dummy Management

    # The base dummy for date widgets is a span with a `datetime`
    # class completed with the type of the widget.
    createDummy:->
        $ "<span class='dateinput #{ @supportedType }'></span>"

    # Placeholder for the dummy update.
    updateDummy:->

    #### Properties Accessors

    # Sets the value of the widget with a `Date` instance.
    # Only valid dates are allowed. Invalid dates are easily
    # identifiable as all their getters will return `NaN`.
    set_date:( property, value )->
        if not value? or isNaN value.getDate() then return @get "date"

        min = @get "min"
        max = @get "max"
        # The `min` and `max` properties being stored as string,
        # they are converted to a date before being used.
        if min? then min = @valueToDate min
        if max? then max = @valueToDate max

        # The passed-in value is then adjusted to the widget's range.
        @properties[ property ] = @fitToRange value, min, max

        # The lock prevent a call to the `date` setter to call
        # back the `value` setter when `date` was called within
        # the `value` setter.
        unless @dateSetProgrammatically
            @valueSetProgrammatically = true
            @set "value", @dateToValue @properties[ property ]
            @valueSetProgrammatically = false

        # The dummy is updated before returning the final value.
        @updateDummy()
        @properties[ property ]

    # Sets the value of the widget. Only valid values are allowed,
    # they are validated with the `isValidValue` function defined
    # for the widget.
    set_value:( property, value )->
        unless @isValidValue value then return @get property

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
        @properties[ property ]

    # Sets the `min` property of the widget.
    #
    # The `min` property is constrained by the same rules as the
    # widget's value. Meaning that it should returns true when
    # passed in `isValidValue` and then it will be snapped to the
    # widget's step.
    set_min:( property, value )->
        unless @isValidValue value then return @get property

        # The `min` property can't be greater that the `max` property.
        if value > @get "max" then return @get property

        @properties[ property ] = @dateToValue @snapToStep @valueToDate value
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
    set_max:( property, value )->
        unless @isValidValue value then return @get property

        # The `max` property can't be greater that the `min` property.
        if value < @get "min" then return @get property

        @properties[ property ] = @dateToValue @snapToStep @valueToDate value
        # When affected, the current `date` of the widget is
        # adjusted to the new range by calling the `date` setter.
        @valueToAttribute property, value
        @set "date", @get "date"
        value

    # Sets the `step` property of the widget.
    set_step:( property, value )->

        # A `null` or `NaN` step will disable the value snapping.
        # `NaN` value end up to `null`.
        if isNaN value then value = null
        @properties[ property ] = value
        @valueToAttribute property, value
        # When affected, the current `date` of the widget is
        # adjusted to the new step by calling the `date` setter.
        @set "date", @get "date"
        value

# <a name='time'></a>
## Time

# Match if the passed-in string is a valid time string.
# The following strings are considered as valid :
# `10`, `10:15`, `10:15:40` or `10:15:40.768`
isValidTime=( value )->
    unless value? then return false
    (/// ^
        [\d]{2}                 # Hours are required
        (:[\d]{2}               # Minutes are optional
            (:[\d]{2}           # Seconds as well
                (\.[\d]{1,4})?  # Milliseconds too
            )?                  # End Seconds
        )?                      # End Minutes
    $ ///).test value

# Converts a time string into a `Date` object where the time properties,
# hours, minutes, seconds and milliseconds, are sets with the provided
# datas or `0`.
timeFromString=( string )->
    [ hours, min, sec ] = string.split ":"
    [ sec, ms ] = if sec? then sec.split "." else [ 0, 0 ]

    # UTC dates start at 1:00 AM so we have to remove one hour.
    time = safeInt( hours - 1 ) * MILLISECONDS_IN_HOUR   +
           safeInt( min )       * MILLISECONDS_IN_MINUTE +
           safeInt( sec )       * MILLISECONDS_IN_SECOND +
           safeInt( ms )

    d = new Date time
    d

# Converts a `Date` object in a string such as `10:15:40`.
# If the milliseconds count is different than `0` then the
# output will look as `10:15:40.768`.
timeToString=( date )->
    h  = date.getHours()
    m  = date.getMinutes()
    s  = date.getSeconds()
    ms = date.getMilliseconds()

    time ="#{ fill h }:#{ fill m }:#{ fill s }"

    if ms isnt 0
        time += ".#{ ms }"

    time

# <a name='TimeInput'></a>
#### TimeInput

# The `TimeInput` handles the form input of type `time`.
#
# Here some live instances :
# <div id="timeinput-demos"></div>
#
# <script type='text/javascript'>
# var f = function(){ console.log( "button clicked" ) };
# var input1 = new TimeInput();
# var input2 = new TimeInput();
# var input3 = new TimeInput();
#
# input2.set( "readonly", true );
# input3.set( "disabled", true );
#
# input1.attach("#timeinput-demos");
# input2.attach("#timeinput-demos");
# input3.attach("#timeinput-demos");
# </script>

class TimeInput extends AbstractDateInputWidget
    # The `TimeWidget` is displayed as a stepper
    # with a text input that allow to input directly
    # a time. In that case the focus is provided
    # by the text input.
    @mixins FocusProvidedByChild

    # Setup the concrete function for validation and conversion
    # of the `AbstractDateInputWidget` class.
    constructor:( target )->
        @supportedType = "time"
        @valueToDate = timeFromString
        @dateToValue = timeToString
        @isValidValue = isValidTime

        # The default `step` for a time input is one minute.
        super target, 60

    #### Dummy management

    # The dummy of a `TimeInput` is the same as the `Stepper`'s' one,
    # one text input, and two additional buttons to increment or
    # decrement the value.
    createDummy:->
        dummy = super()
        dummy.append $ """<input type='text' class='value widget-done'></input>
                        <span class='down'></span>
                        <span class='up'></span>"""

        # The focus isValidValue provided by the text input.
        @focusProvider = dummy.find "input"

        # Gets references to the buttons for setup.
        down = dummy.find(".down")
        up = dummy.find(".up")

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

    # The displayed value for a `TimeInput` is the time in the
    # format `hh:mm`, neither the seconds nor the milliseconds
    # are displayed.
    updateDummy:->
        @dummy.find("input").val @get("value").split(":")[0..1].join(":")

    # The states of the widget is reflected on the widget's input.
    updateStates:->
        super()

        if @get "readonly" then @focusProvider.attr "readonly", "readonly"
        else @focusProvider.removeAttr "readonly"

        if @get "disabled" then @focusProvider.attr "disabled", "disabled"
        else @focusProvider.removeAttr "disabled"

    #### Events handlers

    # Catch changes made to the text input content, validates it, and
    # affect it as the new value if validated.
    change:(e)->
        value = @focusProvider.val()
        if @isValidValue value then @set "value", value else @updateDummy()


    input:(e)->

    # Releasing the mouse over the widget will force the focus on the
    # input. That way, clicking on the increment and decrement button
    # will also give the focus to the widget.
    mouseup:->
        if @get "disabled" then return true

        @grabFocus()

        if @dragging
            $(document).unbind "mousemove", @documentMouseMoveDelegate
            $(document).unbind "mouseup",   @documentMouseUpDelegate
            @dragging = false

        true

    # The `TimeInput` allow to drag the mouse vertically to change the value.
    mousedown:(e)->
        if @cantInteract() then return true

        @dragging = true
        @pressedY = e.pageY

        $(document).bind "mousemove",
                         @documentMouseMoveDelegate =( e )=> @mousemove e
        $(document).bind "mouseup",
                         @documentMouseUpDelegate   =( e )=> @mouseup e

    # The value is changed on the basis that a move of 1 pixel change the value
    # of the amount of `step`.
    mousemove:(e)->
        if @dragging
            y = e.pageY
            dif = @pressedY - y
            ms = @get("date").valueOf()
            step = @get "step"

            @set "date", new Date ms + dif * step * MILLISECONDS_IN_SECOND
            @pressedY = y


# <a name='date'></a>
## Date

# A valid date is a string such as `2012-12-29`.
isValidDate=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}-   # Year
        [\d]{2}-   # Month
        [\d]{2}    # Day of the month
    $ ///).test value

# A valid date string can be passed directly to the `Date` constructor.
dateFromString=( string )->
    d = new Date string
    # Hours may vary when constructing a `Date` from a date string.
    # The returned date's hours are then reset to `0`.
    d.setHours 0
    d

dateToString=( date )->
    [ "#{ fill date.getFullYear(), 4 }",
      "#{ fill date.getMonth() + 1   }",
      "#{ fill date.getDate()        }",
    ].join "-"

# <a name='DateInput'></a>
#### DateInput
class DateInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "date"
        @valueToDate = dateFromString
        @dateToValue = dateToString
        @isValidValue = isValidDate

        super target

# <a name='month'></a>
## Month

isValidMonth=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}-   # Year
        [\d]{2}    # Month
    $ ///).test value

monthFromString=( string )->
    d = new Date string
    # Hours may vary when constructing a `Date`.
    # The returned date's hours are then reset to `0`.
    d.setHours 0
    d

monthToString=( date )->
    "#{ fill date.getFullYear(), 4 }-#{ fill ( date.getMonth() + 1 ) }"

# <a name='MonthInput'></a>
#### MonthInput
class MonthInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "month"
        @valueToDate = monthFromString
        @dateToValue = monthToString
        @isValidValue = isValidMonth

        super target

# <a name='week'></a>
## Week

isValidWeek=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}    # Year
        -W         # Week separator
        [\d]{2}    # Week number prefixed with W
    $ ///).test value

# Converts a string such as `2011-W09` into a `Date` object
# that represent the first day of the corresponding week, even
# if it's not in the same year.
weekFromString=( string )->
    [ year, week ] = ( parseInt s for s in string.split "-W" )

    getWeekDate year, week

weekToString=( date )->
    start = findFirstWeekFirstDay date.getFullYear()
    dif   = date.valueOf() - start.valueOf()
    week  = Math.round ( dif / MILLISECONDS_IN_WEEK ) + 1
    "#{ fill date.getFullYear(), 4 }-W#{ fill week }"

# Returns a `Date` that is the first day of the first week of the year.
# In fact, the returned `Date` can represent a day that is not in `year`
# as a year can start in the middle of a week.
findFirstWeekFirstDay=( year )->
    d = new Date year, 0, 1, 0
    day = d.getDay()

    if day is 0 then day = 7

    if day > 3
        new Date year, 0, 7 - day + 2, 0
    else
        new Date year, 0, 2 - day, 0

getWeekDate=( year, week )->
    start = findFirstWeekFirstDay year
    date = new Date start.valueOf() + MILLISECONDS_IN_WEEK * ( week - 1 )
    date.setHours 0
    date.setMinutes 0
    date.setSeconds 0
    date.setMilliseconds 0
    date

# <a name='WeekInput'></a>
#### WeekInput
class WeekInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "week"
        @valueToDate = weekFromString
        @dateToValue = weekToString
        @isValidValue = isValidWeek

        super target


# <a name='datetime'></a>
## DateTime

isValidDateTime=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}-       # Year
        [\d]{2}-       # Month
        [\d]{2}        # Day of the Month
        T              # Start time token
        [\d]{2}:       # Hours
        [\d]{2}:       # Minutes
        [\d]{2}        # Seconds
        (\.[\d]{1,4})? # Optionnal milliseconds
        (              # Mandatory terminator
            Z|         # Either Z,
            (\+|\-)+   # +XX:XX or -XX:XX
            [\d]{2}:
            [\d]{2}
        )
    $ ///).test value

datetimeFromString=( string )->
    new Date string

datetimeToString=( date )->
    offset = date.getTimezoneOffset()
    sign = "-"
    if offset < 0
        sign = "+"
        offset *= -1

    minutes = offset % 60
    hours = ( offset - minutes ) / 60
    [ "#{ dateToString date }T",
      "#{ timeToString date }",
      "#{ sign }#{ fill hours }:#{ fill minutes }"
    ].join ""

# <a name='DateTimeInput'></a>
#### DateTimeInput
class DateTimeInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "datetime"
        @valueToDate = datetimeFromString
        @dateToValue = datetimeToString
        @isValidValue = isValidDateTime

        super target

# <a name='datetime-local'></a>
## DateTimeLocal
validationRegexp= ->
    /// ^
        ([\d]{4})-     # Year
        ([\d]{2})-     # Month
        ([\d]{2})      # Day of the Month
        T              # Start time token
        ([\d]{2}):     # Hours
        ([\d]{2}):     # Minutes
        ([\d]{2})      # Seconds
        (\.[\d]{1,3})? # Optionnal milliseconds
    $ ///

isValidDateTimeLocal=( value )->
    unless value? then return false
    validationRegexp().test value

datetimeLocalFromString=( string )->
    # Passing the date string directly in the constructor is valid,
    # however the behavior in chrome and firefox are quite different,
    # chrome consider that the passed-in date has an offset of `0`
    # and the convert it to the current local offset when firefox
    # consider the datestring as in the current local offset.
    # In consequences, The date will differ between the two browsers
    # of the amount of the current local offset.
    #
    # The `Date` will be created by parsing the string with the validation
    # regex and pass each value as an argument in the `Date` constructor.

    [ match, year, month,
      day, hours, minutes,
      seconds, milliseconds ] = validationRegexp().exec string

    pI = parseInt
    new Date pI( year    , 10 ),
             pI( month   , 10 ) - 1,
             pI( day     , 10 ),
             pI( hours   , 10 ),
             pI( minutes , 10 ),
             pI( seconds , 10 )
             if milliseconds? then pI milliseconds.replace(".", ""), 10 else 0

datetimeLocalToString=( date )->
    "#{ dateToString date }T#{ timeToString date }"

# <a name='DateTimeLocalInput'></a>
# FIX Find a way to fix the opera issue
#### DateTimeLocalInput
class DateTimeLocalInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "datetime-local"
        @valueToDate = datetimeLocalFromString
        @dateToValue = datetimeLocalToString
        @isValidValue = isValidDateTimeLocal

        super target

@isValidTime = isValidTime
@timeToString = timeToString
@timeFromString = timeFromString

@isValidDate = isValidDate
@dateToString = dateToString
@dateFromString = dateFromString

@isValidMonth = isValidMonth
@monthToString = monthToString
@monthFromString = monthFromString

@isValidWeek = isValidWeek
@weekToString = weekToString
@weekFromString = weekFromString

@isValidDateTime = isValidDateTime
@datetimeToString = datetimeToString
@datetimeFromString = datetimeFromString

@isValidDateTimeLocal = isValidDateTimeLocal
@datetimeLocalToString = datetimeLocalToString
@datetimeLocalFromString = datetimeLocalFromString

@TimeInput = TimeInput
@DateInput = DateInput
@MonthInput = MonthInput
@WeekInput = WeekInput
@DateTimeInput = DateTimeInput
@DateTimeLocalInput = DateTimeLocalInput
