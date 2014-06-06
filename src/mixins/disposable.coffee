
# Public: The `Disposable` mixin provides the basic interface of a
# disposable widget. You can hook on the widget dispose by overriding
# the `on_dispose` method.
class widgets.Disposable
  dispose: ->
    @on_dispose?()
    delete @element
    delete @options
