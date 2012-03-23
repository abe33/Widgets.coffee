$( document ).ready ->

  module "radio tests"

  test "Radio should allow input with a radio type",->
    target = $("<input type='radio'></input>")[0]

    radio = new Radio target

    assertThat radio.target is target


  test "Radio should allow only input with a radio type",->
    target = $("<input type='text'></input>")[0]
    errorRaised = false

    try
      radio = new Radio target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "Radio should reflect the checked state of the input", ->
    target = $("<input type='radio' checked></input>")[0]

    radio = new Radio target

    assertThat radio.get "checked"

  test "Radio should apply change made to the checked property
      on the target", ->
    target = $("<input type='radio' checked></input>")[0]

    radio = new Radio target

    radio.set "checked", false

    assertThat radio.get("checked"), equalTo false

  test "Radio should be created without a target", ->

    errorRaised = false

    try
      radio = new Radio
    catch e
      errorRaised = true

    assertThat not errorRaised

  test "Radio should provide a dummy", ->

    radio = new Radio

    assertThat radio.dummy, notNullValue()

  test "Radio should handle the checked property as a state", ->

    radio = new Radio

    radio.set "checked", true

    assertThat radio.dummy.hasClass "checked"

  test "Radio should hide its target on creation", ->
    target = $("<input type='radio' checked></input>")

    radio = new Radio target[0]

    assertThat target.attr("style"), contains "display: none"

  test "Clicking on a Radio should toggle its checked state", ->

    radio = new Radio

    assertThat radio.get("checked"), equalTo false

    radio.click()

    assertThat radio.get("checked"), equalTo true


  test "Clicking on a Radio several time should never toggle checked
      back to false", ->

    radio = new Radio

    assertThat radio.get("checked"), equalTo false

    radio.click()

    assertThat radio.get("checked"), equalTo true

    radio.click()

    assertThat radio.get("checked"), equalTo true

  test "Clicking on a Radio shouldn't toggle its checked state
      when readonly", ->

    radio = new Radio
    radio.set "readonly", true

    assertThat radio.get("checked"), equalTo false

    radio.click()

    assertThat radio.get("checked"), equalTo false

  test "Clicking on a Radio shouldn't toggle its checked state
      when disabled", ->

    radio = new Radio
    radio.set "disabled", true

    assertThat radio.get("checked"), equalTo false

    radio.click()

    assertThat radio.get("checked"), equalTo false

  test "Clicking on a Radio should grab the focus", ->

    focusReveiced = false

    class MockRadio extends Radio
      focus: (e)->
        focusReveiced = true

    radio = new MockRadio

    radio.click()

    assertThat focusReveiced

  test "Using enter should toggle the radio's checked state", ->

    radio = new Radio

    radio.grabFocus()

    radio.keyup
      keyCode: keys.enter
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat radio.get "checked"

  test "Using space should toggle the radio's checked state", ->

    radio = new Radio

    radio.grabFocus()

    radio.keyup
      keyCode: keys.space
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat radio.get "checked"

  test "Using enter shouldn't toggle the radio's checked state
      when readonly", ->

    radio = new Radio

    radio.set "readonly", true

    radio.grabFocus()

    radio.keyup
      keyCode: keys.enter
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat not radio.get "checked"

  test "Using space shouldn't toggle the radio's checked state
      when readonly", ->

    radio = new Radio

    radio.set "readonly", true

    radio.grabFocus()

    radio.keyup
      keyCode: keys.space
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat not radio.get "checked"

  test "Radio reset should operate on the checked state", ->

    radio = new Radio

    radio.set "checked", true

    radio.reset()

    assertThat not radio.get "checked"

  test "Radio should modify the value state synchronously with checked", ->

    radio = new Radio
    radio.set "checked", true

    assertThat radio.get("value"), equalTo true

  test "Radio should allow to specify a tuple of possible values", ->

    radio = new Radio

    radio.set "values", [ "on", "off" ]
    assertThat radio.get("value"), equalTo "off"

    radio.set "checked", true

    assertThat radio.get("value"), equalTo "on"

  test "Modifying the radio value should modify the checked state", ->

    radio = new Radio

    radio.set "value", true

    assertThat radio.get "checked"

  test "Modifying the radio value should modify the checked
      state according to the values property", ->

    radio = new Radio
    radio.set "values", [ "on", "off" ]
    radio.set "value", "on"

    assertThat radio.get "checked"

  test "Radio should dispatch a checkedChanged signal", ->

    radio = new Radio
    signalCalled = false
    signalOrigin = null
    signalValue = null

    radio.checkedChanged.add ( widget, checked )->
      signalCalled = true
      signalOrigin = widget
      signalValue = checked

    radio.set "checked", true

    assertThat signalCalled
    assertThat signalOrigin, equalTo radio
    assertThat signalValue, equalTo true


  # Some real radios placed at the top of the test runner.
  # It allow to test the widget live in the test runner.

  target = $("<input type='radio'></input>")

  radio1 = new Radio target[0]
  radio2 = new Radio
  radio3 = new Radio

  radio2.set "readonly", true
  radio2.set "checked", true
  radio3.set "disabled", true

  $("#qunit-header").before $ "<h4>Radio</h4>"
  $("#qunit-header").before target
  radio1.before "#qunit-header"
  radio2.before "#qunit-header"
  radio3.before "#qunit-header"
