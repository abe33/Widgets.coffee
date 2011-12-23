# The `FilePicker` widget is a special case, since the `file` input behavior
# cannot be emulate through javascript the real target is used as the trigger
# for the widget's action.
#
# In that regards the testability of the widget cannot be guaranted concerning
# the behavior of the target. Click emulation through javascript on a `file` input
# is generally considered as opening a popup and then prevented by the browser.
#
# Here some live instances : 
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../widgets.js'></script>
#
# <script type='text/javascript'>
# var picker1 = new FilePicker( $("<input type='file'></input>")[0] );
# var picker2 = new FilePicker( $("<input type='file'></input>")[0] );
# var picker3 = new FilePicker( $("<input type='file'></input>")[0] );
# 
# picker2.set( "readonly", true );
# picker2.set( "checked", true );
# picker3.set( "disabled", true );
# 
# $("#livedemos").append( picker1.dummy );
# $("#livedemos").append( picker2.dummy );
# $("#livedemos").append( picker3.dummy );
# </script>
class FilePicker extends Widget
    constructor:(target)->

        # The `target` is mandatory in the `FilePicker` constructor so a default
        # target is created when nothing is passed to the constructor. 
        unless target? 
            target = $("<input type='file'></input>")[0]

        super target

        # The target is hidden when the widget is either readonly or disabled.
        if @cantInteract() then @hideTarget()

        # Target's changes are binded to an internal callback.
        @jTarget.bind "change", (e)=>
            @targetChange e

    #### Target management

    # The target for a `FilePicker` must be an input with the type `file`.
    checkTarget:( target )->
        unless @isInputWithType target, "file"
            throw "FilePicker must have an input file as target"

    # Display the target if defined.
    showTarget:->
        if @hasTarget then @jTarget.show()
    
    # When the target changed the `value`'s text is then replaced with
    # the new value. 
    targetChange:(e)->
        @setValueLabel if @jTarget.val()? then @jTarget.val() else "Browse"
        @dummy.attr "title", @jTarget.val()
    
    #### Dummy management
    
    # The dummy for a `FilePicker` is a `span` with a `filepicker` class on it.
    createDummy:->
        # It contains two `span` children for an icon and the value display.
        dummy = $ "<span class='filepicker'>
                    <span class='icon'></span>
                    <span class='value'>Browse</span>
                 </span>"
        # The widget's target is part of the dummy, at the top.
        # Generally the target's opacity should be set to `0`
        # in a stylesheet. And its position should be absolute
        # within the widget in order to cover the whole widget
        # and allow the click to take effect.
        dummy.append @jTarget

        dummy
    
    # This method allow to test the change of the `value`'s text.
    setValueLabel:( label )->
        @dummy.children(".value").text label
    
    #### Properties Accessors

    # Disabling a `FilePicker` hides the target, in the contrary
    # enabling the widget will display the target again.
    set_disabled:( property, value )->
        if value then @hideTarget() else unless @get("readonly") then @showTarget()
        super property, value
    
    # When a widget allow writing in it, the target is visible, otherwise the
    # target is hidden. 
    set_readonly:( property, value )->
        if value then @hideTarget() else unless @get("disabled") then @showTarget()
        super property, value
   
    #### Events handling
    #
    # The file picker widget is a special case, as it don't receive 
    # focus directly of its dummy.
    # Instead, whenever the focus is given to the widget, 
    # its the widget's input that will receive it.
    
    # In the same way, keyboard inputs are handled from the input
    # and not from the dummy.
    inputSupportedEvents:"focus blur keyup keydown keypress"

    supportedEvents:"mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick"

    # In this regards, the events registrations methods are overridden.
    registerToDummyEvents:->
        @jTarget.bind @inputSupportedEvents, (e)=>
            @[e.type].apply this, arguments 
        super()
    
    unregisterFromDummyEvents:->
        @jTarget.unbind @inputSupportedEvents
        super()
    
    #### Focus management

    # There's no need for the dummy to be able to receive the focus. So
    # a `FilePicker` dummy will never have the `tabindex` attribute set.
    setFocusable:->

    # Grabbing the focus for this widget is giving the focus to its target.
    grabFocus:->
        @jTarget.focus()
    
# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.FilePicker = FilePicker