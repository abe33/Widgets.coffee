# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>

# The `dates.coffee` file contains all the widgets that handles date and time
# related inputs.

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

isValidWeek=(value)->
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
    [ year, week ] = ( parseInt(s) for s in string.split "-W" )

    d = getWeekDate year, week
    # Hours may vary when constructing a `Date`.
    # The returned date's hours are then reset to `0`.
    d.setHours 0
    d

weekToString=( date )->
    start = findFirstWeekFirstDay date.getFullYear()
    dif   = date.valueOf() - start.valueOf()
    week  = Math.floor ( dif / MILLISECONDS_IN_WEEK ) + 1
    "#{ fill date.getFullYear(), 4 }-W#{ fill week }"

# Returns a `Date` that is the first day of the first week of the year.
# In fact, the returned `Date` can represent a day that is not in `year`
# as a year can start in the middle of a week. 
findFirstWeekFirstDay=( year )->
    d = new Date year, 0, 1
    day = d.getDay()
    
    if day is 0 then day = 7

    if day > 3 
        new Date year, 0, 7 - day + 2
    else 
        new Date year, 0, 2 - day
    
getWeekDate=( year, week )->
    start = findFirstWeekFirstDay year
    new Date start.valueOf() + MILLISECONDS_IN_WEEK * ( week - 1 )

isValidDateTime=(value)->
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

datetimeFromString=( string )->
    [ date, time ] = string.split "T"
    if "Z" in time then time = time.replace "Z", ""

    date = dateFromString date
    time = timeFromString time

    # The hour value may vary from 1 quite randomly
    # when creating a `Date` with a date string.
    # To ensure that the sum of `date` and `time` will
    # not have one more hour than the passed-in string
    # the hour of the date have to be reset to `1`. 
    date.setHours 1

    ms = date.valueOf() + time.valueOf()
    
    new Date ms

datetimeToString=( date )->
    "#{ dateToString date }T#{ timeToString date }"

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