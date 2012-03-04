# <link rel="stylesheet" href="../css/styles.css" media="screen">

class Calendar extends Widget

    @DAYS =  ["M","T","W","T","F","S","S",]

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
            td.text date.date()
            @toggleState td, date
            date.incrementDate 1

    updateCells:( value )->

        table = @dummy.find "table"
        table.children().remove()

        header = $ "<tr></tr>"
        header.append "<th>#{ day }</th>" for day in Calendar.DAYS
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
        sameDate = date.date() is value.date()
        sameMonth = date.month() is value.month()
        sameWeek = date.week() is value.week()

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
