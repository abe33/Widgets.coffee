# <link rel="stylesheet" href="../css/styles.css" media="screen">

Date::clone=-> new Date @valueOf()

Date::incrementDate=( amount )->
    @setDate @getDate() + amount

Date::incrementMonth=( amount )->
    @setMonth @getMonth() + amount

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

Date::monthLength=-> @lastDateOfMonth().getDate()

DAYS =  ["S","M","T","W","T","F","S"]

class Calendar extends Widget
    constructor:( value )->
        super()
        @mode = "date"
        @value = if value? then value else new Date

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
        monthStartDay = value.getDay()

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
        days = value.monthLength() + value.firstDateOfMonth().getDay()
        Math.ceil( days / 7 ) - 1

    #### Selection Management

    toggleState:( td, date )->
        value = @get("value")

        if date.getDate() is value.getDate()
            td.addClass "selected"
        else if date.getMonth() isnt value.getMonth()
            td.addClass "blurred"


    #### Properties Accessors

    set_value:( property, value )->
        @[ property ] = value
        @updateDummy()

    set_mode:( property, value )->
        unless value in [ "date", "month", "week" ] then return @get "mode"

        @[ property ] = value



@Calendar = Calendar
