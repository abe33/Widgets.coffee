# Public: This widgets decorates all the dom path until the current
# element with a `focus` class when the element have the focus.
widgets.define 'bubbling_focus', (element) ->
  blur = -> $('.focus').removeClass('focus')

  $element = $(element)
  $element.on 'blur', -> blur()
  $element.on 'focus', ->
    blur()
    $element.parents().addClass('focus')
