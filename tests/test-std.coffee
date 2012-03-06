testGenericDateTimeFunctions=( opt )->

    test "#{ opt.validateFunctionName } should return true", ->
        assertThat opt.validateFunction data for data in opt.validData

    test "#{ opt.validateFunctionName } should return false", ->
        assertThat not opt.validateFunction data for data in opt.invalidData

    test "#{ opt.toStringFunctionName } should
         return valid #{ opt.type } string", ->
        for [ date, string ] in opt.toStringData
            assertThat( opt.toStringFunction( date ), equalTo string )

    test "#{ opt.fromStringFunctionName } should return valid dates", ->
        for [ string, date ] in opt.fromStringData
            assertThat( opt.fromStringFunction( string ), dateEquals date )

    test "#{ opt.type } chaining conversion should always
          result to the same value", ->
        assertThat opt.fromStringFunction(
            opt.toStringFunction(
                opt.fromStringFunction( opt.reverseData ) ) ),
            dateEquals opt.fromStringFunction( opt.reverseData )

        for data in opt.validData
            assertThat opt.fromStringFunction(
                opt.toStringFunction(
                    opt.fromStringFunction( data ) ) ),
                dateEquals opt.fromStringFunction( data )

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

    module "time utils tests"

    testGenericDateTimeFunctions
        type:"time"
        validateFunctionName:"isValidTime"
        validateFunction:Date.isValidTime
        validData:[ "10", "10:10", "10:10:15", "10:10:15.765" ]
        invalidData:[ "", "foo", "100:01:2", "2011-16-10T",
                      "T10:15:75", "::", null ]

        toStringFunctionName:"timeToString"
        toStringFunction:Date.timeToString
        toStringData:[ [ new Date( 1970, 0, 1, 10, 16, 52 ),
                         "10:16:52"  ],
                       [ new Date( 1970, 0, 1, 0, 0, 0 ),
                         "00:00:00" ],
                       [ new Date( 1970, 0, 1, 10, 16, 52, 756 ),
                         "10:16:52.756" ] ]

        fromStringFunctionName:"timeFromString"
        fromStringFunction:Date.timeFromString
        fromStringData:[ [ "10",
                            new Date 1970, 0, 1, 10             ],
                         [ "10:16",
                            new Date 1970, 0, 1, 10, 16         ],
                         [ "00:00:00",
                            new Date 1970, 0, 1, 0, 0, 0        ],
                         [ "10:16:52",
                            new Date 1970, 0, 1, 10, 16, 52     ],
                         [ "10:16:52.756",
                            new Date 1970, 0, 1, 10, 16, 52, 756 ] ]

        reverseData:"10:16:52"

    module "date utils tests"

    testGenericDateTimeFunctions
        type:"date"
        validateFunctionName:"isValidDate"
        validateFunction:Date.isValidDate
        validData:[ "2011-12-15" ]
        invalidData:[ "", "foo", "200-12-20", "2000-0-0", "--", null ]

        toStringFunctionName:"dateToString"
        toStringFunction:Date.dateToString
        toStringData:[ [ new Date( 1970, 0, 1 ),   "1970-01-01" ],
                       [ new Date( 2011, 11, 12 ), "2011-12-12" ] ]

        fromStringFunctionName:"dateFromString"
        fromStringFunction:Date.dateFromString
        fromStringData:[ [ "2011-12-12", new Date( 2011, 11, 12 ) ],
                         [ "1970-01-01", new Date( 1970, 0, 1 )   ] ]

        reverseData:"2011-12-12"

    module "month utils tests"

    testGenericDateTimeFunctions
        type:"month"
        validateFunctionName:"isValidMonth"
        validateFunction:Date.isValidMonth
        validData:[ "2011-12" ]
        invalidData:[ "", "foo", "200-12-20", "2000-0", "--", null ]

        toStringFunctionName:"monthToString"
        toStringFunction:Date.monthToString
        toStringData:[ [ ( new Date 1970, 0 ),  "1970-01" ],
                       [ ( new Date 2011, 11 ), "2011-12" ] ]

        fromStringFunctionName:"monthFromString"
        fromStringFunction:Date.monthFromString
        fromStringData:[ [ "2011-12", new Date( 2011, 11 ) ],
                         [ "1970-01", new Date( 1970, 0  ) ] ]

        reverseData:"2011-12"

    module "week utils tests"

    testGenericDateTimeFunctions
        type:"week"
        validateFunctionName:"isValidWeek"
        validateFunction:Date.isValidWeek
        validData:[ "2011-W12", "1970-W07", "2007-W03", "2015-W25" ]
        invalidData:[ "", "foo", "200-W1", "20-W00", "-W", null ]

        toStringFunctionName:"weekToString"
        toStringFunction:Date.weekToString
        toStringData:[ [ ( new Date 2012, 0, 2 ),  "2012-W01" ],
                       [ ( new Date 2011, 0, 3 ),  "2011-W01" ],
                       [ ( new Date 2011, 7, 25 ), "2011-W34" ],
                       [ ( new Date 2010, 4, 11 ), "2010-W19" ] ]

        fromStringFunctionName:"weekFromString"
        fromStringFunction:Date.weekFromString
        fromStringData:[ [ "2012-W01", new Date 2012, 0, 2  ],
                         [ "2011-W02", new Date 2011, 0, 10  ],
                         [ "2011-W34", new Date 2011, 7, 22 ],
                         [ "2010-W19", new Date 2010, 4, 10  ] ]

        reverseData:"2011-W12"

    module "datetime utils tests"

    testGenericDateTimeFunctions
        type:"datetime"
        validateFunctionName:"isValidDateTime"
        validateFunction:Date.isValidDateTime
        validData:[ "2011-10-10T10:45:32+01:00",
                    "2011-10-10T10:45:32-02:00",
                    "2011-10-10T10:45:32.786Z" ]
        invalidData:[ "", "foo", "2011-10-10", "10:15:75",
                      "2011-16-10T", "T10:15:75", "-W", null ]

        toStringFunctionName:"datetimeToString"
        toStringFunction:Date.datetimeToString
        toStringData:[ [ new Date( 2011, 0, 1, 0, 0, 0 ),
                        "2011-01-01T00:00:00+01:00"     ],
                       [ new Date( 2012, 2, 25, 16, 44, 37 ),
                        "2012-03-25T16:44:37+02:00"     ],
                       [ new Date( 2012, 2, 25, 16, 44, 37, 756 ),
                        "2012-03-25T16:44:37.756+02:00" ] ]

        fromStringFunctionName:"datetimeFromString"
        fromStringFunction:Date.datetimeFromString
        fromStringData:[ [ "2011-01-01T00:00:00+01:00",
                            new Date( 2011, 0, 1, 0, 0, 0 )           ],
                         [ "2012-03-25T16:44:37+02:00",
                            new Date( 2012, 2, 25, 16, 44, 37 )       ],
                         [ "2012-03-25T16:44:37.756+02:00",
                            new Date( 2012, 2, 25, 16, 44, 37, 756 )  ] ]

        reverseData:"2012-03-25T16:44:37+02:00"

    module "datetimelocal utils tests"

    testGenericDateTimeFunctions
        type:"datetimeLocal"
        validateFunctionName:"isValidDateTimeLocal"
        validateFunction:Date.isValidDateTimeLocal
        validData:[ "2011-10-10T10:45:32", "2011-10-10T10:45:32.786" ]
        invalidData:[ "", "foo", "2011-10-10", "10:15:75",
                      "2011-16-10T", "T10:15:75", "-W", null ]

        toStringFunctionName:"datetimeLocalToString"
        toStringFunction:Date.datetimeLocalToString
        toStringData:[ [ new Date( 2011, 0, 1, 0, 0, 0 ),
                         "2011-01-01T00:00:00"     ],
                       [ new Date( 2012, 2, 25, 16, 44, 37 ),
                         "2012-03-25T16:44:37"     ],
                       [ new Date( 2012, 2, 25, 16, 44, 37, 756 ),
                         "2012-03-25T16:44:37.756" ] ]

        fromStringFunctionName:"datetimeLocalFromString"
        fromStringFunction:Date.datetimeLocalFromString
        fromStringData:[ [ "2011-01-01T00:00:00",
                            new Date( 2011, 0, 1, 0, 0, 0 )           ],
                         [ "2012-03-25T16:44:37",
                            new Date( 2012, 2, 25, 16, 44, 37 )       ],
                         [ "2012-03-25T16:44:37.756",
                            new Date( 2012, 2, 25, 16, 44, 37, 756 ) ] ]

        reverseData:"2012-03-25T16:44:37"
