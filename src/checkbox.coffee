# Use the `CheckBox` widget to handle `checkbox` type input.
#
# Here some live instances :
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript'
#         src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript'
#         src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript'
#         src='../depends/signals.js'></script>
# <script type='text/javascript'
#         src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var checkbox1 = new CheckBox();
# var checkbox2 = new CheckBox();
# var checkbox3 = new CheckBox();
#
# checkbox2.set( "readonly", true );
# checkbox2.set( "checked", true );
# checkbox3.set( "disabled", true );
#
# checkbox1.attach("#livedemos");
# checkbox2.attach("#livedemos");
# checkbox3.attach("#livedemos");
# </script>
class CheckBox extends Widget

    # Defines the types that is allowed for a checkbox's `target`.
    #
    # `CheckBox` and its descendants are dedicated to work with
    # a unique type of inputs. This property allow to define the
    # type of allowed inputs for the class.
    targetType:"checkbox"

    constructor:(target)->
        super target

        #### Checkbox signals

        # The `checkedChanged` signal is dispatched when the `checked`
        # property of the widget is modified.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        #  * `checked`   : The new value for this widget's checked property.
        @checkedChanged = new Signal

        #### Shared Properties

        # The `values` property stores a tuple of two values that will be used
        # to fill the `value` property according to the current state.
        #
        # For instance :
        #
        #     checkbox = new CheckBox
        #     checkbox.set "values", [ "on", "off" ]
        #     console.log checkbox.get "value"
        #
        # Will output `off`.
        @values = [ true, false ]

        # The `checked` property reflect the `checked` attribute of the target.
        @checked = @booleanFromAttribute("checked", false)

        # The initial `checked` value is saved for a possible reset.
        @targetInitialChecked = @get "checked"

        # The `checked` property is mapped to a state on the dummy.
        @dummyStates = [ "checked", "disabled", "readonly", "required" ]

        #### Keyboard controls

        # Use the `enter` or `space` key to toggle the
        #  checkbox with the keyboard.
        @registerKeyUpCommand keystroke( keys.enter ), @actionToggle
        @registerKeyUpCommand keystroke( keys.space ), @actionToggle

        @updateStates()
        @hideTarget()

    #### Target management

    # The target for a `CheckBox` must be an `input` with a type `checkbox`.
    checkTarget:( target )->
        unless @isInputWithType target, "checkbox"
            throw new Error """CheckBox target must be an input
                               with a checkbox type"""

    #### Properties accessors

    # Setting the `checked` property also affect the `value` property.
    set_checked:( property, value )->
        @[ property ] = value
        @updateValue value, @get("values")
        @booleanToAttribute property, value
        @checkedChanged.dispatch this, value

    # Overrides the default behavior for the `value` setter.
    # Changing the `value` also modify the `checked` attribute
    # unless the setter was called internally.
    set_value:( property, value )->
        unless @valueSetProgrammatically
            @set "checked", value is @get("values")[0]
        super property, value

    # The `value` property is automatically updated when the `values`
    # change.
    set_values:( property, value )->
        @updateValue @get("checked"), value
        @[ property ] = value

    #### Dummy management

    # The dummy for the checkbox is just a `<span>` element
    # with a `checkbox` class.
    createDummy:->
        $ "<span class='checkbox'></span>"

    #### Checked state management

    # Toggle the state of the checkbox.
    toggle:->
        @set "checked", not @get "checked"

    # Use to toggle the state on a user action, with care
    # to the state of the widget.
    actionToggle:->
        unless @get("readonly") or @get("disabled")
            @toggle()

    # The `reset` function operate on both the `value`
    # and the `checked` state of the widget.
    reset:->
        super()
        @set "checked", @targetInitialChecked

    # Update the `value` property according to the passed-in
    # `checked` state and `values`.
    updateValue:( checked, values )->
        @valueSetProgrammatically = true
        @set "value", if checked then values[0] else values[1]
        @valueSetProgrammatically = false

    #### Dummy events handlers

    # Toggle the checkbox on a user click.
    click:(e)->
        @actionToggle()

        # Grabing the focus on a click is only allowed
        # when the widget is not disabled.
        unless @get "disabled"
            @grabFocus()

@CheckBox = CheckBox
