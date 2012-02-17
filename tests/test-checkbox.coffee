$( document ).ready ->

    module "checkbox tests"

    test "CheckBox should allow input with a checkbox type",->
        target = $("<input type='checkbox'></input>")[0]

        checkbox = new CheckBox target

        assertThat checkbox.target is target

    test "CheckBox should allow only input with a checkbox type",->
        target = $("<input type='text'></input>")[0]
        errorRaised = false

        try
            checkbox = new CheckBox target
        catch e
            errorRaised = true

        assertThat errorRaised

    test "CheckBox should reflect the checked state of the input", ->
        target = $("<input type='checkbox' checked></input>")[0]

        checkbox = new CheckBox target

        assertThat checkbox.get "checked"

    test "CheckBox should apply change made to the checked property
          on the target", ->
        target = $("<input type='checkbox' checked></input>")[0]

        checkbox = new CheckBox target

        checkbox.set "checked", false

        assertThat checkbox.get("checked"), equalTo false

    test "CheckBox should be created without a target", ->

        errorRaised = false

        try
            checkbox = new CheckBox
        catch e
            errorRaised = true

        assertThat not errorRaised

    test "CheckBox should provide a dummy", ->

        checkbox = new CheckBox

        assertThat checkbox.dummy, notNullValue()

    test "CheckBox should handle the checked property as a state", ->

        checkbox = new CheckBox

        checkbox.set "checked", true
        checkbox.set "required", true
        checkbox.set "disabled", true
        checkbox.set "readonly", true

        assertThat checkbox.dummy.hasClass "checked"
        assertThat checkbox.dummy.hasClass "required"
        assertThat checkbox.dummy.hasClass "disabled"
        assertThat checkbox.dummy.hasClass "readonly"

    test "All dummy's states provided by the parent class should
          be available as well on CheckBox", ->

        checkbox = new CheckBox

        checkbox.set "checked", true

        assertThat checkbox.dummy.hasClass "checked"

    test "CheckBox should hide its target on creation", ->
        target = $("<input type='checkbox' checked></input>")

        checkbox = new CheckBox target[0]

        assertThat target.attr("style"), contains "display: none"

    test "Clicking on a CheckBox should toggle its checked state", ->

        checkbox = new CheckBox

        assertThat checkbox.get("checked"), equalTo false

        checkbox.click()

        assertThat checkbox.get("checked"), equalTo true

        checkbox.click()

        assertThat checkbox.get("checked"), equalTo false

    test "Clicking on a CheckBox shouldn't toggle its checked
          state when readonly", ->

        checkbox = new CheckBox
        checkbox.set "readonly", true

        assertThat checkbox.get("checked"), equalTo false

        checkbox.click()

        assertThat checkbox.get("checked"), equalTo false

    test "Clicking on a CheckBox shouldn't toggle its checked
          state when disabled", ->

        checkbox = new CheckBox
        checkbox.set "disabled", true

        assertThat checkbox.get("checked"), equalTo false

        checkbox.click()

        assertThat checkbox.get("checked"), equalTo false

    test "Clicking on a CheckBox should grab the focus", ->

        focusReveiced = false

        class MockCheckBox extends CheckBox
            focus:(e)->
                focusReveiced = true

        checkbox = new MockCheckBox

        checkbox.click()

        assertThat focusReveiced

    test "Using enter should toggle the checkbox's checked state", ->

        checkbox = new CheckBox

        checkbox.grabFocus()

        checkbox.keyup
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat checkbox.get "checked"

    test "Using space should toggle the checkbox's checked state", ->

        checkbox = new CheckBox

        checkbox.grabFocus()

        checkbox.keyup
            keyCode:keys.space
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat checkbox.get "checked"

    test "Using enter shouldn't toggle the checkbox's checked
          state when readonly", ->

        checkbox = new CheckBox

        checkbox.set "readonly", true

        checkbox.grabFocus()

        checkbox.keyup
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat not checkbox.get "checked"

    test "Using space shouldn't toggle the checkbox's checked
          state when readonly", ->

        checkbox = new CheckBox

        checkbox.set "readonly", true

        checkbox.grabFocus()

        checkbox.keyup
            keyCode:keys.space
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat not checkbox.get "checked"

    test "CheckBox reset should operate on the checked state", ->

        checkbox = new CheckBox

        checkbox.set "checked", true

        checkbox.reset()

        assertThat not checkbox.get "checked"

    test "CheckBox should modify the value state synchronously with checked", ->

        checkbox = new CheckBox
        checkbox.set "checked", true

        assertThat checkbox.get("value"), equalTo true

    test "CheckBox should allow to specify a tuple of possible values", ->

        checkbox = new CheckBox

        checkbox.set "values", [ "on", "off" ]
        assertThat checkbox.get("value"), equalTo "off"

        checkbox.set "checked", true

        assertThat checkbox.get("value"), equalTo "on"

    test "Modifying the checkbox value should modify the checked state", ->

        checkbox = new CheckBox

        checkbox.set "value", true

        assertThat checkbox.get "checked"

    test "Modifying the checkbox value should modify the checked
          state according to the values property", ->

        checkbox = new CheckBox
        checkbox.set "values", [ "on", "off" ]
        checkbox.set "value", "on"

        assertThat checkbox.get "checked"

    test "CheckBox should dispatch a checkedChanged signal", ->

        checkbox = new CheckBox
        signalCalled = false
        signalOrigin = null
        signalValue = null

        checkbox.checkedChanged.add ( widget, checked )->
            signalCalled = true
            signalOrigin = widget
            signalValue = checked

        checkbox.set "checked", true

        assertThat signalCalled
        assertThat signalOrigin, equalTo checkbox
        assertThat signalValue, equalTo true


    # Some real checkboxes placed at the top of the test runner.
    # It allow to test the widget live in the test runner.

    target = $("<input type='checkbox'></input>")

    checkbox1 = new CheckBox target[0]
    checkbox2 = new CheckBox
    checkbox3 = new CheckBox

    checkbox1.set "checked", true
    checkbox2.set "readonly", true
    checkbox2.set "checked", true
    checkbox3.set "disabled", true

    $("#qunit-header").before $ "<h4>CheckBox</h4>"
    $("#qunit-header").before target
    checkbox1.before "#qunit-header"
    checkbox2.before "#qunit-header"
    checkbox3.before "#qunit-header"
