# The `TextArea` widget wrap the target within a `span` in order to
# allow custom styling.
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
# var area1 = new TextArea();
# var area2 = new TextArea();
# var area3 = new TextArea();
#
# area1.set( "value", "hello" );
# area2.set( "value", "readonly" );
# area3.set( "value", "disabled" );
# 
# area2.set( "readonly", true );
# area3.set( "disabled", true );
# 
# $("#livedemos").append( area1.dummy );
# $("#livedemos").append( area2.dummy );
# $("#livedemos").append( area3.dummy );
# </script>
class TextArea extends Widget
    constructor:(target)->

        # The `target` is mandatory in the `TextArea` constructor so a default
        # target is created when nothing is passed to the constructor. 
        unless target?
            target = $("<textarea></textarea")[0]

        super target
        
        @valueIsObsolete = false

    #### Target management

    # The target for a `TextArea` must be a `textarea` node.
    checkTarget:(target)->
        unless @isTag target, "textarea"
            throw "TextArea only allow textarea nodes as target"
    
    #### Dummy management

    # The dummy for a `TextArea` is a `span` with a `textarea` class on it.
    createDummy:->
        dummy = $ "<span class='textarea'></span>"
        dummy.append @target
        dummy
    
    #### Events handling
    #
    # The text area widget is a special case, as it don't receive 
    # focus directly of its dummy.
    # Instead, whenever the focus is given to the widget, 
    # its the widget's target that will receive it.
    
    # In the same way, keyboard inputs are handled from the input
    # and not from the dummy.
    targetSupportedEvents:"focus blur keyup keydown keypress input change"
    
    supportedEvents:"mousedown mouseup mousemove mouseover mouseout mousewheel click dblclick"

    # In this regards, the events registrations methods are overridden.
    registerToDummyEvents:->
        @jTarget.bind @targetSupportedEvents, (e)=>
            @[e.type].apply this, arguments 
        super()
    
    unregisterFromDummyEvents:->
        @jTarget.unbind @targetSupportedEvents
        super()

    # When the user types some text in the target, the widget's
    # value is marked as obsolete. 
    input:(e)->
        @valueIsObsolete = true
    
    # When the `change` event occurs, the content of the
    # target is saved as the new widget's value and the obsolete
    # flag is set to `false`.
    # 
    # The flag is unset after the value's affectation, and since 
    # a `valueChanged` signal is dispatched, the `valueIsObsolete`
    # property allow a listener to know if the change done to the
    # widget was done by a user input.
    change:(e)->
        @set "value", @jTarget.val()
        @valueIsObsolete = false
        true

    # Releasing the mouse over the widget gives it the focus.
    mouseup:->
        unless @get "disabled"
            @grabFocus()
        true

    #### Focus management

    # There's no need for the dummy to be able to receive the focus. So
    # a `TexArea` dummy will never have the `tabindex` attribute set.
    setFocusable:->

    # Grabbing the focus for this widget is giving the focus to its target.
    grabFocus:->
        @jTarget.focus()

    
# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.TextArea = TextArea