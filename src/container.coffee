# A `Container` is a base widget that allow to add other widgets
# as children.
class Container extends Widget

  @mixins HasChildren

  # The dummy for a `Container` is a single `span` with
  # a `container` class on it.
  createDummy: ->
    $("<span class='container'></span>")

@Container = Container

