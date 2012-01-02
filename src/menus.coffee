# Here some live instances:
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <div id="livedemos-menus"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../widgets.js'></script>
#
# <script type='text/javascript'>
# var item1 = { display:"display1", action:function(){ console.log ("item 1 clicked"); } };
# var item2 = { display:"display2", action:function(){ console.log ("item 2 clicked"); } };
# var item3 = { display:"display3", menu:new MenuModel() };
# var item4 = { display:"display4", action:function(){ console.log ("item 4 clicked"); } };
# var item5 = { display:"display5", action:function(){ console.log ("item 5 clicked"); } };
# var item6 = { display:"display6", menu:new MenuModel() };
# var item7 = { display:"display7", action:function(){ console.log ("item 7 clicked"); } };
# var item8 = { display:"display8", action:function(){ console.log ("item 8 clicked"); } };
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
class MenuModel 
    constructor:( items... )->
        @contentChanged = new Signal

        @items = @filterValidActions items
    
    add:( items... )->
        @items = @items.concat @filterValidActions items
        @contentChanged.dispatch this
    
    remove:( items... )->
        @items = ( action for action in @items when action not in items )
        @contentChanged.dispatch this

    size:-> 
        @items.length

    filterValidActions:( items )-> 
        action for action in items when @isValidAction action

    isValidAction:( action )->
        action? and
        action.display? and 
        ( not action.action? or $.isFunction action.action )

class MenuList extends Widget
    constructor:( model )->
        super()

        @selectedIndex = -1

        @createProperty "model"
        @set "model", model      

        @parentList = null
        @childList = null

        @registerKeyDownCommand keystroke( keys.enter ), @triggerAction 
        @registerKeyDownCommand keystroke( keys.space ), @triggerAction
        @registerKeyDownCommand keystroke( keys.up ),    @moveSelectionUp 
        @registerKeyDownCommand keystroke( keys.down ),  @moveSelectionDown 
        @registerKeyDownCommand keystroke( keys.right ), @moveSelectionRight 
        @registerKeyDownCommand keystroke( keys.left ),  @moveSelectionLeft 

    set_model:( property, value )->
        @clearList()

        @properties[ property ]?.contentChanged.remove @modelChanged, this
        value?.contentChanged.add @modelChanged, this

        @buildList value
        value
    
    close:->
        @dummy.blur()
        @dummy.detach()
        @childList?.close()
    
    select:( index )->
        if @selectedIndex isnt -1 then @getItemAt( @selectedIndex ).removeClass "selected"

        @selectedIndex = index

        if @selectedIndex isnt -1 
            item = @getItemAt( @selectedIndex )
            item.addClass "selected"
            act = @get("model").items[ index ]

            if act.menu?
                @openChildList act.menu, item 
            else if @isChildListVisible()
                @closeChildList()
        
        unless @hasFocus then @grabFocus()
    
    createDummy:->
        $ "<ul class='menulist'></ul>"
    
    clearList:->
        @dummy.children().remove()
    
    buildList:( model )->
        for act in model.items
            if act.menu?
                item = $ "<li class='menu'>#{act.display}</li>"
            else
                item = $ "<li class='menuitem'>#{act.display}</li>"
            @dummy.append item
        
        @dummy.children().each ( i, o )=>
            item = $ o
            a = model.items[ i ]
            item.mouseup (e)=> unless @cantInteract() then if a.action? then a.action()
            item.mouseover (e)=> unless @cantInteract() then @select i
    
    isChildListVisible:->
        @childList?.dummy.parent().length is 1
    
    closeChildList:->
        @childList?.close()
        @grabFocus()
    
    mousedown:(e)->
        e.stopImmediatePropagation()

    openChildList:( model, item )->
        unless @childList? 
            @childList = new MenuList new MenuModel
            @childList.parentList = this
        
        if @childList.hasFocus then @childList.dummy.blur()

        unless @isChildListVisible() then @dummy.after @childList.dummy
        unless @childList.get("model") is model then @childList.set "model", model

        left = @dummy.offset().left + @dummy.width()
        top = item.offset().top

        @childList.dummy.attr "style", "left: #{left}px; top: #{top}px;"
    
    triggerAction:->
        if @selectedIndex isnt -1 
            item = @get("model").items[ @selectedIndex ]
            if item.action? then item.action()

    getItemAt:( index )->
        $ @dummy.children( "li" )[ index ]

    modelChanged:( model )->
        @clearList()
        @buildList model
    
    moveSelectionUp:(e)->
        e.preventDefault()
        
        unless @cantInteract()
            newIndex = @selectedIndex - 1
            if newIndex < 0 then newIndex = @get("model").size() - 1 
            @select newIndex
    
    moveSelectionDown:(e)->
        e.preventDefault()

        unless @cantInteract()
            newIndex = @selectedIndex + 1
            if newIndex >= @get("model").size() then newIndex = 0
            @select newIndex

    moveSelectionRight:(e)->
        e.preventDefault()

        unless @cantInteract()
            if @isChildListVisible then @childList.grabFocus()
        
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
