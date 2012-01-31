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

test "time chaining conversion should always result to the same value", ->

	assertThat timeFromString( timeToString( timeFromString( "10:16:52" ) ) ), dateEquals timeFromString( "10:16:52" )

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

test "date chaining conversion should always result to the same value", ->

	assertThat dateFromString( dateToString( dateFromString( "2011-12-12" ) ) ), dateEquals dateFromString( "2011-12-12" )

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

test "month chaining conversion should always result to the same value", ->

	assertThat monthFromString( monthToString( monthFromString( "2011-12" ) ) ), dateEquals monthFromString( "2011-12" )

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

test "week chaining conversion should always result to the same value", ->

	assertThat weekFromString( weekToString( weekFromString( "2011-W12" ) ) ), dateEquals weekFromString( "2011-W12" )

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
	assertThat datetimeToString( new Date 2011, 0, 1, 0, 0, 0 ), equalTo "2011-01-01T00:00:00"
	assertThat datetimeToString( new Date 2012, 2, 25, 16, 44, 37 ), equalTo "2012-03-25T16:44:37"
	assertThat datetimeToString( new Date 2012, 2, 25, 16, 44, 37, 756 ), equalTo "2012-03-25T16:44:37.756"

test "datetimeFromString should return valid dates", ->
	assertThat datetimeFromString( "2011-01-01T00:00:00" ), dateEquals new Date 2011, 0, 1, 0, 0, 0
	assertThat datetimeFromString( "2012-03-25T16:44:37" ), dateEquals new Date 2012, 2, 25, 16, 44, 37
	assertThat datetimeFromString( "2012-03-25T16:44:37.756" ), dateEquals new Date 2012, 2, 25, 16, 44, 37, 756 

test "datetime chaining conversion should always result to the same value", ->

	assertThat datetimeFromString( datetimeToString( datetimeFromString( "2012-03-25T16:44:37" ) ) ), dateEquals datetimeFromString( "2012-03-25T16:44:37" )


testGenericDateWidgetBehaviors=( opt )->

	test "A #{ opt.classname } should allow an input with type #{ opt.type } as target", ->

		target = $("<input type='#{ opt.type }'></input>")[0]
		input = new opt.cls target

		assertThat input.target is target
		
	test "A #{ opt.classname } shouldn't allow an input with a type different than #{ opt.type } as target", ->

		target = $("<input type='text'></input>")[0]
		errorRaised = false

		try
			input = new opt.cls target
		catch e
			errorRaised = true

		assertThat errorRaised

	test "A #{ opt.classname } should allow a date object as first argument", ->

		d = opt.defaultDate
		input = new opt.cls d
		
		assertThat input.get( "date" ), dateEquals d


	test "When passing a Date as first argument, the value should match the date", ->
		d = opt.defaultDate
		input = new opt.cls d

		assertThat input.get( "value" ), equalTo opt.defaultValue

	test "Creating a #{ opt.classname } without argument should setup a default Date", ->
		d = new Date
		input = new opt.cls

		assertThat input.get("date").valueOf(), closeTo d.valueOf(), 1000 

	test "A #{ opt.classname } should set its date with the value of the target", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target
		
		assertThat input.get( "date" ), dateEquals opt.defaultDate

	test "Changing the date of a #{ opt.classname } should change the value", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		d = opt.setDate
		input.set "date", d

		assertThat input.get( "value" ), equalTo opt.setValue

	test "Changing the value of a #{ opt.classname } should change the date", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		d = opt.setDate
		input.set "value", opt.setValue

		assertThat input.get( "date" ), dateEquals d 

	test "#{ opt.classname } should prevent invalid values to affect it", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		for invalidValue in opt.invalidValues
			input.set "value", invalidValue

		assertThat input.get("value"), equalTo opt.defaultValue

	test "#{ opt.classname } should prevent invalid dates to affect it", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		for invalidDate in opt.invalidDates
			input.set "date", invalidDate

		assertThat input.get("value"), equalTo opt.defaultValue

	test "#{ opt.classname } should support the min, max and step attributes of the target", ->
		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }' min='#{ opt.minValue }' max='#{ opt.maxValue }' step='#{ opt.stepValue }'></input>")[0]
		input = new opt.cls target

		assertThat input.get( "min" ), dateEquals opt.minDate
		assertThat input.get( "max" ), dateEquals opt.maxDate
		assertThat input.get( "step" ), strictlyEqualTo opt.stepValue

	test "#{ opt.classname } should prevent invalid values to be set in the target", ->

		target = $("<input type='#{ opt.type }' value='foo' min='foo' max='foo' step='foo'></input>")[0]
		input = new opt.cls target

		assertThat input.get( "date" ), dateEquals new Date
		assertThat input.get( "min" ), nullValue()
		assertThat input.get( "max" ), nullValue()
		assertThat input.get( "step" ), strictlyEqualTo 0
	
	test "#{ opt.classname } should adjust values below the min attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }' min='#{ opt.minValue }' max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "value", opt.invalidMinValue

		assertThat input.get("value"), equalTo opt.minValue
		assertThat input.get("date"), dateEquals opt.minDate
	
	test "#{ opt.classname } should adjust dates below the min attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }' min='#{ opt.minValue }' max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "date", opt.invalidMinDate

		assertThat input.get("value"), equalTo opt.minValue
		assertThat input.get("date"), dateEquals opt.minDate
	
	test "#{ opt.classname } should adjust values above the max attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }' min='#{ opt.minValue }' max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "value", opt.invalidMaxValue

		assertThat input.get("value"), equalTo opt.maxValue
		assertThat input.get("date"), dateEquals opt.maxDate
	
	test "#{ opt.classname } should adjust dates above the max attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }' min='#{ opt.minValue }' max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "date", opt.invalidMaxDate

		assertThat input.get("value"), equalTo opt.maxValue
		assertThat input.get("date"), dateEquals opt.maxDate
	
	test "Changing the value should change the target value as well", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")
		input = new opt.cls target[0]

		input.set "value", opt.setValue

		assertThat target.attr("value"), equalTo opt.setValue
	
	test "Changing the date should change the target value as well", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")
		input = new opt.cls target[0]

		input.set "date", opt.setDate

		assertThat target.attr("value"), equalTo opt.setValue


module "timeinput tests"
testGenericDateWidgetBehaviors 
	classname:"TimeInput"
	cls:TimeInput
	type:"time"

	defaultDate:new Date 1970, 0, 1, 11, 56, 42
	defaultValue:"11:56:42"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "100:00:00", "1:22:2" ]

	setDate:new Date 1970, 0, 1, 16, 32, 17
	setValue:"16:32:17"

	minDate:new Date 1970, 0, 1, 10, 0, 0
	minValue:"10:00:00"

	invalidMinDate:new Date 1970, 0, 1, 5, 0, 0
	invalidMinValue:"05:00:00"

	maxDate:new Date 1970, 0, 1, 23, 0, 0
	maxValue:"23:00:00"
	
	invalidMaxDate:new Date 1970, 0, 1, 23, 35, 47
	invalidMaxValue:"23:35:47"

	stepValue:1800

	
module "dateinput tests"

testGenericDateWidgetBehaviors 
	classname:"DateInput"
	cls:DateInput
	type:"date"

	defaultDate:new Date 1981, 8, 9, 0
	defaultValue:"1981-09-09"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "122-50-4", "1-1-+6" ]

	setDate:new Date 2012, 4, 27, 0
	setValue:"2012-05-27"

	minDate:new Date 1970, 0, 1, 0
	minValue:"1970-01-01"

	invalidMinDate:new Date 1960, 0, 1, 0
	invalidMinValue:"1960-01-01"

	maxDate:new Date 2012, 11, 29, 0
	maxValue:"2012-12-29"

	invalidMaxDate:new Date 2100, 4, 21
	invalidMaxValue:"2100-05-21"

	stepValue:1800

module "monthinput tests"

testGenericDateWidgetBehaviors 
	classname:"MonthInput"
	cls:MonthInput
	type:"month"

	defaultDate:new Date 1981, 8, 1, 0
	defaultValue:"1981-09"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

	setDate:new Date 2012, 4, 1, 0
	setValue:"2012-05"

	minDate:new Date 1970, 0, 1, 0
	minValue:"1970-01"

	invalidMinDate:new Date 1960, 0, 1, 0
	invalidMinValue:"1960-01"

	maxDate:new Date 2012, 11, 1, 0
	maxValue:"2012-12"

	invalidMaxDate:new Date 2100, 1, 1, 0
	invalidMaxValue:"2100-05"

	stepValue:1800

module "weekinput tests"

testGenericDateWidgetBehaviors 
	classname:"WeekInput"
	cls:WeekInput
	type:"week"

	defaultDate:new Date 2012, 0, 2, 0
	defaultValue:"2012-W01"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

	setDate:new Date 2011, 7, 15, 0
	setValue:"2011-W33"

	minDate:new Date 2011, 0, 24, 0
	minValue:"2011-W04"

	invalidMinDate:new Date 2011, 0, 3, 0
	invalidMinValue:"2011-W01"

	maxDate:new Date 2013, 0, 21, 0
	maxValue:"2013-W04"

	invalidMaxDate:new Date 2100, 1, 1, 0
	invalidMaxValue:"2100-W05"

	stepValue:1800

module "datetimeinput tests"

testGenericDateWidgetBehaviors 
	classname:"DateTimeInput"
	cls:DateTimeInput
	type:"datetime"

	defaultDate:new Date 2011, 5, 21, 16, 27, 53
	defaultValue:"2011-06-21T16:27:53"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

	setDate:new Date 2011, 7, 15, 8, 35, 12
	setValue:"2011-08-15T08:35:12"

	minDate:new Date 2011, 0, 1, 0, 0, 0
	minValue:"2011-01-01T00:00:00"

	invalidMinDate:new Date 2010, 11, 31, 23, 59, 59
	invalidMinValue:"2010-12-31T23:59:59"

	maxDate:new Date 2011, 11, 31, 23, 59, 59
	maxValue:"2011-12-31T23:59:59"

	invalidMaxDate:new Date 2012, 0, 1, 0
	invalidMaxValue:"2012-01-01T00:00:00"

	stepValue:1800
