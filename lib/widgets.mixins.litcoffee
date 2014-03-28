### Activable

The `Activable` mixin provides the basic interface for an activable widget.
You can hook your own activation/deactivation routines by overriding the
`on_activate` and `on_deactivate` methods.

    class widgets.Activable
      active: false

      activate: ->
        @active = true
        @on_activate?()

      deactivate: ->
        @active = false
        @on_deactivate?()


### Disposable

The `Disposable` mixin provides the basic interface of a disposable widget.
You can hook on the widget dispose by overriding the `on_dispose` method.

    class widgets.Disposable
      dispose: ->
        @on_dispose?()
        delete @element
        delete @options

### HasElements



    class widgets.HasElements
      @has_elements: (singular, plural) ->
        @[plural] = []


