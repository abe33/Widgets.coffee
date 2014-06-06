# Public: Decorates an input that support the `checked` property with
# a `checked` class whenever its property is `true`. It allows to have
# css rules on checked input on IE versions that doesn't support
# the `:checked` selector.
widgets.define 'checked_input', (element) ->
  element.addEventListener 'change', ->
      $(element).toggleClass('checked', element.checked)

# Public: This widgets decorates all the dom path until the current
# element with a `focus` class when the element have the focus.
widgets.define 'bubbling_focus', (element) ->
  blur = -> $('.focus').removeClass('focus')

  $element = $(element)
  $element.on 'blur', -> blur()
  $element.on 'focus', ->
    blur()
    $element.parents().addClass('focus')
