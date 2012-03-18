# The basic tests for all the utils and widgets are done through
# the generic function below.

testGenericDateWidgetBehaviors=( opt )->

  test "A #{ opt.className } should allow an input
      with type #{ opt.type } as target", ->

    target = $("<input type='#{ opt.type }'></input>")[0]
    input = new opt.cls target

    assertThat input.target is target

  test "A #{ opt.className } should hide its target after creation", ->

    target = $("<input type='#{ opt.type }'></input>")[0]
    input = new opt.cls target

    assertThat input.jTarget.attr("style"), contains "display: none"

  test "A #{ opt.className } shouldn't allow an input
      with a type different than #{ opt.type } as target", ->

    target = $("<input type='text'></input>")[0]
    errorRaised = false

    try
      input = new opt.cls target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "A #{ opt.className } should allow a date object
      as first argument", ->

    d = opt.defaultDate
    input = new opt.cls d

    assertThat input.get( "date" ), dateEquals d

  test "When passing a Date as first argument, the value
      should match the date", ->
    d = opt.defaultDate
    input = new opt.cls d

    assertThat input.get( "value" ), equalTo opt.defaultValue

  test "Creating a #{ opt.className } without argument should
      setup a default Date", ->
    d = new Date
    input = new opt.cls
    d2 = input.get "date"
    d.setMilliseconds 0
    d2.setMilliseconds 0

    assertThat input.dateToValue(d2),
           equalTo input.dateToValue input.snapToStep d

  test "A #{ opt.className } should set its date with the value
      of the target", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")[0]
    input = new opt.cls target

    assertThat input.get( "date" ), dateEquals opt.defaultDate

  test "Changing the date of a #{ opt.className } should
      change the value", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")[0]
    input = new opt.cls target

    d = opt.setDate
    input.set "date", d

    assertThat input.get( "value" ), equalTo opt.setValue

  test "Changing the value of a #{ opt.className } should
      change the date", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")[0]
    input = new opt.cls target

    d = opt.setDate
    input.set "value", opt.setValue

    assertThat input.get( "date" ), dateEquals d

  test "#{ opt.className } should prevent invalid
      values to affect it", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")[0]
    input = new opt.cls target

    for invalidValue in opt.invalidValues
      input.set "value", invalidValue

    assertThat input.get("value"), equalTo opt.defaultValue

  test "#{ opt.className } should prevent invalid
      dates to affect it", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")[0]
    input = new opt.cls target

    for invalidDate in opt.invalidDates
      input.set "date", invalidDate

    assertThat input.get("value"), equalTo opt.defaultValue

  test "#{ opt.className } should prevent invalid values
      to be set in the target", ->

    target = $("<input type='#{ opt.type }'
               value='foo'
               min='foo'
               max='foo'
               step='foo'></input>")[0]
    input = new opt.cls target

    assertThat not isNaN input.get( "date" ).hours()
    assertThat input.get( "min" ), opt.undefinedMinValueMatcher
    assertThat input.get( "max" ), opt.undefinedMaxValueMatcher
    assertThat input.get( "step" ), opt.undefinedStepValueMatcher

  test "Changing the value should change the target value as well", ->

    target = $ "<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>"
    input = new opt.cls target[0]

    input.set "value", opt.setValue

    assertThat target.val(), equalTo opt.setValue

  test "Changing the date should change the target value as well", ->

    target = $("<input type='#{ opt.type }'
               value='#{ opt.defaultValue }'></input>")
    input = new opt.cls target[0]

    input.set "date", opt.setDate

    assertThat target.val(), equalTo opt.setValue

  test "A #{ opt.className } should provide a dummy", ->

    assertThat ( new opt.cls ).dummy, notNullValue()

  test "A #{ opt.className } dummy should have the type
      of the input as class", ->

    input = new opt.cls new Date, "#{ opt.type }"
    assertThat input.dummy.hasClass "#{ opt.type }"

  defaultTarget = "<input type='#{ opt.type }'
              value='#{ opt.defaultValue }'
              min='#{ opt.minValue }'
              max='#{ opt.maxValue }'
              step='#{ opt.stepValue }'></input>"

  testValueInRangeMixin
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

  testValueInRangeMixinIntervals
    cls:opt.cls
    className:opt.className
    defaultTarget:defaultTarget

  testValueInRangeMixinKeyboard
    cls:opt.cls
    className:opt.className
    defaultTarget:defaultTarget
    key:"up"
    action:"increment"
    valueMatcher:opt.singleIncrementValue
    initialValueMatcher:equalTo opt.defaultValue

  testValueInRangeMixinKeyboard
    cls:opt.cls
    className:opt.className
    defaultTarget:defaultTarget
    key:"down"
    action:"decrement"
    valueMatcher:opt.singleDecrementValue
    initialValueMatcher:equalTo opt.defaultValue

  testValueInRangeMixinKeyboard
    cls:opt.cls
    className:opt.className
    defaultTarget:defaultTarget
    key:"right"
    action:"increment"
    valueMatcher:opt.singleIncrementValue
    initialValueMatcher:equalTo opt.defaultValue

  testValueInRangeMixinKeyboard
    cls:opt.cls
    className:opt.className
    defaultTarget:defaultTarget
    key:"left"
    action:"decrement"
    valueMatcher:opt.singleDecrementValue
    initialValueMatcher:equalTo opt.defaultValue

  testValueInRangeMixinMouseWheel
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

  testFocusProvidedByChildMixin
    className:"TimeInput"
    cls:TimeInput
    focusChildSelector:"input"

  test "A TimeInput dummy should contains an input that contains
      the value", ->

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

  test "When the value change in the TimeInput's input,
     the TimeInput should validate the new value", ->
    input = new TimeInput

    input.dummy.children(".value").val("10:40")
    input.dummy.children(".value").change()

    assertThat input.get("value"), equalTo "10:40:00"

  test "When the value in the TimeInput's input is invalid,
      the TimeInput should turn it back to the valid value", ->

    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".value").val("abcd")
    input.dummy.children(".value").change()

    assertThat input.get("value"), equalTo "11:20:00"
    assertThat input.dummy.children(".value").val(), equalTo "11:20"

  test "Pressing the mouse on the minus button should start
      a decrement interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".down").mousedown()

    assertThat input.intervalId isnt -1

    input.endIncrement()

  test "Releasing the mouse on the minus button should stop
      the decrement interval", ->

    input = new TimeInput

    input.dummy.children(".down").mousedown()
    input.dummy.children(".down").mouseup()

    assertThat input.intervalId is -1

    input.endIncrement()

  test "Releasing the mouse outside of the minus button should
      stop the decrement interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".down").mousedown()

    $( document ).mouseup()
    assertThat not input.mousePressed
    assertThat input.intervalId is -1

    input.endIncrement()

  test "Moving the mouse out of the minus button should stop
      the decrement interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".down").mousedown()
    input.dummy.children(".down").mouseout()

    assertThat input.intervalId is -1

    input.endIncrement()

  test "Moving the mouse back to the minus button should
      restart the decrement interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".down").mousedown()
    input.dummy.children(".down").mouseout()
    input.dummy.children(".down").mouseover()

    assertThat input.intervalId isnt -1

    input.endIncrement()

  test "Pressing the mouse on the plus button should start
      a increment interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".up").mousedown()

    assertThat input.intervalId isnt -1

    input.endIncrement()

  test "Releasing the mouse on the plus button should stop
      the increment interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".up").mousedown()
    input.dummy.children(".up").mouseup()

    assertThat input.intervalId is -1

    input.endIncrement()

  test "Releasing the mouse outside of the plus button should
      stop the increment interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".up").mousedown()
    $( document ).mouseup()

    assertThat input.intervalId is -1

    input.endIncrement()

  test "Moving the mouse out of the plus button should stop
      the increment interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".up").mousedown()
    input.dummy.children(".up").mouseout()

    assertThat input.intervalId is -1

    input.endIncrement()

  test "Moving the mouse back to the plus button should
      restart the increment interval", ->
    d = Date.timeFromString "11:20"
    input = new TimeInput d

    input.dummy.children(".up").mousedown()
    input.dummy.children(".up").mouseout()
    input.dummy.children(".up").mouseover()

    assertThat input.intervalId isnt -1

    input.endIncrement()

  test "Pressing the mouse over the input and moving
      it to the up should increment the value until
      the mouse is released", ->

    class MockTimeInput extends TimeInput
      mousedown:(e)->
        e.pageY = 5
        super e

      mousemove:(e)->
        e.pageY = 0
        super e

    d = Date.timeFromString "11:20"
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

  test "A DateInput dummy should contains an span that contains
      the value", ->

    input = new DateInput new Date 1970, 0, 1

    text = input.dummy.find(".value")

    assertThat text.length, equalTo 1
    assertThat text.text(), equalTo "1970-01-01"

  test "The DateInput dummy's input should be updated on value change", ->

    input = new DateInput new Date 1970, 0, 1

    input.set "value", "2004-05-13"
    text = input.dummy.find(".value")

    assertThat text.text(), equalTo "2004-05-13"

  test "Clicking on a DateInput should trigger a dialogRequested signal", ->

    input = new DateInput new Date 1970, 0, 1

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true
      signalSource = widget

    input.dummy.mouseup()

    assertThat signalCalled
    assertThat signalSource is input

    DateInput.calendar.close()

  test "Clicking on a disabled DateInput shouldn't
      trigger a dialogRequested signal", ->

    input = new DateInput new Date 1970, 0, 1
    input.set "disabled", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    DateInput.calendar.close()

  test "Clicking on a readonly DateInput shouldn't
      trigger a dialogRequested signal", ->

    input = new DateInput new Date 1970, 0, 1
    input.set "readonly", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    DateInput.calendar.close()

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

  test "A MonthInput dummy should contains an span that contains
      the value", ->

    input = new MonthInput new Date 1970, 0

    text = input.dummy.find(".value")

    assertThat text.length, equalTo 1
    assertThat text.text(), equalTo "1970-01"

  test "The MonthInput dummy's input should be updated on value change", ->

    input = new MonthInput new Date 1970, 0

    input.set "value", "2004-05"
    text = input.dummy.find(".value")

    assertThat text.text(), equalTo "2004-05"

  test "Clicking on a MonthInput should trigger a dialogRequested signal", ->

    input = new MonthInput new Date 1970, 0

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true
      signalSource = widget

    input.dummy.mouseup()

    assertThat signalCalled
    assertThat signalSource is input

    MonthInput.calendar.close()

  test "Clicking on a disabled MonthInput shouldn't
      trigger a dialogRequested signal", ->

    input = new MonthInput new Date 1970, 0
    input.set "disabled", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    MonthInput.calendar.close()

  test "Clicking on a readonly MonthInput shouldn't
      trigger a dialogRequested signal", ->

    input = new MonthInput new Date 1970, 0
    input.set "readonly", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    MonthInput.calendar.close()

  module "weekinput tests"

  testGenericDateWidgetBehaviors
    className:"WeekInput"
    cls:WeekInput
    type:"week"

    defaultDate:Date.weekFromString "2012-W01"
    defaultValue:"2012-W01"

    invalidDates:[ null, new Date "foo" ]
    invalidValues:[ null, "foo", "122-50", "1-1-+6" ]

    setDate:Date.weekFromString "2011-W31"
    setValue:"2011-W31"

    minDate:Date.weekFromString "2011-W04"
    minValue:"2011-W04"
    valueBelowRange:"2011-W01"
    invalidMinValue:"2014-W35"

    maxDate:Date.weekFromString "2013-W04"
    maxValue:"2013-W04"
    valueAboveRange:"2100-W05"
    invalidMaxValue:"2010-W09"

    stepValue:1800
    setStep:3600
    valueNotInStep:"2012-W05"
    snappedValue:"2012-W05"
    singleIncrementValue:"2012-W01"
    singleDecrementValue:"2012-W52"

    undefinedMinValueMatcher:nullValue()
    undefinedMaxValueMatcher:nullValue()
    undefinedStepValueMatcher:nullValue()

  test "A WeekInput dummy should contains an span that contains
      the value", ->

    input = new WeekInput Date.weekFromString "2012-W16"

    text = input.dummy.find(".value")

    assertThat text.length, equalTo 1
    assertThat text.text(), equalTo "2012-W16"

  test "The WeekInput dummy's input should be updated on value change", ->

    input = new WeekInput Date.weekFromString "2012-W16"

    input.set "value", "2004-W05"
    text = input.dummy.find(".value")

    assertThat text.text(), equalTo "2004-W05"

  test "Clicking on a WeekInput should trigger a dialogRequested signal", ->

    input = new WeekInput Date.weekFromString "2012-W16"

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true
      signalSource = widget

    input.dummy.mouseup()

    assertThat signalCalled
    assertThat signalSource is input

    WeekInput.calendar.close()

  test "Clicking on a disabled WeekInput shouldn't
      trigger a dialogRequested signal", ->

    input = new WeekInput Date.weekFromString "2012-W16"
    input.set "disabled", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    WeekInput.calendar.close()

  test "Clicking on a readonly WeekInput shouldn't
      trigger a dialogRequested signal", ->

    input = new WeekInput Date.weekFromString "2012-W16"
    input.set "readonly", true

    signalCalled = false
    signalSource = null

    input.dialogRequested.add ( widget )->
      signalCalled = true

    input.dummy.mouseup()

    assertThat not signalCalled

    WeekInput.calendar.close()

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

  test "DateTimeInput should compose a DateInput and a TimeInput
      as children", ->

    input = new DateTimeInput

    assertThat input.children.length, equalTo 2
    assertThat input.dummy.children().length, equalTo 2

  test "Changing the value on the widget should change the value
      of its children accordingly", ->

    input = new DateTimeInput

    input.set "value", "2011-08-15T08:35:00+02:00"

    assertThat input.dateInput.get("value"), equalTo "2011-08-15"
    assertThat input.timeInput.get("value"), equalTo "08:35:00"

  test "Changing the value of the inner date input should update
      the DateTimeLocalInput value", ->

    input = new DateTimeInput
    input.set "value", "2011-08-15T08:35:00+02:00"

    input.dateInput.set "value", "2016-03-25"

    assertThat input.get("value"), equalTo "2016-03-25T08:35:00+01:00"

  test "Changing the value of the inner time input should update
      the DateTimeLocalInput value", ->

    input = new DateTimeInput
    input.set "value", "2011-08-15T08:35:00+02:00"

    input.timeInput.set "value", "16:25:00"

    assertThat input.get("value"), equalTo "2011-08-15T16:25:00+02:00"


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

  test "DateTimeLocalInput should compose a DateInput and a TimeInput
      as children", ->

    input = new DateTimeLocalInput

    assertThat input.children.length, equalTo 2
    assertThat input.dummy.children().length, equalTo 2

  test "Changing the value on the widget should change the value
      of its children accordingly", ->

    input = new DateTimeLocalInput

    input.set "value", "2011-08-15T08:35:00"

    assertThat input.dateInput.get("value"), equalTo "2011-08-15"
    assertThat input.timeInput.get("value"), equalTo "08:35:00"

  test "Changing the value of the inner date input should update
      the DateTimeLocalInput value", ->

    input = new DateTimeLocalInput
    input.set "value", "2011-08-15T08:35:00"

    input.dateInput.set "value", "2016-03-25"

    assertThat input.get("value"), equalTo "2016-03-25T08:35:00"

  test "Changing the value of the inner time input should update
      the DateTimeLocalInput value", ->

    input = new DateTimeLocalInput
    input.set "value", "2011-08-15T08:35:00"

    input.timeInput.set "value", "16:25:00"

    assertThat input.get("value"), equalTo "2011-08-15T16:25:00"

