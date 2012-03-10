runTests=()->

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
        assertThat table.find("tr").first().find("th").length, equalTo 8

        calendar = new Calendar new Date 2011, 9, 15
        table =  calendar.dummy.find "table"
        assertThat table.find("tr").length, equalTo 7
        assertThat table.find("tr").first().find("th").length, equalTo 8

    test "Calendar's dummy should contains the week numbers
          in a row header cell", ->

        calendar = new Calendar new Date 2012, 0, 1
        table =  calendar.dummy.find "table"

        weeks = [52,1,2,3,4,5]
        $(table.find("tr")[1..-1]).each (i,o)->
            tr = $(o)
            assertThat tr.find("th").text(), equalTo weeks[i]
            assertThat tr.find("th").hasClass "week"


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
        assertThat calendar.dummy.find("td.today").length, equalTo 1

    test "Clicking on a cell should change the value and update the table", ->

        d = new Date 2012, 1, 22
        calendar = new Calendar d

        cell = $(calendar.dummy.find("td")[12]).mouseup()

        assertThat $(calendar.dummy.find("td")[12]).hasClass "selected"
        assertThat calendar.get("value"), dateEquals new Date 2012, 1, 11

    test "Clicking on a cell of a disabled calendar shouldn't
          change the value", ->

        d = new Date 2012, 1, 22
        calendar = new Calendar d

        calendar.set "disabled", true

        cell = $(calendar.dummy.find("td")[12]).mouseup()

        assertThat $(calendar.dummy.find("td")[23]).hasClass "selected"
        assertThat calendar.get("value"), dateEquals new Date 2012, 1, 22

    test "Clicking on a cell of a readonly calendar shouldn't
          change the value", ->

        d = new Date 2012, 1, 22
        calendar = new Calendar d

        calendar.set "readonly", true

        cell = $(calendar.dummy.find("td")[12]).mouseup()

        assertThat $(calendar.dummy.find("td")[23]).hasClass "selected"
        assertThat calendar.get("value"), dateEquals new Date 2012, 1, 22

    test "Calendar should be able to display a month different than the
          value ones without changing the value", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.display new Date 2012, 1

        days = [
            30, 31, 1,  2,  3,  4,  5,
            6,  7,  8,  9,  10, 11, 12,
            13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26,
            27, 28, 29, 1,  2,  3,  4,
        ]

        calendar.dummy.find("td").each (i,o)->
            assertThat $(o).text(), equalTo days[ i ]
            if i in [ 0, 1, 31, 32, 33, 34 ]
                assertThat $(o).hasClass "blurred"
            else
                assertThat not $(o).hasClass "blurred"


    test "Calendar should provide a button that switch
          the display on today when clicked", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.dummy.find("a.today").click()

        assertThat calendar.month.month(), equalTo 2

    test "Calendar should provide a header that display the current month", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        assertThat calendar.dummy.find("h3").text(), equalTo "Jan 2012"

    test "Calendar should provide a button that increment
          the displayed month when clicked", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.dummy.find("a.next-month").click()

        assertThat calendar.month.month(), equalTo 1

    test "Calendar should provide a button that decrement
          the displayed month when clicked", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.dummy.find("a.prev-month").click()

        assertThat calendar.month.month(), equalTo 11

    test "Calendar should provide a button that increment
          the displayed year when clicked", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.dummy.find("a.next-year").click()

        assertThat calendar.month.year(), equalTo 2013

    test "Calendar should provide a button that decrement
          the displayed year when clicked", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.dummy.find("a.prev-year").click()

        assertThat calendar.month.year(), equalTo 2011

    test "Disabled Calendar shouldn't allow to change the display", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.set "disabled", true

        calendar.dummy.find("a.today").click()
        calendar.dummy.find("a.prev-year").click()
        calendar.dummy.find("a.prev-year").click()
        calendar.dummy.find("a.next-year").click()
        calendar.dummy.find("a.prev-month").click()
        calendar.dummy.find("a.prev-month").click()
        calendar.dummy.find("a.next-month").click()

        assertThat calendar.month.year(), equalTo 2012
        assertThat calendar.month.month(), equalTo 0

    test "Readonly Calendar shouldn't allow to change the display", ->

        d = new Date 2012, 0, 1
        calendar = new Calendar d

        calendar.set "readonly", true

        calendar.dummy.find("a.today").click()
        calendar.dummy.find("a.prev-year").click()
        calendar.dummy.find("a.prev-year").click()
        calendar.dummy.find("a.next-year").click()
        calendar.dummy.find("a.prev-month").click()
        calendar.dummy.find("a.prev-month").click()
        calendar.dummy.find("a.next-month").click()

        assertThat calendar.month.year(), equalTo 2012
        assertThat calendar.month.month(), equalTo 0

    test "Changing the value should dispatch a valueChanged signal", ->

        signalCalled = null
        signalSource = null
        signalValue = null
        calendar = new Calendar

        calendar.valueChanged.add ( widget, value )->
            signalCalled = true
            signalSource = widget
            signalValue = value

        d = new Date 2011, 1, 1
        calendar.set "value", d

        assertThat signalCalled
        assertThat signalSource is calendar
        assertThat signalValue, dateEquals d

    test "A Calendar should be hidden at start", ->

        calendar = new Calendar

        assertThat calendar.dummy.attr("style"), contains "display: none"

    test "A Calendar should respond to a dialogRequested signal
          by opening itself", ->

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date

        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        assertThat calendar.dummy.attr("style"), contains "display: block"
        assertThat calendar.caller is widget

    test "Calendar should display the caller's value
          after dialogRequested was triggered", ->

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22

        d = new Date 2012, 1, 22
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        assertThat calendar.get("value"), dateEquals d


    test "Clicking outside of the widgfet should close it", ->

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22

        d = new Date 2012, 1, 22
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        $(document).mouseup()

        assertThat calendar.dummy.attr("style"), contains "display: none"

    test "Clicking on the widgfet shouldn't close it", ->

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22

        d = new Date 2012, 1, 22
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        calendar.dummy.mouseup()

        assertThat calendar.dummy.attr("style"), contains "display: block"

    test "Closing the Calendar with a click outside should affect
          the new value to the caller", ->

        setterCalled = null
        setterValue = null

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22
            set_date:(property, value)->
                setterCalled = property
                setterValue = value

        d = new Date 2007, 5, 17
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        calendar.set "value", d

        $(document).mouseup()

        assertThat setterCalled is "date"
        assertThat setterValue, dateEquals d

    test "Closing the Calendar with the enter key should affect
          the new value to the caller", ->

        setterCalled = null
        setterValue = null

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22
            set_date:(property, value)->
                setterCalled = property
                setterValue = value

        d = new Date 2007, 5, 17
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        calendar.set "value", d

        calendar.keydown
            keyCode:keys.enter
            ctrlKey:false
            altKey:false
            shiftKey:false

        assertThat setterCalled is "date"
        assertThat setterValue, dateEquals d

    test "Clicking on a table cell should close the dialog", ->

        setterCalled = null

        class MockWidget extends Widget
            createDummy:-> $ "<span></span>"

            get_date:(property)-> new Date 2012, 1, 22
            set_date:(property, value)->
                setterCalled = property

        d = new Date 2007, 5, 17
        widget = new MockWidget
        calendar = new Calendar

        calendar.dialogRequested widget

        calendar.dummy.find("td").first().mouseup()

        assertThat setterCalled is "date"
        assertThat calendar.dummy.attr("style"), contains "display: none"

    module "calendar date tests"

    test "The value of a Calendar should be marked by a selected class", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        assertThat $(calendar.dummy.find("td")[23]).hasClass "selected"

    test "The value of a Calendar shouldn't be marked by a selected class
          when the year is different", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d

        calendar.display new Date 2011, 1

        assertThat not calendar.dummy.find("td").hasClass "selected"

    module "calendar month tests"

    test "The days in the month value of a Calendar
          should be marked by a selected class", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d, "month"

        $(calendar.dummy.find("td")[2..30]).each (i,o)->
            assertThat $(o).hasClass "selected"

    test "The value of a month Calendar shouldn't be marked
          by a selected class when the year is different", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d, "month"

        calendar.display new Date 2011, 1

        assertThat not calendar.dummy.find("td").hasClass "selected"


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

        d = new Date 2012,2,7
        calendar = new Calendar d, "week"

        $(calendar.dummy.find("tr")[2]).find("td").each (i,o)->
            assertThat $(o).hasClass "selected"

    test "The value of a month Calendar shouldn't be marked
          by a selected class when the year is different", ->
        d = new Date 2012, 1, 22
        calendar = new Calendar d, "week"

        calendar.display new Date 2011, 1

        assertThat not calendar.dummy.find("td").hasClass "selected"


    # some live instances
    d = new Date().incrementDate 10
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
