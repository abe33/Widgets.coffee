module "core tests"

test "The widget's plugin should be available through the $ object", ->

    assertThat $.widgetPlugin, notNullValue()

test "The widget's plugin should provide a way to register custom widgets handlers", ->

    plugin = $.widgetPlugin
    id = "irrelevant id"
    elementMatch = "irrelevant match"
    elementProcessor = ->

    plugin.register id, elementMatch, elementProcessor

    assertThat plugin.isRegistered id

test "When the widget's plugin function is executed, the processor registered with an element in a set should be triggered", ->

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

    plugin.register id, elementMatch, elementProcessor

    target = $("<span>")
    target.widgets()

    assertThat processorCalled
    assertThat processorScope is plugin
    assertThat processorTarget is target[0]

test "Widget's plugin processors should also be able to use a function as element match", ->

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

    plugin.register id, elementMatch, elementProcessor

    target = $("<span>")
    target.widgets()

    assertThat processorCalled
    assertThat processorScope is plugin
    assertThat processorTarget is target[0]

test "When a processor returns a widget, the plugin should place it in the element parent", ->

    class MockWidget extends Widget
        createDummy:->
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

test "The widget plugin should prevent to register an invalid processor", ->
    
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

test "The widget plugin should provide a shortcut for widget that doesn't require extra setup", ->
    
    class MockWidget extends Widget
        createDummy:->
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

test "When processed, an element should be flagged with a specific class", ->

    class MockWidget extends Widget
        createDummy:->
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
        createDummy:->
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

module "core processors tests"

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

    assertThat target.children(".colorpicker").length, equalTo 1

test "Input with type file should be replaced by a FilePicker", ->

    target = $("<p><input type='file'></input></p>")

    target.children().widgets()

    assertThat target.children(".filepicker").length, equalTo 1

test "Input with type radio should be replaced by a Radio", ->

    target = $("<p><input type='radio'></input></p>")

    target.children().widgets()

    assertThat target.children(".radio").length, equalTo 1

test "Many inputs with type radio and the same name should be handled by a RadioGroup", ->

    plugin = $.widgetPlugin

    target = $ "<p>
                    <input type='radio' name='foo'></input>
                    <input type='radio' name='foo'></input>
                </p>" 

    target.children().widgets()

    assertThat plugin.radiogroups[ "foo" ], allOf notNullValue(), hasProperty "radios", arrayWithLength 2

test "textarea nodes should be replaced by a TextArea", ->

    target = $("<p><textarea></textarea></p>")

    target.children().widgets()

    assertThat target.children(".textarea").length, equalTo 1

test "select nodes should be replaced by a SingleSelect", ->

    target = $("<p><select></select></p>")

    target.children().widgets()

    assertThat target.children(".single-select").length, equalTo 1