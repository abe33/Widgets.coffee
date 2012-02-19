$( document ).ready ->

    module "numeric-widget tests"

    test "NumericWidget should allow input with type number as target", ->

        target = $("<input type='number'></input>")[0]
        widget = new NumericWidget target

        assertThat widget.target is target

    test "NumericWidget should allow input with type range as target", ->

        target = $("<input type='range'></input>")[0]
        widget = new NumericWidget target

        assertThat widget.target is target

    test "NumericWidget should hide their target", ->

        target = $("<input type='range' value='10'
                           min='0' max='50' step='1'></input>")
        widget = new NumericWidget target[0]

        assertThat target.attr("style"), contains "display: none"

    test "Concret numeric widgets class should receive an updateDummy
          call when value change", ->

        updateDummyCalled = false

        class MockNumericWidget extends NumericWidget
            updateDummy:(value, min, max)->
                updateDummyCalled = true

        widget = new MockNumericWidget
        widget.set "value", 20

        assertThat updateDummyCalled

    testValueInRangeMixin
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"

        initialValue:10
        valueBelowRange:-10
        valueAboveRange:110

        minValue:0
        setMinValue:50
        invalidMinValue:110

        maxValue:100
        setMaxValue:5
        invalidMaxValue:-10

        stepValue:5
        setStep:3
        valueNotInStep:10
        snappedValue:9

        singleIncrementValue:15
        singleDecrementValue:5

        undefinedMinValueMatcher:nullValue()
        undefinedMaxValueMatcher:nullValue()
        undefinedStepValueMatcher:nullValue()

    testValueInRangeMixinIntervals
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"

    testValueInRangeMixinKeyboard
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"
        key:"up"
        action:"increment"
        valueMatcher:closeTo 15, 1
        initialValueMatcher:equalTo 10

    testValueInRangeMixinKeyboard
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"
        key:"down"
        action:"decrement"
        valueMatcher:closeTo 5, 1
        initialValueMatcher:equalTo 10

    testValueInRangeMixinKeyboard
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"
        key:"right"
        action:"increment"
        valueMatcher:closeTo 15, 1
        initialValueMatcher:equalTo 10

    testValueInRangeMixinKeyboard
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"
        key:"left"
        action:"decrement"
        valueMatcher:closeTo 5, 1
        initialValueMatcher:equalTo 10

    testValueInRangeMixinMouseWheel
        cls:NumericWidget
        className:"NumericWidget"
        defaultTarget:"<input min='0' max='100' step='5' value='10'>"
        initialValue:10
        singleIncrementValue:15



