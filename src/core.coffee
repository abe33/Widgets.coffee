# <link rel="stylesheet" href="../css/styles.css" media="screen">

$.fn.extend
    widgets:->
        $.widgetPlugin.process $ this

class WidgetPlugin
    constructor:->
        @processors = {}
    
    register:( id, match, processor )->
        unless processor? then throw "The processor function can't be null in register"

        @processors[ id ] = [ match, processor ]
    
    registerWidgetFor:( id, match, widget )->
        unless widget? then throw "The widget class can't be null in registerWidgetFor"

        @register id, match, (target)->
            new widget target
    
    isRegistered:(id)->
        id of @processors
    
    process:( queryset )->
        queryset.each ( i, o )=>
            target = $ o
            next   = target.next()
            parent = target.parent()

            if target.hasClass "widget-done" then return

            for id, [ match, processor ] of @processors
                elementMatched = if $.isFunction match
                    match.call this, o
                else
                    o.nodeName.toLowerCase() is match

                if elementMatched 
                    widget = processor.call this, o
            
                    if widget?
                        if next.length > 0
                            next.before widget.dummy
                        else 
                            parent.append widget.dummy
                    
                    break
    
    isElement:(o)->
        if typeof HTMLElement is "object" 
            o instanceof HTMLElement 
        else
            typeof o is "object" and
            o.nodeType is 1 and 
            typeof o.nodeName is "string"
    
    isTag:( o, tag )->
        @isElement( o ) and o?.nodeName?.toLowerCase() is tag
    
    isInputWithType:( o, types... )->
        @isTag( o, "input" ) and $( o ).attr("type") in types
    
    inputWithType:( types... )->
        ( o )-> @isInputWithType.apply this, [ o ].concat types 
             
                    
$.widgetPlugin = new WidgetPlugin

$.widgetPlugin.registerWidgetFor "textarea",    "textarea",                                                 TextArea
$.widgetPlugin.registerWidgetFor "select",      "select",                                                   DropDownList
$.widgetPlugin.registerWidgetFor "textinput",   $.widgetPlugin.inputWithType("text", "password"),           TextInput
$.widgetPlugin.registerWidgetFor "button",      $.widgetPlugin.inputWithType("button", "reset", "submit"),  Button
$.widgetPlugin.registerWidgetFor "range",       $.widgetPlugin.inputWithType("range"),                      Slider
$.widgetPlugin.registerWidgetFor "number",      $.widgetPlugin.inputWithType("number"),                     Stepper
$.widgetPlugin.registerWidgetFor "checkbox",    $.widgetPlugin.inputWithType("checkbox"),                   CheckBox
$.widgetPlugin.registerWidgetFor "color",       $.widgetPlugin.inputWithType("color"),                      ColorPicker
$.widgetPlugin.registerWidgetFor "file",        $.widgetPlugin.inputWithType("file"),                       FilePicker

$.widgetPlugin.register          "radio",       $.widgetPlugin.inputWithType("radio"),                      ( o )->
    widget = new Radio o
    name = widget.get "name"
    if name?
        unless $.widgetPlugin.radiogroups? then $.widgetPlugin.radiogroups = {}
        groups = $.widgetPlugin.radiogroups

        unless groups[ name ]? then groups[ name ] = new RadioGroup
        group = groups[ name ]

        group.add widget

    widget
        
