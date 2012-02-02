# This file contains the classes related to the management of menus.
# Menus can be used in various widgets, such as selects. 
#
# Classes defined in this file : 
# 
# * [MenuModel](#menumodel)
# * [MenuList](#menulist)

# <a name='menumodel'></a>
## MenuModel
#
# The `MenuModel` class manages a collection of items.
#
# Items are, in their simplest form, an object with 
# a `display` property. Such as :
#
#     item = display:"Item Label"
#
# The content of the `display` property could contains
# HTML code. For exemple :
#
#     item = display:"<em>Item Label</em>"
#
# Additionnally the item can have an `action` property 
# containing a function. Such as : 
#
#     item = display:"Item Label", action:->
#         ...
# 
# In that case they are *action items*.
#
# Alternatively, an item can have a `menu` property, 
# containing a `MenuModel` instance, and allowing to
# create nested models. For instance : 
#
#     item = display:"Item Label"
#     menu = display:"Nested Menu", menu:new MenuModel item
#
# In that case they are *menu items*.
class MenuModel 
    # The constructor can receive any number of items as arguments.
    constructor:( items... )->
        #### MenuModel Signals
        
        # The `contentChanged` signal is dispatched when the content
        # of the model was modified through the `add` or `remove` functions.
        #
        # *Callback arguments*
        #
        #  * `model`    : The model that was modified.
        @contentChanged = new Signal

        # The initial list of items passed to the constructor 
        # is filtered. Only valid instances will be preserved
        # in the final array. 
        @items = @filterValidItems items
    
    # Adds many items to the model and dispatch a `contentChanged` signal.
    add:( items... )->
        @items = @items.concat @filterValidItems items
        @contentChanged.dispatch this
    
    # Removes many items from the model and dispatch a `contentChanged` signal.
    remove:( items... )->
        @items = ( item for item in @items when item not in items )
        @contentChanged.dispatch this
    
    # Returns the number of elements in the model.
    size:-> 
        @items.length

    # Takes an array of objects and return an array that contains only
    # the objects that match the criteria for an item.
    filterValidItems:( items )-> 
        item for item in items when @isValidItem item
    
    # Returns `true` if the passed-in item is valid.
    isValidItem:( item )->
        item? and
        # The display property is mandatory.
        item.display? and 
        ( not item.action? or $.isFunction item.action ) and
        ( not item.menu? or item.menu instanceof MenuModel )

# <a name='menulist'></a>
## MenuList

# A `MenuList` is used to render and manipulate a `MenuModel`.
#
# Here some live instances:
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <div id="livedemos-menus"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var item1 = { display:"Item 1", action:function(){ console.log ("item 1 clicked"); } };
# var item2 = { display:"Item 2", action:function(){ console.log ("item 2 clicked"); } };
# var item3 = { display:"<em>Group 1</em>", menu:new MenuModel() };
# var item4 = { display:"Item 3", action:function(){ console.log ("item 3 clicked"); } };
# var item5 = { display:"Item 4", action:function(){ console.log ("item 5 clicked"); } };
# var item6 = { display:"<em>Group 2</em>", menu:new MenuModel() };
# var item7 = { display:"Item 5", action:function(){ console.log ("item 6 clicked"); } };
# var item8 = { display:"Item 6", action:function(){ console.log ("item 6 clicked"); } };
# 
# item3.menu.add ( item4, item5, item6 );
# item6.menu.add ( item7, item8 );
# 
# var model = new MenuModel ( item1, item2, item3 );
# var list1 = new MenuList ( model );
# var list2 = new MenuList ( model );
# var list3 = new MenuList ( model );
# 
# list2.set( "readonly", true );
# list3.set( "disabled", true );
# 
# list1.addClasses ( "dummy" );
# list2.addClasses ( "dummy" );
# list3.addClasses ( "dummy" );
# 
# $("#livedemos-menus").before ( list1.dummy );
# $("#livedemos-menus").before ( list2.dummy );
# $("#livedemos-menus").before ( list3.dummy );
# </script>
class MenuList extends Widget
    # The `MenuList` class constructor takes a `MenuModel`
    # instance as argument. 
    constructor:( model = new MenuModel )->
        super()

        # Initially, no item is selected in the list.
        @selectedIndex = -1

        # The model is stored in its own property.
        @createProperty "model"
        @set "model", model      

        # A `MenuList` keep reference to both its parent
        # and its child list.
        @parentList = null
        @childList = null

        #### Keyboard Commands

        # Pressing the `enter` or `space` keys when the `MenuList`
        # has the focus will trigger the action on the selected item.
        @registerKeyDownCommand keystroke( keys.enter ), @triggerAction 
        @registerKeyDownCommand keystroke( keys.space ), @triggerAction

        # Pressing the `up` or `down` keys  when the `MenuList`
        # has the focus will move the selection up or down in the list.
        @registerKeyDownCommand keystroke( keys.up ),    @moveSelectionUp 
        @registerKeyDownCommand keystroke( keys.down ),  @moveSelectionDown 

        # Pressing the `right` key when the selected item is a *menu item*
        # will move the focus to the child list.
        @registerKeyDownCommand keystroke( keys.right ), @moveSelectionRight 

        # Pressing the `left` key when the current list has a parent list
        # will move back the focus to the parent.
        @registerKeyDownCommand keystroke( keys.left ),  @moveSelectionLeft 
     
    #### Selection Management
        
    # Selects the item at `index` in the list's model. 
    select:( index )->
        # If there was a previous selection, the list item that was selected
        # see its `selected` class removed. 
        if @selectedIndex isnt -1 then @getListItemAt( @selectedIndex ).removeClass "selected"

        @selectedIndex = if index < @get("model").size() then index else -1

        if @selectedIndex isnt -1 
            # The new selected item is then flagged as selected
            # in the dummy.
            li = @getListItemAt( @selectedIndex )
            li.addClass "selected"
            item = @get("model").items[ index ]

            # And if this item is a *menu item*,
            # the child list is opened with the data
            # of the item.
            if item.menu?
                @openChildList item.menu, li 
            # Otherwise, the child list is closed 
            # if it was previously opened.
            else if @isChildListVisible()
                @closeChildList()
        
        # Once a selection have been done on the `MenuList`
        # the widget grab the focus.
        unless @hasFocus then @grabFocus()
        
    # Triggers the action at the selected index when the 
    # selected index is different of `-1`.  
    triggerAction:->
        if @selectedIndex isnt -1 
            item = @get("model").items[ @selectedIndex ]
            if item.action? then item.action()   
    
    #### Dummy Management

    # The dummy for a `MenuList` is an unordered list
    # with the class `menulist`.
    createDummy:->
        $ "<ul class='menulist'></ul>"
    
    # Creates the list items of the dummy.
    buildList:( model )->
        for item in model.items
            # Both *menu items* and *action items* are
            # display as `li` nodes within the dummy.
            if item.menu?
                # Menus receive the `menu` class.
                li = $ "<li class='menu'>#{item.display}</li>"
            else
                # Actions receive the `menuitem` class.
                li = $ "<li class='menuitem'>#{item.display}</li>"
            @dummy.append li
        
        @dummy.children().each ( i, o )=>
            _li = $ o
            _item = model.items[ i ]
            # Each list item trigger the item action on `mouseup`, and select the item 
            # on a `mouseover`. 
            _li.mouseup   (e)=> unless @cantInteract() then if _item.action? then _item.action()
            _li.mouseover (e)=> unless @cantInteract() then @select i
    
    # Removes all the list item in the dummy.
    clearList:->
        @dummy.children().remove()
    
    # A `MenuList` can be removed from the DOM by using the `close` method.
    # The widget no longer has the focus at the end of the call.
    #
    # If the `MenuList` has a child list the child list is closed as well.
    close:->
        @dummy.blur()
        @dummy.detach()
        @childList?.close()
    
    # Returns the list item at `index` in the dummy.
    getListItemAt:( index )->
        $ @dummy.children( "li" )[ index ]
    
    
    #### Child List Management 
    
    # Opens the child list for the specified model and list item.
    openChildList:( model, li )->
        # The `MenuList` instance is created lazily.
        unless @childList? 
            @childList = new MenuList new MenuModel
            @childList.parentList = this
        
        if @childList.hasFocus then @childList.dummy.blur()

        unless @isChildListVisible() then @dummy.after @childList.dummy
        unless @childList.get("model") is model then @childList.set "model", model

        # The child `MenuList` is placed next to the `li` that requested it.
        left = @dummy.offset().left + @dummy.width()
        top = li.offset().top

        @childList.dummy.attr "style", "left: #{left}px; top: #{top}px;"
    
    # Closes the child list and return the focus to the current list.
    closeChildList:->
        @childList?.close()
        @grabFocus()
    
    # Returns `true` if the child list 
    isChildListVisible:->
        @childList?.dummy.parent().length is 1
    
    #### Properties Accessors

    # When changing the model instance, the content of the dummy is rebuilded
    # with the new model data. 
    set_model:( property, value )->
        @clearList()

        @properties[ property ]?.contentChanged.remove @modelChanged, this
        value?.contentChanged.add @modelChanged, this

        @buildList value
        @properties[ property ] = value
    
    #### Events Handler

    # `mousedown` prevents the propagation of the event to the document.
    # in that way, listening to the document `mousedown` allow to detect
    # when the mouse is pressed outside of a `MenuList`.
    mousedown:(e)->
        e.stopImmediatePropagation()

    #### Signals Listeners

    # The dummy content is recreated when the current model is modified.
    modelChanged:( model )->
        @clearList()
        @buildList model
    
    #### Keyboard Commands

    # Moves the selection to the up.
    moveSelectionUp:(e)->
        e.preventDefault()
        
        unless @cantInteract()
            newIndex = @selectedIndex - 1
            if newIndex < 0 then newIndex = @get("model").size() - 1 
            @select newIndex
    
    # Moves the selection to the down.
    moveSelectionDown:(e)->
        e.preventDefault()

        unless @cantInteract()
            newIndex = @selectedIndex + 1
            if newIndex >= @get("model").size() then newIndex = 0
            @select newIndex

    # If the child list is visible, the focus is passed to the child list.
    moveSelectionRight:(e)->
        e.preventDefault()

        unless @cantInteract()
            if @isChildListVisible then @childList.grabFocus()
    
    # If the list has a parent list, the focus is passed to the parent list. 
    moveSelectionLeft:(e)->
        e.preventDefault()

        unless @cantInteract()
            @dummy.blur()
            @parentList?.grabFocus()

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.MenuModel = MenuModel
    window.MenuList = MenuList
