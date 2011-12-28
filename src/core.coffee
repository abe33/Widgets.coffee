# <link rel="stylesheet" href="../css/styles.css" media="screen">
$.fn.extend 
    # Inputs in a page can be automatically replaced by widgets
    # with the `widgets` function. A typical usecase is to add 
    # the following in the `document.ready` handler.
    #
    #     $("input").widgets()  
    widgets:( options = {} )->

        # `Radio` with the same name are considered as part of a group.
        # `RadioGroup` instances are stored in a map with the name as key. 
        groups = {}

        ( $ this ).each ( i, o )->
            nodeName = o.nodeName.toLowerCase()
            target  = $ o
            next   = target.next()
            parent = target.parent()

            # The input that have already been proceed are flagged 
            # with a `widget-done` class.
            unless target.hasClass "widget-done"
                
                # First, a switch is performed on the node name to handle `textarea` 
                # and later the `select` node as well.
                switch nodeName
                    when "textarea" then widget = new TextArea o
                    
                    # In case of an input, another switch will be performed on the type.
                    when "input"
                        type   = target.attr "type"
                                                
                        # Some widgets require additional setup so instanciation
                        # is made type by type. 
                        switch type
                            when "checkbox"                     then widget = new CheckBox    o 
                            when "number"                       then widget = new Stepper     o 
                            when "color"                        then widget = new ColorPicker o 
                            when "file"                         then widget = new FilePicker  o 
                            when "text", "password"             then widget = new TextInput   o
                            when "button", "reset", "submit"    then widget = new Button      o 
                            when "range"    
                                widget = new Slider o 
                                widget.valueCenteredOnKnob = true
                                widget.updateDummy widget.get("value"), widget.get("min"), widget.get("max")
                            when "radio"    
                                widget = new Radio o 
                                name = widget.get "name"
                                
                                if name?
                                    if name of groups
                                        group = groups[ name ]
                                    else
                                        group = new RadioGroup
                                        groups[ name ] = group
                            
                                    group.add widget

            # Widgets are placed in the DOM immediatly after
            # their target, and since the target could have been
            # moved in the DOM, the next sibling is used.
            if widget?
                if next.length > 0
                    next.before widget.dummy
                # And the parent is used as fallback if the target
                # was the last node in the parent.
                else 
                    parent.append widget.dummy
