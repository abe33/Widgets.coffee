# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# A `Container` is a base widget that allow to add other widgets 
# as children. 
class Container extends Widget

    constructor:( target )->
        super target
         
        # Children widgets are stored in an array in the 
        # `children` property.
        @children = []
    
    #### Children management
    
    # Use the `add` method to add child to this container.
    add:( child )->
        # Only widgets that are not already a child are allowed.
        if child? and child.isWidget and child not in @children
            @children.push child

            # When a child widget is added to a `container`, its dummy is appended
            # to the container's dummy.
            child.attach @dummy

            # Widgets can acces their parent through the `parent` property.
            child.parent = this
    
    # Use the `remove` method to remove a child from this container.
    remove:( child )->
        # Only widgets that are already a children of this container
        # can be removed.
        if child? and child in @children 
            @children.splice @children.indexOf( child ), 1

            # The child's dummy is then detached from the container's dummy.
            child.detach()


            # The children no longer hold a reference to its previous
            # parent at the end of the call.
            child.parent = null

    # The dummy for a `Container` is a single `span` with
    # a `container` class on it.
    createDummy:->
        $ "<span class='container'></span>"
        
    focus:(e)->
        if e.target is @dummy[0]
            super e
    

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.Container = Container 

