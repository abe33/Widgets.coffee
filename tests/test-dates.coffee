# The basic tests for all the utils and widgets are done through the generic function below.

testGenericDateTimeFunctions=( opt )->

	test "#{ opt.validateFunctionName } should return true", ->
		assertThat opt.validateFunction data for data in opt.validData

	test "#{ opt.validateFunctionName } should return false", ->
		assertThat not opt.validateFunction data for data in opt.invalidData

	test "#{ opt.toStringFunctionName } should return valid #{ opt.type } string", ->
		assertThat( opt.toStringFunction( date ), equalTo string ) for [ date, string ] in opt.toStringData
		
	test "#{ opt.fromStringFunctionName } should return valid dates", ->
		assertThat( opt.fromStringFunction( string ), dateEquals date ) for [ string, date ] in opt.fromStringData
		
	test "#{ opt.type } chaining conversion should always result to the same value", ->
		assertThat opt.fromStringFunction( opt.toStringFunction( opt.fromStringFunction( opt.reverseData ) ) ), 
				   dateEquals opt.fromStringFunction( opt.reverseData)

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
		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.defaultValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }' 
						   step='#{ opt.stepValue }'></input>")[0]
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
		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.defaultValue }' 
						   min='#{ opt.minValue }'
						   max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "value", opt.invalidMinValue

		assertThat input.get("value"), equalTo opt.minValue
		assertThat input.get("date"), dateEquals opt.minDate
	
	test "#{ opt.classname } should adjust dates below the min attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.defaultValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "date", opt.invalidMinDate

		assertThat input.get("value"), equalTo opt.minValue
		assertThat input.get("date"), dateEquals opt.minDate
	
	test "#{ opt.classname } should adjust values above the max attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.defaultValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "value", opt.invalidMaxValue

		assertThat input.get("value"), equalTo opt.maxValue
		assertThat input.get("date"), dateEquals opt.maxDate
	
	test "#{ opt.classname } should adjust dates above the max attribute to fit in the range", ->
		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.defaultValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }'></input>")[0]
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
	
	test "Changing the min property should snap the current value if it drop below", ->

		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.minValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "min", opt.setDate

		assertThat input.get("value"), equalTo opt.setValue
	
	test "Changing the max property should snap the current value if it climb above", ->

		target = $("<input type='#{ opt.type }' 
						   value='#{ opt.maxValue }' 
						   min='#{ opt.minValue }' 
						   max='#{ opt.maxValue }'></input>")[0]
		input = new opt.cls target

		input.set "max", opt.setDate

		assertThat input.get("value"), equalTo opt.setValue
	
	test "A #{ opt.classname } should provide a dummy", ->
	
		assertThat ( new opt.cls ).dummy, notNullValue() 
	
	test "A #{ opt.classname } dummy should have the type of the input as class", ->

		assertThat ( new opt.cls new Date, "#{ opt.type }" ).dummy.hasClass "#{ opt.type }"
	
	input1 = new opt.cls new Date, opt.type 
	input2 = new opt.cls new Date, opt.type
	input3 = new opt.cls new Date, opt.type

	input2.set "readonly", true
	input3.set "disabled", true

	$("#qunit-header").before $ "<h4>#{ opt.classname }</h4>"
	$("#qunit-header").before input1.dummy
	$("#qunit-header").before input2.dummy
	$("#qunit-header").before input3.dummy
			
#### Here starts the concret tests

module "time utils tests"

testGenericDateTimeFunctions
	type:"time"
	validateFunctionName:"isValidTime"
	validateFunction:isValidTime
	validData:[ "10", "10:10", "10:10:15", "10:10:15.765" ]
	invalidData:[ "", "foo", "100:01:2", "2011-16-10T", "T10:15:75", "::", null ]

	toStringFunctionName:"timeToString"
	toStringFunction:timeToString
	toStringData:[ [ new Date( 1970, 0, 1, 10, 16, 52 ),	  "10:16:52"	 ],
				   [ new Date( 1970, 0, 1, 10, 16, 52, 756 ), "10:16:52.756" ] ]
	
	fromStringFunctionName:"timeFromString"
	fromStringFunction:timeFromString
	fromStringData:[ [ "10"		     , new Date 1970, 0, 1, 10			    ],
				     [ "10:16"		 , new Date 1970, 0, 1, 10, 16 			],
				     [ "10:16:52"	 , new Date 1970, 0, 1, 10, 16, 52 		],
				     [ "10:16:52.756", new Date 1970, 0, 1, 10, 16, 52, 756 ] ]
	
	reverseData:"10:16:52"

module "date utils tests"

testGenericDateTimeFunctions
	type:"date"
	validateFunctionName:"isValidDate"
	validateFunction:isValidDate
	validData:[ "2011-12-15" ]
	invalidData:[ "", "foo", "200-12-20", "2000-0-0", "--", null ]

	toStringFunctionName:"dateToString"
	toStringFunction:dateToString
	toStringData:[ [ new Date( 1970, 0, 1 ),   "1970-01-01" ],
				   [ new Date( 2011, 11, 12 ), "2011-12-12" ] ]
	
	fromStringFunctionName:"dateFromString"
	fromStringFunction:dateFromString
	fromStringData:[ [ "2011-12-12", new Date( 2011, 11, 12 ) ],
				     [ "1970-01-01", new Date( 1970, 0, 1 )   ] ]
	
	reverseData:"2011-12-12"

module "month utils tests"

testGenericDateTimeFunctions
	type:"month"
	validateFunctionName:"isValidMonth"
	validateFunction:isValidMonth
	validData:[ "2011-12" ]
	invalidData:[ "", "foo", "200-12-20", "2000-0", "--", null ]

	toStringFunctionName:"monthToString"
	toStringFunction:monthToString
	toStringData:[ [ ( new Date 1970, 0 ),  "1970-01" ],
				   [ ( new Date 2011, 11 ), "2011-12" ] ]
	
	fromStringFunctionName:"monthFromString"
	fromStringFunction:monthFromString
	fromStringData:[ [ "2011-12", new Date( 2011, 11 ) ],
				     [ "1970-01", new Date( 1970, 0  ) ] ]
	
	reverseData:"2011-12"

module "week utils tests"

testGenericDateTimeFunctions
	type:"week"
	validateFunctionName:"isValidWeek"
	validateFunction:isValidWeek
	validData:[ "2011-W12", "1970-W07" ]
	invalidData:[ "", "foo", "200-W1", "20-W00", "-W", null ]

	toStringFunctionName:"weekToString"
	toStringFunction:weekToString
	toStringData:[ [ ( new Date 2012, 0, 2 ),  "2012-W01" ],
				   [ ( new Date 2011, 0, 3 ),  "2011-W01" ], 
				   [ ( new Date 2011, 7, 25 ), "2011-W34" ], 
				   [ ( new Date 2010, 4, 11 ), "2010-W19" ] ]
	
	fromStringFunctionName:"weekFromString"
	fromStringFunction:weekFromString
	fromStringData:[ [ "2012-W01", new Date 2012, 0, 2  ],
				     [ "2011-W01", new Date 2011, 0, 3  ],
				     [ "2011-W34", new Date 2011, 7, 22 ],
				     [ "2010-W19", new Date 2010, 4, 10 ] ]
	
	reverseData:"2011-W12"

module "datetime utils tests"

testGenericDateTimeFunctions
	type:"datetime"
	validateFunctionName:"isValidDateTime"
	validateFunction:isValidDateTime
	validData:[ "2011-10-10T10:45:32+01:00", "2011-10-10T10:45:32-02:00", "2011-10-10T10:45:32.786Z" ]
	invalidData:[ "", "foo", "2011-10-10", "10:15:75", "2011-16-10T", "T10:15:75", "-W", null ]

	toStringFunctionName:"datetimeToString"
	toStringFunction:datetimeToString
	toStringData:[ [ new Date( 2011, 0, 1, 0, 0, 0 ), 			"2011-01-01T00:00:00+01:00"     ],
				   [ new Date( 2012, 2, 25, 16, 44, 37 ), 		"2012-03-25T16:44:37+02:00"     ],
				   [ new Date( 2012, 2, 25, 16, 44, 37, 756 ),  "2012-03-25T16:44:37.756+02:00" ] ]
	
	fromStringFunctionName:"datetimeFromString"
	fromStringFunction:datetimeFromString
	fromStringData:[ [ "2011-01-01T00:00:00+01:00", 		new Date( 2011, 0, 1, 0, 0, 0 ) 	  	  ],
				     [ "2012-03-25T16:44:37+02:00", 		new Date( 2012, 2, 25, 16, 44, 37 ) 	  ],
				     [ "2012-03-25T16:44:37.756+02:00", 	new Date( 2012, 2, 25, 16, 44, 37, 756 )  ] ]
	
	reverseData:"2012-03-25T16:44:37+02:00"

module "datetimelocal utils tests"

testGenericDateTimeFunctions
	type:"datetimeLocal"
	validateFunctionName:"isValidDateTimeLocal"
	validateFunction:isValidDateTimeLocal
	validData:[ "2011-10-10T10:45:32", "2011-10-10T10:45:32.786" ]
	invalidData:[ "", "foo", "2011-10-10", "10:15:75", "2011-16-10T", "T10:15:75", "-W", null ]

	toStringFunctionName:"datetimeLocalToString"
	toStringFunction:datetimeLocalToString
	toStringData:[ [ new Date( 2011, 0, 1, 0, 0, 0 ), 			"2011-01-01T00:00:00" 	  ],
				   [ new Date( 2012, 2, 25, 16, 44, 37 ), 		"2012-03-25T16:44:37" 	  ],
				   [ new Date( 2012, 2, 25, 16, 44, 37, 756 ),  "2012-03-25T16:44:37.756" ] ]
	
	fromStringFunctionName:"datetimeLocalFromString"
	fromStringFunction:datetimeLocalFromString
	fromStringData:[ [ "2011-01-01T00:00:00", 		new Date( 2011, 0, 1, 0, 0, 0 ) 	  	  ],
				     [ "2012-03-25T16:44:37", 		new Date( 2012, 2, 25, 16, 44, 37 ) 	  ],
				     [ "2012-03-25T16:44:37.756", 	new Date( 2012, 2, 25, 16, 44, 37, 756 ) ] ]
	
	reverseData:"2012-03-25T16:44:37"

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
	defaultValue:"2011-06-21T16:27:53+02:00"

	invalidDates:[ null, new Date "foo" ]
	invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

	setDate:new Date 2011, 7, 15, 8, 35, 12
	setValue:"2011-08-15T08:35:12+02:00"

	minDate:new Date 2011, 0, 1, 0, 0, 0
	minValue:"2011-01-01T00:00:00+01:00"

	invalidMinDate:new Date 2010, 11, 31, 23, 59, 59
	invalidMinValue:"2010-12-31T23:59:59+01:00"

	maxDate:new Date 2011, 11, 31, 23, 59, 59
	maxValue:"2011-12-31T23:59:59+01:00"

	invalidMaxDate:new Date 2012, 0, 1, 0
	invalidMaxValue:"2012-01-01T00:00:00+01:00"

	stepValue:1800

module "datetimelocalinput tests"

testGenericDateWidgetBehaviors 
	classname:"DateTimeLocalInput"
	cls:DateTimeLocalInput
	type:"datetime-local"

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

