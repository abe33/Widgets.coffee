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

    #### Replacement process

    # The `process` method receive a query set and loop through the
    # elements.
    process:( queryset )->
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
        unless $.widgetPlugin.radiogroups? then $.widgetPlugin.radiogroups = {}
        groups = $.widgetPlugin.radiogroups

        unless groups[ name ]? then groups[ name ] = new RadioGroup
        group = groups[ name ]

        group.add widget

    widget

$.widgetPlugin.register "radio",
                        $.widgetPlugin.inputWithType("radio"),
                        radioProcessor


