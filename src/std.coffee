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
    dif   = this - start - @getTimezoneOffset() * Date.MILLISECONDS_IN_MINUTE
    week  = Math.floor ( dif / Date.MILLISECONDS_IN_WEEK ) + 1
    week or 52

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
