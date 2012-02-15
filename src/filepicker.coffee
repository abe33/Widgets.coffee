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
# <script type='text/javascript' src='../lib/widgets.js'></script>
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
# picker1.attach("#livedemos");
# picker2.attach("#livedemos");
# picker3.attach("#livedemos");
# </script>
class FilePicker extends Widget

    @mixins FocusProvidedByChild

    constructor:(target)->

        # The `target` is mandatory in the `FilePicker` constructor so a default
        # target is created when nothing is passed to the constructor. 
        unless target? then target = $("<input type='file'></input>")[0]

        super target

        # The target is hidden when the widget is either readonly or disabled.
        if @cantInteract() then @hideTarget()

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
    change:(e)->
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
        @focusProvider = @jTarget

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
   
    
# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.FilePicker = FilePicker