#### In this file
#
# The `ColorInput` widget relys on several functions and widgets
# that are also declared in this file, you can find below
# the list of classes that are defined:
#
# * [ColorInput](#colorinput)
# * [SquarePicker](#gridpicker)
# * [ColorPicker](#colorpicker)
# * [AbstractMode](#AbstractMode)
# * [HSVMode](#HSV)
# * [SHVMode](#SHV)
# * [VHSMode](#VHS)
# * [RGBMode](#RGB)
# * [GRBMode](#GRB)
# * [BGRMode](#BGR)

#### Color Conversions

# Converts a color defined with its red, green and blue channels into
# an hexadecimal string.
rgb2hex = (r, g, b) ->
  rnd = Math.round
  value = ((rnd(r) << 16) + (rnd(g) << 8) + rnd(b)).toString 16

  # The value is filled with `0` to match a length of 6.
  value = "0#{value}" while value.length < 6

  value

# Converts an hexadecimal string such as `#abcdef` into an array
# with the red, green and blue channels values.
hex2rgb = (hex) ->
  rgb = hex.substr 1
  color = parseInt rgb, 16

  r = (color >> 16) & 0xff
  g = (color >> 8) & 0xff
  b = color & 0xff

  [r, g, b]

# Converts a color in the `rgb` color space in an
# array with the color in the `hsv` color space.
rgb2hsv = (r, g, b) ->

  r = r / 255
  g = g / 255
  b = b / 255
  rnd = Math.round

  minVal = Math.min r, g, b
  maxVal = Math.max r, g, b
  delta = maxVal - minVal

  # Value is always the maximal component's value.
  v = maxVal

  # The color is a gray, there's no need to proceed further.
  # Both saturation and hue equals to `0`.
  if delta is 0
    h = 0
    s = 0
  else
    # The lower the delta is in comparison with the value
    # the higher the saturation will be.
    s = delta / v
    deltaR = (((v - r) / 6) + (delta / 2)) / delta
    deltaG = (((v - g) / 6) + (delta / 2)) / delta
    deltaB = (((v - b) / 6) + (delta / 2)) / delta

    # In a range from `0` to `1`, full red is at `0` and `1`,
    # full green is at `1/3` and full blue at `2/3`.
    #
    # From the point in the range corresponding to the dominant
    # component, the delta of the other channels are both added
    # in order to move the hue around this point.
    if r is v      then h = deltaB - deltaG
    else if g is v then h = (1 / 3) + deltaR - deltaB
    else if b == v then h = (2 / 3) + deltaG - deltaR

    # Hue is then reduced to fit in the `0-1` range.
    h += 1 if h < 0
    h -= 1 if h > 1

  # And, finally, hue, saturation and value are normalized
  # to their corresponding range.
  [h * 360, s * 100, v * 100]

# Converts a color defined in the `hsv` color space into
# an array containing the color in the `rgb` color space.
hsv2rgb = (h, s, v) ->
  # Hue is reduced to the `0-6` range when both saturation
  # and value are reduced to the `0-1`
  h = h / 60
  s = s / 100
  v = v / 100
  rnd = Math.round

  # Short circuit when saturation is `0`, all other channels
  # will end up to `0` as well.
  if s is 0
    return [rnd v * 255, rnd v * 255, rnd v * 255]
  else
    # By rounding the hue we obtain the dominant
    # color such as :
    #
    #  * 0 = Red
    #  * 1 = Yellow
    #  * 2 = Green
    #  * 3 = Cyan
    #  * 4 = Blue
    #  * 5 = Fuschia
    dominant = Math.floor h

    comp1 = v * (1 - s)
    comp2 = v * (1 - s * (h - dominant))
    comp3 = v * (1 - s * (1 - (h - dominant)))

    # According to the dominant color we affect
    # the values to each component.
    switch dominant
      when 0 then [r, g, b] = [v, comp3, comp1]
      when 1 then [r, g, b] = [comp2, v, comp1]
      when 2 then [r, g, b] = [comp1, v, comp3]
      when 3 then [r, g, b] = [comp1, comp2, v]
      when 4 then [r, g, b] = [comp3, comp1, v]
      else        [r, g, b] = [v, comp1, comp2]

    # And each component is normalized to fit in the
    # `0-255`.
    return [r * 255, g * 255, b * 255]

# Converts a color in a string into an object with
# the three channels values as integer between 0 and 255.
colorObjectFromValue = (value) ->
  [r, g, b] = hex2rgb value

  red:r, green:g, blue: b

# Converts an object with `red`, `green` and `blue` properties
# to a string with the html representation of the color.
colorObjectToValue = (rgb) ->
  rgb2hex rgb.red, rgb.green, rgb.blue

#### Color Validations

# Validates that the passed-in string is a valid hexadecimal color code.
isValidValue = (value) ->
  re = /// ^       # nothing allowed before
    \#             # starts with a diese
    [0-9a-fA-F]{6} # must have 6 chars in 0123456789abcdefABCDEF
  $ ///            # nothing allowed after

  re.test value

# Validates that the passed-in argument is a valid number.
isValidNumber = (value) ->
  value? and not isNaN(value)

# Validates that the passed-in argument is a valid hue.
isValidHue = (value) ->
  (isValidNumber value) and 0 <= value <= 360

# Validates that the passed-in argument is a valid percentage.
isValidPercentage = (value) ->
  (isValidNumber value) and 0 <= value <= 100

# Validates that the passed-in argument is a valid channel value.
isValidChannel = (value) ->
  (isValidNumber value) and 0 <= value <= 255

# Validates that the passed-in color object is valid.
isValidColor = (value) ->
  value?                       and
  (isValidChannel value.red)   and
  (isValidChannel value.green) and
  (isValidChannel value.blue)

# Validates that the passed-in red green and blue channels form a valid color.
isValidRGB = (r, g, b) ->
  (isValidChannel r) and (isValidChannel g) and (isValidChannel b)

# Validates that the passed-in hue, saturation and value channels
# form a valid color.
isValidHSV = (h, s, v) ->
  (isValidHue h) and (isValidPercentage s) and (isValidPercentage v)

# <a name ='colorinput'></a>
## ColorInput

class ColorInput extends Widget
  # Here some live instances of the `ColorInput` widget :
  #
  #= require colorinput

  constructor: (target) ->
    super target

    #### ColorInput Signals

    # The `dialogRequested` signal is dispatched when the widget
    # is activated through a click or a keyboard input.
    #
    # Its purpose is to allow an external widget to handle the
    # color choice itself.
    #
    # *Callback arguments*
    #
    #  * `widget`    : The colorinput that request a dialog.
    @dialogRequested = new Signal

    # The initial value is retreived from the target if defined.
    value = @valueFromAttribute "value"

    # A `ColorInput` has always a valid color as value,
    # the default is `#000000`.
    value = "#000000" unless isValidValue value

    @["value"] = value

    # The color object is then created with the widget's value.
    @color = colorObjectFromValue value

    @dialogRequested.add ColorInput.defaultListener.dialogRequested,
                         ColorInput.defaultListener

    @updateDummy value

    @hideTarget()

    #### Keyboard Controls

    # Both the `Enter` and `Space` keys can be used instead
    # of the click to display the dialog.
    @registerKeyDownCommand keystroke(keys.space), @click
    @registerKeyDownCommand keystroke(keys.enter), @click

  #### Target Management

  # Color inputs only allow input with a `color` type
  # as target.
  checkTarget: (target) ->
    unless @isInputWithType target, "color"
      throw new Error "ColorInput's target should be a color input"

  #### Dummy Management

  # The `ColorInput` dummy contains an additional `span` used
  # to display the current color of this widget.
  createDummy: ->
    $ "<span class='colorinput'>
         <span class='color'></span>
       </span>"

  # The `ColorInput` widget automatically update the color preview
  # through the `style` attribute of the dummy.
  updateDummy: (value) ->
    if @hasDummy
      colorPreview = @dummy.children ".color"
      {red:r, green:g, blue: b} = @get "color"

      # The color channel average value is used to define
      # whether the text should be black or white.
      [h,s,v] = rgb2hsv r, g, b
      textColor = if v >= 50 then "#000000" else "#ffffff"

      # The html code of the color is displayed
      # in the `color` child.
      colorPreview.text value

      # That same child background color is then changed according
      # to the widget's current color.
      colorPreview.attr "style", "background: #{value}; color: #{textColor};"

  #### Properties Accessors

  # The `color` setter takes an object such as :
  #
  #     red: 145
  #     green: 254
  #     blue: 12
  #
  # And modify the current widget's value with the values it contains.
  set_color: (property, value) ->

    # If the passed-in object isn't valid the value
    # is keep unchanged.
    return @get "color" unless isValidColor value

    rgb = colorObjectToValue value

    # The value is then changed.
    @set "value", "##{rgb}"
    @[property] = value

  # Sets the value for this widget.
  set_value: (property, value) ->
    # If the passed-in value isn't a valid color the
    # widget's value is keep unchanged
    return @get "value" unless isValidValue value

    # The `color` object for this widget is updated according
    # to the new widget's value.
    @["color"] = colorObjectFromValue value
    @updateDummy value

    super property, value

  #### Events Handling

  # Clicking on a color picker dispatch a dialog request signal.
  click: (e) ->
    @dialogRequested.dispatch this unless @cantInteract()

# <a name ="gridpicker"></a>
## SquarePicker

# The `SquarePicker` widget is used in the `ColorPicker`.
# It allow to manipulate value by dragging a cursor over a surface.
class SquarePicker extends Widget
  # Here some live instances :
  #
  #= require squarepicker
  constructor: ->
    super()

    @rangeX = [0,1]
    @rangeY = [0,1]
    @set "value", [0,0]
    @dragging = false
    @xLocked = false
    @yLocked = false

  #### Axis Locks
  #
  # The widget's cursor can be locked either on the X axis
  # or on the Y axis.
  #
  # The locks prevent any modification to the value of the
  # locked axis, either by an interaction or by the `value`
  # setter.

  lockX: ->
    @xLocked = true

  # Locks can be unlocked as well.
  unlockX: ->
    @xLocked = false

  lockY: ->
    @yLocked = true

  unlockY: ->
    @yLocked = false

  #### Dummy Management

  # The cursor for the widget is a `span` indide
  # the dummy.
  createDummy: ->
    $ "<span class='gridpicker'>
         <span class='cursor'></span>
       </span>"

  # Updates the widget according to the passerd-in
  # `x` and `y` values.
  updateDummy: (x, y) ->
    cursor = @dummy.children(".cursor")

    w = @dummy.width()
    h = @dummy.height()

    cw = cursor.width()
    ch = cursor.height()

    [xmin, xmax] = @get "rangeX"
    [ymin, ymax] = @get "rangeY"

    # The values are normalized in the range 0-1
    rx = (x - xmin) / (xmax - xmin)
    ry = (y - ymin) / (ymax - ymin)

    # The cursor is then centered on the position
    # within the widget.
    left = Math.floor rx * w - (cw / 2)
    top = Math.floor ry * h - (ch / 2)

    cursor.css "left", "#{left}px"
    cursor.css "top", "#{top}px"

  #### Properties Accessors

  # Sets the value of the horizontal range.
  set_rangeX: (property, value) ->
    unless @isValidRange value then return @get property
    @[property] = value

  # Sets the value of the vertical range.
  set_rangeY: (property, value) ->
    unless @isValidRange value then return @get property
    @[property] = value

  # Sets the value for this widget.
  # The value is an array containing the two values
  # the `x` and `y` axis respectively.
  set_value: (property, value) ->

    # Invalid values, or values outside of the ranges
    # are ignored.
    unless value? and
         typeof value is "object" and
         value.length is 2 and
         @isValid(value[0], "rangeX") and
         @isValid(value[1], "rangeY")
      return @get "value"

    v = @get("value")
    [x,y] = value

    # Prevents values to be modified when locks are active.
    x = v[0] if @xLocked
    y = v[1] if @yLocked

    # Updates the dummy with the final values.
    @updateDummy x, y

    super property, [x, y]

  # The `handlePropertyChange` is overriden to catch
  # changes done on `rangeX` and `rangeY` in order
  # to adjust the value if needed.
  handlePropertyChange: (property, value) ->
    super property, value

    # Match that the call concern either `rangeX` or `rangeY`.
    if property in ["rangeX", "rangeY"]
      [x, y] = @get "value"
      [min, max] = @get property

      # Collides the corresponding axis agaisnt the range.
      switch property
        when "rangeX"
          if x > max      then x = max
          else if x < min then x = min
        when "rangeY"
          if y > max      then y = max
          else if y < min then y = min

      # Updates the value.
      @set "value", [x, y]

  #### Validations

  # Validates that the passed-in `value` match the passed-in `range`.
  isValid: (value, range) ->
    [min, max] = @get range
    value? and not isNaN(value) and min <= value <= max

  # Validates that the passed-in `range` is a valid range.
  isValidRange: (value) ->
    # A range takes the form of an array with two values,
    # the `min` and the `max` bounds.
    unless value? then return false
    [min, max] = value

    # A range is valid when its two bounds are numbers and
    # that the `min` value is lower than the `max` value.
    min? and max? and not isNaN(min) and not isNaN(max) and min < max

  #### Cursor Dragging
  # Pressing the mouse over the widget starts a drag gesture.
  mousedown: (e) ->
    unless @cantInteract()
      @dragging = true
      @drag e

      # Mouse release outside of the widget stop the drag as well.
      $(document).bind "mouseup", @documentMouseUpDelegate = (e) =>
        @mouseup e

      $(document).bind "mousemove", @documentMouseMoveDelegate = (e) =>
        @mousemove e


    # The widget takes focus as soon as the drag starts.
    @grabFocus() unless @get "disabled"
    false

  # Perform the drag during the mouse moves.
  mousemove: (e) ->
    @drag e if @dragging

  # Releaseing the mouse stops the drag gesture.
  mouseup: (e) ->
    if @dragging
      @drag e
      @dragging = false
      $(document).unbind "mouseup", @documentMouseUpDelegate
      $(document).unbind "mousemove", @documentMouseMoveDelegate

  # Realizes the drag gesture.
  drag: (e) ->
    w = @dummy.width()
    h = @dummy.height()

    # The mouse position relatively to the widget is calculated.
    x = e.pageX - @dummy.offset().left
    y = e.pageY - @dummy.offset().top

    x = 0 if x < 0
    x = w if x > w
    y = 0 if y < 0
    y = h if y > h

    [xmin, xmax] = @get "rangeX"
    [ymin, ymax] = @get "rangeY"

    # And mapped according to the two ranges of the widget.
    vx = xmin + (x / w) * xmax
    vy = ymin + (y / h) * ymax

    @set "value", [vx, vy]

# <a name ="colorpicker"></a>
## ColorPicker

# The `ColorPicker` class handle the manipulation
# of the color for a given `ColorInput` object.
class ColorPicker extends Widget
  # Here a live instance of the `ColorPicker` widget :
  #
  #= require colorpicker

  @include HasChildren, DropDownPopup

  constructor: ->
    super()

    # The color is stored internally as an object that
    # always contains both the `rgb` channels and the
    # `hsv` channels.
    #
    # All the computations are done with the datas stored
    # in this object. Ultimately the changes made
    # by a user interaction are affected to the widget's
    # value.
    @model = r:0, g:0, b:0, h:0, s:0, v: 0

    # When interactions are done on the children of the
    # `ColorPicker` the model is updated and each
    # child receive its new value.
    #
    # This property prevent
    # chilren's signals to produce an infinite loop when
    # updated by the dialog.
    @inputValueSetProgrammatically = false

    # The `ColorPicker` supports 6 modes for the
    # grid inputs configuration.
    #
    # Those modes are [HSV](#HSV), [SHV](#SHV), [VHS](#VHS),
    # [RGB](#RGB), [GRB](#GRB), [BGR](#BGR).
    @mode = null
    @editModes = [
      new RGBMode
      new GRBMode
      new BGRMode
      new HSVMode
      new SHVMode
      new VHSMode
    ]
    # Modes are selectabled through radio button and a radio group
    # to rules them all.
    @modesGroup = new RadioGroup
    @modesGroup.selectionChanged.add @modeChanged, this

    # Creates all the children widgets.
    @createDummyChildren()

    # The default mode is the [HSV](#HSV) mode.
    @set "mode", @editModes[3]

  #### Dummy Management

  # The dummy for a `ColorPicker` contains many sub widgets that are created
  # and added in the `createDummyChildren` method.
  #
  # Additionally, there's two `span` that serve to display the original color
  # in comparison next to the current color.
  createDummy: ->
    dummy = $ "<span class='colorpicker'>
                <span class='newColor'></span>
                <span class='oldColor'></span>
               </span>"

    # Clicking on the original color reset the widget.
    dummy.children(".oldColor").click =>
      @set "value", @originalValue

    dummy

  # Creates the widgets used by the dialog to manipulate
  # the color's components.
  createDummyChildren: ->
    # There's one `TextInput` for each component of the color
    # for both the `rgb` and `hsv` color space. And for each
    # components input, a `Radio` button is placed next to it
    # to allow the selection of the corresponding mode.
    @add @redInput        = @newInput "red", 3
    @add @redMode         = @newRadio "red"

    @add @greenInput      = @newInput "green", 3
    @add @greenMode       = @newRadio "green"

    @add @blueInput       = @newInput "blue", 3
    @add @blueMode        = @newRadio "blue"

    @add @hueInput        = @newInput "hue", 3
    @add @hueMode         = @newRadio "hue", true

    @add @saturationInput = @newInput "saturation", 3
    @add @saturationMode  = @newRadio "saturation"

    @add @valueInput      = @newInput "value", 3
    @add @valueMode       = @newRadio "value"

    # One for the hexadecimal form.
    @add @hexInput        = @newInput "hex", 6

    # And two `SquarePicker`.
    @add @squarePicker    = new SquarePicker
    @add @rangePicker     = new SquarePicker

    # One of the `SquarePicker` is locked on the x axis.
    @rangePicker.lockX()
    @rangePicker.addClasses "vertical"

  # Creates a `TextInput` with a maximum length of `maxlength`
  # and add the `cls` class to the input's dummy.
  newInput: (cls, maxlength) ->
    input = new TextInput
    input.addClasses cls
    input.set "maxlength", maxlength

    # The `ColorPicker` listen to all the children
    # `TextInput`s. The class added to the input is passed
    # to the listener to differenciate each input.
    input.valueChanged.add (w, v) =>
      @inputValueChanged w, v, cls
      true

    input
  # Creates a `Radio` with the specified class. Optionally
  # the checked property of the radio can be set to `true`.
  newRadio: (cls, checked=false) ->
    radio = new Radio
    radio.addClasses cls
    radio.set "checked", checked

    # Radios are automatically added in the group.
    @modesGroup.add radio
    radio

  # Invalidates the widget to force an update.
  invalidate: ->
    @update()

    # Since the `update` method can be called in the listener
    # of the `change` event of one of the children input the
    # value of this input cannot be change at that time.
    #
    # It means that if the submitted value was invalid, the widget
    # will not be able to revert to the initial value at the time
    # of the `update` call.
    #
    # The `update` method will then be called again with a small delay
    # to let the input end its event dispatch.
    setTimeout =>
      @update()
    , 10

  # Updates the current widget's value after changes made
  # to its children, the other children are also updated
  # with the current color components.
  update: () ->

    rnd = Math.round

    # The color's components are stored in individual variables.
    {r, g, b, h, s, v} = @model

    # The hexadecimal form is produced from the current red,
    # green and blue.
    value = rgb2hex r, g, b

    # The hexadecimal value is then affected as the
    # new value for this widgets.
    @["value"] = "##{value}"

    # All the affectation below will trigger `valueChanged` signals
    # on the children widgets, so the lock is activated.
    @inputValueSetProgrammatically = true

    # The current edit mode is updated as well with the current model.
    @get("mode").update @model

    # Each `TextInput` receive its new value. Each components value
    # for the `rgb` and `hsv` color space are rounded before affectation.
    # That way the model always stores discret values to avoid
    # inconsistencies in conversion results.
    @updateInput @redInput,        rnd r
    @updateInput @greenInput,      rnd g
    @updateInput @blueInput,       rnd b
    @updateInput @hueInput,        rnd h
    @updateInput @saturationInput, rnd s
    @updateInput @valueInput,      rnd v
    @updateInput @hexInput,        value

    # The lock is released.
    @inputValueSetProgrammatically = false

    # Finally the color preview `span` is updated.
    @dummy.children(".newColor").attr "style", "background: ##{value};"

  # Updates the value of the specified input.
  updateInput: (input, value) ->
    input.set "value", value

  setupDialog: (colorinput) ->
    # The original value is stored for allow a later reset.
    @originalValue = value = @caller.get "value"

    # The dialog's value is set on the current `ColorInput` value.
    @set "value", value

     # And the `span` meant to display the original value is updated.
    @dummy.children(".oldColor").attr "style", "background: #{value};"

  #### Comfirmation And Cancelation

  # Handles the changes comfirmation with the `Enter` key.
  comfirmChangesOnEnter: ->
    # If the command is triggered when on of the children inputs
    # has changes that haven't trigger a `change` event, the
    # widgets prevent the comfirmation to allow the submission
    # of the changes made to this input.
    unless @redInput.valueIsObsolete        or
           @greenInput.valueIsObsolete      or
           @blueInput.valueIsObsolete       or
           @hueInput.valueIsObsolete        or
           @saturationInput.valueIsObsolete or
           @valueInput.valueIsObsolete      or
           @hexInput.valueIsObsolete
      @comfirmChanges()

  # Comfirm the changes to the `ColorInput`. The dialog is hidden
  # a the end of the call.
  comfirmChanges: ->
    @caller.set "value", @get "value"
    @close()

  #### Properties Accessors

  # Changes the color edit mode for this dialog.
  set_mode: (property, value) ->
    oldMode = @[property]

    oldMode.dispose() if oldMode?
    if value?
      value.init this
      value.update @model

    @[property] = value

  # Changing the widget's value using the `value` setter
  # will feed the model with completely new datas from the passed-in color.
  set_value: (property, value) ->
    return @get "value" unless isValidValue value

    @fromHex value
    super property, value

  #### Internal Modification Methods

  # Sets the widget's model with an hexadecimal color.
  # The `#` prefix is optional.
  fromHex: (hex) ->

    v = if hex.indexOf("#") is -1 then "##{hex}" else hex

    if isValidValue v
      {red: r, green: g, blue: b} = colorObjectFromValue v
      @fromRGB r, g, b

  # Sets the widget's model with the three components of a `rgb` color.
  fromRGB: (r, g, b) ->

    r = parseFloat r
    g = parseFloat g
    b = parseFloat b

    if isValidRGB r, g, b
      [h, s, v] = rgb2hsv r, g, b
      @model = r:r, g:g, b:b, h:h, s:s, v: v

    @invalidate()

  # Sets the widget's model with the three components of a `hsv` color.
  fromHSV: (h, s, v) ->

    h = parseFloat h
    s = parseFloat s
    v = parseFloat v

    if isValidHSV h, s, v
      [r, g, b] = hsv2rgb h, s, v
      @model = r:r, g:g, b:b, h:h, s:s, v: v

    @invalidate()

  #### Signal Handlers

  # Catches the change made to the `RadioGroup` selection
  # and affect the corresponding edit mode.
  modeChanged: (widget, oldSel, newSel) ->
    switch newSel
      when @redMode        then @set "mode", @editModes[0]
      when @greenMode      then @set "mode", @editModes[1]
      when @blueMode       then @set "mode", @editModes[2]
      when @hueMode        then @set "mode", @editModes[3]
      when @saturationMode then @set "mode", @editModes[4]
      when @valueMode      then @set "mode", @editModes[5]

  # Receives the `valueChanged` signals from the children inputs.
  inputValueChanged: (widget, value, component) ->
    # But if the lock is activated the function will not proceed.
    unless @inputValueSetProgrammatically

      {r, g, b, h, s, v} = @model

      # According to the component the widget's value is changed.
      switch component
        when "red"        then @fromRGB value, g, b
        when "green"      then @fromRGB r, value, b
        when "blue"       then @fromRGB r, g, value

        when "hue"        then @fromHSV value, s, v
        when "saturation" then @fromHSV h, value, v
        when "value"      then @fromHSV h, s, value

        when "hex"        then @fromHex value

## Color Manipulation Modes

#<a name ="AbstractMode"></a>
#### AbstractMode

# The abstract class provides some basic behavior that are shared
# by each mode.
class AbstractMode
  # Registers the dialog that own the color mode.
  init: (dialog) ->
    @dialog = dialog
    @valuesSetProgrammatically = false

  # The `dispose` methods unregisters the signals listeners
  # and remove the content the mode added to the dialog.
  dispose: ->
    @dialog.rangePicker.valueChanged.remove @rangeChanged, this
    @dialog.squarePicker.valueChanged.remove @squareChanged, this

    @dialog.rangePicker.dummy.children(".layer").remove()
    @dialog.squarePicker.dummy.children(".layer").remove()

  # Initialize the setup for the two `SquarePicker` owns
  # by the `ColorPicker`.
  initPickers: (a, b, c, r, s) ->
    # The `a`, `b` and `c` arguments are the three ranges for the
    # axis of the `SquarePicker`.
    @dialog.squarePicker.set
      rangeX: a
      rangeY: b

    @dialog.rangePicker.set
      rangeY: c

    # Listeners are automatically registered on the `valueChanged`
    # signals of the `SquarePicker`.
    @dialog.rangePicker.valueChanged.add @rangeChanged, this
    @dialog.squarePicker.valueChanged.add @squareChanged, this

    # The additionnal content is built and added in the `SquarePicker`.
    @dialog.rangePicker.dummy.prepend $ r
    @dialog.squarePicker.dummy.prepend $ s

#<a name ="HSV"></a>
#### HSV Mode

# The `HSVMode` setup the `ColorPicker` such as the
# vertical ramp edit the `hue` component and the square
# picker edit the `saturation` and `value`.
class HSVMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,100],
                 [0,100],
                 [0,360],
                 "<span class='layer hue-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer hue-color'></span>
                    <span class='layer white-horizontal-ramp'></span>
                    <span class='layer black-vertical-ramp'></span>
                  </span>"

  update: (model) ->
    if model?
      {h, s, v} = model
      [r,g,b] = hsv2rgb h, 100, 100

      @valuesSetProgrammatically = true

      @dialog.squarePicker.set "value", [s, 100-v]
      @dialog.rangePicker.set "value", [0, 360-h]

      # The `HSV` mode change the background of the lowest
      # additional span with the current hue at full saturation
      # and value.
      value = rgb2hex r,g,b
      @dialog.squarePicker.dummy.find(".hue-color")
                    .attr "style", "background: ##{value};"

      @valuesSetProgrammatically = false

  updateDialog: (h, s, v) ->
    @valuesSetProgrammatically = true
    @dialog.fromHSV 360-h, s, 100-v
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [s, v] = value
      h = @dialog.rangePicker.get("value")[1]

      @updateDialog h, s, v

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [s, v] = @dialog.squarePicker.get "value"
      h = value[1]

      @updateDialog h, s, v

#<a name ="SHV"></a>
#### SHV Mode

# The `SHVMode` setup the `ColorPicker` such as the
# vertical ramp edit the `saturation` component and the square
# picker edit the `hue` and `value`.
class SHVMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,360],
                 [0,100],
                 [1,100],
                 "<span class='layer black-white-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer hue-horizontal-ramp'></span>
                    <span class='layer white-plain'></span>
                    <span class='layer black-vertical-ramp'></span>
                  </span>"

  update: (model) ->
    { h, s, v } = model
    opacity = 1-(s / 100)

    @valuesSetProgrammatically = true

    @dialog.squarePicker.set "value", [360-h, 100-v]
    @dialog.rangePicker.set "value", [0, 100-s]

    @valuesSetProgrammatically = false

    @dialog.squarePicker.dummy.find(".white-plain")
                  .attr "style", "opacity: #{opacity};"

  updateDialog: (h, s, v) ->
    @valuesSetProgrammatically = true
    @dialog.fromHSV 360-h, 100-s, 100-v
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [h, v] = value
      s = @dialog.rangePicker.get("value")[1]

      @updateDialog h, s, v

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [h, v] = @dialog.squarePicker.get "value"
      s = value[1]

      @updateDialog h, s, v

#<a name ="VHS"></a>
#### VHS Mode

# The `VHSMode` setup the `ColorPicker` such as the
# vertical ramp edit the `value` component and the square
# picker edit the `saturation` and `hue`.
class VHSMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,360],
                 [0,100],
                 [1,100],
                 "<span class='layer black-white-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer hue-horizontal-ramp'></span>
                    <span class='layer white-vertical-ramp'></span>
                    <span class='layer black-plain'></span>
                  </span>"

  update: (model) ->
    {h, s, v} = model
    opacity = 1-(v / 100)

    @valuesSetProgrammatically = true

    @dialog.squarePicker.set "value", [360-h, 100-s]
    @dialog.rangePicker.set "value", [0, 100-v]

    @valuesSetProgrammatically = false

    @dialog.squarePicker.dummy.find(".black-plain")
                  .attr "style", "opacity: #{opacity};"

  updateDialog: (h, s, v) ->
    @valuesSetProgrammatically = true
    @dialog.fromHSV 360-h, 100-s, 100-v
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [h, s] = value
      v = @dialog.rangePicker.get("value")[1]

      @updateDialog h, s, v

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [h, s] = @dialog.squarePicker.get "value"
      v = value[1]

      @updateDialog h, s, v

#<a name ="RGB"></a>
#### RGB Mode

# The `RGBMode` setup the `ColorPicker` such as the
# vertical ramp edit the `red` component and the square
# picker edit the `green` and `blue`.
class RGBMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,255],
                 [0,255],
                 [0,255],
                 "<span class='layer black-red-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer rgb-bottom'></span>
                    <span class='layer rgb-up'></span>
                  </span>"

  update: (model) ->
    {r, g, b} = model
    opacity = r / 255

    @valuesSetProgrammatically = true

    @dialog.squarePicker.set "value", [b, 255-g]
    @dialog.rangePicker.set "value", [0, 255-r]

    @valuesSetProgrammatically = false

    @dialog.squarePicker.dummy.find(".rgb-up")
                  .attr "style", "opacity: #{opacity};"

  updateDialog: (r, g, b) ->
    @valuesSetProgrammatically = true
    @dialog.fromRGB 255-r, 255 - g, b
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [b, g] = value
      r = @dialog.rangePicker.get("value")[1]

      @updateDialog r, g, b

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [b, g] = @dialog.squarePicker.get "value"
      r = value[1]

      @updateDialog r, g, b

#<a name ="GRB"></a>
#### GRB Mode

# The `RGBMode` setup the `ColorPicker` such as the
# vertical ramp edit the `green` component and the square
# picker edit the `red` and `blue`.
class GRBMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,255],
                 [0,255],
                 [0,255],
                 "<span class='layer black-green-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer grb-bottom'></span>
                    <span class='layer grb-up'></span>
                  </span>"

  update: (model) ->
    {r, g, b} = model
    opacity = g / 255

    @valuesSetProgrammatically = true

    @dialog.squarePicker.set "value", [b, 255-r]
    @dialog.rangePicker.set "value", [0, 255-g]

    @valuesSetProgrammatically = false

    @dialog.squarePicker.dummy.find(".grb-up")
                  .attr "style", "opacity: #{opacity};"

  updateDialog: (r, g, b) ->
    @valuesSetProgrammatically = true
    @dialog.fromRGB 255-r, 255 - g, b
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [b, r] = value
      g = @dialog.rangePicker.get("value")[1]

      @updateDialog r, g, b

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [b, r] = @dialog.squarePicker.get "value"
      g = value[1]

      @updateDialog r, g, b

#<a name ="BGR"></a>
#### BGR Mode

# The `RGBMode` setup the `ColorPicker` such as the
# vertical ramp edit the `blue` component and the square
# picker edit the `green` and `red`.
class BGRMode extends AbstractMode
  init: (dialog) ->
    super dialog

    @initPickers [0,255],
                 [0,255],
                 [0,255],
                 "<span class='layer black-blue-vertical-ramp'></span>",
                 "<span class='layer'>
                    <span class='layer bgr-bottom'></span>
                    <span class='layer bgr-up'></span>
                  </span>"

  update: (model) ->
    {r, g, b} = model
    opacity = b / 255

    @valuesSetProgrammatically = true

    @dialog.squarePicker.set "value", [g, 255-r]
    @dialog.rangePicker.set "value", [0, 255-b]

    @valuesSetProgrammatically = false

    @dialog.squarePicker.dummy.find(".bgr-up")
                  .attr "style", "opacity: #{opacity};"

  updateDialog: (r, g, b) ->
    @valuesSetProgrammatically = true
    @dialog.fromRGB 255 - r, g, 255 - b
    @valuesSetProgrammatically = false

  squareChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [g, r] = value
      b = @dialog.rangePicker.get("value")[1]

      @updateDialog r, g, b

  rangeChanged: (widget, value) ->
    unless @valuesSetProgrammatically
      [g, r] = @dialog.squarePicker.get "value"
      b = value[1]

      @updateDialog r, g, b

# Setup a unique instance of `ColorPicker` as the default listener
# for `ColorInput` instances.
ColorInput.defaultListener = new ColorPicker

$(document).ready -> ColorInput.defaultListener.attach "body"

@rgb2hsv      = rgb2hsv
@hsv2rgb      = hsv2rgb
@ColorInput   = ColorInput
@SquarePicker = SquarePicker
@ColorPicker  = ColorPicker
@HSVMode      = HSVMode
@SHVMode      = SHVMode
@VHSMode      = VHSMode
@RGBMode      = RGBMode
@GRBMode      = GRBMode
@BGRMode      = BGRMode
