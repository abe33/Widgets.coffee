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

