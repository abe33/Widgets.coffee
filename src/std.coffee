# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# This file contains all the additions to the Javascript standard classes
# and utilities used accross the widgets files.

## Date

# A group of constants for basic time and dates computations.
Date.MILLISECONDS_IN_SECOND = 1000
Date.MILLISECONDS_IN_MINUTE = Date.MILLISECONDS_IN_SECOND * 60
Date.MILLISECONDS_IN_HOUR   = Date.MILLISECONDS_IN_MINUTE * 60
Date.MILLISECONDS_IN_DAY    = Date.MILLISECONDS_IN_HOUR * 24
Date.MILLISECONDS_IN_WEEK   = Date.MILLISECONDS_IN_DAY * 7

# Returns a new `Date` object that is a copy of the current object.
Date::clone=-> new Date @valueOf()

#### Fluent Accessors

# Either returns the full year of the date if called without argument
# or set the full year of the current date and return the date object
# if called with an argument.
Date::year=( year )->
  if year? then @setFullYear year; this else @getFullYear()

# Either returns the month of the date if called without argument
# or set the month of the current date and return the date object
# if called with an argument.
Date::month=( month )->
  if month? then @setMonth month; this else @getMonth()

# Either returns the date of the date if called without argument
# or set the date of the current date and return the date object
# if called with an argument.
Date::date=( date )->
  if date? then @setDate date; this else @getDate()

# Either returns the hours of the date if called without argument
# or set the hours of the current date and return the date object
# if called with an argument.
Date::hours=( hours )->
  if hours? then @setHours hours; this else @getHours()

# Either returns the minutes of the date if called without argument
# or set the minutes of the current date and return the date object
# if called with an argument.
Date::minutes=( minutes )->
  if minutes? then @setMinutes minutes; this else @getMinutes()

# Either returns the seconds of the date if called without argument
# or set the seconds of the current date and return the date object
# if called with an argument.
Date::seconds=( seconds )->
  if seconds? then @setSeconds seconds; this else @getSeconds()

# Either returns the milliseconds of the date if called without argument
# or set the milliseconds of the current date and return the date object
# if called with an argument.
Date::milliseconds=( milliseconds )->
  if milliseconds? then @setMilliseconds milliseconds; this
  else @getMilliseconds()

#### Date Extra Informations

# Returns the week in which is the current date object. The `dowOffset`
# arguments allow to change the day starting the weeks. For instance,
# passing `-1` as offset will returns weeks that starts a sunday (monday is 1
# and sunday is 0).
Date::week=( dowOffset = 0 )->
  start = Date.findFirstWeekFirstDay @getFullYear(), dowOffset
  timeOffset = ( @getTimezoneOffset() + 60 ) * Date.MILLISECONDS_IN_MINUTE
  dif   = this - start - timeOffset
  week  = Math.floor ( dif / Date.MILLISECONDS_IN_WEEK ) + 1
  week or @firstDateOfMonth().incrementDate(-1).week()

# Returns a `Date` object that represent the first day in the current month.
Date::firstDateOfMonth=-> @clone().date 1

# Returns a `Date` object that represent the last day in the current month.
Date::lastDateOfMonth=-> @clone().date(1).incrementMonth(1).incrementDate(-1)

# Returns the number of days in the current month.
Date::monthLength=-> @lastDateOfMonth().date()

# Returns the first day in the first week of the passed-in `year`.
# The day starting the weeks can be adjusted with the `dowOffset`
# argument. For instance, passing `-1` as offset will returns a sunday
# instead of a monday.
Date.findFirstWeekFirstDay=( year, dowOffset=0 )->
  d = new Date year, 0, 1, 0, 0, 0, 0
  day = d.getDay() + dowOffset * -1

  day = 7 if day is 0

  if day > 4 then new Date year, 0, 9 - day, 0
  else new Date year, 0, 2 - day, 0

#### Date Manipulation

# Increments the current `date` property of the `Date` object by `amount`
# and returns the current date object.
Date::incrementDate=( amount )-> @date @date() + amount

# Increments the current `month` property of the `Date` object by `amount`
# and returns the current date object.
Date::incrementMonth=( amount )-> @month @month() + amount

# Increments the current `year` property of the `Date` object by `amount`
# and returns the current date object.
Date::incrementYear=( amount )-> @year @year() + amount

#### Date Comparison

# Compares two `Date` objets. Both the date and the time ar compared.
# If `milliseconds` is true the comparison is also performed on the
# `milliseconds` property of the two dates.
Date::equals=( date, milliseconds=false )->
  @dateEquals(date) and @timeEquals(date, milliseconds)

# Compare the date of two `Date` objects. That means that two dates
# with different times will match if their year, month and date
# are equals.
Date::dateEquals=(date)->
  @year()  is date.year()  and
  @month() is date.month() and
  @date()  is date.date()

# Compare the time of two `Date` object. That means that two dates
# with different dates will match if their hours, minutes and seconds
# are equals. The comparison can be extended to the milliseconds of
# each date objects by passing true in the `milliseconds` argument.
Date::timeEquals=( date, milliseconds=false )->
  @hours()   is date.hours()   and
  @minutes() is date.minutes() and
  @seconds() is date.seconds() and
  if milliseconds then @milliseconds() is date.milliseconds() else true

# Returns true if the current date is today.
Date::isToday=-> @dateEquals new Date

#### Time Conversion

# Match if the passed-in string is a valid time string.
# The following strings are considered as valid :
# `10`, `10:15`, `10:15:40` or `10:15:40.768`
Date.isValidTime=( value )->
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
Date.timeFromString=( string )->
  [ hours, min, sec ] = string.split ":"
  [ sec, ms ] = if sec? then sec.split "." else [ 0, 0 ]

  # UTC dates start at 1:00 AM so we have to remove one hour.
  time = safeInt( hours - 1 ) * Date.MILLISECONDS_IN_HOUR   +
         safeInt( min )       * Date.MILLISECONDS_IN_MINUTE +
         safeInt( sec )       * Date.MILLISECONDS_IN_SECOND +
         safeInt( ms )

  d = new Date time
  d

# Converts a `Date` object in a string such as `10:15:40`.
# If the milliseconds count is different than `0` then the
# output will look as `10:15:40.768`.
Date.timeToString=( date )->
  h  = date.hours()
  m  = date.minutes()
  s  = date.seconds()
  ms = date.milliseconds()

  time ="#{ fill h }:#{ fill m }:#{ fill s }"

  if ms isnt 0
    time += ".#{ ms }"

  time

#### Date Conversion

# A valid date is a string such as `2012-12-29`.
Date.isValidDate=( value )->
  unless value? then return false
  (/// ^
    [\d]{4}-   # Year
    [\d]{2}-   # Month
    [\d]{2}    # Day of the month
  $ ///).test value

# A valid date string can be passed directly to the `Date` constructor.
Date.dateFromString=( string )->
  d = new Date string
  # Hours may vary when constructing a `Date` from a date string.
  # The returned date's hours are then reset to `0`.
  d.setHours 0
  d

Date.dateToString=( date )->
  [ "#{ fill date.year(), 4   }",
    "#{ fill date.month() + 1 }",
    "#{ fill date.date()      }",
  ].join "-"

#### Month Conversion

Date.isValidMonth=( value )->
  unless value? then return false
  (/// ^
    [\d]{4}-   # Year
    [\d]{2}    # Month
  $ ///).test value

Date.monthFromString=( string )->
  d = new Date string
  # Hours may vary when constructing a `Date`.
  # The returned date's hours are then reset to `0`.
  d.setHours 0
  d

Date.monthToString=( date )->
  "#{ fill date.year(), 4 }-#{ fill ( date.month() + 1 ) }"

#### Week Conversion

Date.isValidWeek=( value )->
  unless value? then return false
  (/// ^
    [\d]{4}    # Year
    -W         # Week separator
    [\d]{2}    # Week number prefixed with W
  $ ///).test value

# Converts a string such as `2011-W09` into a `Date` object
# that represent the first day of the corresponding week, even
# if it's not in the same year.
Date.weekFromString=( string )->
  [ year, week ] = ( parseInt s for s in string.split "-W" )

  Date.getWeekDate year, week

Date.weekToString=( date )->
  "#{ fill date.year(), 4 }-W#{ fill date.week() }"

Date.getWeekDate=( year, week )->
  start = Date.findFirstWeekFirstDay year
  date = new Date start.valueOf() + Date.MILLISECONDS_IN_WEEK * ( week - 1 )
  date.setHours 0
  date.setMinutes 0
  date.setSeconds 0
  date.setMilliseconds 0
  date

#### DateTime Conversion

Date.isValidDateTime=( value )->
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

Date.datetimeFromString=( string )->
  new Date string

Date.datetimeToString=( date )->
  offset = date.getTimezoneOffset()
  sign = "-"
  if offset < 0
    sign = "+"
    offset *= -1

  minutes = offset % 60
  hours = ( offset - minutes ) / 60
  [ "#{ Date.dateToString date }T",
    "#{ Date.timeToString date }",
    "#{ sign }#{ fill hours }:#{ fill minutes }"
  ].join ""

#### DateTimeLocal Conversion

Date.dateTimeLocalRE= ->
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

Date.isValidDateTimeLocal=( value )->
  unless value? then return false
  Date.dateTimeLocalRE().test value

Date.datetimeLocalFromString=( string )->
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
    seconds, milliseconds ] = Date.dateTimeLocalRE().exec string

  pI = parseInt
  new Date pI( year    , 10 ),
           pI( month   , 10 ) - 1,
           pI( day     , 10 ),
           pI( hours   , 10 ),
           pI( minutes , 10 ),
           pI( seconds , 10 )
           if milliseconds? then pI milliseconds.replace(".", ""), 10 else 0

Date.datetimeLocalToString=( date )->
  "#{ Date.dateToString date }T#{ Date.timeToString date }"


## Utilities

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
