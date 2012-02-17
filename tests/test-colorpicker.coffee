$( document ).ready ->

    module "colorinput tests"

    test "A color input should accept a target input with type color", ->

        target = $("<input type='color'></input>")[0]
        input = new ColorInput target

        assertThat input.target is target

    test "A color input should hide its target", ->

        target = $("<input type='color'></input>")[0]
        input = new ColorInput target

        assertThat input.jTarget.attr("style"), contains "display: none"

    test "A color input shouldn't accept a target input with
          a type different than color", ->

        target = $("<input type='text'></input>")[0]
        errorRaised = false

        try
            input = new ColorInput target
        catch e
            errorRaised = true

        assertThat errorRaised

    test "A color input should retreive the color from its target", ->

        target = $("<input type='color' value='#ff0000'></input>")[0]
        input = new ColorInput target

        assertThat input.get("value"), equalTo "#ff0000"

    test "A color input should have a default color even without target", ->

        input = new ColorInput

        assertThat input.get("value"), equalTo "#000000"

    test "A color input should provide a color property
          that provide a more code friendly color object", ->

        input = new ColorInput

        color = input.get("color")

        assertThat color, allOf notNullValue(), hasProperties
            red:0
            green:0
            blue:0

    test "A color input color should reflect the initial value", ->

        target = $("<input type='color' value='#abcdef'></input>")[0]
        input = new ColorInput target

        color = input.get("color")

        assertThat color, allOf notNullValue(), hasProperties
            red:0xab
            green:0xcd
            blue:0xef

    test "A color input should update the value when the color is changed", ->

        input = new ColorInput

        input.set "color",
            red:0xab
            green:0xcd
            blue:0xef

        assertThat input.get("value"), equalTo "#abcdef"

    test "A color input should preserve the length of the value
          even with black", ->

        input = new ColorInput

        input.set "color",
            red:0
            green:0
            blue:0

        assertThat input.get("value"), equalTo "#000000"

    test "A color input should update its color property when
          the value is changed", ->

        input = new ColorInput

        input.set "value", "#abcdef"
        color = input.get("color")

        assertThat color, allOf notNullValue(), hasProperties
            red:0xab
            green:0xcd
            blue:0xef

    test "A color input should prevent invalid values
          to alter its properties", ->

        target = $("<input type='color' value='#foobar'></input>")[0]

        input = new ColorInput target
        input.set "value", "foo"
        input.set "value", "#ghijkl"
        input.set "value", "#abc"
        input.set "value", undefined

        assertThat input.get("value"), equalTo "#000000"
        assertThat input.get("color"), hasProperties
            red:0
            green:0
            blue:0

    test "A color input should prevent invalid color to alter
          its properties", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        input.set "color", null

        input.set "color",
            red:NaN,
            green:0,
            blue:0

        input.set "color",
            red:0,
            green:-1,
            blue:0

        input.set "color",
            red:0,
            green:0,
            blue:"foo"

        input.set "color",
            red:0,
            green:0,
            blue:300

        assertThat input.get("value"), equalTo "#abcdef"
        assertThat input.get("color"), hasProperties
            red:0xab
            green:0xcd
            blue:0xef

    test "A color input should provide a dummy", ->

        input = new ColorInput

        assertThat input.dummy, notNullValue()

    test "The color span of a color input should have its background
          filled with the widget's value", ->
        target = $("<input type='color' value='#abcdef'></input>")[0]

        input = new ColorInput target

        assertThat input.dummy.children(".color").attr("style"),
                   contains "background: #abcdef"

    test "The color span of a color input should have its background
          filled with the widget's value even after a change", ->
        input = new ColorInput

        input.set "value", "#abcdef"

        assertThat input.dummy.children(".color").attr("style"),
                   contains "background: #abcdef"

    test "Clicking on a color input should trigger
          a dialogRequested signal", ->

        signalCalled = false
        signalSource = null

        input = new ColorInput

        input.dialogRequested.add ( widget )->
            signalCalled = true
            signalSource = widget

        input.dummy.click()

        assertThat signalCalled
        assertThat signalSource is input

    test "The color child text should be the value hexadecimal code", ->

        input = new ColorInput

        assertThat input.dummy.children(".color").text(), equalTo "#000000"

    test "The color child text color should be defined according
          the luminosity of the color", ->

        input = new ColorInput

        assertThat input.dummy.children(".color").attr("style"),
                   contains "color: #ffffff"

        input.set "value", "#ffffff"

        assertThat input.dummy.children(".color").attr("style"),
                   contains "color: #000000"

    test "The ColorWidget's class should have a default listener
          defined for the dialogRequested signal of its instance", ->

        assertThat ColorInput.defaultListener instanceof ColorPicker

    test "Disabled ColorInput should trigger the dialogRequested on click", ->

        signalCalled = false
        input = new ColorInput

        input.dialogRequested.add ->
            signalCalled = true

        input.set "disabled", true

        input.dummy.click()

        assertThat not signalCalled

    test "Readonly ColorInput should trigger the dialogRequested on click", ->

        signalCalled = false
        input = new ColorInput

        input.dialogRequested.add ->
            signalCalled = true

        input.set "readonly", true

        input.dummy.click()

        assertThat not signalCalled

    test "Pressing Enter should dispatch the dialogRequested signal", ->

        signalCalled = false
        input = new ColorInput

        input.dialogRequested.add ->
            signalCalled = true

        input.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat signalCalled

    test "Pressing Space should dispatch the dialogRequested signal", ->

        signalCalled = false
        input = new ColorInput

        input.dialogRequested.add ->
            signalCalled = true

        input.keydown
            keyCode:keys.space
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat signalCalled

    # Some live instances

    input1 = new ColorInput
    input2 = new ColorInput
    input3 = new ColorInput

    input1.set "value", "#cbdc1b"
    input2.set "value", "#66ff99"
    input3.set "value", "#6699ff"

    input2.set "readonly", true
    input3.set "disabled", true

    $("#qunit-header").before $ "<h4>ColorInput</h4>"
    input1.before "#qunit-header"
    input2.before "#qunit-header"
    input3.before "#qunit-header"


    # SquarePicker
    module "squareinput tests"

    test "A SquarePicker should provides two ranges of values
          for its x and y axis", ->

        grid = new SquarePicker

        grid.set
            rangeX:[ 0, 100 ]
            rangeY:[ 0, 100 ]

        assertThat grid.get("rangeX"), array 0, 100
        assertThat grid.get("rangeY"), array 0, 100

    test "The SquarePicker's value should be a tuple of values
          in the x and y range", ->

        grid = new SquarePicker

        assertThat grid.get("value"), array 0, 0

    test "The SquarePicker should prevent any attempt
          to set invalid values", ->

        grid = new SquarePicker

        grid.set
            rangeX:[ 0, 100 ]
            rangeY:[ 0, 100 ]

        grid.set value:[ 50, 65 ]

        grid.set value:[ 120, 0 ]
        grid.set value:[ 0, 120 ]
        grid.set value:[ 0, "foo" ]
        grid.set value:[ "foo", 0 ]
        grid.set value:[ null, 0 ]
        grid.set value:[ 0, null ]
        grid.set value:"foo"
        grid.set value:null

        assertThat grid.get("value"), array 50, 65

    test "Changing the ranges midway should alter the values", ->

        grid = new SquarePicker
        grid.set
            rangeX:[ 0, 100 ]
            rangeY:[ 0, 100 ]

        grid.set value:[ 50, 65 ]

        grid.set
            rangeX:[ 0, 10 ]
            rangeY:[ 0, 10 ]

        assertThat grid.get("value"), array 10, 10

    test "A SquarePicker should prevent all attempt
          to set an invalid range", ->

        grid = new SquarePicker
        grid.set
            rangeX:[ 0, 100 ]
            rangeY:[ 0, 100 ]

        grid.set
            rangeX:[100,0]
            rangeY:[100,0]

        grid.set
            rangeX:["foo", 0]
            rangeY:["foo", 0]

        grid.set
            rangeX:[0,"foo"]
            rangeY:[0,"foo"]

        grid.set
            rangeX:[null,0]
            rangeY:[null,0]

        grid.set
            rangeX:[0,null]
            rangeY:[0,null]

        grid.set
            rangeX:"foo"
            rangeY:"foo"

        grid.set
            rangeX:null
            rangeY:null

        assertThat grid.get("rangeX"), array 0, 100
        assertThat grid.get("rangeY"), array 0, 100

    test "SquarePicker should provide a dummy", ->

        grid = new SquarePicker

        assertThat grid.dummy, notNullValue()

    test "Given a specific size, pressing the mouse inside
          a grid should change the value according
          to the x and y ranges",->

        class MockSquarePicker extends SquarePicker
            mousedown:(e)->
                e.pageX = 45
                e.pageY = 65
                super e

        grid = new MockSquarePicker

        grid.dummy.attr "style", "width:100px; height:100px"

        grid.set
            rangeX:[ 0, 10 ]
            rangeY:[ 0, 10 ]

        grid.dummy.mousedown()

        assertThat grid.get("value"), array 4.5, 6.5

    test "A SquarePicker should allow to drag the mouse
          to change the value", ->

        class MockSquarePicker extends SquarePicker
            mousedown:(e)->
                e.pageX = 45
                e.pageY = 65
                super e

            mousemove:(e)->
                e.pageX = 47
                e.pageY = 67
                super e

            mouseup:(e)->
                e.pageX = 49
                e.pageY = 69
                super e

        grid = new MockSquarePicker

        grid.dummy.attr "style", "width:100px; height:100px"

        grid.set
            rangeX:[ 0, 10 ]
            rangeY:[ 0, 10 ]

        grid.dummy.mousedown()
        assertThat grid.get("value"), array closeTo( 4.5, 0.1 ),
                                            closeTo( 6.5, 0.1 )

        grid.dummy.mousemove()
        assertThat grid.get("value"), array closeTo( 4.7, 0.1 ),
                                            closeTo( 6.7, 0.1 )

        grid.dummy.mouseup()
        assertThat grid.get("value"), array closeTo( 4.9, 0.1 ),
                                            closeTo( 6.9, 0.1 )

    test "Dragging the mouse outside of the SquarePicker on the bottom
          right should set the values on the max", ->

        class MockSquarePicker extends SquarePicker
            mouseup:(e)->
                e.pageX = 110
                e.pageY = 110
                super e

        grid = new MockSquarePicker

        grid.dummy.attr "style", "width:100px; height:100px"

        grid.set
            rangeX:[ 0, 10 ]
            rangeY:[ 0, 10 ]

        grid.dummy.mousedown()
        grid.dummy.mouseup()
        assertThat grid.get("value"), array closeTo( 10, 0.1 ),
                                            closeTo( 10, 0.1 )

    test "Dragging the mouse outside of the SquarePicker
          on the top left should set the values on the min", ->

        class MockSquarePicker extends SquarePicker
            mouseup:(e)->
                e.pageX = -10
                e.pageY = -10
                super e

        grid = new MockSquarePicker

        grid.dummy.attr "style", "width:100px; height:100px"

        grid.set
            rangeX:[ 0, 10 ]
            rangeY:[ 0, 10 ]

        grid.dummy.mousedown()
        grid.dummy.mouseup()
        assertThat grid.get("value"), array closeTo( 0, 0.1 ),
                                            closeTo( 0, 0.1 )



    test "A disabled SquarePicker should prevent dragging to occurs", ->

        grid = new SquarePicker
        grid.set "disabled", true

        grid.dummy.mousedown()

        assertThat not grid.dragging

    test "A readonly SquarePicker should prevent dragging to occurs", ->

        grid = new SquarePicker
        grid.set "disabled", true

        grid.dummy.mousedown()

        assertThat not grid.dragging

    test "Starting a drag should return false", ->
        result = true

        class MockSquarePicker extends SquarePicker
            mousedown:(e)->
                result = super e

        grid = new MockSquarePicker

        grid.dummy.mousedown()

        assertThat not result

    test "A SquarePicker should have a cursor that display
          the selected position", ->

        grid = new SquarePicker
        grid.dummy.attr "style", "width:100px; height:100px"
        grid.dummy.children(".cursor").attr "style", "width:10px; height:10px"

        grid.set "value", [ 0.45, 0.55 ]

        assertThat grid.dummy.children(".cursor").attr("style"),
                   contains "left: 40px"
        assertThat grid.dummy.children(".cursor").attr("style"),
                   contains "top: 50px"

    test "When dragging, releasing the mouse outside of the widget
          should stop the drag", ->

        grid = new SquarePicker
        grid.dummy.mousedown()

        $(document).mouseup()

        assertThat not grid.dragging

    test "Clicking on a SquarePicker should give the focus
          to the widget", ->

        grid = new SquarePicker
        grid.dummy.mousedown()

        assertThat grid.hasFocus

    test "Clicking on a disabled SquarePicker shouldn't give the
          focus to the widget", ->

        grid = new SquarePicker
        grid.set "disabled", true
        grid.dummy.mousedown()

        assertThat not grid.hasFocus

    test "A SquarePicker should allow to lock the X axis", ->

        grid = new SquarePicker

        grid.lockX()

        grid.set "value", [1,0]

        assertThat grid.get("value"), array 0, 0

    test "A SquarePicker should allow to lock the Y axis", ->

        grid = new SquarePicker

        grid.lockY()

        grid.set "value", [0,1]

        assertThat grid.get("value"), array 0, 0

    test "A SquarePicker should allow to unlock the X axis", ->

        grid = new SquarePicker

        grid.lockX()
        grid.unlockX()

        grid.set "value", [1,0]

        assertThat grid.get("value"), array 1, 0

    test "A SquarePicker should allow to unlock the Y axis", ->

        grid = new SquarePicker

        grid.lockY()
        grid.unlockY()

        grid.set "value", [0,1]

        assertThat grid.get("value"), array 0, 1

    sinput1 = new SquarePicker
    sinput2 = new SquarePicker
    sinput3 = new SquarePicker
    sinput4 = new SquarePicker

    sinput1.set "value", [.2,.5]
    sinput2.set "value", [0, .6]
    sinput3.set "value", [.7,.2]
    sinput4.set "value", [.8,0 ]

    sinput2.lockX()
    sinput2.dummyClass = sinput2.dummyClass + " vertical"
    sinput2.updateStates()

    sinput4.dummyClass = sinput4.dummyClass + " horizontal"
    sinput4.updateStates()

    sinput3.set "readonly", true
    sinput4.set "disabled", true

    $("#qunit-header").before $ "<h4>SquarePicker</h4>"
    sinput1.before "#qunit-header"
    sinput2.before "#qunit-header"
    sinput3.before "#qunit-header"
    sinput4.before "#qunit-header"




    module "colorinput tests"

    test "A ColorPicker should be hidden at startup", ->

        dialog = new ColorPicker
        assertThat dialog.dummy.attr("style"), contains "display: none"

    test "A ColorPicker should have a listener for the dialogRequested
          signal that setup the dialog", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        assertThat dialog.get( "value" ) is "#abcdef"

    test "A ColorPicker should show itself on a dialog request", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"


    test "A ColorPicker should provides a method to convert
          a rgb color to hsv values", ->

        dialog = new ColorPicker

        hsv = rgb2hsv 10, 100, 200

        assertThat hsv, array closeTo( 212, 2 ),
                              closeTo( 95, 2 ),
                              closeTo( 78, 2 )

    test "A ColorPicker should provides a method to convert
          a hsv color to rgb values", ->

        dialog = new ColorPicker

        rgb = hsv2rgb 212, 95, 78

        assertThat rgb, array closeTo( 10, 2 ),
                              closeTo( 100, 2 ),
                              closeTo( 200, 2 )

    test "A ColorPicker should provides a dummy", ->

        dialog = new ColorPicker

        assertThat dialog.dummy, notNullValue()

    test "A ColorPicker should provides a TextInput for each
          channel of the color", ->

        dialog = new ColorPicker

        assertThat dialog.redInput   instanceof TextInput
        assertThat dialog.greenInput instanceof TextInput
        assertThat dialog.blueInput  instanceof TextInput

    test "The inputs for the color channels should be limited
          to three chars", ->

        dialog = new ColorPicker

        assertThat dialog.redInput.get("maxlength"), equalTo 3
        assertThat dialog.greenInput.get("maxlength"), equalTo 3
        assertThat dialog.blueInput.get("maxlength"), equalTo 3

    test "A ColorPicker should have the channels input
          as child of the dummy", ->

        dialog = new ColorPicker

        assertThat dialog.dummy.children(".red")[0],
                   equalTo dialog.redInput.dummy[0]
        assertThat dialog.dummy.children(".green")[0],
                   equalTo dialog.greenInput.dummy[0]
        assertThat dialog.dummy.children(".blue")[0],
                   equalTo dialog.blueInput.dummy[0]

    test "Setting the value of a ColorPicker should fill
          the channels input", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        assertThat dialog.redInput.get("value"),   equalTo 0xab
        assertThat dialog.greenInput.get("value"), equalTo 0xcd
        assertThat dialog.blueInput.get("value"),  equalTo 0xef

    test "A ColorPicker should provides a TextInput for each
          channel of the hsv color", ->

        dialog = new ColorPicker

        assertThat dialog.hueInput        instanceof TextInput
        assertThat dialog.saturationInput instanceof TextInput
        assertThat dialog.valueInput      instanceof TextInput

    test "The inputs for the hsv channels should be limited to three chars", ->

        dialog = new ColorPicker

        assertThat dialog.hueInput.get("maxlength"), equalTo 3
        assertThat dialog.saturationInput.get("maxlength"), equalTo 3
        assertThat dialog.valueInput.get("maxlength"), equalTo 3

    test "A ColorPicker should have the channels input
          as child of the dummy", ->

        dialog = new ColorPicker

        assertThat dialog.dummy.children(".hue")[0],
                   equalTo dialog.hueInput.dummy[0]
        assertThat dialog.dummy.children(".saturation")[0],
                   equalTo dialog.saturationInput.dummy[0]
        assertThat dialog.dummy.children(".value")[0],
                   equalTo dialog.valueInput.dummy[0]

    test "Setting the value of a ColorPicker should fill
          the channels input", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"
        [ h, s, v ] = rgb2hsv 0xab, 0xcd, 0xef

        assertThat dialog.hueInput.get("value"),        equalTo Math.round h
        assertThat dialog.saturationInput.get("value"), equalTo Math.round s
        assertThat dialog.valueInput.get("value"),      equalTo Math.round v

    test "A ColorPicker should provides a TextInput
          for the hexadecimal color", ->

        dialog = new ColorPicker

        assertThat dialog.hexInput instanceof TextInput

    test "The hexadecimal input should be limited to 6 chars", ->

        dialog = new ColorPicker

        assertThat dialog.hexInput.get("maxlength"), equalTo 6

    test "A ColorPicker should have the hexadecimal input
          as child of the dummy", ->

        dialog = new ColorPicker

        assertThat dialog.dummy.children(".hex")[0],
                   equalTo dialog.hexInput.dummy[0]

    test "Setting the value of a ColorPicker should fill
          the hexadecimal input", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        assertThat dialog.hexInput.get("value"), equalTo "abcdef"

    test "Setting the value of the red input should update
          the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.redInput.set "value", 0xff

        assertThat dialog.get("value"), equalTo "#ff0000"

        dialog.redInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#450000"

    test "Setting an invalid value for the red input shouldn't
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.redInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#000000"

    test "Setting the value of the green input should
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.greenInput.set "value", 0xff

        assertThat dialog.get("value"), equalTo "#00ff00"

        dialog.greenInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#004500"

    test "Setting an invalid value for the green input
          shouldn't update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.greenInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#000000"

    test "Setting the value of the blue input should update
          the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.blueInput.set "value", 0xff

        assertThat dialog.get("value"), equalTo "#0000ff"

        dialog.blueInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#000045"

    test "Setting an invalid value for the blue input shouldn't
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.blueInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#000000"

    test "Setting the value of the hue input should update
          the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#332929"

        dialog.hueInput.set "value", 100

        assertThat dialog.get("value"), equalTo "#2c3329"

        dialog.hueInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#323329"

    test "Setting an invalid value for the hue input shouldn't
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#332929"

        dialog.hueInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#332929"


    test "Setting the value of the saturation input should
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.saturationInput.set "value", 50

        assertThat dialog.get("value"), equalTo "#2e331a"

        dialog.saturationInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#2c3310"

    test "Setting an invalid value for the saturation
          input shouldn't update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.saturationInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#313329"

    test "Setting the value of the value input should
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.valueInput.set "value", 50

        assertThat dialog.get("value"), equalTo "#7b8067"

        dialog.valueInput.set "value", "69"

        assertThat dialog.get("value"), equalTo "#a9b08d"

    test "Setting an invalid value for the value input shouldn't
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.valueInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#313329"

    test "Setting the value of the hex input should update
          the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.hexInput.set "value", "abcdef"

        assertThat dialog.get("value"), equalTo "#abcdef"

        dialog.hexInput.set "value", "012345"

        assertThat dialog.get("value"), equalTo "#012345"

    test "Setting an invalid value for the hex input shouldn't
          update the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#313329"

        dialog.hexInput.set "value", "foo"

        assertThat dialog.get("value"), equalTo "#313329"

    test "The ColorPicker should provides two grid inputs", ->

        dialog = new ColorPicker

        assertThat dialog.squarePicker instanceof SquarePicker
        assertThat dialog.rangePicker instanceof SquarePicker

    test "A ColorPicker should have a default edit mode for color
          manipulation through the SquarePickers", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        assertThat dialog.squarePicker.get("rangeX"), array 0, 100
        assertThat dialog.squarePicker.get("rangeY"), array 0, 100
        assertThat dialog.rangePicker.get("rangeY"), array 0, 360

        assertThat dialog.squarePicker.get("value"), array closeTo(28,1),
                                                           closeTo(100-94,1)
        assertThat dialog.rangePicker.get("value")[1], equalTo 360-210

    test "Clicking outside of the ColorPicker should terminate
          the modification and set the value on the ColorInput", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        class MockColorPicker extends ColorPicker
            mouseup:(e)->
                e.pageX = 1000
                e.pageY = 1000
                super e

        dialog = new MockColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        $( document ).mouseup()

        assertThat input.get("value"), "#ff0000"
        assertThat dialog.dummy.attr("style"), contains "display: none"

    test "Pressing enter on the ColorPicker should terminate
          the modification and set the value on the ColorInput", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#ff0000"
        assertThat dialog.dummy.attr("style"), contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the red input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.redInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the green input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.greenInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the blue input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.blueInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the hue input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.hueInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the saturation input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.saturationInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the value input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.valueInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "Pressing enter on the ColorPicker while there was changes
          made to the hex input shouldn't comfirm the color changes", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.hexInput.input()

        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"),
                   hamcrest.not contains "display: none"

    test "A ColorPicker should be placed next to the colorinput
          a dialog request", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        assertThat dialog.dummy.attr("style"), contains "left: 0px"
        assertThat dialog.dummy.attr("style"),
                   contains "top: " + input.dummy.height() + "px"
        assertThat dialog.dummy.attr("style"), contains "position: absolute"

    test "A ColorPicker should provides two more chidren that will
          be used to present the previous and current color", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        assertThat dialog.dummy.children(".oldColor").attr("style"),
                   contains "background: #abcdef"
        assertThat dialog.dummy.children(".newColor").attr("style"),
                   contains "background: #ff0000"

    test "Clicking on the old color should reset the value
          to the original one", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.dummy.children(".oldColor").click()

        assertThat dialog.get("value"), equalTo "#abcdef"

    test "Pressing escape on the ColorPicker should close the dialog", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        dialog.fromHex "ff0000"

        dialog.keydown
            keyCode:keys.escape
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.get("value"), "#abcdef"
        assertThat dialog.dummy.attr("style"), contains "display: none"

    test "ColorPicker should take focus on dialogRequested", ->

        input = new ColorInput
        input.set "value", "#abcdef"

        dialog = new ColorPicker
        dialog.dialogRequested input

        assertThat dialog.hasFocus

    test "ColorPicker should call the dispose method of the previous
          mode when it's changed", ->

        disposeCalled = false

        class MockMode
            init:->
            update:->
            dispose:->
                disposeCalled = true

        dialog = new ColorPicker

        dialog.set "mode", new MockMode
        dialog.set "mode", new MockMode

        assertThat disposeCalled

    test "ColorPicker should call the update method when a new
          set is defined", ->

        updateCalled = false

        class MockMode
            init:->
            update:->
                updateCalled = true
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new MockMode

        assertThat updateCalled

    test "A ColorPicker should contains a radio group to select
          the color modes", ->

        dialog = new ColorPicker

        assertThat dialog.modesGroup instanceof RadioGroup
        assertThat dialog.dummy.find(".radio").length, equalTo 6

    test "A ColorPicker should provides 6 color edit modes", ->

        dialog = new ColorPicker

        assertThat dialog.editModes, arrayWithLength 6

    test "The HSV radio should be checked at start", ->

        dialog = new ColorPicker

        assertThat dialog.hueMode.get "checked"

    test "Checking a mode radio should select the mode for this dialog", ->

        dialog = new ColorPicker

        dialog.valueMode.set "checked", true

        assertThat dialog.get("mode") is dialog.editModes[5]

    test "Ending the edit should return the focus on the color input", ->

        input = new ColorInput
        dialog = new ColorPicker
        dialog.dialogRequested input
        dialog.keydown
            keyCode:keys.enter
            ctrlKey:false
            shiftKey:false
            altKey:false

        assertThat input.hasFocus


    dialog = new ColorPicker
    dialog.set "value", "#abcdef"
    dialog.addClasses "dummy"

    $("#qunit-header").before $ "<h4>ColorPicker</h4>"
    dialog.before "#qunit-header"

    module "hsv mode tests"

    test "The HSV mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 1

    test "The HSV mode should set the background of the color
          layer of the squareinput according to the color", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        assertThat dialog.squarePicker.dummy.find(".hue-color").attr("style"),
                   contains "background: #0080ff"

    test "When in HSV mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.rangePicker.set "value", [0, 260]

        assertThat dialog.get("value"), equalTo "#c2efab"

    test "When in HSV mode, changing the value of the squarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.squarePicker.set "value", [20, 80]

        assertThat dialog.get("value"), equalTo "#292e33"

    test "Disposing the HSV mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 0

    test "HSVMode should no longer receive events from the dialog
          when it was disposed", ->

        squareChangedCalled = false
        rangeChangedCalled = false
        disposeCalled = false

        class MockMode
            init:->
            update:->
            dispose:->

        class MockHSVMode extends HSVMode
            constructor:()->
                super()
                @allowSignal = false

            dispose:->
                disposeCalled = true
                @allowSignal = true
                super()

            squareChanged:( widget, value )->
                if @allowSignal
                    squareChangedCalled = true

            rangeChanged:( widget, value )->
                if @allowSignal
                    rangeChangedCalled = true

        dialog = new ColorPicker

        dialog.set "mode", new MockHSVMode

        dialog.set "mode", new MockMode

        dialog.rangePicker.set "value", [0,0]
        dialog.squarePicker.set "value", [0,0]

        assertThat disposeCalled
        assertThat not squareChangedCalled
        assertThat not rangeChangedCalled

    module "shv mode tests"

    test "The SHV mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        dialog.set "mode", new SHVMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
            equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
            equalTo 1

    test "Disposing the SHV mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new SHVMode
        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
            equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
            equalTo 0

    test "The SHV mode should alter the opacity of the white
          plain span according to the color data", ->

        dialog = new ColorPicker
        dialog.set "value", "#ff0000"

        dialog.set "mode", new SHVMode

        assertThat dialog.squarePicker.dummy.find(".white-plain")
                                            .attr("style"),
                   contains "opacity: 0"

        dialog.set "value", "#ffffff"

        assertThat dialog.squarePicker.dummy.find(".white-plain")
                                            .attr("style"),
                   contains "opacity: 1"


    test "When in SHV mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new SHVMode

        dialog.rangePicker.set "value", [0, 90]

        assertThat dialog.get("value"), equalTo "#d7e3ef"

    test "When in SHV mode, changing the value of the squarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new SHVMode

        dialog.squarePicker.set "value", [200, 80]

        assertThat dialog.get("value"), equalTo "#24332e"

        module "shv mode tests"

        test "The SHV mode should creates layer in the squareinputs
              of its target dialog", ->

            dialog = new ColorPicker

            dialog.set "mode", new SHVMode

            assertThat dialog.squarePicker.dummy.children(".layer").length,
                       equalTo 1
            assertThat dialog.rangePicker.dummy.children(".layer").length,
                       equalTo 1

    module "vhs mode tests"

    test "The VHS mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        dialog.set "mode", new VHSMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 1

    test "Disposing the VHS mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new VHSMode
        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 0

    test "The VHS mode should alter the opacity of the black plain
          span according to the color data", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.set "mode", new VHSMode

        assertThat dialog.squarePicker.dummy.find(".black-plain")
                                            .attr("style"),
                   contains "opacity: 1"

        dialog.set "value", "#ffffff"

        assertThat dialog.squarePicker.dummy.find(".black-plain")
                                            .attr("style"),
                   contains "opacity: 0"

    test "When in VHS mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new VHSMode

        dialog.rangePicker.set "value", [0, 80]

        assertThat dialog.get("value"), equalTo "#242c33"

    test "When in VHS mode, changing the value of the squarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new VHSMode

        dialog.squarePicker.set "value", [200, 60]

        assertThat dialog.get("value"), equalTo "#8fefcf"

    module "rgb mode tests"

    test "The RGB mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        dialog.set "mode", new RGBMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 1

    test "Disposing the RGB mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new RGBMode
        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 0

    test "The RGB mode should alter the opacity of the upper
          layer according to the color data", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.set "mode", new RGBMode

        assertThat dialog.squarePicker.dummy.find(".rgb-up")
                                            .attr("style"),
                   contains "opacity: 0"

        dialog.set "value", "#ffffff"

        assertThat dialog.squarePicker.dummy.find(".rgb-up")
                                            .attr("style"),
                   contains "opacity: 1"

    test "When in RGB mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new RGBMode

        dialog.rangePicker.set "value", [0, 55]

        assertThat dialog.get("value"), equalTo "#c8cdef"

    test "When in RGB mode, changing the value of the SquarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new RGBMode

        dialog.squarePicker.set "value", [100, 205]

        assertThat dialog.get("value"), equalTo "#ab3264"

    module "grb mode tests"

    test "The GRB mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        dialog.set "mode", new GRBMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 1

    test "Disposing the GRB mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new GRBMode
        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 0

    test "The GRB mode should alter the opacity of the upper
          layer according to the color data", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.set "mode", new GRBMode

        assertThat dialog.squarePicker.dummy.find(".grb-up")
                                            .attr("style"),
                   contains "opacity: 0"

        dialog.set "value", "#ffffff"

        assertThat dialog.squarePicker.dummy.find(".grb-up")
                                            .attr("style"),
                   contains "opacity: 1"

    test "When in GRB mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new GRBMode

        dialog.rangePicker.set "value", [0, 55]

        assertThat dialog.get("value"), equalTo "#abc8ef"

    test "When in GRB mode, changing the value of the squarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new GRBMode

        dialog.squarePicker.set "value", [100, 205]

        assertThat dialog.get("value"), equalTo "#32cd64"

    module "bgr mode tests"

    test "The BGR mode should creates layer in the squareinputs
          of its target dialog", ->

        dialog = new ColorPicker

        dialog.set "mode", new BGRMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 1

    test "Disposing the BGR mode should remove the html content
          placed in the dialog by the mode", ->

        class MockMode
            init:->
            update:->
            dispose:->

        dialog = new ColorPicker

        dialog.set "mode", new BGRMode
        dialog.set "mode", new MockMode

        assertThat dialog.squarePicker.dummy.children(".layer").length,
                   equalTo 0
        assertThat dialog.rangePicker.dummy.children(".layer").length,
                   equalTo 0

    test "The BGR mode should alter the opacity of the upper layer
          according to the color data", ->

        dialog = new ColorPicker
        dialog.set "value", "#000000"

        dialog.set "mode", new BGRMode

        assertThat dialog.squarePicker.dummy.find(".bgr-up")
                                            .attr("style"),
                   contains "opacity: 0"

        dialog.set "value", "#ffffff"

        assertThat dialog.squarePicker.dummy.find(".bgr-up")
                                            .attr("style"),
                   contains "opacity: 1"

    test "When in BGR mode, changing the value of the rangePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new BGRMode

        dialog.rangePicker.set "value", [0, 155]

        assertThat dialog.get("value"), equalTo "#abcd64"

    test "When in BGR mode, changing the value of the squarePicker
          should affect the dialog's value", ->

        dialog = new ColorPicker
        dialog.set "value", "#abcdef"

        dialog.set "mode", new BGRMode

        dialog.squarePicker.set "value", [100, 155]

        assertThat dialog.get("value"), equalTo "#6464ef"
