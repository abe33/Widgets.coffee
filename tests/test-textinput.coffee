$( document ).ready ->

  module "textinput tests"

  test "TextInput should allow a target of type text", ->
    target = $("<input type='text'></input>")[0]

    input = new TextInput target

    assertThat input.target is target


  test "TextInput should allow a target of type password", ->
    target = $("<input type='password'></input>")[0]

    input = new TextInput target

    assertThat input.target is target

  test "A TextInput shouldn't allow a target of with a type different
     than text or password", ->

    target = $("<input type='file'></input>")[0]
    errorRaised = false
    try
      input = new TextInput target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "A TextInput should create a target when not provided
      in the constructor", ->

    input = new TextInput

    assertThat input.target, notNullValue()

  test "A TextInput should have a dummy that contains the target", ->

    input = new TextInput

    assertThat input.dummy.children("input").length, equalTo 1

  opt =
    cls:TextInput
    className:"TextInput"
    focusChildSelector:"input"

  testFocusProvidedByChildMixin opt

  test "Changing the value in the target should update the widget", ->

    signalCalled = false
    signalValue = null

    input = new TextInput
    input.valueChanged.add (w,v)->
      signalCalled = true
      signalValue = v

    input.dummy.children("input").val("hello")
    input.dummy.children("input").change()

    assertThat input.get("value"), equalTo "hello"

  test "TextInput should support the maxlength attribute
      of an input text", ->

    target = $("<input type='text' maxlength='5'></input>")

    input = new TextInput target[0]

    assertThat input.get("maxlength"), equalTo 5

    input.set "maxlength", 10

    assertThat input.get("maxlength"), equalTo 10
    assertThat target.attr("maxlength"), equalTo 10

    input.set "maxlength", null

    assertThat target.attr("maxlength"), equalTo undefined

  test "TextInput should know when its content had changed
      and the change events isn't triggered already", ->

    input = new TextInput

    input.dummy.children("input").trigger "input"

    assertThat input.valueIsObsolete


  input1 = new TextInput
  input2 = new TextInput
  input3 = new TextInput

  input1.set "value", "Hello"
  input2.set "value", "Readonly"
  input3.set "value", "Disabled"

  input1.dummyClass = input1.dummyClass + " a"
  input2.dummyClass = input2.dummyClass + " b"
  input3.dummyClass = input3.dummyClass + " c"

  input1.updateStates()
  input2.set "readonly", true
  input3.set "disabled", true

  $("#qunit-header").before $ "<h4>TextInput</h4>"
  input1.before "#qunit-header"
  input2.before "#qunit-header"
  input3.before "#qunit-header"
