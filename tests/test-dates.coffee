module "dateutils tests"

test "time2date should return a Date with the valid time when passing '10'", ->

	d = time2date "10"

	assertThat d.getHours(), equalTo 10

test "time2date should return a Date with the valid time when passing '10:12'", ->

	d = time2date "10:12"

	assertThat d.getHours(), equalTo 10
	assertThat d.getMinutes(), equalTo 12

test "time2date should return a Date with the valid time when passing '10:12:56'", ->

	d = time2date "10:12:56"

	assertThat d.getHours(), equalTo 10
	assertThat d.getMinutes(), equalTo 12
	assertThat d.getSeconds(), equalTo 56

test "time2date should return a Date with the valid time when passing '10:12:56.145'", ->

	d = time2date "10:12:56.145"

	assertThat d.getHours(), equalTo 10
	assertThat d.getMinutes(), equalTo 12
	assertThat d.getSeconds(), equalTo 56
	assertThat d.getMilliseconds(), equalTo 145

test "week2date should return a date when passing valid weeks", ->

	assertThat week2date( "2011-W16" ), dateEquals new Date 2011, 3, 18, 1
	assertThat week2date( "2012-W24" ), dateEquals new Date 2012, 5, 11, 1
	assertThat week2date( "2016-W42" ), dateEquals new Date 2016, 9, 17, 1

test "week2date should fail with '2011-11'", ->

	errorRaised = false
	
	try
		week2date "2011-11"
	catch e
		errorRaised = true

	assertThat errorRaised

test "week2date should fail with null", ->

	errorRaised = false
	try
		week2date null 
	catch e
		errorRaised = true

	assertThat errorRaised

test "week2date should fail with '2011-W11 foo'", ->

	errorRaised = false
	try
		week2date "2011-W11 foo"
	catch e
		errorRaised = true

	assertThat errorRaised

test "week2date should fail with 'foo 2011-W11'", ->

	errorRaised = false
	try
		week2date "foo 2011-W11"
	catch e
		errorRaised = true

	assertThat errorRaised

test "week2date should fail with 'W11'", ->

	errorRaised = false
	try
		week2date "W11"
	catch e
		errorRaised = true

	assertThat errorRaised

module "dateinput tests"

test "A DateInput should allow an input of type date as target", ->

	target = $( "<input type='date'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput should allow an input of type month as target", ->

	target = $( "<input type='month'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput should allow an input of type week as target", ->

	target = $( "<input type='week'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput should allow an input of type time as target", ->

	target = $( "<input type='time'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput should allow an input of type datetime as target", ->

	target = $( "<input type='datetime'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput should allow an input of type datetime-local as target", ->

	target = $( "<input type='datetime-local'></input>" )[0]

	input = new DateInput target

	assertThat input.target is target

test "A DateInput shouldn't allow any other type of inputs as target", ->

	target = $( "<input type='text'></input>" )[0]

	errorRaised = false

	try
		input = new DateInput target
	catch e
		errorRaised = true

	assertThat errorRaised

test "A DateInput should allow to be created without target", ->

	errorRaised = false

	try
		input = new DateInput 
	catch e
		errorRaised = true

	assertThat not errorRaised

test "A DateInput should have a date property that is a date", ->

	input = new DateInput

	assertThat input.get("date") instanceof Date

test "A DateInput should accept a Date object as first argument", ->

	d = new Date

	input = new DateInput d

	assertThat input.get("date") is d

test "When taking a input as target, a DateInput should have its mode set to the input's type", ->

	target_time           = $( "<input type='time'></input>" )[0]
	target_date           = $( "<input type='date'></input>" )[0]
	target_month          = $( "<input type='month'></input>" )[0]
	target_week           = $( "<input type='week'></input>" )[0]
	target_datetime       = $( "<input type='datetime'></input>" )[0]
	target_datetime_local = $( "<input type='datetime-local'></input>" )[0]

	input_time           = new DateInput target_time
	input_date           = new DateInput target_date
	input_month          = new DateInput target_month
	input_week           = new DateInput target_week
	input_datetime       = new DateInput target_datetime
	input_datetime_local = new DateInput target_datetime_local

	assertThat input_time.get("mode"),           equalTo "time"
	assertThat input_date.get("mode"),           equalTo "date"
	assertThat input_month.get("mode"),          equalTo "month"
	assertThat input_week.get("mode"),           equalTo "week"
	assertThat input_datetime.get("mode"),       equalTo "datetime"
	assertThat input_datetime_local.get("mode"), equalTo "datetime-local"

test "When taking a Date as first argument, the DateInput should accept a second argument for the mode", ->
	d = new Date

	input                = new DateInput d
	input_time           = new DateInput d, "time"
	input_date           = new DateInput d, "date"
	input_month          = new DateInput d, "month"
	input_week           = new DateInput d, "week"
	input_datetime       = new DateInput d, "datetime"
	input_datetime_local = new DateInput d, "datetime-local"

	assertThat input.get("mode"),                equalTo "datetime"
	assertThat input_time.get("mode"),           equalTo "time"
	assertThat input_date.get("mode"),           equalTo "date"
	assertThat input_month.get("mode"),          equalTo "month"
	assertThat input_week.get("mode"),           equalTo "week"
	assertThat input_datetime.get("mode"),       equalTo "datetime"
	assertThat input_datetime_local.get("mode"), equalTo "datetime-local"

test "When an invalid mode is passed to the constructor, the DateInput should keep the default", ->

	d = new Date

	input = new DateInput d, "invalid"

	assertThat input.get("mode"), equalTo "datetime"

test "DateInput should convert the value to a Date according to its mode", ->
	target_time           = $( "<input type='time' value='10:45:25'></input>" )[0]
	target_date           = $( "<input type='date' value='2011-11-11'></input>" )[0]
	target_month          = $( "<input type='month' value='2012-12'></input>" )[0]
	target_week           = $( "<input type='week' value='2011-W16'></input>" )[0]
	target_datetime       = $( "<input type='datetime' value='2001-09-11T10:22:45.12Z'></input>" )[0]
	target_datetime_local = $( "<input type='datetime-local' value='2003-07-14T16:46:35.25'></input>" )[0]

	input_time           = new DateInput target_time
	input_date           = new DateInput target_date
	input_month          = new DateInput target_month
	input_week           = new DateInput target_week
	input_datetime       = new DateInput target_datetime
	input_datetime_local = new DateInput target_datetime_local

	assertThat input_time.get("date"),           dateEquals time2date "10:45:25"
	assertThat input_date.get("date"),           dateEquals new Date 2011, 10, 11
	assertThat input_month.get("date"),          dateEquals new Date 2012, 11
	assertThat input_week.get("date"),           dateEquals new Date 2011 ,3, 18, 1
	assertThat input_datetime.get("date"),       dateEquals new Date 2001, 8, 11, 10, 22, 45, 12
	assertThat input_datetime_local.get("date"), dateEquals new Date 2003, 6, 14, 16, 46, 35, 25

test "Invalid value in the target should make the DateInput to fallback on a default date", ->

	target_time           = $( "<input type='time' value='foo'></input>" )[0]
	target_date           = $( "<input type='date' value='foo'></input>" )[0]
	target_month          = $( "<input type='month' value='foo'></input>" )[0]
	target_week           = $( "<input type='week' value='foo'></input>" )[0]
	target_datetime       = $( "<input type='datetime' value='foo'></input>" )[0]
	target_datetime_local = $( "<input type='datetime-local' value='foo'></input>" )[0]

	input_time           = new DateInput target_time
	input_date           = new DateInput target_date
	input_month          = new DateInput target_month
	input_week           = new DateInput target_week
	input_datetime       = new DateInput target_datetime
	input_datetime_local = new DateInput target_datetime_local

	d = new Date 0

	assertThat input_time.get("date"),           dateEquals d
	assertThat input_date.get("date"),           dateEquals d
	assertThat input_month.get("date"),          dateEquals d
	assertThat input_week.get("date"),           dateEquals d
	assertThat input_datetime.get("date"),       dateEquals d
	assertThat input_datetime_local.get("date"), dateEquals d

test "DateInput should allow to change the mode using the mode setter", ->

	d = new Date
	input = new DateInput d

	input.set "mode", "time"

	assertThat input.get("mode"), equalTo "time"
	assertThat input.get("value"), equalTo date2time d

test "DateInput shouldn't allow invalid modes in the mode setter", ->

	input = new DateInput

	input.set "mode", "foo"

	assertThat input.get("mode"), equalTo "datetime"

module "dateinput time mode tests"

test "In time mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='time' value='10:10' min='10:00' max='10:20'></input>" )[0]

	input = new DateInput target

	assertThat input.get('min'), dateEquals time2date "10:00"
	assertThat input.get('max'), dateEquals time2date "10:20"

test "In time mode, changing the date should update the value accordingly", ->

	target = $( "<input type='time' value='10:10'></input>" )[0]

	input = new DateInput target

	input.set "date", time2date "11:10"

	assertThat input.get("value"), equalTo "11:10:00"
	assertThat input.get("date"), dateEquals time2date "11:10" 

	input.set "date", time2date "06:45:16"
	assertThat input.get("value"), equalTo "06:45:16"

	input.set "date", time2date "05"
	assertThat input.get("value"), equalTo "05:00:00"

	input.set "date", time2date "04:12:45.467"
	assertThat input.get("value"), equalTo "04:12:45.467"

test "In time mode, changing the value should update the date", ->

	target = $( "<input type='time' value='10:10'></input>" )[0]

	input = new DateInput target

	input.set "value", "11:53"

	assertThat input.get("date"), dateEquals time2date "11:53" 
	assertThat input.get("value"), equalTo "11:53"

	input.set "value", "05:35:12"
	assertThat input.get("date"), dateEquals time2date "05:35:12"
	
	input.set "value", "04:22:45.542"
	assertThat input.get("date"), dateEquals time2date "04:22:45.542"

test "In time mode, DateInput should prevent invalid time to be passed to value", ->

	target = $( "<input type='time' value='10:10'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "2001-11"
	input.set "value", "foo"
	input.set "value", null

	assertThat input.get("value"), equalTo "10:10"

test "In time mode, DateInput should prevent invalid date to be passed to date", ->

	target = $( "<input type='time' value='10:10'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "10:10"

module "dateinput date mode tests"

test "In date mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='date' value='2011-10-01' min='2011-01-01' max='2011-12-31'></input>" )[0]

	input = new DateInput target

	assertThat input.get('min'), dateEquals new Date 2011, 0, 1
	assertThat input.get('max'), dateEquals new Date 2011, 11, 31 

test "In date mode, changing the date should update the value accordingly", ->

	target = $( "<input type='date' value='2011-10-01'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date 2012, 11, 05

	assertThat input.get("value"), equalTo "2012-12-05"
	assertThat input.get("date"), dateEquals new Date 2012, 11, 05

	input.set "date", new Date 2016, 5, 12
	assertThat input.get("value"), equalTo "2016-06-12"

test "In date mode, changing the value should update the date", ->

	target = $( "<input type='date' value='2011-10-01'></input>" )[0]

	input = new DateInput target

	input.set "value", "2012-12-05"

	assertThat input.get("date"), dateEquals new Date 2012, 11, 05
	assertThat input.get("value"), equalTo "2012-12-05"

	input.set "value", "2016-06-12"
	assertThat input.get("date"), dateEquals new Date 2016, 5, 12

test "In date mode, DateInput should prevent invalid date to be passed to value", ->

	target = $( "<input type='date' value='2011-10-01'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "10:11"
	input.set "value", "foo"
	input.set "value", null

	assertThat input.get("value"), equalTo "2011-10-01"

test "In date mode, DateInput should prevent invalid date to be passed to date", ->

	target = $( "<input type='date' value='2011-10-01'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "2011-10-01"

module "dateinput month mode tests"

test "In month mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='month' value='2011-10' min='2011-01' max='2011-12'></input>" )[0]

	input = new DateInput target

	assertThat input.get('min'), dateEquals new Date 2011, 0
	assertThat input.get('max'), dateEquals new Date 2011, 11 

test "In month mode, changing the date should update the value accordingly", ->

	target = $( "<input type='month' value='2011-10'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date 2012, 11

	assertThat input.get("value"), equalTo "2012-12"
	assertThat input.get("date"), dateEquals new Date 2012, 11

	input.set "date", new Date 2016, 5
	assertThat input.get("value"), equalTo "2016-06"

test "In month mode, changing the value should update the date", ->

	target = $( "<input type='month' value='2011-10-01'></input>" )[0]

	input = new DateInput target

	input.set "value", "2012-12"

	assertThat input.get("date"), dateEquals new Date 2012, 11
	assertThat input.get("value"), equalTo "2012-12"

	input.set "value", "2016-06"
	assertThat input.get("date"), dateEquals new Date 2016, 5

test "In month mode, DateInput should prevent invalid month to be passed to value", ->

	target = $( "<input type='month' value='2011-10'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "10:11"
	input.set "value", "foo"
	input.set "value", null

	assertThat input.get("value"), equalTo "2011-10"

test "In month mode, DateInput should prevent invalid month to be passed to date", ->

	target = $( "<input type='month' value='2011-10'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "2011-10"

module "dateinput week mode tests"

test "In week mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='week' value='2011-W12' min='2011-W1' max='2011-W52'></input>" )[0]

	input = new DateInput target

	assertThat input.get('min'), dateEquals week2date "2011-W1"
	assertThat input.get('max'), dateEquals week2date "2011-W52"

test "In week mode, changing the date should update the value accordingly", ->

	target = $( "<input type='week' value='2011-W10'></input>" )[0]

	input = new DateInput target

	input.set "date", week2date "2012-W1"

	assertThat input.get("value"), equalTo "2012-W1"
	assertThat input.get("date"), dateEquals week2date "2012-W1"

	input.set "date", week2date "2016-W6"
	assertThat input.get("value"), equalTo "2016-W6"


test "In week mode, changing the value should update the date", ->

	target = $( "<input type='week' value='2011-W10'></input>" )[0]

	input = new DateInput target

	input.set "value", "2012-W1"

	assertThat input.get("value"), equalTo "2012-W1"
	assertThat input.get("date"), dateEquals week2date "2012-W1"

	input.set "value", "2016-W6"
	assertThat input.get("date"), dateEquals week2date "2016-W6"

test "In week mode, DateInput should prevent invalid week to be passed to value", ->

	target = $( "<input type='week' value='2011-W10'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "foo-W12"
	input.set "value", "1000-W"
	input.set "value", "foo2001-W10"
	input.set "value", "2001-W10foo"
	input.set "value", "01-W10"
	input.set "value", null

	assertThat input.get("value"), equalTo "2011-W10"

test "In week mode, DateInput should prevent invalid week to be passed to date", ->

	target = $( "<input type='week' value='2011-W10'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "2011-W10"

module "dateinput datetime mode tests"

test "In datetime mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='datetime' value='2011-10-01T09:45:16' min='2011-01-01T08:16:25' max='2011-12-31T16:54:37'></input>" )[0]
	input = new DateInput target

	assertThat input.get('min'), dateEquals new Date 2011, 0, 1, 8, 16, 25
	assertThat input.get('max'), dateEquals new Date 2011, 11, 31, 16, 54, 37

test "In datetime mode, changing the date should update the value accordingly", ->

	target = $( "<input type='datetime' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date 2012, 11, 05, 18, 16, 14

	assertThat input.get("value"), equalTo "2012-12-05T18:16:14"
	assertThat input.get("date"), dateEquals new Date 2012, 11, 05, 18, 16, 14

	input.set "date", new Date 2016, 5, 12, 22, 17, 45
	assertThat input.get("value"), equalTo "2016-06-12T22:17:45"

test "In datetime mode, changing the value should update the date", ->

	target = $( "<input type='datetime' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "value", "2012-12-05T16:45:35"

	assertThat input.get("date"), dateEquals new Date 2012, 11, 05, 16, 45, 35
	assertThat input.get("value"), equalTo "2012-12-05T16:45:35"

	input.set "value", "2016-06-12T18:25:16"
	assertThat input.get("date"), dateEquals new Date 2016, 5, 12, 18, 25, 16

test "In datetime mode, DateInput should prevent invalid datetime to be passed to value", ->

	target = $( "<input type='datetime' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "10:11"
	input.set "value", "2011-10-01"
	input.set "value", "foo"
	input.set "value", null

	assertThat input.get("value"), equalTo "2011-10-01T08:37:21"

test "In datetime mode, DateInput should prevent invalid datetime to be passed to date", ->

	target = $( "<input type='datetime' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "2011-10-01T08:37:21"

module "dateinput datetime-local mode tests"

test "In datetime-local mode, the DateInput should accept the min and max attributes", ->

	target = $( "<input type='datetime-local' value='2011-10-01T09:45:16' min='2011-01-01T08:16:25' max='2011-12-31T16:54:37'></input>" )[0]
	input = new DateInput target

	assertThat input.get('min'), dateEquals new Date 2011, 0, 1, 8, 16, 25
	assertThat input.get('max'), dateEquals new Date 2011, 11, 31, 16, 54, 37

test "In datetime-local mode, changing the date should update the value accordingly", ->

	target = $( "<input type='datetime-local' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date 2012, 11, 05, 18, 16, 14

	assertThat input.get("value"), equalTo "2012-12-05T18:16:14"
	assertThat input.get("date"), dateEquals new Date 2012, 11, 05, 18, 16, 14

	input.set "date", new Date 2016, 5, 12, 22, 17, 45
	assertThat input.get("value"), equalTo "2016-06-12T22:17:45"

test "In datetime-local mode, changing the value should update the date", ->

	target = $( "<input type='datetime-local' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "value", "2012-12-05T16:45:35"

	assertThat input.get("date"), dateEquals new Date 2012, 11, 05, 16, 45, 35
	assertThat input.get("value"), equalTo "2012-12-05T16:45:35"

	input.set "value", "2016-06-12T18:25:16"
	assertThat input.get("date"), dateEquals new Date 2016, 5, 12, 18, 25, 16

test "In datetime-local mode, DateInput should prevent invalid datetime to be passed to value", ->

	target = $( "<input type='datetime-local' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target
	
	input.set "value", "10:11"
	input.set "value", "2011-10-01"
	input.set "value", "foo"
	input.set "value", null

	assertThat input.get("value"), equalTo "2011-10-01T08:37:21"

test "In datetime-local mode, DateInput should prevent invalid datetime to be passed to date", ->

	target = $( "<input type='datetime-local' value='2011-10-01T08:37:21'></input>" )[0]

	input = new DateInput target

	input.set "date", new Date "Foo"
	input.set "date", null

	assertThat input.get("value"), equalTo "2011-10-01T08:37:21"

module "dateinput dummy tests"

test "DateInput should have a dummy", ->

	input = new DateInput

	assertThat input.dummy, notNullValue()

