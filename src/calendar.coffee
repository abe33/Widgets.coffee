# <link rel="stylesheet" href="../css/styles.css" media="screen">

class Calendar extends Widget

    @DAYS   = ["M","T","W","T","F","S","S",]
    @MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

    constructor:( @value = new Date(), @mode = "date" )->
        super()
        @display @value
        @dummy.hide()

    display:( date )->
        @month = date.firstDateOfMonth()
        @updateDummy()

    #### Dummy Management

    createDummy:->
        dummy = $ "<span class='calendar'>
                     <h3></h3>
                     <a class='prev-year'>Previous Year</a>
                     <a class='prev-month'>Previous Month</a>
                     <a class='next-month'>Next Month</a>
                     <a class='next-year'>Next Year</a>
                     <table></table>
                     <a class='today'>Today</a>
                   </span>"

        dummy.find("a.today").click (e)=>
            @display new Date unless @cantInteract()
        dummy.find("a.prev-year").click (e)=>
            @display @month.incrementYear -1 unless @cantInteract()
        dummy.find("a.prev-month").click (e)=>
            @display @month.incrementMonth -1 unless @cantInteract()
        dummy.find("a.next-month").click (e)=>
            @display @month.incrementMonth 1 unless @cantInteract()
        dummy.find("a.next-year").click (e)=>
            @display @month.incrementYear 1 unless @cantInteract()

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

        h3 = @dummy.find("h3")
        h3.text "#{ Calendar.MONTHS[ @month.month() ] } #{ @month.year() }"

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
        sameWeek = date.week() is value.week()
        sameMonth = date.month() is value.month()
        sameYear = date.year() is value.year()


        switch @get("mode")
            when "date"
                td.addClass "selected" if sameDate and sameMonth and sameYear
            when "month"
                td.addClass "selected" if sameMonth and sameYear
            when "week"
                td.addClass "selected" if sameWeek and sameYear

        td.addClass "blurred" if date.month() isnt @month.month()
        td.addClass "today" if date.isToday()


    #### Properties Accessors

    set_value:( property, value )->
        super property, value
        @display value
        value

    set_mode:( property, value )->
        if value not in [ "date", "month", "week" ] then return @get "mode"

        @[ property ] = value
        @updateDummy()
        value

    #### Signals handler

    dialogRequested:( target )->
        @caller = target
        @dummy.show()

@Calendar = Calendar
