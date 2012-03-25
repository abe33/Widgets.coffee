# The `Radio` widget is a kind of `CheckBox` that can
# be only set to true by the user.
#
# They're generaly used in combination with a `RadioGroup`.
class Radio extends CheckBox
  # Here some live instances:
  #
  #= require radio

  # The target for a `Radio` must be an input with the type `radio`.
  checkTarget: (target) ->
    unless @isInputWithType target, "radio"
      throw new Error "Radio target must be an input with a radio type"

  # The dummy for the radio is just a `<span>` element
  # with a `radio` class.
  createDummy: ->
    $ "<span class='radio'></span>"

  # Toggle is unidirectionnal. The only way to
  # uncheck a radio is by code.
  toggle: ->
    super() unless @get "checked"

@Radio = Radio
