module "colorpicker tests"

test "A color picker should accept a target input with type color", ->

    target = $("<input type='color'></input>")[0]
    picker = new ColorPicker target

    assertThat picker.target is target

test "A color picker shouldn't accept a target input with a type different than color", ->

    target = $("<input type='text'></input>")[0]
    errorRaised = false

    try
        picker = new ColorPicker target
    catch e
        errorRaised = true
    
    assertThat errorRaised

test "A color picker should retreive the color from its target", ->
    
    target = $("<input type='color' value='#ff0000'></input>")[0]
    picker = new ColorPicker target

    assertThat picker.get("value"), equalTo "#ff0000"

test "A color picker should have a default color even without target", ->
    
    picker = new ColorPicker 

    assertThat picker.get("value"), equalTo "#000000"

test "A color picker should provide a color property that provide a more code friendly color object", ->

    picker = new ColorPicker 

    color = picker.get("color")

    assertThat color, allOf notNullValue(), hasProperties 
        red:0
        green:0
        blue:0

test "A color picker color should reflect the initial value", ->

    target = $("<input type='color' value='#abcdef'></input>")[0]
    picker = new ColorPicker target

    color = picker.get("color")

    assertThat color, allOf notNullValue(), hasProperties 
        red:0xab
        green:0xcd
        blue:0xef

test "A color picker should update the value when the color is changed", ->

    picker = new ColorPicker

    picker.set "color", 
        red:0xab
        green:0xcd
        blue:0xef
    
    assertThat picker.get("value"), equalTo "#abcdef"

test "A color picker should preserve the length of the value even with black", ->

    picker = new ColorPicker

    picker.set "color", 
        red:0
        green:0
        blue:0
    
    assertThat picker.get("value"), equalTo "#000000"

test "A color picker should update its color property when the value is changed", ->

    picker = new ColorPicker

    picker.set "value", "#abcdef"
    color = picker.get("color")

    assertThat color, allOf notNullValue(), hasProperties 
        red:0xab
        green:0xcd
        blue:0xef

test "A color picker should prevent invalid values to alter its properties", ->
    
    target = $("<input type='color' value='#foobar'></input>")[0]
    
    picker = new ColorPicker target
    picker.set "value", "foo"
    picker.set "value", "#ghijkl"
    picker.set "value", "#abc"
    picker.set "value", undefined

    assertThat picker.get("value"), equalTo "#000000"
    assertThat picker.get("color"), hasProperties 
        red:0
        green:0
        blue:0

test "A color picker should prevent invalid color to alter its properties", ->
    
    picker = new ColorPicker
    picker.set "value", "#abcdef"

    picker.set "color", null
    
    picker.set "color", 
        red:NaN,
        green:0,
        blue:0
    
    picker.set "color", 
        red:0,
        green:-1,
        blue:0
    
    picker.set "color", 
        red:0,
        green:0,
        blue:"foo"
    
    picker.set "color", 
        red:0,
        green:0,
        blue:300
    
    assertThat picker.get("value"), equalTo "#abcdef"
    assertThat picker.get("color"), hasProperties 
        red:0xab
        green:0xcd
        blue:0xef

test "A color picker should provide a dummy", ->

    picker = new ColorPicker

    assertThat picker.dummy, notNullValue()

test "The color span of a color picker should have its background filled with the widget's value", ->
    target = $("<input type='color' value='#abcdef'></input>")[0]
    
    picker = new ColorPicker target

    assertThat picker.dummy.children(".color").attr("style"), contains "background: #abcdef;"

test "The color span of a color picker should have its background filled with the widget's value even after a change", ->
    picker = new ColorPicker

    picker.set "value", "#abcdef"

    assertThat picker.dummy.children(".color").attr("style"), contains "background: #abcdef;"

test "Clicking on a color picker should trigger a dialogRequested signal", ->
    
    signalCalled = false
    signalSource = null
    
    picker = new ColorPicker

    picker.dialogRequested.add ( widget )->
        signalCalled = true
        signalSource = widget

    picker.dummy.click()

    assertThat signalCalled
    assertThat signalSource is picker

test "The color child text should be the value hexadecimal code", ->

    picker = new ColorPicker

    assertThat picker.dummy.children(".color").text(), equalTo "#000000" 

test "The color child text color should be defined according the luminosity of the color", ->

    picker = new ColorPicker

    assertThat picker.dummy.children(".color").attr("style"), contains "color: #ffffff;" 

    picker.set "value", "#ffffff"

    assertThat picker.dummy.children(".color").attr("style"), contains "color: #000000;"

test "The ColorWidget's class should have a default listener defined for the dialogRequested signal of its instance", ->

    assertThat ColorPicker.defaultListener instanceof ColorPickerDialog

test "Disabled ColorPicker should trigger the dialogRequested on click", ->

    signalCalled = false
    picker = new ColorPicker

    picker.dialogRequested.add ->
        signalCalled = true
    
    picker.set "disabled", true

    picker.dummy.click()

    assertThat not signalCalled

test "Readonly ColorPicker should trigger the dialogRequested on click", ->

    signalCalled = false
    picker = new ColorPicker

    picker.dialogRequested.add ->
        signalCalled = true
    
    picker.set "readonly", true

    picker.dummy.click()

    assertThat not signalCalled

# Some live instances

picker1 = new ColorPicker
picker2 = new ColorPicker
picker3 = new ColorPicker

picker1.set "value", "#cbdc1b"
picker2.set "value", "#66ff99"
picker3.set "value", "#6699ff"

picker2.set "readonly", true
picker3.set "disabled", true

$("#qunit-header").before $ "<h4>ColorPicker</h4>"
$("#qunit-header").before picker1.dummy
$("#qunit-header").before picker2.dummy
$("#qunit-header").before picker3.dummy


# SquarePicker
module "squarepicker tests"

test "A SquarePicker should provides two ranges of values for its x and y axis", ->

    grid = new SquarePicker

    grid.set 
        rangeX:[ 0, 100 ]
        rangeY:[ 0, 100 ]

    assertThat grid.get("rangeX"), array 0, 100
    assertThat grid.get("rangeY"), array 0, 100

test "The SquarePicker's value should be a tuple of values in the x and y range", ->

    grid = new SquarePicker

    assertThat grid.get("value"), array 0, 0 

test "The SquarePicker should prevent any attempt to set invalid values", ->

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

test "A SquarePicker should prevent all attempt to set an invalid range", ->

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

test "Given a specific size, pressing the mouse inside a grid should change the value according to the x and y ranges",->

    class MockSquarePicker extends SquarePicker
        mousedown:(e)->
            e.pageX = 45
            e.pageY = 65
            super e

    grid = new MockSquarePicker

    grid.dummy.attr "style", "width:100px; height:100px;"

    grid.set 
        rangeX:[ 0, 10 ]
        rangeY:[ 0, 10 ]
    
    grid.dummy.mousedown()

    assertThat grid.get("value"), array 4.5, 6.5

test "A SquarePicker should allow to drag the mouse to change the value", ->

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

    grid.dummy.attr "style", "width:100px; height:100px;"

    grid.set 
        rangeX:[ 0, 10 ]
        rangeY:[ 0, 10 ]
    
    grid.dummy.mousedown()
    assertThat grid.get("value"), array closeTo( 4.5, 0.1 ), closeTo( 6.5, 0.1 )

    grid.dummy.mousemove()
    assertThat grid.get("value"), array closeTo( 4.7, 0.1 ), closeTo( 6.7, 0.1 )

    grid.dummy.mouseup()
    assertThat grid.get("value"), array closeTo( 4.9, 0.1 ), closeTo( 6.9, 0.1 )

test "Dragging the mouse outside of the SquarePicker on the bottom right should set the values on the max", ->

    class MockSquarePicker extends SquarePicker
            
            mouseup:(e)->
                e.pageX = 110
                e.pageY = 110
                super e

    grid = new MockSquarePicker

    grid.dummy.attr "style", "width:100px; height:100px;"

    grid.set 
        rangeX:[ 0, 10 ]
        rangeY:[ 0, 10 ]
    
    grid.dummy.mousedown()
    grid.dummy.mouseup()
    assertThat grid.get("value"), array closeTo( 10, 0.1 ), closeTo( 10, 0.1 )

test "Dragging the mouse outside of the SquarePicker on the top left should set the values on the min", ->

    class MockSquarePicker extends SquarePicker
            
            mouseup:(e)->
                e.pageX = -10
                e.pageY = -10
                super e

    grid = new MockSquarePicker

    grid.dummy.attr "style", "width:100px; height:100px;"

    grid.set 
        rangeX:[ 0, 10 ]
        rangeY:[ 0, 10 ]
    
    grid.dummy.mousedown()
    grid.dummy.mouseup()
    assertThat grid.get("value"), array closeTo( 0, 0.1 ), closeTo( 0, 0.1 )



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

test "A SquarePicker should have a cursor that display the selected position", ->

    grid = new SquarePicker
    grid.dummy.attr "style", "width:100px; height:100px;"
    grid.dummy.children(".cursor").attr "style", "width:10px; height:10px;"

    grid.set "value", [ 0.45, 0.55 ]

    assertThat grid.dummy.children(".cursor").attr("style"), contains "left: 40px;"
    assertThat grid.dummy.children(".cursor").attr("style"), contains "top: 50px;"

test "When dragging, releasing the mouse outside of the widget should stop the drag", ->

    grid = new SquarePicker
    grid.dummy.mousedown()

    $(document).mouseup()

    assertThat not grid.dragging

test "Clicking on a SquarePicker should give the focus to the widget", ->

    grid = new SquarePicker
    grid.dummy.mousedown() 

    assertThat grid.hasFocus

test "Clicking on a disabled SquarePicker shouldn't give the focus to the widget", ->

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

spicker1 = new SquarePicker
spicker2 = new SquarePicker
spicker3 = new SquarePicker
spicker4 = new SquarePicker

spicker1.set "value", [.2,.5]
spicker2.set "value", [0, .6]
spicker3.set "value", [.7,.2]
spicker4.set "value", [.8,0 ]

spicker2.lockX()
spicker2.dummyClass = spicker2.dummyClass + " vertical"
spicker2.updateStates()

spicker4.dummyClass = spicker4.dummyClass + " horizontal"
spicker4.updateStates()

spicker3.set "readonly", true
spicker4.set "disabled", true

$("#qunit-header").before $ "<h4>SquarePicker</h4>"
$("#qunit-header").before spicker1.dummy
$("#qunit-header").before spicker2.dummy
$("#qunit-header").before spicker3.dummy
$("#qunit-header").before spicker4.dummy




module "colorpickerdialog tests"

test "A ColorPickerDialog should be hidden at startup", ->

    dialog = new ColorPickerDialog
    assertThat dialog.dummy.attr("style"), contains "display: none;"

test "A ColorPickerDialog should have a listener for the dialogRequested signal that setup the dialog", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"
    
    dialog = new ColorPickerDialog
    dialog.dialogRequested picker 

    assertThat dialog.get( "value" ) is "#abcdef"

test "A ColorPickerDialog should show itself on a dialog request", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"
    
    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    assertThat dialog.dummy.attr("style"), contains "display: block;"
     

test "A ColorPickerDialog should provides a method to convert a rgb color to hsv values", ->

    dialog = new ColorPickerDialog

    hsv = rgb2hsv 10, 100, 200
    
    assertThat hsv, array closeTo( 212, 2 ), closeTo( 95, 2 ), closeTo( 78, 2 )

test "A ColorPickerDialog should provides a method to convert a hsv color to rgb values", ->

    dialog = new ColorPickerDialog

    rgb = hsv2rgb 212, 95, 78
    
    assertThat rgb, array closeTo( 10, 2 ), closeTo( 100, 2 ), closeTo( 200, 2 )

test "A ColorPickerDialog should provides a dummy", ->

    dialog = new ColorPickerDialog
    
    assertThat dialog.dummy, notNullValue()

test "A ColorPickerDialog should provides a TextInput for each channel of the color", ->

    dialog = new ColorPickerDialog

    assertThat dialog.redInput instanceof TextInput
    assertThat dialog.greenInput instanceof TextInput
    assertThat dialog.blueInput instanceof TextInput

test "The inputs for the color channels should be limited to three chars", ->

    dialog = new ColorPickerDialog

    assertThat dialog.redInput.get("maxlength"), equalTo 3
    assertThat dialog.greenInput.get("maxlength"), equalTo 3
    assertThat dialog.blueInput.get("maxlength"), equalTo 3

test "A ColorPickerDialog should have the channels input as child of the dummy", ->

    dialog = new ColorPickerDialog

    assertThat dialog.dummy.children(".red")[0],    equalTo dialog.redInput.dummy[0]
    assertThat dialog.dummy.children(".green")[0],  equalTo dialog.greenInput.dummy[0]
    assertThat dialog.dummy.children(".blue")[0],   equalTo dialog.blueInput.dummy[0]

test "Setting the value of a ColorPickerDialog should fill the channels input", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    assertThat dialog.redInput.get("value"), equalTo 0xab
    assertThat dialog.greenInput.get("value"), equalTo 0xcd
    assertThat dialog.blueInput.get("value"), equalTo 0xef

test "A ColorPickerDialog should provides a TextInput for each channel of the hsv color", ->

    dialog = new ColorPickerDialog

    assertThat dialog.hueInput instanceof TextInput
    assertThat dialog.saturationInput instanceof TextInput
    assertThat dialog.valueInput instanceof TextInput

test "The inputs for the hsv channels should be limited to three chars", ->

    dialog = new ColorPickerDialog

    assertThat dialog.hueInput.get("maxlength"), equalTo 3
    assertThat dialog.saturationInput.get("maxlength"), equalTo 3
    assertThat dialog.valueInput.get("maxlength"), equalTo 3

test "A ColorPickerDialog should have the channels input as child of the dummy", ->

    dialog = new ColorPickerDialog

    assertThat dialog.dummy.children(".hue")[0],        equalTo dialog.hueInput.dummy[0]
    assertThat dialog.dummy.children(".saturation")[0], equalTo dialog.saturationInput.dummy[0]
    assertThat dialog.dummy.children(".value")[0],      equalTo dialog.valueInput.dummy[0]

test "Setting the value of a ColorPickerDialog should fill the channels input", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"
    [ h, s, v ] = rgb2hsv 0xab, 0xcd, 0xef

    assertThat dialog.hueInput.get("value"),        equalTo Math.round h
    assertThat dialog.saturationInput.get("value"), equalTo Math.round s
    assertThat dialog.valueInput.get("value"),      equalTo Math.round v

test "A ColorPickerDialog should provides a TextInput for the hexadecimal color", ->

    dialog = new ColorPickerDialog

    assertThat dialog.hexInput instanceof TextInput

test "The hexadecimal input should be limited to 6 chars", ->

    dialog = new ColorPickerDialog

    assertThat dialog.hexInput.get("maxlength"), equalTo 6

test "A ColorPickerDialog should have the hexadecimal input as child of the dummy", ->

    dialog = new ColorPickerDialog

    assertThat dialog.dummy.children(".hex")[0], equalTo dialog.hexInput.dummy[0]

test "Setting the value of a ColorPickerDialog should fill the hexadecimal input", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    assertThat dialog.hexInput.get("value"), equalTo "abcdef"

test "Setting the value of the red input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.redInput.set "value", 0xff

    assertThat dialog.get("value"), equalTo "#ff0000"

    dialog.redInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#450000"

test "Setting an invalid value for the red input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.redInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#000000"

test "Setting the value of the green input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.greenInput.set "value", 0xff

    assertThat dialog.get("value"), equalTo "#00ff00"

    dialog.greenInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#004500"

test "Setting an invalid value for the green input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.greenInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#000000"

test "Setting the value of the blue input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.blueInput.set "value", 0xff

    assertThat dialog.get("value"), equalTo "#0000ff"

    dialog.blueInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#000045"

test "Setting an invalid value for the blue input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.blueInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#000000"

test "Setting the value of the hue input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#332929"

    dialog.hueInput.set "value", 100

    assertThat dialog.get("value"), equalTo "#2c3329"

    dialog.hueInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#323329"

test "Setting an invalid value for the hue input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#332929"

    dialog.hueInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#332929"


test "Setting the value of the saturation input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.saturationInput.set "value", 50

    assertThat dialog.get("value"), equalTo "#2e331a"

    dialog.saturationInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#2c3310"

test "Setting an invalid value for the saturation input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.saturationInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#313329"

test "Setting the value of the value input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.valueInput.set "value", 50

    assertThat dialog.get("value"), equalTo "#7b8067"

    dialog.valueInput.set "value", "69"

    assertThat dialog.get("value"), equalTo "#a9b08d"

test "Setting an invalid value for the value input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.valueInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#313329"

test "Setting the value of the hex input should update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.hexInput.set "value", "abcdef"

    assertThat dialog.get("value"), equalTo "#abcdef"

    dialog.hexInput.set "value", "012345"

    assertThat dialog.get("value"), equalTo "#012345"

test "Setting an invalid value for the hex input shouldn't update the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#313329"

    dialog.hexInput.set "value", "foo"

    assertThat dialog.get("value"), equalTo "#313329"

test "The ColorPickerDialog should provides two grid pickers", ->

    dialog = new ColorPickerDialog

    assertThat dialog.squarePicker instanceof SquarePicker
    assertThat dialog.rangePicker instanceof SquarePicker

test "A ColorPickerDialog should have a default edit mode for color manipulation through the SquarePickers", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    assertThat dialog.squarePicker.get("rangeX"), array 0, 100
    assertThat dialog.squarePicker.get("rangeY"), array 0, 100
    assertThat dialog.rangePicker.get("rangeY"), array 0, 360

    assertThat dialog.squarePicker.get("value"), array closeTo(28,1), closeTo(100-94,1)
    assertThat dialog.rangePicker.get("value")[1], equalTo 360-210

test "Clicking outside of the ColorPickerDialog should terminate the modification and set the value on the ColorPicker", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    class MockColorPickerDialog extends ColorPickerDialog
        mouseup:(e)->
            e.pageX = 1000
            e.pageY = 1000
            super e

    dialog = new MockColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    $( document ).mouseup()

    assertThat picker.get("value"), "#ff0000"
    assertThat dialog.dummy.attr("style"), contains "display: none;"

test "Pressing enter on the ColorPickerDialog should terminate the modification and set the value on the ColorPicker", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#ff0000"
    assertThat dialog.dummy.attr("style"), contains "display: none;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the red input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.redInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the green input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.greenInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the blue input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.blueInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the hue input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.hueInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the saturation input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.saturationInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the value input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.valueInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "Pressing enter on the ColorPickerDialog while there was changes made to the hex input shouldn't comfirm the color changes", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.hexInput.input()

    dialog.keydown 
        keyCode:keys.enter
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: block;"

test "A ColorPickerDialog should be placed next to the colorpicker a dialog request", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"
    
    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    assertThat dialog.dummy.attr("style"), contains "left: 0px;"
    assertThat dialog.dummy.attr("style"), contains "top: " + picker.dummy.height() + "px;"
    assertThat dialog.dummy.attr("style"), contains "position: absolute;"

test "A ColorPickerDialog should provides two more chidren that will be used to present the previous and current color", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"
    
    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    assertThat dialog.dummy.children(".oldColor").attr("style"), contains "background: #abcdef;"
    assertThat dialog.dummy.children(".newColor").attr("style"), contains "background: #ff0000;"

test "Clicking on the old color should reset the value to the original one", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"
    
    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.dummy.children(".oldColor").click()

    assertThat dialog.get("value"), equalTo "#abcdef"

test "Pressing escape on the ColorPickerDialog should close the dialog", ->

    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    dialog.fromHex "ff0000"

    dialog.keydown 
        keyCode:keys.escape
        ctrlKey:false
        shiftKey:false
        altKey:false

    assertThat picker.get("value"), "#abcdef"
    assertThat dialog.dummy.attr("style"), contains "display: none;"

test "ColorPickerDialog should take focus on dialogRequested", ->
    
    picker = new ColorPicker
    picker.set "value", "#abcdef"

    dialog = new ColorPickerDialog
    dialog.dialogRequested picker

    assertThat dialog.hasFocus

test "ColorPickerDialog should call the dispose method of the previous mode when it's changed", ->

    disposeCalled = false

    class MockMode
        init:->
        update:->
        dispose:->
            disposeCalled = true
    
    dialog = new ColorPickerDialog

    dialog.set "mode", new MockMode
    dialog.set "mode", new MockMode

    assertThat disposeCalled

test "ColorPickerDialog should call the update method when a new set is defined", ->

    updateCalled = false

    class MockMode
        init:->
        update:->
            updateCalled = true
        dispose:->
    
    dialog = new ColorPickerDialog

    dialog.set "mode", new MockMode

    assertThat updateCalled

test "A ColorPickerDialog should contains a radio group to select the color modes", ->

    dialog = new ColorPickerDialog

    assertThat dialog.modesGroup instanceof RadioGroup
    assertThat dialog.dummy.find(".radio").length, equalTo 6

test "A ColorPickerDialog should provides 6 color edit modes", ->

    dialog = new ColorPickerDialog

    assertThat dialog.editModes, arrayWithLength 6

test "The HSV radio should be checked at start", ->

    dialog = new ColorPickerDialog

    assertThat dialog.hueMode.get "checked"

test "Checking a mode radio should select the mode for this dialog", ->

    dialog = new ColorPickerDialog

    dialog.valueMode.set "checked", true

    assertThat dialog.get("mode") is dialog.editModes[5]


dialog = new ColorPickerDialog
dialog.set "value", "#abcdef"
dialog.addClasses "dummy"

$("#qunit-header").before $ "<h4>ColorPickerDialog</h4>"
$("#qunit-header").before dialog.dummy

module "hsv mode tests"

test "The HSV mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "The HSV mode should set the background of the color layer of the squarepicker according to the color", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"
    
    assertThat dialog.squarePicker.dummy.find(".hue-color").attr("style"), contains "background: #0080ff;"

test "When in HSV mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"
    
    dialog.rangePicker.set "value", [0, 260] 

    assertThat dialog.get("value"), equalTo "#c2efab"

test "When in HSV mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"
    
    dialog.squarePicker.set "value", [20, 80] 

    assertThat dialog.get("value"), equalTo "#292e33"

test "Disposing the HSV mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "HSVMode should no longer receive events from the dialog when it was disposed", ->

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
    
    dialog = new ColorPickerDialog

    dialog.set "mode", new MockHSVMode

    dialog.set "mode", new MockMode

    dialog.rangePicker.set "value", [0,0]
    dialog.squarePicker.set "value", [0,0]

    assertThat disposeCalled
    assertThat not squareChangedCalled
    assertThat not rangeChangedCalled
        
module "shv mode tests"

test "The SHV mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    dialog.set "mode", new SHVMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "Disposing the SHV mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new SHVMode
    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "The SHV mode should alter the opacity of the white plain span according to the color data", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#ff0000"

    dialog.set "mode", new SHVMode

    assertThat dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains "opacity: 0;"

    dialog.set "value", "#ffffff"

    assertThat dialog.squarePicker.dummy.find(".white-plain").attr("style"), contains "opacity: 1;"


test "When in SHV mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new SHVMode
    
    dialog.rangePicker.set "value", [0, 90] 

    assertThat dialog.get("value"), equalTo "#d7e3ef"

test "When in SHV mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new SHVMode
    
    dialog.squarePicker.set "value", [200, 80] 

    assertThat dialog.get("value"), equalTo "#24332e"

    module "shv mode tests"

    test "The SHV mode should creates layer in the squarepickers of its target dialog", ->

        dialog = new ColorPickerDialog

        dialog.set "mode", new SHVMode

        assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
        assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

module "vhs mode tests"

test "The VHS mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    dialog.set "mode", new VHSMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "Disposing the VHS mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new VHSMode
    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "The VHS mode should alter the opacity of the black plain span according to the color data", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.set "mode", new VHSMode

    assertThat dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains "opacity: 1;"

    dialog.set "value", "#ffffff"

    assertThat dialog.squarePicker.dummy.find(".black-plain").attr("style"), contains "opacity: 0;"

test "When in VHS mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new VHSMode
    
    dialog.rangePicker.set "value", [0, 80] 

    assertThat dialog.get("value"), equalTo "#242c33"

test "When in VHS mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new VHSMode
    
    dialog.squarePicker.set "value", [200, 60] 

    assertThat dialog.get("value"), equalTo "#8fefcf"  

module "rgb mode tests"

test "The RGB mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    dialog.set "mode", new RGBMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "Disposing the RGB mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new RGBMode
    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "The RGB mode should alter the opacity of the upper layer according to the color data", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.set "mode", new RGBMode

    assertThat dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains "opacity: 0;"

    dialog.set "value", "#ffffff"

    assertThat dialog.squarePicker.dummy.find(".rgb-up").attr("style"), contains "opacity: 1;"

test "When in RGB mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new RGBMode
    
    dialog.rangePicker.set "value", [0, 55] 

    assertThat dialog.get("value"), equalTo "#c8cdef"

test "When in RGB mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new RGBMode
    
    dialog.squarePicker.set "value", [100, 205] 

    assertThat dialog.get("value"), equalTo "#ab3264"  

module "grb mode tests"

test "The GRB mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    dialog.set "mode", new GRBMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "Disposing the GRB mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new GRBMode
    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "The GRB mode should alter the opacity of the upper layer according to the color data", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.set "mode", new GRBMode

    assertThat dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains "opacity: 0;"

    dialog.set "value", "#ffffff"

    assertThat dialog.squarePicker.dummy.find(".grb-up").attr("style"), contains "opacity: 1;"

test "When in GRB mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new GRBMode
    
    dialog.rangePicker.set "value", [0, 55] 

    assertThat dialog.get("value"), equalTo "#abc8ef"

test "When in GRB mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new GRBMode
    
    dialog.squarePicker.set "value", [100, 205] 

    assertThat dialog.get("value"), equalTo "#32cd64"  

module "bgr mode tests"

test "The BGR mode should creates layer in the squarepickers of its target dialog", ->

    dialog = new ColorPickerDialog

    dialog.set "mode", new BGRMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 1
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 1

test "Disposing the BGR mode should remove the html content placed in the dialog by the mode", ->
    
    class MockMode
        init:->
        update:->
        dispose:->
        
    dialog = new ColorPickerDialog

    dialog.set "mode", new BGRMode
    dialog.set "mode", new MockMode

    assertThat dialog.squarePicker.dummy.children(".layer").length, equalTo 0
    assertThat dialog.rangePicker.dummy.children(".layer").length, equalTo 0

test "The BGR mode should alter the opacity of the upper layer according to the color data", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#000000"

    dialog.set "mode", new BGRMode

    assertThat dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains "opacity: 0;"

    dialog.set "value", "#ffffff"

    assertThat dialog.squarePicker.dummy.find(".bgr-up").attr("style"), contains "opacity: 1;"

test "When in BGR mode, changing the value of the rangePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new BGRMode
    
    dialog.rangePicker.set "value", [0, 155] 

    assertThat dialog.get("value"), equalTo "#abcd64"

test "When in BGR mode, changing the value of the squarePicker should affect the dialog's value", ->

    dialog = new ColorPickerDialog
    dialog.set "value", "#abcdef"

    dialog.set "mode", new BGRMode
    
    dialog.squarePicker.set "value", [100, 155] 

    assertThat dialog.get("value"), equalTo "#6464ef"  