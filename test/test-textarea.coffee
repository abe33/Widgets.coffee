$( document ).ready ->

  module "textareas tests"

  test "A TextArea should allow an textarea as target", ->
    target = $("<textarea></textarea>")[0]

    area = new TextArea target

    assertThat area.target is target

  test "A TextArea shouldn't allow any other node as target", ->

    target = $("<input type='text'></input>")[0]
    errorRaised = false

    try
      area = new TextArea target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "A TextArea should create its own target if not provided", ->

    area = new TextArea

    assertThat area.target, notNullValue()
    assertThat area.target.nodeName.toLowerCase(), equalTo "textarea"

  test "The TextArea target should be added as a child of the dummy", ->

    area = new TextArea

    assertThat area.dummy.find("textarea").length, equalTo 1

  test "Changing the value in the target should update the widget", ->

    signalCalled = false
    signalValue = null

    textarea = new TextArea
    textarea.valueChanged.add (w,v)->
      signalCalled = true
      signalValue = v

    textarea.dummy.children("textarea").val("hello")
    textarea.dummy.children("textarea").change()

    assertThat textarea.get("value"), equalTo "hello"

  test "TextArea should know when its content had changed
      and the change events isn't triggered already", ->

    area = new TextArea

    area.dummy.children("textarea").trigger "input"

    assertThat area.valueIsObsolete

  opt =
    cls: TextArea
    className: "TextArea"
    focusChildSelector: "textarea"

  testFocusProvidedByChildMixin opt



  area1 = new TextArea
  area2 = new TextArea
  area3 = new TextArea

  area1.set "value", "Hello World"
  area2.set "value", "Readonly"
  area3.set "value", "Disabled"

  area2.set "readonly", true
  area3.set "disabled", true

  $("#qunit-header").before $ "<h4>TextArea</h4>"
  area1.before "#qunit-header"
  area2.before "#qunit-header"
  area3.before "#qunit-header"
