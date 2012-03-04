$(document).ready ->

    module "date extensions tests"

    test "Date.findFirstWeekFirstDay should always returns a monday
          when called without an offset", ->

        for year in [2000..2020]
            assertThat Date.findFirstWeekFirstDay(year).getDay(),
                       describedAs equalTo(1), "For year #{year}"

    test "Date.findFirstWeekFirstDay should always returns a sunday
          when called with an offset of -1", ->

        for year in [2000..2020]
            assertThat Date.findFirstWeekFirstDay(year,-1).getDay(),
                       describedAs equalTo(0), "For year #{year}"

    test "Date::week should return a valid week", ->

        assertThat new Date(2012,0,1).week(), equalTo 52

        for date in [2..8]
            assertThat new Date(2012,0,date).week(), equalTo 1

        for date in [9..15]
            assertThat new Date(2012,0,date).week(), equalTo 2

    test "Date::week should return weeks that starts at sunday
          when called with an offset of -1", ->

        for date in [1..7]
            assertThat new Date(2012,0,date).week(-1), equalTo 1

        for date in [8..14]
            assertThat new Date(2012,0,date).week(-1), equalTo 2

    test "Date::equals should returns true", ->

        d1 = new Date 2012, 1, 22, 16, 45, 12, 785
        d2 = new Date 2012, 1, 22, 16, 45, 12, 785

        assertThat d1.equals d2
        assertThat d1.equals d2, true
        assertThat d1 isnt d2

    test "Date::equals should returns false", ->

        d1 = new Date 2012, 1, 22, 16, 45
        d2 = new Date 2012, 1, 22, 18, 12
        d3 = new Date 2011, 5, 13
        d4 = new Date 2012, 1, 23

        assertThat not d1.equals d2
        assertThat not d1.equals d3
        assertThat not d1.equals d4

    test "Date::dateEquals should returns true", ->

        d1 = new Date 2012, 1, 22, 16, 45
        d2 = new Date 2012, 1, 22, 18, 12
        d3 = new Date 2012, 1, 22, 5,  45

        assertThat d1.dateEquals d2
        assertThat d1.dateEquals d3
        assertThat d2.dateEquals d3

    test "Date::dateEquals should returns false", ->

        d1 = new Date 2012, 1, 22
        d2 = new Date 2011, 1, 22
        d3 = new Date 2012, 7, 22

        assertThat not d1.dateEquals d2
        assertThat not d1.dateEquals d3
        assertThat not d2.dateEquals d3

    test "Date::timeEquals should return true", ->

        d1 = new Date 2012, 1, 22, 16, 45, 53, 785
        d2 = new Date 2012, 1, 22, 16, 45, 53, 432
        d3 = new Date 2007, 5, 16, 16, 45, 53, 785

        assertThat d1.timeEquals d2
        assertThat d1.timeEquals d3
        assertThat d1.timeEquals d3, true

    test "Date::timeEquals should return false", ->

        d1 = new Date 2012, 1, 22, 16, 45, 53, 785
        d2 = new Date 2012, 1, 22, 16, 45, 53, 432
        d3 = new Date 2007, 5, 16, 13, 27, 17

        assertThat not d1.timeEquals d2, true
        assertThat not d1.timeEquals d3
