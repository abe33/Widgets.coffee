# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# A Widget allow to work with or without a target `<input>` node, and provides
# methods to reflect changes done on the widget onto its target.
class Widget extends Module

    # Pass a `<input>` node to the constructor to define the widget's target.
    # An error is raised if the passed-in node's name is not `input` or if
    # the arguments is not a node.
    constructor:( target )->
        # If a target is provided to a widget, that target will
        # be verified in the `checkTarget` method.
        if target? then @checkTarget target

        #### Widget signals

        # The `propertyChanged` signal is dispatched when a call
        # to the `set` method is performed.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        #  * `property`  : The property that was modified.
        #  * `value`     : The new value for this property.
        @propertyChanged = new Signal

        # The `valueChanged` signal is dispatched when the `value`
        # property of the widget is modified.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        #  * `value`     : The new value for this widget.
        @valueChanged    = new Signal

        # The `stateChanged` signal is dispatched when the state
        # of the widget's dummy is modified.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        #  * `state`     : The new state of the dummy.
        @stateChanged    = new Signal

        # The `attached` signal is dispatched when the widget
        # is added to the DOM with the `attach` method.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        @attached        = new Signal

        # The `detached` signal is dispatched when the widget
        # is removed from the DOM with the `detach` method.
        #
        # *Callback arguments*
        #
        #  * `widget`    : The widget that was modified.
        @detached        = new Signal


        #### Widget's target related properties.

        # The `jTarget` property contains the `jQuery` object
        # for the target. However, if `target` is `null`,
        # the `jTarget` property will be `null` as well.
        @target    = target
        @hasTarget = target?
        @jTarget   = if @hasTarget then $ target else null

        #### Shared Properties

        # The shared properties represent the properties of the input that
        # are available from and reflected on the widget. These properties
        # are accessible only through the `get` and `set` method.
        # For instance, to disable the widget use the following code:
        #
        #     widget.set "disabled", true

        # Default properties's values are retreived from the target or set to
        # `undefined` if there's no target specified.
        @properties =
            disabled : @booleanFromAttribute "disabled"
            readonly : @booleanFromAttribute "readonly"
            required : @booleanFromAttribute "required"
            value    : @valueFromAttribute   "value"
            name     : @valueFromAttribute   "name"
            id       : null

        # Dummy creation is done in the `createDummy` method.
        @dummy = @createDummy()
        @hasDummy = @dummy?
        @hasFocus = false

        # Since there's no way to know if an object is a descendant
        # of the Widget class, this property will act as a marker
        # for widget's instances.
        @isWidget = true

        # When added as child in a `Container` the `parent` property
        # store a reference to the parent.
        @parent = null

        # The commands for `keydown` and `keyup` events are stored
        # in two different objects.
        @keyDownCommands = {}
        @keyUpCommands = {}

        # Additional setup if a target have been specified
        if @hasTarget

            # Storing the initial value for reset.
            @targetInitialValue = @get "value"

            # Bind target's change event to handle it internally.
            @jTarget.bind "change", (e)=>
                @targetChange(e)

            # Flag the target to prevent the jquery plugins to iterate over
            # the input target of the widget.
            @jTarget.addClass "widget-done"

        # Additional setup if a dummy have been created.
        if @hasDummy
            # The `dummyStates` property stores the list of shared properties
            # that should be reflected as a class on the dummy. The order
            # of the states in the list are preserved in the dummy's class
            # attribute.
            @dummyStates = [ "disabled", "readonly", "required" ]

            # Enforce the ability of the dummy to receive focus if enabled.
            @setFocusable not @get "disabled"

            # The original class of the dummy is stored for later use.
            @dummyClass = @dummy.attr "class"

            if @hasTarget
                # The style set on the target is copied on the dummy.
                @dummy.attr "style", @jTarget.attr "style"

                # If the target had an `id` attribute, the widget's id
                # will be derived from it such as `#{ original id }-widget`.
                id = @jTarget.attr "id"
                if id? and id isnt "" then @set "id", "#{ id }-widget"

            @registerToDummyEvents()
            @updateStates()

        super()

    #### Shared Properties accessors
    #
    # Since changes made on the widget should be reflected
    # on the target, its necessary to provide an accessor-like
    # mechanism.
    #
    # The `get` and `set` methods provides this mechanism.
    # Custom accessors can be specified for these properties.
    # Accessors definition can be done in the `createProperty`
    # method below.

    # When called, the `get` method will check for the existence
    # of a custom getter handler for the property, if one exist
    # the result of the call is returned, otherwise the value
    # stored in the property is returned.
    get:( property )->
        if "get_#{property}" of this
            @[ "get_#{property}" ].call this, property
        else
            @properties[ property ]

    # The `set` method allow two way of use, the first is
    # two pass the property's name as the first argument
    # and the value as the second argument, such as :
    #
    #     widget.set "name", "someName"
    #
    # The second way is by passing an object to the method
    # to modify several properties in one call, such as :
    #
    #     widget.set
    #         name:"someName"
    #         value:"someValue"
    set:( propertyOrObject, value = null )->
        if typeof propertyOrObject is "object"
            for k, v of propertyOrObject
                @handlePropertyChange k, v
        else
            @handlePropertyChange propertyOrObject, value

    # The `handlePropertyChange` realize the concrete action
    # of a changing a property.
    handlePropertyChange:( property, value )->
        if property of @properties
            if "set_#{property}" of this
                @[ "set_#{property}" ].call this, property, value
            else
                @properties[ property ] = value

        @updateStates()
        @propertyChanged.dispatch this, property, value

    # Creates a new property for this widget, optionally accessors functions
    # can be provided. In any case, the property will be readable and writable.
    #
    # Accessors functions are called with the current widget as scope.
    #
    # The setter accessor must affect the value to the property and then
    # return the final value. If the target should change after the modification
    # of the property, the setter should take care of the reflecting
    # the changes on the target.
    #
    # When creating a new property in a children class, define the accessors
    # functions as methods in the class body to allow overrides in subclasses.
    createProperty:( property, value=undefined, setter=null, getter=null )->
        @properties[ property ] = value

        if setter? then @[ "set_#{property}" ] = setter
        if getter? then @[ "get_#{property}" ] = getter

    # The accessors functions for the widget's properties.
    #
    # Setters accessors are prefixed with `set_` and getters's one with `get_`.
    set_disabled:( property, value )->
        @properties[ property ] = @booleanToAttribute property, value
        # Disabled widget don't allow to receive focus.
        @setFocusable not value

    # Read-only widgets don't allow their `value` to be changed.
    set_readonly:( property, value )->
        @properties[ property ] = @booleanToAttribute property, value

    # Required widgets prevents a form to be submitted if it don't validate.
    set_required:( property, value )->
        @properties[ property ] = @booleanToAttribute property, value

    # Sets the value of both the widget and its target if the widget
    # allow it.
    set_value:( property, value )->
        # Read-only widgets don't allow to modify their values.
        if @get "readonly"
            return @get property
        else
            if value isnt @get property
                @properties[ property ] = value
                @valueToAttribute property, value
                @valueChanged.dispatch this, value

    # Sets the name of the target.
    set_name:( property, value )->
        @properties[ property ] = @valueToAttribute property, value

    # The `id` setter operate only on the dummy, and not on the target.
    # It preserve the uniqueness of ids of the form inputs (given that
    # they are originally unique).
    set_id:( property, value )->
        if value?
            @dummy.attr "id", value
        else
            @dummy.removeAttr "id"

        @properties[ property ] = value

    #### Target management

    # Verify that the passed-in target is valid and throw an error
    # if itsn't the case.
    #
    # By default a `target` can be any `HTMLElement`.
    checkTarget:( target )->
        unless @isElement target
            throw new Error "Widget's target should be a node"

    # A function that verify that the passed-in argument
    # is an HTML element.
    isElement:( o )->
        if typeof HTMLElement is "object"
            o instanceof HTMLElement
        else
            typeof o is "object" and
            o.nodeType is 1 and
            typeof o.nodeName is "string"

    # A function that verify that the passed-in argument
    # is a `tag` node.
    isTag:( o, tag )->
        @isElement( o ) and o?.nodeName?.toLowerCase() is tag

    # A function that verify that the passed-in object is
    # an input node with a type contained in `types`.
    isInputWithType:( o, types... )->
        @isTag( o, "input" ) and $( o ).attr("type") in types

    # Hide the target if provided.
    hideTarget:->
        if @hasTarget
            @jTarget.hide()

    # Reset the target as a `<input type='reset'>` could do.
    reset:->
        @set "value", @targetInitialValue

    # A placeholder for the target's change event.
    targetChange:( e )->

    #### Dummy management

    # Returns `true` when the widget is not in a state that allow
    # a change to the value with a user interaction.
    cantInteract:->
        @get("readonly") or @get("disabled")

    # A placeholder for dummy creation.
    # The method must return the dummy jQuery object.
    createDummy:->

    # Updates the state of the dummy according to the current values
    # in the widget's properties.
    updateStates:->
        if @hasDummy
            oldState = @dummy.attr "class"
            newState = ""
            for state in @dummyStates
                if @get state
                    if newState.length > 0
                        newState += " "

                    newState += state

            # Since some widgets will place the focus on a dummy's child
            # instead of the dummy itself, the `focus` state is reflected
            # in the dummy's class attribute.
            if @hasFocus then newState = "focus #{newState}"

            # Original and state classes are concatened
            # to produce the output dummy class.
            outputState = if @dummyClass? and newState isnt ""
                @dummyClass + " " + newState
            else if @dummyClass?
                @dummyClass
            else
                newState

            if outputState isnt oldState
                @dummy.attr "class", outputState
                @stateChanged.dispatch this, newState

    # Adds a list of classes in the dummy `class` attribute.
    addClasses:( classes... )->
        dummyClasses = @dummyClass.split " "

        for cl in classes
            if cl not in dummyClasses
                dummyClasses.push cl

        @dummyClass = dummyClasses.join " "
        @updateStates()

    # Removes a list of classes from the dummy `class` attribute.
    removeClasses:( classes... )->
        dummyClasses = @dummyClass.split " "
        output = []
        for cl in dummyClasses
            if cl not in classes
                output.push cl

        @dummyClass = output.join " "
        @updateStates()

    # Append the widget's dummy to the passed-in target.
    # The `target` can be either a string or a `jQuery` object.
    attach:( target )->
        @handleDOMInsertion target, "append"

    # Insert the widget's dummy before the passed-in `target`.
    before:( target )->
        @handleDOMInsertion target, "before"

    # Insert the widget's dummy after the passed-in `target`.
    after:( target )->
        @handleDOMInsertion target, "after"

    # Handles the insertion of the widget's dummy in the DOM.
    handleDOMInsertion:( target, action )->
        if target?
            target = $ target if typeof target is "string"
            target[ action ] @dummy
            @attached.dispatch this

    # Detach the widget's dummy from the DOM.
    detach:->
        @dummy.detach()
        @detached.dispatch this

    #### Dummy Events Handling

    # Register this widget to the events of its dummy.
    registerToDummyEvents:->
        @dummy.bind @supportedEvents, ( e )=>
            @[e.type].apply this, arguments

    # Unregister all the events from the dummy.
    unregisterFromDummyEvents:->
        @dummy.unbind @supportedEvents

    # The list of the dummy's events supported by the widget.
    # All these events are catched by the methods with
    # the corresponding name in the widget class.
    supportedEvents:[
        "mousedown", "mouseup",    "mousemove", "mouseover",
        "mouseout",  "mousewheel", "click",     "dblclick",
        "focus",     "blur",       "keyup",     "keydown",
        "keypress",
    ].join " "

    # Override these placeholders to implement the concrete events
    # handlers of a widget class.
    #
    # **Note:** Be aware that, unfortunately, all browsers doesn't
    # support the `focus` and `blur` events on nodes other than
    # `input`, `textarea`, `select` and `a`. And since keyboard events
    # on DOM objects are only available when the object has the focus
    # you will lose the keyboard events as side effect.
    mousedown :-> true
    mouseup   :-> true
    mousemove :-> true
    mouseover :-> true
    mouseout  :-> true
    mousewheel:-> true
    click     :-> true
    dblclick  :-> true

    # Default behavior is to allow focus only if the widget is enabled.
    focus:( e )->
        @hasFocus = true if not @get "disabled"
        @updateStates()
        not @get "disabled"

    blur:( e )->
        @hasFocus = false
        @updateStates()
        true

    # Trigger the command registered with the `keydown` event if any.
    keydown:( e )->
        @triggerKeyDownCommand e

    # Trigger the command registered with the `keyup` event if any.
    keyup:( e )->
        @triggerKeyUpCommand e

    keypress:( e )->
        true

    #### Focus management

    # Set the focusable state of the dummy.
    # It simply toggle the `tabindex` attributes
    # on the dummy to ensure that it cannot receive focus.
    setFocusable:( allowFocus )->
        if @hasDummy
            if allowFocus then @dummy.attr "tabindex", 0
            else @dummy.removeAttr "tabindex"

    # Place the focus on this widget.
    grabFocus:->
        if @hasDummy then @dummy.focus()

    # Remove the focus from this widget.
    releaseFocus:->
        if @hasDummy then @dummy.blur()

    #### Keyboard shortcuts management

    # Register the passed-in function to be triggered
    # when the keystroke `ks` is matched on `keydown`.
    registerKeyDownCommand:( ks, command )->
        @keyDownCommands[ ks ] = [ ks, command ]

    # Register the passed-in function to be triggered
    # when the keystroke `ks` is matched on `keyup`.
    registerKeyUpCommand:( ks, command )->
        @keyUpCommands[ ks ] = [ ks, command ]

    # Returns `yes` if the passed-in keystroke have been associated
    # with a command for this widget's `keydown` event.
    hasKeyDownCommand:( ks )->
        ks of @keyDownCommands

    # Returns `yes` if the passed-in keystroke have been associated
    # with a command for this widget's `keyup` event.
    hasKeyUpCommand:( ks )->
        ks of @keyUpCommands

    # Takes a keyboard event object and trigger
    # the corresponding command on a `keydown`.
    triggerKeyDownCommand:( e )->
        for key, [ ks, command ] of @keyDownCommands
            if ks.match e
                return command.call this, e

        # Keyboards events are bubbled to the parent.
        if @parent? then @parent.triggerKeyDownCommand e
        true

    # Takes a keyboard event object and trigger
    # the corresponding command on a `keyup`.
    triggerKeyUpCommand:( e )->
        for key, [ ks, command ] of @keyUpCommands
            if ks.match e
                return command.call this, e

        # Keyboards events are bubbled to the parent.
        if @parent? then @parent.triggerKeyUpCommand e
        true

    #### Target Attributes Management

    # Uses theses methods to retreive or copy data from the target's attributes.
    valueFromAttribute:( property, defaultValue = undefined )->
        if @hasTarget then @jTarget.attr property else defaultValue

    valueToAttribute:( property, value )->
        if @hasTarget then @jTarget.attr property, value
        value

    # The following two methods handle the special case of attributes
    # for which only presence is meaningful.
    booleanFromAttribute:( property, defaultValue = undefined )->
        if @hasTarget then @jTarget.attr( property ) isnt undefined
        else defaultValue

    booleanToAttribute:( property, value )->
        if @hasTarget
            if value then @jTarget.attr property, property
            else @jTarget.removeAttr property
        value

@Widget = Widget
