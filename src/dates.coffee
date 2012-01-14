# <link rel="stylesheet" href="../css/styles.css" media="screen">

MILLISECONDS_IN_SECOND = 1000
MILLISECONDS_IN_MINUTE = MILLISECONDS_IN_SECOND * 60
MILLISECONDS_IN_HOUR   = MILLISECONDS_IN_MINUTE * 60
MILLISECONDS_IN_DAY    = MILLISECONDS_IN_HOUR * 24
MILLISECONDS_IN_WEEK   = MILLISECONDS_IN_DAY * 7

safeInt=( value, offset = 0 )->
    n = parseInt value
    unless isNaN n then n + offset else offset

fill=( s, l = 2 )->
    s = String s
    s = "0#{s}" while s.length < l
    s

findFirstWeekFirstDay=( year )->
    d = new Date year, 0, 1
    day = d.getDay()
    
    if day is 0 then day = 7

    if day > 3 
        d = new Date year, 0, 7 - day + 2
    else 
        d = new Date year, 0, 2 - day

time2date=( time )->
    unless ( new TimeMode ).isValidValue time then throw "time2date only accept valid RFC time"

    [ hours, min, sec ] = time.split ":"
    [ sec, ms ] = if sec? then sec.split "." else [ 0, 0 ] 

    # UTC dates start at 1:00 AM so we have to remove one hour.
    time = safeInt( hours - 1 ) * MILLISECONDS_IN_HOUR   +
           safeInt( min )       * MILLISECONDS_IN_MINUTE +
           safeInt( sec )       * MILLISECONDS_IN_SECOND +
           safeInt( ms )

    d = new Date time
    d

date2time=( date )->
    h  = date.getHours()
    m  = date.getMinutes()
    s  = date.getSeconds()
    ms = date.getMilliseconds()

    time ="#{ fill h }:#{ fill m }:#{ fill s }"

    if ms isnt 0 
        time += ".#{ ms }"
    
    time

week2date=( string )->
    unless ( new WeekMode ).isValidValue string then throw "time2date only accept valid RFC weeks"

    [ year, week ] = ( parseInt(s) for s in string.split "-W" )

    start = findFirstWeekFirstDay year

    d = new Date start.valueOf() + MILLISECONDS_IN_WEEK * ( week - 1 )

date2week=( date )->

    start = findFirstWeekFirstDay date.getFullYear()
    dif   = date.valueOf() - start.valueOf()
    week  = Math.floor ( dif / MILLISECONDS_IN_WEEK ) + 1
    "#{ fill date.getFullYear(), 4 }-W#{ week }"


class TimeMode
    isValidValue:( value )->
        unless value? then return false
        (/// ^
            [\d]{2}                 # Hours are required
            (:[\d]{2}               # Minutes are optional
                (:[\d]{2}           # Seconds as well
                    (.[\d]{1,4})?   # Milliseconds too
                )?                  # End Seconds
            )?                      # End Minutes
        $ ///g).test value
    
    dateFromString:( string )->
        time2date string
    
    dateToString:( date )->
        date2time date

class DateMode 
    isValidValue:( value )->
        unless value? then return false
        (/// ^
            [\d]{4}-   # Year
            [\d]{2}-   # Month
            [\d]{2}    # Day of the month
        $ ///g).test value
    
    dateFromString:( string )->
        returnDate = new Date string
        returnDate.setHours 0
        returnDate
    
    dateToString:( date )->
        "#{ fill date.getFullYear(), 4 }-#{ fill ( date.getMonth() + 1 ) }-#{ fill date.getDate() }"

class MonthMode
    isValidValue:( value )->
        unless value? then return false
        (/// ^
            [\d]{4}-   # Year
            [\d]{2}    # Month
        $ ///g).test value
    
    dateFromString:( string )->
        returnDate = new Date string
        returnDate.setHours 0
        returnDate
    
    dateToString:( date )->
        "#{ fill date.getFullYear(), 4 }-#{ fill ( date.getMonth() + 1 ) }"
    
class WeekMode
    isValidValue:(value)->
        unless value? then return false
        (/// ^
            [\d]{4}    # Year
            -W         # Week separator 
            [\d]{1,2}  # Week number prefixed with W
        $ ///g).test value
    
    dateFromString:( string )->
        week2date string

    dateToString:( date )->
        date2week date

class DateTimeMode
    isValidValue:(value)->
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
            (Z)?           # Optionnal terminator
        $ ///g).test value
    
    dateFromString:( string )->
        [ date, time ] = string.split "T"
        if "Z" in time then time = time.replace "Z", ""

        date = new Date date
        time = time2date time

        # The hour value may vary from 1 quite randomly
        # when creating a `Date` with a date string.
        # To ensure that the sum of `date` and `time` will
        # not have one more hour than the passed-in string
        # the hour of the date have to be reset to `1`. 
        date.setHours 1

        ms = date.valueOf() + time.valueOf()
        
        new Date ms
    
    dateToString:( date )->
        "#{ fill date.getFullYear(), 4 }-#{ fill ( date.getMonth() + 1 ) }-#{ fill date.getDate() }T#{ date2time date }"

class DateInput extends Widget
    defaultMode:"datetime"
    modes:[ "date", "month", "week", "time", "datetime", "datetime-local" ]
    modesInstances:
        'date':new DateMode
        'month':new MonthMode
        'week':new WeekMode
        'time':new TimeMode
        'datetime':new DateTimeMode
        'datetime-local':new DateTimeMode
    
    constructor:( target, mode = @defaultMode )->
        if target instanceof Date
            super()
            date = target
            if mode not in @modes
                mode = @defaultMode
        else
            super target
            if @hasTarget 
                mode = @valueFromAttribute "type"
            date = new Date

        @currentMode = @modesInstances[ mode ]

        if @hasTarget 
            date = @dateFromAttribute  "value"
            min  = @dateFromAttribute  "min"
            max  = @dateFromAttribute  "max"
        
        @createProperty "date", date
        @createProperty "mode", mode
        @createProperty "min", min
        @createProperty "max", max

        @dateSetProgramatically = false
    
    #### Target Management 

    checkTarget:(target)->
        unless @isInputWithType.apply this, [ target ].concat @modes
            throw "The DateTime target must be of type #{ @modes.join ', ' }"
    
    dateFromAttribute:( attr )->
        value = @valueFromAttribute attr

        unless @currentMode.isValidValue value then return new Date 0
        
        @currentMode.dateFromString value
    
    #### Dummy Management

    createDummy:->
        $ "<span class='dateinput'></span>"

    #### Properties Accessors

    set_value:( property, value )->
        unless @currentMode.isValidValue value then return @get "value"

        super property, value

        @dateSetProgramatically = true
        @set "date", @currentMode.dateFromString value
        @dateSetProgramatically = false 

        value

    set_date:( property, value )->
        if @dateSetProgramatically then return value

        unless value? then return @get "date"

        @set "value", @currentMode.dateToString value
        value
    
    set_mode:( property, value )->
        unless value in @modes then return @get "mode"
        
        @currentMode = @modesInstances[ value ]
        @set "date", @get "date"

        value

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.time2date = time2date
    window.date2time = date2time
    window.week2date = week2date
    window.date2week = date2week
    window.DateInput = DateInput