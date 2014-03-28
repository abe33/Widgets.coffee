### checked_input

Decorates an input that support the `checked` property with a `checked`
class whenever its property is `true`. It allows to have css rules on checked
input on IE versions that doesn't support the `:checked` selector.

    widgets.define 'checked_input', (element) ->
      element.addEventListener 'change', ->
        widgets.toggle_class element, 'checked', element.checked

### bubbling_focus

This widgets decorates all the dom path until the current element with
a `focus` class when the element have the focus.

    widgets.define 'bubbling_focus', (element) ->
      blur = ->
        widgets.remove_class document.querySelectorAll('.focus'), 'focus'

      element.addEventListener 'blur', -> blur()
      element.addEventListener 'focus', ->
        blur()
        widgets.self_and_ancestors element, (el) ->
          widgets.add_class el, 'focus'
