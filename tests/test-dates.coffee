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

	test "A #{ opt.className } should allow an input with type #{ opt.type } as target", ->

		target = $("<input type='#{ opt.type }'></input>")[0]
		input = new opt.cls target

		assertThat input.target is target
	
	test "A #{ opt.className } should hide its target after creation", ->

		target = $("<input type='#{ opt.type }'></input>")[0]
		input = new opt.cls target

		assertThat input.jTarget.attr("style"), contains "display: none"
		
	test "A #{ opt.className } shouldn't allow an input with a type different than #{ opt.type } as target", ->

		target = $("<input type='text'></input>")[0]
		errorRaised = false

		try
			input = new opt.cls target
		catch e
			errorRaised = true

		assertThat errorRaised

	test "A #{ opt.className } should allow a date object as first argument", ->

		d = opt.defaultDate
		input = new opt.cls d
		
		assertThat input.get( "date" ), dateEquals d

	test "When passing a Date as first argument, the value should match the date", ->
		d = opt.defaultDate
		input = new opt.cls d

		assertThat input.get( "value" ), equalTo opt.defaultValue

	test "Creating a #{ opt.className } without argument should setup a default Date", ->
		d = new Date
		input = new opt.cls
		d2 = input.get "date"
		d.setMilliseconds 0
		d2.setMilliseconds 0

		assertThat input.dateToValue(d2), equalTo input.dateToValue input.snapToStep d

	test "A #{ opt.className } should set its date with the value of the target", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target
		
		assertThat input.get( "date" ), dateEquals opt.defaultDate

	test "Changing the date of a #{ opt.className } should change the value", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		d = opt.setDate
		input.set "date", d

		assertThat input.get( "value" ), equalTo opt.setValue

	test "Changing the value of a #{ opt.className } should change the date", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		d = opt.setDate
		input.set "value", opt.setValue

		assertThat input.get( "date" ), dateEquals d 

	test "#{ opt.className } should prevent invalid values to affect it", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		for invalidValue in opt.invalidValues
			input.set "value", invalidValue

		assertThat input.get("value"), equalTo opt.defaultValue

	test "#{ opt.className } should prevent invalid dates to affect it", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")[0]
		input = new opt.cls target

		for invalidDate in opt.invalidDates
			input.set "date", invalidDate

		assertThat input.get("value"), equalTo opt.defaultValue

	test "#{ opt.className } should prevent invalid values to be set in the target", ->

		target = $("<input type='#{ opt.type }' value='foo' min='foo' max='foo' step='foo'></input>")[0]
		input = new opt.cls target

		assertThat not isNaN input.get( "date" ).getHours()
		assertThat input.get( "min" ), opt.undefinedMinValueMatcher
		assertThat input.get( "max" ), opt.undefinedMaxValueMatcher
		assertThat input.get( "step" ), opt.undefinedStepValueMatcher
	
	test "Changing the value should change the target value as well", ->
		
		target = $ "<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>"
		input = new opt.cls target[0]

		input.set "value", opt.setValue

		assertThat target.val(), equalTo opt.setValue
	
	test "Changing the date should change the target value as well", ->

		target = $("<input type='#{ opt.type }' value='#{ opt.defaultValue }'></input>")
		input = new opt.cls target[0]

		input.set "date", opt.setDate

		assertThat target.val(), equalTo opt.setValue
		
	test "A #{ opt.className } should provide a dummy", ->
	
		assertThat ( new opt.cls ).dummy, notNullValue() 
	
	test "A #{ opt.className } dummy should have the type of the input as class", ->

		assertThat ( new opt.cls new Date, "#{ opt.type }" ).dummy.hasClass "#{ opt.type }"
	
	defaultTarget = "<input type='#{ opt.type }' 
							value='#{ opt.defaultValue }' 
							min='#{ opt.minValue }' 
							max='#{ opt.maxValue }'
							step='#{ opt.stepValue }'></input>"
	
	testValueInRangeMixinBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget

		initialValue:opt.defaultValue
		valueBelowRange:opt.valueBelowRange
		valueAboveRange:opt.valueAboveRange
		
		minValue:opt.minValue
		setMinValue:opt.setValue
		invalidMinValue:opt.invalidMinValue

		maxValue:opt.maxValue
		setMaxValue:opt.setValue
		invalidMaxValue:opt.invalidMaxValue

		stepValue:opt.stepValue
		setStep:opt.setStep
		valueNotInStep:opt.valueNotInStep
		snappedValue:opt.snappedValue

		singleIncrementValue:opt.singleIncrementValue
		singleDecrementValue:opt.singleDecrementValue

		undefinedMinValueMatcher:opt.undefinedMinValueMatcher
		undefinedMaxValueMatcher:opt.undefinedMaxValueMatcher
		undefinedStepValueMatcher:opt.undefinedStepValueMatcher

	testValueInRangeMixinIntervalsRunning
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget

	testValueInRangeMixinKeyboardBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget
		key:"up"
		action:"increment"
		valueMatcher:opt.singleIncrementValue
		initialValueMatcher:equalTo opt.defaultValue

	testValueInRangeMixinKeyboardBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget
		key:"down"
		action:"decrement"
		valueMatcher:opt.singleDecrementValue
		initialValueMatcher:equalTo opt.defaultValue

	testValueInRangeMixinKeyboardBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget
		key:"right"
		action:"increment"
		valueMatcher:opt.singleIncrementValue
		initialValueMatcher:equalTo opt.defaultValue

	testValueInRangeMixinKeyboardBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget
		key:"left"
		action:"decrement"
		valueMatcher:opt.singleDecrementValue
		initialValueMatcher:equalTo opt.defaultValue

	testValueInRangeMixinMouseWheelBehavior
		cls:opt.cls
		className:opt.className
		defaultTarget:defaultTarget
		initialValue:opt.defaultValue
		singleIncrementValue:opt.singleIncrementValue
		
	input1 = new opt.cls new Date, opt.type 
	input2 = new opt.cls new Date, opt.type
	input3 = new opt.cls new Date, opt.type

	input2.set "readonly", true
	input3.set "disabled", true

	$("#qunit-header").before $ "<h4>#{ opt.className }</h4>"
	input1.before "#qunit-header"
	input2.before "#qunit-header"
	input3.before "#qunit-header"
			
#### Here starts the concret tests

$( document ).ready ->

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
					   [ new Date( 1970, 0, 1, 0, 0, 0 ),         "00:00:00" ],
					   [ new Date( 1970, 0, 1, 10, 16, 52, 756 ), "10:16:52.756" ] ]
		
		fromStringFunctionName:"timeFromString"
		fromStringFunction:timeFromString
		fromStringData:[ [ "10"		     , new Date 1970, 0, 1, 10			    ],
					     [ "10:16"		 , new Date 1970, 0, 1, 10, 16 			],
					     [ "00:00:00"	 , new Date 1970, 0, 1, 0, 0, 0         ],
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
		className:"TimeInput"
		cls:TimeInput
		type:"time"

		defaultDate:new Date 1970, 0, 1, 11, 30, 0
		defaultValue:"11:30:00"

		invalidDates:[ null, new Date "foo" ]
		invalidValues:[ null, "foo", "100:00:00", "1:22:2" ]

		setDate:new Date 1970, 0, 1, 16, 30, 00
		setValue:"16:30:00"

		minDate:new Date 1970, 0, 1, 10, 0, 0
		minValue:"10:00:00"
		valueBelowRange:"05:45:00"
		invalidMinValue:"23:45:00"

		maxDate:new Date 1970, 0, 1, 23, 0, 0
		maxValue:"23:00:00"
		valueAboveRange:"23:45:00"
		invalidMaxValue:"05:00:00"

		stepValue:1800
		setStep:3600
		valueNotInStep:"10:10:54"
		snappedValue:"10:00:00"

		singleIncrementValue:"12:00:00"
		singleDecrementValue:"11:00:00"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:equalTo 60

	testFocusProvidedByChildMixinBegavior 
		className:"TimeInput"
		cls:TimeInput
		focusChildSelector:"input"

	test "A TimeInput dummy should contains an input that contains the value", ->

		input = new TimeInput new Date 1970, 0, 1, 16, 32, 17, 565
		
		text = input.dummy.find("input")

		assertThat text.length, equalTo 1
		assertThat text.val(), equalTo "16:32"
		assertThat text.hasClass "widget-done"

	test "The TimeInput dummy's input should be updated on value change", ->

		input = new TimeInput new Date 1970, 0, 1, 16, 32, 17, 565
		
		input.set "value", "05:45"
		text = input.dummy.find("input")
		
		assertThat text.val(), equalTo "05:45"
	
	test "When the value change in the TimeInput's input, the TimeInput should validate the new value", ->
		input = new TimeInput

		input.dummy.children(".value").val("10:40")
		input.dummy.children(".value").change()

		assertThat input.get("value"), equalTo "10:40:00"

	test "When the value in the TimeInput's input is invalid, the TimeInput should turn it back to the valid value", ->

		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".value").val("abcd")
		input.dummy.children(".value").change()

		assertThat input.get("value"), equalTo "11:20:00"
		assertThat input.dummy.children(".value").val(), equalTo "11:20"

	test "Pressing the mouse on the minus button should start a decrement interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".down").mousedown()

		assertThat input.intervalId isnt -1
		
		input.endIncrement()

	test "Releasing the mouse on the minus button should stop the decrement interval", ->

		input = new TimeInput

		input.dummy.children(".down").mousedown()
		input.dummy.children(".down").mouseup()

		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Releasing the mouse outside of the minus button should stop the decrement interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".down").mousedown()

		$( document ).mouseup()
		assertThat not input.mousePressed
		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Moving the mouse out of the minus button should stop the decrement interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".down").mousedown()
		input.dummy.children(".down").mouseout()
	
		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Moving the mouse back to the minus button should restart the decrement interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".down").mousedown()
		input.dummy.children(".down").mouseout()
		input.dummy.children(".down").mouseover()

		assertThat input.intervalId isnt -1
		
		input.endIncrement()

	test "Pressing the mouse on the plus button should start a increment interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".up").mousedown()

		assertThat input.intervalId isnt -1
		
		input.endIncrement()

	test "Releasing the mouse on the plus button should stop the increment interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".up").mousedown()
		input.dummy.children(".up").mouseup()

		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Releasing the mouse outside of the plus button should stop the increment interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".up").mousedown()
		$( document ).mouseup()

		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Moving the mouse out of the plus button should stop the increment interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".up").mousedown()
		input.dummy.children(".up").mouseout()

		assertThat input.intervalId is -1
		
		input.endIncrement()

	test "Moving the mouse back to the plus button should restart the increment interval", ->
		d = timeFromString "11:20"
		input = new TimeInput d

		input.dummy.children(".up").mousedown()
		input.dummy.children(".up").mouseout()
		input.dummy.children(".up").mouseover()

		assertThat input.intervalId isnt -1
		
		input.endIncrement()

	test "Pressing the mouse over the input and moving it to the up should increment the value until the mouse is released", ->

		class MockTimeInput extends TimeInput
			mousedown:(e)->
				e.pageY = 5
				super e

			mousemove:(e)->
				e.pageY = 0
				super e
		
		d = timeFromString "11:20"
		input = new MockTimeInput d

		input.dummy.mousedown()
		$(document).mousemove()
		$(document).mouseup()

		assertThat input.get("value"), equalTo "11:25:00" 
		assertThat not input.dragging
		
	module "dateinput tests"

	testGenericDateWidgetBehaviors 
		className:"DateInput"
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
		valueBelowRange:"1960-05-23"
		invalidMinValue:"2013-05-25"

		maxDate:new Date 2012, 11, 29, 0
		maxValue:"2012-12-29"
		valueAboveRange:"2100-05-21"
		invalidMaxValue:"1960-05-23"

		stepValue:1800
		setStep:3600
		valueNotInStep:"2012-05-27"
		snappedValue:"2012-05-27"
		singleIncrementValue:"1981-09-09"
		singleDecrementValue:"1981-09-08"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:nullValue()

	module "monthinput tests"

	testGenericDateWidgetBehaviors 
		className:"MonthInput"
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
		valueBelowRange:"1960-01"
		invalidMinValue:"2013-01"

		maxDate:new Date 2012, 11, 1, 0
		maxValue:"2012-12"
		valueAboveRange:"2100-05"
		invalidMaxValue:"1960-01"

		stepValue:1800
		setStep:3600
		valueNotInStep:"2012-05"
		snappedValue:"2012-05"

		singleIncrementValue:"1981-09"
		singleDecrementValue:"1981-08"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:nullValue()

	module "weekinput tests"

	testGenericDateWidgetBehaviors 
		className:"WeekInput"
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
		valueBelowRange:"2011-W01"
		invalidMinValue:"2014-W35"

		maxDate:new Date 2013, 0, 21, 0
		maxValue:"2013-W04"
		valueAboveRange:"2100-W05"
		invalidMaxValue:"2010-W09"

		stepValue:1800
		setStep:3600
		valueNotInStep:"2012-W05"
		snappedValue:"2012-W05"
		singleIncrementValue:"2012-W01"
		singleDecrementValue:"2012-W01"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:nullValue()

	module "datetimeinput tests"

	testGenericDateWidgetBehaviors 
		className:"DateTimeInput"
		cls:DateTimeInput
		type:"datetime"

		defaultDate:new Date 2011, 5, 21, 16, 30, 00
		defaultValue:"2011-06-21T16:30:00+02:00"

		invalidDates:[ null, new Date "foo" ]
		invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

		setDate:new Date 2011, 7, 15, 8, 30, 00
		setValue:"2011-08-15T08:30:00+02:00"

		minDate:new Date 2011, 0, 1, 0, 0, 0
		minValue:"2011-01-01T00:00:00+01:00"
		valueBelowRange:"2010-12-31T23:30:00+01:00"
		invalidMinValue:"2013-05-03T23:30:00+01:00"

		maxDate:new Date 2011, 11, 31, 23, 30, 00
		maxValue:"2011-12-31T23:30:00+01:00"
		valueAboveRange:"2013-05-03T00:00:00+01:00"
		invalidMaxValue:"2010-01-01T00:00:00+01:00"

		stepValue:1800
		setStep:3600
		valueNotInStep:"2011-08-15T08:35:12+02:00"
		snappedValue:"2011-08-15T08:00:00+02:00"
		singleIncrementValue:"2011-06-21T17:00:00+02:00"
		singleDecrementValue:"2011-06-21T16:00:00+02:00"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:nullValue()

	module "datetimelocalinput tests"

	testGenericDateWidgetBehaviors 
		className:"DateTimeLocalInput"
		cls:DateTimeLocalInput
		type:"datetime-local"

		defaultDate:new Date 2011, 5, 21, 16, 30, 00
		defaultValue:"2011-06-21T16:30:00"

		invalidDates:[ null, new Date "foo" ]
		invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

		setDate:new Date 2011, 7, 15, 8, 30, 00
		setValue:"2011-08-15T08:30:00"

		minDate:new Date 2011, 0, 1, 0, 0, 0
		minValue:"2011-01-01T00:00:00"
		valueBelowRange:"2010-12-31T23:30:00"
		invalidMinValue:"2013-05-16T23:30:00"

		maxDate:new Date 2011, 11, 31, 23, 30, 00
		maxValue:"2011-12-31T23:00:00"
		valueAboveRange:"2013-05-01T00:00:00"
		invalidMaxValue:"2010-01-07T00:00:00"

		stepValue:1800
		setStep:3600
		valueNotInStep:"2011-08-15T08:35:12"
		snappedValue:"2011-08-15T08:00:00"
		singleIncrementValue:"2011-06-21T17:00:00"
		singleDecrementValue:"2011-06-21T16:00:00"

		undefinedMinValueMatcher:nullValue()
		undefinedMaxValueMatcher:nullValue()
		undefinedStepValueMatcher:nullValue()

