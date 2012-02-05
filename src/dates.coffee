# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>

# The `dates.coffee` file contains all the widgets that handles date and time
# related inputs.
# 
# The supported dates and time modes and their corresponding widgets are :
#
# * [time](#time)                    : [TimeInput](#TimeInput)
# * [date](#date)                    : [DateInput](#DateInput)
# * [month](#month)                  : [MonthInput](#MonthInput)
# * [week](#week)                    : [WeekInput](#WeekInput)
# * [datetime](#datetime)            : [DateTimeInput](#DateTimeInput)
# * [datetime-local](#datetime-loca) : [DateTimeLocalInput](#DateTimeLocalInput)

#### Utilities

# A group of *constants* for basic time and dates computations.
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
# equalt to the length `l`.
fill=( s, l = 2 )->
    s = String s
    s = "0#{s}" while s.length < l
    s

#### Abstract
#
# Validation and conversion functions for each mode are available
# as top level functions to allow them to be tested.

#### AbstractDateInputWidget

# All widgets that implements support for one of the html date and time inputs
# extends the `AbstractDateInputWidget` class. 
class AbstractDateInputWidget extends Widget
    @mixins RangeStepper

    valueToDate:( value )-> new Date
    dateToValue:( date )-> ""
    isValidValue:( value )-> false
    supportedType:""

    constructor:( target )->
        min  = null
        max  = null
        step = null

        if target instanceof Date 
            super()
            date  = target
        else
            super target
            if @hasTarget
                step  = parseInt @valueFromAttribute "step"
                date  = @dateFromAttribute  "value", new Date
                min   = @valueFromAttribute "min"
                max   = @valueFromAttribute "max"

                if isNaN step then step = null
                unless @isValidValue min then min = null
                unless @isValidValue max then max = null
            else
                date  = new Date

        minDate = if min? then @snapToStep @valueToDate min
        maxDate = if max? then @snapToStep @valueToDate max 
                
        @properties.step  = step
        @properties.min   = if minDate? then @dateToValue minDate else null
        @properties.max   = if maxDate? then @dateToValue maxDate else null

        @properties.date  = @fitToRange date, minDate, maxDate
        @properties.value = @dateToValue date

        @dateSetProgrammatically = false

        @updateDummy()

    #### Target Management

    checkTarget:( target )->
        unless @isInputWithType target, @supportedType
            throw "TimeInput target must be an input with a #{ @supportedType } type"
        
    dateFromAttribute:( attr, def = null )->
        value = @valueFromAttribute attr
        if @isValidValue value then @valueToDate value else def
    
    #### Value Management

    snapToStep:( value )->
        ms = value.valueOf()
        step = @get "step"
        if step?
            new Date ms - ( ms % ( step * MILLISECONDS_IN_SECOND ) )
        else
            value

    increment:()->
        ms = @get("date").valueOf()
        step = @get "step"
        unless step? then step = 1
        
        @set "date", new Date ms + step * MILLISECONDS_IN_SECOND
        

    decrement:()->
        ms = @get("date").valueOf()
        step = @get "step"
        unless step? then step = 1
        
        @set "date", new Date ms - step * MILLISECONDS_IN_SECOND
    
    #### Dummy Management

    createDummy:->
        $ "<span class='dateinput #{ @supportedType }'></span>"
    
    updateDummy:->

    #### Properties Accessors

    set_date:( property, value )->
        if not value? or isNaN value.getDate() then return @get "date"

        min = @get "min"
        max = @get "max"

        if min? then min = @valueToDate min
        if max? then max = @valueToDate max

        @properties[ property ] = @fitToRange value, min, max

        unless @dateSetProgrammatically then @set "value", @dateToValue @properties[ property ]
        
        @properties[ property ]
    
    set_value:( property, value )->
        unless @isValidValue value then return @get property

        @dateSetProgrammatically = true
        @set "date", @valueToDate value
        @dateSetProgrammatically = false

        super property, @dateToValue @get "date"
        @updateDummy()
    
    set_min:( property, value )->
        unless @isValidValue value then return @get property
        if value > @get "max" then return @get property

        @properties[ property ] = @dateToValue @snapToStep @valueToDate value
        @valueToAttribute property, value
        @set "date", @get "date"
        value
    
    set_max:( property, value )->
        unless @isValidValue value then return @get property
        if value < @get "min" then return @get property

        @properties[ property ] = @dateToValue @snapToStep @valueToDate value
        @valueToAttribute property, value
        @set "date", @get "date"
        value
    
    set_step:( property, value )->
        @properties[ property ] = value
        @valueToAttribute property, value
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
                (.[\d]{1,4})?   # Milliseconds too
            )?                  # End Seconds
        )?                      # End Minutes
    $ ///g).test value

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
class TimeInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "time"
        @valueToDate = timeFromString
        @dateToValue = timeToString
        @isValidValue = isValidTime

        super target

        unless @get("step")? then @set "step", 60
    
    createDummy:->
        dummy = super()
        dummy.append $ "<input type='text' class='value widget-done'></input>
                        <span class='down'></span>
                        <span class='up'></span>"
        dummy
    
    updateDummy:->
        @dummy.find("input").val @get("value").split(":")[0..1].join(":")


# <a name='date'></a>
## Date

# A valid date is a string such as `2012-12-29`.
isValidDate=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}-   # Year
        [\d]{2}-   # Month
        [\d]{2}    # Day of the month
    $ ///g).test value

# A valid date string can be passed directly to the `Date` constructor.
dateFromString=( string )->
    d = new Date string
    # Hours may vary when constructing a `Date` from a date string.
    # The returned date's hours are then reset to `0`.
    d.setHours 0
    d

dateToString=( date )->
    "#{ fill date.getFullYear(), 4 }-#{ fill ( date.getMonth() + 1 ) }-#{ fill date.getDate() }"
   
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
    $ ///g).test value

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
    $ ///g).test value

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
        (.[\d]{1,4})?  # Optionnal milliseconds
        (              # Mandatory terminator
            Z|         # Either Z,
            (\+|\-)+   # +XX:XX or -XX:XX
            [\d]{2}:
            [\d]{2}
        )           
    $ ///g).test value

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
    "#{ dateToString date }T#{ timeToString date }#{ sign }#{ fill hours }:#{ fill minutes }"

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

isValidDateTimeLocal=( value )->
    unless value? then return false
    (/// ^
        [\d]{4}-       # Year
        [\d]{2}-       # Month
        [\d]{2}        # Day of the Month
        T              # Start time token
        [\d]{2}:       # Hours
        [\d]{2}:       # Minutes
        [\d]{2}        # Seconds
        (.[\d]{1,4})?  # Optionnal milliseconds
    $ ///g).test value

datetimeLocalFromString=( string )->
    new Date string

datetimeLocalToString=( date )->
    "#{ dateToString date }T#{ timeToString date }"

# <a name='DateTimeLocalInput'></a>
#### DateTimeLocalInput
class DateTimeLocalInput extends AbstractDateInputWidget
    constructor:( target )->
        @supportedType = "datetime-local"
        @valueToDate = datetimeLocalFromString
        @dateToValue = datetimeLocalToString
        @isValidValue = isValidDateTimeLocal

        super target

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.isValidTime = isValidTime
    window.timeToString = timeToString
    window.timeFromString = timeFromString

    window.isValidDate = isValidDate
    window.dateToString = dateToString
    window.dateFromString = dateFromString

    window.isValidMonth = isValidMonth
    window.monthToString = monthToString
    window.monthFromString = monthFromString

    window.isValidWeek = isValidWeek
    window.weekToString = weekToString
    window.weekFromString = weekFromString

    window.isValidDateTime = isValidDateTime
    window.datetimeToString = datetimeToString
    window.datetimeFromString = datetimeFromString

    window.isValidDateTimeLocal = isValidDateTimeLocal
    window.datetimeLocalToString = datetimeLocalToString
    window.datetimeLocalFromString = datetimeLocalFromString

    window.TimeInput = TimeInput
    window.DateInput = DateInput
    window.MonthInput = MonthInput
    window.WeekInput = WeekInput
    window.DateTimeInput = DateTimeInput
    window.DateTimeLocalInput = DateTimeLocalInput