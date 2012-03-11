# <link rel="stylesheet" href="../css/styles.css" media="screen">

$.fn.extend
    # The jQuery `widgets` function performs a replacement
    # of the inputs, selects and textareas in the current
    # query set.
    #
    # The replacement mecanic itself is handled by an instance
    # of the `WidgetPlugin` class.
    widgets:->
        $.widgetPlugin.process $ this

## WidgetPlugin

# The `WidgetPlugin` class provides controls over the replacement
# of HTML elements by Widgets.
class WidgetPlugin
    constructor:->
        @processors = {}

    #### Processors Management
    #
    # The `WidgetPlugin` class deals with replacement through
    # processor functions.
    #
    # A processor function handle the creation of the widget
    # corresponding to one or more HTML elements types.

    # A processor function is registered through the `register`
    # method.
    # The register method takes the following arguments :
    #
    # * `id`: A string that will identify the processor
    # in the plugin instance.
    # * `match`: Either a string or a function.
    # If a string is passed it will be used to match the node name.
    # If a function is passed, the node itself will be passed to the
    # function, the function return `true` if the node match the requirement
    # for the processor.
    # * `processor`: A function that takes a node as argument and that
    # should return a widget instance for the passed-in node.
    register:( id, match, processor )->
        unless processor?
            throw new Error "The processor function can't be null in register"

        @processors[ id ] = [ match, processor ]

    # Use the `registerWidgetFor` method to register a Widget class
    # with a match. The registered processor is a simple function that
    # instanciate a widget with the target as argument.
    registerWidgetFor:( id, match, widget )->
        unless widget?
            throw new Error "The widget class can't be null
                             in registerWidgetFor"

        @register id, match, (target)->
            new widget target

    # Returns `true` if a processor is registered for the passed-in `id`.
    isRegistered:(id)->
        id of @processors

    #### Replacement Process

    # The `process` method receive a query set and loop through the
    # elements.
    process:( queryset )->
        widgets = []
        queryset.each ( i, o )=>
            target = $ o

            # HTML elements that have already been processed once
            # are flagged with the `widget-done` class.
            if target.hasClass "widget-done" then return

            # A reference to the next sibling and the parent
            # of the node are retreived for a later use.
            next   = target.next()
            parent = target.parent()

            # For a given element, each processor are tested
            # against the element.
            for id, [ match, processor ] of @processors

                # The processor match is tested against the
                # node according to the match type.
                elementMatched = if $.isFunction match
                    match.call this, o
                else
                    o.nodeName.toLowerCase() is match

                if elementMatched
                    # When the processor match, it's called
                    # with the plugin as context and the element
                    # as argument
                    widget = processor.call this, o
                    widgets.push widget

                    # The produced widget is then inserted in the DOM
                    # after its target.
                    #
                    # Since some widgets insert their target as their child
                    # the next element is used to insert the widget in place.
                    # If the element was at the end of its parent, the parent
                    # is used instead.
                    if widget?
                        if next.length > 0
                            widget.before next
                        else
                            widget.attach parent

                    # Once a processor matched, the loop is breaked.
                    break

        return widgets

    #### Matching Utilities

    # Returns `true` if the passed-in argument is a `HTMLElement` instance.
    isElement:(o)->
        if typeof HTMLElement is "object"
            o instanceof HTMLElement
        else
            typeof o is "object" and
            o.nodeType is 1 and
            typeof o.nodeName is "string"

    # Returns `true` if the passed-in argument is a `HTMLElement`
    # with its `nodeName` equal to `tag`.
    isTag:( o, tag )->
        @isElement( o ) and o?.nodeName?.toLowerCase() is tag

    # Returns `true` if the passed-in argument is an `input` node
    # with a type attribute contains in `types`.
    isInputWithType:( o, types... )->
        @isTag( o, "input" ) and $( o ).attr("type") in types

    # Returns a function that will match an element with the
    # `isInputWithType` function.
    inputWithType:( types... )->
        ( o )-> @isInputWithType.apply this, [ o ].concat types

#### Plugin Setup


# An instance of the plugin class is available as a property of the `$`
# object.
$.widgetPlugin = new WidgetPlugin

# Default processors for the plugin handles most of the HTML5 form elements.
$.widgetPlugin.registerWidgetFor "textarea",
                                 "textarea",
                                  TextArea

$.widgetPlugin.registerWidgetFor "select",
                                 "select",
                                 SingleSelect

$.widgetPlugin.registerWidgetFor "textinput",
                                 $.widgetPlugin.inputWithType( "text",
                                                               "password"),
                                 TextInput

$.widgetPlugin.registerWidgetFor "button",
                                  $.widgetPlugin.inputWithType( "button",
                                                                "reset",
                                                                "submit" ),
                                  Button

$.widgetPlugin.registerWidgetFor "range",
                                 $.widgetPlugin.inputWithType( "range" ),
                                 Slider

$.widgetPlugin.registerWidgetFor "number",
                                 $.widgetPlugin.inputWithType("number"),
                                 Stepper

$.widgetPlugin.registerWidgetFor "checkbox",
                                  $.widgetPlugin.inputWithType("checkbox"),
                                  CheckBox

$.widgetPlugin.registerWidgetFor "color",
                                 $.widgetPlugin.inputWithType("color"),
                                 ColorInput

$.widgetPlugin.registerWidgetFor "file",
                                 $.widgetPlugin.inputWithType("file"),
                                 FilePicker

$.widgetPlugin.registerWidgetFor "time",
                                 $.widgetPlugin.inputWithType("time"),
                                 TimeInput

$.widgetPlugin.registerWidgetFor "date",
                                 $.widgetPlugin.inputWithType("date"),
                                 DateInput

$.widgetPlugin.registerWidgetFor "month",
                                 $.widgetPlugin.inputWithType("month"),
                                 MonthInput

$.widgetPlugin.registerWidgetFor "week",
                                 $.widgetPlugin.inputWithType("week"),
                                 WeekInput

$.widgetPlugin.registerWidgetFor "datetime",
                                 $.widgetPlugin.inputWithType("datetime"),
                                 DateTimeInput

$.widgetPlugin.registerWidgetFor "datetime-local",
                                 $.widgetPlugin.inputWithType(
                                     "datetime-local"),
                                 DateTimeLocalInput

# The radio input are a special case since each radio that have the same name
# are part of a group.
radioProcessor=( o )->
    widget = new Radio o
    name = widget.get "name"

    # For all radios that have a name, a `RadioGroup` stored with
    # the radios name is created and filled with the `Radio` widgets.
    if name?
        @radiogroups = {} unless @radiogroups?
        @radiogroups[ name ] = new RadioGroup unless @radiogroups[ name ]?

        group = @radiogroups[ name ]
        group.add widget

    widget

$.widgetPlugin.register "radio",
                        $.widgetPlugin.inputWithType("radio"),
                        radioProcessor

# Forms are another special case. When a `form` node is encountered,
# the processor will create a new form object on the plugin. This object
# will contains the widgets generated by a call to the `widgets` function
# on the form components in this form.
formProcessor=(o)->
    # The `forms` property is created lazily.
    @forms = [] unless @forms?

    form = $(o)
    resetButtons = []
    submitButtons = []

    widgets = form.find("input, textarea, select").widgets()

    # Reset is not handled by the browser. The click on a reset button prevent
    # the default behavior, instead, the buttons in a form will receive
    # a custom action that call the `reset` method on all the widgets
    # the forms, excepted the `Button` instances (they don't have a value
    # to reset).
    reset=->
        widget.reset() for widget in widgets when widget not instanceof Button

    # Looping through all the widgets to find the reset and submit buttons
    # and affect it to their respective array.
    for widget in widgets
        submitButtons.push widget if widget.jTarget.attr("type") is "submit"

        if widget.jTarget.attr("type") is "reset"
            resetButtons.push widget

            # Reset buttons receive a custom action, where display is the
            # value of the button and action is the local `reset` function
            # created previously.
            widget.set "action",
                display:widget.jTarget.attr("value"),
                action:reset

    # The form object is then created and pushed into the forms collection
    # of the plugin.
    @forms.push
        method:form.attr "method"
        action:form.attr "action"
        widgets:widgets
        resetButtons:resetButtons
        submitButtons:submitButtons

    # The form node doesn't have any widget associated with it
    # so the processor return `null`.
    return null

$.widgetPlugin.register "form", "form", formProcessor

