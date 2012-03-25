$( document ).ready ->

  module "jquery tests"

  test "The widget's plugin should be available through the $ object", ->

    assertThat $.widgetPlugin, notNullValue()

  test "The widget's plugin should provide a way to register
      custom widgets handlers", ->

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "irrelevant match"
    elementProcessor = ->

    plugin.register id, elementMatch, elementProcessor

    assertThat plugin.isRegistered id

  test "When the widget's plugin function is executed,
      the processor registered with an element
      in a set should be triggered", ->

    processorCalled = false
    processorScope = null
    processorTarget = null

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"

    elementProcessor = ( target )->
      processorCalled = true
      processorScope = this
      processorTarget = target
      null

    plugin.register id, elementMatch, elementProcessor

    target = $("<span>")
    target.widgets()

    assertThat processorCalled
    assertThat processorScope is plugin
    assertThat processorTarget is target[0]

  test "Widget's plugin processors should also be able
      to use a function as element match", ->

    processorCalled = false
    processorScope = null
    processorTarget = null

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = ( o )->
      o.nodeName.toLowerCase() is "span"

    elementProcessor = ( target )->
      processorCalled = true
      processorScope = this
      processorTarget = target
      null

    plugin.register id, elementMatch, elementProcessor

    target = $("<span>")
    target.widgets()

    assertThat processorCalled
    assertThat processorScope is plugin
    assertThat processorTarget is target[0]

  test "When a processor returns a widget, the plugin should
      place it in the element parent", ->

    class MockWidget extends Widget
      createDummy: ->
        $ "<div></div>"

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"
    elementProcessor = (o)->
      new MockWidget

    plugin.register id, elementMatch, elementProcessor

    target = $("<p><span></span></p>")

    target.children().widgets()

    assertThat target.children("div").length, equalTo 1

  test "The widget plugin should prevent to register
      an invalid processor", ->

    errorRaised = false
    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"
    elementProcessor = null

    try
      plugin.register id, elementMatch, elementProcessor
    catch e
      errorRaised = true

    assertThat errorRaised

  test "The widget plugin should provide a shortcut for widget
      that doesn't require extra setup", ->

    class MockWidget extends Widget
      createDummy: ->
        $ "<div></div>"

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"

    plugin.registerWidgetFor id, elementMatch, MockWidget

    target = $("<p><span></span></p>")

    target.children().widgets()

    assertThat target.children("div").length, equalTo 1

  test "The widget plugin should prevent to register an invalid widget", ->

    errorRaised = false
    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"

    try
      plugin.registerWidgetFor id, elementMatch, null
    catch e
      errorRaised = true

    assertThat errorRaised

  test "When processed, an element should be flagged with a specific
      class", ->

    class MockWidget extends Widget
      createDummy: ->
        $ "<div></div>"

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"

    plugin.registerWidgetFor id, elementMatch, MockWidget

    target = $("<p><span></span></p>")

    target.children().widgets()

    assertThat target.children("span").hasClass "widget-done"

  test "The plugin process should prevent to process twice an element", ->

    class MockWidget extends Widget
      createDummy: ->
        $ "<div></div>"

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "span"

    plugin.registerWidgetFor id, elementMatch, MockWidget

    target = $("<p><span></span></p>")

    target.children().widgets()
    target.children().widgets()

    assertThat target.children("div").length, equalTo 1

    $("body").append target

  module "jquery processors tests"

  test "Input with type text should be replaced by a TextInput", ->

    target = $("<p><input type='text'></input></p>")

    target.children().widgets()

    assertThat target.children(".text").length, equalTo 1

  test "Input with type password should be replaced by a TextInput", ->

    target = $("<p><input type='password'></input></p>")

    target.children().widgets()

    assertThat target.children(".text").length, equalTo 1

  test "Input with type button should be replaced by a Button", ->

    target = $("<p><input type='button'></input></p>")

    target.children().widgets()

    assertThat target.children(".button").length, equalTo 1

  test "Input with type reset should be replaced by a Button", ->

    target = $("<p><input type='reset'></input></p>")

    target.children().widgets()

    assertThat target.children(".button").length, equalTo 1

  test "Input with type submit should be replaced by a Button", ->

    target = $("<p><input type='submit'></input></p>")

    target.children().widgets()

    assertThat target.children(".button").length, equalTo 1

  test "Input with type range should be replaced by a Slider", ->

    target = $("<p><input type='range'></input></p>")

    target.children().widgets()

    assertThat target.children(".slider").length, equalTo 1

  test "Input with type number should be replaced by a Stepper", ->

    target = $("<p><input type='number'></input></p>")

    target.children().widgets()

    assertThat target.children(".stepper").length, equalTo 1

  test "Input with type checkbox should be replaced by a CheckBox", ->

    target = $("<p><input type='checkbox'></input></p>")

    target.children().widgets()

    assertThat target.children(".checkbox").length, equalTo 1

  test "Input with type color should be replaced by a ColorInput", ->

    target = $("<p><input type='color'></input></p>")

    target.children().widgets()

    assertThat target.children(".colorinput").length, equalTo 1

  test "Input with type file should be replaced by a FilePicker", ->

    target = $("<p><input type='file'></input></p>")

    target.children().widgets()

    assertThat target.children(".filepicker").length, equalTo 1

  test "Input with type radio should be replaced by a Radio", ->

    target = $("<p><input type='radio'></input></p>")

    target.children().widgets()

    assertThat target.children(".radio").length, equalTo 1

  test "Input with type time should be replaced by a TimeInput", ->

    target = $("<p><input type='time'></input></p>")

    target.children().widgets()

    assertThat target.find(".time").length, equalTo 1

  test "Input with type date should be replaced by a DateInput", ->

    target = $("<p><input type='date'></input></p>")

    target.children().widgets()

    assertThat target.find(".date").length, equalTo 1

  test "Input with type month should be replaced by a MonthInput", ->

    target = $("<p><input type='month'></input></p>")

    target.children().widgets()

    assertThat target.find(".month").length, equalTo 1

  test "Input with type week should be replaced by a WeekInput", ->

    target = $("<p><input type='week'></input></p>")

    target.children().widgets()

    assertThat target.find(".week").length, equalTo 1

  test "Input with type datetime should be replaced by a DateTimeInput", ->

    target = $("<p><input type='datetime'></input></p>")

    target.children().widgets()

    assertThat target.find(".datetime").length, equalTo 1

  test "Input with type datetime-local should be replaced
        by a DateTimeLocalInput", ->

    target = $("<p><input type='datetime-local'></input></p>")

    target.children().widgets()

    assertThat target.find(".datetime-local").length, equalTo 1


  test "Many inputs with type radio and the same name should
      be handled by a RadioGroup", ->

    plugin = $.widgetPlugin

    target = $ "<p>
            <input type='radio' name='foo'></input>
            <input type='radio' name='foo'></input>
          </p>"

    target.children().widgets()

    assertThat plugin.radiogroups[ "foo" ],
           allOf notNullValue(),
             hasProperty "radios",
                    arrayWithLength 2

  test "textarea nodes should be replaced by a TextArea", ->

    target = $("<p><textarea></textarea></p>")

    target.children().widgets()

    assertThat target.children(".textarea").length, equalTo 1

  test "select nodes should be replaced by a SingleSelect", ->

    target = $("<p><select></select></p>")

    target.children().widgets()

    assertThat target.children(".single-select").length, equalTo 1

  test "When a child is a form, the plugin should create a specific
     object and process its form elements children", ->

    target = $("<form method='post' action='/action'>
            <input type='text'></input>
            <input type='submit'></input>
            <input type='reset'></input>
          </form>")

    target.widgets()

    assertThat target.find(".text").length, equalTo 1
    assertThat target.find(".button").length, equalTo 2
    assertThat $.widgetPlugin.forms.length, equalTo 1

    formObject = $.widgetPlugin.forms[0]

    assertThat formObject.method is "post"
    assertThat formObject.action is "/action"
    assertThat formObject.widgets.length, equalTo 3

    assertThat formObject.widgets[0] instanceof TextInput
    assertThat formObject.widgets[1] instanceof Button
    assertThat formObject.widgets[2] instanceof Button

    assertThat formObject.submitButtons.length, equalTo 1
    assertThat formObject.submitButtons[0] is formObject.widgets[1]
    assertThat formObject.resetButtons.length, equalTo 1
    assertThat formObject.resetButtons[0] is formObject.widgets[2]

    delete $.widgetPlugin.forms

  test "Forms with a reset button, when clicked, should call reset
      on all the value widgets", ->

    assertThatValueNotChanged=(w,v)->
      assertThat w.get("value"), equalTo v
      assertThat w.jTarget.attr("value"), equalTo v

    target = $("<form method='post' action='/action'>
            <input type='text' value='foo'></input>
            <input type='number' value='0'></input>
            <input type='range' value='50'></input>
            <input type='color' value='#112233'></input>
            <input type='date' value='2012-05-24'></input>
            <input type='time' value='16:45:00'></input>
            <input type='month' value='2012-05'></input>
            <input type='week' value='2016-W05'></input>
            <textarea>value</textarea>
            <select>
              <option selected>foo</option>
              <option>bar</option>
              <option>rab</option>
            </select>
            <input type='reset'></input>
          </form>")

    target.widgets()
    formObject = $.widgetPlugin.forms[0]

    [   text,   number, range,
      color,  date,   time,
      month,  week,   textarea,
      select, reset
    ] = formObject.widgets

    text.set     "value", "bar"
    number.set   "value", 12
    range.set    "value", 12
    color.set    "value", "#445566"
    date.set     "value", "2007-11-05"
    time.set     "value", "16:04:45"
    month.set    "value", "2017-12"
    week.set     "value", "2014-W25"
    textarea.set "value", "textarea"
    select.set   "value", "bar"

    reset.dummy.click()

    assertThatValueNotChanged text,     "foo"
    assertThatValueNotChanged number,   0
    assertThatValueNotChanged range,    50
    assertThatValueNotChanged color,    "#112233"
    assertThatValueNotChanged date,     "2012-05-24"
    assertThatValueNotChanged time,     "16:45:00"
    assertThatValueNotChanged month,    "2012-05"
    assertThatValueNotChanged week,     "2016-W05"
    assertThatValueNotChanged textarea, "value"
    assertThatValueNotChanged select,   "foo"

    delete $.widgetPlugin.forms


