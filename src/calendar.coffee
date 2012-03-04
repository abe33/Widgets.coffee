# <link rel="stylesheet" href="../css/styles.css" media="screen">

Date::clone=-> new Date @valueOf()

Date::incrementDate=( amount )->
    @setDate @getDate() + amount
    this

Date::incrementMonth=( amount )->
    @setMonth @getMonth() + amount
    this

Date::firstDateOfMonth=->
    date = @clone()
    date.setDate 1
    date

Date::lastDateOfMonth=->
    date = @clone()
    date.setDate 1
    date.incrementMonth 1
    date.incrementDate -1
    date

Date.findFirstWeekFirstDay=(year)->
    d = new Date year, 0, 1, 0, 0, 0, 0
    day = d.getDay()

    day = 7 if day is 0

    if day > 4
        new Date year, 0, 9 - day, 0
    else
        new Date year, 0, 2 - day, 0

Date::getWeek=( dowOffset = 0 )->
    start = Date.findFirstWeekFirstDay @getFullYear()
    dif   = this - start - @getTimezoneOffset() * MILLISECONDS_IN_MINUTE
    week  = Math.floor ( dif / MILLISECONDS_IN_WEEK ) + 1
    week or 52

Date::isToday=->
    today = new Date

    @getFullYear() is today.getFullYear() and
    @getMonth()    is today.getMonth()    and
    @getDate()     is today.getDate()

Date::monthLength=-> @lastDateOfMonth().getDate()

# A group of *"constants"* for basic time and dates computations.
MILLISECONDS_IN_SECOND = 1000
MILLISECONDS_IN_MINUTE = MILLISECONDS_IN_SECOND * 60
MILLISECONDS_IN_HOUR   = MILLISECONDS_IN_MINUTE * 60
MILLISECONDS_IN_DAY    = MILLISECONDS_IN_HOUR * 24
MILLISECONDS_IN_WEEK   = MILLISECONDS_IN_DAY * 7

DAYS =  ["M","T","W","T","F","S","S",]

class Calendar extends Widget
    constructor:( @value = new Date(), @mode = "date" )->
        super()
        @updateDummy()

    #### Dummy Management

    createDummy:->
        dummy = $ "<span class='calendar'>
                     <table></table>
                   </span>"

        dummy

    updateDummy:->
        value = @get("value").clone()
        @updateCells value

        value.setDate 1
        monthStartDay = value.getDay() - 1
        monthStartDay = 6 if monthStartDay is -1

        date = value.clone()
        date.incrementDate -monthStartDay

        @dummy.find("td").each ( i, o )=>
            td = $ o
            td.text date.getDate()
            @toggleState td, date
            date.incrementDate 1

    updateCells:( value )->

        table = @dummy.find "table"
        table.children().remove()

        header = $ "<tr></tr>"
        header.append "<th>#{ day }</th>" for day in DAYS
        table.append header

        for y in [0..@linesNeeded value]
            line = $ "<tr></tr>"
            for x in [0..6]
                line.append "<td></td>"
            table.append line

    linesNeeded:( value )->
        day = value.firstDateOfMonth().getDay()
        day = 7 if day is 0
        days = value.monthLength() + day
        Math.ceil( days / 7 ) - 1

    #### Selection Management

    toggleState:( td, date )->
        value = @get("value")
        sameDate = date.getDate() is value.getDate()
        sameMonth = date.getMonth() is value.getMonth()
        sameWeek = date.getWeek() is value.getWeek()

        switch @get("mode")
            when "date"  then td.addClass "selected" if sameDate and sameMonth
            when "month" then td.addClass "selected" if sameMonth
            when "week"  then td.addClass "selected" if sameWeek

        td.addClass "blurred" if not sameMonth
        td.addClass "today" if date.isToday()


    #### Properties Accessors

    set_value:( property, value )->
        @[ property ] = value
        @updateDummy()
        value

    set_mode:( property, value )->
        if value not in [ "date", "month", "week" ] then return @get "mode"

        @[ property ] = value
        @updateDummy()
        value



@Calendar = Calendar
