# <link rel="stylesheet" href="../css/styles.css" media="screen">

class Calendar extends Widget

    @DAYS =  ["M","T","W","T","F","S","S",]

    constructor:( @value = new Date(), @mode = "date" )->
        super()
        @display @value

    display:( date )->
        @month = date.firstDateOfMonth()
        @updateDummy()

    #### Dummy Management

    createDummy:->
        dummy = $ "<span class='calendar'>
                     <table></table>
                   </span>"

        dummy

    updateDummy:->
        @updateCells @month

        monthStartDay = @month.getDay() - 1
        monthStartDay = 6 if monthStartDay is -1

        date = @month.clone().incrementDate -monthStartDay

        @dummy.find("td").each ( i, o )=>
            td = $ o
            td.text date.date()
            td.attr "name", Date.dateToString date

            td.parent().find("th").text date.week() if td.index() is 1

            @toggleState td, date
            date.incrementDate 1

    updateCells:( value )->

        table = @dummy.find "table"
        table.find("td").unbind "mouseup", @cellDelegate
        table.children().remove()

        header = $ "<tr><th></th></tr>"
        header.append "<th>#{ day }</th>" for day in Calendar.DAYS
        table.append header

        for y in [0..@linesNeeded value]
            line = $ "<tr><th class='week'></th></tr>"
            for x in [0..6]
                cell = $ "<td></td>"
                cell.bind "mouseup", @cellDelegate=(e)=>
                    unless @cantInteract()
                        @set "value",
                             Date.dateFromString $(e.target).attr "name"
                line.append cell
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
        @display value
        value

    set_mode:( property, value )->
        if value not in [ "date", "month", "week" ] then return @get "mode"

        @[ property ] = value
        @updateDummy()
        value

@Calendar = Calendar
