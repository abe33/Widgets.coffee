runTests=()->

    module "date monkey patch tests"

    test "Date.findFirstWeekFirstDay should always returns a monday", ->

        for year in [2000..2020]
            assertThat Date.findFirstWeekFirstDay(year).getDay(),
                       describedAs equalTo(1), "For year #{year}"

    test "Date::getWeek should return a valid week", ->

        assertThat new Date(2012,0,1).getWeek(), equalTo 52

        for date in [2..8]
            assertThat new Date(2012,0,date).getWeek(), equalTo 1

        for date in [9..15]
            assertThat new Date(2012,0,date).getWeek(), equalTo 2

    module "calendar tests"

    test "Calendar should provide a mode property", ->
        calendar = new Calendar

        assertThat calendar.get("mode"), equalTo "date"

    test "Calendar should accept these modes", ->

        calendar = new Calendar

        calendar.set "mode", "month"
        assertThat calendar.get("mode"), equalTo "month"

        calendar.set "mode", "week"
        assertThat calendar.get("mode"), equalTo "week"

    test "Calendar shouldn't accept any other modes", ->

        calendar = new Calendar

        calendar.set "mode", "foo"
        calendar.set "mode", null
        calendar.set "mode", 10

        assertThat calendar.get("mode"), equalTo "date"

    test "Calendar should have a Date object as value", ->
        d = new Date
        calendar = new Calendar d

        assertThat calendar.get("value"), dateEquals d

    test "Calendar should always have a Date as value", ->

        calendar = new Calendar

        assertThat calendar.get("value") instanceof Date

    test "Calendar should provides a dummy", ->

        calendar = new Calendar

        assertThat calendar.dummy, notNullValue()
        assertThat calendar.dummy.hasClass "calendar"

    test "Calendar's dummy should contains a table", ->

        calendar = new Calendar new Date 2012, 1, 22
        table =  calendar.dummy.find "table"
        assertThat table.length, equalTo 1
        assertThat table.find("tr").length, equalTo 6
        assertThat table.find("tr").first().find("th").length, equalTo 7

        calendar = new Calendar new Date 2011, 9, 15
        table =  calendar.dummy.find "table"
        assertThat table.find("tr").length, equalTo 7
        assertThat table.find("tr").first().find("th").length, equalTo 7

    test "The Calendar's table should display the days
          according to its value", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        days = [
            30, 31, 1,  2,  3,  4,  5,
            6,  7,  8,  9,  10, 11, 12,
            13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26,
            27, 28, 29, 1,  2,  3,  4,
        ]

        calendar.dummy.find("td").each (i,o)->
            assertThat $(o).text(), equalTo days[ i ]

    test "The Calendar's table should be updated after
          the value was changed", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        days = [
            26, 27, 28, 29, 30, 31, 1,
            2,  3,  4,  5,  6,  7,  8,
            9,  10, 11, 12, 13, 14, 15,
            16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, 26, 27, 28, 29,
            30, 31, 1,  2,  3,  4,  5,
        ]

        calendar.set "value", new Date 2012, 0, 15
        calendar.dummy.find("td").each (i,o)->
            assertThat $(o).text(), equalTo days[ i ]

    test "The cells of the Calendar's table that aren't
          in the current month should be marked as blurred", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        daysOff = [0,1,31,32,33,34]

        calendar.dummy.find("td").each (i,o)->
            if i in daysOff then assertThat $(o).hasClass "blurred"

    test "Setting the mode of the calendar should call updateDummy", ->

        updateDummyCalled = false

        class MockCalendar extends Calendar
            updateDummy:->
                super()
                updateDummyCalled = true

        calendar = new MockCalendar
        updateDummyCalled = false

        calendar.set "mode", "month"

        assertThat updateDummyCalled

    test "The current day should be highlighted", ->

        calendar = new Calendar
        assertThat calendar.dummy.find(".today").length, equalTo 1


    module "calendar date tests"
    test "The value of a Calendar should be marked by a selected class", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        assertThat $(calendar.dummy.find("td")[23]).hasClass "selected"

    module "calendar month tests"
    test "The days in the month value of a Calendar
          should be marked by a selected class", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d, "month"

        $(calendar.dummy.find("td")[2..30]).each (i,o)->
            assertThat $(o).hasClass "selected"

    module "calendar week tests"

    test "The days in the week value of a Calendar
          should be marked by a selected class", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d, "week"

        $(calendar.dummy.find("td")[21..27]).each (i,o)->
            assertThat $(o).hasClass "selected"

        d = new Date 2011,5,17
        calendar = new Calendar d, "week"

        $(calendar.dummy.find("td")[14..20]).each (i,o)->
            assertThat $(o).hasClass "selected"




    # some live instances
    d = new Date().incrementDate 3
    # d = new Date 2011,5,17
    calendar1 = new Calendar d, "date"
    calendar2 = new Calendar d, "month"
    calendar3 = new Calendar d, "week"

    calendar1.addClasses "dummy"
    calendar2.addClasses "dummy"
    calendar3.addClasses "dummy"

    # calendar2.set "readonly", true
    # calendar3.set "disabled", true

    $("#qunit-header").before $ "<h4>Calendar</h4>"
    calendar1.before "#qunit-header"
    calendar2.before "#qunit-header"
    calendar3.before "#qunit-header"

$( document ).ready runTests
