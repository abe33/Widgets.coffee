# Here some live instances:
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <div id="livedemos-select"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var s =  "<select>"+
#        "<option>List Item 1</option>"+
#        "<option selected>List Item 2</option>"+
#        "<option>Long List Item 3</option>"+
#        "<option>Very Long List Item 4</option>"+
#        "<optgroup label='Group 1'>"+
#            "<option>List Item 5</option>"+
#            "<option>List Item 6</option>"+
#            "<option>Long List Item 7</option>"+
#        "</optgroup>"+
#        "<optgroup label='Group 2'>"+
#            "<option>List Item 8</option>"+
#            "<option>List Item 9</option>"+
#            "<option>Long List Item 10</option>"+
#        "</optgroup>"+
#     "</select>";
# 
# var select1 = new SingleSelect($(s)[0]);
# var select2 = new SingleSelect($(s)[0]);
# var select3 = new SingleSelect($(s)[0]);
# 
# select2.set("readonly", true);
# select3.set("disabled", true);
# 
# $("#livedemos-select").before(select1.dummy);
# $("#livedemos-select").before(select2.dummy);
# $("#livedemos-select").before(select3.dummy);
# </script>
class SingleSelect extends Widget
    # A `SingleSelect` accept a `select` node as target.
    constructor:( target )->
        super target

        # When a target is provided, the model for the `SingleSelect` object
        # is builded from the data of the target.
        if @hasTarget
            @model = @buildModel new MenuModel, @jTarget.children()
            
            # And the value is searched in the target structure to
            # find the current selection path.
            #
            # The selection path is an array of indices of the nodes
            # that lead to the value.
            @selectedPath = @findValue @get( "value" )
        else
            # Otherwise the `SingleSelect` is initialized with a new
            # model and a `null` selection path.
            @model = new MenuModel
            @selectedPath = null
        
        # Changes made to the model are listened by the `SingleSelect`.
        @model.contentChanged.add @modelChanged, this
        
        # The rest of the setup is then realized.
        @buildMenu()
        @hideTarget()        
        @updateDummy()

        #### Keyboard Commands

        # Pressing the `enter` or `space` keys when the widget has
        # the focus will open up the menu list and place the focus
        # on it to allow the keyboard navigation to follow in the 
        # menu list.
        @registerKeyDownCommand keystroke( keys.enter ), @openMenu 
        @registerKeyDownCommand keystroke( keys.space ), @openMenu 

        # Pressing the `up` or `down` keys when the widget has the 
        # focus will move the selection up or down accordingly.
        #
        # When moving the selection with the keyboard, the data 
        # structure appear to be flatten. The selection cursor 
        # automatically enters or leaves group to find the next 
        # value.
        @registerKeyDownCommand keystroke( keys.up ),    @moveSelectionUp 
        @registerKeyDownCommand keystroke( keys.down ),  @moveSelectionDown 
    
    #### Target Management

    # Only `select` nodes that doesn't have the `multiple` flag set
    # are allowed as target for a `SingleSelect`.
    checkTarget:( target )->
        if not @isTag( target, "select" ) or $( target ).attr("multiple")?
            throw "A SingleSelect only allow select nodes as target" 
    
    # Removes all the `option` nodes in the target.
    clearOptions:->
        @jTarget.children().remove() 
    
    # Build the content of the target based on the current model's data.
    buildOptions:( model = @model, target = @jTarget )->

        for act in model.items
            if act.menu?
                group = $ "<optgroup label='#{act.display}'></optgroup>"
                target.append group
                @buildOptions act.menu, group
            else 
                unless act.action? then act.action = => @set "value", act.value
                target.append $ "<option value='#{act.value}'>#{act.display}</option>"

    # Updates the state of the target accordingly with 
    # the current selection of the widget.
    updateOptionSelection:()->
        @getOptionAt( @selectedPath )?.attr "selected", "selected"
    
    # Returns the label to use for a given `option` or `optgroup` node.
    # If provided the `label` attribute will have the priority. If not
    # the node content will be used instead.  
    getOptionLabel:( option )->
        unless option? then return null
        if option.attr "label" then option.attr "label" else option.text()  
    
    # Returns the value to use for a given `option` node.
    # If provided the `value` attribute will have the priority. If not
    # the node content will be used instead.  
    getOptionValue:( option )->
        unless option? then return null
        if option.attr "value" then option.attr "value" else option.text() 
    
    # Returns the `option` or `optgroup` node at the specified `path`.
    # If the `path` argument is `null` or if the path lead to a dead end 
    # the function returns `null`
    getOptionAt:( path )-> 
        if path is null then return null

        option = null
        if @hasTarget 
            children = @jTarget.children()
            for step in path
                option = children[ step ]
                if option?.nodeName
                    children = $(option).children()
        
        if option? then $ option else null
    
    #### Dummy Management

    # The dummy for a `SingleSelect` is a span with the class `single-select`
    # and an internal span with the class `value`.
    createDummy:->
        $ "<span class='single-select'>
               <span class='value'></span>
           </span>"

    # The dummy's `value` span will receive the content of the
    # `display` property of the current selected item.
    updateDummy:->
        # Assuming the selection path is valid.
        unless @selectedPath is null
            display = @getItemAt( @selectedPath )?.display
        else
            # Otherwise the display will either be the `title` attribute
            # of the target, if defined, or the string `Empty`.
            display = if @hasTarget and @jTarget.attr("title") then @jTarget.attr("title") else "Empty"
        
        # After removing the old value, the `display` value is passed
        # as the content for the new `value` span. That's imply that 
        # the display for an item could contains any valid HTML code. 
        @dummy.find(".value").remove()
        @dummy.append $ "<span class='value'>#{display}</span>"
    
    #### Model Management

    # The `buildModel` automtically construct a `MenuModel` 
    # corresponding to the current target.
    #
    # `optgroup` nodes are handled as sub-models when `option`
    # nodes are actually the models's items and receive an action
    # that select their value on the `SingleSelect` widget.
    # 
    # By contrast with the native select widget, the nested
    # options groups are preserved in the data structure. Each
    # `optgroup` will appear as a submenu in a `MenuList` and
    # will open a new `MenuList` with the data of the `optgroup`.
    buildModel:( model, node )->
        node.each ( i, o )=>
            option = $ o
            if o.nodeName.toLowerCase() is "optgroup"
                # Sub-models are represented by an object that
                # have a `menu` property that contains a `MenuModel`
                # instance.
                model.add {
                    display:@getOptionLabel( option ), 
                    # Nodes traversing is done recursively.
                    menu:@buildModel( new MenuModel, option.children() )
                }
            else
                # Model's items are represented by an object that
                # have both a `value` and an `action` property.
                value = @getOptionValue( option )
                model.add {
                    display:@getOptionLabel( option ), 
                    value:value,
                    action:=> @set "value", value
                }
        model
        
    # Returns the item at `path` in the model.
    # If the `path` argument is `null` or if the 
    # path lead to a dead end, the function returns
    # `null`.
    getItemAt:( path )->
        if path is null then return null
        
        model = @model
        item = null
        for step in path
            item = model.items[ step ]
            unless item? then return null

            if item?.menu?
                model = item.menu
        
        item
    
    # Returns the path to the specified value.
    #
    # The `model` argument is optionnal and allow
    # to use the `findValue` method recursively.
    findValue:( value, model = @model )->
        # If the value is `null` or if it's an empty string
        # the function returns `null`.
        if not value? or value is "" then return null

        # The search result for the pass are stored in an array.
        passResults = null
        for item in model.items
            # If an item's value of the current value is the searched
            # value, the index of this item in the current model is
            # set as the pass result.
            if item.value is value
                passResults = [ _i ]
                break
            # If the item is a sub-model, a sub-pass is processed.
            else if item.menu?
                subPassResults = @findValue value, item.menu
                # If the sub-pass returns a result, the sub-model
                # index is added to the pass result with the result
                # of the sub-pass.
                if subPassResults?
                    passResults = [ _i ].concat subPassResults
                    break
        
        passResults

    # Returns the last model that contains the item at `path`. 
    # If the `path` argument is `null` or if the path lead 
    # to a dead end, the function returns `null`.
    getModelAt:( path )->
        if path is null then return null
        
        model = @model
        item = null
        for step in path
            item = model.items[ step ]
            unless item? then return null
            if item?.menu?
                model = item.menu
        
        model
    
    #### Menu Management
    
    # Creates a `MenuList` instance for this `SingleSelect`.
    # The same model is shared between a `SingleSelect` and
    # its `MenuList`.
    buildMenu:->
        @menuList = new MenuList @model
    
    # Opens the `MenuList` for this instance.
    openMenu:->
        unless @cantInteract()
            # Pressing the mouse on the document when the `MenuList` is
            # opened will close the menu.
            ( $ document ).bind "mousedown", @documentDelegate = (e)=>
                @documentMouseDown e
            
            # The `MenuList` dummy is placed right after the `SingleSelect`
            # in the DOM.
            @dummy.after @menuList.dummy

            # The `MenuList` is displayed right below the `SingleSelect`
            # on screen.
            left = @dummy.offset().left
            top = @dummy.offset().top + @dummy.height()
            @menuList.dummy.attr "style", "left: #{left}px; top: #{top}px;"

            # The focus is then placed on the `MenuList`.
            @menuList.grabFocus()

            # When opening the `MenuList`, the selection path is highlighted.
            # If the selection is contained in a sub-model, the sub-menus will
            # be opened as well. 
            unless @selectedPath is null 
                list = @menuList
                for step in @selectedPath
                    list.select step
                    if list.childList
                        list = list.childList
    
    # Closes the `MenuList` for this instance.
    closeMenu:->
        @menuList.close()
        # When the `MenuList` is closed, the `SingleSelect` 
        # recover the focus.
        @grabFocus()

        $( document ).unbind "mousedown", @documentDelegate
    
    # Returns `true` is the `MenuList` is currently present in the DOM.
    isMenuVisible:->
        @menuList.dummy.parent().length is 1
         
    #### Selection Management
    
    # Moves the selection cursor to the up.
    moveSelectionUp:(e)->
        e.preventDefault()

        unless @cantInteract()
            @selectedPath = @findPrevious @selectedPath
            
            @set "value", @getOptionValue @getOptionAt @selectedPath
    
    # Moves the selection cursor to the down.
    moveSelectionDown:(e)->
        e.preventDefault()

        unless @cantInteract()
            @selectedPath = @findNext @selectedPath
            
            @set "value", @getOptionValue @getOptionAt @selectedPath

    # Finds the next selectionable item in the model.
    #
    # When the next item is a sub-model, the search continue
    # in the sub-model. In the same way, when there's no longer
    # an item in the current sub-model, the search continue one
    # level higher after the sub-model.
    # 
    # If there's no longer any element after the current path, 
    # the search restart from the top.
    findNext:( path )->
        model = @getModelAt path
        step = path.length - 1
        newPath = path.concat()
        newPath[ step ]++

        nextItem = @getItemAt newPath

        while not nextItem? or nextItem.menu?
            if nextItem? 
                if nextItem.menu? 
                    newPath.push 0
                    step++
            else if step > 0
                step--
                newPath.pop()
                newPath[ step ]++
                nextItem = @getItemAt newPath
            else
                newPath = [ 0 ]
            
            nextItem = @getItemAt newPath

        newPath

    # Finds the previous selectionable item in the model.
    #
    # When the previous item is a sub-model, the search continue
    # in the sub-model. In the same way, when there's no longer
    # an item in the current sub-model, the search continue one
    # level higher before the sub-model.
    # 
    # If there's no longer any element before the current path, 
    # the search restart from the bottom.
    findPrevious:( path )->
        model = @getModelAt path
        step = path.length - 1
        newPath = path.concat()
        newPath[ step ]--

        previousItem = @getItemAt newPath

        while not previousItem? or previousItem.menu?
            if previousItem? 
                if previousItem.menu? 
                    newPath.push 0
                    step++
                    newPath[ step ] = @getModelAt( newPath ).size() - 1
            else if step > 0
                step--
                newPath.pop()
                newPath[ step ]--
                previousItem = @getItemAt newPath
            else
                newPath = [ @model.items.length - 1 ]
            
            previousItem = @getItemAt newPath

        newPath
            
    #### Properties Accessors    

    # The only legible values for a `SingleSelect`
    # are those are stored in its model. 
    set_value:( property, value )->
        # In case the new value can't be found in the model, the
        # widget's value will remain unchanged.
        oldValue = @get "value"
        newValue = null
        # The path to the value is searched in the model. 
        newPath = @findValue value

        # If the path is not null, then the value is legible, 
        # and the selection path is updated.
        if newPath isnt null 
            @selectedPath = newPath   
            newValue = value
        
        # The target is updated if set.
        if @hasTarget then @updateOptionSelection()

        @updateDummy()

        # Setting the value automatically close the 
        # `MenuList` of this instance.
        if @isMenuVisible()
            @closeMenu()
        
        # Returns the new value if legible, otherwise the
        # function returns the original value. 
        if newValue? isnt null then @properties[ property ] = newValue else oldValue 

    #### Signal Listeners

    # Catch all changes made to the model.
    modelChanged:( model )->
        # In the case the previous value can't be found anymore
        # in the model, the selection is reset to the first selectable
        # item in the model.
        unless @getItemAt( @selectedPath )?
            @selectedPath = @findNext [ 0 ]
            @properties[ "value" ] = @getItemAt( @selectedPath ).value
        
        # If a target is defined, the target's content is rebuilded
        # from the model.
        if @hasTarget
            @clearOptions()
            @buildOptions()
            @updateOptionSelection()
    
    #### Event Listeners

    # Pressing the mouse over a `SingleSelect` open or close the
    # `MenuList` of the instance according to its current state.
    mousedown:( e )->
        unless @cantInteract()
            # Prevent the default behavior on the `SingleSelect` `mousedown` event
            # to allow the `menuList` to trigger a `mouseup` event in the movement.
            e.preventDefault()

            # Prevent the document to catch the `mousedown` event when the mouse is
            # pressed over the `SingleSelect`.
            e.stopImmediatePropagation()

            if @isMenuVisible()
                @closeMenu()
            else
                @openMenu()
    
    # Pressing the mouse over the document will close the menu.
    #
    # There's no need to test the position of the mouse since
    # both the `SingleSelect` and its `MenuList` stop the propagation
    # of the event and prevents the document to catch it.
    documentMouseDown:( e )->
        @closeMenu()

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.SingleSelect = SingleSelect