# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# A `Container` is a base widget that allow to add other widgets
# as children.
class Container extends Widget

    @mixins HasChild

    # The dummy for a `Container` is a single `span` with
    # a `container` class on it.
    createDummy:->
        $ "<span class='container'></span>"

@Container = Container

