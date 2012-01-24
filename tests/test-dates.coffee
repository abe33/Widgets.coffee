module "time utils tests"

test "isValidTime should return true", ->
	assertThat isValidTime "10"
	assertThat isValidTime "10:10"
	assertThat isValidTime "10:10:15"
	assertThat isValidTime "10:10:15.765"

test "isValidTime should return false", ->
	assertThat not isValidTime ""
	assertThat not isValidTime "foo"
	assertThat not isValidTime "100:12:00"
	assertThat not isValidTime "1:0:0"
	assertThat not isValidTime "::"
	assertThat not isValidTime null

test "timeToString should return valid time string", ->

	assertThat timeToString( new Date 1970, 0, 1, 10, 16, 52 ), equalTo "10:16:52"
	assertThat timeToString( new Date 1970, 0, 1, 10, 16, 52, 756 ), equalTo "10:16:52.756"

test "timeFromString should return valid dates", ->

	assertThat timeFromString( "10" ), dateEquals new Date 1970, 0, 1, 10
	assertThat timeFromString( "10:16" ), dateEquals new Date 1970, 0, 1, 10, 16
	assertThat timeFromString( "10:16:52" ), dateEquals new Date 1970, 0, 1, 10, 16, 52
	assertThat timeFromString( "10:16:52.756" ), dateEquals new Date 1970, 0, 1, 10, 16, 52, 756

module "date utils tests"

test "isValidDate should return true", ->
	assertThat isValidDate "2011-12-15"

test "isValidDate should return false", ->
	assertThat not isValidDate ""
	assertThat not isValidDate "foo"
	assertThat not isValidDate "200-12-20"
	assertThat not isValidDate "2000-0-0"
	assertThat not isValidDate "--"
	assertThat not isValidDate null

test "dateToString should return valid date string", ->

	assertThat dateToString( new Date 1970, 0, 1 ), equalTo "1970-01-01"
	assertThat dateToString( new Date 2011, 11, 12 ), equalTo "2011-12-12"

test "dateFromString should return valid dates", ->

	assertThat dateFromString( "2011-12-12" ), dateEquals new Date 2011, 11, 12
	assertThat dateFromString( "1970-01-01" ), dateEquals new Date 1970, 0, 1

module "month utils tests"

test "isValidMonth should return true", ->
	assertThat isValidMonth "2011-12"

test "isValidMonth should return false", ->
	assertThat not isValidMonth ""
	assertThat not isValidMonth "foo"
	assertThat not isValidMonth "200-12-20"
	assertThat not isValidMonth "2000-0"
	assertThat not isValidMonth "--"
	assertThat not isValidMonth null

test "monthToString should return valid month string", ->

	assertThat monthToString( new Date 1970, 0 ), equalTo "1970-01"
	assertThat monthToString( new Date 2011, 11 ), equalTo "2011-12"

test "monthFromString should return valid dates", ->

	assertThat monthFromString( "2011-12" ), dateEquals new Date 2011, 11
	assertThat monthFromString( "1970-01" ), dateEquals new Date 1970, 0

module "week utils tests"

test "isValidWeek should return true", ->
	assertThat isValidWeek "2011-W12"
	assertThat isValidWeek "1970-W07"

test "isValidWeek should return false", ->
	assertThat not isValidWeek ""
	assertThat not isValidWeek "foo"
	assertThat not isValidWeek "200-W1"
	assertThat not isValidWeek "20-W00"
	assertThat not isValidWeek "-W"
	assertThat not isValidWeek null

test "weekToString should return valid week string", ->

	assertThat weekToString( new Date 2012, 0, 2 ), equalTo "2012-W01"
	assertThat weekToString( new Date 2011, 0, 3 ), equalTo "2011-W01"
	assertThat weekToString( new Date 2011, 7, 25 ), equalTo "2011-W34"
	assertThat weekToString( new Date 2010, 4, 11 ), equalTo "2010-W19"

test "weekFromString should return valid dates", ->

	assertThat weekFromString( "2012-W01" ), dateEquals new Date 2012, 0, 2
	assertThat weekFromString( "2011-W01" ), dateEquals new Date 2011, 0, 3
	assertThat weekFromString( "2011-W34" ), dateEquals new Date 2011, 7, 22
	assertThat weekFromString( "2010-W19" ), dateEquals new Date 2010, 4, 10

module "datetime utils tests"

test "isValidDateTime should return true", ->
	assertThat isValidDateTime "2011-16-10T10:45:32"
	assertThat isValidDateTime "2011-16-10T10:45:32.786"

test "isValidDateTime should return false", ->
	assertThat not isValidDateTime ""
	assertThat not isValidDateTime "foo"
	assertThat not isValidDateTime "2011-16-10"
	assertThat not isValidDateTime "10:15:75"
	assertThat not isValidDateTime "2011-16-10T"
	assertThat not isValidDateTime "T10:15:75"
	assertThat not isValidDateTime "-W"
	assertThat not isValidDateTime null

test "datetimeToString should return valid datetime string", ->
	assertThat datetimeToString( new Date 2012, 2, 25, 16, 44, 37 ), equalTo "2012-03-25T16:44:37"
	assertThat datetimeToString( new Date 2012, 2, 25, 16, 44, 37, 756 ), equalTo "2012-03-25T16:44:37.756"

	test "datetimeFromString should return valid dates", ->
	assertThat datetimeFromString( "2012-03-25T16:44:37" ), dateEquals new Date 2012, 2, 25, 16, 44, 37
	assertThat datetimeFromString( "2012-03-25T16:44:37.756" ), dateEquals new Date 2012, 2, 25, 16, 44, 37, 756 

module "timeinput tests"
	

