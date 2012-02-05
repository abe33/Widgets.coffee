# opt = 
#   cls:Class
#   className:"Class"
#   defaultTarget:"<node>"
#   initialValue:10
#   valueBelowRange:-10
#   valueAboveRange:110
#   minValue:0
#   setMinValue:50
#   invalidMinValue:110
#   maxValue:100
#   setMaxValue:5
#   invalidMaxValue:-10
#   setStep:3
#   valueNotInStep:10
#   snappedValue:9
#   singleIncrementValue:15
#   singleDecrementValue:5
testRangeStepperMixinBehavior=( opt )->
    test "#{ opt.className } value shouldn't be set on a value outside of the range", ->
        target = $ opt.defaultTarget        
        widget = new opt.cls target[0]

        widget.set "value", opt.valueBelowRange

        assertThat widget.get("value"), strictlyEqualTo widget.get("min") 

        widget.set "value", opt.valueAboveRange

        assertThat widget.get("value"), strictlyEqualTo widget.get("max")

    test "#{ opt.className } value should be constrained by step", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        widget.set "step", opt.setStep

        widget.set "value", opt.valueNotInStep

        assertThat widget.get("value"), strictlyEqualTo opt.snappedValue

    test "#{ opt.className } min property should be snapped on the step", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        widget.set "step", opt.setStep

        widget.set "min", opt.valueNotInStep

        assertThat widget.get("min"), strictlyEqualTo opt.snappedValue
    
    test "#{ opt.className } max property should be snapped on the step", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        widget.set "step", opt.setStep

        widget.set "max", opt.valueNotInStep

        assertThat widget.get("max"), strictlyEqualTo opt.snappedValue
    
    test "Changing widget's min property should correct the value if it goes out of the range", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "value", opt.minValue
        widget.set "min", opt.setMinValue

        assertThat widget.get("value"), strictlyEqualTo widget.get("min")

    test "Changing widget's max property should correct the value if it goes out of the range", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "value", opt.maxValue
        widget.set "max", opt.setMaxValue

        assertThat widget.get("value"), strictlyEqualTo widget.get("max")

    test "Changing widget's step property should correct the value if it doesn't snap anymore", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "value", opt.valueNotInStep
        widget.set "step", opt.setStep

        assertThat widget.get("value"), strictlyEqualTo opt.snappedValue

    test "Setting a min value greater than the max value shouldn't be allowed", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "min", opt.invalidMinValue

        assertThat widget.get("min"), strictlyEqualTo opt.minValue

    test "Setting a max value lower than the min value shouldn't be allowed", ->
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "max", opt.invalidMaxValue

        assertThat widget.get("max"), strictlyEqualTo opt.maxValue
    
    test "#{ opt.className } should allow to increment the value through a function", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.increment()

        assertThat widget.get("value"), equalTo opt.singleIncrementValue

    test "#{ opt.className } should allow to decrement the value through a function", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.decrement()

        assertThat widget.get("value"), equalTo opt.singleDecrementValue
    
    test "#{ opt.className } initial range data should be taken from the target if provided", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        assertThat widget.get("min"),   strictlyEqualTo opt.minValue
        assertThat widget.get("max"),   strictlyEqualTo opt.maxValue
        assertThat widget.get("step"),  strictlyEqualTo opt.stepValue

    test "Changing the widget data should modify the target", ->
        
        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.set "min", opt.invalidMaxValue
        widget.set "max", opt.invalidMinValue
        widget.set "step", opt.setStep

        assertThat target.attr("min"), equalTo opt.invalidMaxValue
        assertThat target.attr("max"), equalTo opt.invalidMinValue
        assertThat target.attr("step"), equalTo opt.setStep

    test "#{ opt.className } initial range data shouldn't be set when the target isn't specified", ->

        widget = new opt.cls
        
        assertThat widget.get("min"),   opt.undefinedMinValueMatcher
        assertThat widget.get("max"),   opt.undefinedMaxValueMatcher
        assertThat widget.get("step"),  opt.undefinedStepValueMatcher

# opt=
#   cls:Class
#   className:"Class"
#   defaultTarget:"<node>"
testRangeStepperMixinIntervalsRunning=( opt )->
    asyncTest "#{ opt.className } should provide a way to increment the value on an interval", ->

        incrementCalled = false
        incrementCalledCount = 0
        incrementCalledCountAtStop = 0


        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        widget.increment=()->
            incrementCalled = true
            incrementCalledCount++

        widget.startIncrement()

        setTimeout ->
            assertThat widget.intervalId isnt -1
            assertThat incrementCalledCount, greaterThanOrEqualTo 0

            incrementCalledCountAtStop = incrementCalledCount

            widget.endIncrement()
        , 70

        setTimeout ->
            assertThat widget.intervalId is -1
            assertThat incrementCalledCount, equalTo incrementCalledCountAtStop

            start()
        , 300

    asyncTest "#{ opt.className } should provide a way to decrement the value on an interval", ->

        decrementCalled = false
        decrementCalledCount = 0
        decrementCalledCountAtStop = 0

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        widget.decrement=->
            incrementdecrementalled = true
            decrementCalledCount++

        widget.startDecrement()

        setTimeout ->
            assertThat widget.intervalId isnt -1
            assertThat decrementCalledCount, greaterThanOrEqualTo 0

            decrementCalledCountAtStop = decrementCalledCount
            widget.endDecrement()
        , 70

        setTimeout ->
            assertThat widget.intervalId is -1
            assertThat decrementCalledCount, equalTo decrementCalledCountAtStop

            start()
        , 300

    asyncTest "#{ opt.className } shouldn't start several interval when startIncrement is called many times", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        incrementCalledCount = 0

        widget.increment=()->
            incrementCalledCount++

        widget.startIncrement()
        widget.startIncrement()
        widget.startIncrement()
        widget.startIncrement()

        setTimeout ->
            assertThat incrementCalledCount, lowerThanOrEqualTo 2
            widget.endIncrement()
            start()
        , 70

    asyncTest "#{ opt.className } shouldn't start several interval when startDecrement is called many times", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        decrementCalledCount = 0
        widget.decrement=()->
            decrementCalledCount++

        widget.startDecrement()
        widget.startDecrement()
        widget.startDecrement()
        widget.startDecrement()

        setTimeout ->
            assertThat decrementCalledCount, lowerThanOrEqualTo 2
            widget.endIncrement()
            start()
        , 100
    
# opt=
#   cls:Class
#   className:"Class"
#   defaultTarget:"<node>"
#   key:"up"
#   action:"increment"
#   valueMatcher:closeTo 2, 1
#   initialValueMatcher:equalTo 10
testRangeStepperMixinKeyboardBehavior=( opt )->
    asyncTest "When the #{ opt.key } key is pressed the widget should #{ opt.action } the value", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        widget.grabFocus()
        widget.keydown
            keyCode:keys[ opt.key ]
            ctrlKey:false
            shiftKey:false
            altKey:false

        setTimeout ->
            assertThat widget.get("value"), opt.valueMatcher

            start()
        , 70

    asyncTest "Receiving several keydown of the #{ opt.key } key shouldn't trigger several #{ opt.action }", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]
        e = {
            keyCode:keys[ opt.key ],
            ctrlKey:false,
            shiftKey:false,
            altKey:false
        }

        widget.grabFocus()
        widget.keydown e
        widget.keydown e
        widget.keydown e
        widget.keydown e
        widget.keydown e
        
        setTimeout ->
            assertThat widget.get("value"), opt.valueMatcher

            start()
        , 70

    asyncTest "When the #{ opt.key } key is released the widget should stop #{ opt.action } the value", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        e = {
            keyCode:keys[ opt.key ],
            ctrlKey:false,
            shiftKey:false,
            altKey:false
        }

        widget.grabFocus()
        widget.keydown e

        setTimeout ->
            widget.keyup e
        , 70

        setTimeout ->
            assertThat widget.get("value"), opt.valueMatcher

            start()
        , 200

    asyncTest "Stopping the #{ opt.action } on keyup should allow to start a new one", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        e = {
            keyCode:keys[ opt.key ],
            ctrlKey:false,
            shiftKey:false,
            altKey:false
        }
        widget.grabFocus()
        widget.keydown e
        widget.keyup e

        widget.keydown e

        setTimeout ->
            assertThat widget.get("value"), opt.valueMatcher

            start()
        , 70
    
    asyncTest "Trying to #{ opt.action } a readonly widget shouldn't work", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        e = {
            keyCode:keys[ opt.key ],
            ctrlKey:false,
            shiftKey:false,
            altKey:false
        }
        widget.set "readonly", true

        widget.grabFocus()
        widget.keydown e

        setTimeout ->
            assertThat widget.get("value"), opt.initialValueMatcher

            start()
        , 100

    asyncTest "Trying to #{ opt.action } a disabled widget shouldn't work", ->

        target = $ opt.defaultTarget
        widget = new opt.cls target[0]

        e = {
            keyCode:keys[ opt.key ],
            ctrlKey:false,
            shiftKey:false,
            altKey:false
        }
        widget.set "disabled", true

        widget.grabFocus()
        widget.keydown e

        setTimeout ->
            assertThat widget.get("value"), opt.initialValueMatcher

            start()
        , 100


# opt=
#   cls:Class
#   className:"Class"
#   defaultTarget:"<node>"
#   initialValue:10
#   setValue:15
testRangeStepperMixinMouseWheelBehavior=( opt )->

    class MockStepper extends opt.cls
        mousewheel:( e, d )->
            d = 1 
            super e, d

    test "Using the mousewheel over a widget should change the value according to the step", ->
        
        target = $ opt.defaultTarget
        widget = new MockStepper target[0]
        widget.dummy.mousewheel()

        assertThat widget.get("value"), strictlyEqualTo opt.singleIncrementValue

    test "Using the mousewheel over a readonly widget shouldn't change the value", ->
         
        target = $ opt.defaultTarget
        widget = new MockStepper target[0]
        widget.set "readonly", true
        widget.dummy.mousewheel()

        assertThat widget.get("value"), strictlyEqualTo opt.initialValue

    test "Using the mousewheel over a disabled widget shouldn't change the value", ->
        
        target = $ opt.defaultTarget

        widget = new MockStepper target[0]
        widget.set "disabled", true
        widget.dummy.mousewheel()

        assertThat widget.get("value"), strictlyEqualTo opt.initialValue


if window?
    window.testRangeStepperMixinBehavior            = testRangeStepperMixinBehavior
    window.testRangeStepperMixinKeyboardBehavior    = testRangeStepperMixinKeyboardBehavior
    window.testRangeStepperMixinMouseWheelBehavior  = testRangeStepperMixinMouseWheelBehavior
    window.testRangeStepperMixinIntervalsRunning    = testRangeStepperMixinIntervalsRunning